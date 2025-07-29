# Variables

With this example, you can leverage setting arguments in a variety of ways.

For the resource group, we can set the `name` _explicitly_, while we can use a variable reference to set the `location`:

```
resource "azurerm_resource_group" "example_rg" {
  name     = "learning-terraform-sample-001"
  location = var.location
}
```

The `location` variable is configured as such:
```
variable "location" {
  type        = string
  description = "The location to deploy resources in"
  default = "canadacentral"
}
```
> Note that `"canadacentral"` is the default value.

We can run `terraform plan` and get the following result:
```
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

We can overwrite the default and specify a different value with `.tfvars` files. For example, we have a simple `eastus.tfvars` file for when we want our deployment to be located in East US region:

```
location = "eastus"
```

Let's implement the value of `location` from the `eastus.tfvars` file in our Terraform workflow:

```
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