# Learning Path for IaC, Terraform, AVM

> Acronyms  
> LP - *Learning Path*  
> IaC - *Infrastructure-as-Code*  
> AVM - *Azure Verified Modules*  
> ARM - *Azure Resource Manager*  
> HCL - *HashiCorp Configuration Language*

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
- consistency across development, staging, and production environments (also disaster recovery scenarios)
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

> For this portion of the LP, I will be leveraging the [Fundamentals of Terraform on Azure]() LP, [Hashicorp Terraform Documentation](), and [Hashicorp Terraform Tutorial](). Feel free to clone this repo and make your own notes if that fits your learning style.

### What is Terraform?

`Terraform` uses **HashiCorp Configuration Language (HCL)**, which *declaratively* deploys resources and is intended to be easy to learn and understand.

> HCL is a **domain-specific language**, meaning that it is designed for a target scenario, environment, or *domain*

Terraform Products:
- Business Source License (BSL)
  - free
  - includes the Terraform CLI
- Terraform Enterprise
- Terraform Cloud

> Although there are multiple related Terraform products, BSL includes the `Terraform CLI` which is the only tool you need to deploy Terraform.

#### Terraform CLI

- focuses on managing state and plan deployments
- has no *knowledge* regarding any cloud or API inherently

Terraform `providers` are responsible for connecting the `Terraform CLI` with the target API. Think of providers as a type of *plug-in*.  

`Providers` are loaded into the `Terraform CLI` during the `terraform init` phase based on the requirements set in the configuration. 
  - **resources** are managed with Terraform
  - **data sources** are used to read attributes of an existing resource, regardless of what is managing it.

> Providers MUST be written in `Go` programming languange

Microsoft and HashiCorp/Community curated providers:
- [`azurerm`](): This is the most user firendly way to deploy Azure resources. This provider is managed by HashiCorp so there may be a delay in support for new features.
-  [`azapi`](): This is closer to writing in JSON. The main benefit I've identified is being able to deploy almost any Azure resource, including selecting the API version. This is important in cases where you need to take advantage of Preview features or properties that may not be accessible through the `azurerm` provider.
- [`azuread`]():
- [`azuredevops`]():
- [`github`]():

> The main ones to focus on are `azurerm` and `azapi`.

##### Multiple Provider Configurations

```terraform
# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
```

#### Terraform Workflow

Five fundamental steps:

1. **Scope**, or identify the infrastructure for your project
2. **Write** your configuration code
3. **Initialize**: run `terraform init` to pull down providers and modules, and create or connect to the current state; generates the `terraform.lock.hcl` file
4. **Plan**: run `terraform plan`to generate a plan for how the actual state will align with the desired state. 
    > queries deployed resources (if any) and compares to the configuration
5. **Apply**: run `terraform apply` to implement desired state configuration of target environment via API call(s).
    > `terraform apply -auto-approve` will skip confirmation check

Other help commands to know:

- `terraform fmt` formats your configuration file(s); returns the name of files it modifies, if any.
- `terraform validate` allows you to validate if your configuration is syntatically valid and consistent
- `terraform show` allows you to inspect the current state with resource properties and meta-data.
- `terraform state list` shows a list of resource created in the state
  > `terraform state` will show a full of available subcommands and options

#### Terraform Lifecycle

Three stages:

1. **Create**
    - resource is specified in configuration
    - resource does not yet exist in state
    - resource will be created in Azure (in our case)
2. **Update**
    - the configuration does not match the state
    - the resource will be updated to align configuration and state
    > The update step can happen many times over the lifetime of a resource/environment.
3. **Destroy**
    - the resource no longer exists in the configuration OR the state is set to be destroyed
    - the resource will be deleted from:
      - state
      - Azure

### Writing a Configuration

#### Terraform Block

The `terraform` block contains `Terraform` settings. This is where you specify the required `providers` that `Terraform` will use to provision the infrastructure.

- You can define `version constraints` for `Terraform` by using `required_version`
- It is possible to define `version constraints` for each provider in the `required_providers` block. 
  - `version` is an optional attribute, but HashiCorp recommends using it to enforce the `provider` version. If `version` is not set, `Terraform` will *always* use the latest version of the `provider`, which may introduce **breaking changes** to your configuration/infrastructure.

#### Version Constraint syntax

- A `version constraint` is a `string literal` that can have one or more `conditions` separated by commas.  
- Each condition has an `operator` and a `version number`.

```
version = "<operator> <version>"
```

#### Operators

`=`: allows only the exact version number and cannot be combined with another condition  
`!=`: excludes an exact version number  
`>`: allows for newer versions than the specified version number  
`>=`: allows for equal or newer versions than the specified version number  
`<`: allows for older versions than the specified version number  
`<=`: allows for equal or older versions than the specified version number  
`~>`: allows only the right-most component of the version specified to increment.

  > Semantic versioning (`x.y.z`)  
  > Major (`x`)
  > Minor (`y`)  
  > Patch (`z`)  



```
terraform {
  required_version = "<operator> <version>"

  # If there are any required providers...
  required_providers {
    <provider> = {
        source = "<source>"
        version = "<operator> <version>"
    }
  }
}
```

#### Provider Block

The `provider` block configures the specific provider. You can define multiple provider blocks in a configuration if you need to manage resources from different providers

```
terraform {
  .
  ..
  ...
}

provider "<provider>" {
  features {}
}
```

#### Resource Block

`resource` blocks define components of the infrastructure. There are two strings that should be before the block:
1. type of resource 
    - specified by provider 
2. name of the resource 
    - for mapping in state
    > Not necessarily the name that you will see in the GUI

`resource` blocks contain `arguments` which you use to configure the resource.

```
terraform {
  ...
}

provider "<provider>" {
  ...
}

resource "<type>" "<name>" {
  attribute = <value>
}

```

#### Complete configuration

```
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
  subscription_id = "12345"
}

resource "azurerm_resource_group" "example_rg" {
  name     = "learning-terraform-001"
  location = "eastus"
}
```

### ARM vs Terraform State

#### ARM

- service that is used to deploy and manage resources in Azure
- use **Bicep** or **ARM templates**
- **declarative** templates translates into idempotent commands (create, update, delete)
- state is stored in Azure
- Azure ONLY
- uses `What If` to detect configuration updates

#### Terraform State

> `Terraform` is a **cloud-agnostic** tool that can support anything with an API endpoint, therefore requiring agnostic method of lifecycle management of resources

- JSON-based representation of resources managed with `Terraform`
- maps resource declaration to the ID of the resource in a target environment
- uses `terraform plan` to detect configuration updates
- required to support the `Terraform` lifecycle

> **State files can contain sensitive data.** Users should consider storing securely.

#### Benefits of Terraform over ARM

- simpler syntax
- deployments/configurations can be broken into modules for easier mangament and greater reusability
- automatic dependect management
- VS Code extensions feature validation and IntellisSense for easier authoring experience

#### Benefits of public Terraform Registry Modules

- centralized repository
- community-driven
- versioned and documented
- easy to find
- well-maintained
- reuseable

## Azure Verified Modules (AVM)

> For this portion of the LP, I will be leveraging the [AVM Documentaion](aka.ms/avm) LP and taking notes. Feel free to clone this repo and make your own notes if that fits your learning style.

# All Resources

## Whizlabs
- [HashiCorp Certified Terraform Associate](https://www.whizlabs.com/hashicorp-certified-terraform-associate/)