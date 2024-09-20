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

### Deprecation

Breaking changes are sometimes not avoidable. The impact should be kept as low as possible. A recommendation is to [deprecate parameters](/Azure-Verified-Modules/specs/shared/#id-snfr18---category-release---breaking-changes), instead of completely removing them for a couple of versions. The [Semantic Versioning](/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning) sections offers information about versioning AVM modules.

In case you need to deprecate an input parameter, this sample shows you how this can be achieved.

{{< hint type=note >}}

Since all modules are versioned, nothing will change for existing deployments, as the parameter usage does not change for any existing versions.

{{< /hint >}}

#### Example-Scenario

An AVM module is modified, and the parameters will change, which breaks backward compatibility.

- parameters are changing to a custom type
- the parameter structure is changing
- backward compatibility will be maintained

Existing **input parameters** used to be definined as follows (reducing the examples to the minimum):

```bicep
// main.bicep:
param item object?

// main.test.bicep:
name: 'name'
item:
  {
    variant: 'Large'
    osType: 'Windows'
  }
```

#### Testing

Before you begin to modify anything, it is recommended to create a new test case (e.g. *deprecated*), in addition to the already existing tests, to make sure that the changes are not breaking backward compatibility until you decide to finally remove the deprecated parameters (see [BCPRMNFR1 - Category: Testing - Expected Test Directories](/Azure-Verified-Modules/specs/bicep/#id-bcprmnfr1---category-testing---expected-test-directories) for more details about the requirements).

```bicep
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      item: {
        variant: 'Large'
        osType: 'Linux'
      }
    }
  }
]
```

The test should include all previously used parameters to make sure they are covered before any changes to the new parameter layout are done.

#### Code Changes

The **new parameter structure** requires a change to the used parameters and moves them to a different location and looks like:

```bicep
// main.bicep:
param item itemType?

type itemType = {
  name: string // the name parameter did not change

  properties ={
    osType: 'Linux' | 'Windows'? // the new place for the osType

    variant: {
      size: string? // the new place for the variant size
    }?
  }

  // keep theese for backwards compatibility in the new type
  @description('Optional. Note: This is a deprecated property, please use the corresponding `properties.osType` instead.')
  osType: string? // the old parameter location

  @description('Optional. Note: This is a deprecated property, please use the corresponding `properties.variant.size` instead.')
  variant: string? // the old parameter location
}
```

The original parmeter *item* is of type object and does not give the user any clue of what the syntax is and what is expected to be added to it. The tests could bring light into the darkness, but this is not ideal. In order to retain backwards compatibility, the previously used parameters need to be added to the new type, as they would be invalid otherwise. Now that the new type is in place, some logic needs to be implemented to make sure the module can handle the different sources of data (new and old parameters).

```bicep
resource <modulename> 'Microsoft.xy/yz@2024-01-01' = {
  name: name
  properties: {
    osType: item.?properties.?osType ?? item.?osType ?? 'Linux' // add a default here, if needed
    variant: {
      size: item.?properties.?variant.?size ?? item.?variant
    }
  }
}
```

By choosing this order for the [Coalesce](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/operators-logical#coalesce-) operator, the new format takes precedence over the old syntax. Also note the [safe-dereference](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/operator-safe-dereference#safe-dereference) ensures that no null reference exception will occure if the property has optional parameters.

The tests can now be changed to adapt the new parameter structure for the new version of the module. They will not cover the old parameter structure anymore.

```bicep
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      item:{
        osType: 'Linux'
        variant: {
          size: 'Large'
        }
      }
    }
  }
]
```

#### Summary

Changes to modules (resource or pattern) can bei implemented in two ways.

1. Implement changes with backwards compatibility

    In this scenario you need to make sure that the code does not break backwards compatibility by:

    - adding new parameters
    - marking other parameters as deprecated
    - create a testcase for the old usage syntax
    - increase the minor version number of the module (0.x)

2. Introduce breaking changes

    The easier way to introduce a new major version requires fewer steps:

    - adding new parameters
    - create a test case for the usage
    - increase the major version number of the module (x.0)

{{< hint type=note >}}

Be aware that currently no module has been released as 1.0, which let's you implement breaking changes without increasing the major version.

{{< /hint >}}
