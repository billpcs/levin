package space.revithi.app

import org.scalatra._
import space.revithi._
import scala.annotation.switch
import play.twirl.api.Html
import java.io.File


class LevinScalatraServlet(posts: Map[String, Post]) extends ScalatraServlet {

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

}
