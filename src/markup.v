type Chunk = Code | HHHeader | HHeader | Header | Highlight | Image | Quote | Text

struct Code {
	metadata string
	text     string
}

struct Highlight {
	metadata string
	text     string
}

struct Quote {
	metadata string
	text     string
}

struct Image {
	metadata string
	text     string
}

struct Text {
	metadata string
	text     string
}

struct Header {
	metadata string
	text     string
}

struct HHeader {
	text     string
	metadata string
}

struct HHHeader {
	text     string
	metadata string
}

pub fn (c Chunk) is_code() bool {
	return match c {
		Code { true }
		else { false }
	}
}

pub fn (c Chunk) is_highlight() bool {
	return match c {
		Highlight { true }
		else { false }
	}
}

pub fn (c Chunk) is_text() bool {
	return match c {
		Text { true }
		else { false }
	}
}

pub fn (c Chunk) is_h() bool {
	return match c {
		Header { true }
		else { false }
	}
}

pub fn (c Chunk) is_hh() bool {
	return match c {
		HHeader { true }
		else { false }
	}
}

pub fn (c Chunk) is_hhh() bool {
	return match c {
		HHHeader { true }
		else { false }
	}
}

pub fn (c Chunk) is_quote() bool {
	return match c {
		Quote { true }
		else { false }
	}
}

pub fn (c Chunk) is_image() bool {
	return match c {
		Image { true }
		else { false }
	}
}

fn is_highlight(line string) bool {
	l := line.split(' ')[0].trim_space()
	return l.starts_with('|')
}

fn is_quote(line string) bool {
	l := line.split(' ')[0].trim_space()
	return l.starts_with('>')
}

fn is_code(line string) bool {
	return line.starts_with('@#')
}

fn is_hhh(line string) bool {
	return is_h_star(line, 3)
}

fn is_hh(line string) bool {
	return is_h_star(line, 2)
}

fn is_h(line string) bool {
	return is_h_star(line, 1)
}

fn is_image(line string) bool {
	l := line.split(' ')[0].trim_space()
	return l.starts_with('@!')
}

fn is_other(line string) bool {
	return !is_h_star(line, 0) && !is_highlight(line)
}

fn is_h_star(line string, count int) bool {
	l := line.split(' ')[0].trim_space()
	if count <= 0 {
		return l.starts_with('#')
	} else {
		return l.starts_with('#') && l.count('#') == count
	}
}

fn parse_post_text(text []string) []Chunk {
	mut line := ''
	mut chunked := []Chunk{}
	for i := 0; i < text.len; i += 1 {
		line = text[i]
		if is_h(line) {
			chunked << Header{
				text: line.all_after('#')
				metadata: 'text'
			}
		} else if is_hh(line) {
			chunked << HHeader{
				text: line.all_after('##')
				metadata: 'text'
			}
		} else if is_hhh(line) {
			chunked << HHHeader{
				text: line.all_after('###')
				metadata: 'text'
			}
		} else if is_highlight(line) {
			chunked << Highlight{
				text: line.all_after('| ')
				metadata: 'text'
			}
		} else if is_quote(line) {
			chunked << Quote{
				text: line.all_after('> ')
			}
		} else if is_image(line) {
			chunked << Image{
				text: line.all_after('@! ')
			}
		} else if is_code(line) {
			lang_start := line.split(' ')
			if lang_start.len > 1 {
				if lang_start[1].starts_with('language-') {
					i += 1
					lang := lang_start[1]
					mut code_str := ''
					for !text[i].starts_with('@# end') {
						code_str += '${text[i]}\n'
						i += 1
					}
					chunked << Code{
						metadata: lang
						text: code_str
					}
				}
			}
		} else {
			chunked << Text{
				text: line
				metadata: 'text'
			}
		}
	}

	return chunked
}
