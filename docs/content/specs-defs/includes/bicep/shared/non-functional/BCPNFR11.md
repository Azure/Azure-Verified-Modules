---
title: BCPNFR11 - Test Tooling
url: /spec/BCPNFR11
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Testing,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 110
---

#### ID: BCPNFR11 - Category: Testing - Test Tooling

Module owners **MUST** use the below tooling for unit/linting/static/security analysis tests. These are also used in the AVM Compliance Tests.

- [PSRule for Azure](https://azure.github.io/PSRule.Rules.Azure/)
- [Pester](https://pester.dev/)
  - Some tests are provided as part of the AVM Compliance Tests, but you are free to also use Pester for your own tests.
