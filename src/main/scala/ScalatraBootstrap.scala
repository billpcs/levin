import space.revithi._
import space.revithi.app._
import org.scalatra._
import java.util.EnumSet
import jakarta.servlet.{DispatcherType, ServletContext}
import com.github.benmanes.caffeine.cache.{Caffeine, Cache}

class ScalatraBootstrap extends LifeCycle {
  override def init(context: ServletContext): Unit = {
    val posts: Map[String, Post] = PostReader.getPostsMap()

    val notFoundCache: Cache[String, Int] =
      Caffeine.newBuilder()
        .maximumSize(1000)
        .build[String, Int]()

    context.mount(
      new LevinScalatraFilter(posts, notFoundCache),
      "/*"
    )

    context
      .addServlet(
        "not-found",
        new NotFoundServlet(notFoundCache)
      )
      .addMapping("/__error/404")
  }
}