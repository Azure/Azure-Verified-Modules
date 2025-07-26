---
title: Module Lifecycle
url: /specs/shared/module-lifecycle/
description: Module Lifecycle description for the Azure Verified Modules (AVM) program
---

This section outlines the different stages of a module's lifecycle:

{{< mermaid zoom="false">}}
flowchart LR
    Proposed["1 - Proposed ⚪"] --> |Acceptance criteria met ✅| Available["2 - Available 🟢"]
      click Proposed "{{% siteparam base %}}/specs/shared/module-lifecycle/#1-proposed-modules"
      click Available "{{% siteparam base %}}/specs/shared/module-lifecycle/#2-available-modules"
    Proposed --> |Acceptance criteria not met ❌| Rejected[Rejected]
    Available --> |Module temporarily not maintained| Orphaned["3 - Orphaned 🟡"]
    Orphaned --> |End of life| Deprecated["4 - Deprecated 🔴"]
      click Orphaned "{{% siteparam base %}}/specs/shared/module-lifecycle/#3-orphaned-modules"
    Orphaned --> |New owner identified| Available
    Available --> |End of life| Deprecated
      click Deprecated "{{% siteparam base %}}/specs/shared/module-lifecycle/#4-deprecated-modules"
    style Proposed fill:#ADD8E6,stroke:#333,stroke-width:1px
    style Orphaned fill:#F4A460,stroke:#333,stroke-width:1px
    style Available fill:#8DE971,stroke:#333,stroke-width:4px
    style Deprecated fill:#000000,stroke:#333,stroke-width:1px,color:#fff
    style Rejected fill:#A2A2A2,stroke:#333,stroke-width:1px
{{< /mermaid >}}

{{% notice style="important" %}}
If a module proposal is rejected, the issue is closed and the module's lifecycle ends.
{{% /notice %}}

## 1. Proposed Modules

A module can be proposed through the module proposal process. The module proposal process is outlined in the [Process Overview]({{% siteparam base %}}/contributing/process/#new-module-proposal--creation) section.

To propose/request a new AVM resource, pattern or utility module, submit a [module proposal](https://aka.ms/AVM/ModuleProposal) issue in the AVM repository.

The proposal should include the following information:

- module name
- language (Bicep, Terraform, etc.)
- module class (resource, pattern, utility)
- module description
- module owner(s) - if known

The AVM core team will review the proposal, and administrate the module.

{{% notice style="info" %}}

To **propose a new module**, submit a [module proposal](https://aka.ms/AVM/ModuleProposal) issue in the AVM repository.

{{% /notice %}}

## 2. Available modules

Once a module has been fully developed, tested and published in the main branch of the repository and the corresponding public registry (Bicep or Terraform), it is then considered to be "available" and can be used by the community. The module is maintained by the module owner(s). Feature or bug fix requests and related pull requests can be submitted by anyone to the module owner(s) for review.

## 3. Orphaned Modules

It is critical to the consumers experience that modules continue to be maintained. In the case where a module owner cannot continue in their role or do not respond to issues as per the defined timescale in the [Module Support page]({{% siteparam base %}}/help-support/module-support/) , the following process will apply:

1. The module owner is responsible for finding a replacement owner and providing a handover.
2. If no replacement can be found or the module owner leaves Microsoft without giving warning to the AVM core team, the AVM core team will provide essential maintenance (critical bug and security fixes), as per the [Module Support page]({{% siteparam base %}}/help-support/module-support/)
3. The AVM core team will continue to try and re-assign the module ownership.
4. While a module is in an orphaned state, only security and bug fixes **MUST** be made, no new feature development will be worked on until a new owner is found that can then lead this effort for the module.
5. An issue will be created on the central AVM repo (`Azure/Azure-Verified-Modules`) to track the finding of a new owner for a module.

{{% notice style="info" %}}

To **orphan a module**, submit an [orphaned module](https://aka.ms/AVM/OrphanedModule) issue in the AVM repository. For the required steps, review the related article: [When a module becomes orphaned]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-orphaned).

[When a new owner is identified]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-new-owner-is-identified), follow the related guidance.

{{% /notice %}}

### Notification of a Module Becoming Orphaned

{{% notice style="important" %}}
When a module becomes orphaned, the AVM core team will communicate this through an information notice to be placed as follows.

- In case of a Bicep module, the information notice will be placed in an `ORPHANED.md` file and in the header of the module's `README.md` - both residing in the module's root.
- In case of a Terraform module, the information notice will be placed in the header of the `README.md` file, in the module's root.

The information notice will include the following statement:

{{< highlight lineNos="false" type="markdown" wrap="true" title="ORPHANED.md" >}}
{{% include file="/static/includes/orphaned-module-notice.md" %}}
{{< /highlight >}}

{{% /notice %}}

Also, the AVM core team will amend the issue automation to auto reply stating that the repo is orphaned and only security/bug fixes are being handled until a new module owner is found.

## 4. Deprecated Modules

Once a module reaches the end of its lifecycle (e.g., it's permanently replaced by another module; permanent retirement due to obsolete technology/solution), it needs to be deprecated. A deprecated module will no longer be maintained, and no new features or bug fixes will be implemented for it. The module will indefinitely stay available in the public registry and source code repository for use, but certain measures will take place, such as:

1. The module will show as deprecated in the AVM module index.
2. The module will no longer be shown through VS Code IntelliSense.
3. The module's source code will be kept in its repository but it will show a deprecated status through a `DEPRECATED.md` file (Bicep only) and a disclaimer in the module's `README.md` file.
4. It will be a clearly indicated on the module's repo that new issues can no longer be submitted for the module:
    - Bicep: The module will be taken off the list of available modules in related issue templates.
    - Terraform: The module's repo will be archived.

It is recommended to migrate to a replacement/alternative version of the module, if available.

{{% notice style="important" %}}
When a module becomes deprecated, the AVM core team will communicate this through an information notice to be placed as follows.

- In case of a Bicep module, the information notice will be placed in a `DEPRECATED.md` file and in the header of the module's `README.md` - both residing in the module's root.
- In case of a Terraform module, the information notice will be placed in the header of the `README.md` file, in the module's root.

The information notice **MUST** include the following statement:

{{< highlight lineNos="false" type="markdown" wrap="true" title="DEPRECATED.md" >}}
{{% include file="/static/includes/deprecated-module-notice.md" %}}
{{< /highlight >}}

{{% /notice %}}

{{% notice style="info" %}}

To **deprecate a module**, submit a [deprecated module](https://aka.ms/AVM/DeprecatedModule) issue in the AVM repository. For the required steps, review the related article: [When a module becomes deprecated]({{% siteparam base %}}/help-support/issue-triage/avm-issue-triage/#when-a-module-becomes-deprecated).

{{% /notice %}}

{{% expand title="➕ Retrieve the available versions of a deprecated module" %}}

To find all previous versions of a Bicep module, the following steps need to be performed (assuming the `avm/ptn/finops-toolkit/finops-hub` module has been deprecated):

1. To find out the all the versions the module has ever been published under, perform one of these steps:
    1. navigate to Bicep Public Registry's [JSON index](https://aka.ms/avm/brmmoduleindex) and look for the module's name,
    2. OR visit [https://mcr.microsoft.com/v2/bicep/avm/ptn/finops-toolkit/finops-hub/tags/list](https://mcr.microsoft.com/v2/bicep/avm/ptn/finops-toolkit/finops-hub/tags/list).
    3. OR clone the [Bicep Public Registry repository](https://aka.ms/BRM) and run the following command in the root of the repository: `git tag -l 'avm/ptn/finops-toolkit/finops-hub/*'`. This will list all the tags that match the module's name.
2. Identify the available versions of the module, e.g., `0.1.0`, `0.1.1`, etc.
3. To download the content, construct and navigate to the following URL: [https://github.com/Azure/bicep-registry-modules/releases/tag/avm/ptn/finops-toolkit/finops-hub/0.1.0](https://github.com/Azure/bicep-registry-modules/releases/tag/avm/ptn/finops-toolkit/finops-hub/0.1.0)
4. To see the content in the folder hierarchy, construct and navigate to the following URL: [https://github.com/Azure/bicep-registry-modules/tree/avm/ptn/finops-toolkit/finops-hub/0.1.0/avm/ptn/finops-toolkit/finops-hu](https://github.com/Azure/bicep-registry-modules/tree/avm/ptn/finops-toolkit/finops-hub/0.1.0/avm/ptn/finops-toolkit/finops-hu)

Terraform modules will be listed in the HashiCorp Terraform Registry indefinitely.

{{% /expand %}}
