---
title: BCPNFR7 - Parameter Requirement Types
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPNFR7
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11020
---

## ID: BCPNFR7 - Category: Inputs - Parameter Requirement Types

Modules will have lots of parameters that will differ in their requirement type (required, optional, etc.). To help consumers understand what each parameter's requirement type is, module owners **MUST** add the requirement type to the beginning of each parameter's description. Below are the requirement types with a definition and example for the description decorator:

| Parameter Requirement Type | Definition | Example Description Decorator |
| -------------------------- | ---------- | ----------------------------- |
| Required | The parameter value must be provided. The parameter does not have a default value and hence the module expects and requires an input. | `@description('Required. <PARAMETER DESCRIPTION HERE...>')` |
| Conditional | The parameter value can be optional or required based on a condition, mostly based on the value provided to other parameters. Should contain a sentence starting with 'Required if (...).' to explain the condition. | `@description('Conditional. <PARAMETER DESCRIPTION HERE...>')` |
| Optional | The parameter value is not mandatory. The module provides a default value for the parameter. | `@description('Optional. <PARAMETER DESCRIPTION HERE...>')` |
| Generated | The parameter value is generated within the module and should not be specified as input in most cases. A common example of this is the `utcNow()` function that is only supported as the input for a parameter value, and not inside a variable. | `@description('Generated. <PARAMETER DESCRIPTION HERE...>')` |
