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
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "example_rg" {
  name     = "learning-terraform-002"
  location = "eastus"
}

resource "azurerm_virtual_network" "example_vnet" {
  name = "vnet-tf-002"

  # Attribute reference establishes dependency on the resource group for the virtual network to be created
  # No need to hardcode values if we don't want to - we dont have to change every instance of a particular attribute
  resource_group_name = azurerm_resource_group.example_rg.name
  location            = azurerm_resource_group.example_rg.location

  address_space = ["10.0.0.0/16"]

  /*
  # No need for this depends_on attribute
  # Terraform is smart enough in most cases
  # And we are leveraging attribute references to further establish resource mapping dependencies
  depends_on = [
    azurerm_resource_group.example_rg
  ]
  */
}