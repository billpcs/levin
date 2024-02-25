import os
import log

const port = 8082
const app_name = 'levin'
const page_name = 'revithi.space'
const posts_path = './posts/'
const domain = 'https://revithi.space/'
const default_loglevel = log.Level.debug
const log_file_path = os.expand_tilde_to_home('~/.cache/levin.log')

fn main() {
	mut commands := cmd_base()
	commands.setup()
	commands.parse(os.args)
}
