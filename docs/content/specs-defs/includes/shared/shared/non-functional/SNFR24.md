---
title: SNFR24 - Testing Child, Extension & Interface Resources
url: /spec/SNFR24
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
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 1090
---

#### ID: SNFR24 - Category: Testing - Testing Child, Extension & Interface Resources

Module owners **MUST** test that child, extension and [interface resources](/Azure-Verified-Modules/specs/shared/interfaces/), that are supported by their modules, are tested in E2E tests as per [SNFR2](/Azure-Verified-Modules/specs/shared#id-snfr2---category-testing---e2e-testing) to ensure they deploy and are configured correctly.

These **MAY** be tested in a separate E2E test and **DO NOT** have to be tested in each E2E test.
