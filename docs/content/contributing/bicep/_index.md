---
title: Bicep Contribution Guide
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 2
---

{{< toc >}}

{{< hint type=tip >}}

Before submitting a new [module proposal](https://aka.ms/avm/moduleproposal) for either Bicep or Terraform, please review the FAQ section on ["CARML/TFVM to AVM Evolution Details"](/Azure-Verified-Modules/faq/#carmltfvm-to-avm-evolution-details)

{{< /hint >}}

{{< hint type=important >}}
While this page describes and summarizes important aspects of contributing to AVM, it only references *some* of the shared and language specific requirements.

Therefore, this contribution guide **MUST** be used in conjunction with the [Shared Specification](/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](/Azure-Verified-Modules/specs/bicep/) specifications. **ALL AVM modules** (Resource and Pattern modules) **MUST meet the respective requirements described in these  specifications**!
{{< /hint >}}

<br>

## Recommended Learning

Before you start contributing to the AVM, it is **highly recommended** that you complete the following Microsoft Learn paths, modules & courses:

### Bicep

- [Deploy and manage resources in Azure by using Bicep](https://learn.microsoft.com/learn/paths/bicep-deploy/)
- [Structure your Bicep code for collaboration](https://learn.microsoft.com/learn/modules/structure-bicep-code-collaboration/)
- [Manage changes to your Bicep code by using Git](https://learn.microsoft.com/learn/modules/manage-changes-bicep-code-git/)

### Git

- [Introduction to version control with Git](https://learn.microsoft.com/learn/paths/intro-to-vc-git/)

<br>

## Tooling

### Required Tooling

To contribute to this project the following tooling is required:

- [Git](https://git-scm.com/downloads)

  If just installed, don't forget to set both your git username & password

    ```PowerShell
    git config --global user.name "John Doe"
    git config --global user.email "johndoe@example.com"
    ```

- [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install#install-manually)

  {{< hint type=note >}}

  Must be manually kept up-to-date.

  {{< /hint >}}

- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Bicep extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)

### Recommended Tooling

The following tooling/extensions are recommended to assist you developing for the project:

- [CodeTour extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.codetour)
- [ARM Tools extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
- [ARM Template Viewer extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=bencoleman.armview)
- [PSRule extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=bewhite.psrule-vscode)
- [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- For visibility of Bracket Pairs:
  - Inside Visual Studio Code, add `editor.bracketPairColorization.enabled`: true to your `settings.json`, to enable bracket pair colorization.

<br>

## Lay of the land

### Repositories

Bicep AVM Modules (both Resource and Pattern modules) will be homed in the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository and live within an `avm` directory that will be located at the root of the repository, as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

Module owners are expected to fork the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository and work on a branch from within their fork, before then creating a Pull Request (PR) back into the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository's `main` branch.

### Directory and File Structure

Each Bicep AVM module that lives within the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository in the `avm` directory will have the following directories and files:

- `tests/` - (for unit tests and additional E2E/integration if required - e.g. Pester etc.)
  - `e2e/` - (all examples must deploy successfully - these will be used to automatically generate the examples in the README.md for the module)
- `modules/` - (for sub-modules only if used and NOT children of the primary resource. e.g. RBAC role assignments)
- `/...` - (Module files that live in the root of module directory)
  - `main.bicep` (AVM Module main `.bicep` file and entry point/orchestration module)
  - `main.json` (auto generated and what is published to the MCR via BRM)
  - `version.json` (BRM requirement)
  - `README.md` (auto generated AVM Module documentation)

#### Example Directory and File Structure within `Azure/bicep-registry-modules` Repository

```txt
/ Root of Azure/bicep-registry-modules
│
├───avm
│   ├───ptn
│   │   └───apptiervmss
│   │       │   main.bicep
│   │       │   main.json
│   │       │   README.md
│   │       │   version.json
│   │       │
│   │       ├───modules
│   │       └───tests
│   │           ├───unit (optional)
│   │           └───e2e
│   │               ├───defaults
│   │               ├───waf-aligned
│   │               └───max
│   │
│   └───res
│       └───compute
│           └───virtual-machine
│               │   main.bicep
│               │   main.json
│               │   README.md
│               │   version.json
│               │
│               ├───modules
│               └───tests
│                   ├───unit (optional)
│                   └───e2e
│                       ├───defaults
│                       ├───waf-aligned
│                       └───max
├───other repo dirs...
└───other repo files...
```

<br>

## Composition

{{< hint type=important >}}

Before jumping on implementing your contribution, please review the AVM Module specifications, in particular the [Shared](https://azure.github.io/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](https://azure.github.io/Azure-Verified-Modules/specs/bicep/) pages, to make sure your contribution complies with the AVM module's design and principles.

{{< /hint >}}

<br>

### Code Styling

This section points to conventions to be followed when developing a Bicep template.

<br>

### Casing

Use `camelCasing` as per [BCPNFR8](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr8---category-composition---code-styling---lower-camelcasing).

---

#### Input Parameters and Variables

Make sure to review all specifications of `Category: Inputs` within both the [Shared](https://azure.github.io/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](https://azure.github.io/Azure-Verified-Modules/specs/bicep/) pages.

{{< hint type=tip >}}
See examples in specifications [SNFR14](/Azure-Verified-Modules/specs/shared/#id-snfr14---category-inputs---data-types) and [BCPNFR1](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr1---category-inputs---data-types).
{{< /hint >}}

---

#### Resources

Resources are primarily leveraged by resource modules to declare the primary resource of the main resource type deployed by the AVM module.

Make sure to review all specifications covering resource properties and usage.

{{< hint type=tip >}}
See examples in specifications [SFR1](/Azure-Verified-Modules/specs/shared/#id-sfr1---category-composition---preview-services) and [RMFR1](/Azure-Verified-Modules/specs/shared/#id-rmfr1---category-composition---single-resource-only).
{{< /hint >}}

---

#### Modules

Modules enable you to reuse code from a Bicep file in other Bicep files. As such, for resource modules they're normally leveraged for deploying child resources (e.g., file services in a storage account), cross referenced resources (e.g., network interface in a virtual machine) or extension resources (e.g., role assignments in a key vault). Pattern modules, normally reuse resource modules combined together.

Make sure to review all specifications covering module properties and usage.

{{< hint type=tip >}}
See examples in specifications [BCPFR1](/Azure-Verified-Modules/specs/bicep/#id-bcpfr1---category-composition---cross-referencing-modules) for resource modules and [PMNFR2](//Azure-Verified-Modules/specs/shared/#id-pmnfr2---category-composition---use-resource-modules-to-build-a-pattern-module) for pattern modules.
{{< /hint >}}

---

#### Outputs

Make sure to review all specifications of `Category: Outputs` within both the [Shared](https://azure.github.io/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](https://azure.github.io/Azure-Verified-Modules/specs/bicep/) pages.

{{< hint type=tip >}}
See examples in specification [RMFR7](/Azure-Verified-Modules/specs/shared/#id-rmfr7---category-outputs---minimum-required-outputs).
{{< /hint >}}

---

<br>

### Interfaces

{{< hint type=note >}}

This section is only relevant for contributions to resource modules.

{{< /hint >}}

To meet [RMFR4](/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) and [RMFR5](/Azure-Verified-Modules/specs/shared/#id-rmfr5---category-composition---avm-consistent-feature--extension-resources-value-add-interfacesschemas) AVM resource modules must leverage consistent interfaces for all the optional features/extension resources supported by the AVM module primary resource.

Please refer to the [Shared Interfaces](/Azure-Verified-Modules/specs/shared/interfaces/) page.
If the primary resource of the AVM resource module you are developing supports any of the listed features/extension resources, please follow the corresponding provided Bicep schema to develop them.

The next paragraph provides an example for the Role assignments extension.

#### Example: RBAC Role Definition Name Mapping

To meet [BCPFR2](/Azure-Verified-Modules/specs/bicep/#id-bcpfr2---category-composition---role-assignments-role-definition-mapping), [BCPNFR5](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr5---category-composition---role-assignments-role-definition-mapping-limits) and [BCPNFR6](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr6---category-composition---role-assignments-role-definition-mapping-compulsory-roles) you can use the below code sample in your AVM Modules to achieve this.

{{< include file="/static/includes/sample.rbacMapping.bicep" language="bicep" options="linenos=false" >}}

<br>

### Telemetry Enablement

To meet [SFR3](/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry) & [SFR4](/Azure-Verified-Modules/specs/shared/#id-sfr4---category-telemetry---telemetry-enablement-flexibility) you can use the below code sample in your AVM Modules to achieve this.

{{< include file="/static/includes/sample.telem.bicep" language="bicep" options="linenos=false" >}}

<br>

### Versioning

To meet [SNFR16](/Azure-Verified-Modules/specs/shared/#id-snfr16---category-documentation---examples) and depending on the changes you make, you may need to bump the version in the `version.json` file.

{{< include file="/static/includes/sample.bicep.version.json" language="json" options="linenos=false" >}}

The `version` value is in the form of `MAJOR.MINOR`. The PATCH version will be incremented by the CI automatically when publishing the module to the Public Bicep Registry once the corresponding pull request is merged. Therefore, contributions that would only require an update of the patch version, can keep the `version.json` file intact.

For example, the `version` value should be:
- `0.1` for new modules, so that they can be released as `v0.1.0`.
- `1.0` once the module owner signs off the module is stable enough for it’s first Major release of `v1.0.0`.
- `0.x` for all feature updates between the first release `v0.1.0` and the first Major release of `v1.0.0`.

<br>

## Testing

{{< hint type=note >}}

The AVM core team is working to provide a CI environment used for testing the AVM Bicep modules in the Public Bicep Registry. Until the automation is ready, we kindly ask contributors to proceed with local and manual testing from their fork.

{{< /hint >}}

Before opening a Pull Request to the Bicep Public Registry, ensure your module is ready for publishing, by validating that it meets all the Testing Specifications as per [SNFR1](/Azure-Verified-Modules/specs/shared/#id-snfr1---category-testing---prescribed-tests), [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing), [SNFR3](/Azure-Verified-Modules/specs/shared/#id-snfr3---category-testing---avm-unit-tests), [SNFR4](/Azure-Verified-Modules/specs/shared/#id-snfr4---category-testing---additional-unit-tests), [SNFR5](/Azure-Verified-Modules/specs/shared/#id-snfr5---category-testing---upgrade-tests), [SNFR6](/Azure-Verified-Modules/specs/shared/#id-snfr6---category-testing---static-analysislinting-tests), [SNFR7](/Azure-Verified-Modules/specs/shared/#id-snfr7---category-testing---idempotency-tests).

For example, to meet [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing), ensure the updated module is deployable against a testing Azure subscription and compliant with the intended configuration.

### Testing Diagnostic Settings

To test the numerous diagnostic settings targets (Log Analytics Workspace, Storage Account, Event Hub, etc.) the AVM core team have provided a dependencies `.bicep` file to help create all these pre-requisite targets that will be needed during test runs.

{{< expand "Diagnostic Settings Dependencies - Bicep File" "expand/collapse" >}}

{{< include file="/static/includes/diagnostic.dependencies.bicep" language="bicep" options="linenos=false" >}}

{{< /expand >}}

{{< hint type=note >}}

Also note there are a number of additional scripts and utilities available [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utilities/e2e-template-assets/diagnostic.dependencies.bicep) that may be of use to module owners/contributors.

{{< /hint >}}

<br>

## Publishing to the Registry

When the AVM Modules are published to the Bicep Public Registry they **MUST** follow the below requirements:

- Resource Module: `avm-res-<rp>-<armresourcename>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `avm-ptn-<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

This will require the alias on the MCR to be different than the directory path, which is the default for BRM today.

***Guidance will be provided below on how to do this, when available.***
