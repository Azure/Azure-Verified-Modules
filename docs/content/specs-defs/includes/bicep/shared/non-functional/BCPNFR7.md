---
title: BCPNFR7 - Parameter Requirement Types
url: /spec/BCPNFR7
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Inputs/Outputs,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 11020
---

#### ID: BCPNFR7 - Category: Inputs - Parameter Requirement Types

Modules will have lots of parameters that will differ in their requirement type (required, optional, etc.). To help consumers understand what each parameter's requirement type is, module owners **MUST** add the requirement type to the beginning of each parameter's description. Below are the requirement types with a definition and example for the description decorator:

| Parameter Requirement Type | Definition | Example Description Decorator |
| -------------------------- | ---------- | ----------------------------- |
| Required | The parameter value must be provided. The parameter does not have a default value and hence the module expects and requires an input. | `@description('Required. <PARAMETER DESCRIPTION HERE...>')` |
| Conditional | The parameter value can be optional or required based on a condition, mostly based on the value provided to other parameters. Should contain a sentence starting with 'Required if (...).' to explain the condition. | `@description('Conditional. <PARAMETER DESCRIPTION HERE...>')` |
| Optional | The parameter value is not mandatory. The module provides a default value for the parameter. | `@description('Optional. <PARAMETER DESCRIPTION HERE...>')` |
| Generated | The parameter value is generated within the module and should not be specified as input in most cases. A common example of this is the `utcNow()` function that is only supported as the input for a parameter value, and not inside a variable. | `@description('Generated. <PARAMETER DESCRIPTION HERE...>')` |
