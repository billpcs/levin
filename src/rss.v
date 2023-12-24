const rss_version = '2.0'
const rss_title = 'Levin Blog by billpcs'
const rss_description = 'technology and my thoughts'
const rss_file = './assets/rss.xml'

struct Rss {
	version string
	channel RssChannel
	cached  bool
}

struct RssChannel {
	title       string
	link        string
	description string
	items       []RssItem
}

struct RssItem {
	title       string
	link        string
	description string
	pub_date    string
}

fn (i RssItem) to_string() string {
	title := '<title>${i.title}</title>'
	link := '<link>${i.link}</link>'
	descr := '<description>${i.description}</description>'
	date := '<pubDate>${i.pub_date}</pubDate>'
	guid := '<guid>${i.link}</guid>'
	mut res := ''
	res += '\t<item>\n'
	res += '\t\t${title}\n'
	res += '\t\t${link}\n'
	res += '\t\t${descr}\n'
	res += '\t\t${date}\n'
	res += '\t\t${guid}\n'
	res += '\t</item>\n'
	return res
}

fn (c RssChannel) to_string() string {
	title := '<title>${c.title}</title>'
	link := '<link>${c.link}</link>'
	descr := '<description>${c.description}</description>'
	atom := "<atom:link href=\"${c.link}/rss.xml\" rel=\"self\" type=\"application/rss+xml\"/>"
	mut res := ''
	res += '<channel>\n'
	res += '\t${title}\n'
	res += '\t${link}\n'
	res += '\t${descr}\n'
	res += '\t${atom}\n'
	for item in c.items {
		res += item.to_string()
	}
	res += '</channel>\n'
	return res
}

fn (r Rss) to_string() string {
	mut res := ''
	res += '<?xml version="1.0" encoding="UTF-8" ?>\n'
	res += "<rss version=\"${r.version}\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n"
	res += r.channel.to_string()
	res += '</rss>'
	return res
}

fn rss_test() {
	rss := Rss{
		version: '2.0'
		channel: RssChannel{
			title: 'Levin Blog by billpcs'
			link: 'http://revithi.space/'
			description: 'technology, politics and whatever'
			items: [
				RssItem{
					title: 'Hello World'
					link: 'http://revithi.space/hello'
					description: 'my first for this site'
					pub_date: 'Thu, 21 Dec 2023 18:57:43 GMT'
				},
			]
		}
	}

	println(rss.to_string())
}
