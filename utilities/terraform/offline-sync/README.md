# Azure Verified Modules (AVM) Offline Sync Example Script

> [!WARNING]
> This script is an example intended for advanced users familiar with PowerShell, Git, and Terraform module management. It is provided as-is and not supported for production use.

A PowerShell script to synchronize Azure Verified Modules (AVM) Terraform repositories from GitHub to a target git server, converting Terraform registry module references to git-based references for offline or air-gapped environments. This process is also commonly referred to as **inner sourcing**.

## Overview

This script enables organizations to:

- **Mirror AVM modules** from the official Azure GitHub organization to your own git server
- **Convert module sources** from Terraform registry format to git references
- **Resolve dependencies** automatically, ensuring all required modules are included
- **Create versioned releases** with `-local` suffixed tags for each original version
- **Support multiple targets** including GitHub, Azure DevOps, GitLab, or any git server

## Prerequisites

### Required Software

| Software | Minimum Version | Purpose | Installation |
|----------|-----------------|---------|--------------|
| **PowerShell** | 7.0+ | Script execution with parallel processing | [Install PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell) |
| **Git** | 2.0+ | Repository cloning and management | [Install Git](https://git-scm.com/downloads) |

### Optional Software (for automatic repository creation)

| Software | Purpose | Installation |
|----------|---------|--------------|
| **GitHub CLI (gh)** | Auto-create repos on GitHub targets | [Install GitHub CLI](https://cli.github.com/) |
| **Azure CLI (az)** | Auto-create repos on Azure DevOps targets | [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) |

### Verification Commands

```powershell
# Check PowerShell version (must be 7+)
$PSVersionTable.PSVersion

# Check Git installation
git --version

# Check GitHub CLI (optional)
gh --version

# Check Azure CLI (optional)
az --version
```

### Authentication Setup

#### For GitHub Targets

```powershell
# Authenticate with GitHub CLI
gh auth login

# Verify authentication
gh auth status
```

#### For Azure DevOps Targets

```powershell
# Login to Azure
az login

# Set default organization (optional)
az devops configure --defaults organization=https://dev.azure.com/your-org
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `destinationDirectoryPath` | string | `~/avm-modules` | Local directory where repositories will be cloned |
| `targetGitRepositoryProtocol` | string | `https://` | Protocol for target git URL (`https://` or `git@`) |
| `targetGitRepositoryDomain` | string | `github.com` | Domain of target git server |
| `targetGitRepositoryOrganizationName` | string | `""` | Organization/namespace on target server |
| `targetGitRepositoryNamePrefix` | string | `""` | Optional prefix for repository names on target |
| `sourceRepositoryOrganizationName` | string | `Azure` | GitHub organization to search for source repos |
| `sourceRepositoryPrefixes` | string[] | `@("terraform-azurerm-avm-", ...)` | Repository name prefixes to search for |
| `moduleFilters` | string[] | `@()` | Regex patterns to filter repositories. Use `@()` for all modules |
| `parallelCloneLimit` | int | `10` | Maximum parallel operations |
| `forceLocalRepoCloneRefresh` | switch | `$false` | Remove local destination directory and start fresh |
| `forceRemoteRepoRefresh` | switch | `$false` | Delete tracked remote repos and start fresh |
| `skipVerification` | switch | `$false` | Skip confirmation prompt before deleting repos |
| `syncStateFilePath` | string | `.sync-state.json` | Path to JSON file tracking sync state |
| `skipOrphanCheck` | switch | `$false` | Skip prompting about orphaned repos not in current filter |
| `targetRepositoryVisibility` | string | `private` | Visibility for new repos: `private`, `internal`, or `public` |
| `cleanLocalAndRemote` | switch | `$false` | Clean all local and tracked remote repos, then exit |
| `localTagSuffix` | string | `-local` | Suffix appended to version tags (e.g., `-local`, `-synced`, `-internal`) |

## Usage Examples

### Basic Usage

Sync ALZ pattern modules to your GitHub organization:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-ptn-alz-")
```

### Sync All AVM Modules

Use an empty array to sync all AVM modules:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @()
```

### Sync to Azure DevOps

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryDomain "dev.azure.com" `
    -targetGitRepositoryOrganizationName "contoso/terraform-modules" `
    -moduleFilters @()
```

### Sync Specific Module Categories

Sync only compute and storage resource modules:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-res-compute", "avm-res-storage")
```

### Use SSH Protocol

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryProtocol "git@" `
    -targetGitRepositoryDomain "github.com:" `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @()
```

### Custom Destination with Force Refresh

```powershell
.\Invoke-ModuleSync.ps1 `
    -destinationDirectoryPath "C:\terraform\avm-local" `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-ptn-alz-") `
    -forceLocalRepoCloneRefresh
```

### Self-Hosted GitLab with Name Prefix

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryDomain "gitlab.internal.company.com" `
    -targetGitRepositoryOrganizationName "infrastructure/terraform" `
    -targetGitRepositoryNamePrefix "azure-" `
    -moduleFilters @()
```

### High Parallelism for Large Syncs

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @() `
    -parallelCloneLimit 20
```

### Complete Fresh Start (Delete Remote Repos)

Delete all upstream repositories and recreate them:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-ptn-alz-") `
    -forceRemoteRepoRefresh
```

### Automated CI/CD with No Prompts

For automated pipelines, skip the deletion confirmation:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @() `
    -forceRemoteRepoRefresh `
    -skipVerification
```

> **Important for Automation:** The script maintains a `.sync-state.json` file that tracks which repositories have been synced. If running in CI/CD pipelines, you must persist this file between runs (e.g., store it as a pipeline artifact or in a persistent storage location). Without the sync state file, the script cannot track previously synced repositories, which affects cleanup operations and orphan detection. Use the `-syncStateFilePath` parameter to specify a persistent location.

### Clean Up Everything

Delete all tracked local and remote repositories, then exit:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -cleanLocalAndRemote
```

### Skip Orphan Checks in CI/CD

For automation, skip prompts about orphaned repos:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-ptn-alz-") `
    -skipOrphanCheck
```

### Create Public Repositories

Set visibility for newly created target repositories:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-ptn-alz-") `
    -targetRepositoryVisibility "public"
```

### Custom Tag Suffix

Use a custom suffix instead of the default `-local`:

```powershell
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-ptn-alz-") `
    -localTagSuffix "-synced"
```

This creates tags like `v1.0.0-synced` instead of `v1.0.0-local`.

## How It Works

The script operates in three phases:

### Phase 1: Dependency Resolution

1. **Query GitHub API** to find AVM repositories matching the specified prefixes
2. **Apply filters** to narrow down to desired modules
3. **Clone or update repositories** directly in the destination folder from source (GitHub)
4. **Add upstream remote** pointing to your target git server and fetch existing tags
5. **Scan all tags** in each repository for module dependencies
6. **Recursively clone** any missing dependency repositories
7. **Iterate** until all dependencies are resolved

### Phase 2: Module Source Conversion (Parallel)

For each repository and each semantic version tag:

1. **Check for existing** suffixed tag (skip if already processed)
2. **Checkout** the original tag
3. **Find all module blocks** in `.tf` files (excluding `examples/` folder)
4. **Convert sources** from Terraform registry format to git references:

   **Before:**
   ```hcl
   module "network" {
     source  = "Azure/avm-res-network-virtualnetwork/azurerm"
     version = "0.2.0"
   }
   ```

   **After (with default `-local` suffix):**
   ```hcl
   module "network" {
     source = "git::https://github.com/my-org/terraform-azurerm-avm-res-network-virtualnetwork.git?ref=v0.2.0-local"
   }
   ```

5. **Commit changes** and create a new tag with the configured suffix (e.g., `v0.1.0` → `v0.1.0-local`)

### Phase 3: Push to Target (Parallel)

For each repository:

1. **Check/create** the repository on the target platform (GitHub/Azure DevOps)
2. **Configure** the `upstream` remote pointing to the target
3. **Push** the main branch
4. **Push** all tags (including suffixed versions)

## Output Files

The script creates several outputs in the destination directory:

```
~/avm-modules/
├── .sync-state.json                         # Sync state tracking file
├── terraform-azurerm-avm-ptn-alz/           # Cloned repository
├── terraform-azurerm-avm-res-network-.../   # Dependency repository
├── dependency-graphs/
│   ├── terraform-azurerm-avm-ptn-alz.json   # Dependency graph per repo
│   └── ...
└── failed-repos.json                         # List of failed pushes (if any)
```

### Sync State File Format

The `.sync-state.json` file tracks:

```json
{
  "description": "Sync state for AVM module synchronization. Do not edit manually.",
  "syncedRepos": [
    "terraform-azurerm-avm-ptn-alz",
    "terraform-azurerm-avm-res-network-virtualnetwork"
  ],
  "keptRepos": [
    "terraform-azurerm-avm-res-old-module"
  ],
  "lastSyncAt": "2026-01-12T10:30:00.0000000Z",
  "targetConfig": {
    "protocol": "https://",
    "domain": "github.com",
    "organization": "my-org",
    "prefix": ""
  }
}
```

This file is used by `-cleanLocalAndRemote` and `-forceRemoteRepoRefresh` to know which remote repositories to delete.

### Dependency Graph Format

Each JSON file in `dependency-graphs/` contains:

```json
{
  "repository": "terraform-azurerm-avm-ptn-alz",
  "modules": {
    "module.management_groups": {
      "source": "Azure/avm-ptn-management-groups/azurerm",
      "version": "0.1.0",
      "resolvedRepository": "terraform-azurerm-avm-ptn-management-groups",
      "file": "main.tf",
      "line": 15
    }
  }
}
```

## Module Filter Patterns

The `moduleFilters` parameter accepts regex patterns:

| Pattern | Matches |
|---------|---------|
| `@()` | All modules (no filtering) |
| `@("avm-res-")` | All resource modules |
| `@("avm-ptn-")` | All pattern modules |
| `@("avm-utl-")` | All utility modules |
| `@("avm-ptn-alz")` | ALZ pattern module only |
| `@("avm-res-compute", "avm-res-network")` | Compute and network modules |
| `@("virtualmachine", "virtualnetwork")` | Modules containing these terms |

## Target Platform Formats

### GitHub

```powershell
-targetGitRepositoryProtocol "https://"
-targetGitRepositoryDomain "github.com"
-targetGitRepositoryOrganizationName "my-org"
# Result: https://github.com/my-org/repo-name.git
```

### GitHub (SSH)

```powershell
-targetGitRepositoryProtocol "git@"
-targetGitRepositoryDomain "github.com:"
-targetGitRepositoryOrganizationName "my-org"
# Result: git@github.com:my-org/repo-name.git
```

### Azure DevOps

```powershell
-targetGitRepositoryProtocol "https://"
-targetGitRepositoryDomain "dev.azure.com"
-targetGitRepositoryOrganizationName "contoso/terraform-modules"
# Result: https://dev.azure.com/contoso/terraform-modules/repo-name.git
```

### GitLab

```powershell
-targetGitRepositoryProtocol "https://"
-targetGitRepositoryDomain "gitlab.com"
-targetGitRepositoryOrganizationName "my-group/subgroup"
# Result: https://gitlab.com/my-group/subgroup/repo-name.git
```

### Self-Hosted

```powershell
-targetGitRepositoryProtocol "https://"
-targetGitRepositoryDomain "git.internal.company.com"
-targetGitRepositoryOrganizationName "terraform"
# Result: https://git.internal.company.com/terraform/repo-name.git
```

## Troubleshooting

### Common Issues

#### "PowerShell version must be 7+"

The script uses `ForEach-Object -Parallel` which requires PowerShell 7+.

```powershell
# Install PowerShell 7 on Windows
winget install Microsoft.PowerShell

# Run with PowerShell 7
pwsh .\Invoke-ModuleSync.ps1
```

#### "GitHub API rate limit exceeded"

The script includes delays between API calls, but heavy usage may hit limits.

```powershell
# Authenticate to increase rate limit (5000/hour vs 60/hour)
gh auth login
```

#### "Failed to create repository"

Ensure you're authenticated and have permissions:

```powershell
# For GitHub
gh auth status
gh repo list your-org --limit 1

# For Azure DevOps
az account show
az repos list --org https://dev.azure.com/your-org --project your-project
```

#### "Repository already exists" errors during push

This is informational, not an error. The script will update existing repos.

#### Tags not being created

The script only processes semantic version tags (e.g., `v1.0.0`, `1.2.3`). Non-semver tags are skipped.

### Getting Help

View the built-in help:

```powershell
Get-Help .\Invoke-ModuleSync.ps1 -Full
Get-Help .\Invoke-ModuleSync.ps1 -Examples
```

## Using PowerShell Get-Help

The script includes comprehensive comment-based help that can be accessed using PowerShell's built-in `Get-Help` cmdlet. This is the best way to get up-to-date information about parameters, examples, and usage directly from the script.

### Basic Help

Display a summary of the script's purpose and syntax:

```powershell
Get-Help .\Invoke-ModuleSync.ps1
```

### Detailed Help

Show complete documentation including parameter descriptions and remarks:

```powershell
Get-Help .\Invoke-ModuleSync.ps1 -Detailed
```

### Full Help

Display all available help content including technical details:

```powershell
Get-Help .\Invoke-ModuleSync.ps1 -Full
```

### Examples Only

View just the usage examples:

```powershell
Get-Help .\Invoke-ModuleSync.ps1 -Examples
```

### Parameter-Specific Help

Get help for a specific parameter:

```powershell
Get-Help .\Invoke-ModuleSync.ps1 -Parameter moduleFilters
Get-Help .\Invoke-ModuleSync.ps1 -Parameter targetGitRepositoryOrganizationName
```

### Online Help (if available)

Open the online documentation in a browser:

```powershell
Get-Help .\Invoke-ModuleSync.ps1 -Online
```

### Show Help in a Separate Window

On Windows, display help in a graphical window:

```powershell
Get-Help .\Invoke-ModuleSync.ps1 -ShowWindow
```

### Quick Reference Table

| Command | Description |
|---------|-------------|
| `Get-Help .\Invoke-ModuleSync.ps1` | Basic synopsis and syntax |
| `Get-Help .\Invoke-ModuleSync.ps1 -Detailed` | Full descriptions with examples |
| `Get-Help .\Invoke-ModuleSync.ps1 -Full` | Complete technical documentation |
| `Get-Help .\Invoke-ModuleSync.ps1 -Examples` | Usage examples only |
| `Get-Help .\Invoke-ModuleSync.ps1 -Parameter <name>` | Help for specific parameter |
| `Get-Help .\Invoke-ModuleSync.ps1 -ShowWindow` | Display in GUI window (Windows) |

> **Tip:** If you've just downloaded the script and `Get-Help` returns minimal information, ensure the script file hasn't been blocked by Windows. Right-click the file, select Properties, and click "Unblock" if present.

## Use Cases

### Air-Gapped Environments

For environments without internet access:

1. Run the script on an internet-connected machine
2. Copy the `destinationDirectoryPath` folder to the air-gapped environment
3. Push from within the air-gapped network to your internal git server

### Compliance and Auditing

Organizations requiring:
- Internal code review before using external modules
- Immutable versioned copies of dependencies
- Complete dependency tracking via JSON graphs

### CI/CD Pipeline Integration

Reference the synced modules in Terraform:

```hcl
module "virtual_network" {
  source = "git::https://git.internal.company.com/terraform/terraform-azurerm-avm-res-network-virtualnetwork.git?ref=v0.2.0-local"

  # ... module inputs
}
```

## Setting Up CI/CD Automation

This section provides platform-agnostic guidance for setting up the sync script in any CI/CD system (GitHub Actions, Azure DevOps Pipelines, GitLab CI, Jenkins, etc.).

### Step 1: Prepare Your Pipeline Environment

Ensure your CI/CD runner has the following installed:

| Requirement | Purpose |
|-------------|---------|
| PowerShell 7+ | Script execution |
| Git 2.0+ | Repository operations |
| GitHub CLI (gh) | Required if target is GitHub |
| Azure CLI (az) | Required if target is Azure DevOps |

Most CI/CD systems provide these tools in their hosted runners, or you can install them in your self-hosted runners.

### Step 2: Configure Authentication

The script needs to authenticate to both the source (GitHub) and target git servers.

#### Option A: Token-Based Authentication (Recommended)

Set up environment variables or secrets in your CI/CD system:

| Secret Name | Purpose | Example Value |
|-------------|---------|---------------|
| `GH_TOKEN` | GitHub CLI authentication | `ghp_xxxxxxxxxxxx` |
| `AZURE_DEVOPS_EXT_PAT` | Azure DevOps authentication | `xxxxxxxxxxxxxxxxxx` |
| `GIT_CREDENTIALS` | Generic git credentials | `https://user:token@server.com` |

#### Option B: Git Credential Helper

Configure git to use stored credentials:

```powershell
# For GitHub
git config --global credential.helper store
echo "https://${GH_TOKEN}:x-oauth-basic@github.com" >> ~/.git-credentials

# For Azure DevOps
git config --global credential.helper store
echo "https://user:${AZURE_DEVOPS_PAT}@dev.azure.com" >> ~/.git-credentials
```

### Step 3: Set Up Persistent State Storage

> **Critical:** The `.sync-state.json` file must persist between pipeline runs to track synced repositories, enable cleanup operations, and detect orphaned repos.

Choose one of these approaches:

#### Option A: Store in a Dedicated Repository

```powershell
# Clone state repo at start of pipeline
git clone https://your-server/your-org/avm-sync-state.git ./state

# Run sync with state file in the cloned repo
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @("avm-ptn-alz-") `
    -syncStateFilePath "./state/.sync-state.json" `
    -skipOrphanCheck

# Commit and push state changes at end of pipeline
Push-Location ./state
git add .sync-state.json
git commit -m "Update sync state [skip ci]"
git push
Pop-Location
```

#### Option B: Store as Pipeline Artifact/Cache

```powershell
# Download previous state (platform-specific command)
# e.g., actions/cache, Pipeline Artifacts, etc.

# Run sync with explicit state path
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @() `
    -syncStateFilePath "./pipeline-cache/.sync-state.json" `
    -skipOrphanCheck

# Upload updated state as artifact (platform-specific command)
```

#### Option C: Store in Cloud Storage

```powershell
# Download from Azure Blob, AWS S3, GCS, etc.
az storage blob download --account-name mystorageaccount --container-name state --name .sync-state.json --file ./.sync-state.json

# Run sync
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -moduleFilters @() `
    -syncStateFilePath "./.sync-state.json" `
    -skipOrphanCheck

# Upload updated state
az storage blob upload --account-name mystorageaccount --container-name state --name .sync-state.json --file ./.sync-state.json --overwrite
```

### Step 4: Configure Pipeline Script

Create your pipeline script with these recommended flags for automation:

```powershell
# Recommended flags for CI/CD:
# -skipOrphanCheck     : Prevents interactive prompts about orphaned repos
# -skipVerification    : Skips confirmation prompts (use with caution)
# -syncStateFilePath   : Points to your persistent state location

.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName "my-org" `
    -targetGitRepositoryDomain "github.com" `
    -moduleFilters @("avm-ptn-alz-") `
    -syncStateFilePath "/persistent/path/.sync-state.json" `
    -skipOrphanCheck `
    -targetRepositoryVisibility "private" `
    -parallelCloneLimit 10
```

### Step 5: Schedule Regular Execution

Configure your CI/CD system to run the sync on a schedule:

| Frequency | Use Case |
|-----------|----------|
| Daily | Keep modules up-to-date with latest AVM releases |
| Weekly | Balance freshness with pipeline resource usage |
| On-demand | Manual trigger when specific updates are needed |

### Example: Minimal CI/CD Script

```powershell
#!/usr/bin/env pwsh
# Generic CI/CD script for AVM module sync

param(
    [string]$TargetOrg = $env:TARGET_ORG,
    [string]$StateFile = $env:STATE_FILE_PATH ?? "./.sync-state.json"
)

# Verify prerequisites
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell 7+ required"
    exit 1
}

# Configure git identity for commits
git config --global user.email "ci-bot@example.com"
git config --global user.name "CI Bot"

# Run the sync
.\Invoke-ModuleSync.ps1 `
    -targetGitRepositoryOrganizationName $TargetOrg `
    -moduleFilters @() `
    -syncStateFilePath $StateFile `
    -skipOrphanCheck `
    -targetRepositoryVisibility "private"

# Check exit code
if ($LASTEXITCODE -ne 0) {
    Write-Error "Sync failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Sync completed successfully"
```

### CI/CD Best Practices

1. **Always persist the sync state file** - Without it, the script cannot track what has been synced
2. **Use `-skipOrphanCheck`** - Prevents the pipeline from hanging on interactive prompts
3. **Set appropriate timeouts** - Large syncs can take 30+ minutes
4. **Configure git identity** - Required for creating commits with converted module sources
5. **Use secrets for tokens** - Never hardcode authentication tokens in scripts
6. **Consider network egress** - The script downloads from GitHub and uploads to your target
7. **Monitor for failures** - Check `failed-repos.json` output for any push failures

## License

This tool is provided as-is for working with Azure Verified Modules. See the individual AVM module repositories for their respective licenses.
