import json

struct Post {
mut:
	title string
	tags  []Tag
	time  string
	text  []Chunk
	url   string
}

type Tag = string


fn (p Post) header() string {
	// must be in one line, the first line of the post
	return "{ \"title\": \"${p.title}\", \"time\": \"${p.time}\" }"
}

fn (p Post) json() string {
	return json.encode(p)
}

fn (p Post) to_string() string {
	return "${p.url} @ [${p.time}] - \"${p.title}\""
}

fn (p Post) to_rss_item() RssItem {
	return RssItem {
		title: p.title
		link: domain + p.url
		description: p.tags.str()
		pub_date: to_rfc822(p.time) or {''}
	}
}