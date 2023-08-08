import time
import readline
import math

fn show_db() {
	posts := get_posts()
	println('${posts.len} posts in database')
	for post in posts {
		println(post.to_string())
	}
}

fn reaload_posts(mut app &App) {
	posts := get_posts()
	lock app.posts {
		app.posts = posts
	}
	app.info("posts were reloaded (${posts.len} in db)")
}

fn handle_loglevel(mut app &App) {
}

fn show_uptime(mut app &App) {
	now := time.now()
	elapsed := now - app.start_time

	str := if elapsed < 1 * time.minute {
		"uptime: ${elapsed.seconds():.0} sec"
	}
	else if elapsed < 60 * time.minute {
		"uptime: ${elapsed.minutes():.0} min"
	}
	else if elapsed < 24 * time.hour {
		"uptime: ${elapsed.hours():.0} h"
	}
	else {
		days := elapsed.hours() / 24
		hours := math.fmod(elapsed.hours(), 24)
		"uptime: ${days:.0} days, ${hours:.0} h"
	}

	println(str)
	app.debug(str)
}

fn show_help() {
	println(
	"
	reload, r      : 	re-read database and bring any new posts
	database, db, d:	show the current database of posts
	uptime, up, u  :	show uptime of server 
	quit, q, exit  :	shut down the server
	")
}

fn commander(mut app &App) {
	mut r := readline.Readline{}
	for {
		answer := r.read_line('>>> ') or {""}

		match answer {
			"" {
				// nothing		
			}
			"help", "h" {
				show_help()
			}
			"reload", "r" {
				reaload_posts(mut app)	
			}
			"databse", "db", "d" {
				show_db()
			}
			"uptime", "up", "u" {
				show_uptime(mut app)
			}
			"loglevel", "log", "l" {
				handle_loglevel(mut app)
			}
			"quit", "exit", "q" {
				println("shuting down server...")
				exit(0)
			}
			else {
				println("unknown command '${answer}'")
				show_help()
			}
		}

	}
}