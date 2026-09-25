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

The Bicep ARM deployment name used for telemetry **MUST** follow `<telemetryIdPrefix>.<version>.<uniqueness>` and **MUST** be no longer than 64 characters, as shown in [BCPFR4]({{% siteparam base %}}/spec/BCPFR4).

- `<telemetryIdPrefix>` is the current value in the module's `metadata.json`. Newly assigned Bicep prefixes use `46d3xbcp.<res|ptn|utl>.<seven lowercase hexadecimal characters>` (20 characters); existing assigned identifiers remain valid until approved for replacement.
- `<version>` is the module version token with periods replaced by hyphens.
- `<uniqueness>` is a four-character value derived from `uniqueString` and the deployment context.

Do not truncate an identifier or version to meet the 64-character limit. If an approved new prefix replaces a longer one, retain all previous prefixes in `alternativeTelemetryIdPrefixes` in the same module's `metadata.json` for historical reporting.

{{% notice style="tip" %}}

**Terraform**: Terraform uses a telemetry provider, the configuration of which is the same for every module and is included in the template repo.

**General**: See the language specific contribution guides for detailed guidance and sample code to use in AVM modules to achieve this requirement.

- [Bicep]({{% siteparam base %}}/contributing/bicep/)
- [Terraform]({{% siteparam base %}}/contributing/terraform/)

{{% /notice %}}

### Terraform

To enable telemetry data collection for Terraform modules, the [modtm](https://registry.terraform.io/providers/Azure/modtm/latest) telemetry provider **MUST** be used. This lightweight telemetry provider sends telemetry data to Azure Application Insights via a HTTP POST front end service.

The `modtm` telemetry provider is included in all Terraform modules and is enabled by default through `main.telemetry.tf`, which is generated and maintained by [`Avm.Authoring`](https://www.powershellgallery.com/packages/Avm.Authoring).

The `modtm` provider **MUST** be listed under the `required_providers` section in the module's `terraform.tf` file using the following entry. This is also validated by the linter.

```terraform
terraform {
  required_providers {
    # .. other required providers as needed
    modtm = {
      source = "Azure/modtm"
      version = "~> 0.3"
    }
  }
}
```
