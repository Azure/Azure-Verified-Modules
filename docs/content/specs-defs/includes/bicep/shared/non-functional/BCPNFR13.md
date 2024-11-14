---
title: BCPNFR13 - Test file metadata
url: /spec/BCPNFR13
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Testing,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 11130
---

#### ID: BCPNFR13 - Category: Testing - Test file metadata

By default, the ReadMe-generating utility will create usage examples headers based on each `e2e` folder's name.
Module owners **MAY** provide a custom name & description by specifying the metadata blocks `name` & `description` in their `main.test.bicep` test files.

For example:

```bicep
metadata name = 'Using Customer-Managed-Keys with System-Assigned identity'
metadata description = 'This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.'
```

would lead to a header in the module's `readme.md` file along the lines of

```markdown
### Example 1: _Using Customer-Managed-Keys with System-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.
```
