import cli
import vweb

fn cmd_base() cli.Command {
	return cli.Command{
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
}

fn cmd_start(cmd cli.Command) ! {
	mut app := App{
		posts: get_posts()
	}

	app.init_server()
	spawn commander(mut &app)
	vweb.run(app, port)
}

fn cmd_new(cmd cli.Command) ! {
	title := cmd.args[0]
	write_post(title, ...cmd.args[1..])
	return
}

fn cmd_db(cmd cli.Command) ! {
	posts := get_posts()
	println('${posts.len} posts in database')
	for post in posts {
		println(post.to_string())
	}
}
