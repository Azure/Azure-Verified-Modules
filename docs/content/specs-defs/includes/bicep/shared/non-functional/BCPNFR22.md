---
title: BCPNFR22 - Bicep Module Changelog
description: Module changes are written to a changelog
url: /spec/BCPNFR22
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Release/Publishing, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  # Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 11016
---

## ID: BCPNFR22 - Category: Publishing - Changelog

When a module to be published (i.e., that has a `version.json` file) is changed, an entry **MUST** be created in the `CHANGELOG.md` file in the module folder. A link to the latest version of the changelog file has to be included at the top of the file, just below the `# Changelog` line. It is surrounded by empty lines.



```text
# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/<ptn|res|utl>/<namespace/modulename[/submodulePath]>/CHANGELOG.md).

```

For each new version, an entry **MUST** be created above all existing versions in the `CHANGELOG.md` file of the module.

```text
## <version>

### Changes

- This changed
- And this also

### Breaking Changes

- None
```

Each version's entry:

- **MUST** contain two sections: `Changes` and `Breaking Changes`. At least one of them must have a meaningful entry and sections must not be left empty. A `- None` may be added as content for a section.
- **MUST** exist only once.
- All versions appear in descending order, which puts the most recent changes at the top.

What **SHOULD** be listed in the (Breaking) Changes section:

- Relevant changes for the module
- Changes in tests do *not* need to be added

{{% notice style="note" %}}

The versioning is following the [SNFR17 - Semantic Versioning]({{% siteparam base %}}/spec/SNFR17/) spec.

{{% /notice %}}

### Example content of the CHANGELOG.md

A `CHANGELOG.md` file in the module's root folder **MUST** start with the `# Changelog` header, followed by an empty line and a link to the latest published version of the changelog file, followed by another empty line. A section for each published version follows. Newer versions are placed above older versions.

```text
# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/aad/domain-service/CHANGELOG.md).

## 0.2.1

### Changes

- Updated the referenced AVM common types

### Breaking Changes

- None

## 0.2.0

### Changes

- Implemented the minCPU parameter
- Updated the referenced VirtualNetwork module
- Updated the referenced AVM common types

### Breaking Changes

- The minCPU parameter is mandatory

## 0.1.0

### Changes

- Initial Release

### Breaking Changes

- None

```

Each bullet point should start with a capital letter.

### Manual Editing

It is possible to modify the changelog content any time, e.g., to add missing versions, which will not create a new release of the module itself. Please note the following requirements in all cases:

- All versions in the file, need to be valid and available as published version
- Every version needs the two sections `## Changes` and `## Breaking Changes` with content

{{% notice style="note" %}}

Azure Verified Modules are artifacts in the Microsoft Container Registry (MCR). Every version of a module exists as a tag in the Container Registry and can be listed as tags for each module [https://mcr.microsoft.com/v2/bicep/avm/(res|ptn|utl)/<namespace/modulename>/tags/list](https://mcr.microsoft.com/v2/bicep/avm/$moduleType/$moduleFolderName/tags/list)

{{% /notice %}}
