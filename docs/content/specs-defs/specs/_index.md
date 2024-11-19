---
title: Module Specifications
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocCollapseSection: true
url: /specs/module-specs/
---

{{< toc >}}

This section documents all the specifications for Azure Verified Modules (AVM) and their respective IaC languages.

## Specifications by IaC Language

{{< tagsStats folder="content/specs-defs/includes" recursive=true >}}

## How to navigate the specifications?

The "Module Specifications" section uses tags to dynamically render content based on the selected attributes, such as the IaC language, module classification, category, severity and more. The tags are defined in the front matter of the markdown files.

To make it easier for module owners and contributors to navigate the documentation, the specifications are grouped to distinct pages by the IaC language (`Bicep` | `Terraform`) and module classification ( `resource` | `pattern` | `utility`). The specifications on each page are further ordered by the category (e.g., `Composition`, `CodeStyle`, `Testing`, etc.), severity of the requirements (`MUST` | `SHOULD` | `MAY`) and at what stage of the module's lifecycle the specification is typically applicable (`Initial` | `BAU` | `EOL`).

To find what you need, simply decide which IaC language you'd like develop in, and what classification your module falls under. Then, navigate to the respective page to find the specifications that are relevant to you.

## Why are there language specific specifications?

While every effort is being made to standardize requirements and implementation details across all languages, it is expected that some of the specifications will be different between their respective languages to ensure we follow the best practices and leverage features of each language.

## How to read the specifications?

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

As you're developing/maintaining a module as a module owner or contributor, you need to ensure that your module adheres to the specifications outlined in this section. The specifications are designed to ensure that all AVM modules are consistent, secure, and compliant with best practices.

There are 3 levels of specifications:

- MUST: These are mandatory requirements that **MUST** be followed.
- SHOULD: These are recommended requirements that **SHOULD** be followed, unless there are good reasons for not to.
- MAY: These are optional requirements that **MAY** be followed at the module owner's/contributor's discretion.

## Last Modified

{{< specsHistory folder="content/specs-defs/includes" recursive=true tags="Language-Bicep" >}}
