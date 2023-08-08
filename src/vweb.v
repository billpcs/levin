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
	println('server started!')
	app.mount_static_folder_at(os.resource_abs_path('.'), '/')
}


pub fn (mut app App) index() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) about() vweb.Result {
	return $vweb.html()
}

pub fn (mut app App) notfound() vweb.Result {
	app.set_status(404, 'Not Found')
	return $vweb.html()
}

['/:post']
pub fn (mut app App) post(name string) vweb.Result {
	post := app.find_post_by_name(name) or {
		println("not found post ${name}")
		app.redirect('/notfound')
		Post{}
	}
	post_title := post.title
	chunks := post.text
	return $vweb.html()
}
