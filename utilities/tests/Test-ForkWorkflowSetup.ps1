$ErrorActionPreference = 'Stop'
$doc = Get-Content -Raw (Join-Path $PSScriptRoot '..\..\docs\content\contributing\bicep\contribution-flow.md')
$match = [regex]::Match($doc, '(?s)### Run e2e tests in your fork.*?    ```powershell\r?\n(    \$repository = .*?)\r?\n    ```')
if (-not $match.Success) { throw 'Documented setup script not found.' }
$script = [regex]::Replace($match.Groups[1].Value, '(?m)^    ', '')
foreach ($replacement in @{
    '<owner>/<fork>' = 'tester/fork'
    '<new-identity-name>' = 'test-identity'
    '<azure-region>' = 'eastus'
}.GetEnumerator()) {
    $script = $script.Replace($replacement.Key, $replacement.Value)
}
$tokens = $null
$errors = $null
[void][System.Management.Automation.Language.Parser]::ParseInput($script, [ref]$tokens, [ref]$errors)
if ($errors.Count) { throw ($errors | Out-String) }

function script:Read-Host {
    if ($script:scenario -eq 'cancel') { return 'NO' }
    'CREATE'
}

function script:gh {
    $script:LASTEXITCODE = 0
    $line = $args -join ' '
    if ($line -match '--method (PUT|POST|DELETE)' -or $line -match '^(variable set|workflow enable)') {
        $script:mutations.Add("gh $line")
        if ($script:scenario -eq 'environment-error' -and $line -match 'environments/avm-validation') {
            $script:LASTEXITCODE = 1
        }
        return
    }
    switch -Regex ($line) {
        '^api repos/tester/fork$' {
            if ($script:scenario -eq 'github-error') { $script:LASTEXITCODE = 1; return }
            if ($script:scenario -eq 'not-fork') { return '{"fork":false}' }
            return '{"fork":true,"parent":{"full_name":"Azure/bicep-registry-modules"}}'
        }
        'actions/permissions' { return '{"enabled":true}' }
        'actions/workflows/pr-check.yml' {
            if ($script:scenario -eq 'workflow-disabled') { return '{"state":"disabled_manually"}' }
            return '{"state":"active"}'
        }
        'actions/oidc/customization/sub' {
            if ($script:scenario -eq 'custom-oidc') { return '{"use_default":false}' }
            return '{"use_default":true,"sub_claim_prefix":"repo:tester@12/fork@34"}'
        }
        'environments\?per_page' {
            if ($script:scenario -in @('existing-safe', 'existing-unsafe', 'env-secret-conflict')) { return 'avm-validation' }
            return
        }
        '^secret list' {
            if ($script:scenario -eq 'secret-conflict' -or
                ($script:scenario -eq 'env-secret-conflict' -and $line -match '--env avm-validation')) {
                return 'ARM_CLIENT_ID_OVERRIDE'
            }
            return
        }
        '^variable list' { return }
        default { throw "Unexpected gh call: $line" }
    }
}

function script:az {
    $script:LASTEXITCODE = 0
    $line = $args -join ' '
    switch -Regex ($line) {
        '^account show --output json$' {
            if ($script:scenario -eq 'account-error') { $script:LASTEXITCODE = 1; return }
            return '{"id":"11111111-1111-1111-1111-111111111111","tenantId":"22222222-2222-2222-2222-222222222222"}'
        }
        '^cloud show' { return 'AzureCloud' }
        '^group exists' {
            if ($script:scenario -eq 'invalid-group-status') { return 'unknown' }
            if ($script:scenario -in @('existing-group', 'identity-conflict')) { return 'true' }
            return 'false'
        }
        '^group create' {
            $script:mutations.Add("az $line")
            if ($script:scenario -eq 'group-error') { $script:LASTEXITCODE = 1 }
            return
        }
        '^identity list' {
            if ($script:scenario -eq 'identity-conflict') { return '[{"name":"test-identity"}]' }
            return '[]'
        }
        '^identity create' {
            $script:mutations.Add("az $line")
            if ($script:scenario -eq 'azure-error') { $script:LASTEXITCODE = 1; return }
            return '{"principalId":"33333333-3333-3333-3333-333333333333","clientId":"44444444-4444-4444-4444-444444444444"}'
        }
        '^(identity federated-credential create|role assignment create)' {
            $script:mutations.Add("az $line")
            return
        }
        default { throw "Unexpected az call: $line" }
    }
}

foreach ($scenario in @('new', 'existing-safe', 'existing-group', 'workflow-disabled', 'not-fork', 'custom-oidc', 'secret-conflict', 'env-secret-conflict', 'identity-conflict', 'invalid-group-status', 'existing-unsafe', 'github-error', 'account-error', 'cancel', 'environment-error', 'group-error', 'azure-error')) {
    $script:scenario = $scenario
    $script:mutations = [System.Collections.Generic.List[string]]::new()
    $failed = $false
    try { & ([scriptblock]::Create($script)) | Out-Null } catch { $failed = $true; $failure = $_ }
    if ($scenario -in @('new', 'existing-safe', 'existing-group', 'existing-unsafe', 'workflow-disabled')) {
        if ($failed) { throw "$scenario unexpectedly failed: $failure" }
        if (@($script:mutations | Where-Object { $_ -match '^gh variable set ' }).Count -ne 3) { throw "$scenario did not set all three variables." }
        if (-not ($script:mutations -match '--subject repo:tester@12/fork@34:environment:avm-validation')) { throw "$scenario used an incorrect OIDC subject." }
        if (-not ($script:mutations -match 'environments/avm-validation -F deployment_branch_policy=null')) { throw "$scenario did not allow all branches in the environment." }
        if (-not ($script:mutations -match '--role Contributor --scope /subscriptions/11111111-1111-1111-1111-111111111111')) { throw "$scenario used an incorrect role scope." }
        if (-not ($script:mutations -match '^az identity create --subscription 11111111-1111-1111-1111-111111111111 --resource-group test-identity-rg ')) { throw "$scenario used an incorrect identity scope." }
        if ($scenario -eq 'existing-group' -and ($script:mutations -match '^az group create')) { throw 'Existing resource group was modified.' }
        if ($scenario -ne 'existing-group' -and -not ($script:mutations -match '^az group create --subscription 11111111-1111-1111-1111-111111111111 --name test-identity-rg ')) { throw "$scenario did not create the resource group." }
        if ($scenario -eq 'workflow-disabled' -and -not ($script:mutations -match '^gh workflow enable')) { throw 'Disabled workflow was not enabled.' }
    } elseif (-not $failed) {
        throw "$scenario unexpectedly succeeded."
    } elseif ($scenario -eq 'environment-error') {
        if (@($script:mutations | Where-Object { $_ -match '^az ' }).Count) { throw 'Environment update failure reached Azure mutation.' }
    } elseif ($scenario -in @('group-error', 'azure-error')) {
        if (@($script:mutations | Where-Object { $_ -match '^(gh variable set|az role assignment|az identity federated-credential)' }).Count) { throw 'Azure failure did not stop subsequent mutations.' }
        if ($scenario -eq 'group-error' -and ($script:mutations -match '^az identity create')) { throw 'Group creation failure did not stop identity creation.' }
    } elseif ($script:mutations.Count) {
        throw "$scenario mutated resources before failing."
    }
    Write-Output "$scenario passed"
}
$script:LASTEXITCODE = 0
