---
title: Generate Bicep Module Files
linktitle: Update Module Files
---

As per the module design structure ([BCPFR3]({{% siteparam base %}}/spec/BCPFR3)), every module in the AVM library requires
- a up-to-date ReadMe markdown (`readme.md`) file documenting the set of deployable resource types, input and output parameters and a set of relevant template references from the official Azure Resource Reference documentation
- an up-to-date compiled template (`main.json`) file

The `Set-AVMModule` utility aims to simplify contributing to the AVM library, as it supports
- idempotently generating the AVM folder structure for a module (including any child resource)
- generating the module's ReadMe file from scratch or updating it
- compiling/building the module template

To ease maintenance, you can run the utility with a `Recurse` flag from the root of your folder to update all files automatically.

## Location

You can find the script under [`utilities/tools/Set-AVMModule.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/tools/Set-AVMModule.ps1)

## How it works

Using the provided template path, the script
1. validates the module's folder structure
    - To do so, it searches for any required folder path / file missing and adds them. For several files, it will also provide some default content to get you started. The sources files for this action can be found [here](https://github.com/Azure/bicep-registry-modules/tree/main/utilities/tools/helper/src)
1. compiles its bicep template
1. updates the readme (recursively, specified)
    1. If the intended readMe file does not yet exist in the expected path, it is generated with a skeleton (with e.g., a generated header name)
    1. The script then goes through all sections defined as `SectionsToRefresh` (by default all) and refreshes the sections' content (for example, for the `Parameters`) based on the values in the ARM/JSON Template. It detects sections by their header and always regenerates the full section.
    1. Once all are refreshed, the current ReadMe file is overwritten. **Note:** The script can be invoked combining the `WhatIf` and `Verbose` switches to just receive an console-output of the updated content.

## How to use it

For details on how to use the function, please refer to the script's local documentation.

{{% notice style="note" %}}

The script must be loaded ('_dot-sourced_') before the function can be invoked.
```PowerShell
. 'C:/dev/Set-AVMModule.ps1'
Set-AVMModule (...)
```

{{% /notice %}}

{{% notice style="tip" %}}

For modules that require the generation of files on multiple-levels (for example, a module with child modules such as the 'Key Vault' module with its 'Secret' child module) it is highly recommended to make use of the `-Recurse` parameter.

This parameter will ensure that the script not only generates the files for the provided module folder path, but also all its nested module folder paths.

{{% /notice %}}

{{% notice style="tip" %}}

While readme files are **always** generated from scratch, you can add custom content is specific places that the script will preserve:
- The module's description in the `main.bicep` file's metadata
- The description of parameters & outputs
- A section with the header `## Notes`

If the utility finds a section with the heading `## Notes`, it temporarily saves this content when it regenerates the readme file and then re-inserts (i.e. appends) the section towards the end of the readme file. This section **may** contain images, which must be stored in a subfolder `/src` in the root directory of the module.

Both for the text & images, please make sure to only add what provides tangible value as the content must be manually maintained and should not run stale. Further, for images, please make sure to only store them with an appropriate resolution & size to keep their impact on the repository's size manageable.

{{% /notice %}}
