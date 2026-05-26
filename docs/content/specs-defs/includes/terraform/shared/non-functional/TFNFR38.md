---
title: TFNFR38 - Resource ID Variable Validation
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR38
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21380
---

## ID: TFNFR38 - Category: Inputs/Outputs - Resource ID Variable Validation

Every input variable (or nested attribute) that holds an Azure ARM resource ID **MUST** be validated using the AzAPI provider-defined function [`provider::azapi::parse_resource_id`](https://registry.terraform.io/providers/Azure/azapi/latest/docs/functions/parse_resource_id), called with a literal string naming the expected resource type, and wrapped in `can(...)`.

Hand-rolled `regex`, `startswith`, `length`, or `split` checks **MUST NOT** be used to validate resource IDs. The provider function knows the canonical ARM ID grammar for every resource type, is fixed in lockstep with the provider, and produces a single consistent error model — including for IDs whose grammar contains anomalies (such as classic resources, extension resources, or scope-based IDs).

This rule covers, but is not limited to:

- Top-level scope variables such as `parent_id` (see [TFRMFR1]({{% siteparam base %}}/spec/TFRMFR1)).
- Variables that reference other Azure resources by ID (e.g. `subnet_resource_id`, `key_vault_resource_id`, `workspace_resource_id`, `private_dns_zone_resource_ids`, `user_assigned_resource_ids`).
- Nested attributes inside `object`, `map(object)`, `set(object)`, or `list(object)` types that hold resource IDs.

### Rules

- The resource type passed to `parse_resource_id` **MUST** be a literal string (e.g. `"Microsoft.Network/virtualNetworks/subnets"`). It **MUST NOT** be a reference to another variable, local, or expression. This keeps each `validation` block self-contained and avoids requiring cross-variable validation.
- For optional / `nullable` variables, the validation **MUST** short-circuit on `null` (e.g. `var.x == null || can(provider::azapi::parse_resource_id("...", var.x))`) so that callers omitting the value do not trip validation.
- For collection-valued variables (`set(string)`, `list(string)`, `map(string)`), the validation **MUST** iterate the collection with `alltrue([for v in ... : can(...)])`.
- For nested attributes within object types, the validation **MUST** iterate the parent collection (or reference the object directly) and validate each nested resource ID, again handling `null` for optional nested attributes.
- Where a variable can legitimately hold IDs of more than one resource type (rare — e.g. `marketplace_partner_resource_id` in the diagnostic-settings interface), this rule does not apply and the variable **SHOULD** be left without resource-ID validation rather than validated against a single arbitrary type.

### Examples

A required, single-value resource ID:

```terraform
variable "key_vault_resource_id" {
  type     = string
  nullable = false

  validation {
    condition     = can(provider::azapi::parse_resource_id("Microsoft.KeyVault/vaults", var.key_vault_resource_id))
    error_message = "`key_vault_resource_id` must be a valid Azure Key Vault resource ID."
  }

  description = "The resource ID of the Key Vault that holds the customer-managed key."
}
```

An optional, single-value resource ID:

```terraform
variable "workspace_resource_id" {
  type     = string
  default  = null
  nullable = true

  validation {
    condition     = var.workspace_resource_id == null || can(provider::azapi::parse_resource_id("Microsoft.OperationalInsights/workspaces", var.workspace_resource_id))
    error_message = "`workspace_resource_id` must be a valid Log Analytics workspace resource ID, or `null`."
  }

  description = "The resource ID of the Log Analytics workspace to send diagnostics to."
}
```

A collection of resource IDs:

```terraform
variable "user_assigned_resource_ids" {
  type     = set(string)
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for id in var.user_assigned_resource_ids :
      can(provider::azapi::parse_resource_id("Microsoft.ManagedIdentity/userAssignedIdentities", id))
    ])
    error_message = "Each entry in `user_assigned_resource_ids` must be a valid user-assigned managed identity resource ID."
  }

  description = "A set of user-assigned managed identity resource IDs to attach to the resource."
}
```

A nested resource ID inside a `map(object(...))`:

```terraform
variable "private_endpoints" {
  type = map(object({
    subnet_resource_id            = string
    private_dns_zone_resource_ids = optional(set(string), [])
    # ...other attributes...
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for _, v in var.private_endpoints :
      can(provider::azapi::parse_resource_id("Microsoft.Network/virtualNetworks/subnets", v.subnet_resource_id))
    ])
    error_message = "Each `private_endpoints[*].subnet_resource_id` must be a valid subnet resource ID."
  }

  validation {
    condition = alltrue(flatten([
      for _, v in var.private_endpoints : [
        for id in v.private_dns_zone_resource_ids :
        can(provider::azapi::parse_resource_id("Microsoft.Network/privateDnsZones", id))
      ]
    ]))
    error_message = "Each entry in `private_endpoints[*].private_dns_zone_resource_ids` must be a valid private DNS zone resource ID."
  }
}
```

### Notes

- The rule applies regardless of whether the resource ID is required or optional, single-valued or collection-valued, top-level or nested.
- `parse_resource_id` errors when (a) the input is not a well-formed ARM ID, or (b) the input does not parse as the supplied resource type. Wrapping in `can(...)` converts both failure modes into a single boolean suitable for a `validation` block's `condition`.
- This rule supersedes any older guidance suggesting `startswith(var.x, "/")` or hand-written regex for resource ID validation.
