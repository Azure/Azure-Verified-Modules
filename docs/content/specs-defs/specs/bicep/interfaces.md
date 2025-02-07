---
title: Bicep Interfaces
linktitle: Interfaces
url: /specs/bcp/res/interfaces/
description: Bicep Module Interface Specifications for the Azure Verified Modules (AVM) program
---

This chapter details the interfaces/schemas for the AVM Resource Modules features/extension resources as referenced in [RMFR4]({{% siteparam base %}}/spec/RMFR4) and [RMFR5]({{% siteparam base %}}/spec/RMFR5).

## Diagnostic Settings

{{% notice style="important" %}}

Allowed values for logs and metric categories or category groups **MUST NOT** be specified to keep the module implementation evergreen for any new categories or category groups added by RPs, without module owners having to update a list of allowed values and cut a new release of their module.

{{% /notice %}}

{{< tabs title="Diagnostic Settings" >}}
{{% tab title="Variant 1: Diagnostic settings with both logs & metrics" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.diag.udt.schema1.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.diag.input1.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Variant 2: Diagnostic settings with only metrics" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.diag.udt.schema2.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.diag.input2.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Variant 3: Diagnostic settings with only logs" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.diag.udt.schema3.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.diag.input3.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{< /tabs >}}

{{% notice style="note" %}}

In the provided example for Diagnostic Settings, both logs and metrics are enabled for the associated resource. However, it is **IMPORTANT** to note that certain resources may not support both diagnostic setting types/categories. In such cases, the resource configuration **MUST** be modified accordingly to ensure proper functionality and compliance with system requirements.

{{% /notice %}}

## Role Assignments

{{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
  {{% include file="/static/includes/interfaces/bicep/int.rbac.udt.schema.bicep" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/bicep/int.rbac.input.bicep" %}}
{{< /highlight >}}

**Details on child, extension and cross-referenced resources:**

- Modules **MUST** support Role Assignments on child, extension and cross-referenced resources as well as the primary resource via parameters/variables

## Resource Locks

{{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
  {{% include file="/static/includes/interfaces/bicep/int.locks.udt.schema.bicep" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/bicep/int.locks.input.bicep" %}}
{{< /highlight >}}

**Details on child and extension resources:**

- Locks **SHOULD** be able to be set for child resources of the primary resource in resource modules

**Details on cross-referenced resources:**

- Locks **MUST** be automatically applied to cross-referenced resources if the primary resource has a lock applied.
  - This **MUST** also be able to be turned off for each of the cross-referenced resources by the module consumer via a parameter/variable if they desire

An example of this is a Key Vault module that has a Private Endpoints enabled. If a lock is applied to the Key Vault via the `lock` parameter/variable then the lock should also be applied to the Private Endpoint automatically, unless the `privateEndpointLock/private_endpoint_lock` (example name) parameter/variable is set to `None`

## Tags

{{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
  {{% include file="/static/includes/interfaces/bicep/int.tags.udt.schema.bicep" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/bicep/int.tags.input.bicep" %}}
{{< /highlight >}}

**Details on child, extension and cross-referenced resources:**

- Tags **MUST** be automatically applied to child, extension and cross-referenced resources, if tags are applied to the primary resource.
  - By default, all tags set for the primary resource will automatically be passed down to child, extension and cross-referenced resources.
  - This **MUST** be able to be overridden by the module consumer so they can specify alternate tags for child, extension and cross-referenced resources, if they desire via a parameter/variable
    - If overridden by the module consumer, no merge/union of tags will take place from the primary resource and only the tags specified for the child, extension and cross-referenced resources will be applied

## Managed Identities

{{< tabs title="" >}}
{{% tab title="Variant 1: Both user- & system-assigned identities supported" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.mi.udt.schema1.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.mi.input1.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Variant 2: Only system-assigned identities supported" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.mi.udt.schema2.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.mi.input2.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Variant 3: Only user-assigned identities supported" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.mi.udt.schema3.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.mi.input3.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{< /tabs >}}

**Reason for differences in User Assigned data type in languages:**

- We do not foresee the Managed Identity Resource Provider team to ever add additional properties within the empty object (`{}`) value required on the input of a User Assigned Managed Identity.
- In Bicep we therefore have removed the need for this to be declared and just converted it to a simple array of Resource IDs

## Private Endpoints

{{< tabs title="Private Endpoints" >}}
{{% tab title="Variant 1: The default service (`groupId`) can be assumed" %}}

  E.g., for services that only have one private endpoint type.

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.pe.udt.schema1.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.pe.input1.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Variant 2: The default service (`groupId`) cannot be assumed" %}}

  E.g., for services that have more than one private endpoint type, like a Storage Account (blob, file, etc.)

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.pe.udt.schema2.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.pe.input2.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{< /tabs >}}

**Notes:**

- The properties defined in the schema above are the minimum amount of properties expected to be exposed for Private Endpoints in AVM Resource Modules.
  - A module owner **MAY** chose to expose additional properties of the Private Endpoint resource
    - However, module owners considering this **SHOULD** contact the AVM core team first to consult on how the property should be exposed to avoid future breaking changes to the schema that may be enforced upon them
- Module owners **MAY** chose to define a list of allowed value for the 'service' (a.k.a. `groupIds`) property
  - However, they should do so with caution as should a new service appear for their resource module, a new release will need to be cut to add this new service to the allowed values
    - Whereas not specifying allowed values will allow flexibility from day 0 without the need for any changes and releases to be made

## Customer Managed Keys

{{< tabs title="Customer Managed Keys" >}}
{{% tab title="Variant 1: For CMK configurations not supporting auto-key-rotation" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.cmk.udt.schema1.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.cmk.input1.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Variant 2: For CMK configurations supporting auto-key-rotation" %}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
    {{% include file="/static/includes/interfaces/bicep/int.cmk.udt.schema2.bicep" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/bicep/int.cmk.input2.bicep" %}}
  {{< /highlight >}}

{{% /tab %}}
{{< /tabs >}}

## Secrets export

Secrets used inside a module can be exported to a Key Vault reference provided as per the below schema.
This implementation provides a secure way around the current limitation of Bicep on providing a secure template output (that can be used for secrets).

The user **MUST**

- provide the resource Id to a Key Vault. The principal used for the deployment **MUST** be allowed to set secrets in this Key Vault.
- provide a name for each secret they want to store (opt-in). The module will suggest which secrets are available via the implemented user-defined type.

The module returns an output table where the key is the name of the secret the user provided, and the value contains both the secret's resource Id and URI.

{{% notice style="important" %}}

The feature **MUST** be implemented as per the below schema. Diversions are only allowed in places marked as `>text<` to ensure a consistent user experience across modules.

{{% /notice %}}

### User Defined Type, Parameter & Resource Example

{{< highlight lineNos="false" type="bicep" wrap="true" title="User Defined Type, Parameter & Resource Example" >}}
  {{% include file="/static/includes/interfaces/bicep/int.secExp.udt.schema.bicep" %}}
{{< /highlight >}}

### Input Example with Values

{{< highlight lineNos="false" type="bicep" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/bicep/int.secExp.udt.schema.bicep" %}}
{{< /highlight >}}

### [modules/keyVaultExport.bicep] file

{{< highlight lineNos="false" type="bicep" wrap="true" title="[modules/keyVaultExport.bicep] file" >}}
  {{% include file="/static/includes/interfaces/bicep/int.secExp.module.bicep" %}}
{{< /highlight >}}

### Output Usage Example

When using a module that implements the above interface, you can access its outputs for example in the following ways:
{{< highlight lineNos="false" type="bicep" wrap="true" title="Output Usage Example" >}}
  {{% include file="/static/includes/interfaces/bicep/int.secExp.udt.schema.bicep" %}}
{{< /highlight >}}

Which returns a JSON-formatted output like:

{{< highlight lineNos="false" type="bicep" wrap="true" title="Output Usage Example" >}}
  {{% include file="/static/includes/interfaces/bicep/int.secExp.output.jsonFmt.json" %}}
{{< /highlight >}}

## Azure Monitor Alerts

{{% notice style="note" %}}

This interface is a **SHOULD** instead of a **MUST** and therefore the AVM core team have not mandated a interface schema to use.

{{% /notice %}}
