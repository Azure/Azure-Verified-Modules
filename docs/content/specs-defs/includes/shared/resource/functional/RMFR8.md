---
title: RMFR8 - Dependency on child and other resources
url: /spec/RMFR8
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Type-Functional,
  Category-Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
---

#### ID: RMFR8 - Category: Composition - Dependency on child and other resources

A resource module **MAY** contain references to other resource modules, however **MUST NOT** contain references to non-AVM modules nor AVM pattern modules.

See [BCPFR1](/Azure-Verified-Modules/specs/bicep/#id-bcpfr1---category-composition---cross-referencing-modules) and [TFFR1](/Azure-Verified-Modules/specs/terraform/#id-tffr1---category-composition---cross-referencing-modules) for more information on this.
