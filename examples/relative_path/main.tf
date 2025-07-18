terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0, < 5.0.0"
    }
  }
  backend "local" {
    path = "mystate.tfstate"
  }
}

provider "azurerm" {
  features {

  }
  # Used for local e2e testing
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "example_rg" {
  name     = "learning-terraform-relative-path"
  location = "eastus"
}