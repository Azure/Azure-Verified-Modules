---
title: TFRMNFR1 - Subresources as submodules
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFRMNFR1
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 23010
---

## ID: TFRMNFR1 - Category: Composition - Subresources as submodules

Resource modules **MUST** implement each ARM subresource (a child resource type as defined in the API spec, for example `Microsoft.Example/widgets/parts` is a subresource of `Microsoft.Example/widgets`) as a Terraform submodule.

Submodules **MUST** be located in a direct `modules/<subresource-singular-name>/` child directory at the repository root, where `<subresource-singular-name>` is the singular form of the ARM subresource name as per [PMNFR1]({{% siteparam base %}}/spec/PMNFR1). Nested Terraform module roots are prohibited: `modules/<name>/modules/<name>/` is not an AVM module scope.

Terraform example roots follow the same one-layer convention: each example **MUST** be a direct `examples/<name>/` child directory. Nested example roots are prohibited.

`Avm.Authoring` convention validation enforces the direct `modules/*` and `examples/*` scope structure. Consequently, directory-specific TFLint overrides apply only at those direct roots; see [TFLint configuration overrides]({{% siteparam base %}}/contributing/terraform/tflint-rules/#tflint-configuration-overrides).

For example, a resource module for `Microsoft.Example/widgets` would have the following layout:

```txt
terraform-azure-avm-res-example-widget/
├─ main.tf                         # azapi_resource for Microsoft.Example/widgets
├─ variables.tf
├─ outputs.tf
├─ terraform.tf
├─ _header.md                      # required for top-level docs generation
├─ _footer.md                      # required for top-level docs generation
├─ modules/
│  ├─ part/                        # subresource: Microsoft.Example/widgets/parts
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  ├─ outputs.tf
│  │  ├─ terraform.tf
│  │  ├─ _header.md                # required for submodule docs generation
│  │  └─ _footer.md                # required for submodule docs generation
│  └─ gadget/                      # subresource: Microsoft.Example/widgets/gadgets
│     ├─ main.tf
│     ├─ variables.tf
│     ├─ outputs.tf
│     ├─ terraform.tf
│     ├─ _header.md
│     └─ _footer.md
└─ examples/
```

The parent module **MUST** reference and compose its submodules so that supported subresources can be expressed through the parent module, but each submodule **MUST** also be independently consumable.

"Independently consumable" means a caller can source the submodule directly and use it without relying on hidden behavior in the parent module. Therefore, a submodule **MUST** follow the same interface and specification rules as a root AVM Terraform module (as listed below), even when the parent module also instantiates it.

### Submodule cardinality

Submodules **MUST** deploy exactly one instance of the resource they manage. The submodule's primary `azapi_resource` (or equivalent) **MUST NOT** declare `count` or `for_each`, and the submodule **MUST NOT** otherwise create multiple instances of its primary resource.

Cardinality is the parent module's responsibility: the parent module **MUST** use `count` or `for_each` on its submodule call to control how many instances of the subresource are deployed. This keeps each submodule's variables, outputs and tests focused on a single resource and pushes cardinality concerns up to the consumer.

This rule applies equally when a submodule is consumed through its parent module and when the same submodule is consumed directly by another caller.

For example, a parent module deploying multiple `parts` calls its `part` submodule using `for_each`, cascades the matching nested slot from its own `resource_types` (see [TFFR6]({{% siteparam base %}}/spec/TFFR6) for the naming rule and nested-slot pattern), passes `retry` and `timeouts` through unchanged (see [TFFR7]({{% siteparam base %}}/spec/TFFR7)), and cascades the matching nested slot from its own `ignore_body_changes` (see [TFFR8]({{% siteparam base %}}/spec/TFFR8)):

```terraform
module "part" {
  source   = "./modules/part"
  for_each = var.parts

  name                = each.value.name
  parent_id           = azapi_resource.this.id
  resource_types      = var.resource_types.example_widgets_parts
  retry               = var.retry
  timeouts            = var.timeouts
  ignore_body_changes = var.ignore_body_changes.example_widgets_parts
}
```

When the ARM subresource type is more than one level deep (for example `Microsoft.Example/widgets/parts/components`), its Terraform module root still **MUST** be a direct child of `modules/`. Use a descriptive direct name such as `modules/part-component/`; do not create `modules/part/modules/component/`. The parent module composes all direct submodules and exposes the required nested interface values without creating nested Terraform roots.

The following pattern is **NOT** allowed inside a submodule, because it pushes cardinality into the submodule itself:

```terraform
# modules/part/main.tf (invalid)
resource "azapi_resource" "this" {
  for_each = var.parts
  # ...
}
```

### Module source references

Parent modules **MUST** reference each submodule using a **local relative path** rooted at the parent module's directory:

```terraform
module "part" {
  source = "./modules/part"
  # ...other arguments...
}
```

Submodules **MAY** reference a direct sibling submodule using a relative path:

```terraform
# Inside modules/part/main.tf, calling the direct sibling modules/sub-part/
module "sub_part" {
  source = "../sub-part"
  # ...other arguments...
}
```

This pattern is useful when an ARM resource provider exposes child resources nested more than one level deep, while preserving the required one-layer module-root layout.

Submodules **MUST NOT** reference a sibling submodule via the Terraform Registry (for example `Azure/avm-res-example-widget/azure//modules/part`) or via a Git URL when the sibling lives in the same repository. Using a relative path keeps the entire module tree as a single unit that can be developed, tested and released atomically.

### Submodule documentation files

Each submodule directory **MUST** contain its own `_header.md` and `_footer.md` files at the root of the submodule (alongside `main.tf`). These files are consumed by the AVM `terraform-docs` documentation generation pipeline (see [TFNFR2]({{% siteparam base %}}/spec/TFNFR2)) to produce the submodule's `README.md`. Without them, the generated submodule documentation will be missing its introduction and footer sections and the documentation pipeline will not produce a complete `README.md`.

The submodule `_header.md` and `_footer.md` **MUST**:

- Describe the subresource the submodule manages, not the parent resource.
- Be checked in to source control (they are inputs to documentation generation, not generated artifacts).
- Be present in every submodule under `modules/`, even if the submodule is not intended to be consumed independently.

### Submodules are full AVM modules

Submodules **MUST** meet every requirement that applies to a top-level AVM Terraform resource module, including (but not limited to):

- All shared specifications ([SFR]({{% siteparam base %}}/specs/shared/) and [SNFR]({{% siteparam base %}}/specs/shared/) prefixed specs).
- All resource module specifications ([RMFR]({{% siteparam base %}}/specs/shared/) and [RMNFR]({{% siteparam base %}}/specs/shared/) prefixed specs).
- All Terraform specifications ([TFFR]({{% siteparam base %}}/specs/tf/) and [TFNFR]({{% siteparam base %}}/specs/tf/) prefixed specs), including:
  - [TFFR3]({{% siteparam base %}}/spec/TFFR3) — AzAPI is mandatory for every control-plane resource and supported data-plane operation in every module and submodule; AzureRM is permitted only for the documented unsupported data-plane/non-ARM API exception.
  - [TFFR4]({{% siteparam base %}}/spec/TFFR4) — `response_export_values`.
  - [TFFR5]({{% siteparam base %}}/spec/TFFR5) — `replace_triggers_refs`.
  - [TFFR6]({{% siteparam base %}}/spec/TFFR6) — `resource_types` variable. Each submodule declares its own `resource_types` for the resources it owns; the parent declares a nested `optional(object({...}), {})` slot per submodule that mirrors the submodule's variable exactly, and cascades it through unchanged.
  - [TFFR7]({{% siteparam base %}}/spec/TFFR7) — `retry` and `timeouts` variables, which the parent module **MUST** cascade to each submodule unchanged.
  - [TFFR8]({{% siteparam base %}}/spec/TFFR8) — `ignore_body_changes` variable. Each submodule declares its own for the resources it owns; the parent declares a nested `optional(object({...}), {})` slot per submodule that mirrors the submodule's variable exactly, and cascades it through unchanged. The parent's own paths **MUST NOT** be cascaded, because they are scoped to the parent's `body`.
- All applicable [interface]({{% siteparam base %}}/specs/tf/interfaces/) specifications (managed identities, role assignments, locks, diagnostic settings, private endpoints, customer-managed keys, tags) — for any interface that is supported by the underlying ARM subresource.

To avoid duplication, this specification deliberately states the requirement once: *every requirement that applies to a top-level resource module applies equally to every one of its submodules*. Where a requirement contradicts the submodule's nature (for example, a submodule that is never published independently still **MUST** include all required documentation files but is not itself listed in the registry), the requirement is interpreted in the context of the submodule.

### Rationale

Implementing subresources as submodules:

- Provides a clean, narrowly-scoped Terraform interface per ARM resource type, mirroring the ARM/AzAPI model where each resource type has its own type identifier and API version.
- Allows consumers to use only the subresources they need, without paying the cost of unused resources.
- Keeps each submodule's variables, outputs and tests focused, which improves readability, testability and review velocity.
- Aligns with the equivalent Bicep guidance in [BCPRMNFR3]({{% siteparam base %}}/spec/BCPRMNFR3) so that AVM resource modules in both languages share a consistent structure.
