---
title: TFNFR13 - Default Values with coalesce/try
url: /spec/TFNFR13
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
priority: 130
---

#### ID: TFNFR13 - Category: Code Style - Default Values with coalesce/try

The following example shows how `"${var.subnet_name}-nsg"` **SHOULD** be used when `var.new_network_security_group_name` is `null` or `""`

Good examples:

```terraform
coalesce(var.new_network_security_group_name, "${var.subnet_name}-nsg")
```

```terraform
try(coalesce(var.new_network_security_group.name, "${var.subnet_name}-nsg"), "${var.subnet_name}-nsg")
```

Bad examples:

```terraform
var.new_network_security_group_name == null ? "${var.subnet_name}-nsg" : var.new_network_security_group_name)
```
