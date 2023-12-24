import os
import log

const (
	port       = 8082
	app_name   = 'levin'
	posts_path = './posts/'
	domain = 'https://revithi.space/'
	default_loglevel = log.Level.debug
	log_file_path = os.expand_tilde_to_home('~/.cache/levin.log')
)


fn main() {
	mut commands := cmd_base()
	commands.setup()
	commands.parse(os.args)
}
