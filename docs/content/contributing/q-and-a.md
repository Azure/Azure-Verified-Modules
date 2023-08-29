---
title: Contribution Q&A
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---


# Proposing a module

## Where do I need to go to make sure the module I'd like to build / get built is not in the works somewhere?

The [AVM core team](/Azure-Verified-Modules/specs/shared/team-definitions/#avm-core-team) maintains the list of [Bicep](/Azure-Verified-Modules/indexes/bicep/) and [Terraform](/Azure-Verified-Modules/indexes/terraform/) modules and tracks the status of each module. Based on these lists you can check if the module you'd like to build is already in the works (e.g., it's being worked on in a feature branch but hasn't been published yet).

{{< hint type=important >}}

Module lists are to be published soon.

{{< /hint >}} 

## I need a new module but I cannot own/author it for various reasons, what should I do?

Each AVM module requires a [module owner](/Azure-Verified-Modules/specs/shared/team-definitions/#module-owners) and **MAY** have additional [module contributors](/Azure-Verified-Modules/specs/shared/team-definitions/#module-contributors).

Essentially, you have 3 options:
1. You sign up to be a module owner (and optionally, you can find additional contributors to help you)
2. You find / request someone else to be the module owner (and optionally, you can be a contributor)
3. You request a module and wait until the AVM core team finds a module owner for you

As these options are increasingly more time consuming, we recommend you to start with considering option 1 and only if you cannot own the module, should you move to option 2 and then 3.

You can propose/request a new module here: https://aka.ms/AVM/ModuleProposal

## Where can I submit a new module request?

You can propose/request a new module here: https://aka.ms/AVM/ModuleProposal

## Can I create *ANY* module? E.g., can I create one for managed disks or NICs or diagnostic settings? What about patterns?

In case of resource modules are pretty self explanatory and mapped 1:1 to RPs

In case of pattern modules, ideally you should start from architectural patterns, published in the Azure Architecture Center, and build your pattern module by leveraging resource modules that are required to implement the pattern. AVM does not provide architectural guidance on how you should design your pattern, but you **MUST** follow the module specifications and your modules **SHOULD** be [WAF aligned](/Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned).
## What should I expect, how long will it take for someone to respond and a module to be created/published?

## How do I let the AVM team know I really need an AVM module to exist to unblock me/my company?

# Preparing the environment for a new module

Central
- Updating central JSON/CSV files
  - Who updates that?
- For TF
  - How will the new repo be created for TF? What will the repo be called? Who checks if the naming convention was followed?
  - What are the mandatory .md files for the root of the repo (readme; security; support; etc.)
- For Bicep
  - In what folder do I need to work? Who checks if the naming convention was followed?
  - Who will change CODEOWNERS file?
- For both Bicep and TF
  - What are the mandatory tags/labels?
  - Do I need to use/create custom issue types/templates?
  - How will the support SLAs be automatically enforced?
  - Where can I test my module during development? 
  - Can I run manual tests or can I only use GH actions?

# Developing the module
## To start developing the module, which exact documents do I have to hold myself to?
(please don't just point me to the root of the docs page 😊)

## Where are examples to follow / first sample modules to get inspiration from?

## What are the guardrails/quality gates I need to be aware of/leverage/be compliant with (i.e., where's the CI environment with the automated tests that I need to use and comply with)?

## Will I get any level of code review from the AVM core team to make sure my work is up to the standards?



# Publishing the module
## What steps do I need to follow?
- Is everything fully automated? 
- Do I need to talk to someone to publish my module in the registry or can I do it on my own?


# Updating a module
What if I forget to bump up the version number?
How will it impact the publication flow? Will it mess up the telemetry reporting? --> to avoid the latter, we should probably consider using a moduleVersion param instead of a variable - or implement some tests that guarantee that this gets updated every time there's was an update to the module
I'm already using a module today, but its missing a feature, what should I do?

# Security/Bugs in a module
## I have found a security issue with a module or the way it deploys its resources/pattern, what should I do?
- Covered in SECURITY.md?



# Retiring a module
## A new Azure resource or resource provider got released that supersedes an existing module. Now that I've had the replacement module published for 2 years, what do I need to do to retire the old solution? --> we need to document a step that describes that the status flag of the modules needs to be changed to retired in the module index
## Can modules be deleted from their respective repo (or can their repo be deleted)? --> to this, we concluded earlier that the right approach is to leave one last readme.md file that provides context and points end users to the replacement solution.
## Will modules ever be deleted from their respective registries? --> on this, we concluded earlier that a module MUST never get deleted from a registry. It can be "abandoned" as part of the retirement flow. 
