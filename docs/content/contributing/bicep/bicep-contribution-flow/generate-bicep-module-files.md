As per the module design structure ([BCPFR3](/Azure-Verified-Modules/specs/bicep/#id-bcpfr3---category-composition---directory-and-file-structure)), every module in the AVM library requires
- a up-to-date ReadMe markdown (`readme.md`) file documenting the set of deployable resource types, input and output parameters and a set of relevant template references from the official Azure Resource Reference documentation
- an up-to-date compiled template (`main.json`) file

The `Set-AVMModule` utility aims to simplify contributing to the AVM library, as it supports
- idempotently generating the AVM folder structure for a module (including any child resource)
- generating the module's ReadMe file from scratch or updating it
- compiling/building the module template

To ease maintenance, you can run the utility with a `Recurse` flag from the root of your folder to update all files automatically.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [How to use it](#how-to-use-it)

---
# Location

You can find the script under [`avm/utilities/tools/Set-AVMModule.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utilities/tools/Set-AVMModule.ps1)

# How it works

Using the provided template path, the script
1. validates the module's folder structure
    - To do so, it searches for any required folder path / file missing and adds them. For several files, it will also provide some default content to get you started. The sources files for this action can be found [here](https://github.com/Azure/bicep-registry-modules/tree/main/avm/utilities/tools/helper/src)
1. compiles its bicep template
1. updates the readme (recursively, specified)
    1. If the intended readMe file does not yet exist in the expected path, it is generated with a skeleton (with e.g., a generated header name)
    1. The script then goes through all sections defined as `SectionsToRefresh` (by default all) and refreshes the sections' content (for example, for the `Parameters`) based on the values in the ARM/JSON Template. It detects sections by their header and always regenerates the full section.
    1. Once all are refreshed, the current ReadMe file is overwritten. **Note:** The script can be invoked combining the `WhatIf` and `Verbose` switches to just receive an console-output of the updated content.

# How to use it

For details on how to use the function, please refer to the script's local documentation.

{{< hint type=note >}}

The script must be loaded ('_dot-sourced_') before the function can be invoked.
```PowerShell
. 'C:/dev/Set-AVMModule.ps1'
Set-AVMModule (...)
```

{{< /hint >}}

{{< hint type=tip >}}

For modules that require the generation of files on multiple-levels (for example, a module with child modules such as the 'Key Vault' module with its 'Secret' child module) it is highly recommended to make use of the `-Recurse` parameter.

This parameter will ensure that the script not only generates the files for the provided module folder path, but also all its nested module folder paths.

{{< /hint >}}
