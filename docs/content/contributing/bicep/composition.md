---
title: Bicep Composition
linktitle: Composition
---

{{% notice style="important" %}}
While this page describes and summarizes important aspects of the composition of AVM modules, it may not reference *All* of the shared and language specific requirements.

Therefore, this guide **MUST** be used in conjunction with the [Bicep specifications]({{% siteparam base %}}/specs/bcp/). **ALL AVM modules** (Resource and Pattern modules) **MUST meet the respective requirements described in these specifications**!
{{% /notice %}}

{{% notice style="important" %}}

Before jumping on implementing your contribution, please review the AVM Module specifications, in particular the [Bicep specification]({{% siteparam base %}}/specs/bcp/) page, to make sure your contribution complies with the AVM module's design and principles.

{{% /notice %}}

## Directory and File Structure

Each Bicep AVM module that lives within the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) (BRM) repository in the `avm` directory will have the following directories and files:

- `tests/` - (for unit tests and additional E2E/integration if required - e.g. Pester etc.)
  - `e2e/` - (all examples must deploy successfully - these will be used to automatically generate the examples in the README.md for the module)
- `modules/` - (for sub-modules only if used and NOT children of the primary resource. e.g. RBAC role assignments)
- `/...` - (Module files that live in the root of module directory)
  - `main.bicep` (AVM Module main `.bicep` file and entry point/orchestration module)
  - `main.json` (auto generated and what is published to the MCR via BRM)
  - `version.json` (BRM requirement)
  - `README.md` (auto generated AVM Module documentation)

### Directory and File Structure Example 

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

## Code Styling

This section points to conventions to be followed when developing a Bicep template.

### Casing

Use `camelCasing` as per [BCPNFR8]({{% siteparam base %}}/spec/BCPNFR8).

### Input Parameters and Variables

Make sure to review all specifications of `Category: Inputs/Outputs` within the [Bicep specification]({{% siteparam base %}}/specs/bcp/) pages.

{{% notice style="tip" %}}
See examples in specifications [SNFR14]({{% siteparam base %}}/spec/SNFR14) and [BCPNFR1]({{% siteparam base %}}/spec/BCPNFR1).
{{% /notice %}}

### Resources

Resources are primarily leveraged by resource modules to declare the primary resource of the main resource type deployed by the AVM module.

Make sure to review all specifications covering resource properties and usage.

{{% notice style="tip" %}}
See examples in specifications [SFR1]({{% siteparam base %}}/spec/SFR1) and [RMFR1]({{% siteparam base %}}/spec/RMFR1).
{{% /notice %}}

### Modules

Modules enable you to reuse code from a Bicep file in other Bicep files. As such, for resource modules they're normally leveraged for deploying child resources (e.g., file services in a storage account), cross referenced resources (e.g., network interface in a virtual machine) or extension resources (e.g., role assignments in a key vault). Pattern modules, normally reuse resource modules combined together.

Make sure to review all specifications covering module properties and usage.

{{% notice style="tip" %}}
See examples in specifications [BCPFR1]({{% siteparam base %}}/spec/BCPFR1) for resource modules and [PMNFR2](/{{% siteparam base %}}/spec/PMNFR2) for pattern modules.
{{% /notice %}}

### Outputs

Make sure to review all specifications of `Category: Inputs/Outputs` within the [Bicep specific]({{% siteparam base %}}/specs/bcp/) pages.

{{% notice style="tip" %}}
See examples in specification [RMFR7]({{% siteparam base %}}/spec/RMFR7).
{{% /notice %}}

## Interfaces

{{% notice style="note" %}}

This section is only relevant for contributions to resource modules.

{{% /notice %}}

To meet [RMFR4]({{% siteparam base %}}/spec/RMFR4) and [RMFR5]({{% siteparam base %}}/spec/RMFR5) AVM resource modules must leverage consistent interfaces for all the optional features/extension resources supported by the AVM module primary resource.

Please refer to the [Bicep Interfaces]({{% siteparam base %}}/specs/bcp/res/interfaces/) page.
If the primary resource of the AVM resource module you are developing supports any of the listed features/extension resources, please follow the corresponding provided Bicep schema to develop them.

## Deprecation

Breaking changes are sometimes not avoidable. The impact should be kept as low as possible. A recommendation is to [deprecate parameters]({{% siteparam base %}}/spec/SNFR18), instead of completely removing them for a couple of versions. The [Semantic Versioning]({{% siteparam base %}}/spec/SNFR17) sections offers information about versioning AVM modules.

In case you need to deprecate an input parameter, this sample shows you how this can be achieved.

{{% notice style="note" %}}

Since all modules are versioned, nothing will change for existing deployments, as the parameter usage does not change for any existing versions.

{{% /notice %}}

### Example-Scenario

An AVM module is modified, and the parameters will change, which breaks backward compatibility.

- parameters are changing to a custom type
- the parameter structure is changing
- backward compatibility will be maintained

Existing **input parameters** used to be defined as follows (reducing the examples to the minimum):

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

### Testing

Before you begin to modify anything, it is recommended to create a new test case (e.g. *deprecated*), in addition to the already existing tests, to make sure that the changes are not breaking backward compatibility until you decide to finally remove the deprecated parameters (see [BCPRMNFR1 - Category: Testing - Expected Test Directories]({{% siteparam base %}}/spec/BCPRMNFR1) for more details about the requirements).

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

### Code Changes

The **new parameter structure** requires a change to the used parameters and moves them to a different location and looks like:

```bicep
// main.bicep:
param item itemType?

type itemtype: {
  name: string // the name parameter did not change

  properties ={
    osType: 'Linux' | 'Windows'? // the new place for the osType

    variant: {
      size: string? // the new place for the variant size
    }?
  }

  // keep these for backward compatibility in the new type
  @description('Optional. Note: This is a deprecated property, please use the corresponding `properties.osType` instead.')
  osType: string? // the old parameter location

  @description('Optional. Note: This is a deprecated property, please use the corresponding `properties.variant.size` instead.')
  variant: string? // the old parameter location
}
```

The original parameter *item* is of type object and does not give the user any clue of what the syntax is and what is expected to be added to it. The tests could bring light into the darkness, but this is not ideal. In order to retain backward compatibility, the previously used parameters need to be added to the new type, as they would be invalid otherwise. Now that the new type is in place, some logic needs to be implemented to make sure the module can handle the different sources of data (new and old parameters).

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

### Summary

Changes to modules (resource or pattern) can bei implemented in two ways.

1. Implement changes with backward compatibility

    In this scenario, you need to make sure that the code does not break backward compatibility by:

    - adding new parameters
    - marking other parameters as deprecated
    - create a test case for the old usage syntax
    - increase the minor version number of the module (0.x)

2. Introduce breaking changes

    The easier way to introduce a new major version requires fewer steps:

    - adding new parameters
    - create a test case for the usage
    - increase the major version number of the module (`x.0.0`)

{{% notice style="note" %}}

Be aware that currently no module has been released as `1.0.0` (or beyond), which lets you implement breaking changes without increasing the major version.

{{% /notice %}}
