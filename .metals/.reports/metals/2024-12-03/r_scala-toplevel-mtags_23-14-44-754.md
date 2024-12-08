error id: file://<WORKSPACE>/src/main/scala/space/revithi/app/LevinScalatraServlet.scala:[22..23) in Input.VirtualFile("file://<WORKSPACE>/src/main/scala/space/revithi/app/LevinScalatraServlet.scala", "package space.revithi._

import space.revithi.PostParser.Post
import org.scalatra._

class LevinScalatraServlet(posts: Map[String, Post]) extends ScalatraServlet {

  get("/") {
    views.html.hello()
  }

  get("/posts/:id") {
    views.html.post(params("id"))
  }

  get("/tags") {
    redirect("/")
  }

  notFound {
    <h1>Not found. Bummer.</h1>
  }

}
")
file://<WORKSPACE>/file:<WORKSPACE>/src/main/scala/space/revithi/app/LevinScalatraServlet.scala
file://<WORKSPACE>/src/main/scala/space/revithi/app/LevinScalatraServlet.scala:1: error: expected identifier; obtained uscore
package space.revithi._
                      ^
#### Short summary: 

expected identifier; obtained uscore