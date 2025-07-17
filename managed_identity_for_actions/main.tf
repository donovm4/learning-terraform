terraform {
  required_version = ">= 1.1.0, >= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0, < 5.0.0"
    }
  }

  # Must be specified POST-deployment of storage used for remote
#   backend "azurerm" {
#     resource_group_name  = "rg-remote-terraform-state"
#     container_name       = "prod-remote"
#     storage_account_name = "remotestatesteo2v"
#     key                  = "terraform.tfstate"
#   }
}

provider "azurerm" {
  features {

  }
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg-github-actions" {
  name     = "rg-github-actions"
  location = "eastus"
}

resource "azurerm_user_assigned_identity" "donovm4" {
  location            = azurerm_resource_group.rg-github-actions.location
  name                = "terraform_github"
  resource_group_name = azurerm_resource_group.rg-github-actions.name
}