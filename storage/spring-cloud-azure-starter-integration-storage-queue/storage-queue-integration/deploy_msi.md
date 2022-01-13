# https://docs.microsoft.com/en-us/azure/spring-cloud/quickstart-deploy-apps?tabs=Azure-CLI&pivots=programming-language-java


az configure --defaults group=rg-servicebusapp-bwmkg spring-cloud=asc-sn-gzh-service

## Deploy with ASC
az extension update --name spring-cloud

### create spring-cloud 5 minutes
az spring-cloud create -n asc-sn-gzh-service -g rg-servicebusapp-bwmkg

### create spring-cloud app
```shell
az spring-cloud app create -n asc-sn-gzh-app-stqueueint -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg --assign-identity
```
### Assign identity and Show identity info
```shell
az spring-cloud app identity assign -n asc-sn-gzh-app-stqueueint -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg

az spring-cloud app identity show -n asc-sn-gzh-app-stqueueint -s asc-sn-gzh-service -g rg-servicebusapp-bwmkg
```

// ACCOUNT_NAME=stintegrationgwrgt

"principalId": "c7a057d9-3992-4299-8cf5-e614f995cf4e",

### update msi
```shell

az role assignment create --assignee "a99deebe-fd34-4f99-8392-8e9a6b72afdb" \
--role "Storage Queue Data Contributor" \
--resource-group "rg-integration-ajyan"

```

### Package and Deploy
```shell
mvn clean package spring-boot:repackage

az spring-cloud app deploy \
--name asc-sn-gzh-app-stqueueint \
-s asc-sn-gzh-service \
-g rg-servicebusapp-bwmkg \
--artifact-path ./target/*.jar  \
--jvm-options="-Xms1024m -Xmx1024m" \
--env ACCOUNT_NAME=stintegrationgwrgt
```

### check log
az spring-cloud app logs --name asc-sn-gzh-app-stqueueint \
                         --resource-group rg-servicebusapp-bwmkg \
                         --service asc-sn-gzh-service \
                         --follow


## Verify
```shell
curl -X POST https://asc-sn-gzh-service-asc-sn-gzh-app-stqueueint.azuremicroservices.io/messages?message=hello -d ""
```
### log from ASC


---

## Deploy with APP Service
### create app
```shell
az webapp create -g rg-app-service-gzh -p ASP-rgappservicegzh-90a8  -n asc-sn-gzh-app-stqueueint --runtime "JAVA|8-jre8"
```

### update env, like  source ./terraform/setup_env.sh

```shell 
az webapp config appsettings set -g rg-app-service-gzh -n asc-sn-gzh-app-stqueueint  \
--settings ACCOUNT_NAME=stintegrationgwrgt
```

### Create managedIdentity for App Service
```shell
az webapp identity assign --name asc-sn-gzh-app-stqueueint --resource-group rg-app-service-gzh
```

### update msi

```shell

az role assignment create --assignee "7609e049-e2bf-46ad-b4a1-4514c56587db" \
--role "Storage Queue Data Contributor" \
--resource-group "rg-integration-ajyan"

```

### Package and deploy
```shell
mvn clean package spring-boot:repackage
az webapp deploy --resource-group rg-app-service-gzh \
 --name asc-sn-gzh-app-stqueueint \
 --src-path ./target/*.jar \
 --type jar
```

### check log
```shell
az webapp log tail --name asc-sn-gzh-app-stqueueint --resource-group rg-app-service-gzh
```

### Verify

```shell
curl -X POST https://asc-sn-gzh-app-stqueueint.azurewebsites.net/messages?message=hello -d ""
```

#### log from App Service
```shell
{"timestamp":"2022-01-13T10:03:22.094664338Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueint_3_8d170e16","message":" 2022-01-13 10:03:22.092  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : linkCredits: '0', expectedTotalCredit: '2'\n"}
{"timestamp":"2022-01-13T10:03:22.095136064Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueint_3_8d170e16","message":" 2022-01-13 10:03:22.094  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : prefetch: '0', requested: '2', linkCredits: '0', expectedTotalCredit: '2', queuedMessages:'1', creditsToAdd: '1', messageQueue.size(): '0'\n"}
{"timestamp":"2022-01-13T10:03:22.098727265Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueint_3_8d170e16","message":" 2022-01-13 10:03:22.098  INFO 150 --- [oundedElastic-3] c.a.m.s.i.ServiceBusReceiveLinkProcessor : Link credits='0', Link credits to add: '1'\n"}
{"timestamp":"2022-01-13T10:03:22.281384860Z","level":"INFO","machineName":"pl1sdlwk0001R1","containerName":"asc-sn-gzh-app-stqueueint_3_8d170e16","message":" 2022-01-13 10:03:22.281  INFO 150 --- [oundedElastic-2] s.s.t.b.ServiceBusTopicBinderApplication : Message 'Hello world, 46' successfully checkpointed\n"}


```
