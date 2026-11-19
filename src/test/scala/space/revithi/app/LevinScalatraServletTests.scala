package space.revithi.app

import com.github.benmanes.caffeine.cache.Caffeine
import org.scalatra.test.scalatest._
import space.revithi.PostReader

class LevinScalatraFilterTests extends ScalatraFunSuite {

  private val notFoundCache = Caffeine.newBuilder().maximumSize(1000).build[String, Int]()
  addFilter(new LevinScalatraFilter(PostReader.getPostsMap(), notFoundCache), "/*")

  test("GET / on LevinScalatraFilter should return status 200") {
    get("/") {
      status should equal (200)
    }
  }

}
