module main

import os
import vweb
import crypto.md5
import time
import json
import cli

const (
	port       = 8082
	app_name   = 'levin'
	posts_path = './posts/'
)

struct App {
	vweb.Context
mut:
	posts    shared []Post
	commands cli.Command
}

struct Post {
mut:
	title string
	time  string
	text  []Chunk
	url   string
}

type Chunk = Header | HHeader | HHHeader | Text | Code | Highlight

struct Code {
	lang string
	text string
}

struct Highlight {
	lang string
	text string
}

struct Text {
	lang string
	text string
}

struct Header {
	lang string
	text string
}

struct HHeader {
	text string
	lang string
}

struct HHHeader {
	text string
	lang string
}

pub fn (c Chunk) is_code() bool {
	return match c {
		Code {true}
		else {false}
	}
}

pub fn (c Chunk) is_highlight() bool {
	return match c {
		Highlight {true}
		else {false}
	}
}

pub fn (c Chunk) is_text() bool {
	return match c {
		Text {true}
		else {false}
	}
}

pub fn (c Chunk) is_h() bool {
	return match c {
		Header {true}
		else {false}
	}
}

pub fn (c Chunk) is_hh() bool {
	return match c {
		HHeader {true}
		else {false}
	}
}

pub fn (c Chunk) is_hhh() bool {
	return match c {
		HHHeader {true}
		else {false}
	}
}




fn url(title string) string {
	// eight digits of the hash should be enough
	return md5.hexhash(title)[0..8]
}

fn (p Post) header() string {
	return "{ \"title\": \"${p.title}\", \"time\": \"${p.time}\" }"
}

fn (p Post) json() string {
	return json.encode(p)
}

fn (p Post) to_string() string {
	return "${p.url} @ [${p.time}] - \"${p.title}\""
}

fn parse_post_text(text []string) []Chunk {
	mut line := ""
	mut chunked := []Chunk{}
	for i := 0; i < text.len; i += 1 {
		line = text[i]
		if is_h(line) {
			chunked << Header {
				text: line
				lang: "text"
			}
		}
		else if is_hh(line) {
			chunked << HHeader {
				text: line
				lang: "text"
			}
		}
		else if is_hhh(line) {
			chunked << HHHeader {
				text: line
				lang: "text"
			}
		}
		else if is_highlight(line) {
			chunked << Highlight {
				text: line
				lang: "text"
			}
		}
		// format is
		// @# language-*
		// ...
		// @# end
		else if line.starts_with("@#") {
			lang_start := line.split(" ")
			if lang_start.len > 1 {
				if lang_start[1].starts_with("language-") {
					i += 1
					lang := lang_start[1]
					mut code_str := "" 
					for ! text[i].starts_with("@# end") {
						code_str += "${text[i]}\n"
						i += 1
					}
					chunked << Code {
						lang: lang
						text: code_str
					}
				}
			}
		}
		else {
			chunked << Text {
				text: line
				lang: "text"
			}
		}
	}

	return chunked
}

fn read_post(path string) !Post {
	content := os.read_lines(path)!

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
		text: post_chunked_text
		url: url(metadata.title)
	}
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

fn get_posts() []Post {
	dir := (os.ls('${posts_path}') or { [] }).map('${posts_path}${it}')
	posts := dir.filter(os.is_file(it)).map(read_post(it) or { Post{} })
	return sort_by_date(posts)
}

fn (mut app App) find_post_by_name(url string) !Post {
	rlock app.posts {
		for post in app.posts {
			if url == post.url {
				return post
			}
		}
	}
	return error('could not find this post')
}

fn write_post(title string, contents []string) {
	timeval := time.now().str()

	post := Post{
		title: title.to_lower()
		time: timeval
		url: url(title)
	}

	path := '${posts_path}${post.title}'

	os.write_file(path, post.header()) or { println('failed to write post header') }

	for paragraph in contents {
		os.write_file(path, paragraph) or { println('failed to write a paragraph') }
	}

	println("created new post '${title}'")
}

fn is_highlight(line string) bool {
	l := line.split(' ')[0].trim_space()
	return l.starts_with('>')
}

fn is_code()

fn is_hhh(line string) bool {
	return is_h_star(line, 3)
}

fn is_hh(line string) bool {
	return is_h_star(line, 2)
}

fn is_h(line string) bool {
	return is_h_star(line, 1)
}

fn is_other(line string) bool {
	return !is_h_star(line, 0) && !is_highlight(line)
}

fn is_h_star(line string, count int) bool {
	l := line.split(' ')[0].trim_space()
	if count <= 0 {
		return l.starts_with('#')
	}
	else {
		return l.starts_with('#') && l.count('#') == count
	}
}

pub fn (mut app App) init_server() {
	println('server started!')
	app.mount_static_folder_at(os.resource_abs_path('.'), '/')
}

fn cmd_start(cmd cli.Command) ! {
	mut app := App{
		posts: get_posts()
	}
	app.init_server()
	vweb.run(app, port)
}

fn cmd_new(cmd cli.Command) ! {
	title := cmd.args[0]
	write_post(title, [])
	return
}

fn cmd_db(cmd cli.Command) ! {
	posts := get_posts()
	println('${posts.len} posts in database')
	for post in posts {
		println(post.to_string())
	}
}

fn main() {
	mut commands := cli.Command{
		name: '${app_name}'
		description: 'static blog'
		execute: fn (cmd cli.Command) ! {
			println('see -help')
			return
		}
		commands: [
			cli.Command{
				name: 'start'
				description: 'start serving the web page'
				execute: cmd_start
			},
			cli.Command{
				name: 'new'
				description: 'create template for new post'
				execute: cmd_new
				required_args: 1
				usage: '<title>'
			},
			cli.Command{
				name: 'db'
				execute: cmd_db
			},
		]
	}

	commands.setup()
	commands.parse(os.args)
}

pub fn (mut app App) index() vweb.Result {
	lock app.posts {
		app.posts = get_posts()
	}
	return $vweb.html()
}

pub fn (mut app App) about() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) notfound() vweb.Result {
	app.set_status(404, 'Not Found')
	return $vweb.html()
}

['/:post']
pub fn (mut app App) post(name string) vweb.Result {
	post := app.find_post_by_name(name) or {
		app.redirect('/notfound')
		Post{}
	}
	post_title := post.title
	chunks := post.text
	return $vweb.html()
}
