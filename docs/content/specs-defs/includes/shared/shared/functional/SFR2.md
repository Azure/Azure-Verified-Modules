---
title: SFR2 - WAF Aligned
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SFR2
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 20
---

## ID: SFR2 - Category: Composition - WAF Aligned

Modules **SHOULD** set defaults in input parameters/variables to align to **high** priority/impact/severity recommendations, where appropriate and applicable, in the following frameworks and resources:

- [Well-Architected Framework (WAF)](https://learn.microsoft.com/azure/well-architected/what-is-well-architected-framework)
- [Reliability Hub](https://learn.microsoft.com/azure/reliability/overview-reliability-guidance)
- [Azure Proactive Resiliency Library (APRL)](https://aka.ms/aprl)
  - *Only Product Group (PG) verified*
- [Microsoft Defender for Cloud (MDFC)](https://learn.microsoft.com/en-us/azure/defender-for-cloud/recommendations-reference)

They **SHOULD NOT** align to these recommendations when it requires an external dependency/resource to be deployed and configured and then associated to the resources in the module.

Alignment **SHOULD** prioritize best-practices and security over cost optimization, but **MUST** allow for these to be overridden by a module consumer easily, if desired.

### Module class applicability

Resource modules require executable `defaults` and `waf-aligned` examples. Pattern and utility modules require only a `defaults` example; a WAF-aligned example is optional for these classes.

The SFR2 default-setting requirement and the example-folder naming convention are separate. A folder or scenario named `waf-aligned` does not prove that all applicable WAF recommendations have been implemented or that the scenario is semantically compliant. Module owners must document and implement the applicable recommendations; owners must not claim complete WAF compliance solely from a folder name.

{{% notice style="tip" %}}

Read the FAQ of [What does AVM mean by "WAF Aligned"?]({{% siteparam base %}}/faq/#what-does-avm-mean-by-waf-aligned) for more detailed information and examples.

{{% /notice %}}
