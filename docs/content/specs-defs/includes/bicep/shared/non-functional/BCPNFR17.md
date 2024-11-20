---
title: BCPNFR17 - Code Styling - Type casting
url: /spec/BCPNFR17
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 11160
---

#### ID: BCPNFR17 - Category: Composition - Code Styling - Type casting

To improve the usability of primitive module properties declared as strings, you **SHOULD** declare them using a type which better represents them, and apply any required casting in the module on behalf of the user.

For reference, please refer to the following examples:

#### Boolean as String

{{< tabs "booleanString" >}}
  {{< tab "Before" >}}

  ```bicep
  @allowed([
    'false'
    'true'
  ])
  param myParameterValue string = 'false'

  resource myResource '(...)' = {
    (...)
    properties: {
      myParameter: myParameterValue
    }
  }
  ```

  {{< /tab >}}
  {{< tab "After" >}}

  ```bicep
  param myParameterValue string = false

  resource myResource '(...)' = {
    (...)
    properties: {
      myParameter: string(myParameterValue)
    }
  }
  ```

  {{< /tab >}}
{{< /tabs >}}

#### Integer Array as String Array

{{< tabs "intArrayString" >}}
  {{< tab "Before" >}}

  ```bicep
  @allowed([
    '1'
    '2'
    '3'
  ])
  param zones array

  resource myResource '(...)' = {
    (...)
    properties: {
      zones: zones
    }
  }
  ```

  {{< /tab >}}
  {{< tab "After" >}}

  ```bicep
  @allowed([
    1
    2
    3
  ])
  param zones int[]

  resource myResource '(...)' = {
    (...)
    properties: {
      zones: map(zones, zone => string(zone))
    }
  }
  ```

  {{< /tab >}}
{{< /tabs >}}
