### scala.meta.internal.mtags.IndexingExceptions$InvalidSymbolException: #

Symbol: #

#### Error stacktrace:

```
scala.meta.internal.mtags.OnDemandSymbolIndex.definition(OnDemandSymbolIndex.scala:52)
	scala.meta.internal.metals.FallbackDefinitionProvider.findInIndex$1(FallbackDefinitionProvider.scala:125)
	scala.meta.internal.metals.FallbackDefinitionProvider.$anonfun$search$15(FallbackDefinitionProvider.scala:132)
	scala.collection.immutable.List.flatMap(List.scala:294)
	scala.meta.internal.metals.FallbackDefinitionProvider.$anonfun$search$3(FallbackDefinitionProvider.scala:131)
	scala.Option.map(Option.scala:242)
	scala.meta.internal.metals.FallbackDefinitionProvider.$anonfun$search$2(FallbackDefinitionProvider.scala:43)
	scala.Option.flatMap(Option.scala:283)
	scala.meta.internal.metals.FallbackDefinitionProvider.$anonfun$search$1(FallbackDefinitionProvider.scala:40)
	scala.Option.flatMap(Option.scala:283)
	scala.meta.internal.metals.FallbackDefinitionProvider.search(FallbackDefinitionProvider.scala:39)
	scala.meta.internal.metals.DefinitionProvider.$anonfun$definition$3(DefinitionProvider.scala:120)
	scala.Option.orElse(Option.scala:477)
	scala.meta.internal.metals.DefinitionProvider.$anonfun$definition$2(DefinitionProvider.scala:120)
	scala.concurrent.impl.Promise$Transformation.run(Promise.scala:467)
	java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1136)
	java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)
	java.base/java.lang.Thread.run(Thread.java:840)
```
#### Short summary: 

scala.meta.internal.mtags.IndexingExceptions$InvalidSymbolException: #