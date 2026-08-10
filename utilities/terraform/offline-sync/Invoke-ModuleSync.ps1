<#
.SYNOPSIS
    Synchronizes Azure Verified Modules (AVM) Terraform repositories from GitHub to a target git server.

.DESCRIPTION
    NOTE: This script is an example intended for advanced users familiar with PowerShell, Git, and Terraform module management. It is provided as-is and not supported for production use.

    This script queries the GitHub API to find AVM Terraform module repositories, clones them locally,
    resolves all module dependencies, creates tagged versions (with configurable suffix, default '-local')
    with module sources converted from Terraform registry format to git references, and optionally pushes
    to a target git server (GitHub, Azure DevOps, or other git hosting).

    The script performs three phases:
    - Phase 1: Clone repositories and resolve all module dependencies across all tags
    - Phase 2: Process each tag to create suffixed versions with converted module sources (parallel)
    - Phase 3: Push all repositories and tags to the target git server (parallel)

.PARAMETER destinationDirectoryPath
    The local directory path where repositories will be cloned.
    Supports ~ for home directory expansion.
    Default: ~/avm-modules

.PARAMETER targetGitRepositoryProtocol
    The protocol to use for the target git server URL.
    Common values: "https://", "git@" (for SSH)
    Default: https://

.PARAMETER targetGitRepositoryDomain
    The domain of the target git server.
    Examples: "github.com", "dev.azure.com", "gitlab.com", "your-server.com"
    Default: github.com

.PARAMETER targetGitRepositoryOrganizationName
    The organization or namespace on the target git server where repos will be pushed.
    For GitHub: the organization or username (e.g., "my-org")
    For Azure DevOps: "org/project" format (e.g., "contoso/terraform-modules")
    This parameter is required.

.PARAMETER targetGitRepositoryNamePrefix
    Optional prefix to add to repository names when pushing to target.
    Useful for namespacing or avoiding conflicts.
    Example: "avm-" would rename "terraform-azurerm-avm-res-compute-vm" to "avm-terraform-azurerm-avm-res-compute-vm"
    Default: "" (no prefix)

.PARAMETER sourceRepositoryOrganizationName
    The GitHub organization to search for source AVM repositories.
    Default: Azure

.PARAMETER sourceRepositoryPrefixes
    Array of repository name prefixes to search for in the source organization.
    Repositories must start with one of these prefixes to be included.
    Default: @("terraform-azurerm-avm-", "terraform-azure-avm-", "terraform-azapi-avm-")

.PARAMETER moduleFilters
    Array of regex patterns to filter repositories after the prefix search.
    Only repositories matching at least one filter will be processed.
    Use @() for no filtering (process all matching repos).
    Examples:
        @("avm-res-") - Only resource modules
        @("avm-ptn-") - Only pattern modules
        @("avm-res-compute", "avm-res-network") - Specific module categories
        @() - All modules (no filtering)
    This parameter is required.

.PARAMETER parallelCloneLimit
    Maximum number of parallel operations for cloning, tag processing, and pushing.
    Higher values speed up processing but use more resources and may hit rate limits.
    Default: 10

.PARAMETER forceLocalRepoCloneRefresh
    When specified, removes the destination directory contents (preserving sync state) and starts fresh.
    If repositories already exist on the target server, they will be cloned from there first.
    This allows recovering existing work from the target while refreshing the local state.
    The sync state file is preserved to maintain the list of tracked repos and kept repos.

.PARAMETER forceRemoteRepoRefresh
    When specified, performs a complete fresh start by:
    1. Removing the local destination directory (same as -forceLocalRepoCloneRefresh)
    2. Deleting all target repositories on the upstream git server before pushing
    Use with EXTREME CAUTION as this permanently deletes repositories on the target server.
    Requires appropriate CLI tools (gh for GitHub, az for Azure DevOps) to be installed and authenticated.

.PARAMETER skipVerification
    When specified with -forceRemoteRepoRefresh, skips the confirmation prompt before deleting upstream repositories.
    Without this flag, the script will prompt for confirmation before deleting any repositories.
    Useful for automated/CI scenarios where interactive prompts are not possible.

.PARAMETER syncStateFilePath
    Path to a JSON file that tracks the sync state including:
    - All repositories that have been synced to the target
    - Repositories to keep even when not matched by moduleFilters
    - Last sync timestamp and configuration
    This file is used by cleanLocalAndRemote and forceRemoteRepoRefresh to know which repos to delete.
    Default: .sync-state.json in the destination directory

.PARAMETER skipOrphanCheck
    When specified, skips checking for and prompting about orphaned repositories that exist in the
    destination but are not in the current filter/dependency graph.
    Use this for automated/CI scenarios or when you want to keep all existing repositories.

.PARAMETER targetRepositoryVisibility
    The visibility/privacy level for newly created target repositories.
    Valid values: 'private', 'internal', 'public'
    - private: Only visible to organization members with explicit access (default)
    - internal: Visible to all organization members (GitHub Enterprise only)
    - public: Visible to everyone
    Default: private

.PARAMETER localTagSuffix
    The suffix to append to version tags when creating converted versions.
    For example, with the default '-local' suffix, tag 'v1.0.0' becomes 'v1.0.0-local'.
    This allows you to customize the naming convention for your organization.
    Default: -local

.PARAMETER cleanLocalAndRemote
    When specified, cleans up all local repositories and deletes all tracked remote repositories,
    then exits. Uses the sync state file to determine which remote repositories to delete.
    This is useful for completely resetting the sync state.
    Requires -skipVerification or will prompt for confirmation before deletion.

.EXAMPLE
    # Basic usage - sync ALZ pattern modules to a GitHub organization
    .\Invoke-ModuleSync.ps1 -targetGitRepositoryOrganizationName "my-org"

.EXAMPLE
    # Sync all AVM modules (no filter) to Azure DevOps
    .\Invoke-ModuleSync.ps1 `
        -targetGitRepositoryDomain "dev.azure.com" `
        -targetGitRepositoryOrganizationName "contoso/terraform-modules" `
        -moduleFilters @()

.EXAMPLE
    # Sync specific modules with SSH protocol and custom destination
    .\Invoke-ModuleSync.ps1 `
        -destinationDirectoryPath "C:\terraform\avm-local" `
        -targetGitRepositoryProtocol "git@" `
        -targetGitRepositoryDomain "github.com:" `
        -targetGitRepositoryOrganizationName "my-org" `
        -moduleFilters @("avm-res-compute", "avm-res-storage")

.EXAMPLE
    # Force fresh sync with increased parallelism
    .\Invoke-ModuleSync.ps1 `
        -forceLocalRepoCloneRefresh `
        -parallelCloneLimit 20 `
        -moduleFilters @("avm-ptn-")

.EXAMPLE
    # Sync to a self-hosted GitLab instance with name prefix
    .\Invoke-ModuleSync.ps1 `
        -targetGitRepositoryDomain "gitlab.internal.company.com" `
        -targetGitRepositoryOrganizationName "infrastructure/terraform" `
        -targetGitRepositoryNamePrefix "azure-" `
        -moduleFilters @()

.NOTES
    Requirements:
    - PowerShell 7+ (required for ForEach-Object -Parallel)
    - Git CLI installed and in PATH
    - For GitHub target: GitHub CLI (gh) installed and authenticated
    - For Azure DevOps target: Azure CLI (az) installed and authenticated

    The script creates:
    - Cloned repositories in the destination directory
    - dependency-graphs/ folder with JSON files showing module dependencies per repo
    - failed-repos.json if any pushes fail

    Module source transformation (using default -local suffix):
    - Original: source = "Azure/avm-res-compute-virtualmachine/azurerm"
    - Converted: source = "git::https://target-server/org/terraform-azurerm-avm-res-compute-virtualmachine.git?ref=v0.1.0-local"

    Custom suffix example (with -localTagSuffix '-synced'):
    - Converted: source = "git::https://target-server/org/terraform-azurerm-avm-res-compute-virtualmachine.git?ref=v0.1.0-synced"
#>
param (
    [Parameter(Mandatory = $false, HelpMessage = "Local directory path where repositories will be cloned. Supports ~ expansion.")]
    [string]$destinationDirectoryPath = "~/avm-modules",

    [Parameter(Mandatory = $false, HelpMessage = "Protocol for target git URL (https:// or git@)")]
    [string]$targetGitRepositoryProtocol = "https://",

    [Parameter(Mandatory = $false, HelpMessage = "Domain of target git server (e.g., github.com, dev.azure.com)")]
    [string]$targetGitRepositoryDomain = "github.com",

    [Parameter(Mandatory = $true, HelpMessage = "Organization/namespace on target server. For ADO use 'org/project' format.")]
    [string]$targetGitRepositoryOrganizationName = "",

    [Parameter(Mandatory = $false, HelpMessage = "Optional prefix to add to repository names on target")]
    [string]$targetGitRepositoryNamePrefix = "",

    [Parameter(Mandatory = $false, HelpMessage = "GitHub organization to search for source repositories")]
    [string]$sourceRepositoryOrganizationName = "Azure",

    [Parameter(Mandatory = $false, HelpMessage = "Protocol for source git URL (e.g., https://)")]
    [string]$sourceRepositoryProtocol = "https://",

    [Parameter(Mandatory = $false, HelpMessage = "Domain of source git server (e.g., github.com)")]
    [string]$sourceRepositoryDomain = "github.com",

    [Parameter(Mandatory = $false, HelpMessage = "Repository name prefixes to search for")]
    [string[]]$sourceRepositoryPrefixes = @("terraform-azurerm-avm-", "terraform-azure-avm-", "terraform-azapi-avm-"),

    [Parameter(Mandatory = $true, HelpMessage = "Regex patterns to filter repositories. Use @() for no filtering.")]
    [string[]]$moduleFilters = @(),

    [Parameter(Mandatory = $false, HelpMessage = "Maximum parallel operations for clone/process/push (default: 10)")]
    [int]$parallelCloneLimit = 10,

    [Parameter(Mandatory = $false, HelpMessage = "Remove destination directory and start fresh")]
    [switch]$forceLocalRepoCloneRefresh,

    [Parameter(Mandatory = $false, HelpMessage = "Complete fresh start: remove local directory AND delete upstream repos")]
    [switch]$forceRemoteRepoRefresh,

    [Parameter(Mandatory = $false, HelpMessage = "Skip confirmation prompt before deleting upstream repos (use with -forceRemoteRepoRefresh)")]
    [switch]$skipVerification,

    [Parameter(Mandatory = $false, HelpMessage = "Path to JSON file tracking sync state including synced repos and kept repos")]
    [string]$syncStateFilePath = "",

    [Parameter(Mandatory = $false, HelpMessage = "Skip checking for and prompting about orphaned repos not in the current filter/dependency graph")]
    [switch]$skipOrphanCheck,

    [Parameter(Mandatory = $false, HelpMessage = "Visibility for newly created target repos: private, internal, or public")]
    [ValidateSet('private', 'internal', 'public')]
    [string]$targetRepositoryVisibility = "private",

    [Parameter(Mandatory = $false, HelpMessage = "Clean up all local and tracked remote repositories, then exit")]
    [switch]$cleanLocalAndRemote,

    [Parameter(Mandatory = $false, HelpMessage = "Suffix to append to version tags (e.g., -local, -synced, -internal)")]
    [string]$localTagSuffix = "-local"
)

# Ensure destination directory path is resolved early (needed for sync state file)
$destinationPath = [System.IO.Path]::GetFullPath([System.Environment]::ExpandEnvironmentVariables($destinationDirectoryPath.Replace("~", $env:USERPROFILE)))

# Determine sync state file path (default to destination folder if not specified)
if (-not $syncStateFilePath) {
    $syncStateFilePath = Join-Path -Path $destinationPath -ChildPath ".sync-state.json"
} else {
    $syncStateFilePath = [System.IO.Path]::GetFullPath([System.Environment]::ExpandEnvironmentVariables($syncStateFilePath.Replace("~", $env:USERPROFILE)))
}

# Helper function to load sync state from file
function Get-SyncState {
    param([string]$FilePath)

    $defaultState = @{
        description = "Sync state for AVM module synchronization. Do not edit manually."
        syncedRepos = @()
        keptRepos = @()
        lastSyncAt = $null
        targetConfig = @{
            protocol = ""
            domain = ""
            organization = ""
            prefix = ""
        }
    }

    if (Test-Path -Path $FilePath) {
        try {
            $state = Get-Content -Path $FilePath -Raw | ConvertFrom-Json
            # Ensure all properties exist
            if (-not $state.syncedRepos) { $state | Add-Member -NotePropertyName "syncedRepos" -NotePropertyValue @() -Force }
            if (-not $state.keptRepos) { $state | Add-Member -NotePropertyName "keptRepos" -NotePropertyValue @() -Force }
            return $state
        } catch {
            Write-Warning "Failed to load sync state file: $_"
        }
    }

    return $defaultState
}

# Helper function to save sync state to file
function Save-SyncState {
    param(
        [object]$State,
        [string]$FilePath
    )

    # Ensure the parent directory exists
    $parentDir = Split-Path -Path $FilePath -Parent
    if ($parentDir -and -not (Test-Path -Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    $State | ConvertTo-Json -Depth 10 | Set-Content -Path $FilePath -Encoding UTF8
}

# Helper function to parse Azure DevOps org and project from organization name
function Get-AdoOrgAndProject {
    param(
        [string]$Protocol,
        [string]$Domain,
        [string]$OrganizationName
    )

    $result = @{ Org = ""; Project = ""; OrgUrl = ""; Valid = $false }

    if ($Domain -match "dev\.azure\.com") {
        $orgParts = $OrganizationName -split "/"
        if ($orgParts.Count -ge 2) {
            $result.Org = $orgParts[0]
            $result.Project = $orgParts[1]
            $result.OrgUrl = "${Protocol}${Domain}/$($orgParts[0])"
            $result.Valid = $true
        }
    } elseif ($Domain -match "visualstudio\.com") {
        $result.Org = $Domain -replace "\.visualstudio\.com.*", ""
        $result.Project = $OrganizationName
        $result.OrgUrl = "${Protocol}${Domain}"
        $result.Valid = $true
    }

    return $result
}

# Helper function to delete remote repositories
function Remove-RemoteRepositories {
    param(
        [string[]]$RepoNames,
        [string]$TargetProtocol,
        [string]$TargetDomain,
        [string]$TargetOrg,
        [string]$TargetPrefix
    )

    $isGitHub = $TargetDomain -match "github\.com"
    $isAzureDevOps = $TargetDomain -match "dev\.azure\.com|visualstudio\.com"

    # Check CLI availability
    $ghAvailable = $null -ne (Get-Command gh -ErrorAction SilentlyContinue)
    $ghLoggedIn = $false
    $azAvailable = $null -ne (Get-Command az -ErrorAction SilentlyContinue)
    $azLoggedIn = $false

    if ($isGitHub -and $ghAvailable) {
        gh auth status 2>&1 | Out-Null
        $ghLoggedIn = $LASTEXITCODE -eq 0
    }

    if ($isAzureDevOps -and $azAvailable) {
        az account show 2>&1 | Out-Null
        $azLoggedIn = $LASTEXITCODE -eq 0
    }

    $adoInfo = $null
    if ($isAzureDevOps) {
        $adoInfo = Get-AdoOrgAndProject -Protocol $TargetProtocol -Domain $TargetDomain -OrganizationName $TargetOrg
    }

    foreach ($repoName in $RepoNames) {
        $targetRepoFullName = "$TargetPrefix$repoName"

        if ($isGitHub -and $ghAvailable -and $ghLoggedIn) {
            gh repo view "$TargetOrg/$targetRepoFullName" 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    Deleting GitHub repo: $TargetOrg/$targetRepoFullName"
                gh repo delete "$TargetOrg/$targetRepoFullName" --yes 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "      Deleted successfully"
                } else {
                    Write-Warning "      Failed to delete (may require admin permissions)"
                }
            } else {
                Write-Host "    Skipping $targetRepoFullName (not found on remote)"
            }
        } elseif ($isAzureDevOps -and $azAvailable -and $azLoggedIn -and $adoInfo.Valid) {
            az repos show --repository $targetRepoFullName --org $adoInfo.OrgUrl --project $adoInfo.Project 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    Deleting Azure DevOps repo: $targetRepoFullName in $($adoInfo.Org)/$($adoInfo.Project)"
                az repos delete --id $targetRepoFullName --org $adoInfo.OrgUrl --project $adoInfo.Project --yes 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "      Deleted successfully"
                } else {
                    Write-Warning "      Failed to delete (may require admin permissions)"
                }
            } else {
                Write-Host "    Skipping $targetRepoFullName (not found on remote)"
            }
        }
    }
}

# Load sync state
$syncState = Get-SyncState -FilePath $syncStateFilePath

# Migrate from deprecated keptReposFilePath if it exists
$oldKeptReposPath = Join-Path -Path $destinationPath -ChildPath ".kept-repos.json"
if ((Test-Path -Path $oldKeptReposPath) -and $syncState.keptRepos.Count -eq 0) {
    try {
        $oldKeptData = Get-Content -Path $oldKeptReposPath -Raw | ConvertFrom-Json
        if ($oldKeptData.repos) {
            $syncState.keptRepos = @($oldKeptData.repos)
            Write-Host "Migrated $($syncState.keptRepos.Count) kept repos from deprecated .kept-repos.json"
            # Remove the old file after migration
            Remove-Item -Path $oldKeptReposPath -Force -ErrorAction SilentlyContinue
        }
    } catch {
        Write-Warning "Failed to migrate kept repos: $_"
    }
}

# Extract kept repos for use later
$keptRepos = @($syncState.keptRepos)

# ============================================================================
# CLEANUP PHASE: Handle cleanLocalAndRemote, forceRemoteRepoRefresh early
# ============================================================================
if ($cleanLocalAndRemote -or $forceRemoteRepoRefresh) {
    Write-Host "`n=== Cleanup Phase ==="

    # Get list of repos to delete from sync state
    $reposToDelete = @($syncState.syncedRepos)

    if ($reposToDelete.Count -eq 0) {
        Write-Host "No tracked repositories found in sync state file."
        if (-not (Test-Path -Path $syncStateFilePath)) {
            Write-Host "Sync state file does not exist: $syncStateFilePath"
        }
    } else {
        Write-Host "Found $($reposToDelete.Count) tracked repositories in sync state."

        # Prompt for confirmation unless skipVerification is set
        $proceedWithDeletion = $false
        if ($skipVerification) {
            Write-Host "Skipping verification (skipVerification flag set)"
            $proceedWithDeletion = $true
        } else {
            Write-Host ""
            Write-Warning "WARNING: This will PERMANENTLY DELETE the following:"
            Write-Host "  - Local destination directory: $destinationPath"
            Write-Host "  - Remote repositories on: $targetGitRepositoryProtocol$targetGitRepositoryDomain/$targetGitRepositoryOrganizationName"
            Write-Host ""
            Write-Host "Repositories to delete:"
            foreach ($repoName in $reposToDelete) {
                $targetRepoFullName = "$targetGitRepositoryNamePrefix$repoName"
                Write-Host "    - $targetGitRepositoryOrganizationName/$targetRepoFullName"
            }
            Write-Host ""
            $confirmation = Read-Host "Type 'DELETE' to confirm deletion, or anything else to cancel"
            if ($confirmation -eq 'DELETE') {
                $proceedWithDeletion = $true
                Write-Host "Confirmation received. Proceeding with deletion..."
            } else {
                Write-Host "Deletion cancelled."
                if ($cleanLocalAndRemote) {
                    exit 0
                }
            }
        }

        if ($proceedWithDeletion) {
            # Delete remote repositories
            Write-Host "`nDeleting remote repositories..."
            Remove-RemoteRepositories -RepoNames $reposToDelete `
                -TargetProtocol $targetGitRepositoryProtocol `
                -TargetDomain $targetGitRepositoryDomain `
                -TargetOrg $targetGitRepositoryOrganizationName `
                -TargetPrefix $targetGitRepositoryNamePrefix

            Write-Host "Remote repository deletion complete."
        }
    }

    # Delete local destination directory
    if (Test-Path -Path $destinationPath) {
        Write-Host "`nRemoving local destination directory: $destinationPath"
        Remove-Item -Path $destinationPath -Recurse -Force
    }

    # Delete sync state file
    if (Test-Path -Path $syncStateFilePath) {
        Write-Host "Removing sync state file: $syncStateFilePath"
        Remove-Item -Path $syncStateFilePath -Force
    }

    # Clear kept repos when doing a clean
    $keptRepos = @()

    Write-Host "`nCleanup complete."

    # If cleanLocalAndRemote, exit here
    if ($cleanLocalAndRemote) {
        Write-Host "cleanLocalAndRemote flag set - exiting after cleanup."
        exit 0
    }
}

# Handle forceLocalRepoCloneRefresh (without remote deletion)
if ($forceLocalRepoCloneRefresh -and -not $forceRemoteRepoRefresh) {
    if (Test-Path -Path $destinationPath) {
        Write-Host "`nForce local refresh flag set - cleaning destination directory (preserving sync state): $destinationPath"

        # Preserve sync state file
        $syncStateBackup = $null
        if (Test-Path -Path $syncStateFilePath) {
            $syncStateBackup = Get-Content -Path $syncStateFilePath -Raw
        }

        # Remove the directory
        Remove-Item -Path $destinationPath -Recurse -Force

        # Restore sync state file
        if ($syncStateBackup) {
            New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
            Set-Content -Path $syncStateFilePath -Value $syncStateBackup -Encoding UTF8
            Write-Host "  Preserved sync state file"
        }
    }
    # Keep the kept repos from sync state (don't clear them)
}

# ============================================================================
# END CLEANUP PHASE
# ============================================================================

# Find the source repositories using GitHub Search API
Write-Host "`nQuerying GitHub Search API for AVM repositories in organization '$sourceRepositoryOrganizationName' with prefixes: $($sourceRepositoryPrefixes -join ', ')..."

$avmRepos = @()
$page = 1
$perPage = 100

# Build the search query with OR operator for multiple prefixes, excluding archived repos
$prefixQueries = $sourceRepositoryPrefixes | ForEach-Object { "$_ in:name" }
$searchQuery = "org:$sourceRepositoryOrganizationName archived:false ($($prefixQueries -join ' OR '))"

Write-Host "  Search query: $searchQuery"

do {
    $encodedQuery = [System.Web.HttpUtility]::UrlEncode($searchQuery)
    $uri = "https://api.github.com/search/repositories?q=$encodedQuery&per_page=$perPage&page=$page"

    try {
        $response = Invoke-RestMethod -Uri $uri -Headers @{ "Accept" = "application/vnd.github.v3+json" } -Method Get
    } catch {
        Write-Error "Failed to query GitHub Search API: $_"
        exit 1
    }

    if ($response.items.Count -eq 0) {
        break
    }

    $avmRepos += $response.items
    $page++

    # GitHub Search API has rate limits, add a small delay between pages
    if ($response.items.Count -eq $perPage) {
        Start-Sleep -Milliseconds 500
    }
} while ($response.items.Count -eq $perPage)

Write-Host "Found $($avmRepos.Count) repositories from search in organization '$sourceRepositoryOrganizationName'"

# Filter to only repos that actually start with one of the prefixes (GitHub search does substring matching)
$avmRepos = $avmRepos | Where-Object {
    $repoName = $_.name
    $sourceRepositoryPrefixes | Where-Object { $repoName.StartsWith($_) }
} | Sort-Object -Property name

Write-Host "Found $($avmRepos.Count) repositories matching prefixes in organization '$sourceRepositoryOrganizationName'"

# Apply module filters if specified (filters are additive - repo must match at least one filter)
if ($moduleFilters.Count -gt 0) {
    Write-Host "Applying module filters: $($moduleFilters -join ', ')"
    $filteredRepos = @()

    foreach ($repo in $avmRepos) {
        foreach ($filter in $moduleFilters) {
            if ($repo.name -match $filter) {
                $filteredRepos += $repo
                break  # No need to check other filters once matched
            }
        }
    }

    $avmRepos = $filteredRepos
    Write-Host "After filtering: $($avmRepos.Count) repositories match the specified filters"
}

# Output the list of repositories
Write-Host "`nRepositories to sync:"
foreach ($repo in $avmRepos) {
    Write-Host "  - $($repo.name) ($($repo.clone_url))"
}

# Ensure destination directory exists
if (-not (Test-Path -Path $destinationPath)) {
    Write-Host "`nCreating destination directory: $destinationPath"
    New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
}

# Common URL patterns - defined early so they can be used in parallel blocks
$sourceGitBaseUrl = "$sourceRepositoryProtocol$sourceRepositoryDomain/$sourceRepositoryOrganizationName"
$targetGitBaseUrl = "$targetGitRepositoryProtocol$targetGitRepositoryDomain/$targetGitRepositoryOrganizationName"

if($sourceGitBaseUrl.ToLower() -eq $targetGitBaseUrl.ToLower()) {
    Write-Error "Source and target git base URLs are the same: $sourceGitBaseUrl. This is not allowed. Please update your inputs and try again."
    exit 1
}

# Clone or pull repositories directly to destination folder
# Clone from source (GitHub), then add upstream remote for target and fetch tags from there
Write-Host "`nSyncing repositories to destination (parallel limit: $parallelCloneLimit)..."

$results = $avmRepos | ForEach-Object -ThrottleLimit $parallelCloneLimit -Parallel {
    $repo = $_
    $destPath = $using:destinationPath
    $repoPath = Join-Path -Path $destPath -ChildPath $repo.name
    $targetBaseUrl = $using:targetGitBaseUrl
    $targetPrefix = $using:targetGitRepositoryNamePrefix

    $result = @{
        Name = $repo.name
        Success = $false
        Action = ""
        Message = ""
    }

    # Build target URL for this repo
    $targetRepoUrl = "$targetBaseUrl/$targetPrefix$($repo.name).git"

    if (Test-Path -Path $repoPath) {
        # Repo exists - pull from source (origin)
        $result.Action = "pull"
        Push-Location -Path $repoPath
        try {
            git checkout main 2>&1 | Out-Null
            $pullResult = git pull origin main 2>&1
            if ($LASTEXITCODE -eq 0 -or $pullResult -match "Already up to date") {
                git fetch origin --tags 2>&1 | Out-Null
                $result.Success = $true
                $result.Message = "Pulled from source"
            } else {
                $result.Message = "Failed to pull: $pullResult"
            }
        } catch {
            $result.Message = "Failed to pull: $_"
        } finally {
            Pop-Location
        }
    } else {
        # Repo doesn't exist - clone from source
        $result.Action = "clone"
        try {
            $cloneResult = git clone $repo.clone_url $repoPath 2>&1
            if ($LASTEXITCODE -eq 0) {
                $result.Success = $true
                $result.Message = "Cloned from source"
            } else {
                $result.Message = "Failed to clone: $cloneResult"
            }
        } catch {
            $result.Message = "Failed to clone: $_"
        }
    }

    # If successful, add/update upstream remote for target and fetch tags from there
    if ($result.Success) {
        Push-Location -Path $repoPath
        try {
            # Check if 'upstream' remote exists
            $existingUpstream = git remote get-url upstream 2>&1
            if ($LASTEXITCODE -ne 0) {
                # Remote doesn't exist, add it
                git remote add upstream $targetRepoUrl 2>&1 | Out-Null
            } else {
                # Check if it points to the correct URL
                if ($existingUpstream -ne $targetRepoUrl) {
                    git remote set-url upstream $targetRepoUrl 2>&1 | Out-Null
                }
            }

            # Try to fetch tags from upstream (target) - may fail if repo doesn't exist there yet
            git fetch upstream --tags 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                $result.Message += " + fetched tags from target"
            }
        } catch {
            # Ignore errors fetching from upstream - repo may not exist there yet
        } finally {
            Pop-Location
        }
    }

    $result
}

# Report results
$successCount = 0
$failCount = 0

foreach ($result in $results) {
    if ($result.Success) {
        Write-Host "  $($result.Name): $($result.Message)"
        $successCount++
    } else {
        Write-Warning "  $($result.Name): $($result.Message)"
        $failCount++
    }
}

Write-Host "`nInitial clone complete: $successCount successful, $failCount failed"

# Regex patterns to match module blocks with registry source
# Only match valid module names (alphanumeric, hyphens, underscores - no special chars like < > etc)
$sourcePattern = '(source\s*=\s*")([A-Za-z0-9_-]+/avm-[A-Za-z0-9_-]+/[A-Za-z0-9_-]+)(")'
# Match the version line - capture leading whitespace separately to preserve line structure
$versionPattern = '(\r?\n)([ \t]*version\s*=\s*"([^"]+)"[ \t]*)'

# Regex pattern to match semver tags (with optional v prefix)
$semverPattern = '^v?\d+\.\d+\.\d+(-[A-Za-z0-9.-]+)?(\+[A-Za-z0-9.-]+)?$'

# Helper function to build target repo URL
function Get-TargetRepoUrl {
    param(
        [string]$RepoName,
        [string]$BaseUrl,
        [string]$Prefix
    )
    return "$BaseUrl/$Prefix$RepoName.git"
}

# Helper function to build source GitHub URL
function Get-SourceGitHubUrl {
    param(
        [string]$RepoName,
        [string]$BaseUrl
    )
    return "$BaseUrl/$RepoName.git"
}

# Helper function to convert registry source to repo name
function Get-RepoNameFromRegistrySource {
    param([string]$Source)
    $parts = $Source -split "/"
    if ($parts.Count -ge 3) {
        return "terraform-$($parts[2])-$($parts[1])"
    }
    return $null
}

# Helper function to normalize version to local tag format
function Get-LocalTagName {
    param(
        [string]$Version,
        [string]$Suffix = "-local"
    )
    $normalized = $Version -replace '^v', ''
    return "v$normalized$Suffix"
}

# Helper function to get .tf files excluding examples folder
function Get-TerraformFiles {
    param([string]$Path)
    return Get-ChildItem -Path $Path -Filter "*.tf" -Recurse -File -ErrorAction SilentlyContinue |
           Where-Object { $_.FullName -notmatch '[/\\]examples[/\\]' }
}

# Helper function to filter tags to semver-only (excluding suffixed tags)
function Get-SemverTags {
    param(
        $TagsOutput,  # Can be array or string from git tag -l
        [string]$SemverPattern,
        [string]$ExcludeSuffix = "-local"
    )
    # Handle both array (from git tag -l returning multiple items) and string input
    $tagArray = if ($TagsOutput -is [array]) {
        $TagsOutput
    } else {
        $TagsOutput -split "`n"
    }
    # Escape the suffix for regex use
    $escapedSuffix = [regex]::Escape($ExcludeSuffix)
    return $tagArray | Where-Object { $_ -and $_ -notmatch "$escapedSuffix$" -and $_.Trim() -match $SemverPattern }
}

# Function to extract module dependencies from .tf files at a given path
function Get-ModuleDependencies {
    param (
        [string]$Path,
        [string]$SourcePattern
    )

    $dependencies = @()
    $tfFiles = Get-TerraformFiles -Path $Path

    foreach ($tfFile in $tfFiles) {
        $content = Get-Content -Path $tfFile.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }

        $sourceMatches = [regex]::Matches($content, $SourcePattern)

        foreach ($sourceMatch in $sourceMatches) {
            $source = $sourceMatch.Groups[2].Value
            $targetRepoName = Get-RepoNameFromRegistrySource -Source $source

            if ($targetRepoName -and $targetRepoName -notin $dependencies) {
                $dependencies += $targetRepoName
            }
        }
    }

    return $dependencies
}

# Function to extract detailed module dependencies including file paths and versions
function Get-DetailedModuleDependencies {
    param (
        [string]$Path,
        [string]$SourcePattern,
        [string]$VersionPattern,
        [string]$TargetBaseUrl,
        [string]$TargetPrefix,
        [string]$SourceBaseUrl,
        [string]$TagSuffix = "-local"
    )

    $dependencies = @()
    $tfFiles = Get-TerraformFiles -Path $Path

    foreach ($tfFile in $tfFiles) {
        $content = Get-Content -Path $tfFile.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }

        # Get relative path from repo root
        $relativePath = $tfFile.FullName.Substring($Path.Length).TrimStart('\', '/')

        $sourceMatches = [regex]::Matches($content, $SourcePattern)

        foreach ($sourceMatch in $sourceMatches) {
            $source = $sourceMatch.Groups[2].Value
            $targetRepoName = Get-RepoNameFromRegistrySource -Source $source

            if (-not $targetRepoName) { continue }

            # Look for version attribute after this source
            $sourceEndIndex = $sourceMatch.Index + $sourceMatch.Length
            $remainingContent = $content.Substring($sourceEndIndex)
            $versionMatch = [regex]::Match($remainingContent.Substring(0, [Math]::Min(500, $remainingContent.Length)), $VersionPattern)

            $oldVersion = ""
            $newVersion = ""
            if ($versionMatch.Success) {
                $oldVersion = $versionMatch.Groups[3].Value
                $newVersion = Get-LocalTagName -Version $oldVersion -Suffix $TagSuffix
            }

            # Build original and new source URLs
            $targetRepoFullName = "$TargetPrefix$targetRepoName"
            $newSource = if ($newVersion) {
                "git::$TargetBaseUrl/$targetRepoFullName.git?ref=$newVersion"
            } else {
                "git::$TargetBaseUrl/$targetRepoFullName.git"
            }

            $dependencies += @{
                originalSource = $source
                newSource = $newSource
                oldVersion = $oldVersion
                newVersion = $newVersion
                relativeFilePath = $relativePath
                dependencyRepoName = $targetRepoName
                originalGitRepo = "$SourceBaseUrl/$targetRepoName.git"
                newGitRepo = "$TargetBaseUrl/$targetRepoFullName.git"
            }
        }
    }

    return $dependencies
}

# Function to clone a repository if it doesn't exist
function Clone-RepositoryIfMissing {
    param (
        [string]$RepoName,
        [string]$DestinationPath,
        [string]$SourceBaseUrl
    )

    $repoPath = Join-Path -Path $DestinationPath -ChildPath $RepoName

    if (Test-Path -Path $repoPath) {
        return $false  # Already exists, not newly cloned
    }

    Write-Host "        Cloning missing dependency: $RepoName"
    $cloneUrl = "$SourceBaseUrl/$RepoName.git"

    try {
        $cloneResult = git clone $cloneUrl $repoPath 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $true  # Newly cloned
        } else {
            Write-Warning "    Failed to clone $RepoName : $cloneResult"
            return $false
        }
    } catch {
        Write-Warning "    Failed to clone $RepoName : $_"
        return $false
    }
}

# Function to resolve all dependencies recursively for a specific repo at a specific tag
function Resolve-DependenciesForTag {
    param (
        [string]$RepoPath,
        [string]$DestinationPath,
        [string]$SourceBaseUrl,
        [string]$SourcePattern,
        [hashtable]$ClonedRepos
    )

    $dependencies = Get-ModuleDependencies -Path $RepoPath -SourcePattern $SourcePattern
    $newDependencies = @()

    foreach ($dep in $dependencies) {
        $depPath = Join-Path -Path $DestinationPath -ChildPath $dep

        if (-not (Test-Path -Path $depPath)) {
            $cloned = Clone-RepositoryIfMissing -RepoName $dep -DestinationPath $DestinationPath -SourceBaseUrl $SourceBaseUrl
            if ($cloned) {
                $ClonedRepos[$dep] = $true
                $newDependencies += $dep
            }
        } elseif (-not $ClonedRepos.ContainsKey($dep)) {
            $newDependencies += $dep
            $ClonedRepos[$dep] = $true
        }
    }

    # Recursively resolve dependencies of new dependencies (check their main branch)
    foreach ($newDep in $newDependencies) {
        $newDepPath = Join-Path -Path $DestinationPath -ChildPath $newDep
        if (Test-Path -Path $newDepPath) {
            Resolve-DependenciesForTag -RepoPath $newDepPath -DestinationPath $DestinationPath -SourceBaseUrl $SourceBaseUrl -SourcePattern $SourcePattern -ClonedRepos $ClonedRepos
        }
    }
}

# Phase 1: Resolve dependencies across all tags in all repos
# Initialize dependency graph
$dependencyGraph = @{}

Write-Host "`nPhase 1: Resolving module dependencies across all tags (parallel limit: $parallelCloneLimit)..."

$checkedRepos = @{}  # Track repos we've already fully checked
$initialRepoCount = (Get-ChildItem -Path $destinationPath -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne "dependency-graphs" }).Count

# Convert functions to strings for parallel block
$funcGetSemverTagsP1 = ${function:Get-SemverTags}.ToString()
$funcGetLocalTagNameP1 = ${function:Get-LocalTagName}.ToString()
$funcGetTerraformFilesP1 = ${function:Get-TerraformFiles}.ToString()
$funcGetRepoNameFromRegistrySourceP1 = ${function:Get-RepoNameFromRegistrySource}.ToString()
$funcGetTargetRepoUrlP1 = ${function:Get-TargetRepoUrl}.ToString()
$funcGetSourceGitHubUrlP1 = ${function:Get-SourceGitHubUrl}.ToString()
$funcGetModuleDependenciesP1 = ${function:Get-ModuleDependencies}.ToString()
$funcGetDetailedModuleDependenciesP1 = ${function:Get-DetailedModuleDependencies}.ToString()

# Keep resolving until no new repos are cloned
$passNumber = 1
do {
    $reposBeforePass = (Get-ChildItem -Path $destinationPath -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne "dependency-graphs" }).Count
    Write-Host "  Pass $passNumber - checking dependencies..."

    # Get all repo directories in destination that haven't been checked yet
    $repoDirs = Get-ChildItem -Path $destinationPath -Directory -ErrorAction SilentlyContinue |
        Where-Object { -not $checkedRepos.ContainsKey($_.Name) -and $_.Name -ne "dependency-graphs" }

    if ($repoDirs.Count -eq 0) {
        Write-Host "    No unchecked repos remaining"
        break
    }

    Write-Host "    Checking $($repoDirs.Count) repos in parallel..."

    # Process repos in parallel - collect dependency info and required dependencies
    $phase1Results = $repoDirs | ForEach-Object -ThrottleLimit $parallelCloneLimit -Parallel {
        $repoDir = $_
        $repoPath = $repoDir.FullName
        $repoName = $repoDir.Name
        $srcPattern = $using:sourcePattern
        $verPattern = $using:versionPattern
        $semverPat = $using:semverPattern
        $targetBaseUrl = $using:targetGitBaseUrl
        $targetPrefix = $using:targetGitRepositoryNamePrefix
        $srcBaseUrl = $using:sourceGitBaseUrl
        $tagSuffix = $using:localTagSuffix

        # Reconstitute functions
        ${function:Get-SemverTags} = $using:funcGetSemverTagsP1
        ${function:Get-LocalTagName} = $using:funcGetLocalTagNameP1
        ${function:Get-TerraformFiles} = $using:funcGetTerraformFilesP1
        ${function:Get-RepoNameFromRegistrySource} = $using:funcGetRepoNameFromRegistrySourceP1
        ${function:Get-TargetRepoUrl} = $using:funcGetTargetRepoUrlP1
        ${function:Get-SourceGitHubUrl} = $using:funcGetSourceGitHubUrlP1
        ${function:Get-ModuleDependencies} = $using:funcGetModuleDependenciesP1
        ${function:Get-DetailedModuleDependencies} = $using:funcGetDetailedModuleDependenciesP1

        $result = @{
            RepoName = $repoName
            RepoPath = $repoPath
            Success = $false
            GraphEntry = $null
            RequiredDependencies = @()
            Messages = @()
        }

        Push-Location -Path $repoPath
        try {
            # Fetch all tags
            git fetch --tags 2>&1 | Out-Null

            # Get all tags in the repository
            $tags = git tag -l 2>&1
            if (-not $tags) {
                $result.Messages += "No tags found"
                $result.Success = $true
                Pop-Location
                return $result
            }

            $tagList = Get-SemverTags -TagsOutput $tags -SemverPattern $semverPat -ExcludeSuffix $tagSuffix
            $result.Messages += "Found $($tagList.Count) semver tags"

            # Initialize graph entry
            $graphEntry = @{
                moduleName = $repoName
                path = $repoPath
                originalSourceGitRepo = (Get-SourceGitHubUrl -RepoName $repoName -BaseUrl $srcBaseUrl)
                newGitRepo = (Get-TargetRepoUrl -RepoName $repoName -BaseUrl $targetBaseUrl -Prefix $targetPrefix)
                tags = @{}
            }

            $allDependencies = @()

            foreach ($tag in $tagList) {
                $tag = $tag.Trim()
                if (-not $tag) { continue }

                # Checkout the tag
                git checkout $tag 2>&1 | Out-Null
                if ($LASTEXITCODE -ne 0) {
                    continue
                }

                $localTagName = Get-LocalTagName -Version $tag -Suffix $tagSuffix

                # Get detailed dependencies
                $detailedDeps = Get-DetailedModuleDependencies -Path $repoPath -SourcePattern $srcPattern -VersionPattern $verPattern `
                    -TargetBaseUrl $targetBaseUrl -TargetPrefix $targetPrefix -SourceBaseUrl $srcBaseUrl -TagSuffix $tagSuffix

                # Add tag entry
                $graphEntry.tags[$localTagName] = @{
                    originalTag = $tag
                    localTag = $localTagName
                    dependencies = $detailedDeps
                }

                # Collect dependencies for cloning
                $tagDeps = Get-ModuleDependencies -Path $repoPath -SourcePattern $srcPattern
                $allDependencies += $tagDeps
            }

            # Return to main branch
            git checkout main 2>&1 | Out-Null

            $result.GraphEntry = $graphEntry
            $result.RequiredDependencies = $allDependencies | Select-Object -Unique
            $result.Success = $true

        } catch {
            $result.Messages += "Error: $_"
        } finally {
            Pop-Location
        }

        $result
    }

    # Process results sequentially - merge graph entries and clone missing dependencies
    $allRequiredDeps = @()
    foreach ($result in $phase1Results) {
        $checkedRepos[$result.RepoName] = $true

        if ($result.Messages.Count -gt 0) {
            Write-Host "    $($result.RepoName): $($result.Messages -join ', ')"
        }

        if ($result.GraphEntry) {
            $dependencyGraph[$result.RepoName] = $result.GraphEntry
        }

        $allRequiredDeps += $result.RequiredDependencies
    }

    # Clone any missing dependencies from source, then add upstream remote for target
    $uniqueDeps = $allRequiredDeps | Select-Object -Unique
    $newlyCloned = 0
    foreach ($dep in $uniqueDeps) {
        $depPath = Join-Path -Path $destinationPath -ChildPath $dep
        if (-not (Test-Path -Path $depPath)) {
            Write-Host "      Cloning dependency: $dep"
            $cloneUrl = "$sourceGitBaseUrl/$dep.git"
            git clone $cloneUrl $depPath 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                $newlyCloned++
                # Add upstream remote for target and try to fetch tags
                $targetRepoUrl = "$targetGitBaseUrl/$targetGitRepositoryNamePrefix$dep.git"
                Push-Location -Path $depPath
                git remote add upstream $targetRepoUrl 2>&1 | Out-Null
                git fetch upstream --tags 2>&1 | Out-Null
                Pop-Location
            } else {
                Write-Warning "      Failed to clone $dep"
            }
        }
    }

    $reposAfterPass = (Get-ChildItem -Path $destinationPath -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne "dependency-graphs" }).Count
    $newReposThisPass = $reposAfterPass - $reposBeforePass

    if ($newReposThisPass -gt 0) {
        Write-Host "    Cloned $newReposThisPass new dependency repositories"
    }

    $passNumber++
} while ($newReposThisPass -gt 0)

$finalRepoCount = (Get-ChildItem -Path $destinationPath -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne "dependency-graphs" }).Count
$totalNewRepos = $finalRepoCount - $initialRepoCount

if ($totalNewRepos -gt 0) {
    Write-Host "  Total: Cloned $totalNewRepos dependency repositories"
} else {
    Write-Host "  All dependencies already present"
}

# Get list of repos in destination (the dependency graph)
$syncedRepoNames = Get-ChildItem -Path $destinationPath -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne "dependency-graphs" } |
    Select-Object -ExpandProperty Name |
    Sort-Object

# Find orphaned repos (repos tracked in sync state but not in current dependency graph)
$trackedRepos = @($syncState.syncedRepos)
$orphanedRepos = $trackedRepos | Where-Object { $_ -notin $syncedRepoNames }

# Filter out repos that are already in the kept repos list
$orphansToPrompt = $orphanedRepos | Where-Object { $_ -notin $keptRepos }

# Check for orphaned repos and prompt user
if ($orphansToPrompt.Count -gt 0 -and -not $skipOrphanCheck) {
    Write-Host "`n" -NoNewline
    Write-Warning "Found $($orphansToPrompt.Count) repositories in destination that are not in the current filter/dependency graph:"
    Write-Host ""
    foreach ($orphan in $orphansToPrompt) {
        Write-Host "  - $orphan"
    }
    Write-Host ""

    $reposToDelete = @()
    $reposToKeep = @()

    foreach ($orphan in $orphansToPrompt) {
        Write-Host "Repository '$orphan' is not in the current dependency graph."
        $response = Read-Host "  Delete this repo? [y]es / [n]o / [r]emember to keep / [s]kip all remaining"

        switch ($response.ToLower()) {
            'y' {
                $reposToDelete += $orphan
                Write-Host "    -> Will delete"
            }
            'yes' {
                $reposToDelete += $orphan
                Write-Host "    -> Will delete"
            }
            'r' {
                $reposToKeep += $orphan
                $keptRepos += $orphan
                Write-Host "    -> Will keep and remember"
            }
            'remember' {
                $reposToKeep += $orphan
                $keptRepos += $orphan
                Write-Host "    -> Will keep and remember"
            }
            's' {
                # Skip all remaining - add all unprocessed orphans to keep
                $remainingOrphans = $orphansToPrompt | Where-Object {
                    $_ -notin $reposToDelete -and $_ -notin $reposToKeep -and $_ -ne $orphan
                }
                $reposToKeep += $orphan
                $reposToKeep += $remainingOrphans
                Write-Host "    -> Will keep all remaining orphaned repos"
                break
            }
            'skip' {
                $remainingOrphans = $orphansToPrompt | Where-Object {
                    $_ -notin $reposToDelete -and $_ -notin $reposToKeep -and $_ -ne $orphan
                }
                $reposToKeep += $orphan
                $reposToKeep += $remainingOrphans
                Write-Host "    -> Will keep all remaining orphaned repos"
                break
            }
            default {
                $reposToKeep += $orphan
                Write-Host "    -> Will keep"
            }
        }
    }

    # Delete repos the user chose to delete
    if ($reposToDelete.Count -gt 0) {
        Write-Host "`nDeleting $($reposToDelete.Count) orphaned repositories..."
        foreach ($repoToDelete in $reposToDelete) {
            $repoPath = Join-Path -Path $destinationPath -ChildPath $repoToDelete
            if (Test-Path -Path $repoPath) {
                Remove-Item -Path $repoPath -Recurse -Force
                Write-Host "  Deleted: $repoToDelete"
            }
        }
    }

    # Ask if user wants to remember any repos they chose to keep (but didn't explicitly remember)
    $reposKeptButNotRemembered = $reposToKeep | Where-Object { $_ -notin $keptRepos }
    if ($reposKeptButNotRemembered.Count -gt 0) {
        Write-Host "`nYou kept $($reposKeptButNotRemembered.Count) repos without choosing to remember them."
        $rememberResponse = Read-Host "Would you like to remember all of them to avoid future prompts? [y]es / [n]o"
        if ($rememberResponse.ToLower() -eq 'y' -or $rememberResponse.ToLower() -eq 'yes') {
            $keptRepos += $reposKeptButNotRemembered
            Write-Host "  -> Will remember all kept repos"
        }
    }

    # Save updated kept repos list to sync state
    if ($keptRepos.Count -gt 0) {
        # Remove duplicates
        $keptRepos = $keptRepos | Select-Object -Unique | Sort-Object
        $syncState.keptRepos = @($keptRepos)
        Save-SyncState -State $syncState -FilePath $syncStateFilePath
        Write-Host "  Saved $($keptRepos.Count) kept repos to sync state"
    }

    # Refresh the list of destination repos after deletion
    $existingDestRepos = @()
    if (Test-Path -Path $destinationPath) {
        $existingDestRepos = Get-ChildItem -Path $destinationPath -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -ne "dependency-graphs" } |
            Select-Object -ExpandProperty Name |
            Sort-Object
    }
} elseif ($orphanedRepos.Count -gt 0 -and $skipOrphanCheck) {
    Write-Host "`nSkipping orphan check (skipOrphanCheck flag set). $($orphanedRepos.Count) orphaned repos will be kept."
} elseif ($orphanedRepos.Count -gt 0 -and $orphansToPrompt.Count -eq 0) {
    Write-Host "`nFound $($orphanedRepos.Count) orphaned repos, but all are in the kept repos list. Skipping prompts."
}

# Output dependency graph as JSON files (one per repo)
if ($dependencyGraph.Count -gt 0) {
    $graphOutputFolder = Join-Path -Path $destinationPath -ChildPath "dependency-graphs"

    # Remove and recreate the folder on each run to ensure fresh output
    if (Test-Path -Path $graphOutputFolder) {
        Remove-Item -Path $graphOutputFolder -Recurse -Force | Out-Null
    }
    New-Item -ItemType Directory -Path $graphOutputFolder -Force | Out-Null

    Write-Host "  Writing dependency graphs to: $graphOutputFolder"

    foreach ($repoKey in $dependencyGraph.Keys) {
        $repoData = $dependencyGraph[$repoKey]
        $tagsArray = @()
        foreach ($tagKey in $repoData.tags.Keys) {
            $tagData = $repoData.tags[$tagKey]
            $tagsArray += @{
                originalTag = $tagData.originalTag
                localTag = $tagData.localTag
                dependencies = $tagData.dependencies
            }
        }

        $repoGraph = @{
            moduleName = $repoData.moduleName
            path = $repoData.path
            originalSourceGitRepo = $repoData.originalSourceGitRepo
            newGitRepo = $repoData.newGitRepo
            tags = $tagsArray
        }

        $repoJsonPath = Join-Path -Path $graphOutputFolder -ChildPath "$repoKey.json"
        $repoGraph | ConvertTo-Json -Depth 10 | Set-Content -Path $repoJsonPath -Encoding UTF8
    }

    Write-Host "  Written $($dependencyGraph.Count) dependency graph files"
}

# Get list of all repos to process (including dependencies, excluding special folders)
$allReposToProcess = Get-ChildItem -Path $destinationPath -Directory |
    Where-Object { $_.Name -ne "dependency-graphs" } |
    Select-Object -ExpandProperty Name |
    Sort-Object

# Phase 2: Update module references in Terraform files for each tag
Write-Host "`nPhase 2: Updating module references in Terraform files for each tag..."
Write-Host "  Processing $($allReposToProcess.Count) repositories (parallel limit: $parallelCloneLimit)..."

# Convert functions to strings for passing to parallel blocks
$funcGetSemverTags = ${function:Get-SemverTags}.ToString()
$funcGetLocalTagName = ${function:Get-LocalTagName}.ToString()
$funcGetTerraformFiles = ${function:Get-TerraformFiles}.ToString()
$funcGetRepoNameFromRegistrySource = ${function:Get-RepoNameFromRegistrySource}.ToString()
$funcGetTargetRepoUrl = ${function:Get-TargetRepoUrl}.ToString()

$phase2Results = $allReposToProcess | ForEach-Object -ThrottleLimit $parallelCloneLimit -Parallel {
    $repoName = $_
    $destPath = $using:destinationPath
    $srcPattern = $using:sourcePattern
    $verPattern = $using:versionPattern
    $semverPat = $using:semverPattern
    $targetProtocol = $using:targetGitRepositoryProtocol
    $targetDomain = $using:targetGitRepositoryDomain
    $targetOrg = $using:targetGitRepositoryOrganizationName
    $targetPrefix = $using:targetGitRepositoryNamePrefix
    $tagSuffix = $using:localTagSuffix

    # Reconstitute functions from strings
    ${function:Get-SemverTags} = $using:funcGetSemverTags
    ${function:Get-LocalTagName} = $using:funcGetLocalTagName
    ${function:Get-TerraformFiles} = $using:funcGetTerraformFiles
    ${function:Get-RepoNameFromRegistrySource} = $using:funcGetRepoNameFromRegistrySource
    ${function:Get-TargetRepoUrl} = $using:funcGetTargetRepoUrl

    $result = @{
        RepoName = $repoName
        TagsCreated = 0
        TagsSkipped = 0
        Errors = 0
        Messages = @()
    }

    $repoPath = Join-Path -Path $destPath -ChildPath $repoName

    if (-not (Test-Path -Path $repoPath)) {
        $result.Messages += "Repository path not found: $repoPath"
        $result.Errors++
        return $result
    }

    Push-Location -Path $repoPath
    try {
        # Fetch all tags
        git fetch --tags 2>&1 | Out-Null

        # Get all tags in the repository
        $tags = git tag -l 2>&1
        if (-not $tags) {
            $result.Messages += "No tags found, skipping..."
            Pop-Location
            return $result
        }

        $tagList = Get-SemverTags -TagsOutput $tags -SemverPattern $semverPat -ExcludeSuffix $tagSuffix
        $result.Messages += "Found $($tagList.Count) semver tags to process"

        foreach ($tag in $tagList) {
            $tag = $tag.Trim()
            if (-not $tag) { continue }

            # Normalize tag to always have v prefix for the suffixed version
            $localTag = Get-LocalTagName -Version $tag -Suffix $tagSuffix

            # Check if local tag already exists
            $existingLocalTag = git tag -l $localTag 2>&1
            if ($existingLocalTag) {
                $result.TagsSkipped++
                continue
            }

            # Checkout the tag
            git checkout $tag 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                $result.Messages += "Failed to checkout tag '$tag'"
                $result.Errors++
                continue
            }

            # Find all .tf files in the repository (excluding examples folder)
            $tfFiles = Get-TerraformFiles -Path $repoPath
            $anyModified = $false

            foreach ($tfFile in $tfFiles) {
                $content = Get-Content -Path $tfFile.FullName -Raw
                if (-not $content) { continue }

                $originalContent = $content
                $modified = $false

                # Find all module blocks with registry sources
                $sourceMatches = [regex]::Matches($content, $srcPattern)

                foreach ($sourceMatch in $sourceMatches) {
                    $fullSourceMatch = $sourceMatch.Value
                    $prefix = $sourceMatch.Groups[1].Value
                    $source = $sourceMatch.Groups[2].Value
                    $suffix = $sourceMatch.Groups[3].Value

                    # Convert registry source to repo name
                    $targetRepoName = Get-RepoNameFromRegistrySource -Source $source
                    if (-not $targetRepoName) { continue }

                    # Look for a version attribute after this source line
                    $sourceEndIndex = $sourceMatch.Index + $sourceMatch.Length
                    $remainingContent = $content.Substring($sourceEndIndex)

                    # Find version within the next ~500 chars (should be within same module block)
                    $versionMatch = [regex]::Match($remainingContent.Substring(0, [Math]::Min(500, $remainingContent.Length)), $verPattern)

                    $version = ""
                    if ($versionMatch.Success) {
                        $version = $versionMatch.Groups[3].Value
                        # Remove the version line from content (keep the leading newline)
                        $versionLineStart = $sourceEndIndex + $versionMatch.Index + $versionMatch.Groups[1].Length
                        $versionLineLength = $versionMatch.Groups[2].Length
                        $content = $content.Remove($versionLineStart, $versionLineLength)
                    }

                    # Use git reference with version as ref (with suffix, always v-prefixed) if available
                    if ($version) {
                        $localVersionTag = Get-LocalTagName -Version $version -Suffix $tagSuffix
                        $newSource = "git::$targetProtocol$targetDomain/$targetOrg/$targetPrefix$targetRepoName.git?ref=$localVersionTag"
                    } else {
                        $newSource = "git::$targetProtocol$targetDomain/$targetOrg/$targetPrefix$targetRepoName.git"
                    }

                    $newSourceLine = "$prefix$newSource$suffix"
                    $content = $content.Replace($fullSourceMatch, $newSourceLine)
                    $modified = $true
                }

                if ($modified -and $content -ne $originalContent) {
                    Set-Content -Path $tfFile.FullName -Value $content -NoNewline
                    $anyModified = $true
                }
            }

            if ($anyModified) {
                # Stage all changes
                git add -A 2>&1 | Out-Null

                # Create commit
                git commit -m "Update module references to local git sources for tag $tag" 2>&1 | Out-Null

                # Create the local tag
                git tag $localTag 2>&1 | Out-Null

                if ($LASTEXITCODE -eq 0) {
                    $result.Messages += "Created tag: $localTag"
                    $result.TagsCreated++
                } else {
                    $result.Messages += "Failed to create tag: $localTag"
                    $result.Errors++
                }
            } else {
                # No changes needed, just create the tag pointing to the same commit
                git tag $localTag 2>&1 | Out-Null
                $result.Messages += "Created tag: $localTag (no module changes needed)"
                $result.TagsCreated++
            }
        }

        # Return to main branch
        git checkout main 2>&1 | Out-Null

    } catch {
        $result.Messages += "Error processing: $_"
        $result.Errors++
    } finally {
        Pop-Location
    }

    $result
}

# Aggregate Phase 2 results
$totalTagsCreated = 0
$totalTagsSkipped = 0
$totalErrors = 0

foreach ($result in $phase2Results) {
    $totalTagsCreated += $result.TagsCreated
    $totalTagsSkipped += $result.TagsSkipped
    $totalErrors += $result.Errors

    if ($result.Messages.Count -gt 0) {
        Write-Host "`n  $($result.RepoName):"
        foreach ($msg in $result.Messages) {
            Write-Host "    $msg"
        }
    }
}

Write-Host "`nModule reference update complete: $totalTagsCreated tags created, $totalTagsSkipped skipped, $totalErrors errors"

# Phase 3: Set up upstream remote and push repos/tags to target
Write-Host "`nPhase 3: Pushing repositories and tags to target (parallel limit: $parallelCloneLimit)..."

# Determine target platform type
$isGitHub = $targetGitRepositoryDomain -match "github\.com"
$isAzureDevOps = $targetGitRepositoryDomain -match "dev\.azure\.com|visualstudio\.com"

# Pre-check CLI availability and auth status (only once, not per repo)
$ghAvailable = $false
$ghLoggedIn = $false
$azAvailable = $false
$azLoggedIn = $false

if ($isGitHub) {
    $ghAvailable = $null -ne (Get-Command gh -ErrorAction SilentlyContinue)
    if ($ghAvailable) {
        gh auth status 2>&1 | Out-Null
        $ghLoggedIn = $LASTEXITCODE -eq 0
        if (-not $ghLoggedIn) {
            Write-Warning "Not logged in to GitHub CLI. Run 'gh auth login' first. Repos will not be auto-created."
        }
    } else {
        Write-Warning "GitHub CLI (gh) not found. Repos will not be auto-created."
    }
}

if ($isAzureDevOps) {
    $azAvailable = $null -ne (Get-Command az -ErrorAction SilentlyContinue)
    if ($azAvailable) {
        az account show 2>&1 | Out-Null
        $azLoggedIn = $LASTEXITCODE -eq 0
        if (-not $azLoggedIn) {
            Write-Warning "Not logged in to Azure CLI. Run 'az login' first. Repos will not be auto-created."
        }
    } else {
        Write-Warning "Azure CLI (az) not found. Repos will not be auto-created."
    }
}

# Pre-parse ADO org/project for Phase 3 parallel block
$adoOrgForPhase3 = ""
$adoProjectForPhase3 = ""
$adoOrgUrlForPhase3 = ""
if ($isAzureDevOps) {
    $adoInfoForPhase3 = Get-AdoOrgAndProject -Protocol $targetGitRepositoryProtocol -Domain $targetGitRepositoryDomain -OrganizationName $targetGitRepositoryOrganizationName
    if ($adoInfoForPhase3.Valid) {
        $adoOrgForPhase3 = $adoInfoForPhase3.Org
        $adoProjectForPhase3 = $adoInfoForPhase3.Project
        $adoOrgUrlForPhase3 = $adoInfoForPhase3.OrgUrl
    }
}

$phase3Results = $allReposToProcess | ForEach-Object -ThrottleLimit $parallelCloneLimit -Parallel {
    $repoName = $_
    $destPath = $using:destinationPath
    $targetBaseUrl = $using:targetGitBaseUrl
    $targetPrefix = $using:targetGitRepositoryNamePrefix
    $targetOrg = $using:targetGitRepositoryOrganizationName
    $repoVisibility = $using:targetRepositoryVisibility
    $isGH = $using:isGitHub
    $isADO = $using:isAzureDevOps
    $ghOk = $using:ghAvailable
    $ghAuth = $using:ghLoggedIn
    $azOk = $using:azAvailable
    $azAuth = $using:azLoggedIn
    $adoOrg = $using:adoOrgForPhase3
    $adoProject = $using:adoProjectForPhase3
    $adoOrgUrl = $using:adoOrgUrlForPhase3

    # Reconstitute function from string
    ${function:Get-TargetRepoUrl} = $using:funcGetTargetRepoUrl

    $targetRepoFullName = "$targetPrefix$repoName"
    $targetRemoteUrl = Get-TargetRepoUrl -RepoName $repoName -BaseUrl $targetBaseUrl -Prefix $targetPrefix

    $result = @{
        RepoName = $repoName
        TargetRepoName = $targetRepoFullName
        TargetUrl = $targetRemoteUrl
        Success = $false
        Failed = $false
        FailReason = ""
        Messages = @()
    }

    $repoPath = Join-Path -Path $destPath -ChildPath $repoName

    if (-not (Test-Path -Path $repoPath)) {
        return $result
    }

    # Check/create repo on target platform
    $repoReady = $true

    if ($isGH -and $ghOk -and $ghAuth) {
        # Check if repo exists
        gh repo view "$targetOrg/$targetRepoFullName" 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            # Try to create the repo with specified visibility
            $result.Messages += "Creating GitHub repository: $targetOrg/$targetRepoFullName (visibility: $repoVisibility)"
            $createResult = gh repo create "$targetOrg/$targetRepoFullName" --$repoVisibility --confirm 2>&1
            if ($LASTEXITCODE -eq 0) {
                $result.Messages += "Successfully created repository"
            } else {
                $result.Messages += "Failed to create repository: $createResult"
                $repoReady = $false
            }
        } else {
            $result.Messages += "Repository already exists"
        }
    } elseif ($isADO -and $azOk -and $azAuth -and $adoOrg -and $adoProject) {
        # Check if repo exists
        az repos show --repository $targetRepoFullName --org $adoOrgUrl --project $adoProject 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            # Try to create the repo
            $result.Messages += "Creating Azure DevOps repository: $targetRepoFullName in $adoOrg/$adoProject"
            $createResult = az repos create --name $targetRepoFullName --org $adoOrgUrl --project $adoProject 2>&1
            if ($LASTEXITCODE -eq 0) {
                $result.Messages += "Successfully created repository"
            } else {
                $result.Messages += "Failed to create repository: $createResult"
                $repoReady = $false
            }
        } else {
            $result.Messages += "Repository already exists"
        }
    } elseif ($isADO -and $azOk -and $azAuth) {
        $result.Messages += "Invalid Azure DevOps organization format. Expected: org/project"
        $repoReady = $false
    }

    if (-not $repoReady -and ($isGH -or $isADO)) {
        $result.Failed = $true
        $result.FailReason = "Failed to create repository"
        return $result
    }

    Push-Location -Path $repoPath
    try {
        # Check if 'upstream' remote already exists
        $existingUpstream = git remote get-url upstream 2>&1
        if ($LASTEXITCODE -ne 0) {
            # Remote doesn't exist, add it
            $result.Messages += "Adding upstream remote: $targetRemoteUrl"
            git remote add upstream $targetRemoteUrl 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                $result.Failed = $true
                $result.FailReason = "Failed to add upstream remote"
                Pop-Location
                return $result
            }
        } else {
            # Check if it points to the correct URL
            if ($existingUpstream -ne $targetRemoteUrl) {
                $result.Messages += "Updating upstream remote to: $targetRemoteUrl"
                git remote set-url upstream $targetRemoteUrl 2>&1 | Out-Null
            } else {
                $result.Messages += "Upstream remote already configured"
            }
        }

        # Push main branch to upstream
        $pushResult = git push upstream main 2>&1
        $pushFailed = $false
        if ($LASTEXITCODE -ne 0) {
            if ($pushResult -match "up-to-date|Everything up to date") {
                $result.Messages += "Main branch already up-to-date"
            } else {
                $result.Messages += "Failed to push main branch: $pushResult"
                $pushFailed = $true
            }
        } else {
            $result.Messages += "Main branch pushed"
        }

        # Push all tags to upstream
        $tagPushResult = git push upstream --tags 2>&1
        if ($LASTEXITCODE -ne 0) {
            if ($tagPushResult -match "up-to-date|Everything up to date") {
                $result.Messages += "Tags already up-to-date"
            } else {
                $result.Messages += "Failed to push tags: $tagPushResult"
                $pushFailed = $true
            }
        } else {
            $result.Messages += "Tags pushed successfully"
        }

        if ($pushFailed) {
            $result.Failed = $true
            if (-not $isGH -and -not $isADO) {
                $result.FailReason = "Push failed - repository may need to be created manually"
            } else {
                $result.FailReason = "Push failed"
            }
        } else {
            $result.Success = $true
        }

    } catch {
        $result.Failed = $true
        $result.FailReason = "Exception: $_"
    } finally {
        Pop-Location
    }

    $result
}

# Aggregate Phase 3 results
$pushSuccessCount = 0
$pushFailCount = 0
$failedRepos = @()

foreach ($result in $phase3Results) {
    if ($result.Success) {
        $pushSuccessCount++
    }
    if ($result.Failed) {
        $pushFailCount++
        $failedRepos += @{
            repoName = $result.RepoName
            targetRepoName = $result.TargetRepoName
            targetUrl = $result.TargetUrl
            reason = $result.FailReason
            details = $result.Messages
        }
    }

    if ($result.Messages.Count -gt 0) {
        Write-Host "  $($result.RepoName):"
        foreach ($msg in $result.Messages) {
            Write-Host "    $msg"
        }
    }
}

Write-Host "`nPush complete: $pushSuccessCount repositories processed, $pushFailCount failed"

# Output failed repos to file if any
if ($failedRepos.Count -gt 0) {
    $failedReposPath = Join-Path -Path $destinationPath -ChildPath "failed-repos.json"
    $failedRepos | ConvertTo-Json -Depth 5 | Set-Content -Path $failedReposPath -Encoding UTF8

    Write-Host "`n" -NoNewline
    Write-Warning "The following repositories failed and may need to be created manually:"
    Write-Host ""
    foreach ($failed in $failedRepos) {
        Write-Host "  - $($failed.targetRepoName)"
        Write-Host "    URL: $($failed.targetUrl)"
        Write-Host "    Reason: $($failed.reason)"
        Write-Host ""
    }
    Write-Host "Full details written to: $failedReposPath"
}

# Save sync state with all processed repos (including failed ones, so cleanup can delete them)
$allProcessedRepoNames = $phase3Results | ForEach-Object { $_.RepoName }
if ($allProcessedRepoNames.Count -gt 0) {
    # Add all processed repos to syncedRepos (even failed ones need to be tracked for cleanup)
    $existingSyncedRepos = @($syncState.syncedRepos)
    $allSyncedRepos = ($existingSyncedRepos + $allProcessedRepoNames) | Select-Object -Unique | Sort-Object
    $syncState.syncedRepos = @($allSyncedRepos)
    $syncState.lastSyncAt = (Get-Date).ToUniversalTime().ToString("o")
    $syncState.targetConfig = @{
        protocol = $targetGitRepositoryProtocol
        domain = $targetGitRepositoryDomain
        organization = $targetGitRepositoryOrganizationName
        prefix = $targetGitRepositoryNamePrefix
    }
    Save-SyncState -State $syncState -FilePath $syncStateFilePath
    Write-Host "`nSync state updated: $($allSyncedRepos.Count) total repos tracked in sync state"
}