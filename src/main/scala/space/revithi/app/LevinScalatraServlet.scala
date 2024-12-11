package space.revithi.app

import space.revithi._
import org.scalatra._
import scala.annotation.switch
import play.twirl.api.Html
import java.io.File
import java.time.{LocalDateTime, Duration}
import scala.jdk.CollectionConverters._
import com.github.benmanes.caffeine.cache.{Caffeine, Cache}


class LevinScalatraServlet(posts: Map[String, Post]) extends ScalatraServlet {

  val start_time: LocalDateTime = LocalDateTime.now()

  val notFoundCache: Cache[String, Int] = Caffeine.newBuilder()
    .maximumSize(1000) 
    .build()

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

  notFound {
    val requestUrl = request.getRequestURI
    serveStaticResource() getOrElse {
      val newCount = notFoundCache.get(requestUrl, _ => 0) + 1
      notFoundCache.put(requestUrl, newCount)
      NotFound(views.html.notfound())
    }
  }
}
