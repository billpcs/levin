import os

enum LogLevel {
	disable
	fatal
	error
	info
	debug
}

struct Logger {
	level LogLevel
}

fn (l Logger) log(str string) {
	os.system("echo ${str} >> ${log_file_path}")
}

fn (l Logger) debug(str string) {
	l.level match {
		LogLevel.debug, LogLevel.info, LogLevel.error, LogLevel.fatal {
			log(str)
		}
		else {}
	}
}


fn (l Logger) info(str string) {
	l.level match {
		LogLevel.info, LogLevel.error, LogLevel.fatal {
			log(str)
		}
		else {}
	}
}

fn (l Logger) error(str string) {
	l.level match {
		LogLevel.error, LogLevel.fatal {
			log(str)
		}
		else {}
	}
}

fn (l Logger) fatal(str string) {
	l.level match {
		LogLevel.fatal {
			log(str)
		}
		else {}
	}
}