---
title: TFNFR14 - Not allowed variables
url: /spec/TFNFR14
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Inputs/Outputs,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 21140
---

#### ID: TFNFR14 - Category: Inputs - Not allowed variables

Since Terraform 0.13, `count`, `for_each` and `depends_on` are introduced for modules, module development is significantly simplified. Module's owners **MUST NOT** add variables like `enabled` or `module_depends_on` to control the entire module's operation. Boolean feature toggles are acceptable however.
