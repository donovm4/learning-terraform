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
  # subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "existing" {
  name = "learning-terraform-003"
}

resource "azurerm_key_vault" "example" {
  name                = "examplekeyvault"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  purge_protection_enabled = false
}
