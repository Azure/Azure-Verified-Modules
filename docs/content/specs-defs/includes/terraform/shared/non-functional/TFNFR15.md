---
title: TFNFR15 - Variable Definition Order
url: /spec/TFNFR15
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Testing,
  Language-Terraform,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 21150
---

#### ID: TFNFR15 - Category: Code Style - Variable Definition Order

Input variables **SHOULD** follow this order:

1. All required fields, in alphabetical order
2. All optional fields, in alphabetical order

A `variable` without `default` value is a required field, otherwise it's an optional one.
