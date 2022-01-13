# https://docs.microsoft.com/en-us/azure/spring-cloud/quickstart-deploy-apps?tabs=Azure-CLI&pivots=programming-language-java


az configure --defaults group=rg-servicebusapp-bwmkg spring-cloud=asc-sn-gzh-service

## Deploy with ASC
az extension update --name spring-cloud

### create spring-cloud 5 minutes
az spring-cloud create -n asc-sn-gzh-service -g rg-servicebusapp-bwmkg

### create spring-cloud app
```shell
az spring-cloud app create -n asc-sn-gzh-app-stqueueoperation -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
```
### Assign identity and Show identity info
```shell
az spring-cloud app identity assign -n asc-sn-gzh-app-stqueueoperation -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg

az spring-cloud app identity show -n asc-sn-gzh-app-stqueueoperation -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg
```


"principalId": "c7a057d9-3992-4299-8cf5-e614f995cf4e",

### update msi
```shell

az role assignment create --assignee "c7a057d9-3992-4299-8cf5-e614f995cf4e" \
--role "Azure Service Bus Data Owner" \
--resource-group "rg-servicebus-topic-binder-gcllv"

```

### Package and Deploy
```shell
mvn clean package spring-boot:repackage

az spring-cloud app deploy \
--name asc-sn-gzh-app-stqueueoperation \
-s asc-sn-gzh-service \
-g rg-servicebusapp-bwmkg \
--artifact-path ./target/*.jar  \
--jvm-options="-Xms1024m -Xmx1024m" \
--env AZURE_SERVICEBUS_NAMESPACE=sb-servicebus-topic-binder-tdiom \
AZURE_SERVICEBUS_TOPIC_NAME=tpc001 \
AZURE_SERVICEBUS_TOPIC_SUBSCRIPTION_NAME=sub001
```

### check log
az spring-cloud app logs --name asc-sn-gzh-app-stqueueoperation \
                         --resource-group rg-servicebusapp-bwmkg \
                         --service asc-sn-gzh-service \
                         --follow

### log from ASC

```
ue, please refer to the troubleshooting guidelines here at https://aka.ms/azsdk/net/identity/environmentcredential/troubleshoot
2022-01-13 10:18:09.107  INFO 1 --- [ctor-executor-2] c.azure.identity.DefaultAzureCredential  : Azure Identity => Attempted credential EnvironmentCredential is unavailable.
2022-01-13 10:18:09.899  INFO 1 --- [ctor-executor-2] c.a.identity.ManagedIdentityCredential   : Azure Identity => Managed Identity environment: AZURE VM IMDS ENDPOINT
2022-01-13 10:18:09.899  INFO 1 --- [ctor-executor-2] c.a.identity.ManagedIdentityCredential   : Azure Identity => getToken() result for scopes [https://servicebus.azure.net/.default]: SUCCESS
2022-01-13 10:18:09.900  INFO 1 --- [ctor-executor-2] c.azure.identity.DefaultAzureCredential  : Azure Identity => Attempted credential ManagedIdentityCredential returns a token
2022-01-13 10:18:09.968  INFO 1 --- [ctor-executor-2] c.a.c.a.i.handler.SendLinkHandler        : onLinkRemoteOpen connectionId[MF_6693d2_1642068821313], entityPath[tpc001], linkName[tpc001tpc001], remoteTarget[null], remoteSource[null], action[waitingForError]
2022-01-13 10:18:09.968  INFO 1 --- [ctor-executor-2] c.a.c.a.i.handler.SendLinkHandler        : onLinkRemoteClose connectionId[MF_6693d2_1642068821313] linkName[tpc001tpc001], errorCondition[null] errorDescription[null]
2022-01-13 10:18:09.969  INFO 1 --- [ctor-executor-2] c.a.c.a.i.ActiveClientTokenManager       : Scheduling refresh token task. scopes[https://servicebus.azure.net/.default]
2022-01-13 10:18:09.969 ERROR 1 --- [ctor-executor-2] c.a.c.a.i.ActiveClientTokenManager       : Error occurred while refreshing token that is not retriable. Not scheduling refresh task. Use ActiveClientTokenManager.authorize() to schedule task again. audience[amqp://sb-servicebus-topic-binder-tdiom.servicebus.windows.net/tpc001] scopes[https://servicebus.azure.net/.default]
period >= 0 required but it was -1477784422000000000
2022-01-13 10:18:09.969  INFO 1 --- [ctor-executor-2] c.a.c.a.implementation.ReactorSession    : connectionId[MF_6693d2_1642068821313] sessionId[tpc001] linkName[tpc001tpc001] Creating a new send link.
2022-01-13 10:18:09.970 ERROR 1 --- [ctor-executor-2] c.a.core.amqp.implementation.RetryUtil   : entityPath[tpc001], partitionId[1]: Sending messages timed out.
connectionId[MF_6693d2_1642068821313] linkName[tpc001tpc001] Cannot publish message when disposed.
2022-01-13 10:18:09.970 ERROR 1 --- [ctor-executor-2] c.a.m.s.ServiceBusSenderAsyncClient      : Error sending batch.
connectionId[MF_6693d2_1642068821313] linkName[tpc001tpc001] Cannot publish message when disposed.
2022-01-13 10:18:09.970  WARN 1 --- [ctor-executor-2] c.a.s.i.handler.DefaultMessageHandler    : GenericMessage [payload=byte[16], headers={contentType=application/json, id=be5fed6c-929f-9206-7306-37e7934c487a, timestamp=1642069088504}] sent failed in async mode due to connectionId[MF_6693d2_1642068821313] linkName[tpc001tpc001] Cannot publish message when disposed.
2022-01-13 10:18:09.972 ERROR 1 --- [ctor-executor-2] reactor.core.publisher.Operators         : Operator called default onErrorDropped

reactor.core.Exceptions$ErrorCallbackNotImplemented: com.azure.messaging.servicebus.ServiceBusException: connectionId[MF_6693d2_1642068821313] linkName[tpc001tpc001] Cannot publish message when disposed.
Caused by: com.azure.messaging.servicebus.ServiceBusException: connectionId[MF_6693d2_1642068821313] linkName[tpc001tpc001] Cannot publish message when disposed.
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
Caused by: java.lang.IllegalStateException: connectionId[MF_6693d2_1642068821313] linkName[tpc001tpc001] Cannot publish message when disposed.
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
az webapp create -g rg-app-service-gzh -p ASP-rgappservicegzh-90a8  -n asc-sn-gzh-app-stqueueoperation --runtime "JAVA|8-jre8"
```

### update env, like  source ./terraform/setup_env.sh


```shell 
az webapp config appsettings set -g rg-app-service-gzh -n asc-sn-gzh-app-stqueueoperation  \
--settings AZURE_SERVICEBUS_NAMESPACE=sb-servicebus-topic-binder-tdiom \
AZURE_SERVICEBUS_TOPIC_NAME=tpc001 \
AZURE_SERVICEBUS_TOPIC_SUBSCRIPTION_NAME=sub001

```

### Create managedIdentity for App Service
```shell
az webapp identity assign --name asc-sn-gzh-app-stqueueoperation --resource-group rg-app-service-gzh
```

### update msi
// rg-servicebus-topic-binder-gcllv
// Azure Service Bus Data Owner
```shell

az role assignment create --assignee "80a9dd67-45ed-4654-8a55-14f4b8227119" \
--role "Azure Service Bus Data Owner" \
--resource-group "rg-servicebus-topic-binder-gcllv"

```

### Package and deploy
```shell
mvn clean package spring-boot:repackage
az webapp deploy --resource-group rg-app-service-gzh \
 --name asc-sn-gzh-app-stqueueoperation \
 --src-path ./target/*.jar \
 --type jar
```

### check log
```shell
az webapp log tail --name asc-sn-gzh-app-stqueueoperation --resource-group rg-app-service-gzh
```

### Verify

```shell
...
New message received: 'Hello world, 2'
...
Message 'Hello world, 2' successfully checkpointed
...
New message received: 'Hello world, 3'
...
Message 'Hello world, 3' successfully checkpointed
...
```

#### log from App Service
```shell
{"timestamp":"2022-01-13T10:03:22.094664338Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueoperation_3_8d170e16","message":" 2022-01-13 10:03:22.092  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : linkCredits: '0', expectedTotalCredit: '2'\n"}
{"timestamp":"2022-01-13T10:03:22.095136064Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueoperation_3_8d170e16","message":" 2022-01-13 10:03:22.094  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : prefetch: '0', requested: '2', linkCredits: '0', expectedTotalCredit: '2', queuedMessages:'1', creditsToAdd: '1', messageQueue.size(): '0'\n"}
{"timestamp":"2022-01-13T10:03:22.098727265Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueoperation_3_8d170e16","message":" 2022-01-13 10:03:22.098  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : Link credits='0', Link credits to add: '1'\n"}
{"timestamp":"2022-01-13T10:03:22.281384860Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueoperation_3_8d170e16","message":" 2022-01-13 10:03:22.281  INFO 150 --- [oundedElastic-2] s.s.t.b.ServiceBusTopicBinderApplication : Message 'Hello world, 46' successfully checkpointed\n"}


```
