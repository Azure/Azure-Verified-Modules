---
title: TFNFR6 - Resource & Data Order
url: /spec/TFNFR6
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
  Lifecycle-BAU
]
priority: 21060
---

#### ID: TFNFR6 - Category: Code Style - Resource & Data Order

For the definition of resources in the same file, the resources be depended on **SHOULD** come first, after them are the resources depending on others.

Resources that have dependencies **SHOULD** be defined close to each other.
