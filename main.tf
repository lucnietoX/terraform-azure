# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "RG_Dev"
  location = "westus2"
}

resource "azurerm_data_factory" "adf-dev" {
    name = "adf-dev-idlnxp"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    tags = {
    Environment = "Development"
  }
}  


resource "azurerm_storage_account" "adl-dev" {
    name                     = "adldevidlnxp"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    is_hns_enabled           = "true"
    tags = {
    Environment = "Development"
  }
}

resource "azurerm_databricks_workspace" "adb-dev" {
  name                = "adbdevidlnxp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  tags = {
    Environment = "Development"
  }
}

resource "azurerm_databricks_cluster" "cls01" {
  name                      = "cls01"
  resource_group_name       = azurerm_databricks_workspace.adb-dev.resource_group_name
  location                  = azurerm_databricks_workspace.adb-dev.location
  workspace_resource_id     = azurerm_databricks_workspace.adb-dev.id
  node_type_id              = "Standard_DSv2"
  num_workers               = 2
  auto_scale {
    min_workers = 1
    max_workers = 3
  }
}