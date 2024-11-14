---
title: TFNFR5 - Test Tooling
url: /spec/TFNFR5
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
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 21050
---

#### ID: TFNFR5 - Category: Testing - Test Tooling

Module owners **MUST** use the below tooling for unit/linting/static/security analysis tests. These are also used in the AVM Compliance Tests.

- [Terraform](https://www.terraform.io/)
  - `terraform <validate/fmt/test>`
- [terrafmt](https://github.com/katbyte/terrafmt)
- [Checkov](https://www.checkov.io/)
- [tflint (with azurerm ruleset)](https://github.com/terraform-linters/tflint-ruleset-azurerm)
- [Go](https://go.dev/)
  - Some tests are provided as part of the AVM Compliance Tests, but you are free to also use Go for your own tests.
