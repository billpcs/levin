package space.revithi

import upickle.default.*
import com.vladsch.flexmark.html.HtmlRenderer
import com.vladsch.flexmark.parser.Parser
import java.io.File
import java.nio.file.{Files, Paths}

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

  def allFilesUnderProjectPath(
      relativePath: String
  ): Option[Seq[java.io.File]] = {
    val projectRoot = System.getProperty("user.dir")
    val dirPath = Paths.get(projectRoot, relativePath).toString
    val directory = new File(dirPath)
    if (directory.exists && directory.isDirectory) {
      Some(directory.listFiles.filter(_.isFile))
    } else {
      None
    }
  }

  def readPosts(): Seq[(PostId, RawPostContents)] = {
    val posts = allFilesUnderProjectPath("src/main/resources/posts/").getOrElse(
      List.empty
    )
    val post_names = posts.map(_.getName)
    val post_contents = posts.map(io.Source.fromFile(_).mkString)
    post_names.zip(post_contents)
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

