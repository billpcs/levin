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
	file_name := title.to_lower().replace(" ", "-")

	post := Post{
		title: title
		time: timeval
		url: file_name
	}

	path := '${posts_path}${file_name}'

	mut str_data := ""

	str_data += post.header()
	str_data += "\n\n"

	for line in contents {
		str_data += line 
	}

	os.write_file(path, str_data) or { println('failed to write post header') }

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

	// first line must always be the metadata
	metadata := json.decode(Post, content[0])!

	mut post_text := []string{}
	for line in content[1..].filter(it != '') {
		post_text << line
	}

	post_chunked_text := parse_post_text(post_text)

	return Post{
		title: metadata.title
		time: metadata.time
		url: url
		text: post_chunked_text
	}
}