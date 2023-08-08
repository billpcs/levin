import readline

fn commander(mut app &App) {
	mut r := readline.Readline{}
	for {
		answer := r.read_line('>>> ') or {""}

		match answer {
			"reload", "r" {
				lock app.posts {
					app.posts = get_posts()
				}
			}
			"quit", "exit", "q" {
				exit(0)
			}
			"" {}
			else {
				println("unknown command")
			}
		}

	}
}