---
title: Composition
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}


## Composition

{{< hint type=important >}}

Before jumping on implementing your contribution, please review the AVM Module specifications, in particular the [Shared](https://azure.github.io/Azure-Verified-Modules/specs/shared/) and the [Bicep specific](https://azure.github.io/Azure-Verified-Modules/specs/bicep/) pages, to make sure your contribution complies with the AVM module's design and principles.

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

<br>

### Code Styling

This section points to conventions to be followed when developing a Bicep template.

<br>

#### Casing

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
