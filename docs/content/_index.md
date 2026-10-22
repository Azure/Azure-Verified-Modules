---
title: Azure Verified Modules
linktitle: Azure Verified Modules
type: home
description: 'Azure Verified Modules - The Microsoft IaC Module Strategy'
---

{{% notice style="note" title="Latest Announcements" icon="lightbulb" %}}

1. **Azure Verified Modules (AVM) is now owned by Azure engineering, read more about the news [here.](https://techcommunity.microsoft.com/blog/azuretoolsblog/azure-verified-modules-avm-is-now-owned-by-azure-engineering/4563822)**

2. **The next AVM community call will be hosted on Monday 26th October 2026 @ 16:00 UK | 12:00 EDT | 09:00 PDT | 21:30 IST | 03:00 AEDT (Tuesday 27th October)**
    - YouTube Live Link: [aka.ms/AVM/CommunityCall](https://aka.ms/AVM/CommunityCall)
    - GitHub Issue Link for topics: [AVM Community Call - October 2026 · Issue #3079 · Azure/Azure-Verified-Modules](https://github.com/Azure/Azure-Verified-Modules/issues/3079)
    - Add to your calendar: [Download the calendar invite (.ics)]({{% siteparam base %}}/community/avm-oct26-community-call.ics)

{{% /notice %}}

## Introduction

<div style="width:70%; margin: 0 auto;">
{{< youtube id="JbIMrJKW5N0" title="An introduction to Azure Verified Modules (AVM)" >}}
</div>


{{% notice style="tip" %}}

For a more detailed intro check out the [Azure Infra Summit 2026 Session on AVM](https://www.youtube.com/watch?v=QBqRAMVTmwE)

{{% /notice %}}

## Value Proposition

<table style="border: none; border-collapse: collapse; margin:0; padding:0;">
  <tr>
    <td style="border: none; padding:0; margin:0; width:65%">

Azure Verified Modules (AVM) is an initiative to consolidate and set the standards for what a good Infrastructure-as-Code module looks like.

Modules will then align to these standards, across languages (Bicep, Terraform etc.) and will then be classified as AVMs and available from their respective language specific registries.

AVM is a common code base, a toolkit for our Customers, our Partners, and Microsoft. It's an open-source initiative owned by the Azure Deployments team within Azure engineering, with a devolved ownership approach to develop modules, leveraging internal & external communities.

Azure Verified Modules enable and accelerate consistent solution development and delivery of cloud-native or migrated applications and their supporting infrastructure by codifying Microsoft guidance (WAF), with best practice configurations.

  </td>
    <td style="border: none; margin:0; padding: 0;">
      <img src="{{%siteparam base%}}/images/avm_cycle.png" width=65% alt="AVM development cycle" style="margin:0 auto;padding: 0;">
    </td>
  </tr>
</table>

## Modules

<table style="border: none; border-collapse: collapse; margin: 0; padding: 0;">
  <tr>
    <td style="border: none; padding: 0; width:55%">
        <img src="{{%siteparam base%}}/images/avm_modules.png" width=80% alt="AVM module classifications">
    </td>
    <td style="border: none; padding: 0;">
Azure Verified Modules provides two types of modules: Resource and Pattern modules.

AVM modules are used to deploy Azure resources and their extensions, as well as reusable architectural patterns consistently.

Modules are composable building blocks that encapsulate groups of resources dedicated to one task.

- Flexible, generalized, multi-purpose
- Integrates child resources
- Integrates extension resources

AVM improves code quality and provides a unified customer experience.
    </td>
  </tr>
</table>

{{% notice style="important" %}}
AVM is owned by Azure engineering and supported by Microsoft, you may raise a GitHub issue on this repository or the module's repository directly to get support or log feature requests.

You can also log a support ticket and if the issue is not related to the Azure platform, you will be redirected to submit a GitHub issue for the module owner(s) or the AVM team.

See [Module Support]({{%siteparam base%}}/help-support/module-support) for more information.
{{% /notice %}}

## Next Steps

<table style="border: none; border-collapse: collapse; margin: 0; padding: 0;">
  <tr>
    <td style="border: none; padding: 0; width:60%">

1. Review [Overview]({{% siteparam base %}}/overview/introduction)
2. Review the [Module Classification Definitions]({{% siteparam base %}}/specs/shared/module-classifications/)
3. Review the [Specifications]({{% siteparam base %}}/specs/module-specs/)
4. Review the [FAQ]({{% siteparam base %}}/faq/)
5. Learn how to [contribute to AVM]({{% siteparam base %}}/contributing/)
    </td>
    <td style="border: none; padding: 0;">

    ![AVM]({{%siteparam base%}}/images/avm_logo.png?width=10vw "AVM")

    </td>

  </tr>
</table>
