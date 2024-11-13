---
title: TFNFR12 - Dynamic for Optional Nested Objects
url: /spec/TFNFR12
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
priority: 120
---

#### ID: TFNFR12 - Category: Code Style - Dynamic for Optional Nested Objects

An example from the community:

```terraform
resource "azurerm_kubernetes_cluster" "main" {
  ...
  dynamic "identity" {
    for_each = var.client_id == "" || var.client_secret == "" ? [1] : []

    content {
      type                      = var.identity_type
      user_assigned_identity_id = var.user_assigned_identity_id
    }
  }
  ...
}
```

Please refer to the coding style in the example. Nested blocks under conditions, **SHOULD** be declared as:

```terraform
for_each = <condition> ? [<some_item>] : []
```
