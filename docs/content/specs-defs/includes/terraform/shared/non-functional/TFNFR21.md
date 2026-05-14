---
title: TFNFR21 - Discourage Nullability by Default
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR21
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21210
---

## ID: TFNFR21 - Category: Code Style - Discourage Nullability by Default

`nullable = true` **MUST** be avoided.

Variables **MUST** be declared with `nullable = false` whenever the variable's type has a meaningful zero value (`{}` for objects/maps, `[]` for lists/sets, `""` for strings where empty has the same meaning as absent, etc.). Consumers should signal "no value" by omitting the input, not by explicitly passing `null`.

### Exception — behavior-toggle inputs

A small, well-defined class of inputs **MAY** keep the implicit `nullable = true` (i.e. `default = null`) where `null` carries a distinct semantic meaning of *"no override — use the underlying provider/AVM defaults"*, and where representing that state with the type's zero value would be ambiguous or wrong. Examples include:

- `var.retry` and `var.timeouts` (per [TFFR7]({{% siteparam base %}}/spec/TFFR7)) — `null` means "do not emit a `retry`/`timeouts` block; use the AzAPI provider defaults".
- `var.lock` (per the AVM lock interface) — `null` means "do not create a management lock".
- Optional sub-objects that toggle whole feature blocks on/off, where `{}` would be indistinguishable from "feature enabled with all defaults".

Where this exception applies, the variable **MUST**:

- Use `default = null` (the implicit `nullable = true` is permitted only for this purpose).
- State explicitly in its `description` what `null` means.
- Be consumed with a `null`-aware pattern (e.g. `count = var.lock != null ? 1 : 0`, or `dynamic "timeouts" { for_each = var.timeouts == null ? [] : [var.timeouts] }`).

This exception does **not** extend to required inputs, to collection-shaped inputs ([TFNFR20]({{% siteparam base %}}/spec/TFNFR20)), or to nested attributes inside an object — those **MUST** use `nullable = false` and the type's zero value.
