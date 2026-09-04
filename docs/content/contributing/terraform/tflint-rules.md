---
title: AVM TFLint Rules
linktitle: TFLint Rules
description: AVM custom TFLint rules, their applicability, and supported overrides
weight: 6
---

This reference covers the custom [AVM TFLint ruleset](https://github.com/Azure/tflint-ruleset-avm) rules. It does not repeat rules provided by the standard Terraform TFLint plugin. AVM rules are enabled by default. An override is an exception to an AVM requirement and should be narrow, temporary where possible, and explained in the override file.

## Rule applicability and overrides

Rules run in the scope that contains the applicable Terraform configuration:

- **All module scopes** - the root module, each submodule, and each example independently.
- **Module scopes** - the root module and each submodule independently; examples are excluded.
- **Root module** - the published module root only.

To disable a rule, use the exact HCL shown in the **Disable** column. The configuration files and precedence rules are documented in [TFLint configuration overrides](#tflint-configuration-overrides).

| Rule | Enforces | Scope | Disable |
| --- | --- | --- | --- |
| [avm_azapi_data_response_export_values_required](#avm_azapi_data_response_export_values_required) | AzAPI data sources declare `response_export_values`. | All module scopes | `rule "avm_azapi_data_response_export_values_required" { enabled = false }` |
| [avm_azapi_replace_triggers_refs_valid](#avm_azapi_replace_triggers_refs_valid) | Managed AzAPI resources validate declared replacement-trigger paths. | All module scopes | `rule "avm_azapi_replace_triggers_refs_valid" { enabled = false }` |
| [avm_azapi_resource_tags_required](#avm_azapi_resource_tags_required) | Writable AzAPI resource types expose consumer-settable tags; read-only or unsupported types omit `tags`. | All module scopes | `rule "avm_azapi_resource_tags_required" { enabled = false }` |
| [avm_azapi_response_export_values_required](#avm_azapi_response_export_values_required) | Managed AzAPI resources declare `response_export_values`. | All module scopes | `rule "avm_azapi_response_export_values_required" { enabled = false }` |
| [avm_interface_customer_managed_key](#avm_interface_customer_managed_key) | The customer-managed key interface follows the AVM contract. | All module scopes | `rule "avm_interface_customer_managed_key" { enabled = false }` |
| [avm_interface_lock_deprecated](#avm_interface_lock_deprecated) | Deprecated lock-interface shapes are not introduced. | All module scopes | `rule "avm_interface_lock_deprecated" { enabled = false }` |
| [avm_interface_private_endpoints_deprecated](#avm_interface_private_endpoints_deprecated) | Deprecated private-endpoint interface shapes are not introduced. | All module scopes | `rule "avm_interface_private_endpoints_deprecated" { enabled = false }` |
| [avm_interface_role_assignments_deprecated](#avm_interface_role_assignments_deprecated) | Deprecated role-assignment interface shapes are not introduced. | All module scopes | `rule "avm_interface_role_assignments_deprecated" { enabled = false }` |
| [avm_interface_diagnostic_settings](#avm_interface_diagnostic_settings) | The diagnostic-settings interface follows the AVM contract. | All module scopes | `rule "avm_interface_diagnostic_settings" { enabled = false }` |
| [avm_interface_ignore_body_changes](#avm_interface_ignore_body_changes) | Applicable AzAPI resources expose and apply `ignore_body_changes`. | All module scopes | `rule "avm_interface_ignore_body_changes" { enabled = false }` |
| [avm_interface_location](#avm_interface_location) | The location interface follows the AVM contract. | All module scopes | `rule "avm_interface_location" { enabled = false }` |
| [avm_interface_lock](#avm_interface_lock) | The lock interface follows the AVM contract. | All module scopes | `rule "avm_interface_lock" { enabled = false }` |
| [avm_interface_managed_identities](#avm_interface_managed_identities) | The managed-identities interface follows the AVM contract. | All module scopes | `rule "avm_interface_managed_identities" { enabled = false }` |
| [avm_output_entire_resource_disallowed](#avm_output_entire_resource_disallowed) | Outputs do not expose an entire provider resource. | Module scopes | `rule "avm_output_entire_resource_disallowed" { enabled = false }` |
| [avm_interface_private_endpoints](#avm_interface_private_endpoints) | The private-endpoints interface follows the AVM contract. | All module scopes | `rule "avm_interface_private_endpoints" { enabled = false }` |
| [avm_interface_private_endpoints_manage_dns_zone_group](#avm_interface_private_endpoints_manage_dns_zone_group) | Private-endpoint DNS-zone-group management follows the AVM contract. | All module scopes | `rule "avm_interface_private_endpoints_manage_dns_zone_group" { enabled = false }` |
| [avm_provider_azapi_version_constraint](#avm_provider_azapi_version_constraint) | The AzAPI provider constraint meets AVM requirements. | Module scopes | `rule "avm_provider_azapi_version_constraint" { enabled = false }` |
| [avm_provider_azurerm_disallowed](#avm_provider_azurerm_disallowed) | AzureRM is not used as a module foundation. | Module scopes | `rule "avm_provider_azurerm_disallowed" { enabled = false }` |
| [avm_provider_azurerm_version_constraint](#avm_provider_azurerm_version_constraint) | An approved AzureRM exception has the required constraint. | Module scopes | `rule "avm_provider_azurerm_version_constraint" { enabled = false }` |
| [avm_provider_modtm_version_constraint](#avm_provider_modtm_version_constraint) | The ModTM provider constraint meets AVM requirements. | Module scopes | `rule "avm_provider_modtm_version_constraint" { enabled = false }` |
| [avm_terraform_module_source_required](#avm_terraform_module_source_required) | AVM module references use the required source format. | Module scopes | `rule "avm_terraform_module_source_required" { enabled = false }` |
| [avm_terraform_ignore_changes_unquoted_references](#avm_terraform_ignore_changes_unquoted_references) | `ignore_changes` uses AVM-compliant references. | All module scopes | `rule "avm_terraform_ignore_changes_unquoted_references" { enabled = false }` |
| [avm_output_resource_id_required](#avm_output_resource_id_required) | Resource modules expose their required outputs. | Root module | `rule "avm_output_resource_id_required" { enabled = false }` |
| [avm_interface_resource_tags](#avm_interface_resource_tags) | An exposed `resource_tags` interface uses the typed recursive replacement contract. | All module scopes | `rule "avm_interface_resource_tags" { enabled = false }` |
| [avm_interface_resource_types](#avm_interface_resource_types) | Applicable AzAPI resources use the `resource_types` interface. | All module scopes | `rule "avm_interface_resource_types" { enabled = false }` |
| [avm_interface_retry](#avm_interface_retry) | Applicable AzAPI resources expose and apply `retry`. | All module scopes | `rule "avm_interface_retry" { enabled = false }` |
| [avm_interface_role_assignments](#avm_interface_role_assignments) | The role-assignments interface follows the AVM contract. | All module scopes | `rule "avm_interface_role_assignments" { enabled = false }` |
| [avm_interface_tags](#avm_interface_tags) | The standard tags interface follows the AVM contract. | All module scopes | `rule "avm_interface_tags" { enabled = false }` |
| [avm_terraform_literal_heredoc_disallowed](#avm_terraform_literal_heredoc_disallowed) | JSON and YAML are encoded with `jsonencode` or `yamlencode`, not literal heredocs. | All module scopes | `rule "avm_terraform_literal_heredoc_disallowed" { enabled = false }` |
| [avm_terraform_provider_block_disallowed](#avm_terraform_provider_block_disallowed) | Modules reject provider blocks and declare aliases with `configuration_aliases`. | Module scopes | `rule "avm_terraform_provider_block_disallowed" { enabled = false }` |
| [avm_terraform_sensitive_variable_default_disallowed](#avm_terraform_sensitive_variable_default_disallowed) | Sensitive variables have no non-empty default. | All module scopes | `rule "avm_terraform_sensitive_variable_default_disallowed" { enabled = false }` |
| [avm_terraform_configuration_file_required](#avm_terraform_configuration_file_required) | Each module has exactly one `terraform` block in `terraform.tf`. | Module scopes | `rule "avm_terraform_configuration_file_required" { enabled = false }` |
| [avm_interface_timeouts](#avm_interface_timeouts) | Applicable AzAPI resources expose and apply `timeouts`. | All module scopes | `rule "avm_interface_timeouts" { enabled = false }` |

## Per-rule severity

Version 1.0.0 of the AVM plugin supports an optional `severity` input on every AVM `rule` block. The exact supported values are `error`, `warning`, and `notice`. When `severity` is omitted, the rule keeps its default severity.

```hcl
rule "avm_interface_resource_types" {
  enabled  = true
  severity = "notice"
}
```

This setting is specific to rules provided by the AVM plugin and changes the severity emitted by that rule. It is separate from TFLint's global [`--minimum-failure-severity`](https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md#minimum-failure-severity) option, which sets the failure threshold for the TFLint process rather than configuring an individual rule's severity.

## Breaking change in v1.0.0: rule names

[AVM TFLint ruleset v1.0.0](https://github.com/Azure/tflint-ruleset-avm/releases/tag/v1.0.0), released through [ruleset PR #159](https://github.com/Azure/tflint-ruleset-avm/pull/159), renamed all rules to canonical `avm_*` names without compatibility aliases. Update the label of every affected TFLint `rule` block in `.tflint.hcl` and AVM override files:

| Old name | New canonical name |
| --- | --- |
| `azapi_data_response_export_values` | `avm_azapi_data_response_export_values_required` |
| `azapi_replace_triggers_refs` | `avm_azapi_replace_triggers_refs_valid` |
| `azapi_resource_tag` | `avm_azapi_resource_tags_required` |
| `azapi_response_export_values` | `avm_azapi_response_export_values_required` |
| `customer_managed_key` | `avm_interface_customer_managed_key` |
| `deprecated_lock_interface` | `avm_interface_lock_deprecated` |
| `deprecated_private_endpoints_interface` | `avm_interface_private_endpoints_deprecated` |
| `deprecated_role_assignments_interface` | `avm_interface_role_assignments_deprecated` |
| `diagnostic_settings` | `avm_interface_diagnostic_settings` |
| `ignore_body_changes` | `avm_interface_ignore_body_changes` |
| `location` | `avm_interface_location` |
| `lock` | `avm_interface_lock` |
| `managed_identities` | `avm_interface_managed_identities` |
| `no_entire_resource_output_tffr2` | `avm_output_entire_resource_disallowed` |
| `private_endpoints` | `avm_interface_private_endpoints` |
| `private_endpoints_manage_dns_zone_group` | `avm_interface_private_endpoints_manage_dns_zone_group` |
| `provider_azapi_version_constraint` | `avm_provider_azapi_version_constraint` |
| `provider_azurerm_disallowed` | `avm_provider_azurerm_disallowed` |
| `provider_azurerm_version_constraint` | `avm_provider_azurerm_version_constraint` |
| `provider_modtm_version_constraint` | `avm_provider_modtm_version_constraint` |
| `required_module_source_tffr1` | `avm_terraform_module_source_required` |
| `required_module_source_tfnfr10` | `avm_terraform_ignore_changes_unquoted_references` |
| `required_output_rmfr7` | `avm_output_resource_id_required` |
| `resource_types` | `avm_interface_resource_types` |
| `retry` | `avm_interface_retry` |
| `role_assignments` | `avm_interface_role_assignments` |
| `tags` | `avm_interface_tags` |
| `terraform_heredoc_usage` | `avm_terraform_literal_heredoc_disallowed` |
| `terraform_module_provider_declaration` | `avm_terraform_provider_block_disallowed` |
| `terraform_sensitive_variable_no_default` | `avm_terraform_sensitive_variable_default_disallowed` |
| `terraform_tf_file` | `avm_terraform_configuration_file_required` |
| `timeouts` | `avm_interface_timeouts` |

These renames apply only to TFLint rule identifiers. Terraform input variable names such as `ignore_body_changes`, `resource_types`, `retry`, and `timeouts` are unchanged.

## Rule guidance

### avm_azapi_data_response_export_values_required

Applies [TFFR4]({{% siteparam base %}}/spec/TFFR4) to AzAPI data sources: declare `response_export_values`, including `[]` when no response fields are needed.

### avm_azapi_replace_triggers_refs_valid

Applies [TFFR5]({{% siteparam base %}}/spec/TFFR5). Omit `replace_triggers_refs` when no body paths require replacement. When present, it must be a non-empty static list of valid JMESPath expressions that identify body paths requiring replacement. Entries cannot be blank or duplicated, and cannot include `name` or `location`, because AzAPI already replaces the resource when either changes. When the body is statically evaluable, the rule verifies that each declared path resolves against it.

Authors remain responsible for identifying the properties that actually require replacement. Current Bicep-generated schemas do not reliably preserve create-only versus updateable mutability, so this rule validates declared paths but cannot prove that the list is semantically complete.

### avm_azapi_resource_tags_required

Applies [TFFR9]({{% siteparam base %}}/spec/TFFR9): types with writable tags in the embedded AVM-generated capability snapshot must set `tags` from a consumer-settable expression. A direct `tags = var.tags` assignment remains valid, and modules can use the typed `resource_tags` replacement interface documented by the [standard tags interface]({{% siteparam base %}}/specs/tf/interfaces/#tags). Types with read-only or unsupported tags must omit the argument. The rule does not require one exact tags expression and skips dynamic or otherwise unevaluable type expressions.

The ruleset embeds its AVM-generated capability snapshot and works standalone. It does not consume, import, or query AzAPI, and does not accept an external snapshot path.

A weekly ruleset workflow compares the embedded snapshot with upstream data and opens a ruleset pull request when that data changes. Updated capability data ships with the next ruleset release. All users receive snapshot updates by upgrading the ruleset release.

### avm_azapi_response_export_values_required

Applies [TFFR4]({{% siteparam base %}}/spec/TFFR4): every applicable managed AzAPI resource declares `response_export_values`, including `[]` when no fields are exported.

### avm_interface_customer_managed_key

Validates the [customer-managed key interface]({{% siteparam base %}}/specs/tf/interfaces/#customer-managed-keys).

### avm_interface_lock_deprecated

Prevents new use of deprecated shapes in the [resource-lock interface]({{% siteparam base %}}/specs/tf/interfaces/#resource-locks).

### avm_interface_private_endpoints_deprecated

Prevents new use of deprecated shapes in the [private-endpoints interface]({{% siteparam base %}}/specs/tf/interfaces/#private-endpoints).

### avm_interface_role_assignments_deprecated

Prevents new use of deprecated shapes in the [role-assignments interface]({{% siteparam base %}}/specs/tf/interfaces/#role-assignments).

### avm_interface_diagnostic_settings

Validates the [diagnostic-settings interface]({{% siteparam base %}}/specs/tf/interfaces/#diagnostic-settings).

### avm_interface_ignore_body_changes

Validates the [AzAPI `ignore_body_changes` interface]({{% siteparam base %}}/spec/TFFR8), including its per-resource and per-submodule applicability.

### avm_interface_location

Validates the standard [location interface]({{% siteparam base %}}/specs/tf/interfaces/#location).

### avm_interface_lock

Validates the [resource-lock interface]({{% siteparam base %}}/specs/tf/interfaces/#resource-locks).

### avm_interface_managed_identities

Validates the [managed-identities interface]({{% siteparam base %}}/specs/tf/interfaces/#managed-identities).

### avm_output_entire_resource_disallowed

Applies [TFFR2]({{% siteparam base %}}/spec/TFFR2): output explicit values instead of an entire provider resource.

### avm_interface_private_endpoints

Validates the [private-endpoints interface]({{% siteparam base %}}/specs/tf/interfaces/#private-endpoints).

### avm_interface_private_endpoints_manage_dns_zone_group

Validates the DNS-zone-group behavior of the [private-endpoints interface]({{% siteparam base %}}/specs/tf/interfaces/#private-endpoints).

### avm_provider_azapi_version_constraint

Validates the AzAPI constraint required by [TFFR3]({{% siteparam base %}}/spec/TFFR3).

### avm_provider_azurerm_disallowed

Applies the AzureRM-foundation prohibition in [TFFR3]({{% siteparam base %}}/spec/TFFR3).

### avm_provider_azurerm_version_constraint

Validates the AzureRM constraint when the narrow [TFFR3]({{% siteparam base %}}/spec/TFFR3) exception is used.

### avm_provider_modtm_version_constraint

Validates the ModTM provider constraint when that provider is used.

### avm_terraform_module_source_required

Applies [TFFR1]({{% siteparam base %}}/spec/TFFR1) to AVM module sources.

### avm_terraform_ignore_changes_unquoted_references

Applies [TFNFR10]({{% siteparam base %}}/spec/TFNFR10) to `ignore_changes` references.

### avm_output_resource_id_required

Applies the required-output contract in [RMFR7]({{% siteparam base %}}/spec/RMFR7).

### avm_interface_resource_tags

Validates the optional `resource_tags` variable when it is declared. The variable must default to `null` and permit null values. Its type must use one or both non-empty, optional `resources` and `modules` namespaces without inline defaults. Resource labels must be optional `map(string)` leaves, module labels must be optional objects that recursively use the same shape, and the complete type must contain at least one resource leaf. The separate namespaces identify Terraform resource and module block labels without collisions.

### avm_interface_resource_types

Validates the [AzAPI `resource_types` interface]({{% siteparam base %}}/spec/TFFR6), including its deterministic resource-type keys and cascading shape.

### avm_interface_retry

Validates the [AzAPI `retry` interface]({{% siteparam base %}}/spec/TFFR7).

### avm_interface_role_assignments

Validates the [role-assignments interface]({{% siteparam base %}}/specs/tf/interfaces/#role-assignments).

### avm_interface_tags

Validates the [tags interface]({{% siteparam base %}}/specs/tf/interfaces/#tags). The backward-compatible `tags` fallback remains a nullable `map(string)`. When a module exposes `resource_tags`, its deterministic typed `resources` and `modules` namespaces provide complete per-resource replacements without merging.

### avm_terraform_literal_heredoc_disallowed

Applies [TFNFR40]({{% siteparam base %}}/spec/TFNFR40): represent JSON or YAML structured values with `jsonencode` or `yamlencode`.

### avm_terraform_provider_block_disallowed

Applies [TFNFR27]({{% siteparam base %}}/spec/TFNFR27): a published module contains no `provider` blocks; aliases are declared only through `configuration_aliases` and configured by its consumer.

### avm_terraform_sensitive_variable_default_disallowed

Applies [TFNFR23]({{% siteparam base %}}/spec/TFNFR23): a sensitive variable may default only to an empty collection.

### avm_terraform_configuration_file_required

Applies [TFNFR39]({{% siteparam base %}}/spec/TFNFR39): a module has exactly one `terraform` block and it is in `terraform.tf`.

### avm_interface_timeouts

Validates the [AzAPI `timeouts` interface]({{% siteparam base %}}/spec/TFFR7).

## MAPOTF and standard Terraform TFLint coverage

MAPOTF, not a custom AVM TFLint rule, owns formatting and deterministic ordering for [resource and data blocks]({{% siteparam base %}}/spec/TFNFR8), [variables]({{% siteparam base %}}/spec/TFNFR15), [outputs]({{% siteparam base %}}/spec/TFNFR41), [required providers]({{% siteparam base %}}/spec/TFNFR26), and [file placement]({{% siteparam base %}}/spec/TFNFR39). It also removes redundant explicit `nullable = true`; that cleanup does not replace the semantic requirements for `nullable = false` in [TFNFR20]({{% siteparam base %}}/spec/TFNFR20) and [TFNFR21]({{% siteparam base %}}/spec/TFNFR21).

The standard Terraform TFLint plugin validates `required_version` and provider requirement declarations. [TFNFR25]({{% siteparam base %}}/spec/TFNFR25) and [TFNFR26]({{% siteparam base %}}/spec/TFNFR26) explain the complementary AVM file-layout and ordering requirements.

## TFLint configuration overrides

`Avm.Authoring` loads the following repository-root override files:

| File | Default scope |
| --- | --- |
| `avm.tflint.override.hcl` | All root-module checks |
| `avm.tflint_module.override.hcl` | All submodule checks |
| `avm.tflint_example.override.hcl` | All example checks |
| `modules/<name>/avm.tflint.override.hcl` | One direct submodule |
| `examples/<name>/avm.tflint.override.hcl` | One direct example |

Each file contains normal TFLint rule configuration. For example:

```hcl
rule "avm_terraform_sensitive_variable_default_disallowed" {
  enabled = false
}
```

`Avm.Authoring` merges overrides in this order: the immutable AVM base configuration, the matching repository-root all-scope override, then the target-directory override. A submodule or example override is loaded only for its target directory and takes precedence over the matching all-submodule or all-example file. Use it when an exception is specific to one direct child module or example; do not weaken the corresponding repository-wide default.

AVM permits only one directory layer for Terraform submodule and example roots: `modules/*` and `examples/*`. Nested Terraform module or example roots are prohibited, so target overrides apply only to those direct scopes. `Avm.Authoring` convention validation enforces this structure.
