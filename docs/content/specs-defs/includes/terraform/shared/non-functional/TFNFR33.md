---
title: TFNFR33 - Precise Local Types
url: /spec/TFNFR33
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
priority: 330
---

#### ID: TFNFR33 - Category: Code Style - Precise Local Types

Precise local types **SHOULD** be used.

Good example:

```terraform
{
  name = "John"
  age  = 52
}
```

Bad example:

```terraform
{
  name = "John"
  age  = "52" # age should be number
}
```
