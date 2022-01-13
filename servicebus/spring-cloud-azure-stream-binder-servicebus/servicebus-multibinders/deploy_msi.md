# https://docs.microsoft.com/en-us/azure/spring-cloud/quickstart-deploy-apps?tabs=Azure-CLI&pivots=programming-language-java


az configure --defaults group=rg-servicebusapp-bwmkg spring-cloud=asc-sn-gzh-service

az extension update --name spring-cloud
# create spring-cloud 5 minutes
az spring-cloud create -n asc-sn-gzh-service -g rg-servicebusapp-bwmkg
# create spring-cloud app
az spring-cloud app create -n asc-sn-gzh-app-sbmulbinders -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
# az spring-cloud app create -n asc-sn-gzh-app-sbmulbinders-key -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
az spring-cloud app identity assign -n asc-sn-gzh-app-sbmulbinders -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg
# show identity info
az spring-cloud app identity show -n asc-sn-gzh-app-sbmulbinders -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg

"principalId": "c911aa5e-640a-4957-9365-7dd32c96a341",



## ENV
AZURE_SERVICEBUS_NAMESPACE_01=sb-servicebus-multibinders-xwsig \
AZURE_SERVICEBUS_NAMESPACE_02=sb-servicebus-multibinders-eukso \
AZURE_SERVICEBUS_QUEUE_NAME=que001 \
AZURE_SERVICEBUS_TOPIC_NAME=tpc001 \
AZURE_SERVICEBUS_TOPIC_SUBSCRIPTION_NAME=sub001 \


az role assignment create --assignee "f1c01d8b-a2bb-4a9c-92d7-ff65abd65827" \
--role "Storage Blob Data Contributor" \
--resource-group


rg=rg-servicebus-multibinders-jbqwd


# deploy
 az spring-cloud app deploy --env AZURE_SERVICEBUS_NAMESPACE_01=sb-servicebus-multibinders-xwsig \
                                  AZURE_SERVICEBUS_NAMESPACE_02=sb-servicebus-multibinders-eukso \
                                  AZURE_SERVICEBUS_QUEUE_NAME=que001 \
                                  AZURE_SERVICEBUS_TOPIC_NAME=tpc001 \
                                  AZURE_SERVICEBUS_TOPIC_SUBSCRIPTION_NAME=sub001 \
 --name asc-sn-gzh-app-sbmulbinders \
 --artifact-path ./target/spring-cloud-azure-sample-stream-binder-servicebus-multiple-1.0.0.jar  \
 --jvm-options="-Xms1024m -Xmx1024m"


# log
az spring-cloud app logs --name asc-sn-gzh-app-sbmulbinders \
                         --resource-group rg-servicebusapp-bwmkg \
                         --service asc-sn-gzh-service \
                         --follow

## result
# 如果用msi, 会不会慢;

curl -X POST http://localhost:8080/queues?message=hello


log from asc
```



```


## Deploy with APP Service
### create app
```shell
az webapp create -g rg-app-service-gzh -p ASP-rgappservicegzh-90a8  -n asc-sn-gzh-app-sbmulbinders --runtime "JAVA|8-jre8"
```

### update env, like  source ./terraform/setup_env.sh


```shell 
az webapp config appsettings set -g rg-app-service-gzh -n asc-sn-gzh-app-sbmulbinders --settings AZURE_SERVICEBUS_NAMESPACE_01=sb-servicebus-multibinders-xwsig \
AZURE_SERVICEBUS_NAMESPACE_02=sb-servicebus-multibinders-eukso \
AZURE_SERVICEBUS_QUEUE_NAME=que001 \
AZURE_SERVICEBUS_TOPIC_NAME=tpc001 \
AZURE_SERVICEBUS_TOPIC_SUBSCRIPTION_NAME=sub001
```

### Create managedIdentity for App Service
```shell
az webapp identity assign --name asc-sn-gzh-app-sbmulbinders --resource-group rg-app-service-gzh
```

### update msi
// rg-servicebusapp-bwmkg
// Azure Service Bus Data Owner
```shell

az role assignment create --assignee "9ede5fce-9cbd-4ff3-b07a-c641fa746507" \
--role "Azure Service Bus Data Owner" \
--resource-group "rg-servicebus-multibinders-jbqwd"

```

### Package
```shell
mvn clean package spring-boot:repackage
```

### deploy
```shell
az webapp deploy --resource-group rg-app-service-gzh \
 --name asc-sn-gzh-app-sbmulbinders \
 --src-path ./target/*.jar \
 --type jar
```

### check log
```shell
az webapp log tail --name asc-sn-gzh-app-sbmulbinders --resource-group rg-app-service-gzh
```

### Verify

```shell

```

#### log from App Service
```shell

 [oundedElastic-4] c.a.m.s.i.ServiceBusReceiveLinkProcessor : prefetch: '0', requested: '2', linkCredits: '0', expectedTotalCredit: '2', queuedMessages:'1', creditsToAdd: '1', messageQueue.size(): '0'\n"}
{"timestamp":"2022-01-13T09:19:11.352117267Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbmulbinders_3_6a30fe92","message":" 2022-01-13 09:19:11.351  INFO 150 --- [oundedElastic-4] c.a.m.s.i.ServiceBusReceiveLinkProcessor : Link credits='0', Link credits to add: '1'\n"}
{"timestamp":"2022-01-13T09:19:11.464014105Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbmulbinders_3_6a30fe92","message":" 2022-01-13 09:19:11.463  INFO 150 --- [oundedElastic-2] m.ServiceBusQueueMultiBindersApplication : Message 'Hello world1, 185' successfully checkpointed\n"}
{"timestamp":"2022-01-13T09:19:11.490564567Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbmulbinders_3_6a30fe92","message":" 2022-01-13 09:19:11.480  INFO 150 --- [oundedElastic-3] m.ServiceBusQueueMultiBindersApplication : Message 'Hello world2, 184' successfully checkpointed\n"}

```
