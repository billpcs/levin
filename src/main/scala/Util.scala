package space.revithi

import java.time.LocalDateTime
import java.time.format.{DateTimeFormatter, FormatStyle}
import java.time.ZoneId
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatterBuilder
import java.util.Locale

object Util {
    def to_rfc822(input_time: String): String = {
        val input_formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
        val rfc_822_formatter = new DateTimeFormatterBuilder()
                            .appendPattern("EEE, dd MMM yyyy HH:mm:ss z")
                            .toFormatter(Locale.ENGLISH)

        val local = LocalDateTime.parse(input_time, input_formatter)
        val zoned = ZonedDateTime.of(local, ZoneId.of("GMT"))
        return rfc_822_formatter.format(zoned)
    }
}