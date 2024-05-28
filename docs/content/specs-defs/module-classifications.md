---
title: Module Classifications
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/shared/module-classifications/
---

AVM defines two module classifications, **Resource Modules** and **Pattern Modules**, that can be created, published, and consumed, these are defined further in the table below:

<!-- markdownlint-disable -->
| Module Class | Definition | Who is it for? |
| --------------------- | ---------- | -------------- |
|**Resource Module** | Deploys a primary resource with WAF high priority/impact best practice configurations set by default, e.g., availability zones, firewall, enforced Entra ID authentication and other shared interfaces, e.g., RBAC, Locks, Private Endpoints etc. (if supported). See [What does AVM mean by "WAF Aligned"?](/Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned) <br><br> They MAY include related resources, e.g. VM contains disk & NIC. Focus should be on customer experience. A customer would expect that a VM module would include all required resources to provision a VM. <br><br> Furthermore, Resource Modules MUST NOT deploy external dependencies for the primary resource. E.g. a VM needs a vNet and Subnet to be deployed into, but the vNet will not be created by the VM Resource Module.<br><br> Finally, a resource can be anything such as Microsoft Defender for Cloud Pricing Plans, these are still resources in ARM and can therefore be created as a Resource Module. | People who want to craft bespoke architectures that default to WAF best practices, where appropriate, for each resource. <br><br> People who want to create pattern modules. |
| **Pattern Module** | Deploys multiple resources, usually using Resource Modules. They can be any size but should help accelerate a common task/deployment/architecture. <br><br> Good candidates for pattern modules are those architectures that exist in [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/), or other official documentation. <br><br> *Note:* Pattern modules can contain other pattern modules, however, pattern modules MUST NOT contain references to non-AVM modules. | People who want to easily deploy patterns (architectures) using WAF best practices. |
| **Utility Module**<br>(draft,<br>see below) | Implements a function or routine that can be flexibly reused in resource or pattern modules - e.g., a function that retrieves the endpoint of an API or portal of a given environment. <br><br>It MUST NOT deploy any Azure resources other than deployment scripts. | People who want to leverage commonly used functions/routines/helpers in their module, instead of re-implementing them locally. |
<!-- markdownlint-enable -->

{{< hint title="PREVIEW" >}}

The concept of **Utility Modules** will be introduced gradually, through some initial examples. The definition above is subject to change as additional details are worked out.

The required automated tests and other workflow elements will be derived from the Pattern Modules' automation/CI environment as the concept matures.

Utility modules will follow the below naming convention:

- Bicep: `avm/utl/<hyphenated grouping/category name>/<hyphenated utility module name>`. Modules will be kept under the `avm/utl` folder in the BRM repository.
- Terraform: `avm-utl-<utility-module-name>`. Repositories will be named after the utility module (e.g., `terraform-azurerm-avm-utl-<my utility module>`).

All related documentation (functional and non-functional requirements, etc.) will also be published along the way.

{{< /hint >}}
