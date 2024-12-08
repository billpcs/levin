file://<WORKSPACE>/src/main/scala/PostParser.scala
### java.lang.IndexOutOfBoundsException: 0

occurred in the presentation compiler.

presentation compiler configuration:
Scala version: 3.3.3
Classpath:
<WORKSPACE>/src/main/resources [exists ], <WORKSPACE>/.bloop/hello/bloop-bsp-clients-classes/classes-Metals-ZInR9lJuQ0yfKipdapZpqw== [exists ], <HOME>/.cache/bloop/semanticdb/com.sourcegraph.semanticdb-javac.0.10.3/semanticdb-javac-0.10.3.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala3-library_3/3.3.4/scala3-library_3-3.3.4.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/playframework/twirl/twirl-api_3/2.0.6/twirl-api_3-2.0.6.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scalatra/scalatra-jakarta_3/3.1.0/scalatra-jakarta_3-3.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/typelevel/laika-core_3/1.2.1/laika-core_3-1.2.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.14/scala-library-2.13.14.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-xml_3/2.3.0/scala-xml_3-2.3.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scalatra/scalatra-common-jakarta_3/3.1.0/scalatra-common-jakarta_3-3.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scalatra/scalatra-compat-jakarta_3/3.1.0/scalatra-compat-jakarta_3-3.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/slf4j/slf4j-api/2.0.13/slf4j-api-2.0.13.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/github/albfernandez/juniversalchardet/2.4.0/juniversalchardet-2.4.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/apache/commons/commons-text/1.12.0/commons-text-1.12.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-parser-combinators_3/2.4.0/scala-parser-combinators_3-2.4.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-collection-compat_3/2.12.0/scala-collection-compat_3-2.12.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/typelevel/cats-core_3/2.12.0/cats-core_3-2.12.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/ee10/jetty-ee10-webapp/12.0.10/jetty-ee10-webapp-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.14.0/commons-lang3-3.14.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/typelevel/cats-kernel_3/2.12.0/cats-kernel_3-2.12.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-ee/12.0.10/jetty-ee-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-session/12.0.10/jetty-session-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-xml/12.0.10/jetty-xml-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/ee10/jetty-ee10-servlet/12.0.10/jetty-ee10-servlet-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/12.0.10/jetty-server-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/12.0.10/jetty-util-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-security/12.0.10/jetty-security-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/12.0.10/jetty-http-12.0.10.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/eclipse/jetty/jetty-io/12.0.10/jetty-io-12.0.10.jar [exists ]
Options:
-Xsemanticdb -sourceroot <WORKSPACE>


action parameters:
offset: 743
uri: file://<WORKSPACE>/src/main/scala/PostParser.scala
text:
```scala
package space.revithi

import laika.api._
import laika.format._
import laika.ast.Path.Root
import laika.config.LinkValidation
import java.io.File
import java.nio.file.{Files, Paths}
import upickle.default.*

case class PostMetadata(
    title: String,
    time: String,
    tags: List[String] = List.empty,
    cols: Int = 0
) derives ReadWriter

case class Post(
    id: String,
    metadata: PostMetadata,
    contents: String
)

object PostReader {

  def allFiles(): Option[List[java.io.File]] = {
    val projectRoot = System.getProperty("user.dir")
    val dirPath = Paths.get(projectRoot, relativePath).toString
    val directory = new File(dirPath)
    if (directory.exists && directory.isDirectory) {
      directory.listFiles.filter(@@)
    }
  }

  def readPosts(relativePath: String): Array[(String, String)] = {
    val projectRoot = System.getProperty("user.dir")
    val dirPath = Paths.get(projectRoot, relativePath).toString
    val directory = new File(dirPath)
    if (directory.exists && directory.isDirectory) {
      val files = directory.listFiles.filter(_.isFile)
      val files_names = files.map(_.getName)
      files_names.zip(files.map(file => io.Source.fromFile(file).mkString))
    } else {
      println(s"$dirPath does not exist")
      Array.empty[(String, String)]
    }
  }

  def splitMetadataAndContents(post: String): (PostMetadata, String) = {
    val lines = post.split("\n")
    val metadata = lines.head
    val rest = lines.tail.dropWhile(_ == "").mkString("\n")
    (read[PostMetadata](metadata), rest)
  }


  def get(): Map[String,Post] = {
    val transformer = Transformer
      .from(Markdown)
      .to(HTML)
      .using(Markdown.GitHubFlavor)
      .withConfigValue(LinkValidation.Global(excluded = Seq(Root)))
      .build

    val ret = readPosts("src/main/resources/posts/").map { (name, contents) =>
      val (m, c) = splitMetadataAndContents(contents)
      name -> Post(
        id = name,
        metadata = m,
        contents = transformer.transform(c).getOrElse("")
      )
    }.toMap

    println(ret("dpdk"))

    return ret
  }
}

```



#### Error stacktrace:

```
scala.collection.LinearSeqOps.apply(LinearSeq.scala:131)
	scala.collection.LinearSeqOps.apply$(LinearSeq.scala:128)
	scala.collection.immutable.List.apply(List.scala:79)
	dotty.tools.dotc.util.Signatures$.countParams(Signatures.scala:501)
	dotty.tools.dotc.util.Signatures$.applyCallInfo(Signatures.scala:186)
	dotty.tools.dotc.util.Signatures$.computeSignatureHelp(Signatures.scala:94)
	dotty.tools.dotc.util.Signatures$.signatureHelp(Signatures.scala:63)
	scala.meta.internal.pc.MetalsSignatures$.signatures(MetalsSignatures.scala:17)
	scala.meta.internal.pc.SignatureHelpProvider$.signatureHelp(SignatureHelpProvider.scala:51)
	scala.meta.internal.pc.ScalaPresentationCompiler.signatureHelp$$anonfun$1(ScalaPresentationCompiler.scala:436)
```
#### Short summary: 

java.lang.IndexOutOfBoundsException: 0