---
title: Terraform Specific Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/terraform/
---

{{< hint type=warning >}}

**Legacy content**

The content on this website has been deprecated and will be removed in the future.

Please refer to the new documentation under the [Terraform Specifications](/Azure-Verified-Modules/specs/tf/) chapter for the most up-to-date information.

{{< /hint >}}

This page contains the **Terraform specific requirements** for AVM modules (**Resource and Pattern modules**) that ALL Terraform AVM modules **MUST** meet. These requirements are in addition to the [Shared Specification](/Azure-Verified-Modules/specs/shared/) requirements that ALL AVM modules **MUST** meet.

{{< hint type=important >}}

Provider Versatility: Users have the autonomy to choose between AzureRM, AzAPI, or a combination of both, tailored to the specific complexity of module requirements.

{{< /hint >}}

The following table summarizes the category identification codes used in this specification:

| Scope                                            | Functional requirements               | Non-functional requirements                 |
| ------------------------------------------------ | ------------------------------------- | ------------------------------------------- |
| Shared requirements (resource & pattern modules) | [TFFR](#functional-requirements-tffr) | [TFNFR](#non-functional-requirements-tfnfr) |
| Resource module level requirements               | *N/A*                                 | *N/A*                                       |
| Pattern module level requirements                | *N/A*                                 | *N/A*                                       |

<br>

{{< toc >}}

<br>

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for Terraform AVM modules (Resource and Pattern).

<br>

### Functional Requirements (TFFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/terraform/shared/functional" tags="Class-Resource,Class-Pattern,Type-Functional,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **Terraform specific, functional requirements (TFFR)** for AVM modules (Resource and Pattern)." summarize=false >}}

### Non-Functional Requirements (TFNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/terraform/shared/non-functional" tags="Class-Resource,Class-Pattern,Type-NonFunctional,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **Terraform specific, non-functional requirements (TFNFR)** for AVM modules (Resource and Pattern)." summarize=false >}}
