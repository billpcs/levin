import veb
import markdown

pub fn (mut app App) index(mut ctx Context) veb.Result {
	app.debug("user '${ctx.ip()}' requested index")
	return $veb.html()
}

pub fn (mut app App) about(mut ctx Context) veb.Result {
	app.debug("user '${ctx.ip()}' requested about")
	return $veb.html()
}

pub fn (mut app App) notfound(mut ctx Context) veb.Result {
	app.debug("user '${ctx.ip()}' went to notfound")
	ctx.res.set_status(.not_found)
	return $veb.html()
}

@['/']
pub fn (mut app App) slash(mut ctx Context) veb.Result {
	return app.index(mut ctx)
}

@['/tags']
pub fn (mut app App) tags(mut ctx Context) veb.Result {
	tags := app.get_all_tags()
	return $veb.html()
}

@['/posts']
pub fn (mut app App) posts(mut ctx Context) veb.Result {
	return ctx.redirect('/')
}

@['/posts/:post']
pub fn (mut app App) post(mut ctx Context, name string) veb.Result {
	// post := app.find_post_by_name(name) or { return app.notfound(mut ctx) }
	post := app.find_post_by_name(name) or { return ctx.text('not found') }
	app.debug("user '${ctx.ip()}' accessed post '${name}'")
	post_title := post.title
	post_url := post.relative_url()
	tags := post.tags
	cols := post.cols
	post_html := veb.RawHtml(markdown.to_html(post.text))
	return $veb.html()
}

@['/:other...']
pub fn (mut app App) catchall(mut ctx Context, path string) veb.Result {
	return app.notfound(mut ctx)
	// return ctx.text('other')
}