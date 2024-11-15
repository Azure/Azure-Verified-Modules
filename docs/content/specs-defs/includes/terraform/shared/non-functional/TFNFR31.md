---
title: TFNFR31 - locals.tf for Locals Only
url: /spec/TFNFR31
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
  Severity-MAY,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 21310
---

#### ID: TFNFR31 - Category: Code Style - locals.tf for Locals Only

In `locals.tf`, file we could declare multiple `locals` blocks, but only `locals` blocks are allowed.

You **MAY** declare `locals` blocks next to a `resource` block or `data` block for some advanced scenarios, like making a fake module to execute some light-weight tests aimed at the expressions.
