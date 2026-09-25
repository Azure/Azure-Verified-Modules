---
title: SFR3 - Deployment/Usage Telemetry
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SFR3
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Telemetry, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 30
---

## ID: SFR3 - Category: Telemetry - Deployment/Usage Telemetry

Modules **MUST** provide the capability to collect deployment/usage telemetry as detailed in [Telemetry]({{% siteparam base %}}/help-support/telemetry/) further.

To highlight that AVM modules use telemetry, an information notice **MUST** be included in the footer of each module's `README.md` file with the below content. See the [telemetry guidance](https://docs.opensource.microsoft.com/releasing/general-guidance/telemetry/) for more details.

### Telemetry Information Notice

{{% notice style="note" %}}

The following information notice is automatically added at the bottom of the `README.md` file of the module when

- **Bicep:** Using the [`utilities/tools/Set-AVMModule.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/tools/Set-AVMModule.ps1) utility
- **Terraform:** Running [`avm pre-commit`]({{% siteparam base %}}/contributing/terraform/contribution-flow/#4-run-avm-pre-commit) with the note and header `## Data Collection` placed in the module's `_footer.md` beforehand

{{% /notice %}}

{{< highlight lineNos="false" type="markdown" wrap="true" title="" >}}

### Data Collection

{{% include file="/static/includes/telemetry-information-notice.md" %}}
{{< /highlight >}}

### Module Class Applicability

This specification applies to all AVM module classes (resource, pattern, utility), however, in case of utility modules, telemetry collection **MUST** only be added when the utility module deploys any resources (e.g., a deployment script resource). If the utility module does not deploy any resources, telemetry collection **MUST NOT** be added.

### Bicep

{{% notice style="important" %}}
Published CSV files in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) remain available for consumers and checks that look up assigned telemetry prefixes. To see their formatted content with additional information, visit the [AVM Module Indexes]({{% siteparam base %}}/indexes) page.

Record the assigned prefix in `telemetryIdPrefix` in the module's `metadata.json`, including a child's own file when applicable. Place it alongside the module's `main.bicep` before compiling, and read only that value in Bicep with `loadJsonContent('metadata.json', 'telemetryIdPrefix')` instead of hardcoding it. Preserve existing identifiers. Corrections follow the [metadata review process]({{% siteparam base %}}/contributing/module-metadata/); assignment of a new identifier requires the AVM core team.

Assigned values are also published in the [Resource Module]({{% siteparam base %}}/indexes/bicep/bicep-resource-modules/#module-name-and-telemetry-id-prefix), [Pattern Module]({{% siteparam base %}}/indexes/bicep/bicep-pattern-modules/#module-name-and-telemetry-id-prefix), and [Utility Module]({{% siteparam base %}}/indexes/bicep/bicep-utility-modules/#module-name-and-telemetry-id-prefix) indexes. Ask the AVM core team to resolve any discrepancy with metadata rather than inventing or replacing an identifier.
{{% /notice %}}

The ARM deployment name used for the telemetry **MUST** follow the pattern and **MUST** be no longer than 64 characters in length: `46d3xbcp.<res/ptn>.<(short) module name>.<version>.<uniqueness>`

- `<res/ptn>` == AVM Resource or Pattern Module
- `<(short) module name>` == The AVM Module's, possibly shortened, name including the resource provider and the resource type, **without**;
  - The prefixes: `avm-res-`
  - The prefixes: `avm-ptn-`
- `<version>` == The AVM Module's MAJOR.MINOR version (only) with `.` (periods) replaced with `-` (hyphens), to allow simpler splitting of the ARM deployment name
- `<uniqueness>` == This section of the ARM deployment name is to be used to ensure uniqueness of the deployment name.
  - This is to cater for the following scenarios:
    - The module is deployed multiple times to the same:
      - Location/Region
      - Scope (Tenant, Management Group,Subscription, Resource Group)

{{% notice style="note" %}}

Due to the 64-character length limit of Azure deployment names, the `<(short) module name>` segment has a length limit of 36 characters, so if the module name is longer than that, it **MUST** be truncated to 36 characters. If any of the semantic version's segments are longer than 1 character, it further restricts the number of characters that can be used for naming the module.

{{% /notice %}}

An example deployment name for the AVM Virtual Machine Resource Module would be: `46d3xbcp.res.compute-virtualmachine.1-2-3.eum3`

An example deployment name for a shortened module name would be: `46d3xbcp.res.desktopvirtualization-appgroup.1-2-3.eum3`

{{% notice style="tip" %}}

**Terraform**: Terraform uses a metadata-backed empty Azure deployment generated by `Avm.Authoring`; it does not require a separate telemetry provider.

**General**: See the language specific contribution guides for detailed guidance and sample code to use in AVM modules to achieve this requirement.

- [Bicep]({{% siteparam base %}}/contributing/bicep/)
- [Terraform]({{% siteparam base %}}/contributing/terraform/)

{{% /notice %}}

### Terraform

Instrumented Terraform roots and child modules **MUST** obtain their assigned `46d3xtrf` `telemetryIdPrefix` and `canonicalType` from their own `metadata.json`. The prefix **MUST NOT** be reconstructed from a module source or hardcoded in generated Terraform. Terraform prefixes **MUST** be `46d3xtrf.<res|ptn|utl>.<seven lowercase hexadecimal characters>` (20 characters). Children without a telemetry prefix, including telemetry-free helpers and utilities, **MUST NOT** create a telemetry deployment.

[`Avm.Authoring`](https://www.powershellgallery.com/packages/Avm.Authoring) **MUST** generate and maintain `main.telemetry.tf` rather than requiring module authors to maintain telemetry resources. When `var.enable_telemetry` is true, this file **MUST** create an empty, incremental `Microsoft.Resources/deployments@2025-04-01` deployment using `azapi_resource` at the active subscription scope. The deployment location follows [SFR4]({{% siteparam base %}}/spec/SFR4/).

The deployment name is the reporting payload. It **MUST** have the form `<telemetryIdPrefix>.<version>.<source>.<instance>` and **MUST NOT** exceed 64 characters:

| Segment | Value |
| --- | --- |
| `telemetryIdPrefix` | The fixed metadata identifier, which the module catalog maps to its canonical type. |
| `version` | The installed full version from the Terraform modules manifest entry matching `path.module`, with periods replaced by hyphens. Use `0-0-0` when a version is unavailable. |
| `source` | One character derived from the manifest source: `t` for Terraform Registry, `o` for OpenTofu Registry, `g` for Git, or `x` for other sources. Never include a raw source path. |
| `instance` | The first four lowercase hex characters of a hash of the stable provider-free `terraform_data.telemetry` instance ID. |

The generated resource **MUST** reject an invalid or overlong version token rather than truncate reporting data. It **MUST NOT** send telemetry tags; Azure deployment events provide the time, subscription, and caller context. An output in the empty template **MUST** change with `plantimestamp()` on every normal plan solely to force an in-place deployment write, including on otherwise no-op applies; this output is not reporting data. Refresh-only operations do not create a telemetry write.

The deployment **MUST** fail the apply if Azure rejects it, unless the consumer disables telemetry with `enable_telemetry = false`. With telemetry enabled, the deployment identity needs `Microsoft.Resources/deployments/read`, `Microsoft.Resources/deployments/write`, and `Microsoft.Resources/deployments/delete` at the active subscription scope. See the [telemetry guidance]({{% siteparam base %}}/help-support/telemetry/) for the opt-out and location override.

The generated configuration **MUST NOT** require the `modtm` provider or add per-resource AzAPI telemetry headers. During the supported migration window, existing `modtm_telemetry.telemetry` and telemetry-only `random_uuid.telemetry` state **MUST** be forgotten with declarative `removed` blocks using `destroy = false`, without destroying either object. Terraform still needs the old providers available for one final initialization when an existing state refers to them; new installations and subsequent plans do not require `modtm`.
