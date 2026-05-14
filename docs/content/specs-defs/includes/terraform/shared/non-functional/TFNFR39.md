---
title: TFNFR39 - Standard File Layout
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR39
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
priority: 21390
---

## ID: TFNFR39 - Category: Code Style - Standard File Layout

Every Terraform AVM module (root module *and* every submodule) **MUST** organize its top-level Terraform code into the following files at the module's root directory:

| File            | Required   | Contents                                                                                                                                              |
| --------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `terraform.tf`  | **MUST**   | The single `terraform { … }` block — `required_version`, `required_providers`, and any backend configuration (root module only). Provider configuration blocks **MUST NOT** appear here. |
| `variables.tf`  | **MUST**   | All `variable` blocks for the module. **MAY** be split into additional `variables.<topic>.tf` files (see below).                                     |
| `outputs.tf`    | **MUST**   | All `output` blocks for the module. **MAY** be split into additional `outputs.<topic>.tf` files (see below).                                          |
| `main.tf`       | **MUST**   | The module's primary `resource`, `data`, and `module` blocks. **MAY** be split into additional `main.<topic>.tf` files (see below).                   |
| `locals.tf`     | **SHOULD** | All `locals` blocks. Required if the module declares any `locals`. **MAY** be split into additional `locals.<topic>.tf` files (see below). **MAY** be omitted only when the module has no locals at all. |

### Splitting and naming additional files

For larger modules the contents of `main.tf`, `variables.tf`, `outputs.tf`, and `locals.tf` **MAY** each be split into multiple files along logical / topic lines. When this is done:

- Additional Terraform files **MUST** use the canonical filename (`main`, `variables`, `outputs`, or `locals`) as the prefix, followed by a `.`, a short descriptive topic name, and the `.tf` extension — for example `main.diagnostic_settings.tf`, `variables.diagnostic_settings.tf`, `outputs.diagnostic_settings.tf`, `locals.diagnostic_settings.tf`.
- The topic name **MUST** be `snake_case` (per [TFNFR3]({{% siteparam base %}}/spec/TFNFR3)).
- The same topic name **SHOULD** be used across the four file types when they describe the same logical concern, so that (for example) `main.private_endpoints.tf`, `variables.private_endpoints.tf`, `outputs.private_endpoints.tf`, and `locals.private_endpoints.tf` all relate to the same feature.
- Each split file **MUST** contain only the block kind matching its prefix:
  - `main.<topic>.tf` — only `resource`, `data`, and `module` blocks.
  - `variables.<topic>.tf` — only `variable` blocks.
  - `outputs.<topic>.tf` — only `output` blocks.
  - `locals.<topic>.tf` — only `locals` blocks.
- The `terraform { … }` block **MUST** appear exactly once per module, in `terraform.tf`. It **MUST NOT** be split.

### Files that MUST NOT appear at the module root

- A `providers.tf` file — provider *requirements* belong in `terraform.tf`; provider *configurations* belong only in the consumer's root module, never in an AVM module (per [SFR2]({{% siteparam base %}}/spec/SFR2)).
- A single monolithic `module.tf` or `everything.tf` — the canonical filenames above **MUST** be used.

### Rationale

Standardizing file layout means that any reviewer or consumer can find a module's interface (`variables.tf`, `outputs.tf`), provider constraints (`terraform.tf`), and primary logic (`main.tf` / `main.<topic>.tf`) in the same place across every AVM Terraform module, without having to grep. It also makes the cascade rules in [TFFR6]({{% siteparam base %}}/spec/TFFR6), [TFFR7]({{% siteparam base %}}/spec/TFFR7), and [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1) reviewable at a glance.

### Notes

- Submodules (per [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)) follow the same layout in their own root directory under `modules/<subresource>/`. The submodule's `terraform.tf` **MUST** declare the same set of `required_providers` it actually consumes.
- Auto-generated documentation files (`README.md`, `_header.md`, `_footer.md`) and tooling configuration files (`.terraform-docs.yml`, `.tflint.hcl`, etc.) are out of scope of this rule and follow their own specs.
