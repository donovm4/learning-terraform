# Learning Path for IaC, Terraform, AVM

> Acronyms  
> LP - *Learning Path*  
> IaC - *Infrastructure-as-Code*  
> AVM - *Azure Verified Modules*

## Infrastructure as Code (IaC)

`IaC` is the process of automating your infrastructure provisioning, which can decrease user errors and increase efficiency and repeatability.  
- uses **declarative** coding language, so when users deploy a configuration, it generates the same result on each compilation (known as idempotency)
- Users can leverage version control


> `Idempotency`: the ability to apply `N` number of operations against a resource that will still result in the same configuration/outcome.

#### Manual versus IaC configuration management

From a manual approach, one would have to really focus on the manual steps fo setting up an individual instance of a resource, let alone `N` number of instances.  

From an IaC approach, it is easier for users to provision `N` number of instances and maintain consistency across the environment. The focuses here are:
- scalability
- traceability when auditing configurations/deployments
- consistency across development, staging, and production environments
- version control, code review, and unit-testing capabilities

These points can ultimately be summed up as ease of use, reduction of human error, and repeatability

#### Declarative versus Imperative

`Declarative` (functional) states *what* the final state should be, without defining steps on *how* that final state should be achieved. This is generally the best approach where ease of use is the primary goal.

Example
```
resource "azurerm_resource_group" "example" {
  name     = "storage-resource-group"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                      = "mystorageaccount"
  location                  = azurerm_resource_group.example.location
  resource_group_name       = azurerm_resource_group.example.name
  sku                       = "Standard"
  account_replication_type  = "GRS"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  enable_https_traffic_only = true
}
```

`Imperative` (procedural) defines the *how* (each ordered step) and the *what* for the final state to be achieved. This is generally the best approach where addressing frequently complex configuration changes is the primary goal.

```
#!/usr/bin/env bash

az group create --name storage-resource-group --location eastus

az storage account create --name mystorageaccount --resource-group storage-resource-group --location eastus --sku Standard_LRS --kind StorageV2 --access-tier Hot --https-only true
```

> In this case, you would not be able to specify thge storage account before specifying the resource group first.
### DevOps practices

> For this portion of the LP, I will be leveraging [John Savill's DevOps Master Class]() and [AZ-400](). Feel free to clone this repo and make your own notes if that fits your learning style.

#### What is DevOps?

- *Continuous delivery* of value by unionizing people, processes, and products.
- Clear communication of goals
- Moving to automation rather than relying on manual steps of deployment prcesses
- Identification and use of proper tools for continuous cycles
- Continuous delivery (or development), continuous improvement

Business units focus on *value*.  
Developer units focus on *innovation*.  
Operations units focus on *stability*.  



#### Azure DevOps



#### Vocab words and concepts that don't have a clear section yet:



`Circular dependency`: indicates there is an issue with dpendency sequencing causing an infinite loop, meaning the deployment becomes unable to continue.

## Terraform

> For this portion of the LP, I will be leveraging the [Fundamentals of Terraform]() LP, [Hashicorp Terraform Documentation](), and [Hashicorp Terraform Tutorial](). Feel free to clone this repo and make your own notes if that fits your learning style.



## Azure Verified Modules (AVM)

> For this portion of the LP, I will be leveraging the [AVM Documentaion](aka.ms/avm) LP and taking notes. Feel free to clone this repo and make your own notes if that fits your learning style.