package space.revithi

import org.eclipse.jetty.server.Server
import org.eclipse.jetty.ee10.servlet.{DefaultServlet, ServletContextHandler}
import org.eclipse.jetty.ee10.webapp.WebAppContext
import org.scalatra.servlet.ScalatraListener

object JettyLauncher {
  def main(args: Array[String]): Unit = {
    val port = 8082
    val server = new Server(port)
    val context = new WebAppContext()
    context setContextPath "/"
    context.setBaseResourceAsString("src/main/webapp")
    context.addEventListener(new ScalatraListener)
    context.addServlet(classOf[DefaultServlet], "/")
    server.setHandler(context)



    try {
      server.start()
      server.join()
    } catch {
      case e: Exception =>
        e.printStackTrace()
        server.stop()
    }
  }
}

