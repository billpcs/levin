package space.revithi

import java.net.URL
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.ee10.webapp.WebAppContext
import org.eclipse.jetty.util.resource.ResourceFactory

object JettyLauncher {
  def main(args: Array[String]): Unit = {
    val port = sys.env.getOrElse("PORT", "8082").toInt
    val server = new Server(port)
    val context = new WebAppContext()
    context.setContextPath("/")
    val descriptor = getClass.getResource("/webapp/WEB-INF/web.xml")
    context.setBaseResource(ResourceFactory.of(context).newResource(new URL(descriptor, "../")))
    context.setThrowUnavailableOnStartupException(true)
    server.setHandler(context)
    server.setStopAtShutdown(true)
    server.start()
    server.join()
  }
}
