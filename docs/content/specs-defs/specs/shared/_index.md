---
title: Shared Specification (Bicep & Terraform)
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/shared/
---

{{< hint type=tip >}}

Make sure to checkout the [Module Classification Definitions](/Azure-Verified-Modules/specs/shared/module-classifications/) first before reading further so you understand the difference between a Resource and Pattern Module in AVM.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

<br>

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

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/shared/functional" type="page" tags="Class-Resource,Class-Pattern,Type-Functional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **shared, functional requirements (SFR)** for Bicep and Terraform AVM modules (Resource and Pattern)." summarize=false >}}

### Non-Functional Requirements (SNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/shared/non-functional" type="page" tags="Class-Resource,Class-Pattern,Type-NonFunctional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **shared, non-functional requirements (SNFR)** for Bicep and Terraform AVM modules (Resource and Pattern)." summarize=false >}}

## Resource Module Requirements

Listed below are both functional and non-functional requirements for [AVM Resource Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements (RMFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/resource/functional" type="page" tags="Class-Resource,Type-Functional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **resource module level, functional requirements (RMFR)** for Bicep and Terraform." summarize=false >}}

### Non-Functional Requirements (RMNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/resource/non-functional" type="page" tags="Class-Resource,Type-NonFunctional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **resource module level, non-functional requirements (RMNFR)** for Bicep and Terraform." summarize=false >}}

## Pattern Module Requirements

Listed below are both functional and non-functional requirements for [AVM Pattern Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements (PMFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/pattern/functional" type="page" tags="Class-Pattern,Type-Functional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **pattern module level, functional requirements (PMFR)** for Bicep and Terraform." summarize=false >}}

### Non-Functional Requirements (PMNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/shared/pattern/non-functional" type="page" tags="Class-Pattern,Type-NonFunctional,Language-Bicep,Language-Terraform" recursive=true strict=false showHint=true hintText="This section includes **pattern module level, non-functional requirements (PMNFR)** for Bicep and Terraform." summarize=false >}}
