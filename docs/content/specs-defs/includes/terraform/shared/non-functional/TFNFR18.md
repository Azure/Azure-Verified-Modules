---
title: TFNFR18 - Variables with Types
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
  Lifecycle-Maintenance
]
priority: 180
---

#### ID: TFNFR18 - Category: Code Style - Variables with Types

`type` **MUST** be defined for every `variable`. `type` **SHOULD** be as precise as possible, `any` **MAY** only be defined with adequate reasons.

- Use `bool` instead of `string` or `number` for `true/false`
- Use `string` for text
- Use concrete `object` instead of `map(any)`
