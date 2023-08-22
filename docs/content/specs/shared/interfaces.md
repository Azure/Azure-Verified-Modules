---
title: Interfaces
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Below are the interfaces/schemas for the AVM Resource Modules features/extension resources as detailed in [RMFR4](/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) and [RMFR5](/Azure-Verified-Modules/specs/shared/#id-rmfr5---category-composition---avm-consistent-feature--extension-resources-value-add-interfacesschemas)

## Managed Identities

### Bicep

{{< include file="/static/includes/interfaces/int.mi.bicep" language="bicep" options="linenos=false" >}}

### Terraform

{{< include file="/static/includes/interfaces/int.mi.tf" language="terraform" options="linenos=false" >}}

### Notes

There is a difference in the User Assigned Managed Identity data types between Bicep and Terraform as we have simplified the consumer input for Bicep. However, in Terraform a map/object is a better data type to handle for_each loop ordering etc.

