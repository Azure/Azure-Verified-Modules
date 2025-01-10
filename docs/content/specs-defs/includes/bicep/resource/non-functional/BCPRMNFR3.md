---
title: BCPRMNFR3 - Resource module structure
url: /spec/BCPRMNFR3
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 13010
---

#### ID: BCPRMNFR3 - Category: Composition - Implementing child resources

Providers like `Microsoft.Sql/servers` may have dedicated child resources such as `Microsoft.Sql/servers/databases`. In these cases, the module **MUST** host this child resource in a subfolder named after the child resource's singular name ([ref](/Azure-Verified-Modules/specs-defs/includes/shared/pattern/non-functional/PMNFR1)), so that the path to the child resource folder is consistent with its resource type. In the given example, we would have a `database` subfolder in the `server` parent folder.

```txt
sql
└─ server [module]
  └─ database [child-module/resource]
```

In this folder, we recommend to place the child resource-template alongside a ReadMe & compiled JSON (to be generated via the default [Set-AVMModule](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files) utility) and optionally further nest additional folders for it's child resources.

There are several reasons to structure a module in this way. For example
- It allows a separation of concerns where each module can focus on its own properties and logic, while delegating most of a child-resource's logic to its separate child module
- It's consistent with the provider namespace structure and makes modules easier to understand not only because they're more aligned with set structure, but also are aligned with one another
- As each module is its own 'deployment', it reduces limitations around nested loops
- Once the feature is enabled, it will enable module owners to publish set child-modules as separate modules to the public registry, allowing consumers to make use of them directly.

In full transparency: The drawbacks of these additional deployments is an extended deployment period & a contribution to the 800 deployments limit. However, for AVM resource modules it was agreed that the advantages listed above outweigh these limitations.