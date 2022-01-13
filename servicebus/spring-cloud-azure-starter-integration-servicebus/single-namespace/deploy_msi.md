# https://docs.microsoft.com/en-us/azure/spring-cloud/quickstart-deploy-apps?tabs=Azure-CLI&pivots=programming-language-java


az configure --defaults group=rg-servicebusapp-bwmkg spring-cloud=asc-sn-gzh-service

az extension update --name spring-cloud
# create spring-cloud 5 minutes
az spring-cloud create -n asc-sn-gzh-service -g rg-servicebusapp-bwmkg
# create spring-cloud app
az spring-cloud app create -n asc-sn-gzh-app-sbsingns -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
# az spring-cloud app create -n asc-sn-gzh-app-sbsingns-key -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
az spring-cloud app identity assign -n asc-sn-gzh-app-sbsingns -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg
# show identity info
az spring-cloud app identity show -n asc-sn-gzh-app-sbsingns -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg

  "principalId": "62072d57-1d2c-4931-9d17-97bcaefacf36",




## ENV
SERVICEBUS_NAMESPACE=sb-servicebusapp-boxmu

az role assignment create --assignee "f1c01d8b-a2bb-4a9c-92d7-ff65abd65827" \
--role "Storage Blob Data Contributor" \
--resource-group


# deploy
 az spring-cloud app deploy --env SERVICEBUS_NAMESPACE=sb-servicebusapp-boxmu \
 --name asc-sn-gzh-app-sbsingns \
 --artifact-path ./target/spring-cloud-azure-starter-integration-sample-servicebus-1.0.0.jar \
 --jvm-options="-Xms1024m -Xmx1024m"


# log
az spring-cloud app logs --name asc-sn-gzh-app-sbsingns \
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
az webapp create -g rg-app-service-gzh -p ASP-rgappservicegzh-90a8  -n asc-sn-gzh-app-sbsingns --runtime "JAVA|8-jre8"
```

### update env, like  source ./terraform/setup_env.sh
```shell 
az webapp config appsettings set -g rg-app-service-gzh -n asc-sn-gzh-app-sbsingns --settings SERVICEBUS_NAMESPACE=sb-servicebusapp-boxmu
```

### Create managedIdentity for App Service
```shell
az webapp identity assign --name myApp --resource-group myResourceGroup
```

### update msi
// rg-servicebusapp-bwmkg
// Azure Service Bus Data Owner

### deploy
```shell
az webapp deploy --resource-group rg-app-service-gzh \
 --name asc-sn-gzh-app-sbsingns \
 --src-path ./target/*.jar \
 --type jar
```

### check log
```shell
az webapp log tail --name asc-sn-gzh-app-sbsingns --resource-group rg-app-service-gzh
```

### Verify

```shell
curl -X POST https://asc-sn-gzh-app-sbsingns.azurewebsites.net/queues?message=hellowww -d ""
```

#### log from App Service
```shell
ndedElastic-4] c.a.m.s.i.ServiceBusReceiveLinkProcessor : Link credits='0', Link credits to add: '1'\n"}
{"timestamp":"2022-01-13T09:06:13.293105906Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbsingns_3_2e0baeb5","message":" 2022-01-13 09:06:13.289  INFO 150 --- [oundedElastic-2] o.s.i.h.s.MessagingMethodInvokerHelper   : Overriding default instance of MessageHandlerMethodFactory with provided one.\n"}
{"timestamp":"2022-01-13T09:06:13.404040372Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbsingns_3_2e0baeb5","message":" 2022-01-13 09:06:13.403  INFO 150 --- [oundedElastic-2] c.a.s.s.s.QueueReceiveController         : New message received: 'hellowww'\n"}
{"timestamp":"2022-01-13T09:06:13.536267782Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-sbsingns_3_2e0baeb5","message":" 2022-01-13 09:06:13.535  INFO 150 --- [oundedElastic-2] c.a.s.s.s.QueueReceiveController         : Message 'hellowww' successfully checkpointed\n"}

```
