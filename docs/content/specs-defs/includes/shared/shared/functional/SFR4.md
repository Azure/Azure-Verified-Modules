---
title: SFR4 - Telemetry Enablement Flexibility
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SFR4
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Telemetry, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 40
---

## ID: SFR4 - Category: Telemetry - Telemetry Enablement Flexibility

The telemetry collection **MUST** be on/enabled by default, however module consumers **MUST** be allowed to disable it by setting the below parameter/variable value to `false`:

- Bicep: `enableTelemetry`
- Terraform: `enable_telemetry`

{{% notice style="note" %}}

Whenever a module references AVM modules that implement the telemetry parameter (e.g., a pattern module that uses AVM resource modules), the telemetry parameter value **MUST** be passed through to these modules. This is necessary to ensure a consumer can reliably enable & disable the telemetry feature for all used modules.

{{% /notice %}}

This general specification can be modified for some use-cases, that are language specific:

### Bicep

For cross-references in resource modules, the spec [BCPFR7]({{% siteparam base %}}/spec/BCPFR7/) also applies.

### Terraform

Every Terraform module root **MUST** declare a string input named `location`. The only root exception is a utility module that deploys no Azure resources. Every local child module that deploys Azure resources **MUST** also declare `location`, whether or not it reports its own telemetry; child modules that deploy no Azure resources are exempt. Declaring this input does not always make it required from consumers: the telemetry-only exception below applies even when the module's resources are global or scope-based.

When `location` is used only for telemetry, including forwarding it to local children whose location is also telemetry-only, it **MUST** be optional with `type = string`, `default = null`, and nullable semantics. Authors **MAY** omit `nullable` (Terraform defaults it to `true`) or set `nullable = true`; `nullable = false` **MUST NOT** be used for this optional input. The variable **MUST** validate that location is non-null when telemetry is enabled:

```hcl
variable "location" {
  type        = string
  default     = null
  description = "The Azure region for this module's telemetry deployment."

  validation {
    condition     = !var.enable_telemetry || var.location != null
    error_message = "The location must not be null when telemetry is enabled."
  }
}
```

With `enable_telemetry = false`, consumers **MUST** be able to omit this telemetry-only location or explicitly pass `null`. With telemetry enabled, including its default configuration, consumers **MUST** supply a non-null region. Existing additional validations **MUST** allow null when telemetry is disabled.

If `location` is needed outside telemetry, including by resources, data sources, locals, outputs, or a child with a required location input, the input **MUST** remain a required, non-nullable string without a default. Disabling telemetry **MUST NOT** relax these non-telemetry location requirements.

The generated telemetry deployment **MUST** use `var.location`. Consumers of modules with a required `location` input must supply a region available in their cloud, including sovereign clouds.

Local module calls **MUST** pass the parent's `var.location` to children that require `location`, including conditionally for telemetry, when the call has no authored location argument. A call that already supplies a location for an individual resource or region **MUST** retain that value. A pattern with optional resource-specific locations can pass the corresponding override to each child when supplied and fall back to the parent's `var.location` when omitted; overrides for different children remain independent. Instrumented children **MUST** also receive the parent's `enable_telemetry` value so a parent opting out cannot enable child telemetry. Forwarding a nullable telemetry-only location **MUST NOT** make it unconditionally required in a parent that has no non-telemetry location dependency. Example calls **MUST** expose and forward a missing required location and the opt-out where supported, without replacing authored per-item locations.
