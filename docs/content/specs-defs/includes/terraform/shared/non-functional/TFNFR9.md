---
title: TFNFR9 - Module Block Order
url: /spec/TFNFR9
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
priority: 90
---

#### ID: TFNFR9 - Category: Code Style - Module Block Order

The meta-arguments below **SHOULD** be declared on the top of a `module` block with the following order:

1. `source`
2. `version`
3. `count`
4. `for_each`

blank lines will be used to separate them.

After them will be required arguments, optional arguments, all ranked in alphabetical order.

These meta-arguments below **SHOULD** be declared on the bottom of a `resource` block in the following order:

1. `depends_on`
2. `providers`

Arguments and meta-arguments **SHOULD** be separated by blank lines.
