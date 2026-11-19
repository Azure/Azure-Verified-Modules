---
title: TFNFR42 - Required Examples
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR42
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Testing, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TF/CI/Informational # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21420
---

## ID: TFNFR42 - Category: Testing - Required Examples

Terraform module owners **MUST** provide executable examples under direct `examples/<name>/` roots.

| Module class | Required example | Optional example |
| --- | --- | --- |
| Resource | `examples/defaults/` and `examples/waf-aligned/` | Additional examples |
| Pattern | `examples/defaults/` | `examples/waf-aligned/` and additional examples |
| Utility | `examples/defaults/` | `examples/waf-aligned/` and additional examples |

The exact baseline spelling is `defaults`. `default` is retained only for migration compatibility with existing tooling and repositories; new modules **MUST** use `defaults`.

Each required example **MUST**:

- deploy and destroy successfully without interactive input;
- use required and applicable conditional module inputs;
- rely on module defaults for optional inputs not needed by the scenario;
- keep test-harness prerequisites, deployment scope, and dependency resources separate from module scenario inputs;
- keep telemetry controls explicit and separate, including `enable_telemetry` and a required `location` when needed;
- not contain `.e2eignore`.

Terraform submodules **MUST NOT** require separate example trees. Parent examples **MUST** exercise submodule behavior that is part of the module scenario.

The new Terraform composition check may report warnings for missing or misplaced examples. It is advisory only and **MUST NOT** be treated as a merge or release gate. Existing required-example workflow gates remain unchanged.

An example named `waf-aligned` does not prove semantic WAF compliance. The scenario must implement or arrange the applicable recommendations described by [SFR2]({{% siteparam base %}}/spec/SFR2).
