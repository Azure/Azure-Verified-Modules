---
draft: false
title: Module Specifications
linktitle: Module Specifications
weight: 1
url: /specs/module-specs/
---

This section documents all the specifications for Azure Verified Modules (AVM) and their respective IaC languages.

## Specifications by IaC Language

{{< tagsStats folder="content/specs-defs/includes" recursive=true >}}

## What changed recently?

{{< specsHistory folder="content/specs-defs/includes" recursive=true daysShown=30 >}}

## How to navigate the specifications?

The "Module Specifications" section uses tags to dynamically render content based on the selected attributes, such as the IaC language, module classification, category, severity and more. The tags are defined in hidden header of each specification page.

To make it easier for module owners and contributors to navigate the documentation, the specifications are grouped to distinct pages by the IaC language (`Bicep` | `Terraform`) and module classification ( `resource` | `pattern` | `utility`). The specifications on each page are further ordered by the category (e.g., `Composition`, `CodeStyle`, `Testing`, etc.), severity of the requirements (`MUST` | `SHOULD` | `MAY`) and at what stage of the module's lifecycle the specification is typically applicable (`Initial` | `BAU` | `EOL`).

To find what you need, simply decide which IaC language you'd like develop in, and what classification your module falls under. Then, navigate to the respective page to find the specifications that are relevant to you.

### Specification Tags

The following tags are used to qualify the specifications:

| Key       | Allowed Values                                                                                                                 | Multiple/Single     |
|-----------|--------------------------------------------------------------------------------------------------------------------------------|-------------------- |
| Language  | Bicep, Terraform                                                                                                               | Multiple            |
| Class     | Resource, Pattern, Utility                                                                                                     | Multiple            |
| Type      | Functional, NonFunctional                                                                                                      | Single              |
| Category  | Testing, Telemetry, Contribution/Support, Documentation, CodeStyle, Naming/Composition, Inputs/Outputs, Release/Publishing     | Single              |
| Severity  | MUST, SHOULD, MAY                                                                                                              | Single              |
| Persona   | Owner, Contributor                                                                                                             | Multiple            |
| Lifecycle | Initial, BAU, EOL                                                                                                              | Single              |
| Validation| **Bicep**: BCP/Manual, BCP/CI/Informational, BCP/CI/Enforced <br>**Terraform**: TF/Manual, TF/CI/Informational, TF/CI/Enforced | Single per language |

Each tag is a concatenation of exactly one of the keys and one of the values, e.g., `Language-Bicep`, `Class-Resource`, `Type-Functional`, etc. When it's marked as `Multiple`, it means that the tag can have multiple values, e.g., `Language-Bicep, Language-Terraform`, or `Persona-Owner, Persona-Contributor`, etc. When it's marked as `Single`, it means that the tag can have only one value, e.g., `Type-Functional`, `Lifecycle-Initial`, etc.

{{% expand title="➕ Click here to see the definition of the Severity, Persona, Lifecycle and Validation tags..." expanded="false" %}}

**Severity**

What's the severity or importance of this specification? See "[How to read the specifications?]({{% siteparam base %}}/specs/module-specs/#how-to-read-the-specifications)" section for more details.

**Persona**

Who is this specification for? The `Owner` is the module owner, while the `Contributor` is anyone who contributes to the module.

**Lifecycle**

When is this specification mostly relevant?

- The `Initial` stage is when the module is being developed first - e.g., naming related specs are labeled with `Lifecycle-Initial` as the naming of the module only happens once: at the beginning of their life.
- The `BAU` (business as usual) stage is at any time during the module's typical lifecycle - e.g., specs that describe coding standards are relevant throughout the module's life, for any time a new module version is released.
- The `EOL` stage is when the module is being decommissioned - e.g., specs describing how a module should be retired are labeled with `Lifecycle-EOL`.

**Validation**

How is this specification checked/validated/enforced?

- `Manual` means that the specification is manually enforced at the time of the module review (at the time of the first or any subsequent module version release).
- `CI/Informational` means that the module is checked against the specification by a CI pipeline, but the failure is only informational and doesn't block the module release.
- `CI/Enforced` means that the specification is automatically enforced by a CI pipeline, and the failure blocks the module release.

Note: the `BCP/` or `TF/` prefix is required as shared (language-agnostic) specifications may have different level of validation/enforcement per each language - e.g., it is possible that a specification is enforced by a CI pipeline for Bicep modules, while it is manually enforced for Terraform modules.

{{% /expand %}}

## Why are there language specific specifications?

While every effort is being made to standardize requirements and implementation details across all languages (and most specifications in fact, are applicable to all), it is expected that some of the specifications will be different between their respective languages to ensure we follow the best practices and leverage features of each language.

## How to read the specifications?

{{% notice style="important" %}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{% /notice %}}

As you're developing/maintaining a module as a module owner or contributor, you need to ensure that your module adheres to the specifications outlined in this section. The specifications are designed to ensure that all AVM modules are consistent, secure, and compliant with best practices.

There are 3 levels of specifications:

- MUST: These are mandatory requirements that **MUST** be followed.
- SHOULD: These are recommended requirements that **SHOULD** be followed, unless there are good reasons for not to.
- MAY: These are optional requirements that **MAY** be followed at the module owner's/contributor's discretion.
