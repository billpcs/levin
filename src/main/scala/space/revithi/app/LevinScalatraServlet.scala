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
    redirect("/")
  }

}
