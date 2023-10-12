---
title: Module Classifications
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

AVM defines two module classifications, **Resource Modules** and **Pattern Modules**, that can be created, published, and consumed, these are defined further in the table below:

| Module Classification | Definition | Who is it for? |
| --------------------- | ---------- | -------------- |
|**Resource Module** | Deploys a primary resource with WAF best practice configurations set by default, e.g., RBAC, Locks, Private Endpoints etc. (if supported). <br><br> They MAY include related resources, e.g. VM contains disk & NIC. Focus should be on customer experience. A customer would expect that a VM module would include all required resources to provision a VM. <br><br> Furthermore, Resource Modules MUST NOT deploy external dependencies for the primary resource. E.g. a VM needs a vNet and Subnet to be deployed into, but the vNet will not be created by the VM Resource Module. <br><br> Finally, a resource can be anything such as Microsoft Defender for Cloud Pricing Plans, these are still resources in ARM and can therefore be created as a Resource Module. | People that want to craft bespoke architectures that default to WAF best practices, where appropriate, for each resource. <br><br> People that want to create pattern modules. |
| **Pattern Module** | Deploys multiple resources, usually using Resource Modules. They can be any size but should help accelerate a common task/deployment/architecture. <br><br> Good candidates for pattern modules are those architectures that exist in [Azure Architecture Center](https://learn.microsoft.com/azure/architecture/), or other official documentation. <br><br> *Note:* It is feasible that pattern modules can contain other pattern modules, however, pattern modules MUST NOT contain references to non-AVM modules. | People that want to easily deploy patterns (architectures) using WAF best practices. |
