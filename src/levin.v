import os
import vweb
import cli

const (
	port       = 8082
	app_name   = 'levin'
	posts_path = './posts/'
)

struct App {
	vweb.Context
mut:
	posts    shared []Post
	commands cli.Command
}

fn main() {
	mut commands := cmd_base()
	commands.setup()
	commands.parse(os.args)
}
