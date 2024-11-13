---
title: SFR6 - Data Redundancy
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: [
  Class-Resource,
  Class-Pattern,
  Type-Functional,
  Category-Composition,
  Language-Bicep,
  Language-Terraform,
  Severity-TBD,
  Persona-Owner,
  Lifecycle-Initial
]
type: "posts"
---

#### ID: SFR6 - Category: Composition - Data Redundancy

Modules that deploy resources or patterns that support data redundancy **SHOULD** enable this to the highest possible value by default, e.g. `RA-GZRS`. When a resource or pattern doesn't provide the ability to specify data redundancy as a simple property, e.g. `GRS` etc., then the modules **MUST** provide the ability to enable data redundancy for the resources or pattern via parameters/variables.

For example, a Storage Account module can simply set the `sku.name` property to `Standard_RAGZRS`. Whereas a SQL DB or Cosmos DB module will need to expose more properties, via parameters/variables, to allow the specification of the regions to replicate data to as per the consumers requirements.

{{< hint type=note >}}

For information on the data redundancy options in Azure, see [Cross-region replication in Azure](https://learn.microsoft.com/en-us/azure/reliability/cross-region-replication-azure)

{{< /hint >}}
