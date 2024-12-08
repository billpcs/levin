import space.revithi._
import space.revithi.app._
import org.scalatra._
import jakarta.servlet.ServletContext

class ScalatraBootstrap extends LifeCycle {
  override def init(context: ServletContext): Unit = {
    val posts = PostReader.get()
    context.mount(new LevinScalatraServlet(posts), "/*")
  }
}
