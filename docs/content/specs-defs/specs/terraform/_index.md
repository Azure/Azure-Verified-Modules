---
title: Terraform Specifications
linktitle: Terraform
url: /specs/tf/
description: Terraform Module Specifications for the Azure Verified Modules (AVM) program
---

## Specifications by Category and Module Classification

{{< tagsStats folder="content/specs-defs/includes" recursive=true language="Terraform" >}}

## How to propose changes to the specifications?

{{% notice style="important" %}}

Any updates to existing or new specifications for Terraform must be submitted as a draft for review by Azure Terraform PG/Engineering(`@Azure/terraform-avm`) and AVM core team(`@Azure/avm-core-team`).

{{% /notice %}}

## Why AVM Terraform modules favor AzAPI

AVM Terraform modules **MUST** use the [AzAPI](https://registry.terraform.io/providers/Azure/azapi/latest) provider. The AzureRM provider is only permitted under the narrow exception described in [TFFR3](/spec/TFFR3) (resources that have no AzAPI equivalent, e.g. some data-plane resources).

This decision is intentional and is driven by the following factors:

- **Built-in retries and error handling.** AzAPI exposes first-class `retry` and `timeouts` blocks, including regex-based error matching, which lets modules handle transient failures (for example, scope locks being removed or eventual-consistency errors) deterministically and without external workarounds.
- **Pre-flight validation.** AzAPI performs ARM API pre-flight checks at plan time, surfacing many configuration errors *before* an apply is attempted. This produces faster feedback loops and fewer partially-deployed resources.
- **Day-zero access to the latest Azure features.** Because AzAPI talks directly to the Azure Resource Manager REST API, modules can adopt new resource types, properties and API versions as soon as they ship in Azure — without waiting for an AzureRM provider release.
- **Alignment with Bicep and ARM.** AzAPI uses the same resource type identifiers (e.g. `Microsoft.KeyVault/vaults@2023-07-01`) and the same property shape as Bicep and ARM templates. This makes it dramatically easier to translate documentation, samples and Bicep modules into Terraform, and keeps Bicep and Terraform AVM modules conceptually aligned.
- **Close partnership with the Azure engineering teams.** AzAPI is built and maintained in close collaboration with the Azure Resource Provider engineering teams. Issues in AzAPI can be triaged directly against the underlying ARM behavior, and the AVM team works directly with the AzAPI engineering team on roadmap and breaking changes.
- **Consistency across the AVM ecosystem.** Standardizing on AzAPI means every AVM Terraform module uses the same patterns for identity, diagnostic settings, role assignments, locks and private endpoints — primarily through the [`Azure/avm-utl-interfaces/azure`](https://registry.terraform.io/modules/Azure/avm-utl-interfaces/azure/latest) utility module — which simplifies authoring, review and consumer experience.

## What changed recently?

{{< specsHistory folder="content/specs-defs/includes" recursive=true tags="Language-Terraform" daysShown=30 >}}
