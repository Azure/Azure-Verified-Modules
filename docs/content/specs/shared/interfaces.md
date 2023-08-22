---
title: Interfaces
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Below are the interfaces/schemas for the AVM Resource Modules features/extension resources as detailed in [RMFR4](/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) and [RMFR5](/Azure-Verified-Modules/specs/shared/#id-rmfr5---category-composition---avm-consistent-feature--extension-resources-value-add-interfacesschemas)

{{< toc >}}

## Diagnostic Settings

### Bicep

#### Schema

{{< include file="/static/includes/interfaces/int.diag.schema.bicep.json" language="json" options="linenos=false" >}}

#### Input Example with Values

{{< include file="/static/includes/interfaces/int.diag.input.bicep" language="bicep" options="linenos=false" >}}

### Terraform

{{< include file="/static/includes/interfaces/int.diag.tf" language="terraform" options="linenos=false" >}}

### Notes

TBC

## Role Assignments

### Bicep

{{< include file="/static/includes/interfaces/int.rbac.bicep" language="bicep" options="linenos=false" >}}

### Terraform

{{< include file="/static/includes/interfaces/int.rbac.tf" language="terraform" options="linenos=false" >}}

### Notes

TBC

## Tags

### Bicep

{{< include file="/static/includes/interfaces/int.tags.bicep" language="bicep" options="linenos=false" >}}

### Terraform

{{< include file="/static/includes/interfaces/int.tags.tf" language="terraform" options="linenos=false" >}}

### Notes

TBC

## Managed Identities

### Bicep

{{< include file="/static/includes/interfaces/int.mi.bicep" language="bicep" options="linenos=false" >}}

### Terraform

{{< include file="/static/includes/interfaces/int.mi.tf" language="terraform" options="linenos=false" >}}

### Notes

There is a difference in the User Assigned Managed Identity data types between Bicep and Terraform as we have simplified the consumer input for Bicep. However, in Terraform a map/object is a better data type to handle for_each loop ordering etc.

## Private Endpoints

### Bicep

{{< include file="/static/includes/interfaces/int.pe.bicep" language="bicep" options="linenos=false" >}}

### Terraform

{{< include file="/static/includes/interfaces/int.pe.tf" language="terraform" options="linenos=false" >}}

### Notes

TBC

## Customer Managed Keys

### Bicep

{{< include file="/static/includes/interfaces/int.cmk.bicep" language="bicep" options="linenos=false" >}}

### Terraform

{{< include file="/static/includes/interfaces/int.cmk.tf" language="terraform" options="linenos=false" >}}

### Notes

TBC

## Azure Monitor Alerts

{{< hint type=note >}}

This interface is a **SHOULD** instead of a **MUST** and therefore the AVM core team have not mandated a interface schema to use.

{{< /hint >}}
