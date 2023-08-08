import os
import vweb
import cli
import time

const (
	port       = 8082
	app_name   = 'levin'
	posts_path = './posts/'
	log_file_path = '/home/bill/.cache/levin.log'
)

struct App {
	vweb.Context
mut:
	posts    shared []Post
	commands cli.Command
	start_time time.Time
	logger	Logger
}

fn main() {
	mut commands := cmd_base()
	commands.setup()
	commands.parse(os.args)
}
