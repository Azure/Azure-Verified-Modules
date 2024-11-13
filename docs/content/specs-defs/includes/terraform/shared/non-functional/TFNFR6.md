---
title: TFNFR6 - Resource & Data Order
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
priority: 60
---

#### ID: TFNFR6 - Category: Code Style - Resource & Data Order

For the definition of resources in the same file, the resources be depended on **SHOULD** come first, after them are the resources depending on others.

Resources have dependencies **SHOULD** be defined close to each other.
