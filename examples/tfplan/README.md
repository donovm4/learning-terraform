# Saving Terraform Plans (stored locally)

## Default `terraform plan` workflow

After initializing the configuration, we usually run `terraform plan`:

```
Terraform will perform the following actions:

  # azurerm_resource_group.example_rg will be created
  + resource "azurerm_resource_group" "example_rg" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "rg-stored-plan"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Let's play closer attention to the note at the bottom...

> ```Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.```

## How to save a plan

We can use the `-out` flag and specify the name of the plan to generate. For this example, let's use the command `terraform plan -out "test.tfplan"`

Result:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.example_rg will be created
  + resource "azurerm_resource_group" "example_rg" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "rg-stored-plan"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: test.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "test.tfplan"
```

## Apply a saved plan

Run `terraform apply test.tfplan`

```
azurerm_resource_group.example_rg: Creating...
azurerm_resource_group.example_rg: Creation complete after 10s [id=/subscriptions/.../resourceGroups/rg-stored-plan]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## Using saved plan for destroy

Leverage the following command: `terraform plan -destroy -out "test.tfplan"`

Result: 

```
azurerm_resource_group.example_rg: Refreshing state... [id=/subscriptions/.../resourceGroups/rg-stored-plan]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_resource_group.example_rg will be destroyed
  - resource "azurerm_resource_group" "example_rg" {
      - id         = "/subscriptions/.../resourceGroups/rg-stored-plan" -> null
      - location   = "eastus" -> null
      - name       = "rg-stored-plan" -> null
      - tags       = {} -> null
        # (1 unchanged attribute hidden)
    }

Plan: 0 to add, 0 to change, 1 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: test.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "test.tfplan"
```

`terraform apply test.tfplan`

```
azurerm_resource_group.example_rg: Destroying... [id=/subscriptions/.../resourceGroups/rg-stored-plan]
azurerm_resource_group.example_rg: Still destroying... [id=/subscriptions/.../resourceGroups/rg-stored-plan, 10s elapsed]
azurerm_resource_group.example_rg: Destruction complete after 16s

Apply complete! Resources: 0 added, 0 changed, 1 destroyed.
```
