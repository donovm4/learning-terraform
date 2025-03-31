# Referencing existing resources

You can reference existing resources. In this configuration, we are targeting the resource we created in `run_1`. This resource group is managed outside of the `run_2` state file. Using the data source, **we are not managing / importing the resource** into the state - just referencing it.

`run_1` / `main.tf`:
```
data "azurerm_resource_group" "existing" {
  name = "learning-terraform-003"
}
```

You can then reference the object(s) for other tasks, like creating a key vault.  

`run_2` / `main.tf`:
```
resource "azurerm_key_vault" "example" {
  name = "examplekeyvault"
  location = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id

  purge_protection_enabled = false
}
```

Result:
```
run_2: ✗ terraform apply
data.azurerm_client_config.current: Reading...
data.azurerm_resource_group.existing: Reading...
data.azurerm_client_config.current: Read complete after 0s [id=...]
data.azurerm_resource_group.existing: Read complete after 0s [id=/subscriptions/.../resourceGroups/learning-terraform-003]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_key_vault.example will be created
  + resource "azurerm_key_vault" "example" {
      + access_policy                 = (known after apply)
      + id                            = (known after apply)
      + location                      = "eastus"
      + name                          = "examplekeyvault"
      + public_network_access_enabled = true
      + purge_protection_enabled      = false
      + resource_group_name           = "learning-terraform-003"
      + sku_name                      = "standard"
      + soft_delete_retention_days    = 90
      + tenant_id                     = "5de15217-9086-4c93-b391-8ff6593435b4"
      + vault_uri                     = (known after apply)

      + contact (known after apply)

      + network_acls (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```