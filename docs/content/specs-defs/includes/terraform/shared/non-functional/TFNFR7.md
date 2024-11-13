---
title: TFNFR7 - Count & for_each Use
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-CodeStyle,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 70
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
