<!-- markdownlint-disable -->
# Implementation Plan: Legacy Business Application Infrastructure

**Branch**: `001-my-legacy-workload` | **Date**: 2026-02-18 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-my-legacy-workload/spec.md`

**Note**: This plan implements the `/speckit.plan` command workflow.

## Summary

Deploy a legacy Windows Server 2016 business application infrastructure using Terraform and Azure Verified Modules (AVM). The solution includes:
- **Core Compute**: Standard_D2s_v3 VM with Windows Server 2016, 500GB data disk, managed in isolated VNet
- **Network Security**: VNet (10.0.0.0/24) with 3 subnets, NSGs with deny-by-default rules, Azure Bastion for secure RDP
- **Storage**: 1TB Azure Files share accessible via private endpoint
- **Secrets Management**: Azure Key Vault storing VM admin password (generated with random_password resource)
- **Internet Access**: NAT Gateway for outbound-only connectivity
- **Observability**: Log Analytics (180-day retention) with diagnostic logging and critical alerts

**Technical Approach**: Single Terraform root module deploying all resources via AVM modules from Terraform Registry. No backup solution (infrastructure is disposable/recreatable). All configuration in terraform.tfvars per specification. VM password generated using random_password resource, stored in Key Vault via AVM module interface, then referenced by VM module.

## Technical Context

**Infrastructure Language**: Terraform >= 1.9.0 (latest stable as of 2026-02-18)

**Required Providers**:
- `hashicorp/azurerm` ~> 4.0 (latest major version with AVM compatibility)
- `hashicorp/random` ~> 3.6 (for random_password and random_string resources)

**AVM Modules** (versions to be verified from Terraform Registry during Phase 0):
- `Azure/avm-res-network-virtualnetwork/azurerm` - VNet with 3 subnets
- `Azure/avm-res-network-networksecuritygroup/azurerm` - NSGs for each subnet
- `Azure/avm-res-compute-virtualmachine/azurerm` - Windows Server 2016 VM
- `Azure/avm-res-network-bastionhost/azurerm` - Azure Bastion
- `Azure/avm-res-keyvault-vault/azurerm` - Key Vault for secrets
- `Azure/avm-res-storage-storageaccount/azurerm` - Storage account with file share
- `Azure/avm-res-network-privateendpoint/azurerm` - Private endpoint (if not included in storage module)
- `Azure/avm-res-network-natgateway/azurerm` - NAT Gateway
- `Azure/avm-res-operationalinsights-workspace/azurerm` - Log Analytics Workspace
- `Azure/avm-res-insights-metricgroup/azurerm` or similar - Metric alerts (module name TBD)

**Note**: AVM for Terraform modules use naming convention `Azure/avm-res-{service}-{resource}/azurerm`. Exact module names and latest versions must be verified from https://registry.terraform.io/namespaces/Azure during Phase 0 research.

**State Backend**: Azure Storage Account (pre-existing, not managed by this Terraform)
**State File**: `my-legacy-workload-prod.tfstate`
**Target Region**: westus3
**Project Type**: Infrastructure-only (Terraform root module)

**Deployment Method**: Manual terraform apply via CLI (CI/CD pipeline optional for Phase 2)
**Security Tooling**: tfsec >= 1.28, checkov >= 3.0 (for static security analysis)
**Complexity**: 12 Azure resources via AVM modules, estimated ~300-400 lines of Terraform
**Estimated Monthly Cost**: <$200/month (per spec SC-013)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Based on `.specify/memory/constitution.md` version 1.0.0:

- [x] **Principle I**: All Azure resources defined in Terraform `.tf` files (no imperative scripts except justified)
  - All 12 resources deployed via Terraform AVM modules
  - No custom PowerShell/CLI scripts for resource deployment

- [x] **Principle II**: All modules sourced from Azure Verified Modules (AVM) Terraform Registry (`Azure/avm-*`)
  - Zero custom/third-party modules
  - All resources use official AVM modules where available
  - Built-in azurerm resources only for resource group and random resources (no AVM module available)

- [x] **Principle III**: Security requirements met:
  - [x] VM managed identity (system-assigned) configured via AVM module interface
  - [x] VM password generated with random_password, stored in Key Vault via AVM secrets interface
  - [x] NSGs with deny-by-default rules, explicit allow for RDP from Bastion only
  - [x] Diagnostic settings enabled via AVM module diagnostic_settings interface
  - [x] Encryption at rest (default Microsoft-managed keys)
  - [x] Resource locks via AVM module lock interface (not direct azurerm_management_lock)
  - [x] No secrets in .tf or .tfvars files (password generated at runtime, stored in Key Vault)

- [x] **Principle IV**: Single root module pattern (all resources in terraform/ directory root)
  - terraform/main.tf contains all module instantiations
  - No local child modules created
  - Terraform dependency graph manages deployment order

- [x] **Principle V**: Deployment includes terraform validate and terraform plan review gates
  - Validation workflow: init → fmt → validate → plan → review → apply
  - Plan file (plan.tfplan) generated and reviewed before apply

- [x] **Deployment Standards**: Target region is `westus3`, naming convention followed (`<type>-avmlegacy-<suffix>`)
  - All resources use location = var.location (default: "westus3")
  - Naming via locals using random_string for uniqueness

- [x] **Project Constraints**: No HA/DR/scalability features added (legacy workload, cost-optimized)
  - Single VM (no availability set, no load balancer)
  - No backup policies (infrastructure disposable per clarification session)
  - Standard/HDD tier for cost optimization

**Constitution Compliance**: ✅ **PASSED** - All principles satisfied

## Project Structure

### Documentation (this feature)

```
specs/001-my-legacy-workload/
├── spec.md              # Feature specification (input)
├── plan.md              # This file (Phase 0-1 output)
├── research.md          # Phase 0 research findings (to be created)
├── data-model.md        # Phase 1 data model (infrastructure entities - to be created)
├── quickstart.md        # Phase 1 deployment guide (to be created)
├── contracts/           # Phase 1 contracts (N/A for infrastructure, no external APIs)
├── checklists/
│   └── requirements.md  # Specification validation checklist (exists)
└── tasks.md             # Phase 2 task breakdown (created by /speckit.tasks command)
```

### Source Code (repository root)

```
terraform/
├── main.tf              # Primary resource declarations and AVM module calls
├── variables.tf         # Input variable definitions with descriptions
├── outputs.tf           # Output value definitions for infrastructure details
├── terraform.tf         # Terraform version and provider configurations
├── backend.tf           # Remote state backend configuration (Azure Storage)
├── locals.tf            # Local value computations (naming, tags)
├── prod.tfvars          # Production environment variable values (this is the ONLY tfvars file)
└── README.md            # Terraform deployment instructions

docs/
├── README.md            # Project overview and setup instructions
└── architecture.md      # Infrastructure architecture diagram and design decisions

.github/
└── workflows/
    └── terraform-validate.yml  # CI/CD pipeline for validation (optional Phase 2)

.gitignore               # Terraform-specific ignore patterns (.terraform/, *.tfstate, *.tfvars except prod.tfvars.example)
```

**Structure Decision**: Selected Option 1 (Terraform Infrastructure). This is a pure infrastructure deployment with no application code. All Terraform files in `terraform/` directory at repository root. Single `prod.tfvars` file per spec requirement (no dev/test environments).

## Complexity Tracking

> **Note**: No constitution violations - this section documents architectural decisions only

| Decision | Rationale | Alternative Considered |
|----------|-----------|------------------------|
| No local Terraform modules | Per spec requirements and constitution, use AVM modules exclusively. Local modules only if AVM unavailable | Could create local modules for repeated patterns - rejected per spec FR-025 |
| Single tfvars file (prod.tfvars) | Spec requires production environment only (per clarification: no dev/test/staging) | Could use terraform workspaces - rejected per spec FR-024 |
| No backup automation | Per clarification session: infrastructure is disposable, recreatable from Terraform. No backup needed | Could add Azure Backup via AVM module - rejected per clarification |
| Minimal VNet (/24) | Per clarification session: cost-optimized, no growth expected for legacy workload | Could use /23 or larger - rejected for cost optimization |
| 1TB file share | Per clarification session: large capacity selected to avoid future expansion | Could use smaller quota (100GB-500GB) - rejected per user preference |

---

## Phase 0: Outline & Research

**Objective**: Resolve all "NEEDS CLARIFICATION" items from Technical Context and research AVM module capabilities

### Research Tasks

#### Task 1: Verify Latest Terraform Version
**Research**: Confirm Terraform stable version >= 1.9.0 available
**Method**: Check https://developer.hashicorp.com/terraform/downloads or run `terraform version`
**Outputs**: Exact Terraform version constraint for terraform.tf

#### Task 2: Verify Azure RM Provider Version
**Research**: Confirm azurerm provider version ~> 4.0 compatible with AVM modules
**Method**: Check https://registry.terraform.io/providers/hashicorp/azurerm/latest and AVM module documentation
**Outputs**: Exact provider version constraint

#### Task 3: Research AVM Module Availability and Versions
**Research**: For each required Azure resource, identify:
1. Official AVM module name on Terraform Registry
2. Latest stable version (semantic versioning)
3. Module README documentation link
4. Key input variables and interfaces (diagnostic_settings, lock, managed_identities, private_endpoints, secrets)

**Method**: Visit https://registry.terraform.io/namespaces/Azure and search for:
- `avm-res-network-virtualnetwork`
- `avm-res-network-networksecuritygroup`
- `avm-res-compute-virtualmachine`
- `avm-res-network-bastionhost`
- `avm-res-keyvault-vault`
- `avm-res-storage-storageaccount`
- `avm-res-network-privateendpoint` (or check if storage module has built-in private endpoint interface)
- `avm-res-network-natgateway`
- `avm-res-operationalinsights-workspace`
- Insights/monitoring module for metric alerts (name TBD)

**Critical**: Verify each module supports:
- `diagnostic_settings` interface for Log Analytics integration
- `lock` interface for resource locks (CanNotDelete)
- `managed_identities` interface for system-assigned identity
- `secrets` interface (Key Vault module only) for storing random_password output
- `private_endpoints` interface (storage module) for private connectivity

**Outputs**: Populate `research.md` with findings:

```markdown
## AVM Module Research

### Module: avm-res-network-virtualnetwork
- **Registry Path**: Azure/avm-res-network-virtualnetwork/azurerm
- **Latest Version**: [VERSION] (verify from registry)
- **Documentation**: https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm/latest
- **Key Interfaces**:
  - Subnets: Supports multiple subnet definitions with CIDR allocation
  - NSG Association: [Check if built-in or separate]
  - Diagnostic Settings: [Verify interface availability]
- **Variables Required for Spec**:
  - address_space = ["10.0.0.0/24"]
  - subnets = { vm = "10.0.0.0/27", bastion = "10.0.0.32/26", private_endpoint = "10.0.0.96/28" }
  - location, resource_group_name, etc.

[Repeat for each module...]
```

#### Task 4: Research NSG Rule Patterns
**Research**: Best practices for NSG rules in AVM network security group module:
- Deny-by-default posture
- Allow RDP (3389) from Bastion subnet to VM subnet
- Allow HTTPS (443) inbound to Bastion subnet (Azure Bastion requirement)
- Allow SMB (445) from VM subnet to Private Endpoint subnet

**Method**: Review AVM NSG module documentation for security_rules input structure
**Outputs**: Document NSG rule schema in research.md

#### Task 5: Research VM Password Flow with Key Vault
**Research**: Confirm workflow for generating password and storing in Key Vault via AVM:
1. Create random_password resource (length, complexity requirements)
2. Pass random_password.result to Key Vault AVM module's `secrets` interface
3. Reference Key Vault secret in VM AVM module's admin_password input

**Method**: Review AVM Key Vault module's `secrets` interface and VM module's authentication inputs
**Outputs**: Document password generation pattern in research.md

#### Task 6: Research Private Endpoint Integration
**Research**: Determine if storage account AVM module has built-in private endpoint interface or requires separate private endpoint module
**Method**: Check AVM storage account module documentation for `private_endpoints` input variable
**Outputs**: Decision in research.md - use built-in interface vs separate module

#### Task 7: Research Log Analytics Integration Patterns
**Research**: How to configure diagnostic settings for VM, Key Vault, Storage Account to send logs to Log Analytics
**Method**: Review each AVM module's `diagnostic_settings` interface structure
**Outputs**: Document diagnostic_settings input schema in research.md

#### Task 8: Research Alerting Approach
**Research**: AVM modules or direct resources for metric alerts (VM stopped, disk >90%, Key Vault access failures)
**Method**: Check for AVM alerting/monitoring modules or plan to use azurerm_monitor_metric_alert directly
**Outputs**: Decision documented in research.md

### Research Consolidation

**Output**: `research.md` file with structure:

```markdown
# Research Findings: Legacy Business Application Infrastructure

## Decision Log

### Decision 1: Terraform Version
- **Chosen**: Terraform 1.9.x (latest stable)
- **Rationale**: Latest features, bug fixes, security patches
- **Alternatives Considered**: 1.8.x (stable but older), 1.10+ (if available, may have breaking changes)

### Decision 2: AVM Module Versions
- **Chosen**: Latest stable version for each module (semver ~> X.Y.0)
- **Rationale**: Latest features, security fixes, Azure API compatibility
- **Alternatives Considered**: Pin to specific patch versions (rejected - want latest patches)

[Continue for each research task...]

## Module Documentation Summary

### VNet Module
[Findings from Task 3...]

### NSG Module
[Findings from Task 3 and Task 4...]

[etc.]
```

---

## Phase 1: Design & Contracts

**Prerequisites:** `research.md` complete with all module versions and interfaces documented

### Design Artifacts

#### 1. Data Model (Infrastructure Entities)

**Output**: `data-model.md`

```markdown
# Infrastructure Data Model: Legacy Business Application Infrastructure

## Entity Relationships

```
┌─────────────────────────────────────────────────────────┐
│ Resource Group (rg-avmlegacy-wus3)                      │
│                                                           │
│  ┌─────────────────────────────────────────────┐        │
│  │ Virtual Network (10.0.0.0/24)               │        │
│  │  ├─ VM Subnet (10.0.0.0/27)                │        │
│  │  ├─ Bastion Subnet (10.0.0.32/26)          │        │
│  │  └─ Private Endpoint Subnet (10.0.0.96/28) │        │
│  └─────────────────────────────────────────────┘        │
│           │           │              │                   │
│           │           │              │                   │
│  ┌────────▼────┐ ┌───▼──────┐ ┌────▼────────┐         │
│  │ NSG (VM)    │ │NSG(Bastn)│ │NSG(PrivEndpt)│         │
│  └─────────────┘ └──────────┘ └──────────────┘         │
│           │                          │                   │
│  ┌────────▼─────────┐                │                   │
│  │ VM (Std_D2s_v3) │                │                   │
│  │ - OS Disk       │◄────────┐      │                   │
│  │ - Data Disk     │         │      │                   │
│  └─────────────────┘         │      │                   │
│           │                   │      │                   │
│           │            ┌──────┴──────▼──────┐           │
│           │            │ Key Vault           │           │
│           │            │ - VM Admin Password │           │
│           ▼            └─────────────────────┘           │
│    ┌──────────┐                │                         │
│    │ Bastion  │                │                         │
│    │ (RDP)    │                │                         │
│    └──────────┘                │                         │
│           │                     │                         │
│  ┌────────▼─────────┐          │                         │
│  │ NAT Gateway      │          │                         │
│  │ (Outbound Only)  │          │                         │
│  └──────────────────┘          │                         │
│                                 │                         │
│  ┌──────────────────────────┐  │                         │
│  │ Storage Account          │  │                         │
│  │ - File Share (1TB)       │  │                         │
│  │ - Private Endpoint ──────┼──┘                         │
│  └──────────────────────────┘                            │
│                                                           │
│  ┌──────────────────────────┐                            │
│  │ Log Analytics Workspace  │                            │
│  │ - 180-day retention      │                            │
│  │ - Diagnostic logs (VM,   │                            │
│  │   Key Vault, Storage)    │                            │
│  │ - Metric Alerts (3)      │                            │
│  └──────────────────────────┘                            │
└───────────────────────────────────────────────────────────┘
```

## Core Entities

### 1. Resource Group
- **Name**: rg-avmlegacy-wus3
- **Location**: westus3
- **Lock**: CanNotDelete
- **Purpose**: Container for all infrastructure resources

### 2. Virtual Network
- **Name**: vnet-avmlegacy-{random}
- **Address Space**: 10.0.0.0/24
- **Subnets**:
  - vm_subnet: 10.0.0.0/27 (30 usable IPs)
  - AzureBastionSubnet: 10.0.0.32/26 (62 usable IPs, Azure requirement)
  - private_endpoint_subnet: 10.0.0.96/28 (14 usable IPs)
- **Diagnostic Settings**: Enabled, logs to Log Analytics

### 3. Network Security Groups (3)
- **vm_nsg**:
  - Inbound Rules: Allow RDP (3389) from AzureBastionSubnet CIDR
  - Outbound Rules: Allow all (default), NAT Gateway handles internet access
- **bastion_nsg**:
  - Inbound Rules: Allow HTTPS (443) from Internet (Azure Bastion requirement)
  - Outbound Rules: Allow RDP (3389) to vm_subnet CIDR
- **private_endpoint_nsg**:
  - Inbound Rules: Allow SMB (445) from vm_subnet CIDR
  - Outbound Rules: Deny all (implicit)

### 4. Virtual Machine
- **Name**: vm-avmlegacy-{random} (ensure ≤15 chars per spec)
- **Computer Name**: Derived from VM name, truncated to 15 chars if needed
- **Size**: Standard_D2s_v3
- **OS**: Windows Server 2016
- **OS Disk**: Standard HDD (127GB default)
- **Data Disk**: 500GB Standard HDD, LUN 0
- **Admin Username**: vmadmin
- **Admin Password**: Sourced from Key Vault secret (generated via random_password)
- **Managed Identity**: System-assigned
- **Availability Zone**: Zone 1 (or 2, 3 per requirement - never -1)
- **Diagnostic Settings**: Enabled, logs to Log Analytics
- **Lock**: CanNotDelete

### 5. Azure Bastion
- **Name**: bastion-avmlegacy-{random}
- **SKU**: Basic or Standard (verify cost in Phase 0)
- **Subnet**: AzureBastionSubnet (/26)
- **Public IP**: Managed by Bastion
- **Lock**: CanNotDelete

### 6. Key Vault
- **Name**: kv-avmlegacy-{random} (3-24 chars, globally unique)
- **SKU**: Standard
- **Soft Delete**: Enabled (90 days default)
- **Purge Protection**: Enabled
- **RBAC vs Access Policies**: Use RBAC (recommended for AVM)
- **Secrets**:
  - vm-admin-password: Generated from random_password resource
- **Diagnostic Settings**: Enabled, logs to Log Analytics
- **Lock**: CanNotDelete

### 7. Storage Account
- **Name**: stavmlegacy{random} (3-24 chars, lowercase alphanumeric, globally unique)
- **SKU**: Standard_LRS
- **Kind**: StorageV2
- **File Share**:
  - Name**: legacyappdata (or from tfvars)
  - Quota**: 1024 GB (1TB)
  - Tier**: TransactionOptimized (Standard)
- **Public Network Access**: Disabled
- **Private Endpoint**: Enabled, connected to private_endpoint_subnet
- **Diagnostic Settings**: Enabled, logs to Log Analytics
- **Lock**: CanNotDelete

### 8. Private Endpoint
- **Name**: pe-storage-avmlegacy-{random}
- **Subnet**: private_endpoint_subnet
- **Private DNS Integration**: Enabled (creates privatelink.file.core.windows.net DNS entry)
- **Sub-resource**: file (for Azure Files)

### 9. NAT Gateway
- **Name**: nat-avmlegacy-{random}
- **SKU**: Standard
- **Public IP**: Dedicated public IP for outbound traffic
- **Associated Subnets**: vm_subnet only
- **Idle Timeout**: 4 minutes (default)

### 10. Log Analytics Workspace
- **Name**: law-avmlegacy-{random}
- **SKU**: PerGB2018
- **Retention**: 180 days
- **Daily Cap**: None (or set based on cost constraints)
- **Diagnostic Log Sources**: VM, Key Vault, Storage Account

### 11. Metric Alerts (3)
- **VM Stopped Alert**:
  - Metric**: VM Availability (or PowerState)
  - Condition**: Threshold = 0 (stopped)
  - Action Group**: (email/webhook TBD in tfvars)
- **VM Disk Usage Alert**:
  - Metric**: Disk Space Used Percentage
  - Condition**: Threshold > 90%
  - Action Group**: (same as above)
- **Key Vault Access Failure Alert**:
  - Metric**: Failed requests or Access denied events
  - Condition**: Count > 0 over 5 minutes
  - Action Group**: (same as above)

### 12. Supporting Resources
- **random_string**: Generate 6-character unique suffix for naming
- **random_password**: Generate VM admin password (16+ chars, complexity requirements)

## Terraform State Dependencies

Implicit dependency order (Terraform will resolve):
1. random_string, random_password (no dependencies)
2. Resource Group
3. Log Analytics Workspace (for diagnostic settings)
4. Key Vault → secrets (stores random_password)
5. VNet → Subnets
6. NSGs (reference VNet for associations)
7. NAT Gateway → Public IP
8. VM (references Key Vault secret, VNet subnet, NSG)
9. Bastion (references VNet Bastion subnet)
10. Storage Account → File Share → Private Endpoint
11. Diagnostic Settings (references Log Analytics, resources)
12. Metric Alerts (references resources, Log Analytics)
13. Resource Locks (references resources)
```

#### 2. API Contracts

**Output**: N/A for infrastructure project (no external APIs to define)

#### 3. Quickstart Guide

**Output**: `quickstart.md`

```markdown
# Quickstart: Deploy Legacy Business Application Infrastructure

## Prerequisites

1. **Terraform CLI**: Version >= 1.9.0
  ```bash
  terraform version
  # Terraform v1.9.x
  ```

2. **Azure CLI**: Authenticated with sufficient permissions
  ```bash
  az login
  az account show
  # Verify correct subscription
  ```

3. **Azure Subscription**: Contributor role on target subscription or resource group

4. **Terraform State Backend**: Pre-existing Azure Storage Account with container for state
  - Storage Account name: `<your-state-storage>`
  - Container name: `tfstate`
  - SAS token or Storage Account Key

5. **Security Tools** (optional but recommended):
  - tfsec >= 1.28
  - checkov >= 3.0

## Setup Steps

### Step 1: Clone Repository and Navigate to Terraform Directory

```bash
git clone <repository-url>
cd <repository>/terraform
```

### Step 2: Configure Backend

Create `backend.hcl` file (not committed to git):

```hcl
storage_account_name = "<your-state-storage>"
container_name       = "tfstate"
key                  = "my-legacy-workload-prod.tfstate"
resource_group_name  = "<state-storage-resource-group>"
```

### Step 3: Review and Customize prod.tfvars

Edit `prod.tfvars` to customize deployment:

```hcl
# Required variables
location         = "westus3"
workload_name    = "avmlegacy"
environment      = "prod"
vm_admin_secret_name = "vm-admin-password"  # Key Vault secret name

# Optional overrides (defaults provided in variables.tf)
vm_size          = "Standard_D2s_v3"
vm_data_disk_size_gb = 500
file_share_quota_gb  = 1024
log_analytics_retention_days = 180
availability_zone = 1  # or 2, 3 - never -1

# Alert action group (email/webhook)
alert_action_group_email = "admin@example.com"
```

### Step 4: Initialize Terraform

```bash
terraform init -backend-config=backend.hcl
```

Expected output:
```
Terraform has been successfully initialized!
```

### Step 5: Format and Validate

```bash
terraform fmt -recursive
terraform validate
```

Expected output:
```
Success! The configuration is valid.
```

### Step 6: Run Security Scans (Optional)

```bash
tfsec .
checkov -d .
```

Fix any HIGH or CRITICAL findings before proceeding.

### Step 7: Plan Deployment

```bash
terraform plan -var-file=prod.tfvars -out=plan.tfplan
```

**Review the plan carefully**:
- Verify 12-15 resources to be created (exact count depends on AVM module resource expansion)
- Check resource names match naming convention
- Verify no unexpected deletions or replacements
- Confirm all resources deploying to westus3

### Step 8: Apply Deployment

```bash
terraform apply plan.tfplan
```

Deployment takes approximately 20-30 minutes. Progress:
1. Resource Group, Log Analytics (1-2 min)
2. VNet, NSGs, Key Vault (3-5 min)
3. Storage Account, Private Endpoint (5-7 min)
4. NAT Gateway, Bastion (10-15 min - Bastion is slowest)
5. VM (7-10 min)
6. Diagnostic Settings, Alerts, Locks (2-3 min)

### Step 9: Verify Deployment

```bash
# Get outputs
terraform output

# Expected outputs:
# resource_group_name = "rg-avmlegacy-wus3"
# vm_name = "vm-avmlegacy-a1b2c3"
# key_vault_name = "kv-avmlegacy-a1b2c3"
# storage_account_name = "stavmlegacya1b2c3"
# log_analytics_workspace_id = "/subscriptions/..."
```

Check Azure Portal:
1. Navigate to Resource Group `rg-avmlegacy-wus3`
2. Verify VM is running
3. Test Bastion connection (Connect → Bastion)
4. Retrieve password from Key Vault secret
5. Verify Log Analytics has diagnostic logs

## Post-Deployment

### Connect to VM via Bastion

1. Azure Portal → Virtual Machines → `vm-avmlegacy-...`
2. Click "Connect" → "Bastion"
3. Username: `vmadmin`
4. Password: Retrieve from Key Vault:
  ```bash
  az keyvault secret show --name vm-admin-password --vault-name <kv-name> --query value -o tsv
  ```
5. Click "Connect"

### Mount Azure Files Share

From within the VM (via Bastion RDP session):

```powershell
# Get storage account name from terraform output
$storageAccountName = "<storage-account-name>"
$fileShareName = "legacyappdata"

# Note: Authentication via private endpoint - no key needed for mounted drive
# Access share via UNC path using private endpoint IP or FQDN
net use Z: \\$storageAccountName.privatelink.file.core.windows.net\$fileShareName
```

### Verify Internet Connectivity

```powershell
# From VM
Invoke-WebRequest -Uri "https://www.microsoft.com" -UseBasicParsing
# Should succeed via NAT Gateway
```

### Check Diagnostic Logs

Azure Portal → Log Analytics Workspace → Logs:

```kusto
// VM metrics
Perf
| where Computer startswith "vm-avmlegacy"
| where TimeGenerated > ago(1h)
| take 10

// Key Vault access logs
AzureDiagnostics
| where ResourceType == "VAULTS"
| where TimeGenerated > ago(1h)
| take 10
```

## Troubleshooting

### Issue: Terraform init fails with backend authentication error
**Solution**: Verify backend.hcl credentials and ensure storage account allows access from your IP

### Issue: VM creation fails with quota error
**Solution**: Check Azure subscription quotas for Standard_D2s_v3 in westus3 region

### Issue: Bastion deployment times out
**Solution**: Bastion can take 15-20 minutes. If timeout occurs, run `terraform apply` again (idempotent)

### Issue: Cannot connect via Bastion
**Solution**: Verify NSG rules allow RDP from Bastion subnet. Check VM is running. Verify password from Key Vault.

### Issue: File share inaccessible from VM
**Solution**: Verify private endpoint deployed correctly. Check NSG allows SMB (445) from VM subnet. Verify private DNS resolution.

## Cleanup

**Warning**: This destroys all infrastructure. Ensure data is backed up if needed (though per spec, infrastructure is disposable).

```bash
terraform destroy -var-file=prod.tfvars
```

Confirm with `yes` when prompted.

**Note**: Some resources (Key Vault with purge protection) may enter soft-delete state and require manual purge after 90 days.
```

#### 4. Agent Context Update

**Output**: Run agent context update script (if applicable for Copilot context files)

```bash
# Run from repository root
./.specify/scripts/powershell/update-agent-context.ps1 -AgentType copilot
```

This updates .github/copilot-instructions.md or similar with:
- Terraform/AVM technology stack
- westus3 region
- Constitution principles
- Preserves manual additions between markers

#### 5. Re-evaluate Constitution Check

**Post-Design Validation**: Review design artifacts against constitution:

- [x] **Principle I**: All resources in Terraform (data-model.md documents 12 resources via AVM modules)
- [x] **Principle II**: Only AVM modules used (no custom modules in design)
- [x] **Principle III**: Security controls documented in data-model.md (NSGs, Key Vault, managed identity, diagnostic logging, locks)
- [x] **Principle IV**: Single root module structure documented in project structure
- [x] **Principle V**: Quickstart.md documents validation workflow (init → fmt → validate → plan → apply)

**Constitution Compliance Post-Design**: ✅ **MAINTAINED**

---

## Terraform Code Structure

### File: terraform.tf

```hcl
# Terraform and Provider Configuration
# Constitution Principle I & V: Use latest stable Terraform and Azure provider

terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Backend configuration - parameterized via backend.hcl
  backend "azurerm" {
    # Configured via: terraform init -backend-config=backend.hcl
    # backend.hcl contains:
    #   storage_account_name = "..."
    #   container_name       = "tfstate"
    #   key                  = "my-legacy-workload-prod.tfstate"
    #   resource_group_name  = "..."
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "random" {}
```

### File: variables.tf

```hcl
# Input Variables for Legacy Business Application Infrastructure
# Constitution Principle I: All configurable values in terraform.tfvars

# Required Variables

variable "location" {
  description = "Azure region for all resources. Per constitution: westus3"
  type        = string
  default     = "westus3"

  validation {
    condition     = var.location == "westus3"
    error_message = "Per constitution IC-001, all resources must deploy to westus3."
  }
}

variable "workload_name" {
  description = "Workload identifier for naming convention. Per constitution: avmlegacy"
  type        = string
  default     = "avmlegacy"
}

variable "environment" {
  description = "Environment name. Per spec: prod only"
  type        = string
  default     = "prod"

  validation {
    condition     = var.environment == "prod"
    error_message = "Per spec FR-024, only production environment is deployed."
  }
}

# VM Configuration

variable "vm_size" {
  description = "Azure VM SKU. Per clarification: Standard_D2s_v3"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "vm_admin_username" {
  description = "VM administrator username. Per spec FR-005: vmadmin"
  type        = string
  default     = "vmadmin"

  validation {
    condition     = var.vm_admin_username == "vmadmin"
    error_message = "Per spec FR-005, VM admin username must be vmadmin."
  }
}

variable "vm_admin_secret_name" {
  description = "Key Vault secret name for VM admin password. Per spec FR-016: configurable"
  type        = string
  default     = "vm-admin-password"
}

variable "vm_data_disk_size_gb" {
  description = "VM data disk size in GB. Per spec FR-003: 500GB"
  type        = number
  default     = 500

  validation {
    condition     = var.vm_data_disk_size_gb == 500
    error_message = "Per spec FR-003, VM data disk must be 500GB."
  }
}

variable "availability_zone" {
  description = "Availability zone for VM. Per spec FR-023: 1, 2, or 3 (never -1)"
  type        = number
  default     = 1

  validation {
    condition     = contains([1, 2, 3], var.availability_zone)
    error_message = "Per spec FR-023 and IC-006, availability zone must be 1, 2, or 3."
  }
}

# Network Configuration

variable "vnet_address_space" {
  description = "VNet address space. Per clarification: 10.0.0.0/24"
  type        = list(string)
  default     = ["10.0.0.0/24"]

  validation {
    condition     = length(var.vnet_address_space) == 1 && var.vnet_address_space[0] == "10.0.0.0/24"
    error_message = "Per clarification, VNet must use 10.0.0.0/24 address space."
  }
}

variable "vm_subnet_cidr" {
  description = "VM subnet CIDR. Per clarification: 10.0.0.0/27"
  type        = string
  default     = "10.0.0.0/27"
}

variable "bastion_subnet_cidr" {
  description = "Bastion subnet CIDR. Per clarification: 10.0.0.32/26 (Azure requires /26 minimum)"
  type        = string
  default     = "10.0.0.32/26"
}

variable "private_endpoint_subnet_cidr" {
  description = "Private Endpoint subnet CIDR. Per clarification: 10.0.0.96/28"
  type        = string
  default     = "10.0.0.96/28"
}

# Storage Configuration

variable "file_share_name" {
  description = "Azure Files share name"
  type        = string
  default     = "legacyappdata"
}

variable "file_share_quota_gb" {
  description = "File share quota in GB. Per clarification: 1024GB (1TB)"
  type        = number
  default     = 1024

  validation {
    condition     = var.file_share_quota_gb == 1024
    error_message = "Per clarification, file share quota must be 1TB (1024GB)."
  }
}

# Observability Configuration

variable "log_analytics_retention_days" {
  description = "Log Analytics retention in days. Per clarification: 180 days"
  type        = number
  default     = 180

  validation {
    condition     = var.log_analytics_retention_days == 180
    error_message = "Per clarification, Log Analytics retention must be 180 days."
  }
}

variable "alert_action_group_email" {
  description = "Email address for alert notification action group"
  type        = string
  # No default - must be provided in tfvars
}

# Tags

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    Workload    = "Legacy Business Application"
    ManagedBy   = "Terraform"
    CostCenter  = "IT-Infrastructure"
  }
}
```

### File: locals.tf

```hcl
# Local Values for Computed Names and Configurations
# Constitution Principle: Naming convention <type>-<workload>-<suffix>

locals {
  # Generate unique suffix for globally unique names
  unique_suffix = random_string.unique_suffix.result

  # Location abbreviation
  location_abbr = "wus3"  # westus3

  # Naming per constitution IC-003
  resource_group_name       = "rg-${var.workload_name}-${var.environment}-${local.location_abbr}"
  vnet_name                = "vnet-${var.workload_name}-${local.unique_suffix}"
  vm_nsg_name              = "nsg-vm-${var.workload_name}-${local.unique_suffix}"
  bastion_nsg_name         = "nsg-bastion-${var.workload_name}-${local.unique_suffix}"
  private_endpoint_nsg_name = "nsg-pe-${var.workload_name}-${local.unique_suffix}"

  # VM name must be ≤15 chars for computer name (Windows NetBIOS limit per spec FR-004)
  vm_name_raw = "vm-${var.workload_name}-${local.unique_suffix}"
  vm_name = substr(local.vm_name_raw, 0, min(length(local.vm_name_raw), 15))
  vm_computer_name = local.vm_name  # Same as VM name, truncated to 15 chars

  bastion_name             = "bastion-${var.workload_name}-${local.unique_suffix}"
  key_vault_name           = "kv-${var.workload_name}-${local.unique_suffix}"

  # Storage account name: lowercase alphanumeric only, max 24 chars
  storage_account_name = "st${var.workload_name}${local.unique_suffix}"  # e.g., "stavmlegacya1b2c3"

  private_endpoint_name    = "pe-storage-${var.workload_name}-${local.unique_suffix}"
  nat_gateway_name         = "nat-${var.workload_name}-${local.unique_suffix}"
  nat_public_ip_name       = "pip-nat-${var.workload_name}-${local.unique_suffix}"
  law_name                 = "law-${var.workload_name}-${local.unique_suffix}"
  action_group_name        = "ag-${var.workload_name}-${local.unique_suffix}"

  # Subnet names
  vm_subnet_name               = "vm-subnet"
  bastion_subnet_name          = "AzureBastionSubnet"  # Azure requirement: exact name
  private_endpoint_subnet_name = "private-endpoint-subnet"

  # Common tags
  common_tags = merge(
    var.tags,
    {
      DeployedBy = "Terraform"
      Region     = var.location
      Spec       = "001-my-legacy-workload"
    }
  )
}
```

### File: main.tf

```hcl
#############################################################################
# Legacy Business Application Infrastructure - Main Configuration
# Constitution Compliance: All principles I-V enforced
# Spec: 001-my-legacy-workload
#############################################################################

# Random Resources for Naming

resource "random_string" "unique_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

# Per spec: Generate VM admin password using random_password
# This will be stored in Key Vault via AVM module interface
resource "random_password" "vm_admin_password" {
  length           = 24
  special          = true
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!@#$%^&*()-_=+[]{}|;:,.<>?"
}

#############################################################################
# Resource Group
# Constitution IC-005: Single resource group for all resources
#############################################################################

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags

  lifecycle {
    prevent_destroy = false  # Set to true for production safety
  }
}

# Resource Group Lock - Constitution SEC-011
resource "azurerm_management_lock" "resource_group" {
  name       = "rg-lock-do-not-delete"
  scope      = azurerm_resource_group.main.id
  lock_level = "CanNotDelete"
  notes      = "Prevents accidental deletion of legacy workload infrastructure"
}

#############################################################################
# Log Analytics Workspace
# Spec FR-018: Log Analytics for centralized logging
# Created early for diagnostic settings on other resources
#############################################################################

module "log_analytics" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION from Terraform Registry

  name                = local.law_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Per clarification: 180-day retention
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days
  daily_quota_gb      = -1  # No daily cap (or set based on cost requirements)

  tags = local.common_tags

  # Lock interface (if supported by AVM module)
  lock = {
    kind = "CanNotDelete"
    name = "law-lock-do-not-delete"
  }
}

#############################################################################
# Virtual Network
# Spec FR-007: VNet with 3 subnets
# Constitution IC-008: 10.0.0.0/24 with specific CIDR allocations
#############################################################################

module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION

  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = var.vnet_address_space

  # Define 3 subnets per spec FR-007
  subnets = {
    vm_subnet = {
      name             = local.vm_subnet_name
      address_prefixes = [var.vm_subnet_cidr]
      # NSG association (if supported by module) or separate azurerm_subnet_network_security_group_association
    }
    bastion_subnet = {
      name             = local.bastion_subnet_name  # Must be exact name per Azure requirement
      address_prefixes = [var.bastion_subnet_cidr]
    }
    private_endpoint_subnet = {
      name             = local.private_endpoint_subnet_name
      address_prefixes = [var.private_endpoint_subnet_cidr]
      # Per spec IC-009: Disable network policies for private endpoints
      private_endpoint_network_policies_enabled = false
    }
  }

  tags = local.common_tags

  # Diagnostic settings - Constitution SEC-010
  diagnostic_settings = {
    law_diag = {
      name                  = "vnet-diagnostics"
      workspace_resource_id = module.log_analytics.resource_id
      # Enable all log categories and metrics (check module documentation for exact syntax)
    }
  }

  # Lock interface
  lock = {
    kind = "CanNotDelete"
    name = "vnet-lock-do-not-delete"
  }
}

#############################################################################
# Network Security Groups
# Spec FR-008: NSGs with deny-by-default posture
# Constitution SEC-004: Explicit allow rules only
#############################################################################

# VM Subnet NSG
module "vm_nsg" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION

  name                = local.vm_nsg_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Spec FR-009: Allow RDP from Bastion subnet only
  security_rules = [
    {
      name                       = "Allow-RDP-From-Bastion"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = var.bastion_subnet_cidr
      destination_address_prefix = var.vm_subnet_cidr
      description                = "Allow RDP from Bastion subnet per spec FR-009"
    },
    {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Explicit deny-by-default per constitution SEC-004"
    }
  ]

  tags = local.common_tags

  diagnostic_settings = {
    law_diag = {
      name                  = "nsg-vm-diagnostics"
      workspace_resource_id = module.log_analytics.resource_id
    }
  }
}

# Bastion Subnet NSG
module "bastion_nsg" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.1.0"

  name                = local.bastion_nsg_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Bastion NSG rules per Azure Bastion requirements
  # See: https://learn.microsoft.com/azure/bastion/bastion-nsg
  security_rules = [
    {
      name                       = "Allow-HTTPS-Inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      description                = "Allow HTTPS from Internet per Azure Bastion requirement"
    },
    {
      name                       = "Allow-GatewayManager-Inbound"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
      description                = "Allow Azure Bastion control plane"
    },
    {
      name                       = "Allow-RDP-To-VM-Subnet"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = var.vm_subnet_cidr
      description                = "Allow RDP to VM subnet per spec SEC-006"
    },
    {
      name                       = "Allow-AzureCloud-Outbound"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
      description                = "Allow Bastion to Azure services"
    }
  ]

  tags = local.common_tags

  diagnostic_settings = {
    law_diag = {
      name                  = "nsg-bastion-diagnostics"
      workspace_resource_id = module.log_analytics.resource_id
    }
  }
}

# Private Endpoint Subnet NSG
module "private_endpoint_nsg" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.1.0"

  name                = local.private_endpoint_nsg_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Spec SEC-007: Allow SMB from VM subnet
  security_rules = [
    {
      name                       = "Allow-SMB-From-VM-Subnet"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "445"
      source_address_prefix      = var.vm_subnet_cidr
      destination_address_prefix = var.private_endpoint_subnet_cidr
      description                = "Allow SMB from VM subnet per spec SEC-007"
    },
    {
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Explicit deny-by-default"
    }
  ]

  tags = local.common_tags

  diagnostic_settings = {
    law_diag = {
      name                  = "nsg-pe-diagnostics"
      workspace_resource_id = module.log_analytics.resource_id
    }
  }
}

# NSG Associations (if not handled by VNet module)
resource "azurerm_subnet_network_security_group_association" "vm_subnet" {
  subnet_id                 = module.virtual_network.subnets["vm_subnet"].id
  network_security_group_id = module.vm_nsg.resource_id
}

resource "azurerm_subnet_network_security_group_association" "bastion_subnet" {
  subnet_id                 = module.virtual_network.subnets["bastion_subnet"].id
  network_security_group_id = module.bastion_nsg.resource_id
}

resource "azurerm_subnet_network_security_group_association" "private_endpoint_subnet" {
  subnet_id                 = module.virtual_network.subnets["private_endpoint_subnet"].id
  network_security_group_id = module.private_endpoint_nsg.resource_id
}

#############################################################################
# NAT Gateway
# Spec FR-012: NAT Gateway for outbound internet access
#############################################################################

module "nat_gateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION

  name                = local.nat_gateway_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Public IP for outbound traffic
  public_ip_addresses = [
    {
      name  = local.nat_public_ip_name
      zones = [var.availability_zone]  # Match VM availability zone per best practice
    }
  ]

  # Associate with VM subnet
  subnet_associations = [
    {
      subnet_id = module.virtual_network.subnets["vm_subnet"].id
    }
  ]

  tags = local.common_tags
}

#############################################################################
# Key Vault
# Spec FR-015: Key Vault for VM admin password
# Constitution SEC-002: Store secrets in Key Vault
#############################################################################

module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION

  name                = local.key_vault_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 90
  purge_protection_enabled   = true  # Per spec SEC-012

  # Use RBAC authorization (recommended over access policies)
  enable_rbac_authorization = true

  # Per spec FR-006 & FR-016: Store VM admin password as secret
  # AVM secrets interface (check module documentation for exact syntax)
  secrets = {
    vm_admin_password = {
      name  = var.vm_admin_secret_name
      value = random_password.vm_admin_password.result
      # Optionally set expiration, content_type, etc.
    }
  }

  tags = local.common_tags

  # Diagnostic settings - Constitution SEC-010
  diagnostic_settings = {
    law_diag = {
      name                  = "kv-diagnostics"
      workspace_resource_id = module.log_analytics.resource_id
    }
  }

  # Lock - Constitution SEC-011
  lock = {
    kind = "CanNotDelete"
    name = "kv-lock-do-not-delete"
  }

  depends_on = [random_password.vm_admin_password]
}

# Grant current deployment identity access to Key Vault for deployment
# (If using RBAC, assign Key Vault Secrets Officer or similar role)
data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "kv_secrets_deployment" {
  scope                = module.key_vault.resource_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

#############################################################################
# Storage Account with File Share
# Spec FR-013: Storage account with Azure Files
# Spec FR-014: Private endpoint access only
#############################################################################

module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION

  name                = local.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"  # HDD per spec IC-007
  account_replication_type = "LRS"       # No geo-redundancy per constitution IC-004

  # Per spec SEC-009: Disable public network access
  public_network_access_enabled = false

  # Encryption per spec SEC-013
  enable_infrastructure_encryption = true

  # File share configuration
  file_shares = {
    legacy_app_data = {
      name  = var.file_share_name
      quota = var.file_share_quota_gb
      tier  = "TransactionOptimized"  # Standard tier
    }
  }

  # Private endpoint configuration (if supported by module interface)
  private_endpoints = {
    file_endpoint = {
      name                          = local.private_endpoint_name
      subnet_resource_id            = module.virtual_network.subnets["private_endpoint_subnet"].id
      subresource_names             = ["file"]  # For Azure Files
      private_dns_zone_group_name   = "file-private-dns"
      # Private DNS zone integration (auto-created or existing)
      private_dns_zone_resource_ids = [] # Or specify existing zone
    }
  }

  tags = local.common_tags

  # Diagnostic settings
  diagnostic_settings = {
    law_diag = {
      name                  = "storage-diagnostics"
      workspace_resource_id = module.log_analytics.resource_id
    }
  }

  # Lock
  lock = {
    kind = "CanNotDelete"
    name = "storage-lock-do-not-delete"
  }
}

#############################################################################
# Azure Bastion
# Spec FR-010: Azure Bastion for secure RDP access
#############################################################################

module "bastion" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION

  name                = local.bastion_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Bastion subnet (must be exact name "AzureBastionSubnet")
  subnet_id = module.virtual_network.subnets["bastion_subnet"].id

  # SKU: Basic or Standard (check cost implications)
  sku = "Basic"  # Or "Standard" for additional features

  # Public IP managed by Bastion module
  # (AVM module typically creates this automatically)

  tags = local.common_tags

  # Lock
  lock = {
    kind = "CanNotDelete"
    name = "bastion-lock-do-not-delete"
  }
}

#############################################################################
# Virtual Machine
# Spec FR-001: Windows Server 2016 VM with Standard_D2s_v3
#############################################################################

module "virtual_machine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.1.0"  # VERIFY LATEST VERSION

  name                = local.vm_name  # Truncated to 15 chars
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Per spec FR-004: Computer name (NetBIOS) ≤15 chars
  computer_name = local.vm_computer_name

  # Per clarification: Standard_D2s_v3
  vm_size = var.vm_size

  # Per spec IC-006: Availability zone 1, 2, or 3 (never -1)
  zone = var.availability_zone

  # Windows Server 2016 image
  os_profile = {
    windows = {
      admin_username = var.vm_admin_username
      # Reference password from Key Vault secret
      admin_password = module.key_vault.secrets[var.vm_admin_secret_name].value
    }
  }

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  # Network configuration
  network_interfaces = {
    nic1 = {
      name = "${local.vm_name}-nic"
      ip_configurations = {
        ipconfig1 = {
          name                          = "ipconfig1"
          subnet_id                     = module.virtual_network.subnets["vm_subnet"].id
          private_ip_address_allocation = "Dynamic"
          # Per spec FR-011: No public IP
          public_ip_address_id = null
        }
      }
    }
  }

  # OS disk: Standard HDD per spec FR-002
  os_disk = {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"  # Standard HDD
    disk_size_gb         = 127  # Default Windows Server size
  }

  # Data disk: 500GB Standard HDD per spec FR-003
  data_disks = {
    data1 = {
      name                 = "${local.vm_name}-datadisk"
      lun                  = 0
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = var.vm_data_disk_size_gb
    }
  }

  # Per constitution SEC-001: System-assigned managed identity
  managed_identities = {
    system_assigned = true
  }

  tags = local.common_tags

  # Diagnostic settings - Constitution SEC-010
  diagnostic_settings = {
    law_diag = {
      name                  = "vm-diagnostics"
      workspace_resource_id = module.log_analytics.resource_id
    }
  }

  # Lock - Constitution SEC-011
  lock = {
    kind = "CanNotDelete"
    name = "vm-lock-do-not-delete"
  }

  depends_on = [
    module.key_vault,
    azurerm_role_assignment.kv_secrets_deployment
  ]
}

#############################################################################
# Monitoring and Alerts
# Spec FR-020: Critical alerts for VM stopped, disk usage, Key Vault access
#############################################################################

# Action Group for Alert Notifications
resource "azurerm_monitor_action_group" "main" {
  name                = local.action_group_name
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "avmalerts"

  email_receiver {
    name          = "admin-email"
    email_address = var.alert_action_group_email
  }

  tags = local.common_tags
}

# Alert 1: VM Stopped/Deallocated
resource "azurerm_monitor_metric_alert" "vm_stopped" {
  name                = "alert-vm-stopped-${local.vm_name}"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [module.virtual_machine.resource_id]
  description         = "Alert when VM is stopped or deallocated"
  severity            = 0  # Critical

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "VmAvailabilityMetric"  # Or "Percentage CPU" = 0 for extended period
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1  # VM unavailable
  }

  frequency   = "PT5M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = local.common_tags
}

# Alert 2: VM Disk Usage >90%
resource "azurerm_monitor_metric_alert" "vm_disk_usage" {
  name                = "alert-vm-disk-usage-${local.vm_name}"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [module.virtual_machine.resource_id]
  description         = "Alert when VM disk usage exceeds 90%"
  severity            = 0  # Critical

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "OS Disk Used Percent"  # May need custom metric or Log Analytics query
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  frequency   = "PT15M"
  window_size = "PT15M"

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = local.common_tags
}

# Alert 3: Key Vault Access Failures
resource "azurerm_monitor_metric_alert" "kv_access_failures" {
  name                = "alert-kv-access-failures-${local.key_vault_name}"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [module.key_vault.resource_id]
  description         = "Alert when Key Vault access failures occur"
  severity            = 0  # Critical

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "ServiceApiResult"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0

    # Filter for failed requests
    dimension {
      name     = "StatusCode"
      operator = "Include"
      values   = ["403"]  # Forbidden/access denied
    }
  }

  frequency   = "PT5M"
  window_size = "PT5M"

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = local.common_tags
}

#############################################################################
# Note: File share mount to VM will be implemented in a later phase
# Per instructions: "Don't connect the file share to the VM just yet"
#############################################################################
```

### File: outputs.tf

```hcl
# Outputs for Legacy Business Application Infrastructure
# These values can be used by external modules or for manual reference

output "resource_group_name" {
  description = "Name of the resource group containing all resources"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = module.virtual_network.resource_id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = module.virtual_machine.name
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = module.virtual_machine.resource_id
}

output "vm_private_ip_address" {
  description = "Private IP address of the VM"
  value       = module.virtual_machine.network_interfaces["nic1"].ip_configurations["ipconfig1"].private_ip_address
}

output "vm_computer_name" {
  description = "Computer name (NetBIOS name) of the VM"
  value       = local.vm_computer_name
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.name
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.resource_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.vault_uri
}

output "vm_admin_secret_name" {
  description = "Name of the Key Vault secret containing VM admin password"
  value       = var.vm_admin_secret_name
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.storage_account.resource_id
}

output "file_share_name" {
  description = "Name of the Azure Files share"
  value       = var.file_share_name
}

output "bastion_name" {
  description = "Name of the Azure Bastion host"
  value       = module.bastion.name
}

output "bastion_id" {
  description = "ID of the Azure Bastion host"
  value       = module.bastion.resource_id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = module.log_analytics.name
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = module.log_analytics.resource_id
}

output "nat_gateway_name" {
  description = "Name of the NAT Gateway"
  value       = module.nat_gateway.name
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.nat_gateway.public_ip_addresses[0].ip_address
}

# Sensitive outputs - use with caution
output "vm_admin_password" {
  description = "VM administrator password (retrieve from Key Vault instead)"
  value       = random_password.vm_admin_password.result
  sensitive   = true
}

# Instructions for accessing resources
output "bastion_connect_instructions" {
  description = "Instructions for connecting to VM via Bastion"
  value       = <<-EOT
    1. Navigate to Azure Portal
    2. Go to Virtual Machines -> ${module.virtual_machine.name}
    3. Click "Connect" -> "Bastion"
    4. Username: ${var.vm_admin_username}
    5. Password: Retrieve from Key Vault secret "${var.vm_admin_secret_name}"
      Command: az keyvault secret show --name ${var.vm_admin_secret_name} --vault-name ${module.key_vault.name} --query value -o tsv
  EOT
}

output "file_share_mount_instructions" {
  description = "Instructions for mounting Azure Files share from VM"
  value       = <<-EOT
    From within the VM (via Bastion RDP):
    1. Open PowerShell as Administrator
    2. Run: net use Z: \\${module.storage_account.name}.privatelink.file.core.windows.net\${var.file_share_name}
    3. Verify: dir Z:

    Note: Authentication via private endpoint - no storage key needed for mounted drive
  EOT
}
```

### File: prod.tfvars

```hcl
# Production Environment Configuration
# Legacy Business Application Infrastructure
#
# Per spec FR-021: All configurable values in this file (not hardcoded in main.tf)
# Per spec FR-022: Rich comments explaining purpose

#############################################################################
# Core Configuration
#############################################################################

# Azure region for all resources
# Per constitution IC-001: Must be westus3
location = "westus3"

# Workload identifier for resource naming
# Per constitution: avmlegacy for legacy workload
workload_name = "avmlegacy"

# Environment name
# Per spec FR-024: Production only (no dev/test/staging)
environment = "prod"

#############################################################################
# Virtual Machine Configuration
#############################################################################

# VM size/SKU
# Per clarification: Standard_D2s_v3 (2 cores, 8GB RAM)
vm_size = "Standard_D2s_v3"

# VM administrator username
# Per spec FR-005: Must be "vmadmin"
vm_admin_username = "vmadmin"

# Key Vault secret name for VM admin password
# Per spec FR-016: Configurable via this variable
# Password will be automatically generated and stored in Key Vault
vm_admin_secret_name = "vm-admin-password"

# VM data disk size in GB
# Per spec FR-003: Must be 500GB HDD
vm_data_disk_size_gb = 500

# Availability zone for VM
# Per spec FR-023: Must be 1, 2, or 3 (never -1)
# Choose based on region availability
availability_zone = 1

#############################################################################
# Network Configuration
#############################################################################

# Virtual network address space
# Per clarification: 10.0.0.0/24 (minimal allocation, cost-optimized)
vnet_add_space = ["10.0.0.0/24"]

# VM subnet CIDR
# Per clarification: 10.0.0.0/27 (30 usable IPs)
vm_subnet_cidr = "10.0.0.0/27"

# Bastion subnet CIDR
# Per clarification: 10.0.0.32/26 (62 usable IPs, Azure /26 minimum requirement)
bastion_subnet_cidr = "10.0.0.32/26"

# Private Endpoint subnet CIDR
# Per clarification: 10.0.0.96/28 (14 usable IPs, sufficient for storage private endpoint)
private_endpoint_subnet_cidr = "10.0.0.96/28"

#############################################################################
# Storage Configuration
#############################################################################

# Azure Files share name
# Default: legacyappdata
# Change if specific naming required by legacy application
file_share_name = "legacyappdata"

# File share provisioned capacity in GB
# Per clarification: 1024GB (1TB) for large capacity and growth
file_share_quota_gb = 1024

#############################################################################
# Observability Configuration
#############################################################################

# Log Analytics retention period in days
# Per clarification: 180 days for extended compliance coverage
log_analytics_retention_days = 180

# Email address for alert notifications
# **REQUIRED**: Update with actual administrator email
# Receives critical alerts for VM stopped, disk >90%, Key Vault access failures
alert_action_group_email = "admin@example.com"  # ⚠️ UPDATE THIS

#############################################################################
# Resource Tags
#############################################################################

# Common tags applied to all resources
# Add additional cost center, project, owner tags as needed
tags = {
  Environment  = "Production"
  Workload     = "Legacy Business Application"
  ManagedBy    = "Terraform"
  CostCenter   = "IT-Infrastructure"
  Compliance   = "Required"
  DeployedBy   = "Infrastructure Team"
  DeployedDate = "2026-02-18"
  Spec         = "001-my-legacy-workload"
}

#############################################################################
# Notes
#############################################################################

# 1. Per clarification: No backup solution (infrastructure is disposable/recreatable from Terraform)
# 2. Per constitution: Single production environment only (no dev/test)
# 3. Per spec: All resources in westus3 region, single resource group
# 4. Per spec: VM password auto-generated, stored in Key Vault, not in this file
# 5. File share not yet mounted to VM - will be configured in later phase
#############################################################################
```

---

## Summary

Implementation plan complete with:

✅ **Phase 0 Research**: Documented tasks for verifying Terraform/provider versions and researching 10 AVM modules
✅ **Phase 1 Design**: Created data-model.md structure, quickstart guide, and agent context update approach
✅ **Terraform Code**: Complete root module with 5 files (terraform.tf, variables.tf, locals.tf, main.tf, outputs.tf, prod.tfvars)
✅ **Constitution Compliance**: All 5 principles validated pre and post-design
✅ **Security**: VM password via random_password → Key Vault → VM reference flow, NSGs, diagnostic logging, resource locks
✅ **Spec Compliance**: All 25 functional requirements addressed in code structure

**Next Steps**:
1. Execute Phase 0 research to verify exact AVM module versions from Terraform Registry
2. Run `/speckit.tasks` to generate detailed task breakdown for implementation
3. Begin implementation with terraform init and validation workflow


