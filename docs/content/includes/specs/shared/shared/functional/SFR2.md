---
title: "SFR2 - WAF Aligned"
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: ["Class-Shared","Type-Functional","Category-Composition","Language-Shared","Enforcement-SHOULD","Persona-Owner","Lifecycle-Maintenance"]
type: "posts"
---

#### ID: SFR2 - Category: Composition - WAF Aligned

Modules **SHOULD** set defaults in input parameters/variables to align to **high** priority/impact/severity recommendations, where appropriate and applicable, in the following frameworks and resources:

- [Well-Architected Framework (WAF)](https://learn.microsoft.com/azure/well-architected/what-is-well-architected-framework)
- [Reliability Hub](https://learn.microsoft.com/azure/reliability/overview-reliability-guidance)
- [Azure Proactive Resiliency Library (APRL)](https://aka.ms/aprl)
  - *Only Product Group (PG) verified*
- [Microsoft Defender for Cloud (MDFC)](https://learn.microsoft.com/en-us/azure/defender-for-cloud/recommendations-reference)

They **SHOULD NOT** align to these recommendations when it requires an external dependency/resource to be deployed and configured and then associated to the resources in the module.

Alignment **SHOULD** prioritize best-practices and security over cost optimization, but **MUST** allow for these to be overridden by a module consumer easily, if desired.

{{< hint type=tip >}}

Read the FAQ of [What does AVM mean by "WAF Aligned"?](/Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned) for more detailed information and examples.

{{< /hint >}}