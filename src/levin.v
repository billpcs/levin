import os
import vweb
import cli
import time
import log

const (
	port       = 8082
	app_name   = 'levin'
	posts_path = './posts/'
	default_loglevel = log.Level.debug
	log_file_path = os.expand_tilde_to_home('~/.cache/levin.log')
)

struct App {
	vweb.Context
pub mut:
	posts    shared []Post
	commands cli.Command
	start_time time.Time
	logger	shared log.Log
}

fn main() {
	mut commands := cmd_base()
	commands.setup()
	commands.parse(os.args)
}
