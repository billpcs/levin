module main

import os
import os.cmdline
import vweb
import crypto.md5
import time

const (
	port = 8082
  title = "levin"
)

struct App {
	vweb.Context
mut:
	posts shared []Post
}

struct Post {
mut:
  title string
  time string
  text string
  url string
}

fn url(title string) string {
  return md5.hexhash(title)
  // return hash(title)
}

fn hash(s string) string {
  return s.to_lower().hash().str()
}

fn (p Post) to_string() string {
  return "| title ; ${p.title}\n" +
         "| time  ; ${p.time}\n"
}

fn read_post(path string) ?Post {
  n_metadata := 2
  mut post := Post{}
  cont := os.read_lines(path) ?
  related := cont[0..n_metadata].filter(it.starts_with("|"))
  for i,line in related {
    if i > 3 { break }
    splited := line.split(";")
    if splited.len > 1 {
      of_interest := splited[0].trim("| ")
      if of_interest == 'title' {
        post.title = splited[1].trim_space()
      }
      else if of_interest == 'time' {
        post.time = splited[1].trim_space()
      }
    }
  }
  if cont.len > n_metadata+1 {
    post.text = cont[n_metadata+1..].join_lines()
  }
  post.url = url(post.title)
  return post
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

fn sort_by_date(mut posts []Post) {
  posts.sort_with_compare(compare_porst_dates)
}

fn get_posts() []Post {
  mut posts := []Post{}
  dir := (os.ls("./posts") or {[]}).map("./posts/${it}")
  files := dir.filter(os.is_file(it))
  for file in files {
    post := read_post(file) or {Post{}}
    posts << post
  }
  sort_by_date(mut posts)
  return posts
}

fn (mut app App) find_post_by_name(url string) ?Post {
  rlock app.posts {
    for post in app.posts {
      if url == post.url {
        return post
      }
    }
  }
  return error('not found this post')
}


fn write_post(title string) {
  time := time.now().str()
  post := Post {
    title: title.to_lower()
    time: time
    url: url(title)
  }
  os.write_file("./posts/${post.title}",post.to_string()) or {
    println("failed to write")
  }
}

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
  return !is_h(line) &&
         !is_hh(line) &&
         !is_hhh(line)
}

fn is_h_star(line string, count int) bool {
  l := line.split(" ")[0].trim_space()
  return l.starts_with("#") && l.count("#") == count
}


pub fn (mut app App) init_server() {
  println("server started!")
  //app.handle_static("assets", false)
  app.mount_static_folder_at(os.resource_abs_path('.'), '/')
}

fn main() {
  name := cmdline.option(os.args, "new", "empty")
  start := 'start' in os.args

  mut app := App{
    posts: get_posts()
  }

  if start {
    app.init_server()
    vweb.run(app, port)
  }
  else if name != 'empty' {
    write_post(name)
  }
  else {
    posts := rlock {app.posts}
    println("found ${posts.len} posts")
    for post in posts {
      println(post.url)
    }
  }
}


pub fn (mut app App) index() vweb.Result {
  return $vweb.html()
}


['/:post']
pub fn (mut app App) post(name string) vweb.Result {
  post := app.find_post_by_name(name) or {
    app.redirect("/error")
    Post{}
  }
  post_title := post.title
  lines := post.text.split("\n")
  return $vweb.html()
}

pub fn (mut app App) about() vweb.Result {
  return $vweb.html()
}

pub fn (mut app App) error() vweb.Result {
  return $vweb.html()
}

pub fn (mut app App) reload() vweb.Result {
  /* There is a bug here and the app locks forever */
  // lock app.posts {
  //   app.posts = get_posts()
  // }
  return app.redirect("/")
}
