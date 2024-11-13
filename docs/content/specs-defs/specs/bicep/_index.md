---
title: Bicep Specific Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/bicep/
---

{{< hint type=tip >}}

Make sure to checkout the [Shared Specification](/Azure-Verified-Modules/specs/shared/) first before reading further so you understand the specifications items that are shared and agnostic to the IaC language/tool.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

<br>

This page contains the **Bicep specific requirements** for AVM modules (**Resource and Pattern modules**) that ALL Bicep AVM modules **MUST** meet. These requirements are in addition to the [Shared Specification](/Azure-Verified-Modules/specs/shared/) requirements that ALL AVM modules **MUST** meet.

The following table summarizes the category identification codes used in this specification:

| Scope                                            | Functional requirements                 | Non-functional requirements                   |
|--------------------------------------------------|-----------------------------------------|-----------------------------------------------|
| Shared requirements (resource & pattern modules) | [BCPFR](#functional-requirements-bcpfr) | [BCPNFR](#non-functional-requirements-bcpnfr) |
| Resource module level requirements               | *N/A*                                   | [BCPRMNFR](#non-functional-requirements-bcprmnfr)                                      |
| Pattern module level requirements                | *N/A*                                   | *N/A*                                         |

<br>

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for Bicep AVM modules (Resource and Pattern).


### Functional Requirements (BCPFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/bicep/shared/functional" type="page" tags="Class-Resource,Class-Pattern,Type-Functional,Language-Bicep" recursive=true strict=false showHint=true hintText="This section includes **Bicep specific, functional requirements (BCPFR)** for AVM modules (Resource and Pattern)." summarize=false >}}

### Non-Functional Requirements (BCPNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/bicep/shared/non-functional" type="page" tags="Class-Resource,Class-Pattern,Type-NonFunctional,Language-Bicep" recursive=true strict=false showHint=true hintText="This section includes **Bicep specific, non-functional requirements (BCPNFR)** for AVM modules (Resource and Pattern)." summarize=false >}}

## Resource Module Requirements

Listed below are both functional and non-functional requirements for Bicep [AVM Resource Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Non-Functional Requirements (BCPRMNFR)

{{< includePagesBasedOnTags folder="content/specs-defs/includes/bicep/resource/non-functional" type="page" tags="Class-Resource,Type-NonFunctional,Language-Bicep" recursive=true strict=false showHint=true hintText="This section includes **resource module level, non-functional requirements (BCPRMNFR)** for Bicep." summarize=false >}}
