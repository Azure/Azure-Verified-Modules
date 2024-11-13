---
title: SNFR22 - Parameters/Variables for Resource IDs
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: ["Class-Shared","Type-NonFunctional","Category-Inputs","Language-Shared","Enforcement-MUST","Persona-Owner","Persona-Contributor","Lifecycle-Maintenance"]
type: "posts"
priority: 180
---

#### ID: SNFR22 - Category: Inputs - Parameters/Variables for Resource IDs

A module parameter/variable that requires a full Azure Resource ID as an input value, e.g. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultName}`, **MUST** contain `ResourceId/resource_id` in its parameter/variable name to assist users in knowing what value to provide at a glance of the parameter/variable name.

Example for the property `workspaceId` for the Diagnostic Settings resource. In Bicep its parameter name should be `workspaceResourceId` and the variable name in Terraform should be `workspace_resource_id`.

`workspaceId` is not descriptive enough and is ambiguous as to which ID is required to be input.
