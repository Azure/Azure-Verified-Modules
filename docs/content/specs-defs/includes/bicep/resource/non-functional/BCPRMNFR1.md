---
title: BCPRMNFR1 - Expected Test Directories
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPRMNFR1
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Testing, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 13010
---

## ID: BCPRMNFR1 - Category: Testing - Expected Test Directories

Resource module owners **MUST** create executable `defaults` and `waf-aligned` folders within `/tests/e2e/` and **SHOULD** create a `max` folder. Module owners **CAN** create additional folders as required.

Pattern and utility modules require only the defaults test case; they may add `waf-aligned`, but it is optional. Shared test applicability and skip rules are defined in [SNFR2]({{% siteparam base %}}/spec/SNFR2).

Each test instance must run through the normal test command without user input. Test-harness resources and inputs, such as an existing test scope or prerequisite resources, must be separated from module-specific scenario inputs. Telemetry controls must be explicit test inputs and must not be used to make a defaults or WAF scenario appear different from a normal module deployment.

{{% notice style="note" %}}

If a module can deploy varying styles of the same resource, e.g., VMs can be Linux or Windows, each style should be tested as both `defaults` and `waf-aligned`. Each must then be used as **suffixes** in the directory name to denote the style, e.g., for a VM we would expect to see:

- `/tests/e2e/linux.defaults/main.test.bicep`
- `/tests/e2e/linux.waf-aligned/main.test.bicep`
- `/tests/e2e/windows.defaults/main.test.bicep`
- `/tests/e2e/windows.waf-aligned/main.test.bicep`

{{% /notice %}}

### Defaults tests (**MUST**)

The `defaults` folder contains an executable test instance that deploys the module with the minimum set of module inputs.

This includes input parameters of type `Required` plus any `Conditional` inputs that are required for the module to deploy. This instance relies on module defaults for all other inputs; parameters of type `Optional` **SHOULD NOT** be supplied unless needed to represent the test harness or separate deployment prerequisite.

### WAF aligned tests (**MUST**)

The `waf-aligned` folder contains a test instance that deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

This includes input parameters of type `Required`, parameters of type `Conditional` marked as required for WAF compliance, and parameters of type `Optional` useful for WAF compliance.

Parameters and dependencies which are not needed for WAF compliance, **SHOULD NOT** be included.

A folder named `waf-aligned` does not by itself prove semantic WAF compliance. The scenario must actually set or arrange the applicable high-priority recommendations identified by [SFR2]({{% siteparam base %}}/spec/SFR2).

### Max tests (**SHOULD**)

The `max` folder contains a test instance that deploys the module using a large parameter set, enabling most of the modules' features.

The purpose of this instance is primarily parameter validation and not necessarily to serve as a real example scenario. Ideally, all features, extension resources and child resources should be enabled in this test, unless not possible due to conflicts, e.g., in case parameters are mutually exclusive.

{{% notice style="note" %}}

Please note that this test is not mandatory to have, but recommended for bulk parameter validation. It can be skipped in case the module parameter validation is covered already by additional, more scenario-specific tests.

{{% /notice %}}

### Additional tests (**CAN**)

Additional folders `CAN` be created by module owners as required.

For example, to validate parameters not covered by the `max` test due to conflicts, or to provide a real example scenario for a specific use case.
