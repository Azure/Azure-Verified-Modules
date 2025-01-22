---
title: TFNFR7 - Count & for_each Use
url: /spec/TFNFR7
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21070
---

#### ID: TFNFR7 - Category: Code Style - count & for_each Use

We can use `count` and `for_each` to deploy multiple resources, but the improper use of `count` can lead to [anti pattern](https://github.com/Azure/terraform-robust-module-design/tree/main/looping_for_resources_or_modules/count_index_antipattern).

You can use `count` to create some kind of resources under certain conditions, for example:

```terraform
resource "azurerm_network_security_group" "this" {
  count               = local.create_new_security_group ? 1 : 0
  name                = coalesce(var.new_network_security_group_name, "${var.subnet_name}-nsg")
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = var.new_network_security_group_tags
}
```

The module's owners **MUST** use `map(xxx)` or `set(xxx)` as resource's `for_each` collection, the map's key or set's element **MUST** be static literals.

Good example:

```terraform
resource "azurerm_subnet" "pair" {
  for_each             = var.subnet_map // `map(string)`, when user call this module, it could be: `{ "subnet0": "subnet0" }`, or `{ "subnet0": azurerm_subnet.subnet0.name }`
  name                 = "${each.value}"-pair
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

Bad example:

```terraform
resource "azurerm_subnet" "pair" {
  for_each             = var.subnet_name_set // `set(string)`, when user use `toset([azurerm_subnet.subnet0.name])`, it would cause an error.
  name                 = "${each.value}"-pair
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
```
