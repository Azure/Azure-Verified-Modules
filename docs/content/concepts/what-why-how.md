---
title: What, Why, How
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

## What is Azure Verified Modules?

Azure Verified Modules (AVM), as "One Microsoft", we want to provide and define the single definition of what a good IaC module is;

- How they should be constructed and built
  - Enforcing consistency and testing where possible
- How they are to be consumed
- What they deliver for consumers in terms of resources deployed and configured
- And where appropriate aligned across IaC languages (e.g. Bicep, Terraform, etc.).

{{< hint type=tip icon=gdoc_heart title="Mission Statement" >}}

Our mission is to deliver a comprehensive Azure Verified Modules library in multiple IaC languages, following the principles of the well-architected framework, serving as the trusted Microsoft source of truth. Supported by Microsoft, AVM will accelerate deployment time for Azure resources and architectural patterns, empowering every person and organization on the planet on their IaC journey.

{{< /hint >}}

### Definition of "Verified" Summary

- The modules are supported by Microsoft, across it's many internal organizations, as described in [Module Support](/Azure-Verified-Modules/help-support/module-support/)
- Modules are aligned to clear specifications that enforces consistency between all AVM modules. *See the 'Specifications & Definitions' section in the menu*
- Modules will continue to stay up-to-date with product/service roadmaps owned by the module owners and contributors
- Modules will align to WAF high priority recommendations. *See ['What does AVM mean by "WAF Aligned"?'](/Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned)*
- Modules will provide clear documentation alongside examples to promote self-service consumption
- Modules will be tested to ensure they comply with the specifications for AVM and their examples deploy as intended

<br>

## Why Azure Verified Modules?

This effort to create Azure Verified Modules, with a strategy and definition, is required based on the sheer number of existing attempts from all areas across Microsoft to try and address this same area for our customers and partners. Across Microsoft there are many initiatives, projects and repositories that host and provide IaC modules in several languages, for example Bicep and Terraform. Each of these come with differing code styling and standards, consumption methods and approaches, testing frameworks, target personas, contribution guidelines, module definitions and most importantly support statements from their owners and maintainers.

However, none of these existing attempts have ever made it all the way through to becoming a brand and the go to place for IaC modules from Microsoft that consumers can trust (mainly around longevity and support), build upon and contribute back to.

Performing this effort now to create a shared single aligned strategy and definition for IaC modules from Microsoft, as One Microsoft, will allow us to accelerate existing and future projects, such as Application Landing Zone Accelerators (LZAs), as well as providing the building blocks via a library of modules, in the language of the consumers choice, that is consistent, trusted and supported by Microsoft. **This all leads to consumers being able to accelerate faster, no matter what stage of their IaC journey they are on.**

We also know, from our customers, that well defined support statements from Microsoft are required for initiatives like this to succeed at scale, especially in larger enterprise customers. We have seen over the past FY that this topic alone is important and is one that has led to confusion and frustration to customers who are consuming modules developed by individuals that in the end are not "officially" Microsoft supported and this unfortunately normally occurs at a critical point in time for the project being worked on, which amplifies frustrations.

<br>

## How will we create, support and enforce Azure Verified Modules?

Azure Verified Modules will achieve this, and its mission statement, by implementing and enforcing the following; driven by the AVM Core Team:

1. Publishing AVM modules to their respective public registries for consumption
   - For Bicep this will be the [Bicep Public Module Registry](https://aka.ms/BRM)
   - For Terraform this will be the [HashiCorp Terraform Registry](https://registry.terraform.io/)
2. Creating, publishing and maintaining the Azure Verified Modules specifications (this site)
   - Including IaC language specific specifications (today Bicep and Terraform)
3. Creating easy to follow AVM module contribution and publishing guidance for each IaC language (today Bicep and Terraform)
4. Enforcing tests for each AVM module is compliant with the AVM specifications, where possible, via Unit and Integration tests
5. Enforcing End-to-End Deployment tests of each AVM module
6. Providing, and backing, a long-term support statement, regardless of the AVM module's ownership status
   - Backed by the AVM Core Team, Microsoft CSS and Azure PGs

