---
title: TFNFR16 - Variable Naming Rules
url: /spec/TFNFR16
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
priority: 21160
---

#### ID: TFNFR16 - Category: Code Style - Variable Naming Rules

The naming of a `variable` **SHOULD** follow [HashiCorp's naming rule](https://www.terraform.io/docs/extend/best-practices/naming.html).

`variable` used as feature switches **SHOULD** apply a positive statement, use `xxx_enabled` instead of `xxx_disabled`. Avoid double negatives like `!xxx_disabled`.

Please use `xxx_enabled` instead of `xxx_disabled` as name of a `variable`.
