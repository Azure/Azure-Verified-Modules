---
title: TFFR9 - AzAPI - Tag Propagation
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR9
type: default
tags: [
  Class-Resource,
  Class-Pattern,
  Class-Utility,
  Type-Functional,
  Category-Inputs/Outputs,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU,
  Validation-TBD
]
priority: 20090
---

## ID: TFFR9 - Category: Inputs/Outputs - AzAPI - Tag Propagation

### Applicability

This requirement applies independently to every root module and submodule that directly declares a managed AzAPI resource. The [avm_azapi_resource_tags_required]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_azapi_resource_tags_required) rule uses its embedded AVM-generated capability snapshot to classify the resource type's tags property as writable, read-only, or unsupported.

### Requirement

For every resource type with a statically writable tags property, the resource **MUST** expose consumer-settable tags through the [standard tags interface]({{% siteparam base %}}/specs/tf/interfaces/#tags) and set the `tags` argument. A direct assignment remains valid for modules that use only the module-wide fallback:

```terraform
resource "azapi_resource" "this" {
  type = var.resource_types.example_widgets

  tags = var.tags
}
```

When the module exposes the optional `resource_tags` interface, a non-null override for the Terraform resource block label **MUST** replace `var.tags` completely. An omitted or `null` override **MUST** inherit `var.tags`, and an empty map **MUST** remain an intentional empty replacement. The implementation **MUST NOT** merge the fallback and override maps.

Resource override keys identify Terraform resource block labels, not ARM resource types. Submodule overrides **MUST** use the deterministic typed `resource_tags.modules.<module_label>` shape defined by the standard tags interface. The separate `resources` and `modules` namespaces **MUST** resolve identical resource and module labels without ambiguity.

For every resource type with a statically read-only or unsupported tags property, the resource **MUST NOT** set a `tags` argument. Do not use a conditional, dynamic value, or an empty map to force tags onto these types.

The validation skips dynamic or otherwise unevaluable `type` expressions to avoid false positives. Authors **SHOULD** keep resource types statically resolvable through `var.resource_types` as required by [TFFR6]({{% siteparam base %}}/spec/TFFR6).

The embedded AVM-generated capability snapshot, rather than a hand-maintained module allowlist or an AzAPI import, is the authority for this classification.

See [avm_azapi_resource_tags_required]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_azapi_resource_tags_required) for capability enforcement and [avm_interface_resource_tags]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_interface_resource_tags) for validation of the optional override interface.
