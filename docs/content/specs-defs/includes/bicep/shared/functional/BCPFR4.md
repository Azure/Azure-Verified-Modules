---
title: BCPFR4 - Telemetry Enablement
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPFR4
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Telemetry, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 10030
---

## ID: BCPFR4 - Category: Composition - Telemetry Enablement

To comply with specifications outlined in [SFR3]({{% siteparam base %}}/spec/SFR3) & [SFR4]({{% siteparam base %}}/spec/SFR4) you **MUST** incorporate the following code snippet into your modules. Place this code sample in the "top level" `main.bicep` file; it is not necessary to include it in any nested Bicep files (child modules), unless they are marked for direct publishing (Ref [Child module publishing]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/child-module-publishing)).

Before compiling, ensure the module's `metadata.json` exists alongside its `main.bicep` and contains its assigned `telemetryIdPrefix`. The example uses the `jsonPath` argument of [`loadJsonContent`](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-files#loadjsoncontent) to load only that value. Do not load the full metadata object: that embeds unrelated values, including owners and descriptions, in the compiled ARM template. If an assigned prefix is missing or conflicts with the module index, follow the [module metadata guidance]({{% siteparam base %}}/contributing/module-metadata/) rather than hardcoding or inventing one.

The current Bicep `telemetryIdPrefix` **MUST** use `46d3xbcp.<res|ptn|utl>.<seven lowercase hexadecimal characters>` (20 characters). When replacing a previously assigned identifier, retain it and any earlier prefixes in `alternativeTelemetryIdPrefixes` in the same `metadata.json`; the deployment uses only the current prefix. Check that the complete deployment name fits within 64 characters without truncation.

After changing `telemetryIdPrefix`, regenerate `main.json` with [`Set-AVMModule.ps1`]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/) without `-SkipBuild`. Consumers deploying the compiled `main.json` do not need `metadata.json`.

{{< highlight lineNos="false" type="bicep" wrap="true" title="sample.telem.bicep" >}}
{{% include file="/static/includes/sample.telem.bicep" %}}
{{< /highlight >}}
