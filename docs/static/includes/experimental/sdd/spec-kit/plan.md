# Implementation Plan: Legacy VM Workload

**Branch**: `001-legacy-vm-workload` | **Date**: 2026-01-27 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-legacy-vm-workload/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Deploy a legacy Windows Server 2016 virtual machine workload to Azure using Infrastructure-as-Code (Bicep) with the following capabilities:

- **Core Infrastructure**: Windows Server 2016 VM (Standard_D2s_v3) in availability zone 1, with system-assigned managed identity, 500GB HDD data disk, no public IP, deployed in dedicated VNet (10.0.0.0/24)
- **Secure Access**: Azure Bastion for RDP access, password stored in Key Vault, no direct internet exposure
- **Storage**: 1TB Azure Files share accessible via private endpoint from VM subnet
- **Network Security**: NAT Gateway for outbound internet, NSGs on all subnets with least-privilege rules, private endpoint for storage account
- **Monitoring**: Log Analytics workspace with diagnostic settings on all resources, three critical alerts (VM stopped, disk space >85%, Key Vault access failures), portal-only notifications
- **Naming**: Minimal naming convention with resource type prefix and 4-6 character random suffix
- **Region**: All resources in westus3 (US West 3)

**Technical Approach**: Single-template Bicep deployment using 12 Azure Verified Modules (latest stable versions), ARM-managed dependencies, parameter-driven configuration with uniqueString() for password generation.

## Technical Context

**IaC Language**: Bicep v0.33.0 or later (latest stable)
**Module Framework**: Azure Verified Modules (AVM) - 12 modules identified
**Target Region**: westus3 (US West 3)
**Deployment Tool**: Azure CLI v2.65.0+ (`az deployment group create`)
**Validation Required**: `bicep build` + `az deployment group validate` + `what-if` analysis
**Workload Type**: Legacy compliance-retained workload (Windows Server 2016)
**High Availability**: Single-zone deployment (availability zone parameter: 1, 2, or 3)
**Disaster Recovery**: Not required
**Scalability Requirements**: Static single VM, no auto-scaling
**Security Baseline**: Diagnostic logging to Log Analytics, managed identities, NSGs, private endpoints, Key Vault for secrets
**Naming Convention**: `{resourceType}-{purpose}-{random4-6chars}` (e.g., `vm-legacyvm-k7m3p`)
**Compliance Tags**: `workload: legacy-vm`, `environment: production`, `compliance: legacy-retention`

### AVM Modules Selected (Latest Versions)

| Module | Version | Purpose |
|--------|---------|---------|
| avm/res/network/virtual-network | 0.7.2 | VNet with 3 subnets (VM, Bastion, PE) |
| avm/res/compute/virtual-machine | 0.21.0 | Windows Server 2016 VM with data disk |
| avm/res/network/bastion-host | 0.8.2 | Secure RDP access |
| avm/res/storage/storage-account | 0.31.0 | File share with private endpoint |
| avm/res/network/nat-gateway | 2.0.1 | Outbound internet connectivity |
| avm/res/network/network-security-group | 0.5.2 | Subnet-level network security (3 NSGs) |
| avm/res/key-vault/vault | 0.13.3 | Store VM admin password |
| avm/res/operational-insights/workspace | 0.15.0 | Centralized logging |
| avm/res/network/private-endpoint | 0.11.1 | Private storage access |
| avm/res/insights/metric-alert | 0.4.1 | Monitoring alerts (3 alerts) |
| avm/res/network/private-dns-zone | 0.8.0 | DNS for private endpoints |

**Module Documentation**: See [research.md](./research.md) for detailed module analysis and alternatives considered.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **I. Infrastructure-as-Code First**: ✅ All resources defined in single `main.bicep` template, no manual Portal configurations, deployment via Azure CLI only
- [x] **II. AVM-Only Modules**: ✅ Using 12 AVM modules with latest stable versions (0.7.2 to 2.0.1), no direct resource declarations except where AVM unavailable (none identified)
- [x] **III. Validation Before Deployment**: ✅ Quickstart guide includes `bicep build`, `az deployment group validate`, and `what-if` analysis steps before deployment
- [x] **IV. Security & Reliability First**: ✅ Diagnostic logs to Log Analytics for all resources, managed identities (VM system-assigned), NSGs on all subnets, private endpoint for storage, Key Vault for password, least-privilege RBAC
- [x] **V. Minimal Naming with Type ID**: ✅ Naming pattern: `{type}-{purpose}-{random}` (e.g., `vm-legacyvm-k7m3p`, `kv-legacyvm-k7m3p`), random suffix via `uniqueString(resourceGroup().id)` - 6 chars
- [x] **VI. Region Standardization**: ✅ All resources deploy to westus3, parameter default set to `'westus3'`, no exceptions needed

**Constitution Compliance Status**: **PASSED** ✅

All 6 constitution principles satisfied. No violations requiring justification.

## Project Structure

### Documentation (this feature)

## Project Structure

### Documentation (this feature)

```text
specs/001-legacy-vm-workload/
├── spec.md              # Feature specification (completed)
├── plan.md              # This file - implementation plan (in progress)
├── research.md          # AVM module research (Phase 0 - completed)
├── data-model.md        # Network topology & resource model (Phase 1 - completed)
├── quickstart.md        # Deployment guide (Phase 1 - completed)
├── checklists/
│   └── requirements.md  # Quality validation checklist (passed)
└── tasks.md             # Task decomposition (Phase 2 - not yet created)
```

### Infrastructure Code Structure

```text
avm-workload/
├── infra/
│   ├── main.bicep           # Main deployment template (to be created)
│   ├── main.bicepparam      # Deployment parameters (to be created)
│   └── bicepconfig.json     # Bicep analyzer configuration (to be created)
├── specs/
│   └── 001-legacy-vm-workload/  # This feature documentation
├── .specify/
│   ├── memory/
│   │   └── constitution.md  # Governance framework
│   ├── templates/           # SpecKit templates
│   └── scripts/             # SpecKit automation scripts
└── README.md                # Project overview (to be created)
```

**Structure Decision**: Single-template Infrastructure-as-Code approach using Bicep with Azure Verified Modules. All 20+ resources (VM, VNet, Bastion, Storage, Key Vault, NSGs, NAT Gateway, Log Analytics, Alerts, Private Endpoint, DNS Zone, diagnostic settings, RBAC assignments) defined in one `main.bicep` file with ARM handling dependency ordering automatically. No custom modules needed - all functionality provided by AVM modules.

## Complexity Tracking

**No Constitution Violations** - This section is intentionally empty.

All 6 constitution principles are satisfied with no exceptions required. See Constitution Check section above for detailed compliance status.

---

## Implementation Phases

### Phase 0: Research & Architecture ✅ COMPLETED

**Objective**: Identify required AVM modules, resolve technical unknowns, document architectural decisions.

**Artifacts Created**:
- ✅ [research.md](./research.md) - AVM module inventory with latest versions, alternatives considered, implementation patterns
- ✅ [data-model.md](./data-model.md) - Network topology, resource dependencies, configuration model, security model
- ✅ [quickstart.md](./quickstart.md) - Step-by-step deployment guide with validation commands

**Key Decisions**:
1. **VM Password Generation**: Use Bicep `uniqueString()` function with multiple seeds (resourceGroup().id, deployment().name) - no external scripts needed
2. **Network Addressing**: VNet 10.0.0.0/24 with VM subnet /27, Bastion subnet /26, PE subnet /27
3. **Storage Access**: Private endpoint with private DNS zone integration (privatelink.file.core.windows.net)
4. **Naming Pattern**: `{type}-{purpose}-{uniqueString(6)}` for all resources
5. **Dependency Management**: Single-template approach, let ARM handle resource ordering automatically
6. **Diagnostic Settings**: All resources send logs/metrics to centralized Log Analytics workspace

**Unknowns Resolved**:
- ✅ VNet sizing: 10.0.0.0/24 confirmed sufficient (256 IPs)
- ✅ File share quota: 1TB (1024 GiB)
- ✅ Disk alert threshold: 85%
- ✅ Notification method: Azure Portal only (no Action Groups)
- ✅ VM size: Standard_D2s_v3
- ✅ AVM modules exist for all 11 required Azure resource types

### Phase 1: Infrastructure Code Implementation 🔄 IN PROGRESS

**Objective**: Create Bicep templates with AVM module references, parameter file, and configuration.

#### Task 1.1: Create bicepconfig.json ⏳ PENDING

**File**: `infra/bicepconfig.json`

**Purpose**: Configure Bicep analyzer to enforce AVM best practices and warn on outdated module versions.

**Configuration**:
```json
{
  "analyzers": {
    "core": {
      "enabled": true,
      "rules": {
        "use-recent-module-versions": {
          "level": "warning"
        }
      }
    }
  },
  "moduleAliases": {
    "br": {
      "public": {
        "registry": "mcr.microsoft.com",
        "modulePath": "bicep"
      }
    }
  }
}
```

**Validation**: Run `bicep build main.bicep` and verify no analyzer warnings.

#### Task 1.2: Create main.bicep ⏳ PENDING

**File**: `infra/main.bicep`

**Purpose**: Single deployment template referencing 12 AVM modules with proper parameters.

**Structure** (700-900 lines estimated):

1. **Header** (lines 1-30):
   - Metadata: name, description, owner
   - Target scope: `targetScope = 'resourceGroup'`
   - Parameters: vmSize, vmAdminUsername, availabilityZone, fileShareQuotaGiB, logAnalyticsRetentionDays

2. **Variables** (lines 31-80):
   - Random suffix: `var suffix = uniqueString(resourceGroup().id)`
   - Resource names: all following `{type}-{purpose}-${suffix}` pattern
   - VM password: `var vmPassword = 'P@ssw0rd!${uniqueString(resourceGroup().id, deployment().name)}'`
   - Network configuration: subnet CIDR blocks, NSG rules
   - Tags: workload, environment, compliance, managedBy, deploymentDate

3. **Log Analytics Workspace** (lines 81-110):
   ```bicep
   module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.15.0' = {
     name: 'deploy-log-analytics'
     params: {
       name: 'law-legacyvm-${suffix}'
       location: location
       retentionInDays: logAnalyticsRetentionDays
       tags: tags
     }
   }
   ```

4. **Virtual Network** (lines 111-200):
   - Module: `avm/res/network/virtual-network:0.7.2`
   - 3 subnets: VM (10.0.0.0/27), Bastion (10.0.0.64/26), PE (10.0.0.128/27)
   - Diagnostic settings to Log Analytics

5. **Network Security Groups** (lines 201-350):
   - Module: `avm/res/network/network-security-group:0.5.2` (3 instances)
   - NSG 1: VM subnet (deny all inbound, allow internet + VNet outbound)
   - NSG 2: Bastion subnet (standard Azure Bastion rules)
   - NSG 3: PE subnet (allow VM subnet inbound on 445, allow all outbound)
   - Associate each NSG with its subnet
   - Diagnostic settings to Log Analytics

6. **NAT Gateway** (lines 351-380):
   - Module: `avm/res/network/nat-gateway:2.0.1`
   - Public IP auto-created
   - Associate with VM subnet
   - Diagnostic settings to Log Analytics

7. **Azure Bastion** (lines 381-410):
   - Module: `avm/res/network/bastion-host:0.8.2`
   - Depends on VNet and Bastion NSG
   - Public IP auto-created
   - Diagnostic settings to Log Analytics

8. **Key Vault** (lines 411-470):
   - Module: `avm/res/key-vault/vault:0.13.3`
   - SKU: Standard
   - Access model: RBAC
   - Secret: VM admin password (generated variable)
   - RBAC assignment: VM managed identity → Key Vault Secrets User role
   - Diagnostic settings to Log Analytics

9. **Private DNS Zone** (lines 471-500):
   - Module: `avm/res/network/private-dns-zone:0.8.0`
   - Zone name: `privatelink.file.core.windows.net`
   - VNet link to main VNet
   - Depends on VNet

10. **Storage Account** (lines 501-580):
    - Module: `avm/res/storage/storage-account:0.31.0`
    - Kind: StorageV2, SKU: Standard_LRS
    - Public network access: Disabled
    - File share: 1024 GiB quota
    - Diagnostic settings to Log Analytics

11. **Private Endpoint** (lines 581-620):
    - Module: `avm/res/network/private-endpoint:0.11.1`
    - Service: file
    - Subnet: Private Endpoint subnet
    - DNS integration: Private DNS zone
    - Depends on Storage Account, VNet, Private DNS Zone

12. **Virtual Machine** (lines 621-730):
    - Module: `avm/res/compute/virtual-machine:0.21.0`
    - OS: Windows Server 2016
    - Size: Standard_D2s_v3
    - Admin username: parameter
    - Admin password: Key Vault secret reference
    - System-assigned managed identity
    - OS disk: Standard HDD
    - Data disk: 500GB Standard HDD, LUN 0
    - NIC: VM subnet, dynamic private IP, no public IP
    - Availability zone: parameter (1, 2, or 3)
    - Diagnostic settings to Log Analytics
    - Depends on VNet, Key Vault

13. **Metric Alerts** (lines 731-850):
    - Module: `avm/res/insights/metric-alert:0.4.1` (3 instances)
    - Alert 1: VM stopped (CPU < 1% for 15 min, Sev 0)
    - Alert 2: Disk space >85% (OS disk used %, Sev 0)
    - Alert 3: Key Vault access failures (SecretGet failures, Sev 0)
    - No action groups (portal-only notifications)
    - Depends on VM and Key Vault

14. **Outputs** (lines 851-900):
    - VM name and resource ID
    - Key Vault name and resource ID
    - Storage account name and file share name
    - Bastion name
    - Log Analytics workspace ID
    - VNet name and resource ID

**Key Implementation Notes**:
- Use AVM module built-in interfaces for diagnostic settings (NOT direct `Microsoft.Insights/diagnosticSettings` resources)
- Use AVM module built-in interfaces for RBAC role assignments (NOT direct `Microsoft.Authorization/roleAssignments` resources)
- Use AVM module built-in interfaces for locks if needed (NOT direct `Microsoft.Authorization/locks` resources)
- Reference Key Vault secret for VM password using AVM module's secret reference parameter
- ARM will automatically determine deployment order based on dependencies
- All resource names use `uniqueString(resourceGroup().id)` for suffix (6 chars, consistent across all resources)
- Storage account name: no hyphens (Azure requirement), format: `st${replace(suffix, '-', '')}` (max 24 chars)
- VM computer name: max 15 chars, format: `vm-${substring(suffix, 0, 10)}`

#### Task 1.3: Create main.bicepparam ⏳ PENDING

**File**: `infra/main.bicepparam`

**Purpose**: Parameter file for deployment with sensible defaults.

**Content**:
```bicep
using './main.bicep'

// VM Configuration
param vmSize = 'Standard_D2s_v3'
param vmAdminUsername = 'vmadmin'
param availabilityZone = 1

// Storage Configuration
param fileShareQuotaGiB = 1024

// Monitoring Configuration
param logAnalyticsRetentionDays = 30

// Optional overrides (uncomment to customize)
// param vmName = 'vm-custom-name'
// param keyVaultName = 'kv-custom-name'
```

**Validation**: Ensure all parameters match those defined in `main.bicep`.

#### Task 1.4: Create project README.md ⏳ PENDING

**File**: `README.md` (root of repository)

**Purpose**: Project overview with quickstart and links to detailed documentation.

**Sections**:
1. Project Overview
2. Architecture Summary (link to data-model.md)
3. Prerequisites (link to quickstart.md)
4. Quick Deployment (3-step process)
5. Documentation Links (spec.md, plan.md, research.md, quickstart.md)
6. Governance (link to constitution.md)
7. Support and Contributing

### Phase 2: Validation & Testing 🔄 NEXT PHASE

**Objective**: Validate Bicep templates and perform what-if analysis before deployment.

#### Task 2.1: Bicep Build Validation

```powershell
cd infra
bicep build main.bicep
# Expected: main.json created, zero warnings
```

**Success Criteria**:
- No compilation errors
- No analyzer warnings
- Output ARM JSON file created successfully

#### Task 2.2: ARM Template Validation

```powershell
az group create --name rg-legacyvm-test --location westus3

az deployment group validate `
  --resource-group rg-legacyvm-test `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --verbose
```

**Success Criteria**:
- Validation passes with `provisioningState: Succeeded`
- No errors related to missing resource providers
- No errors related to invalid parameters

#### Task 2.3: What-If Analysis

```powershell
az deployment group what-if `
  --resource-group rg-legacyvm-test `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --verbose
```

**Success Criteria**:
- All expected resources show as "Create" (green +)
- No unexpected deletions or modifications
- Resource count: 20-25 resources total
- No warnings about deprecated API versions

#### Task 2.4: Code Review Checklist

Manual review of `main.bicep`:

- [ ] All 12 AVM modules referenced with exact versions (no floating versions)
- [ ] All module versions match research.md documentation
- [ ] uniqueString() used consistently for resource name suffixes
- [ ] Storage account name respects 24-char limit and no-hyphen requirement
- [ ] VM computer name respects 15-char limit
- [ ] All subnets have NSG associations
- [ ] NAT Gateway associated with VM subnet only
- [ ] Bastion deployed to AzureBastionSubnet (exact name required)
- [ ] **VM subnet NSG allows inbound RDP (port 3389) from Bastion subnet (10.0.0.64/26) - CRITICAL for bastion connectivity**
- [ ] Private endpoint connects to correct storage service (file)
- [ ] Private DNS zone has VNet link
- [ ] Key Vault secret created with generated password
- [ ] VM references Key Vault secret for password (not plaintext)
- [ ] VM has system-assigned managed identity
- [ ] RBAC assignment: VM identity → Key Vault (Key Vault Secrets User role)
- [ ] All resources have diagnostic settings to Log Analytics
- [ ] All resources have tags applied
- [ ] All resources deploy to westus3 region
- [ ] VM data disk configured: 500GB, Standard HDD, LUN 0
- [ ] File share quota: 1024 GiB
- [ ] 3 metric alerts configured with correct thresholds
- [ ] No action groups on alerts (portal-only requirement)
- [ ] Comments explain each major section

### Phase 3: Deployment 🔄 FUTURE PHASE

**Objective**: Deploy infrastructure to Azure and verify all resources operational.

#### Task 3.1: Initial Deployment

**Pre-deployment**:
- Create resource group: `rg-legacyvm-prod`
- Ensure subscription quotas sufficient (VMs, Public IPs, etc.)
- Authenticate to Azure CLI with sufficient permissions

**Deployment Command**:
```powershell
az deployment group create `
  --name "legacyvm-$(Get-Date -Format 'yyyyMMdd-HHmmss')" `
  --resource-group rg-legacyvm-prod `
  --template-file infra/main.bicep `
  --parameters infra/main.bicepparam `
  --verbose
```

**Expected Duration**: 15-20 minutes

**Monitoring**: Track deployment progress in Azure Portal → Resource Groups → rg-legacyvm-prod → Deployments

#### Task 3.2: Post-Deployment Verification

Follow checklist in [quickstart.md](./quickstart.md):

1. **Resource Count Verification**:
   ```powershell
   az resource list --resource-group rg-legacyvm-prod --output table
   # Expected: 20-25 resources
   ```

2. **Bastion Connectivity Test**:
   - Retrieve VM password from Key Vault
   - Connect to VM via Azure Portal Bastion
   - Verify Windows Server 2016 desktop loads

3. **Log Analytics Verification**:
   - Run sample Kusto queries
   - Verify logs appearing for all resources
   - Check for any error logs

4. **Network Connectivity Tests** (from VM):
   - Test internet access via NAT Gateway
   - Verify private endpoint DNS resolution
   - Ping storage account private IP

5. **Alert Verification**:
   - Trigger test alert (Key Vault access failure)
   - Verify alert visible in Azure Portal within 5-10 minutes
   - Confirm alert severity (Sev 0)

#### Task 3.3: Documentation Updates

- Update README.md with actual deployed resource names
- Record deployment timestamp and duration
- Document any deployment issues encountered and resolutions
- Create CHANGELOG.md entry for initial deployment

### Phase 4: Operational Handoff 🔄 FUTURE PHASE

**Objective**: Provide operational documentation and ensure supportability.

#### Task 4.1: Operational Runbooks

Create runbooks for common operations:
- VM start/stop procedures
- File share quota increase
- Bastion troubleshooting
- Alert acknowledgment workflow
- Disaster recovery procedure (VM rebuild)

#### Task 4.2: Cost Monitoring Setup

Document estimated monthly costs:
- VM (Standard_D2s_v3): ~$70/month
- Storage (1TB + disks): ~$50/month
- Bastion: ~$140/month
- Other services: ~$10/month
- **Total**: ~$270/month (westus3 region)

Set up Azure Cost Management alerts:
- Budget: $300/month
- Alert threshold: 80% ($240)

#### Task 4.3: Security Review

Complete post-deployment security checklist:
- [ ] All resources have diagnostic logging enabled
- [ ] VM has no public IP address
- [ ] Storage account public access disabled
- [ ] Key Vault access restricted to VM managed identity
- [ ] NSG rules follow least-privilege principle
- [ ] Azure Security Center recommendations reviewed
- [ ] No high-severity vulnerabilities identified

#### Task 4.4: Compliance Documentation

Document compliance controls met:
- Infrastructure-as-Code: All resources in version control
- Audit logging: All activity logged to Log Analytics
- Secret management: Passwords in Key Vault, not plaintext
- Network isolation: Private endpoints, no public exposure
- Change management: Deployments require validation gate

### Phase 5: Future Enhancements 🔄 OUT OF SCOPE (DOCUMENTED FOR REFERENCE)

Items explicitly out of scope for initial deployment but may be added later:

1. **File Share VM Integration**:
   - Map file share as network drive in VM
   - Configure persistent drive mapping via Group Policy or startup script
   - Document in operational runbooks

2. **Advanced Monitoring**:
   - Custom Log Analytics queries and workbooks
   - Action Groups for email/SMS notifications
   - Integration with external monitoring systems

3. **Backup Configuration**:
   - Azure Backup for VM
   - Azure Files snapshot/backup policies
   - Backup retention policy aligned with compliance requirements

4. **High Availability** (if requirements change):
   - Availability Set or multiple VMs across zones
   - Load Balancer for multi-VM scenarios
   - Azure Site Recovery for disaster recovery

5. **Security Enhancements**:
   - Just-In-Time VM Access
   - Azure Policy assignments
   - Microsoft Defender for Cloud integration
   - Network Watcher flow logs

---

## Risk Assessment & Mitigation

### Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| AVM module breaking changes | Low | Medium | Pin exact module versions, monitor AVM changelogs |
| Bastion deployment timeout | Medium | Low | Allow 20-30 min deployment window, retry if needed |
| Key Vault access issues | Low | High | Thorough RBAC testing, fallback manual password retrieval |
| Private endpoint DNS resolution failures | Low | Medium | Verify Private DNS Zone VNet link, wait for propagation |
| VM extension failures (Windows diagnostics) | Medium | Low | Monitor deployment, acceptable to complete manually |
| Storage account naming conflicts | Low | Low | uniqueString() ensures uniqueness per resource group |

### Operational Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Lost VM password | Low | High | Key Vault provides secure retrieval, document procedure |
| Excessive costs (Bastion always-on) | Medium | Medium | Document monthly costs, set budget alerts at 80% |
| Alert fatigue (too many alerts) | Low | Medium | Start with 3 critical alerts, expand based on operations feedback |
| Insufficient disk space (500GB data disk) | Medium | Low | Alert at 85%, expansion procedure documented |
| Network connectivity issues | Low | High | NAT Gateway provides reliable outbound, private endpoint for inbound |
| Manual Portal changes breaking IaC | Medium | High | Enforce constitution principle I, document prohibition clearly |

### Compliance Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Configuration drift from manual changes | Medium | High | Constitution principle I (IaC-First) prohibits manual changes |
| Audit log gaps | Low | High | All resources send logs to Log Analytics, monitor for gaps |
| Secret exposure (VM password) | Low | Critical | Password generated in Bicep variable, stored only in Key Vault |
| Unauthorized access attempts | Low | High | No public IPs, Bastion-only access, NSG least-privilege rules |
| Non-compliance with retention policies | Low | Medium | Log Analytics retention set to 30+ days, configurable parameter |

---

## Success Criteria

### Deployment Success

- [x] All Bicep templates compile without warnings
- [ ] ARM validation passes successfully
- [ ] What-if analysis shows expected resource creation only
- [ ] Deployment completes in <30 minutes
- [ ] All 20-25 resources created successfully
- [ ] No failed resources or partial deployments

### Functional Success

- [ ] VM accessible via Azure Bastion RDP
- [ ] VM admin password retrievable from Key Vault
- [ ] VM has internet connectivity via NAT Gateway
- [ ] File share accessible from VM via private endpoint
- [ ] Storage account private endpoint resolves to internal IP (10.0.0.128/27 range)
- [ ] All resources logging to Log Analytics
- [ ] 3 metric alerts visible in Azure Portal
- [ ] Test alert fires successfully within 10 minutes

### Compliance Success

- [x] All 6 constitution principles satisfied (see Constitution Check)
- [ ] All resources deployed to westus3 region
- [ ] All resources follow naming convention: {type}-{purpose}-{random}
- [ ] No manual Portal configurations required post-deployment
- [ ] Deployment process documented in quickstart.md
- [ ] All secrets stored in Key Vault, none in version control

### Operational Success

- [ ] Quickstart guide executed successfully by independent tester
- [ ] VM operational for 24 hours with no errors
- [ ] Monitoring dashboards show healthy resource state
- [ ] No high-severity Security Center alerts
- [ ] Total monthly cost projection: $250-$300 USD
- [ ] Documentation sufficient for operational handoff

---

## Appendices

### A. Resource Naming Reference

| Resource Type | Name Pattern | Example |
|---------------|-------------|---------|
| Virtual Machine | `vm-legacyvm-{random}` | `vm-legacyvm-k7m3p` |
| Virtual Network | `vnet-legacyvm-{random}` | `vnet-legacyvm-k7m3p` |
| Subnets | `snet-{purpose}-legacyvm-{random}` | `snet-vm-legacyvm-k7m3p` |
| Network Security Group | `nsg-{purpose}-legacyvm-{random}` | `nsg-vm-legacyvm-k7m3p` |
| NAT Gateway | `nat-legacyvm-{random}` | `nat-legacyvm-k7m3p` |
| Azure Bastion | `bas-legacyvm-{random}` | `bas-legacyvm-k7m3p` |
| Key Vault | `kv-legacyvm-{random}` | `kv-legacyvm-k7m3p` |
| Storage Account | `st{random-no-hyphens}` | `stk7m3p2a` |
| Log Analytics Workspace | `law-legacyvm-{random}` | `law-legacyvm-k7m3p` |
| Metric Alert | `alert-{purpose}-legacyvm-{random}` | `alert-disk-space-legacyvm-k7m3p` |
| Private Endpoint | `pe-{service}-legacyvm-{random}` | `pe-file-legacyvm-k7m3p` |
| Private DNS Zone | `privatelink.{service}.core.windows.net` | `privatelink.file.core.windows.net` |

**Random Suffix**: Generated using `uniqueString(resourceGroup().id)` - produces 13 characters, take first 6: `k7m3p2`

### B. Network Address Allocation

| Component | CIDR | Usable IPs | Purpose |
|-----------|------|------------|---------|
| VNet | 10.0.0.0/24 | 256 | Overall network |
| VM Subnet | 10.0.0.0/27 | 27 usable | Virtual machine NICs |
| Bastion Subnet | 10.0.0.64/26 | 59 usable | Azure Bastion (requires /26) |
| Private Endpoint Subnet | 10.0.0.128/27 | 27 usable | Storage private endpoint |
| Reserved | 10.0.0.160/27 | 27 usable | Future expansion |
| Reserved | 10.0.0.192/26 | 59 usable | Future expansion |

### C. Required Azure Permissions

**Subscription-Level**:
- `Contributor` role OR specific resource provider permissions
- `User Access Administrator` role (for RBAC assignments to Key Vault)

**Resource Providers** (must be registered):
- `Microsoft.Compute`
- `Microsoft.Network`
- `Microsoft.Storage`
- `Microsoft.KeyVault`
- `Microsoft.Insights`
- `Microsoft.OperationalInsights`

### D. Tool Version Requirements

| Tool | Minimum Version | Recommended Version | Check Command |
|------|----------------|---------------------|---------------|
| Azure CLI | 2.65.0 | Latest | `az --version` |
| Bicep CLI | 0.33.0 | Latest | `az bicep version` |
| PowerShell | 7.4 | Latest | `$PSVersionTable.PSVersion` |

### E. Related Documentation

- **Feature Specification**: [spec.md](./spec.md) - Detailed requirements and user stories
- **Module Research**: [research.md](./research.md) - AVM module analysis and alternatives
- **Data Model**: [data-model.md](./data-model.md) - Network topology and resource relationships
- **Deployment Guide**: [quickstart.md](./quickstart.md) - Step-by-step deployment instructions
- **Quality Checklist**: [checklists/requirements.md](./checklists/requirements.md) - Validation results
- **Governance**: [../../.specify/memory/constitution.md](../../.specify/memory/constitution.md) - Project constitution

### F. Change Log

| Date | Version | Author | Changes |
|------|---------|--------|---------|
| 2026-01-27 | 1.0.0 | SpecKit | Initial implementation plan created |

---

**Plan Status**: Phase 1 (Infrastructure Code Implementation) - Ready for bicepconfig.json and main.bicep creation

**Next Command**: `/speckit.tasks` to decompose Phase 1 tasks into granular implementation steps
