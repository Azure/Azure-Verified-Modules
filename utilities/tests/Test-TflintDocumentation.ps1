[CmdletBinding()]
param(
  [string] $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..'))
)

$ErrorActionPreference = 'Stop'

$guidePath = Join-Path $RepositoryRoot 'docs\content\contributing\terraform\tflint-rules.md'
$guide = Get-Content -Raw $guidePath

$rules = @(
  'azapi_data_response_export_values',
  'azapi_replace_triggers_refs',
  'azapi_resource_tag',
  'azapi_response_export_values',
  'customer_managed_key',
  'deprecated_lock_interface',
  'deprecated_private_endpoints_interface',
  'deprecated_role_assignments_interface',
  'diagnostic_settings',
  'ignore_body_changes',
  'location',
  'lock',
  'managed_identities',
  'no_entire_resource_output_tffr2',
  'private_endpoints',
  'private_endpoints_manage_dns_zone_group',
  'provider_azapi_version_constraint',
  'provider_azurerm_disallowed',
  'provider_azurerm_version_constraint',
  'provider_modtm_version_constraint',
  'required_module_source_tffr1',
  'required_module_source_tfnfr10',
  'required_output_rmfr7',
  'resource_types',
  'retry',
  'role_assignments',
  'tags',
  'terraform_heredoc_usage',
  'terraform_module_provider_declaration',
  'terraform_sensitive_variable_no_default',
  'terraform_tf_file',
  'timeouts'
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
  'docs\content\specs-defs\includes\shared\resource\functional\RMFR7.md' = '#required-output-rmfr7'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR1.md' = '#required-module-source-tffr1'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR2.md' = '#no-entire-resource-output-tffr2'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR3.md' = '#provider-azapi-version-constraint'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR4.md' = '#azapi-response-export-values'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR5.md' = '#azapi-replace-triggers-refs'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR6.md' = '#resource-types'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR7.md' = '#retry'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR8.md' = '#ignore-body-changes'
  'docs\content\specs-defs\includes\terraform\shared\functional\TFFR9.md' = '#azapi-resource-tag'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR10.md' = '#required-module-source-tfnfr10'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR23.md' = '#terraform-sensitive-variable-no-default'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR25.md' = '#terraform-tf-file'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR26.md' = '#mapotf-and-standard-terraform-tflint-coverage'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR27.md' = '#terraform-module-provider-declaration'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR39.md' = '#terraform-tf-file'
  'docs\content\specs-defs\includes\terraform\shared\non-functional\TFNFR40.md' = '#terraform-heredoc-usage'
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
  'conditionally replace, or otherwise transform',
  'statically unsupported resource type',
  'dynamic or otherwise unevaluable',
  'embedded AVM-generated capability snapshot',
  'rather than a hand-maintained module allowlist or an AzAPI import'
)) {
  if ($tagSpec -notmatch [regex]::Escape($requiredText)) {
    throw "TFFR9 does not define '$requiredText'."
  }
}

$tagRuleGuide = $guide -split '### azapi resource tag', 2 | Select-Object -Last 1
foreach ($requiredText in @(
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
