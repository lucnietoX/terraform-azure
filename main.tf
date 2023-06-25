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
}  