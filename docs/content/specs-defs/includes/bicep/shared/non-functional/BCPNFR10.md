---
title: BCPNFR10 - Test Bicep File Naming
url: /spec/BCPNFR10
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
priority: 11100
---

#### ID: BCPNFR10 - Category: Testing - Test Bicep File Naming

Module owners **MUST** name their test `.bicep` files in the `/tests/e2e/<defaults/waf-aligned/max/etc.>` directories: `main.test.bicep` as the test framework (CI) relies upon this name.
