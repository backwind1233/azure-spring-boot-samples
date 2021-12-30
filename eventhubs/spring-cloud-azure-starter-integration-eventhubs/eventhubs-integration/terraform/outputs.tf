output "AZURE_EVENTHUBS_NAMESPACE" {
  value = azurerm_eventhub_namespace.eventhubs_namespace.name
}

output "AZURE_STORAGE_ACCOUNT_NAME" {
  value = azurerm_storage_account.storage_account.name
}

output "AZURE_STORAGE_CONTAINER_NAME" {
  value = azurerm_storage_container.storage_container.name
}