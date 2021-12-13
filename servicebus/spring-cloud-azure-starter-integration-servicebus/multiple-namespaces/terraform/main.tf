terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.75"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.6"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.10.0"
    }
    nullresource = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurecaf_name" "resource_group" {
  name          = var.application_name
  resource_type = "azurerm_resource_group"
  random_length = 5
  clean_input   = true
}

resource "azurerm_resource_group" "main" {
  name     = azurecaf_name.resource_group.result
  location = var.location

  tags = {
    "terraform"        = "true"
    "application-name" = var.application_name
  }
}

# =================== servicebus_01 ================
resource "azurecaf_name" "servicebus_01" {
  name          = var.application_name
  resource_type = "azurerm_servicebus_namespace"
  random_length = 5
  clean_input   = true
}

resource "null_resource" "null" {
  provisioner "local-exec" {
    command = "rm environment_values.sh"
  }
}

resource "azurerm_servicebus_namespace" "servicebus_namespace_01" {
  name                = azurecaf_name.servicebus_01.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  sku            = "Standard"
  zone_redundant = false

  provisioner "local-exec" {
    command = "echo 'export AZURE_SERVICEBUS_NAMESPACE_01=${azurerm_servicebus_namespace.servicebus_namespace_01.name}' >> environment_values.sh"
  }
}

resource "azurerm_servicebus_queue" "application_queue_01" {
  name                = "queue1"
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace_01.name
  resource_group_name = azurerm_resource_group.main.name

  enable_partitioning   = false
  max_delivery_count    = 10
  lock_duration         = "PT30S"
  max_size_in_megabytes = 1024
  requires_session      = false
  default_message_ttl   = "P14D"
}

# =================== servicebus_02 ================
resource "azurecaf_name" "servicebus_02" {
  name          = var.application_name
  resource_type = "azurerm_servicebus_namespace"
  random_length = 5
  clean_input   = true
}

resource "azurerm_servicebus_namespace" "servicebus_namespace_02" {
  name                = azurecaf_name.servicebus_02.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  sku            = "Standard"
  zone_redundant = false

  provisioner "local-exec" {
    command = "echo 'export AZURE_SERVICEBUS_NAMESPACE_02=${azurerm_servicebus_namespace.servicebus_namespace_02.name}' >> environment_values.sh"
  }
}

resource "azurerm_servicebus_queue" "application_queue_02" {
  name                = "queue2"
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace_02.name
  resource_group_name = azurerm_resource_group.main.name

  enable_partitioning   = false
  max_delivery_count    = 10
  lock_duration         = "PT30S"
  max_size_in_megabytes = 1024
  requires_session      = false
  default_message_ttl   = "P14D"
}

# =================== servicebus_03 ================
resource "azurecaf_name" "servicebus_03" {
  name          = var.application_name
  resource_type = "azurerm_servicebus_namespace"
  random_length = 5
  clean_input   = true
}

resource "azurerm_servicebus_namespace" "servicebus_namespace_03" {
  name                = azurecaf_name.servicebus_03.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  sku            = "Standard"
  zone_redundant = false

  provisioner "local-exec" {
    command = "echo 'export AZURE_SERVICEBUS_NAMESPACE_03=${azurerm_servicebus_namespace.servicebus_namespace_03.name}' >> environment_values.sh"
  }
}

resource "azurerm_servicebus_queue" "application_queue_03" {
  name                = "queue1"
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace_03.name
  resource_group_name = azurerm_resource_group.main.name

  enable_partitioning   = false
  max_delivery_count    = 10
  lock_duration         = "PT30S"
  max_size_in_megabytes = 1024
  requires_session      = false
  default_message_ttl   = "P14D"
}

data "azurerm_client_config" "client_config" {
}

resource "azurerm_role_assignment" "servicebus_01_data_owner" {
  scope                = azurerm_servicebus_namespace.servicebus_namespace_01.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = data.azurerm_client_config.client_config.object_id
}

resource "azurerm_role_assignment" "servicebus_02_data_owner" {
  scope                = azurerm_servicebus_namespace.servicebus_namespace_02.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = data.azurerm_client_config.client_config.object_id
}

resource "azurerm_role_assignment" "servicebus_03_data_owner" {
  scope                = azurerm_servicebus_namespace.servicebus_namespace_03.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = data.azurerm_client_config.client_config.object_id
}