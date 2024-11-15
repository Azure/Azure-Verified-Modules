---
title: TFNFR29 - Sensitive Data Outputs
url: /spec/TFNFR29
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
priority: 21290
showPage: false
---

#### ID: TFNFR29 - Category: Code Style - Sensitive Data Outputs

`output` block contains confidential data **MUST** declare `sensitive = true`.
