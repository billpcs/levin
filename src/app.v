import os
import log
import vweb
import cli
import time

struct Tags {
mut:
	cached bool
	list   map[string][]Post
}

struct App {
	vweb.Context
mut:
	posts      shared []Post
	commands   cli.Command
	start_time time.Time
	logger     shared log.Log
	tags       shared Tags
	rss        shared Rss
}

fn (mut app App) find_post_by_name(name string) !Post {
	rlock app.posts {
		for post in app.posts {
			if name == post.id {
				return post
			}
		}
	}
	return error('could not find this post')
}

fn (mut app App) force_recompute_tags() map[string][]Post {
	mut m := map[string][]Post{}

	lock app.posts {
		for post in app.posts {
			for tag in post.tags {
				m[tag] << post
			}
		}
	}

	return m
}

fn (mut app App) force_recompute_rss() RssChannel {
	mut items := []RssItem{}
	lock app.posts {
		for post in app.posts {
			items << post.to_rss_item()
		}
	}
	return RssChannel{
		title: rss_title
		link: domain
		description: rss_description
		items: items
	}
}

fn (mut app App) get_all_tags() map[string][]Post {
	lock app.tags {
		if app.tags.cached {
			app.info('tags requested, they were cached')
			return app.tags.list
		} else {
			app.info('tags requested, recomputed and cached')
			app.tags.list = app.force_recompute_tags()
			app.tags.cached = true
			return app.tags.list
		}
	}
}

fn (mut app App) get_rss(force_reload bool) Rss {
	lock app.rss {
		if app.rss.cached && !force_reload {
			app.info('rss requested, returning cached version')
		} else {
			app.info('rss requested, recomputing and caching')
			app.rss = Rss{
				version: rss_version
				cached: true
				channel: app.force_recompute_rss()
			}
		}
	}
	rss := app.rss
	return rss
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
	app.serve_static('/rss.xml', rss_file)
	app.serve_static('/sitemap.xml', './assets/sitemap.xml')
	app.serve_static('/favicon.ico', './assets/favicon.ico')
	app.serve_static('/robots.txt', './assets/robots.txt')
	app.mount_static_folder_at(os.resource_abs_path('./assets'), '/assets')
	app.mount_static_folder_at(os.resource_abs_path('./img'), '/img')
}
