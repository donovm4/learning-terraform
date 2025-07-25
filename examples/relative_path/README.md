# Relative Path

- This is a sample configuration that creates the state file at a custom local path.

## Main portion of configuration

```
terraform {
  required_version = "..."
  required_providers {
    ...
  }
  backend "local" {
    path = "[desired/path/of/state]"
  }
}
```