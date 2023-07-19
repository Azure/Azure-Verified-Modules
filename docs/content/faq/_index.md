---
title: Frequently Asked Questions (FAQs)
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< hint type=tip >}}

Got an unanswered question? Create a [GitHub Issue](https://github.com/Azure/Azure-Verified-Modules/issues) so we can get it answered and added here for everyone's benefit 👍

{{< /hint >}}

{{< toc >}}

## What is happening to existing initiatives like CARML and TFVM?

The AVM initiative has been working closely with the teams behind the following initiatives:

- [CARML](https://github.com/Azure/ResourceModules)
- [TFVM](https://github.com/Azure/terraform-azure-modules)
- [BRM (Bicep Registry Modules)](https://github.com/Azure/bicep-registry-modules)

### CARML Evolution

CARML is an existing IaC module library effort, written in Bicep (only), that was started by ISD and has been contributed to by many across Microsoft and has also had some external contributions.

A lot of CARML's principles and architecture decisions will form the basis for AVM going forward. Most of the CARML modules today are very close to being AVM Resource Modules today already and will only require a small number of changes to become completely aligned.

CARML never got to the stage of creating, at scale, modules like AVM [Pattern Modules](/Azure-Verified-Modules/specs/shared/module-classifications), but they were on it's long-term roadmap.

In summary, CARML will **evolve** to become the Bicep version of AVM. This means that in the future the CARML repo SHOULD be looked to be archived and in the shorter term there MUST be a notice placed on the repo redirecting them to the AVM central repository as modules are evolved into AVM modules.

#### CARML Publishing to Bicep Registry Notes

To avoid confusion for consumers it has been decided that CARML should not be published to the Bicep Registry under the CARML brand. Instead, the effort and work should be completed to take the existing CARML modules and perform a gap analysis upon them against the AVM specifications and then any required gaps addressed first.

At this stage the revamped module can be published to the Bicep Registry under the AVM brand to provide the uniform and single identity for AVM to consumers.

It may also be decided, for speed of delivery reasons, that a CARML module can be taken as is, with minimal AVM gaps addressed, and just rebranded to AVM and published to the Bicep Registry. However, this is ideally discouraged as it is creating technical debt from day 1.

Publishing both CARML and AVM to the Bicep Registry is wasted effort and will lead to confusion as they will overlap for 80% of their code and will leave consumers in an "analysis paralysis" scenario, which we must avoid.
