---
title: Module Lifecycle
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---
{{< hint type=note >}}

This page is still a work in progress

{{< /hint >}}

## Request/Propose a New AVM Resource or Pattern Module

{{< hint type=note >}}

We are still getting ready to actually create code but we are willing to take module proposals from Microsoft FTEs!

Fill in the form [here](https://aka.ms/avm/moduleproposal) 📄

{{< /hint >}}

{{< hint type=tip >}}

Before submitting a new [module proposal](https://aka.ms/avm/moduleproposal) for either Bicep or Terraform, please review the FAQ section on ["CARML/TFVM to AVM Evolution Details"](/Azure-Verified-Modules/faq/#carmltfvm-to-avm-evolution-details)

{{< /hint >}}

## Orphaned AVM Modules

It is critical to the consumers experience that modules continue to be maintained. In the case where a module owner cannot continue in their role or do not respond to issues as per the defined timescale in the [Module Support page](/Azure-Verified-Modules/help-support/module-support/) , the following process will apply:

1. The module owner is responsible for finding a replacement owner and providing a handover.
2. If no replacement can be found or the module owner leaves Microsoft without giving warning to the AVM core team, the AVM core team will provide essential maintenance (critical bug and security fixes), as per the [Module Support page](/Azure-Verified-Modules/help-support/module-support/)
3. The AVM core team will continue to try and re-assign the module ownership.
4. Whilst a module is in an orphaned state, only security and bug fixes **MUST** be made, no new feature development will be worked on until a new owner is found that can then lead this effort for the module.
5. An issue will be created on the central AVM repo (`Azure/Azure-Verified-Modules`) to track the finding of a new owner for a module

### Notification of a Module Becoming Orphaned

When a module becomes orphaned the AVM core team MUST place an information notice on the modules root `README.md` that states the following:

> *"This module is currently orphaned. Only security and bug fixes are being handled by the AVM core team at present. If interested in becoming a module owner (must be Microsoft FTE) for this orphaned module please comment on the issue here `<LINK TO AVM REPO ISSUE>`"*

Also, the AVM core team will amend the issue automation to auto reply stating that the repo is orphaned and only security/bug fixes are being handled until a new module owner is found.
