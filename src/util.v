import time

fn to_rfc822(t string) !string {
	// expects format 2023-12-24 10:52:44
	// returns format Sun, 24 Dec 2023 10:52:44 UTC
	parsed := time.parse(t)!
	return parsed.utc_string()
}

fn find_key_with_min_value(m map[string]u32) string {
	mut min := u32(0xffffffff)
	mut key_of_min := ""
	rlock {
		for key in m.keys() {
			mkey := m[key]
			if mkey < min {
				min = mkey
				key_of_min = key
			}
		}
	}
	return key_of_min
}

fn map_delete_oldest_key(mut m map[string]u32) {
	// get first key (which is the oldest in v)
	if m.keys().len > 0 {
		key := m.keys()[0]
		m.delete(key)
	}
}