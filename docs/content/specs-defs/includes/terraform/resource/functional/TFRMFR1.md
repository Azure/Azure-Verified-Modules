---
title: TFRMFR1 - Resource Module Parent ID
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFRMFR1
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 22010
---

## ID: TFRMFR1 - Category: Inputs/Outputs - Resource Module Parent ID

A Terraform resource module **MUST** expose its parent scope to consumers as a single string variable named `parent_id`, and **MUST** assign that variable to the `parent_id` argument of every primary `azapi_resource` (or equivalent AzAPI resource) it manages.

`parent_id` is the AzAPI provider's universal way of expressing where a resource lives in the Azure Resource Manager hierarchy. Depending on the resource type, it can be:

- A subscription ID (e.g. `/subscriptions/{subscriptionId}`) — for tenant- or subscription-scoped resources.
- A management group ID (e.g. `/providers/Microsoft.Management/managementGroups/{name}`) — for management-group-scoped resources.
- A resource group ID (e.g. `/subscriptions/{subscriptionId}/resourceGroups/{rgName}`) — for the most common case of resources that live inside a resource group.
- The resource ID of a parent ARM resource (e.g. the ID of a virtual network for subnets, the ID of a storage account for blob containers) — for child / nested resources.

Because the same variable describes every possible parent scope, modules **MUST NOT** expose `resource_group_name`, `resource_group_resource_id`, or any other parent-scope-specific variable. The fully-qualified ARM ID supplied via `parent_id` is sufficient and works uniformly for every kind of Azure resource.

`parent_id` **MUST** be validated using the AzAPI provider's [provider-defined functions](https://registry.terraform.io/providers/Azure/azapi/latest/docs/functions), per [TFNFR38]({{% siteparam base %}}/spec/TFNFR38). The required function is [`provider::azapi::parse_resource_id`](https://registry.terraform.io/providers/Azure/azapi/latest/docs/functions/parse_resource_id), called with the *expected parent resource type* for the module's primary resource (for example `Microsoft.Resources/resourceGroups` for resources that live inside a resource group, or `Microsoft.Network/virtualNetworks` for a subnet module). Hand-rolled `regex`, `startswith`, or `length` checks **MUST NOT** be used.

This rule supersedes the Terraform clause of [RMFR3]({{% siteparam base %}}/spec/RMFR3) (which historically required a `resource_group_name` variable in Terraform). RMFR3 still applies to Bicep modules; for AVM Terraform modules the rules in this spec take precedence.

### Variable declaration

```terraform
variable "parent_id" {
  type     = string
  nullable = false

  validation {
    # Validate via the AzAPI provider's `parse_resource_id` function. The function
    # errors if `parent_id` is malformed OR if it does not parse as the expected
    # parent resource type (e.g. passing a subscription ID where a resource group
    # is required). Replace `Microsoft.Resources/resourceGroups` with the parent
    # resource type expected by this module's primary resource (for example
    # `Microsoft.Network/virtualNetworks` for a subnet module).
    condition     = can(provider::azapi::parse_resource_id("Microsoft.Resources/resourceGroups", var.parent_id))
    error_message = "`parent_id` must be a valid Azure resource group resource ID."
  }

  description = <<DESCRIPTION
The fully-qualified ARM resource ID of the scope into which the resource managed by this module will be deployed. Examples:

- Subscription scope:        `/subscriptions/00000000-0000-0000-0000-000000000000`
- Management group scope:    `/providers/Microsoft.Management/managementGroups/example-mg`
- Resource group scope:      `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg`
- Parent resource scope:     `/subscriptions/.../resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet`

This module **does not** create the parent scope. The consumer (or composing pattern module) is responsible for providing a `parent_id` for an existing scope.
DESCRIPTION
}
```

### Use in the resource block

```terraform
resource "azapi_resource" "this" {
  type      = var.resource_types.this
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  response_export_values = []
}
```

### Notes

- `parent_id` **MUST** be of type `string`, **MUST** be required (no `default`), and **MUST** be validated using [`provider::azapi::parse_resource_id`](https://registry.terraform.io/providers/Azure/azapi/latest/docs/functions/parse_resource_id) wrapped in `can(...)`, per [TFNFR38]({{% siteparam base %}}/spec/TFNFR38).
- The resource type passed to `parse_resource_id` **MUST** be a literal string naming the *expected parent* resource type for the module's primary resource (e.g. `"Microsoft.Resources/resourceGroups"` for a resource that lives inside a resource group, or `"Microsoft.Network/virtualNetworks"` for a subnet module). It **MUST NOT** be a reference to another variable. This keeps the validation block self-contained.
- Modules **MUST NOT** accept `resource_group_name`, `resource_group_resource_id`, or any other parent-scope-specific variable. If a module needs to be told which resource group (or subscription, or management group) to deploy into, it does so exclusively via `parent_id`.
- Modules **MUST NOT** create the parent scope themselves (see [RMFR3]({{% siteparam base %}}/spec/RMFR3) for the resource-group case). The consumer or composing pattern module supplies an existing scope's ARM ID.
- Submodules (per [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)) **MUST** also expose `parent_id` and follow the same rules. The parent module typically passes its own primary resource's ID to each child, e.g. `parent_id = azapi_resource.this.id`.
- Modules **MAY** expose additional, narrower scope variables only when a single resource genuinely needs *two* different parent scopes (rare). In that case the additional variable **MUST** still be a `parent_id`-shaped string (fully-qualified ARM ID), validated with the same provider-defined function pattern, and **MUST NOT** be named after a specific scope kind such as `resource_group_name`.

### Exception — extension-resource modules

A small class of resource modules manages an Azure extension resource (a resource type that attaches to *any* parent ARM resource, regardless of its provider). Examples include modules whose primary resource is `Microsoft.Authorization/locks`, `Microsoft.Authorization/roleAssignments`, `Microsoft.Insights/diagnosticSettings`, `Microsoft.Resources/tags`, or similar. For these modules, the parent resource type is intentionally polymorphic and a literal `parse_resource_id("Microsoft.X/y", var.parent_id)` validation **MUST NOT** be used.

Where this exception applies, the module **MUST** still:

- Expose the parent scope as the variable named `parent_id` (no other name), of type `string`, required, and `nullable = false`.
- Validate that `parent_id` is a non-empty fully-qualified ARM ID using a generic check, e.g.:

  ```terraform
  validation {
    condition     = length(var.parent_id) > 0 && (startswith(var.parent_id, "/subscriptions/") || startswith(var.parent_id, "/providers/"))
    error_message = "`parent_id` must be a fully-qualified ARM resource ID starting with `/subscriptions/` or `/providers/`."
  }
  ```

- Document in the variable's `description` that any ARM resource ID is accepted because the module manages an extension resource.
- Document the exception in the module's `README.md` so reviewers immediately understand why the standard `parse_resource_id` validation is absent.
