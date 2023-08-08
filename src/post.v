import json

struct Post {
mut:
	title string
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