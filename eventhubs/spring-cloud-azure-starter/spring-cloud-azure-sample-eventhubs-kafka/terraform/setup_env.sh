export AZURE_EVENTHUBS_CONNECTION_STRING=$(terraform -chdir=./terraform output -raw azurerm_eventhub_namespace)