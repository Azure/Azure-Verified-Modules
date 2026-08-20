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
  'dynamic or otherwise unevaluable'
)) {
  if ($tagSpec -notmatch [regex]::Escape($requiredText)) {
    throw "TFFR9 does not define '$requiredText'."
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

Write-Host 'TFLint documentation validation passed.'
