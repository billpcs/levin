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
		id: file_name
	}

	path := '${posts_path}${file_name}'

	mut str_data := ''

	str_data += post.header()

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

	// the file name becomes the id
	// to ensure uniqueness
	id := os.file_name(path)

	// metadata is ONLY on the first line as JSON
	metadata := if content.len >= 1 {
		json.decode(Post, content[0])!
	}
	else {
		return error('no metadata found')
	}


	// the rest is the post
	post_text := content[1..].join('\n')

	return Post{
		title: metadata.title
		time: metadata.time
		tags: metadata.tags
		id: id
		text: post_text
	}
}
