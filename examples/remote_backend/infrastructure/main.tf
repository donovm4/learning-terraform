terraform {
  required_version = ">= 1.1.0, >= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0, < 5.0.0"
    }
  }
  # Must be specified POST-deployment of storage used for remote
  backend "azurerm" {
    resource_group_name  = "rg-remote-terraform-state"
    container_name       = "example-remote-backend"
    storage_account_name = "remotestatestcaj0"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = var.subscription_id
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

resource "azurerm_resource_group" "example_rg" {
  name     = "rg-remote-infrastructure"
  location = "eastus"
}

