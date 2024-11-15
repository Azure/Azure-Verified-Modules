---
title: TFNFR37 - Tool Usage by Module Owner
url: /spec/TFNFR37
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
  Lifecycle-BAU
]
priority: 21370
---

#### ID: TFNFR37 - Category: Code Style - Tool Usage by Module Owner

`newres` is a command-line tool that generates Terraform configuration files for a specified resource type. It automates the process of creating `variables.tf` and `main.tf` files, making it easier to get started with Terraform and reducing the time spent on manual configuration.

Module owners **MAY** use `newres` when they're trying to add new `resource` block, attribute, or nested block. They **MAY** generate the whole block along with the corresponding `variable` blocks in an empty folder, then copy-paste the parts they need with essential refactoring.
