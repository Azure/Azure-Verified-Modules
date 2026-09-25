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

Every Terraform module root **MUST** expose a string input named `location`, except a utility module that deploys no Azure resources. Local child modules that deploy Azure resources **MUST** also expose `location`, whether or not the child reports its own telemetry. `Avm.Authoring` **MUST** generate a required, non-nullable `location` input without a default where one is missing, and preserve an existing authored declaration. Roots with global or scope-based Azure resources still need a location for their subscription-scoped telemetry deployment. Utility modules that deploy no Azure resources **MUST NOT** gain an otherwise unused location input.

The generated telemetry deployment **MUST** use `var.location` directly. Terraform modules **MUST NOT** expose a separate `telemetry_location` input. Consumers in sovereign clouds must supply a location valid in that cloud.

Local module calls **MUST** pass the parent's `var.location` to children that require `location` when the call has no authored location argument. A call that already supplies a location for an individual resource or region **MUST** retain that value. Instrumented children **MUST** also receive the parent's `enable_telemetry` value so a parent opting out cannot enable child telemetry. Example calls **MUST** expose and forward a missing required location and the opt-out where supported, without replacing authored per-item locations.
