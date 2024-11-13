---
title: TFNFR19 - Sensitive Data Variables
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
priority: 190
---

#### ID: TFNFR19 - Category: Code Style - Sensitive Data Variables

If `variable`'s `type` is `object` and contains one or more fields that would be assigned to a `sensitive` argument, then this whole `variable` **SHOULD** be declared as `sensitive = true`, otherwise you **SHOULD** extract sensitive field into separated variable block with `sensitive = true`.
