package space.revithi.app

import org.scalatra.test.scalatest._

class LevinScalatraServletTests extends ScalatraFunSuite {

  addServlet(classOf[LevinScalatraServlet], "/*")

  test("GET / on LevinScalatraServlet should return status 200") {
    get("/") {
      status should equal (200)
    }
  }

}
