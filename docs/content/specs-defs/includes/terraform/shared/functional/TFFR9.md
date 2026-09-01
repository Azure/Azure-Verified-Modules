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

This requirement applies independently to every root module and submodule that directly declares a managed AzAPI resource. The [avm_azapi_resource_tags_required]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_azapi_resource_tags_required) rule determines whether a resource type supports the `tags` argument from its embedded AVM-generated capability snapshot.

### Requirement

For every statically supported resource type, the resource **MUST** set the standard AVM tags input exactly as follows:

```terraform
resource "azapi_resource" "this" {
  type = var.resource_types.example_widgets

  tags = var.tags
}
```

The assignment **MUST NOT** merge, conditionally replace, or otherwise transform `var.tags` at the resource declaration. Apply any approved tag shaping before assigning the standard input.

For every statically unsupported resource type, the resource **MUST NOT** set a `tags` argument. Do not use a conditional, dynamic value, or an empty map to force tags onto an unsupported type.

The validation skips dynamic or otherwise unevaluable `type` expressions to avoid false positives. Authors **SHOULD** keep resource types statically resolvable through `var.resource_types` as required by [TFFR6]({{% siteparam base %}}/spec/TFFR6).

The `tags` input and propagation behavior remain governed by the [standard tags interface]({{% siteparam base %}}/specs/tf/interfaces/#tags). The embedded AVM-generated capability snapshot, rather than a hand-maintained module allowlist or an AzAPI import, is the authority for deciding whether the argument is supported.

See [avm_azapi_resource_tags_required]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_azapi_resource_tags_required) for enforcement and the supported override.
