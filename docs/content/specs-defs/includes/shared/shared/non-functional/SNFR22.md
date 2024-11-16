---
title: SNFR22 - Parameters/Variables for Resource IDs
url: /spec/SNFR22
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
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 1180
---

#### ID: SNFR22 - Category: Inputs - Parameters/Variables for Resource IDs

A module parameter/variable that requires a full Azure Resource ID as an input value, e.g. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultName}`, **MUST** contain `ResourceId/resource_id` in its parameter/variable name to assist users in knowing what value to provide at a glance of the parameter/variable name.

Example for the property `workspaceId` for the Diagnostic Settings resource. In Bicep its parameter name should be `workspaceResourceId` and the variable name in Terraform should be `workspace_resource_id`.

`workspaceId` is not descriptive enough and is ambiguous as to which ID is required to be input.