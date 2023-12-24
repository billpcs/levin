import cli
import vweb
import time
import os
import log
import crypto.md5

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
				flags: [
					cli.Flag{
						flag: .bool
						name: 'deamon'
						abbrev: 'd'
					},
				]
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

fn cmd_print_startup_info(mut app App) {
	hash := md5.hexhash(app.str())[0..8]
	app.info('server started (hash ${hash})')
	app.info("logfile: '${log_file_path}'")
	app.info('loglevel: ${default_loglevel}')
}

fn cmd_start(cmd cli.Command) ! {
	log_file := os.open_append(log_file_path) or {
		println('failed to open logfile, writing to stdout')
		os.stdout()
	}

	mut app := App{
		posts: get_posts()
		logger: log.Log{
			level: default_loglevel
			ofile: log_file
			output_target: log.LogTarget.file
		}
		start_time: time.now()
		tags: Tags{
			cached: false
		}
	}

	app.init_server()

	deamon := cmd.flags.get_bool('deamon')!

	if !deamon {
		spawn vweb.run(&app, port)
		cmd_print_startup_info(mut &app)
		// start REPL after a while
		time.sleep(time.second)
		commander(mut &app)
	} else {
		vweb.run(&app, port)
	}
}

fn cmd_new(cmd cli.Command) ! {
	title := cmd.args[0]
	write_post(title, ...cmd.args[1..])
	return
}

fn cmd_db(cmd cli.Command) ! {
	show_db()
}
