---
title: SNFR12 - Versions Supported
url: /spec/SNFR12
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Contribution/Support,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Lifecycle-BAU
]
priority: 1150
---

#### ID: SNFR12 - Category: Contribution/Support - Versions Supported

Only the latest released version of a module **MUST** be supported.

For example, if an AVM Resource Module is used in an AVM Pattern Module that was working but now is not. The first step by the AVM Pattern Module owner should be to upgrade to the latest version of the AVM Resource Module test and then if not fixed, troubleshoot and fix forward from the that latest version of the AVM Resource Module onwards.

This avoids AVM Module owners from having to maintain multiple major release versions.