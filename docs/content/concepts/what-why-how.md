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
  - Enforcing consistency where possible
- How they are to be consumed
- What they deliver for consumers in terms of resources deployed and configured
- And where appropriate aligned across IaC languages (e.g. Bicep, Terraform, etc.).

{{< hint type=tip icon=gdoc_heart title="Mission Statement" >}}

Provide every person and every organization on the planet an Azure Verified Modules library/s, in multiple IaC languages (today Bicep and Terraform), that is the single source of truth from Microsoft for IaC modules that is also supported by Microsoft.

{{< /hint >}}

## Why Azure Verified Modules?

This effort to create Azure Verified Modules, with a strategy and definition, is required based on the sheer number of existing attempts from all areas across Microsoft to try and address this same area for our customers and partners. Across Microsoft there are many initiatives, projects and repositories that host and provide IaC modules in several languages, for example Bicep & Terraform. Each of these come with differing code styling and standards, consumption methods and approaches, testing frameworks, target personas, contribution guidelines, module definitions and most importantly support statements from their owners and maintainers.

However, none of these existing attempts have ever made it all the way through to becoming a brand and the go to place for IaC modules from Microsoft that consumers can trust (mainly around longevity and support), build upon and contribute back to.

Performing this effort now to create a shared single aligned strategy and definition for IaC modules from Microsoft, as One Microsoft, will allow us to accelerate existing and future projects, such as Application Landing Zone Accelerators (LZAs), as well as providing the building blocks via a library of modules, in the language of the consumers choice, that is consistent, trusted and supported by Microsoft. This all leads to consumers being able to accelerate faster, no matter what stage of their IaC journey they are on.

We also know, from our customers, that well defined support statements from Microsoft are required for initiatives like this to succeed at scale, especially in larger enterprise customers. We have seen over the past FY that this topic alone is important and is one that has led to confusion and frustration to customers who are consuming modules developed by individuals that in the end are not "officially" Microsoft supported and this unfortunately normally occurs at a critical point in time for the project being worked on, which amplifies frustrations.

## How will we create, support and enforce Azure Verified Modules?

Azure Verified Modules will
