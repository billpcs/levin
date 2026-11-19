package space.revithi

import upickle.default.*
import com.vladsch.flexmark.html.HtmlRenderer
import com.vladsch.flexmark.parser.Parser
import scala.io.Source
import scala.util.Using

type PostId = String
type RawPostContents = String
type PostContents = String

case class PostMetadata(
    title: String,
    time: String,
    tags: List[String] = List.empty,
    cols: Int = 0
) derives ReadWriter

case class Post(
    id: PostId,
    metadata: PostMetadata,
    contents: String,
    relative_url: String,
  ) {
  def toRssItem(): RssItem = {
    RssItem(
      title = metadata.title,
      link = "https://revithi.space/" + relative_url,
      description = metadata.tags.mkString(", "),
      pub_date = Util.to_rfc822(metadata.time)
    )
  }
}

object PostReader {

  def readPosts(): Seq[(PostId, RawPostContents)] = {
    val loader = getClass.getClassLoader
    val names = Using.resource(Source.fromResource("posts.index", loader)(scala.io.Codec.UTF8)) {
      _.getLines().toList
    }
    names.map { name =>
      val contents = Using.resource(Source.fromResource(s"posts/$name", loader)(scala.io.Codec.UTF8)) {
        _.mkString
      }
      name -> contents
    }
  }

  def splitMetadataAndContents(post: String): (String, String) = {
    val lines = post.split("\n")
    val metadata = lines.head
    val rest = lines.tail.dropWhile(_ == "").mkString("\n")
    (metadata, rest)
  }

  def getPostsMap(): Map[String, Post] = {
    val parser = Parser.builder().build()
    val renderer = HtmlRenderer.builder().build()
    readPosts().map { (name, contents) =>
      val (meta, markdown) = splitMetadataAndContents(contents)
      val metadata = read[PostMetadata](meta)
      val document = parser.parse(markdown)
      val html = renderer.render(document)
      name -> Post(
        id = name,
        metadata = metadata,
        contents = html,
        relative_url = "posts/" + name
      )
    }.toMap
  }
}

