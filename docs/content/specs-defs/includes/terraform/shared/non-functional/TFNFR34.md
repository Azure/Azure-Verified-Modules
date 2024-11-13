---
title: TFNFR34 - Using Feature Toggles
url: /spec/TFNFR34
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
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 340
---

#### ID: TFNFR34 - Category: Code Style - Using Feature Toggles

E.g., our previous release was `v1.2.1`, now we'd like to submit a pull request which contains such new `resource`:

```terraform
resource "azurerm_route_table" "this" {
  location            = local.location
  name                = coalesce(var.new_route_table_name, "${var.subnet_name}-rt")
  resource_group_name = var.resource_group_name
}
```

A user who's just upgraded the module's version would be surprised to see a new resource to be created in a newly generated plan file.

A better approach is adding a feature toggle to be turned off by default:

```terraform
variable "create_route_table" {
  type     = bool
  default  = false
  nullable = false
}

resource "azurerm_route_table" "this" {
  count               = var.create_route_table ? 1 : 0
  location            = local.location
  name                = coalesce(var.new_route_table_name, "${var.subnet_name}-rt")
  resource_group_name = var.resource_group_name
}
```

Similarly, when adding a new argument assignment in a `resource` block, we **SHOULD** use the default value provided by the provider's schema or `null`. We **SHOULD** use `dynamic` block with default omitted configuration when adding a new nested block inside a `resource` block.
