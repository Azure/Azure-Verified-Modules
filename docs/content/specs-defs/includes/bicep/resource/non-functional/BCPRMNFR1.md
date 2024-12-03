---
title: BCPRMNFR1 - Expected Test Directories
url: /spec/BCPRMNFR1
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
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

#### ID: BCPRMNFR1 - Category: Testing - Expected Test Directories

Module owners **MUST** create the `defaults`, `waf-aligned` folders within their `/tests/e2e/` directory in their resource module source code and **SHOULD** create a `max` folder also. Module owners **CAN** create additional folders as required. Each folder will be used as described for various test cases.

##### Defaults tests (**MUST**)

The `defaults` folder contains a test instance that deploys the module with the minimum set of required parameters.

This includes input parameters of type `Required` plus input parameters of type `Conditional` marked as required for WAF compliance.

This instance has heavy reliance on the default values for other input parameters. Parameters of type `Optional` **SHOULD NOT** be used.

##### WAF aligned tests (**MUST**)

The `waf-aligned` folder contains a test instance that deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

This includes input parameters of type `Required`, parameters of type `Conditional` marked as required for WAF compliance, and parameters of type `Optional` useful for WAF compliance.

Parameters and dependencies which are not needed for WAF compliance, **SHOULD NOT** be included.

##### Max tests (**SHOULD**)

The `max` folder contains a test instance that deploys the module using a large parameter set, enabling most of the modules' features.

The purpose of this instance is primarily parameter validation and not necessarily to serve as a real example scenario. Ideally, all features, extension resources and child resources should be enabled in this test, unless not possible due to conflicts, e.g., in case parameters are mutually exclusive.

{{< hint type=note >}}

Please note that this test is not mandatory to have, but recommended for bulk parameter validation. It can be skipped in case the module parameter validation is covered already by additional, more scenario-specific tests.

{{< /hint >}}

##### Additional tests (**CAN**)

Additional folders `CAN` be created by module owners as required.

For example, to validate parameters not covered by the `max` test due to conflicts, or to provide a real example scenario for a specific use case.

If a module can deploy varying styles of the same resource, e.g., VMs can be Linux or Windows, each style should be tested as both `defaults` and `waf-aligned`. These names should be used as suffixes in the directory name to denote the style, e.g., for a VM we would expect to see:

- `/tests/e2e/defaults.linux/main.test.bicep`
- `/tests/e2e/waf-aligned.linux/main.test.bicep`
- `/tests/e2e/defaults.windows/main.test.bicep`
- `/tests/e2e/waf-aligned.windows/main.test.bicep`
