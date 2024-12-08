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
      "org.eclipse.jetty.ee10" % "jetty-ee10-webapp" % "12.0.10" % "container",
      "jakarta.servlet" % "jakarta.servlet-api" % "6.0.0" % "provided",
      "com.lihaoyi" %% "upickle" % "3.1.0",
      "com.vladsch.flexmark" % "flexmark-all" % "0.64.8",
      "com.github.ben-manes.caffeine" % "caffeine" % "3.1.8"
    ),
  )

enablePlugins(SbtTwirl)
enablePlugins(JettyPlugin)

Test / fork := true

Jetty / containerLibs := Seq("org.eclipse.jetty.ee10" % "jetty-ee10-runner" % "12.0.10" intransitive())
Jetty / containerMain := "org.eclipse.jetty.ee10.runner.Runner"
