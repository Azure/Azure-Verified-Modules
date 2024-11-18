---
title: Shared Specification (Bicep & Terraform)
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/shared/
---

{{< hint type=warning >}}

**Legacy content**

The content on this website has been deprecated and will be removed in the future.

Please refer to the new documentation under the [Bicep Spefications](/Azure-Verified-Modules/specs/bcp/) / [Terraform Specifications](/Azure-Verified-Modules/specs/tf/) chapters for the most up-to-date information.

{{< /hint >}}

This page contains the shared **requirements for both Bicep and Terraform** AVM modules (**Resource and Pattern modules**) that ALL AVM modules **MUST** meet. In addition to these, requirements specific to each language, defined in their respective specifications also **MUST** be met. See [Bicep](/Azure-Verified-Modules/specs/bicep/) and [Terraform](/Azure-Verified-Modules/specs/terraform/) specific requirements for more information.

The following table summarizes the category identification codes used in this specification:

| Scope                                            | Functional requirements               | Non-functional requirements                 |
|--------------------------------------------------|---------------------------------------|---------------------------------------------|
| Shared requirements (resource & pattern modules) | [SFR](#functional-requirements-sfr)   | [SNFR](#non-functional-requirements-snfr)   |
| Resource module level requirements               | [RMFR](#functional-requirements-rmfr) | [RMNFR](#non-functional-requirements-rmnfr) |
| Pattern module level requirements                | [PMFR](#functional-requirements-pmfr) | [PMNFR](#non-functional-requirements-pmnfr) |

<br>

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for both classifications of AVM modules (Resource and Pattern) and all languages.

{{< hint type=note >}}

While every effort is being made to standardize requirements and implementation details across all languages, it is expected that some of the specifications will be different between their respective languages to ensure we follow the best practices and leverage features of each language.

{{< /hint >}}

<br>

### Functional Requirements (SFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/shared/functional" tags="Class-Resource,Class-Pattern,Type-Functional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **shared, functional requirements (SFR)** for Bicep and Terraform AVM modules (Resource and Pattern)." summarize=false >}}

### Non-Functional Requirements (SNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/shared/non-functional" tags="Class-Resource,Class-Pattern,Type-NonFunctional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **shared, non-functional requirements (SNFR)** for Bicep and Terraform AVM modules (Resource and Pattern)." summarize=false >}}

## Resource Module Requirements

Listed below are both functional and non-functional requirements for [AVM Resource Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements (RMFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/resource/functional" tags="Class-Resource,Type-Functional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **resource module level, functional requirements (RMFR)** for Bicep and Terraform." summarize=false >}}

### Non-Functional Requirements (RMNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/resource/non-functional" tags="Class-Resource,Type-NonFunctional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **resource module level, non-functional requirements (RMNFR)** for Bicep and Terraform." summarize=false >}}

## Pattern Module Requirements

Listed below are both functional and non-functional requirements for [AVM Pattern Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements (PMFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/pattern/functional" tags="Class-Pattern,Type-Functional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **pattern module level, functional requirements (PMFR)** for Bicep and Terraform." summarize=false >}}

### Non-Functional Requirements (PMNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/pattern/non-functional" tags="Class-Pattern,Type-NonFunctional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **pattern module level, non-functional requirements (PMNFR)** for Bicep and Terraform." summarize=false >}}
