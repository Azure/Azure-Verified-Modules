---
title: TFNFR20 - Non-Nullable Defaults for collection values
url: /spec/TFNFR20
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
priority: 200
---

#### ID: TFNFR20 - Category: Code Style - Non-Nullable Defaults for collection values

Nullable **SHOULD** be set to `false` for collection values (e.g. sets, maps, lists) when using them in loops. However for scalar values like string and number, a null value **MAY** have a semantic meaning and as such these values are allowed.
