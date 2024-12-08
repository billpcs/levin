package space.revithi

import java.nio.file.{Paths, Files}
import java.nio.charset.StandardCharsets

case class Rss(
    version: String,
    channel: RssChannel,
    cached: Boolean
) {
    override def toString(): String =
        s"""<?xml version="1.0" encoding="UTF-8" ?>
        <rss version="${version}" xmlns:atom="http://www.w3.org/2005/Atom">
        ${channel}
        </rss>
        """

    def write(path: String): Unit = 
        println(this.toString())
        Files.write(Paths.get(path), this.toString().getBytes(StandardCharsets.UTF_8))
        
}


case class RssChannel(
    title: String,
    link: String,
    description: String,
    items: Iterable[RssItem]
) {
    override def toString(): String =
        val atom = "<atom:link href=\"https://revithi.space/rss.xml\" rel=\"self\" type=\"application/rss+xml\"/>"
        s"""<title>${title}</title>
            <link>${link}</link>
            <description>${description}</description>
            ${atom}
            ${items.mkString("\n")}
        """
}


case class RssItem(
    title: String,
    link: String,
    description: String,
    pub_date: String
) {
    override def toString(): String =
        s"""
        <item>
            <title>${title}</title>
            <link>${link}</link>
            <description>${description}</description>
            <pubDate>${pub_date}</pubDate>
            <guid>${link}</guid>
        </item>
        """
}

object Rss {
    val version = "2.0"
    val title = "Levin Blog (by revithi)"
    val description = "Technology and my thoughts"
    val file = "/assets/rss.xml"
}