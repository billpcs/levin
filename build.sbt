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
      "org.slf4j" % "slf4j-api" % "2.0.20",
      "ch.qos.logback" % "logback-classic" % "1.5.18" % Runtime,
      "org.eclipse.jetty" % "jetty-server" % "12.0.39" % "container;compile",
      "org.eclipse.jetty.ee10" % "jetty-ee10-webapp" % "12.0.39" % "container;compile",
      "org.eclipse.jetty.ee10" % "jetty-ee10-servlet" % "12.0.39" % "container;compile",
      "jakarta.servlet" % "jakarta.servlet-api" % "6.0.0",
      "com.lihaoyi" %% "upickle" % "3.1.0",
      "com.vladsch.flexmark" % "flexmark-all" % "0.64.8",
      "com.github.ben-manes.caffeine" % "caffeine" % "3.1.8",
    ),
  )

enablePlugins(SbtTwirl)
enablePlugins(JettyPlugin)

Test / fork := true

Jetty / containerLibs := Seq("org.eclipse.jetty.ee10" % "jetty-ee10-runner" % "12.0.39" intransitive())
Jetty / containerMain := "org.eclipse.jetty.ee10.runner.Runner"
Jetty / containerPort := 8082

Compile / resourceGenerators += Def.task {
  val source = (Compile / sourceDirectory).value / "webapp"
  val managed = (Compile / resourceManaged).value
  val webFiles = (source ** AllPassFilter).get.filter(_.isFile).map { file =>
    val relative = IO.relativize(source, file).get
    val destination = managed / "webapp" / relative
    IO.copyFile(file, destination)
    destination
  }

  val posts = (Compile / resourceDirectory).value / "posts"
  val index = managed / "posts.index"
  IO.writeLines(index, (posts * AllPassFilter).get.filter(_.isFile).map(_.getName).sorted)
  webFiles :+ index
}.taskValue

Compile / mainClass := Some("space.revithi.JettyLauncher")
assembly / assemblyJarName := "levin.jar"
assembly / assemblyMergeStrategy := {
  case "module-info.class" => MergeStrategy.discard
  case PathList("META-INF", "versions", _, "module-info.class") => MergeStrategy.discard
  case path => (assembly / assemblyMergeStrategy).value(path)
}
