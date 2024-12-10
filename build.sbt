val ScalatraVersion = "3.1.0"

ThisBuild / scalaVersion := "3.3.3"
ThisBuild / organization := "space.revithi"

lazy val hello = (project in file("."))
  .settings(
    name := "Levin Scalatra",
    version := "0.1.0",
    libraryDependencies ++= Seq(
      "org.scalatra" %% "scalatra-jakarta" % ScalatraVersion,
      "org.scalatra" %% "scalatra-scalatest-jakarta" % ScalatraVersion % "test",
      "ch.qos.logback" % "logback-classic" % "1.5.6" % "runtime",
      "org.slf4j" % "slf4j-api" % "1.7.32",
      "org.eclipse.jetty" % "jetty-server" % "12.0.10" % "container;compile",  // Core Jetty server
      "org.eclipse.jetty.ee10" % "jetty-ee10-webapp" % "12.0.10" % "container;compile",  // Existing dependency
      "org.eclipse.jetty.ee10" % "jetty-ee10-servlet" % "12.0.10" % "container;compile", // Servlet support (for ServletContextHandler)
      "jakarta.servlet" % "jakarta.servlet-api" % "6.0.0" % "provided",
      "com.lihaoyi" %% "upickle" % "3.1.0",
      "com.vladsch.flexmark" % "flexmark-all" % "0.64.8",
      "com.github.ben-manes.caffeine" % "caffeine" % "3.1.8",
    ),
  )

enablePlugins(SbtTwirl)
enablePlugins(JettyPlugin)

Test / fork := true

Jetty / containerLibs := Seq("org.eclipse.jetty.ee10" % "jetty-ee10-runner" % "12.0.10" intransitive())
Jetty / containerMain := "org.eclipse.jetty.ee10.runner.Runner"
Jetty / containerPort := 8082

assembly / mainClass := Some("space.revithi.JettyLauncher")
assembly / assemblyMergeStrategy := {
  case PathList("META-INF", xs @ _*) => MergeStrategy.discard
  case x => MergeStrategy.first
}
