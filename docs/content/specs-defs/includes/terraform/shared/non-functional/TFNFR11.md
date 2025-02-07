---
title: TFNFR11 - Null Comparison Toggle
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR11
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21110
---

## ID: TFNFR11 - Category: Code Style - Null Comparison Toggle

Sometimes we need to ensure that the resources created are compliant to some rules at a minimum extent, for example a `subnet` has to be connected to at least one `network_security_group`. The user **SHOULD** pass in a `security_group_id` and ask us to make a connection to an existing `security_group`, or want us to create a new security group.

Intuitively, we will define it like this:

```terraform
variable "security_group_id" {
  type: string
}

resource "azurerm_network_security_group" "this" {
  count               = var.security_group_id == null ? 1 : 0
  name                = coalesce(var.new_network_security_group_name, "${var.subnet_name}-nsg")
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.new_network_security_group_tags
}
```

The disadvantage of this approach is if the user create a security group directly in the root module and use the `id` as a `variable` of the module, the expression which determines the value of `count` will contain an `attribute` from another `resource`, the value of this very `attribute` is "known after apply" at plan stage. Terraform core will not be able to get an exact plan of deployment during the "plan" stage.

You can't do this:

```terraform
resource "azurerm_network_security_group" "foo" {
  name                = "example-nsg"
  resource_group_name = "example-rg"
  location            = "eastus"
}

module "bar" {
  source = "xxxx"
  ...
  security_group_id = azurerm_network_security_group.foo.id
}
```

For this kind of parameters, wrapping with `object` type is **RECOMMENDED**:

```terraform
variable "security_group" {
  type: object({
    id   = string
  })
  default     = null
}
```

The advantage of doing so is encapsulating the value which is "known after apply" in an object, and the `object` itself can be easily found out if it's `null` or not. Since the `id` of a `resource` cannot be `null`, this approach can avoid the situation we are facing in the first example, like the following:

```terraform
resource "azurerm_network_security_group" "foo" {
  name                = "example-nsg"
  resource_group_name = "example-rg"
  location            = "eastus"
}

module "bar" {
  source = "xxxx"
  ...
  security_group = {
    id = azurerm_network_security_group.foo.id
  }
}
```

This technique **SHOULD** be used under this use case only.
