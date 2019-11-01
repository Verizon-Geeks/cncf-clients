Zipkin integration With ODL
  Zipkin a distributed tracing system based on Google Dapper and initially developed by Twitter, 
is a Java-based application that is used for identifying latency issues, provides detailed structured logging of individual requests with span and trace id.

Enabling Zipkin Server
  $ docker run -d -p 9411:9411 openzipkin/zipkin

Access the Zipkin UI
  $ http://localhost:9411

Create a Sample ODL Applicaton

Prerequisites
 Java 8-compliant JDK

 Maven 3.5.2 or later with appropriate Maven settings.xml file 
 $ cp -n ~/.m2/settings.xml{,.orig} ; wget -q -O - https://raw.githubusercontent.com/opendaylight/odlparent/master/settings.xml > ~/.m2/settings.xml

Building a sample module

 using Neon opendaylight-startup-archetype
  $ mvn archetype:generate -DarchetypeGroupId=org.opendaylight.archetypes -DarchetypeArtifactId=opendaylight-startup-archetype \
	-DarchetypeCatalog=remote -DarchetypeVersion=1.1.2-SNAPSHOT
	
 update the properties values for groupId and artifactId

Project structure will be created

 Maven Build the sample project 
  $ mvn clean install -Dcheckstyle.skip=true -DskipTests -Dmaven.javadoc.skip=true

 Edit yang file with sample RPC in sample/api directory
  $ rpc sample-world {
        input {
            leaf hello {
                type string;
            }
        }
        output {
            leaf world {
                type string;
            }
        }
    }

 Build api directory
  $ mvn clean install

 Register the Rpc in org.opendaylight.controller.sal.binding.api.RpcProviderRegistry
  $ BindingAwareBroker.RpcRegistration<SampleService> serviceRegistration = rpcProviderRegistry.addRpcImplementation(SampleService.class, this);

 Implement the Sample Rpc in SampleProvider.java
  @Override
   public ListenableFuture<RpcResult<SampleWorldOutput>> sampleWorld(SampleWorldInput input) {
      SampleWorldOutputBuilder sampleBuilder = new SampleWorldOutputBuilder();
      sampleBuilder.setWorld("Hey " + input.getHello());
      return RpcResultBuilder.success(sampleBuilder.build()).buildFuture();
   }

 Build the whole project
  $ mvn archetype:generate -DarchetypeGroupId=org.opendaylight.archetypes -DarchetypeArtifactId=opendaylight-startup-archetype \
	-DarchetypeCatalog=remote -DarchetypeVersion=1.1.2-SNAPSHOT

Integrating ODL with Zipkin

 add the Zipkin Brave Dependency in impl/pom.xml and features/pom.xml
  $ <dependency>
      <groupId>io.zipkin.zipkin2</groupId>
      <artifactId>zipkin</artifactId>
      <version>2.12.1</version>
    </dependency>
    <dependency>
      <groupId>io.zipkin.reporter2</groupId>
      <artifactId>zipkin-reporter</artifactId>
      <version2.7.15</version>
    </dependency>
    <dependency>
      <groupId>io.zipkin.reporter2</groupId>
      <artifactId>zipkin-sender-urlconnection</artifactId>
      <version>2.7.15</version>
    </dependency>
    <dependency>
      <groupId>io.zipkin.reporter2</groupId>
      <artifactId>zipkin-sender-kafka11</artifactId>
      <version>2.7.15</version>
    </dependency>
    <dependency>
      <groupId>io.zipkin.reporter2</groupId>
      <artifactId>zipkin-sender-okhttp3</artifactId>
      <version>2.7.15</version>
    </dependency>
    <dependency>
      <groupId>io.zipkin.brave</groupId>
      <artifactId>brave</artifactId>
      <version>5.6.1</version>
    </dependency>
    <dependency>
      <groupId>io.zipkin.brave</groupId>
      <artifactId>brave-instrumentation-http</artifactId>
      <version>5.6.1</version>
    </dependency>

 initialize Tracing and Tracer Object
      $ OkHttpSender sender = OkHttpSender.create("http://127.0.0.1:9411/api/v2/spans");
        AsyncReporter<Span> reporter = AsyncReporter.create(sender);
        Tracing tracing = Tracing.newBuilder()
                .localServiceName("sampleapp")
                .spanReporter(reporter)
                .traceId128Bit(false)
                .sampler(Sampler.create(1))
                .build();
        Tracer tracer = tracing.tracer();

 create different spans using the Tracer object where ever required
   $ ScopedSpan span = tracer.startScopedSpan("encode");

 always finish or flush the spans to report them
  $ span.finish();
  you can also add span names, tags and also anotate them

 build the project and Run the Karaf
 $ ./karaf/target/assembly/bin/karaf

 Navigate to http://localhost:8181/apidoc/explorer/index.html[username and password are admin & admin] to send a request to rest api 

 POST /operations/sample:sample-world

 Provide the required input 
  $ {"sample:input": { "hello":"Name"}}

 Output will be something like this
  $ {
     "output": {
       "world": "Hey Name"
     }
   }

 you should be able to see traces and spans for called requests in Zipkin UI




