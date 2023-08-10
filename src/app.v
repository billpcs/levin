import os
import vweb
import log

fn (mut app App) find_post_by_name(url string) !Post {
	rlock app.posts {
		for post in app.posts {
			if url == post.url {
				return post
			}
		}
	}
	return error('could not find this post')
}

fn (mut app App) get_log_level() log.Level {
	lock app.logger {
		return app.logger.get_level()
	}
	return log.Level.debug
}

fn (mut app App) set_log_level(lvl log.Level) {
	lock app.logger {
		app.logger.set_level(lvl)
	}
}

fn (mut app App) debug(str string) {
	lock app.logger {
		app.logger.debug(str)
		app.logger.flush()
	}
}

fn (mut app App) info(str string) {
	lock app.logger {
		app.logger.info(str)
		app.logger.flush()
	}
}

fn (mut app App) error(str string) {
	lock app.logger {
		app.logger.error(str)
		app.logger.flush()
	}
}

fn (mut app App) fatal(str string) {
	lock app.logger {
		app.logger.fatal(str)
	}
}

fn (mut app App) init_server() {
	app.mount_static_folder_at(os.resource_abs_path('.'), '/')
}


pub fn (mut app App) index() vweb.Result {
	app.debug("user '${app.ip()}' requested index")
	return $vweb.html()
}

pub fn (mut app App) about() vweb.Result {
	app.debug("user '${app.ip()}' requested about")
	return $vweb.html()
}

pub fn (mut app App) notfound() vweb.Result {
	app.debug("user '${app.ip()}' went to notfound")
	app.set_status(404, 'Not Found')
	return $vweb.html()
}

['/']
pub fn (mut app App) slash() vweb.Result {
	return app.index()
}

['/:post']
pub fn (mut app App) post(name string) vweb.Result {
	post := app.find_post_by_name(name) or {
		return app.notfound()
	}
	app.debug("user '${app.ip()}' accessed post '${name}'")
	post_title := post.title
	chunks := post.text
	return $vweb.html()
}