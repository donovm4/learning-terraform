terraform {
  required_version = ">= 1.1.0, >= 1.10.0"
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

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
}

resource "azurerm_resource_group" "example_rg" {
  name     = "rg-remote-terraform-state"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.example_rg.location
  name                = module.naming.virtual_network.name_unique
  resource_group_name = azurerm_resource_group.example_rg.name
}

resource "azurerm_subnet" "private" {
  address_prefixes     = ["192.168.0.0/24"]
  name                 = module.naming.subnet.name_unique
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.example_rg.location
  name                = module.naming.network_security_group.name_unique
  resource_group_name = azurerm_resource_group.example_rg.name
}

resource "azurerm_subnet_network_security_group_association" "private" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.private.id
}

resource "azurerm_network_security_rule" "no_internet" {
  access                      = "Deny"
  direction                   = "Outbound"
  name                        = module.naming.network_security_rule.name_unique
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = 100
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.example_rg.name
  destination_address_prefix  = "Internet"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_subnet.private.address_prefixes[0]
  source_port_range           = "*"
}

module "avm-res-storage-storageaccount" {
  source                        = "Azure/avm-res-storage-storageaccount/azurerm"
  version                       = "0.6.1"
  enable_telemetry              = false
  resource_group_name           = azurerm_resource_group.example_rg.name
  location                      = azurerm_resource_group.example_rg.location
  name                          = "remotestate${module.naming.storage_account.name_unique}"
  account_replication_type      = "LRS"
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  min_tls_version               = "TLS1_2"
  shared_access_key_enabled     = true
  public_network_access_enabled = true
  network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules = ["173.73.57.85"]
    # ip_rules                   = [try(module.public_ip[0].public_ip, var.bypass_ip_cidr)]
    virtual_network_subnet_ids = toset([azurerm_subnet.private.id])
  }
  containers = {
    blob_container0 = {
      name          = "example-remote-backend"
    }
  }
}