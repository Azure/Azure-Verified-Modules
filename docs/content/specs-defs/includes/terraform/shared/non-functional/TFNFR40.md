---
title: TFNFR40 - Structured JSON and YAML Values
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR40
type: default
tags: [
  Class-Resource,
  Class-Pattern,
  Class-Utility,
  Type-NonFunctional,
  Category-CodeStyle,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU,
  Validation-TBD
]
priority: 21400
---

## ID: TFNFR40 - Category: Code Style - Structured JSON and YAML Values

Structured values that are passed as JSON or YAML **MUST** be constructed with `jsonencode` or `yamlencode`, rather than a literal JSON or YAML heredoc. Native HCL objects, lists, conditionals, and `for` expressions keep the structure reviewable and let Terraform perform correct escaping.

```terraform
body = jsonencode({
  properties = {
    enabled = var.enabled
    names   = [for item in var.items : item.name]
  }
})
```

Terraform interpolation (`${...}`), template directives (`%{...}`), unknown values, and dynamically generated lists or maps are **not** exceptions: construct the native HCL value and pass it to the encoder.

A heredoc **MAY** be used only when the value is not JSON or YAML, or when the receiving system requires opaque source text for a downstream templating engine or syntax that `jsonencode` or `yamlencode` cannot represent without changing its meaning. The heredoc must not use Terraform interpolation to assemble JSON or YAML in that case, and its reason must be clear from the surrounding configuration.

See [avm_terraform_literal_heredoc_disallowed]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_terraform_literal_heredoc_disallowed) for enforcement and the supported override.
