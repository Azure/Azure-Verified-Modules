---
title: SNFR4 - Unit Tests
url: /spec/SNFR4
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
  Language-Terraform,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 50
---

#### ID: SNFR4 - Category: Testing - Unit Tests

Modules **SHOULD** implement unit testing to ensure logic and conditions within parameters/variables/locals are performing correctly. These tests **MUST** pass before a module version can be published.

Unit Tests test specific module functionality, without deploying resources. Used on more complex modules. In Bicep and Terraform these live in `tests/unit`.
