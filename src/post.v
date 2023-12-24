import json

struct Post {
mut:
	title string
	tags  []string
	time  string
	text  []Chunk
	url   string
}

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

fn (p Post) get_item_descr_by_tags() string {
	mut str := ''
	if p.tags.len == 0 {
		str += ''
	}
	else {
		str += 'Talking about '
		if p.tags.len == 1 {
			str += '${p.tags[0]}.\n'
		}
		else if p.tags.len == 2 {
			str += '${p.tags[0]} and ${p.tags[1]}.'
		}
		else {
			for i := 0; i < p.tags.len - 1; i += 1 {
				str += p.tags[i] + ', '
			}
			str += 'and ${p.tags[p.tags.len-1]}.\n'
		}
	}

	str += p.text.map(it.text).join(' ')[..200]
	str += '...'

	return str
}


fn (p Post) to_rss_item() RssItem {
	return RssItem{
		title: p.title
		link: domain + p.url
		description: p.get_item_descr_by_tags()
		pub_date: to_rfc822(p.time) or { '' }
	}
}
