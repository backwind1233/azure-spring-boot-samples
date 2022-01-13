# https://docs.microsoft.com/en-us/azure/spring-cloud/quickstart-deploy-apps?tabs=Azure-CLI&pivots=programming-language-java


az configure --defaults group=rg-servicebusapp-bwmkg spring-cloud=asc-sn-gzh-service

az extension update --name spring-cloud
# create spring-cloud 5 minutes
az spring-cloud create -n asc-sn-gzh-service -g rg-servicebusapp-bwmkg
# create spring-cloud app
az spring-cloud app create -n asc-sn-gzh-app-sbmulns -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
# az spring-cloud app create -n asc-sn-gzh-app-sbmulns-key -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
az spring-cloud app identity assign -n asc-sn-gzh-app-sbmulns -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg
# show identity info
az spring-cloud app identity show -n asc-sn-gzh-app-sbmulns -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg

"principalId": "6e7cb84e-7785-4025-8b78-8b72d88b3738",



## ENV
AZURE_SERVICEBUS_NAMESPACE_01=sb-servicebusapp-ldltw AZURE_SERVICEBUS_NAMESPACE_02=sb-servicebusapp-vlwwg

az role assignment create --assignee "f1c01d8b-a2bb-4a9c-92d7-ff65abd65827" \
--role "Storage Blob Data Contributor" \
--resource-group


# deploy
 az spring-cloud app deploy --env AZURE_SERVICEBUS_NAMESPACE_01=sb-servicebusapp-ldltw AZURE_SERVICEBUS_NAMESPACE_02=sb-servicebusapp-vlwwg \
 --name asc-sn-gzh-app-sbmulns \
 --artifact-path ./target/spring-cloud-azure-starter-integration-sample-servicebus-multiple-namespaces-1.0.0.jar  \
 --jvm-options="-Xms1024m -Xmx1024m"


# log
az spring-cloud app logs --name asc-sn-gzh-app-sbmulns \
                         --resource-group rg-servicebusapp-bwmkg \
                         --service asc-sn-gzh-service \
                         --follow

## result
curl -X POST http://localhost:8080/queues?message=hello


log from asc
```


```

## Deploy with APP Service
### create app
```shell
az webapp create -g rg-app-service-gzh -p ASP-rgappservicegzh-90a8  -n asc-sn-gzh-app-sbmulns --runtime "JAVA|8-jre8"
```

### update env, like  source ./terraform/setup_env.sh
```shell 
az webapp config appsettings set -g rg-app-service-gzh -n asc-sn-gzh-app-sbmulns --settings AZURE_SERVICEBUS_NAMESPACE_01=sb-servicebusapp-ldltw AZURE_SERVICEBUS_NAMESPACE_02=sb-servicebusapp-vlwwg 
```

### update msi
// rg-servicebusapp-cjgti
// Azure Service Bus Data Owner

### deploy
```shell
az webapp deploy --resource-group rg-app-service-gzh \
 --name asc-sn-gzh-app-sbmulns \
 --src-path ./target/spring-cloud-azure-starter-integration-sample-servicebus-multiple-namespaces-1.0.0.jar \
 --type jar
```

### Verify

```shell
curl -X POST https://asc-sn-gzh-app-sbmulns.azurewebsites.net/queues?message=hello -d ""
```
### check log
```shell
az webapp log tail --name asc-sn-gzh-app-sbmulns --resource-group rg-app-service-gzh
```

#### log from App Service
```shell
r         : New message received: 'hello'\n"}
{"timestamp":"2022-01-13T08:55:17.361619264Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbmulns_3_8a8e0415","message":" 2022-01-13 08:55:17.361  INFO 150 --- [oundedElastic-2] c.a.s.s.s.QueueReceiveController         : Message 'hello' successfully checkpointed\n"}
{"timestamp":"2022-01-13T08:55:17.377733683Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbmulns_3_8a8e0415","message":" 2022-01-13 08:55:17.377  INFO 150 --- [oundedElastic-2] AbstractAzureServiceClientBuilderFactory : Will configure the default credential for class com.azure.messaging.servicebus.ServiceBusClientBuilder$ServiceBusSenderClientBuilder.\n"}
{"timestamp":"2022-01-13T08:55:17.666777372Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbmulns_3_8a8e0415","message":" 2022-01-13 08:55:17.666 ERROR 150 --- [ctor-executor-3] c.azure.identity.EnvironmentCredential   : EnvironmentCredential authentication unavailable. Environment variables are not fully configured.To mitigate this issue, please refer to the troubleshooting guidelines here at https://aka.ms/azsdk/net/identity/environmentcredential/troubleshoot\n"}
{"timestamp":"2022-01-13T08:55:17.947301927Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbmulns_3_8a8e0415","message":" 2022-01-13 08:55:17.946  INFO 150 --- [ctor-executor-3] c.a.s.s.s.QueueReceiveController         : Message was sent successfully for queue2.\n"}
2022-01-13T08:56:49  No new trace in the past 1 min(s).

```