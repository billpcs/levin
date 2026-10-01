package space.revithi.app

import jakarta.servlet.RequestDispatcher
import jakarta.servlet.http.{
  HttpServlet,
  HttpServletRequest,
  HttpServletResponse
}

import com.github.benmanes.caffeine.cache.Cache

class NotFoundServlet(
    notFoundCache: Cache[String, Int]
) extends HttpServlet {

  override def service(
      request: HttpServletRequest,
      response: HttpServletResponse
  ): Unit = {

    val requestUrl =
      Option(
        request.getAttribute(
          RequestDispatcher.ERROR_REQUEST_URI
        )
      )
        .map(_.toString)
        .getOrElse(request.getRequestURI)

    val newCount =
      notFoundCache.get(requestUrl, _ => 0) + 1

    notFoundCache.put(requestUrl, newCount)

    response.setStatus(HttpServletResponse.SC_NOT_FOUND)
    response.setContentType("text/html")
    response.setCharacterEncoding("UTF-8")

    response.getWriter.write(
      views.html.notfound().body
    )
  }
}