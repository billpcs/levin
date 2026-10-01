package space.revithi.app

import org.scalatra.test.scalatest._

class LevinScalatraFilterTests extends ScalatraFunSuite {

  addServlet(classOf[LevinScalatraFilter], "/*")

  test("GET / on LevinScalatraFilter should return status 200") {
    get("/") {
      status should equal (200)
    }
  }

}
