---
title: TFNFR32 - Alphabetical Local Arrangement
url: /spec/TFNFR32
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
  Lifecycle-BAU
]
priority: 21320
showPage: false
---

#### ID: TFNFR32 - Category: Code Style - Alphabetical Local Arrangement

Expressions in `locals` block **MUST** be arranged alphabetically.

Good examples:

```terraform
locals {
  name = coalesce(var.name, "name")
  tags = merge(var.tags, {
    env = "prod"
  })
}
```

```terraform
locals {
  tags = merge(var.tags, {
    env = "prod"
  })
}

locals {
  name = coalesce(var.name, "name")
}
```
