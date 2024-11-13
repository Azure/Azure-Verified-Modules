---
title: SFR5 - Availability Zones
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: ["Class-Shared",
  "Type-Functional",
  "Category-Composition",
  "Language-Shared",
  "Enforcement-MUST",
  "Persona-Owner",
  "Lifecycle-Initial
]
type: "posts"
---

#### ID: SFR5 - Category: Composition - Availability Zones

Modules that deploy ***zone-redundant*** resources **MUST** enable the spanning across as many zones as possible by default, typically all 3.

Modules that deploy ***zonal*** resources **MUST** provide the ability to specify a zone for the resources to be deployed/pinned to. However, they **MUST NOT** default to a particular zone by default, e.g. `1` in an effort to make the consumer aware of the zone they are selecting to suit their architecture requirements.

For both scenarios the modules **MUST** expose these configuration options via configurable parameters/variables.

{{< hint type=note >}}

For information on the differences between zonal and zone-redundant services, see [Availability zone service and regional support](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support)

{{< /hint >}}
