import time
import readline
import math
import log

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

fn set_log_level(mut app &App, l log.Level) {
	app.set_log_level(l)
	println("loglevel set to '${l}'")
	app.info("loglevel set to '${l}'")
}

fn handle_loglevel(mut app &App, args ...string) {
	if args.len == 0 {
		println("loglevel is ${app.get_log_level()}")
	}
	else {
		match args[0] {
			"debug", "d" {
				set_log_level(mut app, log.Level.debug)
			}
			"info", "i" {
				set_log_level(mut app, log.Level.info)
			}
			"warn", "w" {
				set_log_level(mut app, log.Level.info)
			}
			"error", "e" {
				set_log_level(mut app, log.Level.error)
			}
			"fatal", "f" {
				set_log_level(mut app, log.Level.fatal)
			}
			"disabled", "disable" {
				set_log_level(mut app, log.Level.disabled)
			}
			else {
				println("available modes are:")
				println("\tdebug, info, warn, error, fatal, disabled")
			}
		}
	}

}

fn show_uptime(mut app &App) {
	now := time.now()
	elapsed := now - app.start_time

	str := if elapsed.minutes() < 1 {
		"uptime: ${elapsed.seconds():.0} sec"
	}
	else if elapsed.minutes() < 60 {
		mins := elapsed.seconds() / 60
		secs := math.fmod(elapsed.seconds(), 60)
		"uptime: ${mins:.0} min, ${secs:.0} sec"
	}
	else if elapsed.hours() < 24 {
		hours := elapsed.minutes() / 60
		mins := math.fmod(elapsed.minutes(), 60)
		"uptime: ${hours:.0} h, ${mins:.0} min"
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
		input := r.read_line('>>> ') or {""}
		input_list := input.split(" ")

		cmd := input_list[0]
		args := input_list[1..]

		match cmd {
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
				handle_loglevel(mut app, ...args)
			}
			"quit", "exit", "q" {
				println("shuting down server...")
				exit(0)
			}
			else {
				println("unknown command '${cmd}'")
				show_help()
			}
		}

	}
}