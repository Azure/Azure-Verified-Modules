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
  Category-Naming/Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 2060
---

#### ID: RMFR8 - Category: Composition - Dependency on child and other resources

A resource module **MAY** contain references to other resource modules, however **MUST NOT** contain references to non-AVM modules nor AVM pattern modules.

See [BCPFR1](/Azure-Verified-Modules/spec/BCPFR1) and [TFFR1](/Azure-Verified-Modules/spec/TFFR1) for more information on this.
