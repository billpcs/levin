import time
import readline

fn show_db() {
	posts := get_posts()
	println('${posts.len} posts in database')
	for post in posts {
		println(post.to_string())
	}
}

fn reaload_posts(mut app &App) {
	lock app.posts {
		app.posts = get_posts()
	}
	println("posts were reloaded")
}

fn show_uptime(started time.Time) {
	now := time.now()
	elapsed := now - started

	if elapsed < 1 * time.minute {
		println("${elapsed.seconds()} seconds")
	}
	else if elapsed < 60 * time.minute {
		println("${elapsed.minutes()} minutes")
	}
	else if elapsed < 24 * time.hour {
		println("${elapsed.hours()} hours")
	}
	else {
		println("${elapsed.days()} days")
	}

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
				show_uptime(app.start_time)
			}
			"quit", "exit", "q" {
				println("shuting down server...")
				exit(0)
			}
			else {
				println("unknown command")
			}
		}

	}
}