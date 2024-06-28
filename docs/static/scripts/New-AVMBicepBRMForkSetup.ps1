[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "", Justification = "Coloured output required in this script")]

#Requires -PSEdition Core
#Requires -Modules @{ ModuleName="Az.Accounts"; ModuleVersion="2.19.0" }
#Requires -Modules @{ ModuleName="Az.Resources"; ModuleVersion="6.16.2" }

<#
.SYNOPSIS
This function creates and sets up everything a contributor to the AVM Bicep project should need to get started with their contribution to a AVM Bicep Module.

.DESCRIPTION
This function creates and sets up everything a contributor to the AVM Bicep project should need to get started with their contribution to a AVM Bicep Module. This includes:

- Forking and cloning the `Azure/bicep-registry-modules` repository
- Creating a new SPN and granting it the necessary permissions for the CI tests and configuring the forked repositories secrets, as per: https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#1-setup-your-azure-test-environment
- Enabling GitHub Actions on the forked repository
- Disabling all the module workflows by default, as per: https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/

Effectively simplifying this process to a signle command, https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/

.PARAMETER GitHubRepositoryPathForCloneOfForkedRepository
Mandatory. The path to the GitHub repository to fork and clone. Directory will be created if does not already exist. Can use either relative paths or full literal paths.

.PARAMETER GitHubSecret_ARM_MGMTGROUP_ID
Optional. The group ID of the management group to test-deploy modules in. Is needed for resources that are deployed to the management group scope. If not provided CI tests on Management Group scoped modules will not work and you will need to manually confiugre the RBAC role assignments for the SPN and associated repository secret later.

.PARAMETER GitHubSecret_ARM_SUBSCRIPTION_ID
Mandatory. The ID of the subscription to test-deploy modules in. Is needed for resources that are deployed to the subscription scope.

.PARAMETER GitHubSecret_ARM_TENANT_ID
Mandatory. The tenant ID of the Azure Active Directory tenant to test-deploy modules in. Is needed for resources that are deployed to the tenant scope.

.PARAMETER GitHubSecret_TOKEN_NAMEPREFIX
Mandatory. Required. A short (3-5 character length), unique string that should be included in any deployment to Azure. Usually, AVM Bicep test cases require this value to ensure no two contributors deploy resources with the same name - which is especially important for resources that require a globally unique name (e.g., Key Vault). These characters will be used as part of each resource’s name during deployment.

.PARAMETER SPNName
Optional. The name of the SPN (Service Principal) to create. If not provided, a default name of `spn-avm-bicep-brm-fork-ci-<GitHub Organization>` will be used.

.EXAMPLE
.\<PATH-TO-SCRIPT-DOWNLOAD-LOCATION>\New-AVMBicepBRMForkSetup.ps1 -GitHubRepositoryPathForCloneOfForkedRepository "D:\GitRepos\" -GitHubSecret_ARM_MGMTGROUP_ID "alz" -GitHubSecret_ARM_SUBSCRIPTION_ID "1b60f82b-d28e-4640-8cfa-e02d2ddb421a" -GitHubSecret_ARM_TENANT_ID "c3df6353-a410-40a1-b962-e91e45e14e4b" -GitHubSecret_TOKEN_NAMEPREFIX "ex123"

Example Subscription & Management Group scoped deployments enabled with default generated SPN name of `spn-avm-bicep-brm-fork-ci-<GitHub Organization>`.

.EXAMPLE
.\<PATH-TO-SCRIPT-DOWNLOAD-LOCATION>\New-AVMBicepBRMForkSetup.ps1 -GitHubRepositoryPathForCloneOfForkedRepository "D:\GitRepos\" -GitHubSecret_ARM_SUBSCRIPTION_ID "1b60f82b-d28e-4640-8cfa-e02d2ddb421a" -GitHubSecret_ARM_TENANT_ID "c3df6353-a410-40a1-b962-e91e45e14e4b" -GitHubSecret_TOKEN_NAMEPREFIX "ex123"

Example Subscription scoped deployments enabled only with default generated SPN name of `spn-avm-bicep-brm-fork-ci-<GitHub Organization>`.

.EXAMPLE
.\<PATH-TO-SCRIPT-DOWNLOAD-LOCATION>\New-AVMBicepBRMForkSetup.ps1 -GitHubRepositoryPathForCloneOfForkedRepository "D:\GitRepos\" -GitHubSecret_ARM_MGMTGROUP_ID "alz" -GitHubSecret_ARM_SUBSCRIPTION_ID "1b60f82b-d28e-4640-8cfa-e02d2ddb421a" -GitHubSecret_ARM_TENANT_ID "c3df6353-a410-40a1-b962-e91e45e14e4b" -GitHubSecret_TOKEN_NAMEPREFIX "ex123" -SPNName "my-spn-name"

Example with provided SPN name.

#>

[CmdletBinding(SupportsShouldProcess = $false)]
param (
  [Parameter(Mandatory = $true)]
  [string] $GitHubRepositoryPathForCloneOfForkedRepository,

  [Parameter(Mandatory = $false)]
  [string] $GitHubSecret_ARM_MGMTGROUP_ID,

  [Parameter(Mandatory = $true)]
  [string] $GitHubSecret_ARM_SUBSCRIPTION_ID,

  [Parameter(Mandatory = $true)]
  [string] $GitHubSecret_ARM_TENANT_ID,

  [Parameter(Mandatory = $true)]
  [string] $GitHubSecret_TOKEN_NAMEPREFIX,

  [Parameter(Mandatory = $false)]
  [string] $SPNName

)

# Check if the GitHub CLI is installed
$GitHubCliInstalled = Get-Command gh -ErrorAction SilentlyContinue
if ($null -eq $GitHubCliInstalled) {
  throw 'The GitHub CLI is not installed. Please install the GitHub CLI and try again. Install link for GitHub CLI: https://github.com/cli/cli#installation'
}
Write-Host 'The GitHub CLI is installed...' -ForegroundColor Green

# Check if GitHub CLI is authenticated
$GitHubCliAuthenticated = gh auth status
if ($LASTEXITCODE -ne 0) {
  Write-Host $GitHubCliAuthenticated -ForegroundColor Red
  throw "Not authenticated to GitHub. Please authenticate to GitHub using the GitHub CLI command of 'gh auth login', and try again."
}
Write-Host 'Authenticated to GitHub with following details...' -ForegroundColor Cyan
Write-Host ''
gh auth status
Write-Host ''

# Ask the user to confirm if it's the correct GitHub account
do {
  Write-Host "Is the above GitHub account correct to coninue with the fork setup of the 'Azure/bicep-registry-modules' repository? Please enter 'y' or 'n'." -ForegroundColor Yellow
  $userInput = Read-Host
  $userInput = $userInput.ToLower()

  switch ($userInput) {
    'y' {
      Write-Host ''
      Write-Host 'User Confirmed. Proceeding with the GitHub account listed above...' -ForegroundColor Green
      Write-Host ''
      break
    }
    'n' {
      Write-Host ''
      throw "User stated incorrect GitHub account. Please switch to the correct GitHub account. You can do this in the GitHub CLI (gh) by logging out by running 'gh auth logout' and then logging back in with 'gh auth login'"
    }
    default {
      Write-Host ''
      Write-Host "Invalid input. Please enter 'y' or 'n'." -ForegroundColor Red
      Write-Host ''
    }
  }
} while ($userInput -ne 'y' -and $userInput -ne 'n')

# Fork and clone repository locally
Write-Host "Changing to directory $GitHubRepositoryPathForCloneOfForkedRepository ..." -ForegroundColor Magenta

if (-not (Test-Path -Path $GitHubRepositoryPathForCloneOfForkedRepository)) {
  Write-Host "Directory does not exist. Creating directory $GitHubRepositoryPathForCloneOfForkedRepository ..." -ForegroundColor Yellow
  New-Item -Path $GitHubRepositoryPathForCloneOfForkedRepository -ItemType Directory -ErrorAction Stop
  Write-Host ''
}
Set-Location -Path $GitHubRepositoryPathForCloneOfForkedRepository -ErrorAction stop
$CreatedDirectoryLocation = Get-Location
Write-Host "Forking and cloning 'Azure/bicep-registry-modules' repository..." -ForegroundColor Magenta

gh repo fork 'Azure/bicep-registry-modules' --default-branch-only --clone=true
if ($LASTEXITCODE -ne 0) {
  throw "Failed to fork and clone the 'Azure/bicep-registry-modules' repository. Please check the error message above, resolve any issues, and try again."
}

$ClonedRepoDirectoryLocation = Join-Path $CreatedDirectoryLocation 'bicep-registry-modules'
Write-Host ''
Write-Host "Fork of 'Azure/bicep-registry-modules' created successfully directory in $CreatedDirectoryLocation ..." -ForegroundColor Green
Write-Host ''
Write-Host "Changing into cloned repository directory $ClonedRepoDirectoryLocation ..." -ForegroundColor Magenta
Set-Location $ClonedRepoDirectoryLocation -ErrorAction stop

# Check is user is logged in to Azure
$UserLoggedIntoAzure = Get-AzContext -ErrorAction SilentlyContinue
if ($null -eq $UserLoggedIntoAzure) {
  throw 'You are not logged into Azure. Please log into Azure using the Azure PowerShell module using the command of `Connect-AzAccount` to the correct tenant and try again.'
}
$UserLoggedIntoAzureJson = $UserLoggedIntoAzure | ConvertTo-Json -Depth 10 | ConvertFrom-Json
Write-Host "You are logged into Azure as '$($UserLoggedIntoAzureJson.Account.Id)' ..." -ForegroundColor Green

# Check user has access to desired subscription
$UserCanAccessSubscription = Get-AzSubscription -SubscriptionId $GitHubSecret_ARM_SUBSCRIPTION_ID -ErrorAction SilentlyContinue
if ($null -eq $UserCanAccessSubscription) {
  throw "You do not have access to the subscription with the ID of '$($GitHubSecret_ARM_SUBSCRIPTION_ID)'. Please ensure you have access to the subscription and try again."
}
Write-Host "You have access to the subscription with the ID of '$($GitHubSecret_ARM_SUBSCRIPTION_ID)' ..." -ForegroundColor Green
Write-Host ''

# Get GitHub Login/Org Name
$GitHubUserRaw = gh api user
$GitHubUserConvertedToJson = $GitHubUserRaw | ConvertFrom-Json -Depth 10
$GitHubOrgName = $GitHubUserConvertedToJson.login
$GitHubOrgAndRepoNameCombined = "$($GitHubOrgName)/bicep-registry-modules"

# Create SPN
if ($SPNName -eq '') {
  Write-Host "No value provided for the SPN Name. Defaulting to 'spn-avm-bicep-brm-fork-ci-<GitHub Organization>' ..." -ForegroundColor Yellow

  $SPNName = "spn-avm-bicep-brm-fork-ci-$($GitHubOrgName)"
}
$newSpn = New-AzADServicePrincipal -DisplayName $SPNName -Description "Service Principal Name (SPN) for the AVM Bicep CI Tests in the $($GitHubOrgName) fork. See: https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#1-setup-your-azure-test-environment" -ErrorAction Stop
Write-Host "New SPN created with a Display Name of '$($newSpn.DisplayName)' and an Object ID of '$($newSpn.Id)'." -ForegroundColor Green
Write-Host ''

# Create RBAC Role Assignments for SPN
Write-Host 'Starting 120 second sleep to allow the SPN to be created and available for RBAC Role Assignments (eventual consistency) ...' -ForegroundColor Yellow
Start-Sleep -Seconds 120

Write-Host "Creating RBAC Role Assignments of 'Contributor' and 'User Access Administrator' for the Service Principal Name (SPN) '$($newSpn.DisplayName)' on the Subscription with the ID of '$($GitHubSecret_ARM_SUBSCRIPTION_ID)' ..." -ForegroundColor Magenta
New-AzRoleAssignment -ApplicationId $newSpn.AppId -RoleDefinitionName 'User Access Administrator' -Scope "/subscriptions/$($GitHubSecret_ARM_SUBSCRIPTION_ID)" -ErrorAction Stop
New-AzRoleAssignment -ApplicationId $newSpn.AppId -RoleDefinitionName 'Contributor' -Scope "/subscriptions/$($GitHubSecret_ARM_SUBSCRIPTION_ID)" -ErrorAction Stop
Write-Host "RBAC Role Assignments of 'Contributor' and 'User Access Administrator' for the Service Principal Name (SPN) '$($newSpn.DisplayName)' created successfully on the Subscription with the ID of '$($GitHubSecret_ARM_SUBSCRIPTION_ID)'." -ForegroundColor Green
Write-Host ''

if ($GitHubSecret_ARM_MGMTGROUP_ID -eq '') {
  Write-Host "No Management Group ID provided as input parameter to '-GitHubSecret_ARM_MGMTGROUP_ID', skipping RBAC Role Assignments upon Management Groups" -ForegroundColor Yellow
  Write-Host ''
}

if ($GitHubSecret_ARM_MGMTGROUP_ID -ne '') {
  Write-Host "Creating RBAC Role Assignments of 'Contributor' and 'User Access Administrator' for the Service Principal Name (SPN) '$($newSpn.DisplayName)' on the Management Group with the ID of '$($GitHubSecret_ARM_MGMTGROUP_ID)' ..." -ForegroundColor Magenta
  New-AzRoleAssignment -ApplicationId $newSpn.AppId -RoleDefinitionName 'User Access Administrator' -Scope "/providers/Microsoft.Management/managementGroups/$($GitHubSecret_ARM_MGMTGROUP_ID)" -ErrorAction Stop
  New-AzRoleAssignment -ApplicationId $newSpn.AppId -RoleDefinitionName 'Contributor' -Scope "/providers/Microsoft.Management/managementGroups/$($GitHubSecret_ARM_SUBSCRIPTION_ID)" -ErrorAction Stop
  Write-Host "RBAC Role Assignments of 'Contributor' and 'User Access Administrator' for the Service Principal Name (SPN) '$($newSpn.DisplayName)' created successfully on the Management Group with the ID of '$($GitHubSecret_ARM_MGMTGROUP_ID)'." -ForegroundColor Green
  Write-Host ''
}

# Set GitHub Repo Secrets
Write-Host "Setting GitHub Secrets on forked repostiory '$($GitHubOrgAndRepoNameCombined)' ..." -ForegroundColor Magenta
Write-Host 'Creating and formatting secret `AZURE_CREDENTIALS` with details from SPN creation process and other parameter inputs ...' -ForegroundColor Cyan

$FormattedAzureCredentialsSecret = "{ 'clientId': '$($newSpn.AppId)', 'clientSecret': '$($newSpn.PasswordCredentials.SecretText)', 'subscriptionId': '$($GitHubSecret_ARM_SUBSCRIPTION_ID)', 'tenantId': '$($GitHubSecret_ARM_TENANT_ID)' }"
$FormattedAzureCredentialsSecretJsonCompressed = $FormattedAzureCredentialsSecret | ConvertFrom-Json | ConvertTo-Json -Compress

if ($GitHubSecret_ARM_MGMTGROUP_ID -ne '') {
  gh secret set ARM_MGMTGROUP_ID --body $GitHubSecret_ARM_MGMTGROUP_ID -R $GitHubOrgAndRepoNameCombined
}
gh secret set ARM_SUBSCRIPTION_ID --body $GitHubSecret_ARM_SUBSCRIPTION_ID -R $GitHubOrgAndRepoNameCombined
gh secret set ARM_TENANT_ID --body $GitHubSecret_ARM_TENANT_ID -R $GitHubOrgAndRepoNameCombined
gh secret set AZURE_CREDENTIALS --body $FormattedAzureCredentialsSecretJsonCompressed -R $GitHubOrgAndRepoNameCombined
gh secret set TOKEN_NAMEPREFIX --body $GitHubSecret_TOKEN_NAMEPREFIX -R $GitHubOrgAndRepoNameCombined

Write-Host ''
Write-Host "Successfully created and set GitHub Secrets on forked repostiory '$($GitHubOrgAndRepoNameCombined)' ..." -ForegroundColor Green
Write-Host ''

Write-Host "Openning browser so you can enable GitHub Actions on newly forked repository '$($GitHubOrgAndRepoNameCombined)' ..." -ForegroundColor Magenta
Write-Host "Please select click on the green button stating 'I understand my workflows, go ahead and enable them' to enable actions/workflows on your forked repository via the website that has appeared in your browser window and then return to this terminal session to continue ..." -ForegroundColor Yellow
Start-Process "https://github.com/$($GitHubOrgAndRepoNameCombined)/actions" -ErrorAction Stop
Write-Host ''

$GitHubWorkflowPlatformToggleWorkflows = '.Platform - Toggle AVM workflows'
$GitHubWorkflowPlatformToggleWorkflowsFileName = 'platform.toggle-avm-workflows.yml'

do {
  Write-Host "Did you successfully enabled the GitHub Actions/Workflows on your forked repository '$($GitHubOrgAndRepoNameCombined)'? Please enter 'y' or 'n'." -ForegroundColor Yellow
  $userInput = Read-Host
  $userInput = $userInput.ToLower()

  switch ($userInput) {
    'y' {
      Write-Host ''
      Write-Host "User Confirmed. Proceeding to trigger workflow of '$($GitHubWorkflowPlatformToggleWorkflows)' to disable all workflows as per: https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/..." -ForegroundColor Green
      Write-Host ''
      break
    }
    'n' {
      Write-Host ''
      Write-Host 'User stated no. Ending script here. Please review and complete any of the steps you have not completed, likely just enabling GitHub Actions/Workflows on your forked repository and then disabling all workflows as per: https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/' -ForegroundColor Yellow
      exit
    }
    default {
      Write-Host ''
      Write-Host "Invalid input. Please enter 'y' or 'n'." -ForegroundColor Red
      Write-Host ''
    }
  }
} while ($userInput -ne 'y' -and $userInput -ne 'n')

Write-Host "Triggering '$($GitHubWorkflowPlatformToggleWorkflows) on '$($GitHubOrgAndRepoNameCombined)' ..." -ForegroundColor Magenta
Write-Host ''
gh workflow run $GitHubWorkflowPlatformToggleWorkflows -R $GitHubOrgAndRepoNameCombined
Write-Host ''

Write-Host 'Starting 120 second sleep to allow the workflow run to complete ...' -ForegroundColor Yellow
Start-Sleep -Seconds 120
Write-Host ''

Write-Host "Workflow '$($GitHubWorkflowPlatformToggleWorkflows) on '$($GitHubOrgAndRepoNameCombined)' should have now completed, openning workflow in browser so you can check ..." -ForegroundColor Magenta
Start-Process "https://github.com/$($GitHubOrgAndRepoNameCombined)/actions/workflows/$($GitHubWorkflowPlatformToggleWorkflowsFileName)" -ErrorAction Stop
Write-Host ''

Write-Host "Script execution complete. Fork of '$($GitHubOrgAndRepoNameCombined)' created and configured and cloned to '$($ClonedRepoDirectoryLocation)' as per Bicep contribution guide: https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/ you are now ready to proceed from step 4. Openning the Bicep Contrbution Guide for you to review and continue..." -ForegroundColor Green
Start-Process 'https://azure.github.io/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/'
