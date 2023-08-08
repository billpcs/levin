import cli
import vweb
import time

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

	// log_file := os.open_append(log_file_path) or {
	// 	println("failed to open logfile, writing to stdout")
	// 	os.stdout()
	// }

	mut app := App{
		posts: get_posts()
		logger: Logger {
			level: LogLevel.debug
		}
		start_time: time.now()
	}

	spawn commander(mut &app)
	app.init_server()
	vweb.run(app, port)
}

fn cmd_new(cmd cli.Command) ! {
	title := cmd.args[0]
	write_post(title, ...cmd.args[1..])
	return
}

fn cmd_db(cmd cli.Command) ! {
	show_db()
}
