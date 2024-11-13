---
title: TFNFR30 - Handling Deprecated Outputs
url: /spec/TFNFR30
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
priority: 300
---

#### ID: TFNFR30 - Category: Code Style - Handling Deprecated Outputs

Sometimes we notice that the name of certain `output` is not appropriate anymore, however, since we have to ensure forward compatibility in the same major version, its name **MUST NOT** be changed directly. It **MUST** be moved to an independent `deprecated_outputs.tf` file, then redefine a new output in `output.tf` and make sure it's compatible everywhere else in the module.

A cleanup **MAY** be performed to `deprecated_outputs.tf` and other logics related to compatibility during a major version upgrade.
