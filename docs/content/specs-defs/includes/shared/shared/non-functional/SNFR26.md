---
title: SNFR26 - Output - Parameters - Decorators
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SNFR26
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 1250
---

## ID: SNFR26 - Output-Parameters - Decorators

Output parameters **MUST** implement:

- [Decorators in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters#use-decorators) such as `description` & `secure` (if sensitive)
- [Arguments in Terraform](https://developer.hashicorp.com/terraform/language/values/outputs#optional-arguments) such as `description` & `sensitive` (if sensitive)

{{% tabs title="Output parameters" groupid="scriptlanguage" %}}
  {{% tab title="Bicep" %}}

```bicep
@description('The resourceId of your resource.')
output sampleResourceId string = sampleResource.id

@description('The key of your resource.')
@secure()
output sampleResourceKey string = sampleResource.key
```

  {{% /tab %}}
  {{% tab title="Terraform" %}}

```terraform
# Resource output
output "foo" {
  description = "MyResource foo attribute"
  value = azurerm_resource_myresource.foo
}

# Output of a sensitive attribute
output "bar" {
  description = "MyResource bar attribute"
  value     = azurerm_resource_myresource.bar
  sensitive = true
}
```

  {{% /tab %}}
{{% /tabs %}}
