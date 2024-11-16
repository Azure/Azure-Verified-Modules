---
title: RMFR4 - AVM Consistent Feature & Extension Resources Value Add
url: /spec/RMFR4
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Type-Functional,
  Category-Naming/Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 2040
---

#### ID: RMFR4 - Category: Composition - AVM Consistent Feature & Extension Resources Value Add

Resource modules support the following optional features/extension resources, as specified, if supported by the primary resource. The top-level variable/parameter names **MUST** be:

| Optional Features/Extension Resources       | Bicep Parameter Name | Terraform Variable Name | MUST/SHOULD |
|---------------------------------------------|----------------------|-------------------------|-------------|
| Diagnostic Settings                         | `diagnosticSettings` | `diagnostic_settings`   | MUST        |
| Role Assignments                            | `roleAssignments`    | `role_assignments`      | MUST        |
| Resource Locks                              | `lock`               | `lock`                  | MUST        |
| Tags                                        | `tags`               | `tags`                  | MUST        |
| Managed Identities (System / User Assigned) | `managedIdentities`  | `managed_identities`    | MUST        |
| Private Endpoints                           | `privateEndpoints`   | `private_endpoints`     | MUST        |
| Customer Managed Keys                       | `customerManagedKey` | `customer_managed_key`  | MUST        |
| Azure Monitor Alerts                        | `alerts`             | `alerts`                | SHOULD      |

Resource modules **MUST NOT** deploy required/dependent resources for the optional features/extension resources specified above. For example, for Diagnostic Settings the resource module **MUST NOT** deploy the Log Analytics Workspace, this is expected to be already in existence from the perspective of the resource module deployed via another method/module etc.

{{< hint type=note >}}

Please note that the implementation of Customer Managed Keys from an ARM API perspective is different across various RPs that implement Customer Managed Keys in their service. For that reason you may see differences between modules on how Customer Managed Keys are handled and implemented, but functionality will be as expected.

{{< /hint >}}

Module owners **MAY** choose to utilize cross repo dependencies for these "add-on" resources, or **MAY** chose to implement the code directly in their own repo/module. So long as the implementation and outputs are as per the specifications requirements, then this is acceptable.

{{< hint type=tip >}}

Make sure to checkout the language specific specifications for more info on this:

- [Bicep](/Azure-Verified-Modules/spec/BCPNFR1)
- [Terraform](/Azure-Verified-Modules/spec/TFNFR1)

{{< /hint >}}