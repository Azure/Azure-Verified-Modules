---
title: Child Module Publishing
description: How to set up a child module for publishing so that it can be directly referenced from the public bicep registry
---

Child resources are resources that exist only within the scope of another resource. For example, a virtual network subnet cannot exist without a virtual network. The subnet is a child resource of the virtual network.

In the context of AVM, particularly AVM Bicep resource modules, child modules are modules deploying child resources. They are implemented within the scope of their corresponding parent resource modules. For example, the module `avm/res/network/virtual-network/subnet` deploys a virtual network subnet and is a child module of its parent virtual network module `avm/res/network/virtual-network`.

By default, child modules are not published to the public bicep registry independently from their parents. They need to be explicitly enabled for publishing to be directly referenced from the registry.

This page covers step-by-step guidelines to publish a bicep child module.

{{% notice style="important" %}}

The child module publishing process is currently in a pilot/preview phase. This means it may not be as smooth as the general module publishing.

The core team is currently working on additional automation, with the goal of improving efficiency in addressing child module publishing requests.

{{% /notice %}}

{{% notice style="note" %}}

Child module publishing currently only applies to resource modules.

Supporting child module publishing for other module categories, such as pattern and utility modules, is not planned at this time.

{{% /notice %}}

## Quick guide

Use this section for a fast overview on how to publish a child module.
For a step-by-step explanation with detailed instructions, refer to the following sections.

* **Check prerequisites**: Existing [issue in AVM](https://github.com/Azure/Azure-Verified-Modules/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22Class%3A%20Child%20Module%20%3Apackage%3A%22%20label%3A%22Language%3A%20Bicep%20%3Amuscle%3A%22), telemetry ID prefix assigned in [Bicep Module Index CSV](https://github.com/Azure/Azure-Verified-Modules/blob/main/docs/static/module-indexes/BicepResourceModules.csv), module registered in the [MAR-file](https://github.com/microsoft/mcr/blob/main/teams/bicep/bicep.yml).
* Implement required changes in your fork:
  * **Allowed list**: If not present, add child module to [child-module-publish-allowed-list.json](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/staticValidation/compliance/helper/child-module-publish-allowed-list.json).
  * **Child module template**: Add `enableTelemetry` parameter and `avmTelemetry` deployment to child `main.bicep` template.
  * **Parent module template**: In the `main.bicep` template of the child module direct parent, add a `enableReferencedModulesTelemetry` variable with a value of `false`, and pass it as the `enableTelemetry` value down to the child module deployment.
  * **Version**: Add the `version.json` file to the child module folder and set version to `0.1`.
  * **Changelog**: Add a new `CHANGELOG.md` file to the child module folder and update the changelog of all its versioned parents with a new patch version, up to the top-level parent.
  * **Set-AVMModule**: Run the [Set-AVMModule](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/tools/Set-AVMModule.ps1) utility using the `-Recurse` flag and the path to the top-level module, test your changes and raise a PR.

## Prerequisites

Before jumping into the implementation, make sure the following prerequisites are in place:

### Bicep Child Module Proposal issue

Ensure there is an [AVM issue open](https://github.com/Azure/Azure-Verified-Modules/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22Class%3A%20Child%20Module%20%3Apackage%3A%22%20label%3A%22Language%3A%20Bicep%20%3Amuscle%3A%22) already, proposing the child module to be published. If not, please create one using the [Bicep Child Module Proposal issue template](https://github.com/Azure/Azure-Verified-Modules/issues/new?template=4_module_proposal_bicep_child.yml).

{{% notice style="note" %}}

Please understand the difference between publishing an existing child module and extending a parent module with a not yet implemented child module functionality.

The Bicep Child Module Proposal issue intends to cover the former, so the intended child module MUST already exist in the [BRM (Bicep Registry Modules)](https://aka.ms/BRM) repository source code.

{{% /notice %}}

### Telemetry ID prefix assigned

Follow the below steps to check the child module telemetry ID prefix.

{{% notice style="note" %}}

If the Bicep Child Module Proposal issue was just created, please allow a few days for the telemetry ID prefix to be assigned before reaching out.

{{% /notice %}}

1. Check the online Bicep resource module index source CSV file [here](https://github.com/Azure/Azure-Verified-Modules/blob/main/docs/static/module-indexes/BicepResourceModules.csv).
1. Search for the child module name in the `ModuleName` field.
1. Verify if the corresponding value exists in the `TelemetryIdPrefix` field. Note down the value as you will need it in the implementation phase.
1. If not found, please reach out to the core team, mentioning the `@Azure/avm-core-team-technical-bicep` via the Bicep Child Module Proposal issue.

### Module registered in the MAR-file

Ensure that the child module is registered in the [MAR-file](https://github.com/microsoft/mcr/blob/main/teams/bicep/bicep.yml).
If not, please reach out to the core team, mentioning the `@Azure/avm-core-team-technical-bicep` via the Bicep Child Module Proposal issue.

{{% notice style="note" %}}

The MAR-file can only be accessed by Microsoft FTEs. If you are missing access, please reach out to the parent module owner for help.

{{% /notice %}}

## Implementation

The quickest way to get the child module published is to enable it yourself, contributing via a pull request to the [BRM](https://aka.ms/BRM) repository.

Please follow the steps below:

- Make sure the child module name is listed in the publishing allowed list [child-module-publish-allowed-list.json](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/staticValidation/compliance/helper/child-module-publish-allowed-list.json). If not, add it to the file, keeping an alphabetical order. This step is relevant until the process is in a pilot phase.
- Update the child module `main.bicep` template to support telemetry, as per [SFR4]({{% siteparam base %}}/spec/SFR4), [SFR3]({{% siteparam base %}}/spec/SFR3) and [BCPFR4]({{% siteparam base %}}/spec/BCPFR4)
  - Add the `enableTelemetry` parameter with a default value of `true`.
    ```bicep
    @description('Optional. Enable/Disable usage telemetry for module.')
    param enableTelemetry bool = true
    ```
  - Add the `avmTelemetry` deployment, referencing below template. Make sure to replace the `<ReplaceWith-TelemetryIdPrefix>` placeholder with the assigned telemetry ID prefix value that you noted down when checking prerequisites.
    ```bicep
      #disable-next-line no-deployments-resources
      resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
        name: '<ReplaceWith-TelemetryIdPrefix>.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
        properties: {
          mode: 'Incremental'
          template: {
            '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            contentVersion: '1.0.0.0'
            resources: []
            outputs: {
              telemetry: {
                type: 'String'
                value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
              }
            }
          }
        }
      }
    ```
- Update the `main.bicep` template of the child module direct parent, as per [BCPFR7]({{% siteparam base %}}/spec/BCPFR7).
  - Add the `enableReferencedModulesTelemetry` variable with a default value of `false`.
    ```bicep
    var enableReferencedModulesTelemetry = false
    ```
  - Pass the `enableReferencedModulesTelemetry` variable as the `enableTelemetry` value down to the child module deployment.
    ```bicep
    enableTelemetry: enableReferencedModulesTelemetry
    ```
- Add the `version.json` file to the child module folder and set version to `0.1`.
  ```json
  {
    "$schema": "https://aka.ms/bicep-registry-module-version-file-schema#",
    "version": "0.1"
  }
  ```
- Update Changelogs
  - Add a new `CHANGELOG.md` file to the child module folder, with the following sample content. Make sure to replace the `<avm/res/path/to/child-module>` placeholder with the name of the child module.
    ```markdown
    # Changelog

    The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/<avm/res/path/to/child-module>/CHANGELOG.md).

    ## 0.1.0

    ### Changes

    - Initial version

    ### Breaking Changes

    - None
    ```
  - Update the changelog of all the child module's versioned parents with a new patch version, up to the top-level parent. Refer below for an example content section:
    ```markdown
      ## <CurrentMajor>.<CurrentMinor>.<CurrentPatch+1>

      ### Changes

      - Enabling child module `<avm/res/path/to/child-module>` for publishing (added telemetry option)

      ### Breaking Changes

      - None

    ```
- As per the defaultc pull request process, run the [Set-AVMModule](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/tools/Set-AVMModule.ps1) utility using the `-Recurse` flag and top-level parent's folder path. Then test your changes locally and/or via the top-level module pipeline, raise a PR and attach a status badge proving successful validation.

{{% notice style="tip" %}}

Reference [This pull request](https://github.com/Azure/bicep-registry-modules/pull/5503) as an example for proposing a child module for publishing.

{{% /notice %}}
