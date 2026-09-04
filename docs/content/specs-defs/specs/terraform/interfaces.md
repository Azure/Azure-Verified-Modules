---
title: Terraform Interfaces
linktitle: Interfaces
url: /specs/tf/interfaces/
description: Terraform Module Interface Specifications for the Azure Verified Modules (AVM) program
---

This chapter details the interfaces/schemas for the AVM Resource Modules features/extension resources as referenced in [RMFR4]({{% siteparam base %}}/spec/RMFR4) and [RMFR5]({{% siteparam base %}}/spec/RMFR5).

## Diagnostic Settings

{{% notice style="important" %}}

Allowed values for logs and metric categories or category groups **MUST NOT** be specified to keep the module implementation evergreen for any new categories or category groups added by RPs, without module owners having to update a list of allowed values and cut a new release of their module.

{{% /notice %}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.diag.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.diag.input.tf" %}}
{{< /highlight >}}

{{% notice style="note" %}}

In the provided example for Diagnostic Settings, both logs and metrics are enabled for the associated resource. However, it is **IMPORTANT** to note that certain resources may not support both diagnostic setting types/categories. In such cases, the resource configuration **MUST** be modified accordingly to ensure proper functionality and compliance with system requirements.

{{% /notice %}}

## Role Assignments

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.rbac.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.rbac.input.tf" %}}
{{< /highlight >}}

**Details on child, extension and cross-referenced resources:**

- Modules **MUST** support Role Assignments on child, extension and cross-referenced resources as well as the primary resource via parameters/variables
- The `name` attribute is optional in both the top-level `role_assignments` interface and `private_endpoints[*].role_assignments`. Omitting it remains valid and backward compatible; a random UUID is generated when no name is supplied.
- During migration, tooling **MAY** temporarily accept the older exact type declaration without the `name` attribute. New and updated modules **SHOULD** use the canonical schema, including `name = optional(string, null)`.

## Resource Locks

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.locks.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.locks.input.tf" %}}
{{< /highlight >}}

**Details on child and extension resources:**

- Locks **SHOULD** be able to be set for child resources of the primary resource in resource modules

**Details on cross-referenced resources:**

- Locks **MUST** be automatically applied to cross-referenced resources if the primary resource has a lock applied.
  - This **MUST** also be able to be turned off for each of the cross-referenced resources by the module consumer via a parameter/variable if they desire

An example of this is a Key Vault module that has a Private Endpoints enabled. If a lock is applied to the Key Vault via the `lock` parameter/variable then the lock should also be applied to the Private Endpoint automatically, unless the `privateEndpointLock/private_endpoint_lock` (example name) parameter/variable is set to `None`

{{% notice style="important" %}}

In Terraform, locks become part of the resource graph and suitable `depends_on` values should be set. Note that, during a `destroy` operation, Terraform will remove the locks before removing the resource itself, reducing the usefulness of the lock somewhat. Also note, due to eventual consistency in Azure, use of locks can cause destroy operations to fail as the lock may not have been fully removed by the time the destroy operation is executed.

{{% /notice %}}

## Tags

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.tags.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.tags.input.tf" %}}
{{< /highlight >}}

The `tags` variable is the module-wide fallback and common interface. It **MUST** remain a `map(string)` with a default of `null`. A module that does not expose per-resource overrides can continue to assign `tags = var.tags` directly.

Modules **MAY** add the typed `resource_tags` variable when consumers need to replace tags for individual resources or resources declared by submodules. The variable **MUST** default to `null` and use this canonical shape:

- `resources` is an optional object whose attribute names match Terraform resource block labels in the current module.
- `modules` is an optional object whose attribute names match Terraform module block labels. Each value repeats that submodule's typed `resource_tags` shape.
- The `resources` and `modules` namespaces keep identical resource and module labels unambiguous. For example, `resource_tags.resources.child` and `resource_tags.modules.child` identify different blocks.
- Each module **MUST** declare a deterministic object type containing only its supported resource and submodule labels. Open-ended maps of objects or `any` types **MUST NOT** replace the typed shape.
- Every namespace, resource label, and module label **MUST** be optional without an inline default. The object **MUST** contain at least one resource label, either directly or below a module label.

For every tag-capable resource, an omitted or `null` resource override inherits `var.tags`. A supplied map replaces `var.tags` completely for that resource; implementations **MUST NOT** merge the two maps. An empty map therefore deliberately applies no tags. A resource block override applies uniformly to every instance created from that block with `count` or `for_each`. This expression implements the required precedence for a resource labeled `this`:

```terraform
resource "azapi_resource" "this" {
  tags = try(var.resource_tags.resources.this, null) != null ? var.resource_tags.resources.this : var.tags
}
```

Tags **MUST** propagate by default to tag-capable child, extension, and cross-referenced resources. A parent module passes the fallback and the nested override independently:

```terraform
module "child" {
  source = "./modules/child"

  tags          = var.tags
  resource_tags = try(var.resource_tags.modules.child, null)
}
```

The child module applies the same precedence to its own resource labels. Omitting `resource_tags.modules.child`, or setting it to `null`, leaves every child resource on the `tags` fallback unless a more specific non-null override is supplied.

## Managed Identities

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.mi.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.mi.input.tf" %}}
{{< /highlight >}}

**Reason for differences in User Assigned data type in languages:**

- We do not forsee the Managed Identity Resource Provider team to ever add additional properties within the empty object (`{}`) value required on the input of a User Assigned Managed Identity.
- In Bicep we therefore have removed the need for this to be declared and just converted it to a simple array of Resource IDs
- However, in Terraform we have left it as a object/map as this simplifies `for_each` and other loop mechanisms and provides more consistency in plan, apply, destroy operations
  - Especially when adding, removing or changing the order of the User Assigned Managed Identities as they are declared

## Private Endpoints

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.pe.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.pe.input.tf" %}}
{{< /highlight >}}

**Notes:**

- The properties defined in the schema above are the minimum amount of properties expected to be exposed for Private Endpoints in AVM Resource Modules.
  - A module owner **MAY** chose to expose additional properties of the Private Endpoint resource.
    - However, module owners considering this **SHOULD** contact the AVM core team first to consult on how the property should be exposed to avoid future breaking changes to the schema that may be enforced upon them.
- Module owners **MAY** chose to define a list of allowed value for the 'service' (a.k.a. `groupIds`) property.
  - However, they should do so with caution as should a new service appear for their resource module, a new release will need to be cut to add this new service to the allowed values.
    - Whereas not specifying allowed values will allow flexibility from day 0 without the need for any changes and releases to be made.

## Customer Managed Keys

A module **MUST** implement exactly one of the two variants below. Which one applies is determined by the resource provider's API, not by module owner preference. Linting accepts either shape.

{{< tabs title="Customer Managed Keys" >}}
{{% tab title="Variant 1: For providers that identify the encryption identity by resource ID" %}}

  {{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
    {{% include file="/static/includes/interfaces/tf/int.cmk.schema1.tf" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/tf/int.cmk.input1.tf" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="terraform" wrap="true" title="Module Implementation Example" >}}
    {{% include file="/static/includes/interfaces/tf/int.cmk.usage1.tf" %}}
  {{< /highlight >}}

{{% /tab %}}
{{% tab title="Variant 2: For providers that require the encryption identity client ID" %}}

  {{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
    {{% include file="/static/includes/interfaces/tf/int.cmk.schema2.tf" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
    {{% include file="/static/includes/interfaces/tf/int.cmk.input2.tf" %}}
  {{< /highlight >}}

  {{< highlight lineNos="false" type="terraform" wrap="true" title="Module Implementation Example" >}}
    {{% include file="/static/includes/interfaces/tf/int.cmk.usage2.tf" %}}
  {{< /highlight >}}

{{% /tab %}}
{{< /tabs >}}

**Notes:**

- Modules **MUST NOT** use a data source to resolve the key URI or the encryption identity's client ID.
  - Terraform reads a data source during `plan` whenever its arguments are already known. A key or identity lookup whose arguments are known literals can therefore run before a resource created by the same `terraform apply` exists, causing the plan to fail.
  - A module **MAY** read the Key Vault itself by `key_vault_resource_id`, because that argument is unknown at plan time whenever the vault is created by the same apply, which defers the read to apply time.
- Variant 1 **MUST** be used where the resource provider takes the vault URI, the key name and the key version as separate fields, and identifies the encryption identity by resource ID, such as `Microsoft.Storage/storageAccounts`.
  - Omitting `key_version` **MUST** leave the resource provider following key rotations automatically.
  - Where the resource provider requires a versioned key, such as `Microsoft.Compute/diskEncryptionSets`, the module **MUST** validate that `key_version` has been supplied.
- Variant 2 **MUST** be used where the resource provider requires the encryption identity's client ID, such as `Microsoft.ContainerRegistry/registries`, because a client ID cannot be resolved from an identity resource ID without a data source.
  - `key_vault_key_uri` carries the entire key identifier, so the consumer owns the host. The same input shape therefore works unchanged in sovereign clouds and against Managed HSM, and the module **MUST NOT** construct a DNS suffix of its own.
  - Omitting the trailing version segment **MUST** leave the resource provider following key rotations automatically.
  - Consumers **SHOULD** build `key_vault_key_uri` from the key resource they own, rather than from a data source, so that the value stays known at plan time.
  - Variant 2 deliberately carries no vault resource ID and no identity resource ID. A module **MUST NOT** require either, and **MUST NOT** attempt to cross-check the identity against `managed_identities`.
- Modules **MUST** validate that whichever identity value their resource provider requires has been supplied, and **SHOULD** do so with a `precondition` so that the error names the missing attribute.
- Where the resource provider also requires the identity to be assigned to the primary resource, modules **MUST** document that the consumer supplies the same identity through `managed_identities.user_assigned_resource_ids`.

## Azure Monitor Alerts

{{% notice style="note" %}}

This interface is a **SHOULD** instead of a **MUST** and therefore the AVM core team have not mandated a interface schema to use.

{{% /notice %}}

## AzAPI resource types

{{% notice style="important" %}}

Each `resource_types` key **MUST** be the snake_case form of the ARM resource type with the `Microsoft.` prefix dropped (for example `Microsoft.Example/widgets/parts` \u2192 `example_widgets_parts`). Each module **MUST** declare one `optional(string, "...")` field per `azapi_resource` (or equivalent AzAPI resource) it owns, defaulting each field to the latest tested API version. See [TFFR6]({{% siteparam base %}}/spec/TFFR6).

{{% /notice %}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.resource_types.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.resource_types.input.tf" %}}
{{< /highlight >}}

**Notes:**

- `resource_types` keys name the AzAPI resource type and are derived deterministically from the ARM type. They are independent of the Terraform resource label (see [TFRMNFR2]({{% siteparam base %}}/spec/TFRMNFR2)) \u2014 `this` is never a valid `resource_types` key.
- Submodules **MUST** declare their own `resource_types` variable using the same naming rule for the resources they own. The parent **MUST** declare one nested `optional(object({...}), {})` slot per submodule it instantiates, shaped exactly like that submodule's variable, and **MUST** cascade the slot through unchanged (see [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)). The parent **MUST NOT** repeat the submodule's defaults \u2014 the submodule remains the source of truth for its own tested API versions.
- Defaults **MUST** be a stable (non-preview) API version unless the module's primary resource only ships a preview API.

## AzAPI retry

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.retry.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.retry.input.tf" %}}
{{< /highlight >}}

**Notes:**

- The `retry` variable **MUST** be applied to every `azapi_resource` (and equivalent AzAPI resources) declared by the module.
- Parent modules **MUST** cascade `retry` to each submodule they instantiate (see [TFFR7]({{% siteparam base %}}/spec/TFFR7) and [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)).
- Module owners **MAY** ship module-level defaults when the resource it manages benefits from them. To do so, set the variable's overall `default` to `{}` (not `null`) and provide per-field defaults inside the `optional(...)` wrappers. Consumers **MUST** still be able to override any individual field.

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration with Module-level Defaults" >}}
  {{% include file="/static/includes/interfaces/tf/int.retry.defaults.tf" %}}
{{< /highlight >}}

## AzAPI timeouts

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.timeouts.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.timeouts.input.tf" %}}
{{< /highlight >}}

**Notes:**

- `timeouts` is a **block** on `azapi_resource` (not an attribute), so a `dynamic "timeouts"` block is required to honor the variable's `null` default.
- The `timeouts` variable **MUST** be applied to every `azapi_resource` (and equivalent AzAPI resources) declared by the module.
- Parent modules **MUST** cascade `timeouts` to each submodule they instantiate (see [TFFR7]({{% siteparam base %}}/spec/TFFR7) and [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)). Submodules **MAY** additionally expose per-item overrides for cases where individual resources need different settings.
- Module owners **MAY** ship module-level defaults when the resource it manages benefits from them (for example, longer create / delete timeouts for slow-provisioning resources). To do so, set the variable's overall `default` to `{}` (not `null`) and provide per-field defaults inside the `optional(...)` wrappers. Consumers **MUST** still be able to override any individual field.

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration with Module-level Defaults" >}}
  {{% include file="/static/includes/interfaces/tf/int.timeouts.defaults.tf" %}}
{{< /highlight >}}

## AzAPI ignore_body_changes

{{% notice style="important" %}}

`ignore_body_changes` is a **write-only** argument that requires the `Azure/azapi` provider v2.12.0 or later, and Terraform 1.11 or later when a non-empty value is supplied. See [TFFR8]({{% siteparam base %}}/spec/TFFR8).

{{% /notice %}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Variable Declaration" >}}
  {{% include file="/static/includes/interfaces/tf/int.ignore_body_changes.schema.tf" %}}
{{< /highlight >}}

{{< highlight lineNos="false" type="terraform" wrap="true" title="Input Example with Values" >}}
  {{% include file="/static/includes/interfaces/tf/int.ignore_body_changes.input.tf" %}}
{{< /highlight >}}

**Notes:**

- Unlike `retry` and `timeouts`, `ignore_body_changes` values are dot-notation paths into **one specific resource's** `body`, so the variable **MUST NOT** be cascaded to submodules unchanged. It uses the same per-resource, per-submodule shape and key-naming rule as `resource_types` (see [TFFR6]({{% siteparam base %}}/spec/TFFR6)).
- The `ignore_body_changes` variable **MUST** be applied to every `azapi_resource` (and equivalent AzAPI resources) declared by the module, and every submodule **MUST** declare its own (see [TFFR8]({{% siteparam base %}}/spec/TFFR8) and [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)).
- The assignment **MUST** collapse an empty list to `null` so that the write-only argument is absent when the feature is unused, keeping the module usable on Terraform versions earlier than 1.11.
- A change to `ignore_body_changes` only takes effect **after** an apply, because the value is held in provider-private state.
- An ignored path is not merely hidden from the plan — configuration changes at that path are **not sent to Azure** until the path is removed from the list.
- Module owners **MAY** ship module-level defaults where the resource is known to be mutated outside Terraform, by supplying the default inside the `optional(list(string), [...])` wrapper. Consumers **MUST** still be able to override any individual field.
