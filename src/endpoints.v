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

pub fn (mut app App) notfound(mut ctx Context, path string) veb.Result {
	app.debug("NOTFOUND: user '${ctx.ip()}' tried going to ${path}")
	ctx.res.set_status(.not_found)
	return $veb.html()
}

@['/tags']
pub fn (mut app App) tags(mut ctx Context) veb.Result {
	tags := app.get_all_tags()
	return $veb.html()
}

@['/stats']
pub fn (mut app App) stats() veb.Result {
	stats := app.get_stats()
	return $veb.html()
}


@['/posts']
pub fn (mut app App) posts(mut ctx Context) veb.Result {
	return ctx.redirect('/')
}

@['/posts/:post']
pub fn (mut app App) post(mut ctx Context, name string) veb.Result {
	post := app.find_post_by_name(name) or {
		return app.notfound(mut ctx, "/post/ with name '${name}'")
	}
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
	lock app.stats {
		app.stats.list[path] += 1
		if app.stats.list.keys().len > max_stats_entries {
			map_delete_oldest_key(mut app.stats.list)
		}
	}
	return app.notfound(mut ctx, "'${path}'")
}
