import vweb

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

@['/']
pub fn (mut app App) slash() vweb.Result {
	return app.index()
}

@['/tags']
pub fn (mut app App) tags() vweb.Result {
	tags := app.get_all_tags()
	return $vweb.html()
}

@['/posts']
pub fn (mut app App) posts() vweb.Result {
	return app.redirect('/')
}

@['/posts/:post']
pub fn (mut app App) post(name string) vweb.Result {
	post := app.find_post_by_name(name) or { return app.notfound() }
	app.debug("user '${app.ip()}' accessed post '${name}'")
	post_title := post.title
	post_url := post.relative_url()
	chunks := post.text
	tags := post.tags
	return $vweb.html()
}

@['/:other...']
pub fn (mut app App) catchall(path string) vweb.Result {
	return app.notfound()
}