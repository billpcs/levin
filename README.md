# Levin Scalatra

## Build and deploy

On your build machine, run:

```sh
sbt assembly
```

Copy `target/scala-3.3.3/levin.jar` to your server. With Java 17 or newer installed, run:

```sh
java -jar levin.jar
```

The JAR includes embedded Jetty, the posts, and the static assets. It can run
from any working directory. The default HTTP port is 8082. Set `PORT` to
override it:

```sh
PORT=9000 java -jar levin.jar
```

## Local development

Run `sbt ~Jetty/start` and open [http://localhost:8082/](http://localhost:8082/).
