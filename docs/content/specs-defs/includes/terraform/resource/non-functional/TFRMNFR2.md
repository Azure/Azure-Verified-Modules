---
title: TFRMNFR2 - Primary Resource Naming
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFRMNFR2
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
priority: 23020
---

## ID: TFRMNFR2 - Category: Naming/Composition - Primary Resource Naming

The primary `azapi_resource` (or equivalent AzAPI resource) declared in a Terraform resource module **MUST** be named `this`. The same rule applies to the primary resource declared in any submodule (per [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)).

The "primary resource" is the single Azure resource that the module exists to manage — the one whose ARM resource type appears in the module's name (per [RMNFR1]({{% siteparam base %}}/spec/RMNFR1)). Every other resource declared by the module (locks, role assignments, diagnostic settings, private endpoints, private DNS zone groups, child / extension resources required by the primary resource, etc.) is a *satellite* resource and **MUST NOT** be named `this`; instead, satellites **MUST** be named after what they represent (for example `azapi_resource.lock`, `azapi_resource.role_assignments`, `azapi_resource.diagnostic_settings`, `azapi_resource.private_endpoints`).

Standardizing on `this` for the primary resource lets consumers, CI checks, and the AVM interface utility module reference it predictably — most notably as `azapi_resource.this.id` for downstream `parent_id` wiring, and `azapi_resource.this.output` for exported values.

### Example

```terraform
resource "azapi_resource" "this" {
  type      = var.resource_types.this
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }
}

resource "azapi_resource" "lock" {
  count = var.lock != null ? 1 : 0

  type      = module.avm_interfaces.lock_azapi.type
  name      = module.avm_interfaces.lock_azapi.name
  parent_id = module.avm_interfaces.lock_azapi.parent_id
  body      = module.avm_interfaces.lock_azapi.body
}

resource "azapi_resource" "role_assignments" {
  for_each = module.avm_interfaces.role_assignments_azapi

  type      = each.value.type
  name      = each.value.name
  parent_id = each.value.parent_id
  body      = each.value.body
}
```

### Exceptions

The `this` rule **MAY** be relaxed only when **all** of the following are true:

- The module is `Class-Utility` (per [Module Classifications]({{% siteparam base %}}/specs/team-definitions/#module-classifications)) **OR** the module's primary functionality is implemented by two or more `azapi_resource` declarations that are *peers* (no resource is the ARM parent of any other, and no resource depends on another resource's ID for its own creation).
- No single `azapi_resource` would, on its own, be a meaningful handle for downstream consumers (i.e. there is no resource whose `id` would be the obvious value of a single canonical `resource_id` output).

A module where one `azapi_resource` is the ARM parent of, or a hard dependency for, another `azapi_resource` is **NOT** exempted — the parent resource is the primary and **MUST** be named `this`.

Where this exception applies, each resource **MUST** be named after what it represents, and the module's `README.md` **MUST** document why the `this` convention does not apply.

### Notes

- This rule applies regardless of whether the primary resource uses `azapi_resource`, `azapi_resource_action`, `azapi_update_resource`, or any other AzAPI resource type.
- The rule applies independently to every submodule: each submodule has its own `this` (the primary resource it manages) — that is the contract enabling the parent module to write `module.<submodule>.resource_id`.
- The rule does **not** apply to data sources or to `azapi_resource_list` lookups; those **SHOULD** still be named after what they represent.
