---
title: Interfaces
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

Below are the interfaces/schemas for the AVM Resource Modules features/extension resources as detailed in [RMFR4](/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) and [RMFR5](/Azure-Verified-Modules/specs/shared/#id-rmfr5---category-composition---avm-consistent-feature--extension-resources-value-add-interfacesschemas)

{{< toc >}}

## Diagnostic Settings

{{< hint type=important >}}

Allowed values for logs and metric categories or category groups **MUST NOT** be specified to keep the module implementation evergreen for any new categories or category groups added by RPs, without module owners having to update a list of allowed values and cut a new release of their module.

{{< /hint >}}

{{< tabs "diag-settings" >}}
  {{< tab "Bicep Schema" >}}
  {{< include file="/static/includes/interfaces/int.diag.schema.bicep.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.diag.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Schema" >}}
  {{< include file="/static/includes/interfaces/int.diag.schema.tf.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.diag.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

## Role Assignments

{{< tabs "role-assignments" >}}
  {{< tab "Bicep Schema" >}}
  {{< include file="/static/includes/interfaces/int.rbac.schema.bicep.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.rbac.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Schema" >}}
  {{< include file="/static/includes/interfaces/int.rbac.schema.tf.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.rbac.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

## Resource Locks

{{< tabs "locks" >}}
  {{< tab "Bicep Schema" >}}
  {{< include file="/static/includes/interfaces/int.locks.schema.bicep.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.locks.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Schema" >}}
  {{< include file="/static/includes/interfaces/int.locks.schema.tf.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.locks.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

**Details on child and extension resources:**

- Locks **SHOULD** be able to be set for child resources of the primary resource in resource modules

**Details on cross-referenced resources:**

- Locks **MUST** be automatically applied to cross-referenced resources if the primary resource has a lock applied.
  - This **MUST** also be able to be turned off for each of the cross-referenced resources by the module consumer via a parameter/variable if they desire

An example of this is a Key Vault module that has a Private Endpoints enabled. If a lock is applied to the Key Vault via the `lock` parameter/variable then the lock should also be applied to the Private Endpoint automatically, unless the `privateEndpointLock/private_endpoint_lock` (example name) parameter/variable is set to `None`

## Tags

{{< tabs "tags" >}}
  {{< tab "Bicep Schema" >}}
  {{< include file="/static/includes/interfaces/int.tags.schema.bicep.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.tags.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Schema" >}}
  {{< include file="/static/includes/interfaces/int.tags.schema.tf.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.tags.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

## Managed Identities

{{< tabs "managed-identities" >}}
  {{< tab "Bicep Schema" >}}
  {{< include file="/static/includes/interfaces/int.mi.schema.bicep.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.mi.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Schema" >}}
  {{< include file="/static/includes/interfaces/int.mi.schema.tf.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.mi.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

## Private Endpoints

{{< tabs "private-endpoints" >}}
  {{< tab "Bicep Schema" >}}
  {{< include file="/static/includes/interfaces/int.pe.schema.bicep.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.pe.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Schema" >}}
  {{< include file="/static/includes/interfaces/int.pe.schema.tf.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.pe.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

## Customer Managed Keys

{{< tabs "cmk" >}}
  {{< tab "Bicep Schema" >}}
  {{< include file="/static/includes/interfaces/int.cmk.schema.bicep.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.cmk.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Schema" >}}
  {{< include file="/static/includes/interfaces/int.cmk.schema.tf.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.cmk.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

## Azure Monitor Alerts

{{< hint type=note >}}

This interface is a **SHOULD** instead of a **MUST** and therefore the AVM core team have not mandated a interface schema to use.

{{< /hint >}}
