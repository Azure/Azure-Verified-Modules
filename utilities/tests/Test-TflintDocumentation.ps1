[CmdletBinding()]
param(
  [string] $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..'))
)

$ErrorActionPreference = 'Stop'

$guidePath = Join-Path $RepositoryRoot 'docs\content\contributing\terraform\tflint-rules.md'
$guide = Get-Content -Raw $guidePath

$rules = @(
  'avm_azapi_data_response_export_values_required',
  'avm_azapi_replace_triggers_refs_valid',
  'avm_azapi_resource_tags_required',
  'avm_azapi_response_export_values_required',
  'avm_interface_customer_managed_key',
  'avm_interface_lock_deprecated',
  'avm_interface_private_endpoints_deprecated',
  'avm_interface_role_assignments_deprecated',
  'avm_interface_diagnostic_settings',
  'avm_interface_ignore_body_changes',
  'avm_interface_location',
  'avm_interface_lock',
  'avm_interface_managed_identities',
  'avm_output_entire_resource_disallowed',
  'avm_interface_private_endpoints',
  'avm_interface_private_endpoints_manage_dns_zone_group',
  'avm_provider_azapi_version_constraint',
  'avm_provider_azurerm_disallowed',
  'avm_provider_azurerm_version_constraint',
  'avm_provider_modtm_version_constraint',
  'avm_terraform_module_source_required',
  'avm_terraform_ignore_changes_unquoted_references',
  'avm_output_resource_id_required',
  'avm_interface_resource_tags',
  'avm_interface_resource_types',
  'avm_interface_retry',
  'avm_interface_role_assignments',
  'avm_interface_tags',
  'avm_terraform_literal_heredoc_disallowed',
  'avm_terraform_provider_block_disallowed',
  'avm_terraform_sensitive_variable_default_disallowed',
  'avm_terraform_configuration_file_required',
  'avm_interface_timeouts'
)

foreach ($rule in $rules) {
  if ($guide -notmatch [regex]::Escape($rule)) {
    throw "The TFLint guide does not document '$rule'."
  }

  $disableExpression = 'rule "' + $rule + '" { enabled = false }'
  if ($guide -notmatch [regex]::Escape($disableExpression)) {
    throw "The TFLint guide does not provide the exact override for '$rule'."
  }
}

foreach ($spec in @('TFFR9', 'TFNFR40', 'TFNFR41')) {
  $specPath = Join-Path $RepositoryRoot "docs\content\specs-defs\includes\terraform\shared\$(if ($spec -like 'TFFR*') { 'functional' } else { 'non-functional' })\$spec.md"
  if (-not (Test-Path $specPath)) {
    throw "Expected specification '$spec' is missing."
  }
}

$specRuleLinks = @{
  'docs\content\specs-defs\includes\shared\resource\functional\RMFR7.md' = '#avm_output_resource_id_required'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR1.md' = '#avm_terraform_module_source_required'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR2.md' = '#avm_output_entire_resource_disallowed'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR3.md' = '#avm_provider_azapi_version_constraint'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR4.md' = '#avm_azapi_response_export_values_required'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR5.md' = '#avm_azapi_replace_triggers_refs_valid'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR6.md' = '#avm_interface_resource_types'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR7.md' = '#avm_interface_retry'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR8.md' = '#avm_interface_ignore_body_changes'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR9.md' = '#avm_azapi_resource_tags_required'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR10.md' = '#avm_terraform_ignore_changes_unquoted_references'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR23.md' = '#avm_terraform_sensitive_variable_default_disallowed'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR25.md' = '#avm_terraform_configuration_file_required'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR26.md' = '#mapotf-and-standard-terraform-tflint-coverage'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR27.md' = '#avm_terraform_provider_block_disallowed'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR39.md' = '#avm_terraform_configuration_file_required'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR40.md' = '#avm_terraform_literal_heredoc_disallowed'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR41.md' = '#mapotf-and-standard-terraform-tflint-coverage'
}

foreach ($relativePath in $specRuleLinks.Keys) {
  $content = Get-Content -Raw (Join-Path $RepositoryRoot $relativePath)
  if ($content -notmatch [regex]::Escape($specRuleLinks[$relativePath])) {
    throw "'$relativePath' does not link to its TFLint rule guidance."
  }
}

$tagSpec = Get-Content -Raw (Join-Path $RepositoryRoot 'docs\content\specs-defs\includes\terraform\shared\functional\TFFR9.md')
foreach ($requiredText in @(
  'tags = var.tags',
  'non-null override for the Terraform resource block label',
  'MUST NOT** merge the fallback and override maps',
  'resource_tags.modules.<module_label>',
  'separate `resources` and `modules` namespaces',
  'statically read-only or unsupported tags property',
  '#avm_interface_resource_tags',
  'dynamic or otherwise unevaluable',
  'embedded AVM-generated capability snapshot',
  'rather than a hand-maintained module allowlist or an AzAPI import'
)) {
  if ($tagSpec -notmatch [regex]::Escape($requiredText)) {
    throw "TFFR9 does not define '$requiredText'."
  }
}

$tagInterface = Get-Content -Raw (Join-Path $RepositoryRoot 'docs\content\specs-defs\specs\terraform\interfaces.md')
foreach ($requiredText in @(
  'The `tags` variable is the module-wide fallback and common interface',
  'A module that does not expose per-resource overrides can continue to assign `tags = var.tags` directly',
  'Modules **MAY** add the typed `resource_tags` variable',
  '`resources` and `modules` namespaces',
  'attribute names match Terraform resource block labels',
  'attribute names match Terraform module block labels',
  'A supplied map replaces `var.tags` completely',
  'An empty map therefore deliberately applies no tags',
  'resource_tags = try(var.resource_tags.modules.child, null)'
)) {
  if ($tagInterface -notmatch [regex]::Escape($requiredText)) {
    throw "The Terraform tags interface does not define '$requiredText'."
  }
}

$tagSchema = Get-Content -Raw (Join-Path $RepositoryRoot 'docs\static\includes\interfaces\tf\int.tags.schema.tf')
foreach ($requiredText in @(
  'variable "tags"',
  'type        = map(string)',
  'default     = null',
  'variable "resource_tags"',
  'resources = optional(object({',
  'modules = optional(object({'
)) {
  if ($tagSchema -notmatch [regex]::Escape($requiredText)) {
    throw "The Terraform tags schema does not define '$requiredText'."
  }
}

$tagRuleGuide = ($guide -split '### avm_azapi_resource_tags_required', 2 | Select-Object -Last 1) -split '### avm_azapi_response_export_values_required', 2 | Select-Object -First 1
foreach ($requiredText in @(
  'must set `tags` from a consumer-settable expression',
  'A direct `tags = var.tags` assignment remains valid',
  'typed `resource_tags` replacement interface',
  'read-only or unsupported tags must omit the argument',
  'does not require one exact tags expression',
  'does not consume, import, or query AzAPI',
  'embeds its AVM-generated capability snapshot and works standalone',
  'does not accept an external snapshot path',
  'weekly ruleset workflow compares the embedded snapshot with upstream data',
  'opens a ruleset pull request when that data changes',
  'Updated capability data ships with the next ruleset release',
  'upgrading the ruleset release'
)) {
  if ($tagRuleGuide -notmatch [regex]::Escape($requiredText)) {
    throw "The azapi_resource_tag guide does not document '$requiredText'."
  }
}

$resourceTagsRuleGuide = ($guide -split '### avm_interface_resource_tags', 2 | Select-Object -Last 1) -split '### avm_interface_resource_types', 2 | Select-Object -First 1
foreach ($requiredText in @(
  'optional `resource_tags` variable when it is declared',
  'default to `null` and permit null values',
  'optional `resources` and `modules` namespaces without inline defaults',
  'optional `map(string)` leaves',
  'recursively use the same shape',
  'at least one resource leaf',
  'Terraform resource and module block labels without collisions'
)) {
  if ($resourceTagsRuleGuide -notmatch [regex]::Escape($requiredText)) {
    throw "The avm_interface_resource_tags guide does not document '$requiredText'."
  }
}

$replaceTriggersSpec = Get-Content -Raw (Join-Path $RepositoryRoot 'docs\content\specs-defs\includes\terraform\shared\functional\TFFR5.md')
$compositionGuide = Get-Content -Raw (Join-Path $RepositoryRoot 'docs\content\contributing\terraform\composition.md')
$replaceTriggersGuide = $guide -split '### azapi replace triggers refs', 2 | Select-Object -Last 1
foreach ($requiredText in @(
  'MUST** omit `replace_triggers_refs` when no body properties require replacement',
  'non-empty static list of JMESPath expressions',
  'MUST** be valid JMESPath syntax, non-blank, and unique within the list',
  'Do not include `name` or `location`',
  'body is statically evaluable, every declared expression **MUST** resolve against that body',
  'Bicep-generated schemas do not reliably preserve whether a property is create-only or updateable',
  'cannot prove that the list is semantically complete'
)) {
  if ($replaceTriggersSpec -notmatch [regex]::Escape($requiredText)) {
    throw "TFFR5 does not define '$requiredText'."
  }
}

foreach ($requiredText in @(
  'Omit `replace_triggers_refs` when no body paths require replacement',
  'non-empty static list of valid JMESPath expressions',
  'Entries cannot be blank or duplicated',
  'cannot include `name` or `location`',
  'body is statically evaluable, the rule verifies that each declared path resolves against it',
  'Bicep-generated schemas do not reliably preserve create-only versus updateable mutability',
  'cannot prove that the list is semantically complete'
)) {
  if ($replaceTriggersGuide -notmatch [regex]::Escape($requiredText)) {
    throw "The azapi_replace_triggers_refs guide does not document '$requiredText'."
  }
}

foreach ($requiredText in @(
  'Set `replace_triggers_refs` only when body paths require replacement',
  'non-empty static list **MUST** contain valid, unique JMESPath expressions',
  'omit the argument when no paths are needed'
)) {
  if ($compositionGuide -notmatch [regex]::Escape($requiredText)) {
    throw "The Terraform composition guide does not document '$requiredText'."
  }
}

foreach ($content in @($replaceTriggersSpec, $replaceTriggersGuide, $compositionGuide)) {
  foreach ($prohibitedPattern in @(
    '(?i)must be specified, even if empty',
    '(?i)always set `replace_triggers_refs`',
    '(?i)declare `replace_triggers_refs` on every applicable',
    '(?s)replace_triggers_refs\s*=\s*\[\s*\]'
  )) {
    if ($content -match $prohibitedPattern) {
      throw "replace_triggers_refs documentation contains superseded wording: '$prohibitedPattern'."
    }
  }
}

$staleSnapshotTerms = @(
  'generic external snapshot path',
  'pins, downloads, verifies, and caches an AVM-owned immutable snapshot',
  'On a cache miss, it fetches the exact pin',
  'fail-closed',
  'no stale snapshot fallback is used',
  'preload instructions',
  'independently of ruleset releases'
)
foreach ($staleTerm in $staleSnapshotTerms) {
  if ($tagRuleGuide -match [regex]::Escape($staleTerm)) {
    throw "The azapi_resource_tag guide contains superseded snapshot wording: '$staleTerm'."
  }
}

$documentation = Get-ChildItem -Path (Join-Path $RepositoryRoot 'docs') -Recurse -File -Filter '*.md' |
  Get-Content -Raw
if ($documentation -match 'TFNFR32') {
  throw 'Removed specification TFNFR32 is still referenced by documentation.'
}

foreach ($path in @(
  (Join-Path $RepositoryRoot 'docs\content\contributing\terraform\advanced.md'),
  $guidePath
)) {
  $content = Get-Content -Raw $path
  foreach ($override in @(
    'avm.tflint.override.hcl',
    'avm.tflint_module.override.hcl',
    'avm.tflint_example.override.hcl',
    'modules/<name>/avm.tflint.override.hcl',
    'examples/<name>/avm.tflint.override.hcl'
  )) {
    if ($content -notmatch [regex]::Escape($override)) {
      throw "'$path' does not document '$override'."
    }
  }

  if ($guide -notmatch [regex]::Escape('the immutable AVM base configuration, the matching repository-root all-scope override, then the target-directory override')) {
    throw 'The TFLint guide does not document override precedence.'
  }

  foreach ($requiredText in @(
    'AVM permits only one directory layer for Terraform submodule and example roots',
    'Nested Terraform module or example roots are prohibited',
    'Avm.Authoring` convention validation enforces this structure'
  )) {
    if ($guide -notmatch [regex]::Escape($requiredText)) {
      throw "The TFLint guide does not document '$requiredText'."
    }
  }

  $submoduleSpec = Get-Content -Raw (Join-Path $RepositoryRoot 'docs\content\specs-defs\includes\terraform\resource\non-functional\TFRMNFR1.md')
  foreach ($requiredText in @(
    'Nested Terraform module roots are prohibited',
    'Nested example roots are prohibited',
    'Avm.Authoring` convention validation enforces the direct `modules/*` and `examples/*` scope structure'
  )) {
    if ($submoduleSpec -notmatch [regex]::Escape($requiredText)) {
      throw "TFRMNFR1 does not define '$requiredText'."
    }
  }
}

Write-Output 'TFLint documentation validation passed.'
