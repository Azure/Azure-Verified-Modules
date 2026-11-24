$ErrorActionPreference = 'Stop'
$doc = Get-Content -Raw (Join-Path $PSScriptRoot '..\..\docs\content\contributing\bicep\contribution-flow.md')
$match = [regex]::Match($doc, '(?s)### Run e2e tests in your fork.*?    ```powershell\r?\n(.*?)\r?\n    ```')
if (-not $match.Success) { throw 'Documented setup script not found.' }
$script = [regex]::Replace($match.Groups[1].Value, '(?m)^    ', '')
foreach ($replacement in @{
    '<owner>/<fork>' = 'tester/fork'
    '<branch-to-test>' = 'feature/test'
    '<test-subscription-guid>' = '11111111-1111-1111-1111-111111111111'
    '<existing-identity-resource-group>' = 'test-rg'
    '<new-identity-name>' = 'test-identity'
    '<azure-region>' = 'eastus'
}.GetEnumerator()) {
    $script = $script.Replace($replacement.Key, $replacement.Value)
}
$tokens = $null
$errors = $null
[void][System.Management.Automation.Language.Parser]::ParseInput($script, [ref]$tokens, [ref]$errors)
if ($errors.Count) { throw ($errors | Out-String) }

function global:git {
    $global:LASTEXITCODE = 0
    'feature/test'
}

function global:Read-Host {
    if ($global:scenario -eq 'cancel') { return 'NO' }
    'CREATE'
}

function global:gh {
    $global:LASTEXITCODE = 0
    $line = $args -join ' '
    if ($line -match '--method (PUT|POST)' -or $line -match '^(variable set|workflow enable)') {
        $global:mutations.Add("gh $line")
        return
    }
    switch -Regex ($line) {
        '^api repos/tester/fork$' {
            if ($global:scenario -eq 'github-error') { $global:LASTEXITCODE = 1; return }
            if ($global:scenario -eq 'not-fork') { return '{"fork":false}' }
            return '{"fork":true,"parent":{"full_name":"Azure/bicep-registry-modules"}}'
        }
        'branches/' { return '{}' }
        'actions/permissions' { return '{"enabled":true}' }
        'actions/workflows/pr-check.yml' {
            if ($global:scenario -eq 'workflow-disabled') { return '{"state":"disabled_manually"}' }
            return '{"state":"active"}'
        }
        'actions/oidc/customization/sub' {
            if ($global:scenario -eq 'custom-oidc') { return '{"use_default":false}' }
            return '{"use_default":true,"sub_claim_prefix":"repo:tester@12/fork@34"}'
        }
        'environments\?per_page' {
            if ($global:scenario -in @('existing-safe', 'existing-unsafe', 'env-secret-conflict')) { return 'avm-validation' }
            return
        }
        'deployment-branch-policies' {
            if ($global:scenario -in @('existing-unsafe', 'created-unsafe')) { return "other`tbranch" }
            return "feature/test`tbranch"
        }
        'environments/avm-validation$' {
            return '{"deployment_branch_policy":{"custom_branch_policies":true}}'
        }
        '^secret list' {
            if ($global:scenario -eq 'secret-conflict' -or
                ($global:scenario -eq 'env-secret-conflict' -and $line -match '--env avm-validation')) {
                return 'ARM_CLIENT_ID_OVERRIDE'
            }
            return
        }
        '^variable list' { return }
        default { throw "Unexpected gh call: $line" }
    }
}

function global:az {
    $global:LASTEXITCODE = 0
    $line = $args -join ' '
    switch -Regex ($line) {
        '^account show' { return '{"id":"11111111-1111-1111-1111-111111111111","tenantId":"22222222-2222-2222-2222-222222222222"}' }
        '^cloud show' { return 'AzureCloud' }
        '^group show' { return }
        '^identity list' {
            if ($global:scenario -eq 'identity-conflict') { return '[{"name":"test-identity"}]' }
            return '[]'
        }
        '^identity create' {
            $global:mutations.Add("az $line")
            if ($global:scenario -eq 'azure-error') { $global:LASTEXITCODE = 1; return }
            return '{"principalId":"33333333-3333-3333-3333-333333333333","clientId":"44444444-4444-4444-4444-444444444444"}'
        }
        '^(identity federated-credential create|role assignment create)' {
            $global:mutations.Add("az $line")
            return
        }
        default { throw "Unexpected az call: $line" }
    }
}

foreach ($scenario in @('new', 'existing-safe', 'workflow-disabled', 'not-fork', 'custom-oidc', 'secret-conflict', 'env-secret-conflict', 'identity-conflict', 'existing-unsafe', 'github-error', 'cancel', 'created-unsafe', 'azure-error')) {
    $global:scenario = $scenario
    $global:mutations = [System.Collections.Generic.List[string]]::new()
    $failed = $false
    try { & ([scriptblock]::Create($script)) | Out-Null } catch { $failed = $true }
    if ($scenario -in @('new', 'existing-safe', 'workflow-disabled')) {
        if ($failed) { throw "$scenario unexpectedly failed." }
        if (@($global:mutations | Where-Object { $_ -match '^gh variable set ' }).Count -ne 3) { throw "$scenario did not set all three variables." }
        if (-not ($global:mutations -match '--subject repo:tester@12/fork@34:environment:avm-validation')) { throw "$scenario used an incorrect OIDC subject." }
        if (-not ($global:mutations -match '--role Contributor --scope /subscriptions/11111111-1111-1111-1111-111111111111')) { throw "$scenario used an incorrect role scope." }
        if ($scenario -eq 'workflow-disabled' -and -not ($global:mutations -match '^gh workflow enable')) { throw 'Disabled workflow was not enabled.' }
    } elseif (-not $failed) {
        throw "$scenario unexpectedly succeeded."
    } elseif ($scenario -eq 'created-unsafe') {
        if (@($global:mutations | Where-Object { $_ -match '^az ' }).Count) { throw 'Unsafe environment reached Azure mutation.' }
    } elseif ($scenario -eq 'azure-error') {
        if (@($global:mutations | Where-Object { $_ -match '^(gh variable set|az role assignment)' }).Count) { throw 'Azure failure did not stop subsequent mutations.' }
    } elseif ($global:mutations.Count) {
        throw "$scenario mutated resources before failing."
    }
    Write-Output "$scenario passed"
}
