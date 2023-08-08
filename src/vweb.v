import os
import vweb

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


fn (mut app App) init_server() {
	app.logger.debug("server starting")
	app.mount_static_folder_at(os.resource_abs_path('.'), '/')
}


pub fn (mut app App) index() vweb.Result {
	app.logger.debug("user ${app.ip()} requests index")
	return $vweb.html()
}

pub fn (mut app App) about() vweb.Result {
	app.logger.debug("user ${app.ip()} requests about")
	return $vweb.html()
}

pub fn (mut app App) notfound() vweb.Result {
	app.logger.debug("user ${app.ip()} went to notfound")
	app.set_status(404, 'Not Found')
	return $vweb.html()
}

['/:post']
pub fn (mut app App) post(name string) vweb.Result {
	post := app.find_post_by_name(name) or {
		return app.notfound()
	}
	app.logger.debug("user ${app.ip()} accessed post '${name}'")
	post_title := post.title
	chunks := post.text
	return $vweb.html()
}
