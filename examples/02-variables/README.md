# Variables

With this example, you can leverage setting arguments in a variety of ways.

For the resource group, we can set the `name` _explicitly_, while we can use a variable reference to set the `location`:

```
// main.tf

resource "azurerm_resource_group" "example_rg" {
  name     = "learning-terraform-sample-001"
  location = var.location
}
```

## `variable` block

The `location` variable is configured as such:
```
// variables.tf

variable "location" {
  type        = string
  description = "The location to deploy resources in"
  default = "canadacentral"
}
```
> Note that `"canadacentral"` is the default value.

We can run `terraform plan` and get the following result:
```
// terminal 

> terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.example_rg will be created
  + resource "azurerm_resource_group" "example_rg" {
      + id       = (known after apply)
      + location = "canadacentral"
      + name     = "learning-terraform-sample-001"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

## leveraging `tfvars` files

We can overwrite the default and specify a different value with `.tfvars` files. For example, we have a simple `eastus.tfvars` file for when we want our deployment to be located in East US region:

```
// eastus.tfvars

location = "eastus"
```

Let's implement the value of `location` from the `eastus.tfvars` file in our Terraform workflow:

```
// terminal

> terraform plan --var-file=eastus.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.example_rg will be created
  + resource "azurerm_resource_group" "example_rg" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "learning-terraform-sample-001"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

## Environment variables

Environment variables are useful in CI/CD pipelines. You can inject values without creating additional files.

> [!IMPORTANT]
>
> - `TF_VAR_` is a mandatory prefix.
> - the variable name MUST match

```
// terminal

export TF_VAR_<variable-name>=<value>

$env:TF_VAR_<variable-name>=<value>
```

## Hierarchy of variables

Terraform uses the following order of precedence:

1. Any `-var` and `-var-file` options on the command line in the order provided and variables from HCP Terraform
2. Any `*.auto.tfvars` or `*.auto.tfvars.json` files in lexical order
3. The `terraform.tfvars.json` file
4. The `terraform.tfvars` file
5. Environment variables
6. The default argument of the `variable` block
