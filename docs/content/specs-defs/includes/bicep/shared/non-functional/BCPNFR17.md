---
title: BCPNFR17 - Code Styling - Type casting
url: /spec/BCPNFR17
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Composition,
  Language-Bicep,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
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
