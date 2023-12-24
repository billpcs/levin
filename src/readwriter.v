import os
import json
import time

fn get_posts() []Post {
	dir := (os.ls('${posts_path}') or { [] }).map('${posts_path}${it}')
	posts := dir.filter(os.is_file(it)).map(read_post(it) or { Post{} })
	return sort_by_date(posts)
}

fn write_post(title string, contents ...string) {
	timeval := time.now().str()
	file_name := title.to_lower().replace(' ', '-')

	post := Post{
		title: title
		time: timeval
		url: file_name
	}

	path := '${posts_path}${file_name}'

	mut str_data := ''

	str_data += post.header()
	str_data += '\n---\n\n'

	for line in contents {
		str_data += line
	}

	os.write_file(path, str_data) or { println('failed to write post') }

	println("created new post '${title}'")
}

fn compare_porst_dates(a &Post, b &Post) int {
	if a.time < b.time {
		return 1
	} else if a.time > b.time {
		return -1
	} else {
		return 0
	}
}

fn sort_by_date(posts []Post) []Post {
	mut posts_copy := posts.clone()
	posts_copy.sort_with_compare(compare_porst_dates)
	return posts_copy
}

fn read_post(path string) !Post {
	content := os.read_lines(path)!

	// the file name becomes the url
	// to ensure uniqueness
	url := os.file_name(path)

	/*
		read until the first '---' which
		seperates medatata and post contenets
	*/
	mut metadata_str := ''
	mut metadata_end_idx := 0
	for i := 0; i < content.len; i += 1 {
		if content[i].starts_with('---') {
			metadata_end_idx = i
			break
		}
		metadata_str += content[i]
	}

	metadata := json.decode(Post, metadata_str)!

	post_text := content[metadata_end_idx + 1..].filter(it != '')

	post_chunked_text := parse_post_text(post_text)

	return Post{
		title: metadata.title
		time: metadata.time
		tags: metadata.tags
		url: url
		text: post_chunked_text
	}
}
