terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0, < 5.0.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  # Used for local e2e testing
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "existing" {
  name = "rg-terraform-data-references"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "demo-law"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
