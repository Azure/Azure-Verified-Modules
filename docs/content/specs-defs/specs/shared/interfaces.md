---
title: Interfaces
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/shared/interfaces/
---

Below are the interfaces/schemas for the AVM Resource Modules features/extension resources as detailed in [RMFR4](/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) and [RMFR5](/Azure-Verified-Modules/specs/shared/#id-rmfr5---category-composition---avm-consistent-feature--extension-resources-value-add-interfacesschemas)

{{< toc >}}

<br>

## Diagnostic Settings

{{< hint type=important >}}

Allowed values for logs and metric categories or category groups **MUST NOT** be specified to keep the module implementation evergreen for any new categories or category groups added by RPs, without module owners having to update a list of allowed values and cut a new release of their module.

{{< /hint >}}

{{< tabs "diag-settings" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< include file="/static/includes/interfaces/int.diag.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.diag.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Variable Declaration" >}}
  {{< include file="/static/includes/interfaces/int.diag.schema.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.diag.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

{{< hint type=note >}}

In the provided example for Diagnostic Settings, both logs and metrics are enabled for the associated resource. However, it is **IMPORTANT** to note that certain resources may not support both diagnostic setting types/categories. In such cases, the resource configuration **MUST** be modified accordingly to ensure proper functionality and compliance with system requirements.

{{< /hint >}}

<br>

## Role Assignments

{{< tabs "role-assignments" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< include file="/static/includes/interfaces/int.rbac.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.rbac.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Variable Declaration" >}}
  {{< include file="/static/includes/interfaces/int.rbac.schema.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.rbac.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

**Details on child, extension and cross-referenced resources:**

- Modules **MUST** support Role Assignments on child, extension and cross-referenced resources as well as the primary resource via parameters/variables

<br>

## Resource Locks

{{< tabs "locks" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< include file="/static/includes/interfaces/int.locks.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.locks.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Variable Declaration" >}}
  {{< include file="/static/includes/interfaces/int.locks.schema.tf" language="terraform" options="linenos=false" >}}
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

{{< hint type=important >}}

In Terraform, locks become part of the resource graph and suitable `depends_on` values should be set. Note that, during a `destroy` operation, Terraform will remove the locks before removing the resource itself, reducing the usefulness of the lock somewhat. Also note, due to eventual consistency in Azure, use of locks can cause destroy operations to fail as the lock may not have been fully removed by the time the destroy operation is executed.

{{< /hint >}}

<br>

## Tags

{{< tabs "tags" >}}
  {{< tab "Bicep Parameter Example" >}}
  {{< include file="/static/includes/interfaces/int.tags.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.tags.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Variable Declaration" >}}
  {{< include file="/static/includes/interfaces/int.tags.schema.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.tags.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

**Details on child, extension and cross-referenced resources:**

- Tags **MUST** be automatically applied to child, extension and cross-referenced resources, if tags are applied to the primary resource.
  - By default, all tags set for the primary resource will automatically be passed down to child, extension and cross-referenced resources.
  - This **MUST** be able to be overridden by the module consumer so they can specify alternate tags for child, extension and cross-referenced resources, if they desire via a parameter/variable
    - If overridden by the module consumer, no merge/union of tags will take place from the primary resource and only the tags specified for the child, extension and cross-referenced resources will be applied

<br>

## Managed Identities

{{< tabs "managed-identities" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< include file="/static/includes/interfaces/int.mi.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.mi.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Variable Declaration" >}}
  {{< include file="/static/includes/interfaces/int.mi.schema.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.mi.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

**Reason for differences in User Assigned data type in languages:**

- We do not forsee the Managed Identity Resource Provider team to ever add additional properties within the empty object (`{}`) value required on the input of a User Assigned Managed Identity.
- In Bicep we therefore have removed the need for this to be declared and just converted it to a simple array of Resource IDs
- However, in Terraform we have left it as a object/map as this simplifies `for_each` and other loop mechanisms and provides more consistency in plan, apply, destroy operations
  - Especially when adding, removing or changing the order of the User Assigned Managed Identities as they are declared

<br>

## Private Endpoints

{{< tabs "private-endpoints" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< hint type=note >}}
  Please note that you will need to ensure that the User-Defined Types for [Role Assignments](#role-assignments) & [Locks](#resource-locks) also are present in your module file for this interface to work correctly.
  {{< /hint >}}
  {{< expand "➕ Variant 1: A default service (`groupId`) can be assumed - e.g., for services that only have one private endpoint type)" "expand/collapse" >}}
  {{< include file="/static/includes/interfaces/int.pe.udt.schema1.bicep" language="bicep" options="linenos=false" >}}
  {{< /expand >}}
  {{< expand "➕ Variant 2: A default service (`groupId`) cannot be assumed - e.g., for services that have more than one private endpoint type, like a Storage Account (blob, file, etc.)" "expand/collapse" >}}
  {{< include file="/static/includes/interfaces/int.pe.udt.schema2.bicep" language="bicep" options="linenos=false" >}}
  {{< /expand >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.pe.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Variable Declaration" >}}
  {{< include file="/static/includes/interfaces/int.pe.schema.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.pe.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

**Notes:**

- The properties defined in the schema above are the minimum amount of properties expected to be exposed for Private Endpoints in AVM Resource Modules.
  - A module owner **MAY** chose to expose additional properties of the Private Endpoint resource
    - However, module owners considering this **SHOULD** contact the AVM core team first to consult on how the property should be exposed to avoid future breaking changes to the schema that may be enforced upon them
- Module owners **MAY** chose to define a list of allowed value for the 'service' (a.k.a. `groupIds`) property
  - However, they should do so with caution as should a new service appear for their resource module, a new release will need to be cut to add this new service to the allowed values
    - Whereas not specifying allowed values will allow flexibility from day 0 without the need for any changes and releases to be made

<br>

## Customer Managed Keys

{{< tabs "cmk" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< include file="/static/includes/interfaces/int.cmk.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.cmk.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Variable Declaration" >}}
  {{< include file="/static/includes/interfaces/int.cmk.schema.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Terraform Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.cmk.input.tf" language="terraform" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

<br>

## Azure Monitor Alerts

{{< hint type=note >}}

This interface is a **SHOULD** instead of a **MUST** and therefore the AVM core team have not mandated a interface schema to use.

{{< /hint >}}
