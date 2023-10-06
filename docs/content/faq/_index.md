---
title: Frequently Asked Questions (FAQs)
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 1
---

{{< hint type=tip >}}

Got an unanswered question? Create a [GitHub Issue](https://github.com/Azure/Azure-Verified-Modules/issues) so we can get it answered and added here for everyone's benefit 👍

{{< /hint >}}

{{< toc >}}

{{< hint type=tip >}}

Check out the [Contribution Q&A](/Azure-Verified-Modules/contributing/q-and-a/) for more answers to common questions about the contribution process.

{{< /hint >}}

## What is happening to existing initiatives like CARML and TFVM?

The AVM initiative has been working closely with the teams behind the following initiatives:

- [CARML (Common Azure Resource Modules Library)](https://github.com/Azure/ResourceModules)
- [TFVM (Terraform Verified Modules)](https://github.com/Azure/terraform-azure-modules)
- [BRM (Bicep Registry Modules)](https://github.com/Azure/bicep-registry-modules) - this is where the AVM Bicep modules will be published.

AVM is a straight-line evolution of CARML & TFVM.

### CARML/TFVM to AVM Evolution Details

While AVM Module contributions and ownership will shortly be opened to all Microsoft FTEs and the public (as contributors), the content of previously existing libraries such as TFVM & CARML will be migrated to AVM. The relevant teams are working out the details of the migration process as you read this.

In the case of CARML (Bicep), this will include:

- A new release making CARML conform with the Bicep Registry
- Tests automation alignment
- Module features added where applicable and aligned with AVM specifications

Aspiring Bicep-based AVM modules contributors/owners, please check the CARML library first to see if the module you want to propose already exists as a CARML module.

- If you wish to own it in the future (once migrated by the AVM/CARML/TFVM teams), please go ahead and submit your Module Proposal using the form today and just let us know in the details
- If you don't plan to be the owner but do want to contribute, please hold off from contributing until it's migrated from CARML/TFVM

### CARML Evolution

CARML is an existing IaC Bicep module library effort, that was started by ISD and has been contributed to by many across Microsoft and has also had some external contributions.

A lot of CARML's principles and architecture decisions will form the basis for AVM going forward. Most of the CARML modules today are very close to being AVM Resource Modules already and will only require a small number of changes to become AVM compliant.

CARML never got to the stage of creating, at scale, modules like AVM [Pattern Modules](/Azure-Verified-Modules/specs/shared/module-classifications), but they were on its long-term roadmap.

In summary, CARML will **evolve** to become the Bicep version of AVM. A notice will be placed on the CARML repo redirecting users and contributors to the AVM central repository as modules are evolved into AVM modules.​

#### CARML Publishing to Bicep Registry Notes

To avoid confusion for consumers it has been decided that CARML should not be published to the Bicep Registry under the CARML brand. Instead, the effort and work should be completed to take the existing CARML modules and perform a gap analysis upon them against the AVM specifications and then any required gaps addressed first.

At this stage the revamped module can be published to the Bicep Registry under the AVM brand to provide the uniform and single identity for AVM to consumers.

It may also be decided, for speed of delivery reasons, that a CARML module can be taken as is, with minimal AVM gaps addressed, and just rebranded to AVM and published to the Bicep Registry. However, this is ideally discouraged as it is creating technical debt from day 1.

Publishing both CARML and AVM to the Bicep Registry is wasted effort and will lead to confusion as they will overlap for 80% of their code and will leave consumers in an "analysis paralysis" scenario, which we must avoid.

#### Timeline and approach

In Q4 of 2023, the AVM core team is planning to:

- Provide a detailed contribution guide for Bicep modules.
- Release the first version of the CI environment used for testing and publishing Bicep modules.
- Work out the details of and start delivering on a phased migration process.

Members of the CARML key contributors have already volunteered to become module owners (see the module index of [Bicep resource modules](/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/)), and will be working with the AVM core team to migrate the existing CARML modules to AVM.

This will be done in a phased approach, as follows:

- The first phase including those CARML modules that other modules depend on, e.g., Public IP, NIC and Private Endpoint.
- A second phase including those modules that already have module owners associated, which will be migrated in a prioritized order based on customer demand, using telemetry.
- A third phase including the remaining of the CARML modules, not yet having a module owner associated.

Modules that won't have a module owner associated with them after they have been migrated to AVM will be marked as "[orphaned](/Azure-Verified-Modules/specs/shared/module-lifecycle/#orphaned-avm-modules)" and will be available for any Microsoft FTEs to pick up and become the module owner.

The AVM core team plans to have migrated the majority of the CARML modules to AVM by the end of 2023.

---
## What does AVM mean by "WAF Aligned"?

{{< hint type=tip >}}

WAF == [Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/) (as per our [glossary](/Azure-Verified-Modules/glossary/))

{{< /hint >}}

At a high-level "WAF Aligned" means, where possible and appropriate, AVM Modules will align to recommendations and default input parameter/variables to values that algin to WAF recommendations across all of it's pillars. For the security pillar we will also use the Microsoft Cloud Security Benchmark (MCSB) and Microsoft Defender for Cloud (MDFC) to align input parameter/variables values to these.

AVM will use the following sources to set it's "WAF Aligned" defaults:

- [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)
- [Azure Proactive Resiliency Library](https://azure.github.io/Azure-Proactive-Resiliency-Library/)
- [Introduction to the Microsoft cloud security benchmark](https://learn.microsoft.com/security/benchmark/azure/introduction)
- [Security recommendations - Microsoft cloud security benchmark](https://learn.microsoft.com/azure/defender-for-cloud/recommendations-reference)

### Will all AVM modules be 100% "WAF Aligned" out of the box and good to go?

Not quite, but they'll certainly be on the right path.

To understand this further you first must understand that some of the "WAF Aligned" recommendations, from the sources above are more than just setting a string or boolean value to something particular to meet the recommendation; some will require additional resources to be created and exist and then linked together to help satisfy the recommendation.

In these scenarios the AVM modules will not enforce the additional resources to be deployed and configured, but will provide sufficient flexibility via their input parameters/variables to be able to support the configuration, if so desired by the module consumer.

#### Some examples

| Recommendation                                                         | Will Be Set By Default in AVM Modules?                                                                            |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| TLS version should always be set the latest/highest version TLS 1.3    | **Yes**, as string value                                                                                          |
| Key Vault should use RBAC instead of access policies for authorization | **Yes**, as string/boolean value                                                                                  |
| Container registries should use private link                           | **No**, as requires additional Private Endpoint and DNS configuration as well as, potentially, additional costs   |
| API Management services should use a virtual network                   | **No**, as requires additional Virtual Network and Subnet configuration as well as, potentially, additional costs |

{{< hint type=important >}}

Whilst every Well-Architected Framework pillar's recommendations should equally be considered by the module owners/contributors, within AVM we are taking an approach to prioritize reliability and security over cost optimization. This provides consumers of the AVM modules, by default, more resilient and secure resources and patterns.

However, please note these defaulted values can be altered via input parameter/variables in each of the modules so that you can meet your specific requirements.

{{< /hint >}}

---

## Aren't AVM resource modules too complex for people less skilled in IaC technologies?

 **TLDR**: Resource modules have complexity inside, so they can be flexibly used from the outside.

Resource modules are written in a flexible way; therefore, you don't need to modify them from project to project, use case to use case, as they aim to cover most of the functionality that a given resource type can provide, in a way that you can interact with any module just by using the required parameters - i.e., you don't have to know how the template of the particular module works inside, just take a look at the `README.md` file of the given module to learn how to leverage it.

Resource modules are multi-purpose; therefore, they contain a lot of dynamic expressions (functions, variables, etc.), so there's no need to maintain multiple instances for different use cases. They can be deployed in different configurations just by changing the input parameters. They should be perceived by the **user** as black boxes, where they don't have to worry about the internal complexity of the code, as they only interact with them by their parameters.

---

## What is a "Primary Resource" in the context of AVM?

The definition of a Primary Resource is detailed in the [glossary](/Azure-Verified-Modules/glossary/).

---

## Will existing Landing Zone Accelerators (Platform & Application) be migrated to become AVM pattern modules and/or built from AVM resource modules?

In short, no. Existing Landing Zone Accelerators ([Platform](https://aka.ms/alz/aac#platform) & [Application](https://aka.ms/alz/aac#application)) will not be made or forced to convert their existing code bases, if available in either language, to AVM or to use AVM.

However, over time if new features or functionality are required by Landing Zone Accelerators, that team **SHOULD** consider migrating/refactoring that part of their code base to be constructed with the relevant AVM module if available.

If the relevant AVM module isn't available to use to assist the Landing Zone Accelerator, then a new [AVM module proposal](https://aka.ms/avm/moduleproposal) should be made, and if desired, the Landing Zone Accelerator team may decide to own this proposed module 👍

## Does/will AVM cover Microsoft 365, Azure DevOps, GitHub, etc.?

Whilst the principles and practices of AVM are largely applicable to other clouds and services such as, Microsoft 365 & Azure DevOps, the AVM program (today) only covers Azure cloud resources and architectures.

However, if you think this program, or a similar one, should exist to cover these other Microsoft Cloud offerings, please give a 👍 or leave a comment on this [GitHub Issue #71](https://github.com/Azure/Azure-Verified-Modules/issues/71) in the AVM repository.
