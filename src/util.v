import time

fn to_rfc822(t string) !string {
	// expects format 2023-12-24 10:52:44
	// returns format Sun, 24 Dec 2023 10:52:44 UTC
	parsed := time.parse(t)!
	return parsed.utc_string()
}
