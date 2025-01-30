---
title: Azure Verified Modules
linktitle: Azure Verified Modules
type: home
description: 'Azure Verified Modules - The Microsoft IaC Module Strategy'
---

{{% notice style="caution" icon="fa-solid fa-calendar-days" title="AVM Community Calls" %}}

The AVM team is hosting its next external community call on the **6th February 2025**! 🥳

- **Register** here to attend: [https://aka.ms/AVM/CommunityCall](https://aka.ms/AVM/CommunityCall)
- To find out more about future calls and watch the recordings of previous ones, see the [Community Calls page]({{% siteparam base %}}/resources/community)!

{{% /notice %}}

{{% notice style="info" title="AVM Site Updates" icon="fa-solid fa-sitemap" %}}

**AVM has just gone through a major website overhaul - Check out our features!**

- **New theme**: Change between light and dark mode in the bottom left corner ( <i class="fa-solid fa-paintbrush"></i> ) or leave it on dynamic mode to switch automatically based on your system settings.
- **New navigation option**: Use the arrows ( <i class="fa-solid fa-chevron-left"></i> and <i class="fa-solid fa-chevron-right"></i> ) in the top right corner to navigate back and forth between pages.
- **New search**: Look for a module - e.g., "*virtual network*" or "*vnet*" - using the search bar ( <i class="fa-solid fa-magnifying-glass"></i> ) in the top right corner and follow the search results to the related Bicep or Terraform index page.
- **New TOC menu**: Try our new table of contents ( <i class="fa-solid fa-rectangle-list"></i> ) now moved to the top left corner of the page to provide easier in-page navigation consistently.
- **New print functionality**: Click the printer icon ( <i class="fa-solid fa-print"></i> ) in the top right corner to generate a PDF or print parts of the documentation. Note, this feature will show all content in the hierarchy below the current page - i.e., when invoked from the home page, it will include he entire AVM documentation.
- Other minor updates and bug fixes, such as:
  - More compact, zoomable mermaid diagrams for better viewing.
  - Last modified date on each page is now a clickable link to the GitHub commit history for that page.
  - Minor menu updates, including the default collapsed/expanded configuration.

Try out things and let us know what you think!

{{% /notice %}}

## Introduction

<div style="width:70%; margin: 0 auto;">
{{< youtube id="JbIMrJKW5N0" title="An introduction to Azure Verified Modules (AVM)" >}}
</div>

## Value Proposition

<table style="border: none; border-collapse: collapse; margin:0; padding:0;">
  <tr>
    <td style="border: none; padding:0; margin:0; width:65%">

Azure Verified Modules (AVM) is an initiative to consolidate and set the standards for what a good Infrastructure-as-Code module looks like.

Modules will then align to these standards, across languages (Bicep, Terraform etc.) and will then be classified as AVMs and available from their respective language specific registries.

AVM is a common code base, a toolkit for our Customers, our Partners, and Microsoft. It's an official, Microsoft driven initiative, with a devolved ownership approach to develop modules, leveraging internal & external communities.

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
AVM is owned, developed & supported by Microsoft, you may raise a GitHub issue on this repository or the module's repository directly to get support or log feature requests.

You can also log a support ticket and these will be redirected to the AVM team and the module owner(s).

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
