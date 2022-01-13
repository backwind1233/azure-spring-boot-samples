# https://docs.microsoft.com/en-us/azure/spring-cloud/quickstart-deploy-apps?tabs=Azure-CLI&pivots=programming-language-java


az configure --defaults group=rg-servicebusapp-bwmkg spring-cloud=asc-sn-gzh-service

## Deploy with ASC
az extension update --name spring-cloud
### create spring-cloud 5 minutes
az spring-cloud create -n asc-sn-gzh-service -g rg-servicebusapp-bwmkg
### create spring-cloud app
```shell
az spring-cloud app create -n asc-sn-gzh-app-sbquebinder -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
```
### Assign identity
```shell
az spring-cloud app identity assign -n asc-sn-gzh-app-sbquebinder -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg
```
### Show identity info
```shell
az spring-cloud app identity show -n asc-sn-gzh-app-sbquebinder -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg
```

"principalId": "2de0575d-9a6e-4f7d-8a02-7da621d5b8f6",

### update msi
// rg-servicebus-queue-binder-fgwpu
// Azure Service Bus Data Owner
```shell

az role assignment create --assignee "2de0575d-9a6e-4f7d-8a02-7da621d5b8f6" \
--role "Azure Service Bus Data Owner" \
--resource-group "rg-servicebus-queue-binder-fgwpu"

```

###  deploy
```shell
az spring-cloud app deploy \
--name asc-sn-gzh-app-sbquebinder \
-s asc-sn-gzh-service \
-g rg-servicebusapp-bwmkg \
--artifact-path ./target/*.jar  \
--jvm-options="-Xms1024m -Xmx1024m" \
--env AZURE_SERVICEBUS_NAMESPACE=sb-servicebus-queue-binder-lhunw AZURE_SERVICEBUS_QUEUE_NAME=que001 
```


### check log
az spring-cloud app logs --name asc-sn-gzh-app-sbquebinder \
                         --resource-group rg-servicebusapp-bwmkg \
                         --service asc-sn-gzh-service \
                         --follow

### Verify

```shell
...
New message received: 'Hello world, 2'
...
Message 'Hello world, 2' successfully checkpointed
...
...
New message received: 'Hello world, 3'
...
Message 'Hello world, 3' successfully checkpointed
...
...

```



### log from ASC

```

2022-01-13 09:54:32.896  INFO 1 --- [ctor-executor-1] c.a.c.a.implementation.ReactorSession    : connectionId[MF_2fd71d_1642067660719] sessionId[que001] linkName[que001que001] Creating a new send link.
2022-01-13 09:54:32.897 ERROR 1 --- [ctor-executor-1] c.a.core.amqp.implementation.RetryUtil   : entityPath[que001], partitionId[1]: Sending messages timed out.
connectionId[MF_2fd71d_1642067660719] linkName[que001que001] Cannot publish message when disposed.
2022-01-13 09:54:32.898 ERROR 1 --- [ctor-executor-1] c.a.m.s.ServiceBusSenderAsyncClient      : Error sending batch.
connectionId[MF_2fd71d_1642067660719] linkName[que001que001] Cannot publish message when disposed.
2022-01-13 09:54:32.898  WARN 1 --- [ctor-executor-1] c.a.s.i.handler.DefaultMessageHandler    : GenericMessage [payload=byte[14], headers={contentType=application/json, id=38d145bf-767a-a2a1-845f-1c92ff7e694a, timestamp=1642067672446}] sent failed in async mode due to connectionId[MF_2fd71d_1642067660719] linkName[que001que001] Cannot publish message when disposed.
2022-01-13 09:54:32.901 ERROR 1 --- [ctor-executor-1] reactor.core.publisher.Operators         : Operator called default onErrorDropped

reactor.core.Exceptions$ErrorCallbackNotImplemented: com.azure.messaging.servicebus.ServiceBusException: connectionId[MF_2fd71d_1642067660719] linkName[que001que001] Cannot publish message when disposed.
Caused by: com.azure.messaging.servicebus.ServiceBusException: connectionId[MF_2fd71d_1642067660719] linkName[que001que001] Cannot publish message when disposed.
        at com.azure.messaging.servicebus.ServiceBusSenderAsyncClient.mapError(ServiceBusSenderAsyncClient.java:736) ~[azure-messaging-servicebus-7.4.2.jar!/:7.4.2]
        at reactor.core.publisher.Mono.lambda$onErrorMap$31(Mono.java:3676) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxOnErrorResume$ResumeSubscriber.onError(FluxOnErrorResume.java:94) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onError$2(TracingSubscriber.java:63) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onError(TracingSubscriber.java:63) [na:na]
        at reactor.core.publisher.FluxDoOnEach$DoOnEachSubscriber.onError(FluxDoOnEach.java:195) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onError$2(TracingSubscriber.java:63) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onError(TracingSubscriber.java:63) [na:na]
        at reactor.core.publisher.FluxHide$SuppressFuseableSubscriber.onError(FluxHide.java:142) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoPeekTerminal$MonoTerminalPeekSubscriber.onError(MonoPeekTerminal.java:258) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onError$2(TracingSubscriber.java:63) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onError(TracingSubscriber.java:63) [na:na]
        at reactor.core.publisher.SerializedSubscriber.onError(SerializedSubscriber.java:124) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxRetryWhen$RetryWhenMainSubscriber.whenError(FluxRetryWhen.java:225) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxRetryWhen$RetryWhenOtherSubscriber.onError(FluxRetryWhen.java:274) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onError$2(TracingSubscriber.java:63) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onError(TracingSubscriber.java:63) [na:na]
        at reactor.core.publisher.FluxConcatMap$ConcatMapImmediate.innerError(FluxConcatMap.java:309) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxConcatMap$ConcatMapInner.onError(FluxConcatMap.java:873) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.Operators.error(Operators.java:198) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoError.subscribe(MonoError.java:53) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.Mono.subscribe(Mono.java:4338) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxConcatMap$ConcatMapImmediate.drain(FluxConcatMap.java:449) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxConcatMap$ConcatMapImmediate.onNext(FluxConcatMap.java:251) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.EmitterProcessor.drain(EmitterProcessor.java:491) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.EmitterProcessor.tryEmitNext(EmitterProcessor.java:299) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.SinkManySerialized.tryEmitNext(SinkManySerialized.java:100) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.InternalManySink.emitNext(InternalManySink.java:27) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxRetryWhen$RetryWhenMainSubscriber.onError(FluxRetryWhen.java:190) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onError$2(TracingSubscriber.java:63) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onError(TracingSubscriber.java:63) [na:na]
        at reactor.core.publisher.SerializedSubscriber.onError(SerializedSubscriber.java:124) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.SerializedSubscriber.onError(SerializedSubscriber.java:124) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxTimeout$TimeoutMainSubscriber.onError(FluxTimeout.java:219) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onError$2(TracingSubscriber.java:63) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onError(TracingSubscriber.java:63) [na:na]
        at reactor.core.publisher.MonoFlatMap$FlatMapMain.secondError(MonoFlatMap.java:192) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoFlatMap$FlatMapInner.onError(MonoFlatMap.java:259) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.Operators.error(Operators.java:198) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoError.subscribe(MonoError.java:53) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.InternalMonoOperator.subscribe(InternalMonoOperator.java:64) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoFlatMap$FlatMapMain.onNext(MonoFlatMap.java:157) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onNext$1(TracingSubscriber.java:58) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onNext(TracingSubscriber.java:58) [na:na]
        at reactor.core.publisher.FluxHide$SuppressFuseableSubscriber.onNext(FluxHide.java:137) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.FluxPeekFuseable$PeekFuseableSubscriber.onNext(FluxPeekFuseable.java:210) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onNext$1(TracingSubscriber.java:58) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onNext(TracingSubscriber.java:58) [na:na]
        at reactor.core.publisher.FluxHide$SuppressFuseableSubscriber.onNext(FluxHide.java:137) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.Operators$MonoSubscriber.complete(Operators.java:1816) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoFlatMap$FlatMapInner.onNext(MonoFlatMap.java:249) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onNext$1(TracingSubscriber.java:58) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onNext(TracingSubscriber.java:58) [na:na]
        at reactor.core.publisher.Operators$MonoSubscriber.complete(Operators.java:1816) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoFlatMap$FlatMapInner.onNext(MonoFlatMap.java:249) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onNext$1(TracingSubscriber.java:58) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onNext(TracingSubscriber.java:58) [na:na]
        at reactor.core.publisher.FluxMap$MapSubscriber.onNext(FluxMap.java:120) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onNext$1(TracingSubscriber.java:58) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onNext(TracingSubscriber.java:58) [na:na]
        at reactor.core.publisher.FluxMap$MapSubscriber.onNext(FluxMap.java:120) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onNext$1(TracingSubscriber.java:58) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onNext(TracingSubscriber.java:58) [na:na]
        at reactor.core.publisher.MonoIgnoreThen$ThenIgnoreMain.complete(MonoIgnoreThen.java:284) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.publisher.MonoIgnoreThen$ThenIgnoreMain.onNext(MonoIgnoreThen.java:187) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.lambda$onNext$1(TracingSubscriber.java:58) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.withActiveSpan(TracingSubscriber.java:79) [na:na]
        at io.opentelemetry.javaagent.shaded.instrumentation.reactor.TracingSubscriber.onNext(TracingSubscriber.java:58) [na:na]
        at reactor.core.publisher.MonoCreate$DefaultMonoSink.success(MonoCreate.java:160) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at com.azure.core.amqp.implementation.ReactorSession.lambda$createProducer$16(ReactorSession.java:477) ~[azure-core-amqp-2.3.4.jar!/:2.3.4]
        at com.azure.core.amqp.implementation.handler.DispatchHandler.onTimerTask(DispatchHandler.java:34) ~[azure-core-amqp-2.3.4.jar!/:2.3.4]
        at com.azure.core.amqp.implementation.ReactorDispatcher$WorkScheduler.run(ReactorDispatcher.java:205) ~[azure-core-amqp-2.3.4.jar!/:2.3.4]
        at org.apache.qpid.proton.reactor.impl.SelectableImpl.readable(SelectableImpl.java:118) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.reactor.impl.IOHandler.handleQuiesced(IOHandler.java:61) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.reactor.impl.IOHandler.onUnhandled(IOHandler.java:390) ~[proton-j-0.33.8.jar!/:na]
        at com.azure.core.amqp.implementation.handler.CustomIOHandler.onUnhandled(CustomIOHandler.java:41) ~[azure-core-amqp-2.3.4.jar!/:2.3.4]
        at org.apache.qpid.proton.engine.BaseHandler.onReactorQuiesced(BaseHandler.java:87) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.engine.BaseHandler.handle(BaseHandler.java:206) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.engine.impl.EventImpl.dispatch(EventImpl.java:108) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.engine.impl.EventImpl.delegate(EventImpl.java:129) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.engine.impl.EventImpl.dispatch(EventImpl.java:114) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.reactor.impl.ReactorImpl.dispatch(ReactorImpl.java:324) ~[proton-j-0.33.8.jar!/:na]
        at org.apache.qpid.proton.reactor.impl.ReactorImpl.process(ReactorImpl.java:291) ~[proton-j-0.33.8.jar!/:na]
        at com.azure.core.amqp.implementation.ReactorExecutor.run(ReactorExecutor.java:92) ~[azure-core-amqp-2.3.4.jar!/:2.3.4]
        at reactor.core.scheduler.SchedulerTask.call(SchedulerTask.java:68) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at reactor.core.scheduler.SchedulerTask.call(SchedulerTask.java:28) ~[reactor-core-3.4.9.jar!/:3.4.9]
        at java.util.concurrent.FutureTask.run(FutureTask.java:266) ~[na:1.8.0_302]
        at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.access$201(ScheduledThreadPoolExecutor.java:180) ~[na:1.8.0_302]
        at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:293) ~[na:1.8.0_302]
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) ~[na:1.8.0_302]
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) ~[na:1.8.0_302]
        at java.lang.Thread.run(Thread.java:748) ~[na:1.8.0_302]
Caused by: java.lang.IllegalStateException: connectionId[MF_2fd71d_1642067660719] linkName[que001que001] Cannot publish message when disposed.
        at com.azure.core.amqp.implementation.ReactorSender.send(ReactorSender.java:203) ~[azure-core-amqp-2.3.4.jar!/:2.3.4]
        at com.azure.core.amqp.implementation.ReactorSender.send(ReactorSender.java:197) ~[azure-core-amqp-2.3.4.jar!/:2.3.4]
        at com.azure.messaging.servicebus.ServiceBusSenderAsyncClient.lambda$sendInternal$24(ServiceBusSenderAsyncClient.java:679) ~[azure-messaging-servicebus-7.4.2.jar!/:7.4.2]
        at reactor.core.publisher.MonoFlatMap$FlatMapMain.onNext(MonoFlatMap.java:125) ~[reactor-core-3.4.9.jar!/:3.4.9]
        ... 56 common frames omitted



```

---

## Deploy with APP Service
### create app
```shell
az webapp create -g rg-app-service-gzh -p ASP-rgappservicegzh-90a8  -n asc-sn-gzh-app-sbquebinder --runtime "JAVA|8-jre8"
```

### update env, like  source ./terraform/setup_env.sh


```shell 
az webapp config appsettings set -g rg-app-service-gzh -n asc-sn-gzh-app-sbquebinder  \
--settings AZURE_SERVICEBUS_NAMESPACE=sb-servicebus-queue-binder-lhunw \
AZURE_SERVICEBUS_QUEUE_NAME=que001
```

### Create managedIdentity for App Service
```shell
az webapp identity assign --name asc-sn-gzh-app-sbquebinder --resource-group rg-app-service-gzh
```

### update msi
// rg-servicebus-queue-binder-fgwpu
// Azure Service Bus Data Owner
```shell

az role assignment create --assignee "112ec56f-e216-43a2-ab74-f586a52f8a8b" \
--role "Azure Service Bus Data Owner" \
--resource-group "rg-servicebus-queue-binder-fgwpu"

```

### Package
```shell
mvn clean package spring-boot:repackage
```

### deploy
```shell
az webapp deploy --resource-group rg-app-service-gzh \
 --name asc-sn-gzh-app-sbquebinder \
 --src-path ./target/*.jar \
 --type jar
```

### check log
```shell
az webapp log tail --name asc-sn-gzh-app-sbquebinder --resource-group rg-app-service-gzh
```

### Verify

```shell
...
New message received: 'Hello world, 2'
...
Message 'Hello world, 2' successfully checkpointed
...
...
New message received: 'Hello world, 3'
...
Message 'Hello world, 3' successfully checkpointed
...
...

```

#### log from App Service
```shell

 [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : Link credits='0', Link credits to add: '1'\n"}
{"timestamp":"2022-01-13T09:41:32.794277028Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:32.794  INFO 150 --- [oundedElastic-2] s.s.q.b.ServiceBusQueueBinderApplication : Message 'Hello world, 43' successfully checkpointed\n"}
{"timestamp":"2022-01-13T09:41:33.586284859Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:33.585  INFO 150 --- [   scheduling-1] s.s.q.b.ServiceBusQueueBinderApplication : Sending message, sequence 44\n"}
{"timestamp":"2022-01-13T09:41:33.591570865Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:33.591  INFO 150 --- [   scheduling-1] c.a.m.s.ServiceBusSenderAsyncClient      : Sending batch with size[1].\n"}
{"timestamp":"2022-01-13T09:41:33.637440019Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:33.637  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : linkCredits: '0', expectedTotalCredit: '2'\n"}
{"timestamp":"2022-01-13T09:41:33.639875560Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:33.639  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : prefetch: '0', requested: '2', linkCredits: '0', expectedTotalCredit: '2', queuedMessages:'1', creditsToAdd: '1', messageQueue.size(): '0'\n"}
{"timestamp":"2022-01-13T09:41:33.640348088Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:33.637  INFO 150 --- [oundedElastic-2] s.s.q.b.ServiceBusQueueBinderApplication : New message received: 'Hello world, 44'\n"}
{"timestamp":"2022-01-13T09:41:33.641129833Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:33.640  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : Link credits='0', Link credits to add: '1'\n"}
{"timestamp":"2022-01-13T09:41:33.716704106Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbquebinder_2_3f3b678e","message":" 2022-01-13 09:41:33.716  INFO 150 --- [oundedElastic-2] s.s.q.b.ServiceBusQueueBinderApplication : Message 'Hello world, 44' successfully checkpointed\n"}

```
