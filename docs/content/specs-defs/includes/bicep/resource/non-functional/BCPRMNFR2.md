---
title: BCPRMNFR2 - User-defined types - AVM-Common-Types
url: /spec/BCPRMNFR2
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-Manual # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 13010
---

#### ID: BCPRMNFR2 - User-defined types - AVM-Common-Types

When implementing any of the [shared](/Azure-Verified-Modules/specs/shared/interfaces) or [Bicep-specific](/Azure-Verified-Modules/specs/bicep/interfaces) AVM interface variants you MUST import their User-defined type (UDT) via the published [AVM-Common-Types](https://github.com/Azure/bicep-registry-modules/tree/main/avm/utl/types/avm-common-types) module.

When doing so, each type MUST be imported separately, right above the parameter or output that uses it.

```bicep
import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:*.*.*'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:*.*.*'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?
```

Importing them individually as opposed to one common block has several benefits such as
- Individual versioning of types
- If you must update the version for one type, you're not exposed to unexpected changes to other types

{{% notice style="important" %}}

The `import (...)` block MUST not be added in between a parameter's definition and its metadata. Doing so breaks the metadata's binding to the parameter in question.

{{% /notice %}}

Finally, you should check for version updates regularly to ensure the resource module stays consistent with the specs. If the used AVM-Common-Types runs stale, the CI may eventually fail the module's static tests.
