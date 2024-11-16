---
title: TFNFR4 - Lower snake_casing
url: /spec/TFNFR4
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Naming/Composition,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 21040
---

#### ID: TFNFR4 - Category: Composition - Code Styling - lower snake_casing

Module owners **MUST** use [lower snake_casing](https://wikipedia.org/wiki/Snake_case) for naming the following:

- Locals
- Variables
- Outputs
- Resources (symbolic names)
- Modules (symbolic names)

For example: `snake_casing_example` (every word in lowercase, with each word separated by an underscore `_`)