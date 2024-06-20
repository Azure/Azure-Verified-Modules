---
title: Composition
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

<!--
TODO: Should contain
- Repository composition
- Module composition
-->

{{< hint type=important >}}
While this page describes and summarizes important aspects of the composition of AVM modules, it may not reference *All* of the shared and language specific requirements.

Therefore, this guide **MUST** be used in conjunction with the [Shared Specification](/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](/Azure-Verified-Modules/specs/bicep/) specifications. **ALL AVM modules** (Resource and Pattern modules) **MUST meet the respective requirements described in these specifications**!
{{< /hint >}}

## Composition

{{< hint type=important >}}

Before jumping on implementing your contribution, please review the AVM Module specifications, in particular the [Shared](/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](/Azure-Verified-Modules/specs/bicep/) pages, to make sure your contribution complies with the AVM module's design and principles.

{{< /hint >}}

<br>

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

For a new module (res or ptn), the files can be created automatically, once the parent folder exists. This example shows how to create a res module `res/compute/virtual-machine`.

```powershell
Set-Location -Path ".\avm\"
New-Item -ItemType Directory -Path ".\res\compute\virtual-machine"
Set-AVMModule -ModuleFolderPath .\res\compute\virtual-machine
```

<br>

### Code Styling

This section points to conventions to be followed when developing a Bicep template.

<br>

#### Casing

Use `camelCasing` as per [BCPNFR8](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr8---category-composition---code-styling---lower-camelcasing).

---

#### Input Parameters and Variables

Make sure to review all specifications of `Category: Inputs` within both the [Shared](/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](/Azure-Verified-Modules/specs/bicep/) pages.

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

Make sure to review all specifications of `Category: Outputs` within both the [Shared](/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](/Azure-Verified-Modules/specs/bicep/) pages.

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

<br>
