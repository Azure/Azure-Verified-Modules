---
title: TFNFR41 - Output Definition Order
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR41
type: default
tags: [
  Class-Resource,
  Class-Pattern,
  Class-Utility,
  Type-NonFunctional,
  Category-CodeStyle,
  Language-Terraform,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU,
  Validation-TBD
]
priority: 21410
---

## ID: TFNFR41 - Category: Code Style - Output Definition Order

`output` blocks in a module **SHOULD** be ordered alphabetically by output name. This applies to `outputs.tf` and every `outputs.<topic>.tf` file in the root module and each submodule.

```terraform
output "id" {
  value = azapi_resource.this.id
}

output "name" {
  value = azapi_resource.this.name
}
```

MAPOTF's `sort_outputs` behavior implements this convention. See [MAPOTF and standard Terraform TFLint coverage]({{% siteparam base %}}/contributing/terraform/tflint-rules/#mapotf-and-standard-terraform-tflint-coverage).

