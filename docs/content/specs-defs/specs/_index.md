---
title: Module Specifications
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocCollapseSection: true
url: /specs/module-specs/
---

This section documents all the specifications for Azure Verified Modules (AVM) and their respective IaC languages.

## How to navigate the specifications?

The AVM specifications section uses tags to dynamically render content based on the selected attributes, such as the IaC language, module classification, category, severity and more. The tags are defined in the front matter of the markdown files.

## How to read the specifications?

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

As you're developing/maintaining a module as a module owner or contributor, you need to ensure that your module adheres to the specifications outlined in this section. The specifications are designed to ensure that all AVM modules are consistent, secure, and compliant with best practices.

There are 3 levels of specifications:

- MUST: These are mandatory requirements that **MUST** be followed.
- SHOULD: These are recommended requirements that **SHOULD** be followed, unless there are good reasons for not to.
- MAY: These are optional requirements that **MAY** be followed at the module owner's/contributor's discretion.
