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
| [azapi_data_response_export_values](#azapi-data-response-export-values) | AzAPI data sources declare `response_export_values`. | All module scopes | `rule "azapi_data_response_export_values" { enabled = false }` |
| [azapi_replace_triggers_refs](#azapi-replace-triggers-refs) | Managed AzAPI resources declare replacement-trigger paths. | All module scopes | `rule "azapi_replace_triggers_refs" { enabled = false }` |
| [azapi_resource_tag](#azapi-resource-tag) | Supported AzAPI resource types apply the standard `tags` input; unsupported types omit `tags`. | All module scopes | `rule "azapi_resource_tag" { enabled = false }` |
| [azapi_response_export_values](#azapi-response-export-values) | Managed AzAPI resources declare `response_export_values`. | All module scopes | `rule "azapi_response_export_values" { enabled = false }` |
| [customer_managed_key](#customer-managed-key) | The customer-managed key interface follows the AVM contract. | All module scopes | `rule "customer_managed_key" { enabled = false }` |
| [deprecated_lock_interface](#deprecated-lock-interface) | Deprecated lock-interface shapes are not introduced. | All module scopes | `rule "deprecated_lock_interface" { enabled = false }` |
| [deprecated_private_endpoints_interface](#deprecated-private-endpoints-interface) | Deprecated private-endpoint interface shapes are not introduced. | All module scopes | `rule "deprecated_private_endpoints_interface" { enabled = false }` |
| [deprecated_role_assignments_interface](#deprecated-role-assignments-interface) | Deprecated role-assignment interface shapes are not introduced. | All module scopes | `rule "deprecated_role_assignments_interface" { enabled = false }` |
| [diagnostic_settings](#diagnostic-settings) | The diagnostic-settings interface follows the AVM contract. | All module scopes | `rule "diagnostic_settings" { enabled = false }` |
| [ignore_body_changes](#ignore-body-changes) | Applicable AzAPI resources expose and apply `ignore_body_changes`. | All module scopes | `rule "ignore_body_changes" { enabled = false }` |
| [location](#location) | The location interface follows the AVM contract. | All module scopes | `rule "location" { enabled = false }` |
| [lock](#lock) | The lock interface follows the AVM contract. | All module scopes | `rule "lock" { enabled = false }` |
| [managed_identities](#managed-identities) | The managed-identities interface follows the AVM contract. | All module scopes | `rule "managed_identities" { enabled = false }` |
| [no_entire_resource_output_tffr2](#no-entire-resource-output-tffr2) | Outputs do not expose an entire provider resource. | Module scopes | `rule "no_entire_resource_output_tffr2" { enabled = false }` |
| [private_endpoints](#private-endpoints) | The private-endpoints interface follows the AVM contract. | All module scopes | `rule "private_endpoints" { enabled = false }` |
| [private_endpoints_manage_dns_zone_group](#private-endpoints-manage-dns-zone-group) | Private-endpoint DNS-zone-group management follows the AVM contract. | All module scopes | `rule "private_endpoints_manage_dns_zone_group" { enabled = false }` |
| [provider_azapi_version_constraint](#provider-azapi-version-constraint) | The AzAPI provider constraint meets AVM requirements. | Module scopes | `rule "provider_azapi_version_constraint" { enabled = false }` |
| [provider_azurerm_disallowed](#provider-azurerm-disallowed) | AzureRM is not used as a module foundation. | Module scopes | `rule "provider_azurerm_disallowed" { enabled = false }` |
| [provider_azurerm_version_constraint](#provider-azurerm-version-constraint) | An approved AzureRM exception has the required constraint. | Module scopes | `rule "provider_azurerm_version_constraint" { enabled = false }` |
| [provider_modtm_version_constraint](#provider-modtm-version-constraint) | The ModTM provider constraint meets AVM requirements. | Module scopes | `rule "provider_modtm_version_constraint" { enabled = false }` |
| [required_module_source_tffr1](#required-module-source-tffr1) | AVM module references use the required source format. | Module scopes | `rule "required_module_source_tffr1" { enabled = false }` |
| [required_module_source_tfnfr10](#required-module-source-tfnfr10) | `ignore_changes` uses AVM-compliant references. | All module scopes | `rule "required_module_source_tfnfr10" { enabled = false }` |
| [required_output_rmfr7](#required-output-rmfr7) | Resource modules expose their required outputs. | Root module | `rule "required_output_rmfr7" { enabled = false }` |
| [resource_types](#resource-types) | Applicable AzAPI resources use the `resource_types` interface. | All module scopes | `rule "resource_types" { enabled = false }` |
| [retry](#retry) | Applicable AzAPI resources expose and apply `retry`. | All module scopes | `rule "retry" { enabled = false }` |
| [role_assignments](#role-assignments) | The role-assignments interface follows the AVM contract. | All module scopes | `rule "role_assignments" { enabled = false }` |
| [tags](#tags) | The standard tags interface follows the AVM contract. | All module scopes | `rule "tags" { enabled = false }` |
| [terraform_heredoc_usage](#terraform-heredoc-usage) | JSON and YAML are encoded with `jsonencode` or `yamlencode`, not literal heredocs. | All module scopes | `rule "terraform_heredoc_usage" { enabled = false }` |
| [terraform_module_provider_declaration](#terraform-module-provider-declaration) | Modules reject provider blocks and declare aliases with `configuration_aliases`. | Module scopes | `rule "terraform_module_provider_declaration" { enabled = false }` |
| [terraform_sensitive_variable_no_default](#terraform-sensitive-variable-no-default) | Sensitive variables have no non-empty default. | All module scopes | `rule "terraform_sensitive_variable_no_default" { enabled = false }` |
| [terraform_tf_file](#terraform-tf-file) | Each module has exactly one `terraform` block in `terraform.tf`. | Module scopes | `rule "terraform_tf_file" { enabled = false }` |
| [timeouts](#timeouts) | Applicable AzAPI resources expose and apply `timeouts`. | All module scopes | `rule "timeouts" { enabled = false }` |

## Rule guidance

### azapi_data_response_export_values

Applies [TFFR4]({{% siteparam base %}}/spec/TFFR4) to AzAPI data sources: declare `response_export_values`, including `[]` when no response fields are needed.

### azapi_replace_triggers_refs

Applies [TFFR5]({{% siteparam base %}}/spec/TFFR5): declare `replace_triggers_refs` on every applicable managed AzAPI resource, listing body paths that require replacement.

### azapi_resource_tag

Applies [TFFR9]({{% siteparam base %}}/spec/TFFR9): set `tags = var.tags` exactly on types supported by the shared AzAPI embedded-schema capability source, and omit `tags` for unsupported types. The rule skips dynamic or otherwise unevaluable type expressions.

### azapi_response_export_values

Applies [TFFR4]({{% siteparam base %}}/spec/TFFR4): every applicable managed AzAPI resource declares `response_export_values`, including `[]` when no fields are exported.

### customer_managed_key

Validates the [customer-managed key interface]({{% siteparam base %}}/specs/tf/interfaces/#customer-managed-keys).

### deprecated_lock_interface

Prevents new use of deprecated shapes in the [resource-lock interface]({{% siteparam base %}}/specs/tf/interfaces/#resource-locks).

### deprecated_private_endpoints_interface

Prevents new use of deprecated shapes in the [private-endpoints interface]({{% siteparam base %}}/specs/tf/interfaces/#private-endpoints).

### deprecated_role_assignments_interface

Prevents new use of deprecated shapes in the [role-assignments interface]({{% siteparam base %}}/specs/tf/interfaces/#role-assignments).

### diagnostic_settings

Validates the [diagnostic-settings interface]({{% siteparam base %}}/specs/tf/interfaces/#diagnostic-settings).

### ignore_body_changes

Validates the [AzAPI `ignore_body_changes` interface]({{% siteparam base %}}/spec/TFFR8), including its per-resource and per-submodule applicability.

### location

Validates the standard [location interface]({{% siteparam base %}}/specs/tf/interfaces/#location).

### lock

Validates the [resource-lock interface]({{% siteparam base %}}/specs/tf/interfaces/#resource-locks).

### managed_identities

Validates the [managed-identities interface]({{% siteparam base %}}/specs/tf/interfaces/#managed-identities).

### no_entire_resource_output_tffr2

Applies [TFFR2]({{% siteparam base %}}/spec/TFFR2): output explicit values instead of an entire provider resource.

### private_endpoints

Validates the [private-endpoints interface]({{% siteparam base %}}/specs/tf/interfaces/#private-endpoints).

### private_endpoints_manage_dns_zone_group

Validates the DNS-zone-group behavior of the [private-endpoints interface]({{% siteparam base %}}/specs/tf/interfaces/#private-endpoints).

### provider_azapi_version_constraint

Validates the AzAPI constraint required by [TFFR3]({{% siteparam base %}}/spec/TFFR3).

### provider_azurerm_disallowed

Applies the AzureRM-foundation prohibition in [TFFR3]({{% siteparam base %}}/spec/TFFR3).

### provider_azurerm_version_constraint

Validates the AzureRM constraint when the narrow [TFFR3]({{% siteparam base %}}/spec/TFFR3) exception is used.

### provider_modtm_version_constraint

Validates the ModTM provider constraint when that provider is used.

### required_module_source_tffr1

Applies [TFFR1]({{% siteparam base %}}/spec/TFFR1) to AVM module sources.

### required_module_source_tfnfr10

Applies [TFNFR10]({{% siteparam base %}}/spec/TFNFR10) to `ignore_changes` references.

### required_output_rmfr7

Applies the required-output contract in [RMFR7]({{% siteparam base %}}/spec/RMFR7).

### resource_types

Validates the [AzAPI `resource_types` interface]({{% siteparam base %}}/spec/TFFR6), including its deterministic resource-type keys and cascading shape.

### retry

Validates the [AzAPI `retry` interface]({{% siteparam base %}}/spec/TFFR7).

### role_assignments

Validates the [role-assignments interface]({{% siteparam base %}}/specs/tf/interfaces/#role-assignments).

### tags

Validates the [tags interface]({{% siteparam base %}}/specs/tf/interfaces/#tags).

### terraform_heredoc_usage

Applies [TFNFR40]({{% siteparam base %}}/spec/TFNFR40): represent JSON or YAML structured values with `jsonencode` or `yamlencode`.

### terraform_module_provider_declaration

Applies [TFNFR27]({{% siteparam base %}}/spec/TFNFR27): a published module contains no `provider` blocks; aliases are declared only through `configuration_aliases` and configured by its consumer.

### terraform_sensitive_variable_no_default

Applies [TFNFR23]({{% siteparam base %}}/spec/TFNFR23): a sensitive variable may default only to an empty collection.

### terraform_tf_file

Applies [TFNFR39]({{% siteparam base %}}/spec/TFNFR39): a module has exactly one `terraform` block and it is in `terraform.tf`.

### timeouts

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
rule "terraform_sensitive_variable_no_default" {
  enabled = false
}
```

`Avm.Authoring` merges overrides in this order: the immutable AVM base configuration, the matching repository-root all-scope override, then the target-directory override. A submodule or example override is loaded only for its target directory and takes precedence over the matching all-submodule or all-example file. Use it when an exception is specific to one direct child module or example; do not weaken the corresponding repository-wide default.

AVM permits only one directory layer for Terraform submodule and example roots: `modules/*` and `examples/*`. Nested Terraform module or example roots are prohibited, so target overrides apply only to those direct scopes. `Avm.Authoring` convention validation enforces this structure.
