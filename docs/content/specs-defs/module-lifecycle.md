---
title: Module Lifecycle
url: /specs/shared/module-lifecycle/
description: Module Lifecycle description for the Azure Verified Modules (AVM) program
---

This section outlines the different stages of a module's lifecycle:

1. Proposed
2. Available
3. Orphaned
4. Deprecated

## Proposed Modules

A module can be proposed through the module proposal process. The module proposal process is outlined in the [Process Overview]({{% siteparam base %}}/contributing/process/#new-module-proposal--creation) section.

To propose/request a new AVM resource, pattern or utility module, submit a (module proposal)[https://aka.ms/AVM/ModuleProposal] issue in the AVM repository.

The proposal should include the following information:

- module name
- language (Bicep, Terraform, etc.)
- module class (resource, pattern, utility)
- module description
- module owner(s) - if known

The AVM core team will review the proposal, and administrate the module.

## Available modules

Once a module has been fully developed, tested and published in the main branch of the repository and the corresponding public registry (Bicep or Terraform), it is then considered to be "available" and can be used by the community. The module is maintained by the module owner(s). Feature or bug fix requests and related pull requests can be submitted by anyone to the module owner(s) for review.

## Orphaned Modules

It is critical to the consumers experience that modules continue to be maintained. In the case where a module owner cannot continue in their role or do not respond to issues as per the defined timescale in the [Module Support page]({{% siteparam base %}}/help-support/module-support/) , the following process will apply:

1. The module owner is responsible for finding a replacement owner and providing a handover.
2. If no replacement can be found or the module owner leaves Microsoft without giving warning to the AVM core team, the AVM core team will provide essential maintenance (critical bug and security fixes), as per the [Module Support page]({{% siteparam base %}}/help-support/module-support/)
3. The AVM core team will continue to try and re-assign the module ownership.
4. While a module is in an orphaned state, only security and bug fixes **MUST** be made, no new feature development will be worked on until a new owner is found that can then lead this effort for the module.
5. An issue will be created on the central AVM repo (`Azure/Azure-Verified-Modules`) to track the finding of a new owner for a module.

### Notification of a Module Becoming Orphaned

{{% notice style="important" %}}
When a module becomes orphaned, the AVM core team will communicate this through an information notice to be placed as follows.

- In case of a Bicep module, the information notice will be placed in an `ORPHANED.md` file and in the header of the module's `README.md` - both residing in the module's root.
- In case of a Terraform module, the information notice will be placed in the header of the `README.md` file, in the module's root.

The information notice will include the following statement:

{{< highlight lineNos="false" type="markdown" wrap="true" title="orphaned-module-notice.md" >}}
{{% include file="/static/includes/orphaned-module-notice.md" %}}
{{< /highlight >}}

{{% /notice %}}

Also, the AVM core team will amend the issue automation to auto reply stating that the repo is orphaned and only security/bug fixes are being handled until a new module owner is found.

## Deprecated Modules

Once a module reaches the end of its lifecycle, it needs to be deprecated. A deprecated module will no longer be maintained, and no new features or bug fixes will be implemented for it. The module will indefinitely stay available in the public registry and source code repository for use, but certain measures will take place, such as:

- It will show as deprecated in the AVM module index.
- The module will no longer be shown through VS Code IntelliSense.
- Its source code will show and archived status (through an `ARCHIVED.MD` file and a disclaimer in its `README.md` file).
- It will be taken off the list of available modules in related issue templates.

It is recommended to migrate to a replacement/alternative version of the module, if available.
