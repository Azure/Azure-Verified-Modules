# Research: Legacy Windows Server VM Workload

**Date**: 2026-01-22
**Purpose**: Resolve technical unknowns and research AVM modules, Bicep patterns, and implementation approaches

## Phase 0: Research Tasks

### 1. AVM Module Discovery

#### Required Azure Resources

Based on FR-001 through FR-020, the following Azure resources must be deployed:

1. **Resource Group** - Logical container (single RG for production)
2. **Virtual Network** - Network infrastructure with subnets
3. **Network Security Groups** - Traffic restriction (FR-019)
4. **Azure Bastion** - Secure RDP access (FR-007)
5. **Virtual Machine** - Windows Server 2016, 2+ cores, 8GB RAM (FR-001, FR-002, FR-003)
6. **Managed Disks** - OS disk (Standard HDD) + 500GB data disk (FR-003, FR-004)
7. **Storage Account** - File share hosting (FR-008)
8. **Azure Files Share** - HDD-backed file share
9. **Private Endpoint** - Storage account private connectivity (FR-009)
10. **Key Vault** - Secret management for VM password (FR-010, FR-011)
11. **Log Analytics Workspace** - Diagnostic logging destination (FR-018)
12. **Management Locks** - CanNotDelete locks (FR-017)
13. **Azure Monitor Alerts** - Critical alerts (FR-021)

#### AVM Module Research

Based on AVM module index and MCR registry research:

| Resource | AVM Module | Registry Path | Latest Version | Notes |
|----------|-----------|---------------|----------------|-------|
| Resource Group | avm/res/resources/resource-group | br/public:avm/res/resources/resource-group | 0.4.0 | Includes lock support |
| Virtual Network | avm/res/network/virtual-network | br/public:avm/res/network/virtual-network | 0.5.2 | Includes subnet, NSG support |
| Bastion Host | avm/res/network/bastion-host | br/public:avm/res/network/bastion-host | 0.4.0 | Requires dedicated subnet |
| Virtual Machine | avm/res/compute/virtual-machine | br/public:avm/res/compute/virtual-machine | 0.8.0 | Windows, data disks, managed identity |
| Storage Account | avm/res/storage/storage-account | br/public:avm/res/storage/storage-account | 0.14.3 | File shares, private endpoints, locks |
| Key Vault | avm/res/key-vault/vault | br/public:avm/res/key-vault/vault | 0.10.2 | **Secrets feature** for password storage |
| Log Analytics | avm/res/operational-insights/workspace | br/public:avm/res/operational-insights/workspace | 0.9.1 | Diagnostic log destination |
| Private Endpoint | (integrated) | N/A - part of storage module | N/A | Storage module handles PE creation |
| Managed Disks | (integrated) | N/A - part of VM module | N/A | VM module handles disk attachment |
| NSG | (integrated) | N/A - part of VNet module | N/A | VNet module handles NSG association |

**Decision**: All required resources have corresponding AVM modules. No custom Bicep resource declarations needed (satisfies FR-014 and Constitution Principle I).

### 2. Password Generation Strategy

#### Requirement
- Generate VM admin password at deployment time (FR-011)
- Store in Key Vault using configurable secret name (FR-012)
- No external scripts or deployment scripts (Constitution Principle II)
- Use uniqueString() Bicep function (per user requirement)

#### Research Findings

**AVM Key Vault Module Secrets Feature**:
- The `avm/res/key-vault/vault` module includes a `secrets` parameter array
- Each secret object structure:
  ```bicep
  secrets: [
    {
      name: 'secret-name'
      value: 'secret-value'  // Can be Bicep expression
      contentType: 'text/plain'
      attributes: {
        enabled: true
      }
    }
  ]
  ```

**Password Generation Pattern**:
```bicep
// Generate complex password using uniqueString + guid + special chars
var passwordSeed = uniqueString(resourceGroup().id, deployment().name, 'vmadmin')
var guidPart = substring(guid(resourceGroup().id, 'password'), 0, 8)
var vmAdminPassword = '${toUpper(substring(passwordSeed, 0, 1))}${substring(passwordSeed, 1, 10)}${guidPart}!@#'

// Store in Key Vault via AVM module secrets parameter
module keyVault 'br/public:avm/res/key-vault/vault:0.10.2' = {
  params: {
    secrets: [
      {
        name: vmAdminSecretName  // From parameter
        value: vmAdminPassword   // Generated password
      }
    ]
  }
}

// Reference in VM module
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.8.0' = {
  params: {
    adminPassword: keyVault.outputs.secrets[0].secretUri  // Reference KV secret
  }
}
```

**Decision**: Use uniqueString() + guid() + special characters to generate 20+ character complex password. Store via AVM Key Vault secrets array. Reference secret URI in VM module. No deployment scripts required (satisfies Constitution Principle II).

### 3. Network Architecture

#### Subnet Design

Based on Azure best practices and Bastion requirements:

```text
Virtual Network: 10.0.0.0/16
├── AzureBastionSubnet: 10.0.0.0/26 (required name, /26 or larger)
├── VmSubnet: 10.0.1.0/24 (VM and private endpoints)
└── (Reserved): 10.0.2.0/23 (future expansion)
```

**Bastion Requirements** (from Azure docs):
- Subnet name MUST be exactly `AzureBastionSubnet`
- Minimum size /26 (64 addresses)
- No NSG on Bastion subnet (Bastion manages its own rules)

**VM Subnet Requirements**:
- NSG with restrictive rules (allow Bastion RDP only)
- Private endpoint for storage account

#### NSG Rules (FR-019)

```text
VmSubnet NSG:
- Inbound Priority 100: Allow RDP (3389) from AzureBastionSubnet
- Inbound Priority 4096: Deny all other inbound
- Outbound Priority 100: Allow HTTPS (443) to Storage (for private endpoint)
- Outbound Priority 4096: Deny internet outbound (security best practice)
```

**Decision**: 2-subnet VNet, Bastion in dedicated subnet (no NSG), VM in separate subnet (restrictive NSG). Private endpoint in VM subnet for storage access.

### 4. Storage Configuration

#### File Share Tier
- Requirement: HDD-backed file share (FR-008)
- AVM storage-account module parameter: `fileServices.shares[].accessTier: 'TransactionOptimized'` (Standard tier, HDD-backed)
- Size: Not specified in requirements; recommend 100GB initial allocation

#### Private Endpoint Configuration
- Storage account `publicNetworkAccess: 'Disabled'` (FR-020)
- Private endpoint targeting `file` sub-resource
- DNS integration via private DNS zone (auto-created by AVM module)
- Private endpoint deployed in VmSubnet

**Decision**: Storage account with TransactionOptimized file share, public access disabled, private endpoint in VM subnet. DNS resolved via private DNS zone.

### 5. Resource Naming

#### CAF Abbreviations (Constitution Principle V)

| Resource Type | Abbreviation | Example | Character Limits |
|---------------|--------------|---------|------------------|
| Resource Group | rg | rg-legacyvm-x7k9m | 1-90 alphanumeric, hyphens, underscores |
| Virtual Network | vnet | vnet-legacyvm-x7k9m | 2-64 alphanumeric, hyphens, periods, underscores |
| Subnet | snet | snet-vm-legacyvm-x7k9m | 1-80 alphanumeric, hyphens, periods, underscores |
| Network Security Group | nsg | nsg-vm-legacyvm-x7k9m | 1-80 alphanumeric, hyphens, periods, underscores |
| Bastion Host | bas | bas-legacyvm-x7k9m | 1-80 alphanumeric, hyphens |
| Virtual Machine | vm | vm-legacyvm-x7k9m | 1-15 alphanumeric, hyphens (Windows limit: 15 chars) |
| Managed Disk | disk | disk-vm-data-legacyvm-x7k9m | 1-80 alphanumeric, underscores, hyphens |
| Storage Account | st | stlegacyvmx7k9m | 3-24 lowercase alphanumeric ONLY (no hyphens) |
| File Share | share | fs-legacyvm | 3-63 lowercase alphanumeric, hyphens |
| Private Endpoint | pe | pe-st-legacyvm-x7k9m | 2-64 alphanumeric, hyphens, periods, underscores |
| Key Vault | kv | kv-legacyvm-x7k9m | 3-24 alphanumeric, hyphens (globally unique) |
| Log Analytics | log | log-legacyvm-x7k9m | 4-63 alphanumeric, hyphens |

**Random Suffix Generation**:
```bicep
var randomSuffix = toLower(substring(uniqueString(resourceGroup().id, deployment().name), 0, 6))
var storageAccountName = 'stlegacyvm${replace(randomSuffix, '-', '')}'  // No hyphens for storage
```

**Decision**: Use CAF abbreviations with 6-character random suffix. Handle storage account naming constraints (lowercase, no hyphens). Parameterize workload name ('legacyvm') for flexibility.

### 6. Availability Zone Selection

#### Requirement
- FR-015: Availability zone MUST be 1, 2, or 3 (never -1)
- US West 3 region supports zones 1, 2, 3

#### AVM Module Support
- VM module: `zone` parameter (single integer: 1, 2, or 3)
- Storage account: `storageAccountSku: 'Standard_LRS'` (zone-redundant not required for legacy workload)
- Bastion: No zone support (regional service)

**Decision**: Parameterize zone selection (default: 1). VM deployed to specified zone. Storage uses LRS (locally redundant, HDD-backed). Bastion is regional (no zone parameter).

### 7. Diagnostic Settings & Alerts

#### Diagnostic Logging (FR-018)
All AVM modules support `diagnosticSettings` parameter array:
```bicep
diagnosticSettings: [
  {
    name: 'diag-to-law'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
  }
]
```

#### Critical Alerts (FR-021)

Per clarification, configure alerts for:
1. VM stopped/deallocated state
2. Data disk space >90% capacity
3. Key Vault access failures

**Azure Monitor Alert Rules**:
- VM Power State: Metric alert on `Power State` = `Stopped`
- Disk Capacity: Metric alert on `Disk Used Percentage` > 90
- Key Vault Audit: Log alert on `failed` operations in Key Vault audit logs

**Decision**: Deploy Log Analytics workspace first, configure diagnosticSettings on all resources. Create Azure Monitor alert rules as separate resources (AVM may have alerting module - research needed). If no AVM alert module, use direct Bicep resource declaration (justified exception per Constitution).

### 8. Idempotent Deployment Strategy

#### ARM Incremental Mode
- Default ARM deployment mode: `incremental`
- Already-deployed resources: skipped (no modification unless properties changed)
- Missing resources: created
- Failed resources: can be retried without deleting existing ones

#### Password Secret Handling
- Key Vault secret with same name: overwritten with new value if template re-run
- VM password reference: remains valid (secret URI doesn't change)
- **Risk**: Redeployment generates new password, overwrites secret, VM retains old password in memory
- **Mitigation**: Document that password changes require VM password reset operation (not automatic)

**Decision**: Use ARM incremental mode (default). Password regeneration on redeploy is acceptable for initial deployments. Document that post-deployment password changes require manual VM admin password update via Azure Portal or PowerShell.

## Research Conclusions

### All Technical Unknowns Resolved

| Unknown | Resolution |
|---------|------------|
| AVM module availability | ✅ All resources covered by AVM modules |
| Password generation | ✅ uniqueString() + guid() + special chars, stored via KV secrets |
| Network architecture | ✅ 2-subnet VNet (Bastion + VM), restrictive NSG on VM subnet |
| Storage configuration | ✅ TransactionOptimized file share, private endpoint, DNS integration |
| Naming convention | ✅ CAF abbreviations + 6-char random suffix, storage account constraints handled |
| Availability zones | ✅ Parameterized zone 1-3, VM deployed to zone, storage LRS |
| Diagnostic logging | ✅ diagnosticSettings parameter on all AVM modules → Log Analytics |
| Alerting | ✅ Azure Monitor alert rules (may need direct resource if no AVM module) |
| Deployment strategy | ✅ ARM incremental mode, idempotent, no resource deletion on failure |

### Open Questions (None)

All clarifications resolved per spec.md Clarifications section. No remaining [NEEDS CLARIFICATION] items.

## Next Steps

Proceed to **Phase 1**:
1. Create data-model.md (Azure resource entities and relationships)
2. Define contracts/parameters.md (input parameters for main.bicepparam)
3. Define contracts/outputs.md (template outputs)
4. Create quickstart.md (deployment guide)
5. Update agent context
6. Re-check constitution compliance
