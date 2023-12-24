import os
import time
import readline
import log

fn show_db() {
	posts := get_posts()
	println('${posts.len} posts in database')
	for post in posts {
		println(post.to_string())
	}
}

fn reload_posts(mut app App) {
	posts := get_posts()
	lock app.posts {
		app.posts = posts
	}
	lock app.tags {
		// force recompute of tags
		app.tags.cached = false
	}
	app.info('posts were reloaded (${posts.len} in db)')
}

fn reload_rss(mut app App) ! {
	rss := app.get_rss(true)
	mut file := os.open_file(rss_file, 'w')!
	n_bytes := file.writeln(rss.to_string()) or { 0 }
	if n_bytes == 0 {
		app.error('rss: could not write to ${rss_file}')
	} else {
		app.info('rss file was rewritten')
	}
	file.close()
}

fn set_log_level(mut app App, l log.Level) {
	app.set_log_level(l)
	println("loglevel set to '${l}'")
	app.info("loglevel set to '${l}'")
}

fn handle_loglevel(mut app App, args ...string) {
	if args.len == 0 {
		println('loglevel is ${app.get_log_level()}')
	} else {
		match args[0] {
			'debug', 'd' {
				set_log_level(mut app, log.Level.debug)
			}
			'info', 'i' {
				set_log_level(mut app, log.Level.info)
			}
			'warn', 'w' {
				set_log_level(mut app, log.Level.info)
			}
			'error', 'e' {
				set_log_level(mut app, log.Level.error)
			}
			'fatal', 'f' {
				set_log_level(mut app, log.Level.fatal)
			}
			'disabled', 'disable' {
				set_log_level(mut app, log.Level.disabled)
			}
			else {
				println('available modes are:')
				println('\tdebug, info, warn, error, fatal, disabled')
			}
		}
	}
}

fn build_str_rec(elapsed time.Duration, str string) string {
	if elapsed.seconds() <= 60 {
		nstr := '${elapsed.seconds():.0} secs'
		return str + ' ' + nstr
	} else if elapsed.minutes() <= 60 {
		mins := i64(elapsed.minutes())
		rem := elapsed - mins * time.minute
		nstr := '${mins} mins'
		return build_str_rec(rem, str + ' ' + nstr)
	} else if elapsed.hours() <= 24 {
		hours := i64(elapsed.hours())
		rem := elapsed - hours * time.hour
		nstr := '${hours} hours'
		return build_str_rec(rem, str + ' ' + nstr)
	} else {
		days := i64(elapsed.days())
		rem := elapsed - days * time.hour * 24
		nstr := '${days} days'
		return build_str_rec(rem, str + ' ' + nstr)
	}
}

fn show_uptime(mut app App) {
	now := time.now()
	elapsed := now - app.start_time

	str := '${build_str_rec(elapsed, 'uptime:')}'

	println(str)
	app.debug(str)
}

fn show_help() {
	println('
	reload, r      : 	re-read database and bring any new posts
	database, db, d:	show the current database of posts
	uptime, up, u  :	show uptime of server 
	quit, q, exit  :	shut down the server
	')
}

fn commander(mut app App) {
	mut r := readline.Readline{}
	for {
		input := r.read_line('>>> ') or { '' }
		input_list := input.split(' ')

		cmd := input_list[0]
		args := input_list[1..]

		match cmd {
			'' {
				// nothing		
			}
			'help', 'h' {
				show_help()
			}
			'reload', 'r' {
				reload_posts(mut app)
				reload_rss(mut app) or { app.info('could not load rss') }
			}
			'databse', 'db', 'd' {
				show_db()
			}
			'uptime', 'up', 'u' {
				show_uptime(mut app)
			}
			'loglevel', 'log', 'l' {
				handle_loglevel(mut app, ...args)
			}
			'quit', 'exit', 'q' {
				println('shuting down server...')
				exit(0)
			}
			else {
				println("unknown command '${cmd}'")
				show_help()
			}
		}
	}
}
