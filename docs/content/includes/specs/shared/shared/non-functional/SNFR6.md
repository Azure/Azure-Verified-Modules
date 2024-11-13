---
title: SNFR6 - Static Analysis/Linting Tests
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
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
  Lifecycle-Maintenance
]
type: "posts"
priority: 70
---

#### ID: SNFR6 - Category: Testing - Static Analysis/Linting Tests

Modules **MUST** use static analysis, e.g., linting, security scanning (PSRule, tflint, etc.). These tests **MUST** pass before a module version can be published.

There may be differences between languages in linting rules standards, but the AVM core team will try to close these and bring them into alignment over time.
