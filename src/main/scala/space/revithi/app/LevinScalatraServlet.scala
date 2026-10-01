package space.revithi.app

import space.revithi._
import org.scalatra._
import scala.annotation.switch
import play.twirl.api.Html
import java.io.File
import java.time.{LocalDateTime, Duration}
import scala.jdk.CollectionConverters._
import jakarta.servlet.RequestDispatcher
import com.github.benmanes.caffeine.cache.{Caffeine, Cache}


class LevinScalatraFilter(
    posts: Map[String, Post],
    notFoundCache: Cache[String, Int]
) extends ScalatraFilter {

  val start_time: LocalDateTime = LocalDateTime.now()

  val posts_sorted = posts.values.toList.sortWith{
      case (a,b) => a.metadata.time > b.metadata.time
    }
  
  val post_tags = posts.map{case(k, v) => (k, v.metadata.tags)}
  val tags_to_posts: Map[String, List[Post]] = posts
    .map {
      case(k, v) => (v, v.metadata.tags)
    }
    .map { 
      case (post, tags) => tags.map(tag => (tag, post))
    }
    .flatten
    .groupBy(_._1)
    .map {
      case (tag, v) => (tag, v.map(_._2).toList)
    }
  
  val rss = Rss(
    version = Rss.version,
    channel = RssChannel(
      title = Rss.title,
      link = "https://revithi.space",
      description = Rss.description,
      items = posts.map(p => p._2.toRssItem())
    ),
    cached = true
  )



  get("/") {
    views.html.index(posts_sorted)
  }

  get("/posts/:id") {
    posts.get(params("id")) match {
      case Some(post) => {
        views.html.post(post.id, post.metadata.title, post.metadata.cols, Html(post.contents))
      }
      case None => notFound(())
    }
  }

  get("/about") {
    views.html.about()
  }

  get("/tags") {
    views.html.tags(tags_to_posts)
  }

  get("/rss.xml") {
    contentType = "application/xml"
    Ok(rss)
  }

  get("/home") {
    redirect("/")
  }

  get("/stats") {
    val s = Duration.between(start_time, LocalDateTime.now()).toSeconds()
    val str = String.format("uptime: %d hours, %d min, %02d sec", s / 3600, (s % 3600) / 60, (s % 60));
    views.html.stats(str, notFoundCache.asMap().asScala)
  }
}
