# Data Model: Legacy Windows Server VM Workload

**Date**: 2026-01-22
**Purpose**: Define Azure resource entities, attributes, and relationships

## Overview

This workload consists of 10 primary Azure resource entities deployed via AVM modules. All resources exist within a single resource group and are deployed to the US West 3 region. The model follows a hub-and-spoke pattern where the VNet serves as the central network hub, with VM, Bastion, Storage, and Key Vault as dependent resources.

## Entity Definitions

### 1. Resource Group

**Purpose**: Logical container for all workload resources

**Attributes**:
- Name: `rg-legacyvm-{randomSuffix}`
- Location: `westus3`
- Lock: CanNotDelete
- Tags: Environment=Production, Workload=LegacyVM

**Relationships**:
- Contains: All other resources in this workload
- Parent: Azure Subscription

**AVM Module**: `avm/res/resources/resource-group:0.4.0`

---

### 2. Virtual Network

**Purpose**: Network infrastructure providing isolation and connectivity

**Attributes**:
- Name: `vnet-legacyvm-{randomSuffix}`
- Location: `westus3`
- Address Space: `10.0.0.0/16`
- Subnets:
  - `AzureBastionSubnet`: `10.0.0.0/26` (required name, no NSG)
  - `snet-vm-legacyvm-{randomSuffix}`: `10.0.1.0/24` (with NSG)
- DNS Servers: Default (Azure-provided)
- Lock: CanNotDelete
- Diagnostic Settings: → Log Analytics Workspace

**Relationships**:
- Contains: 2 subnets (Bastion subnet, VM subnet)
- Hosts: Virtual Machine (via VM subnet)
- Hosts: Bastion Host (via Bastion subnet)
- Hosts: Private Endpoint (via VM subnet)
- Associated With: Network Security Group (on VM subnet)

**AVM Module**: `avm/res/network/virtual-network:0.5.2`

---

### 3. Network Security Group (VM Subnet)

**Purpose**: Traffic filtering for VM subnet

**Attributes**:
- Name: `nsg-vm-legacyvm-{randomSuffix}`
- Location: `westus3`
- Security Rules:
  - **Inbound**:
    - Priority 100: Allow RDP (3389) from AzureBastionSubnet
    - Priority 4096: Deny all other inbound
  - **Outbound**:
    - Priority 100: Allow HTTPS (443) to Storage service tag
    - Priority 4096: Deny internet outbound
- Lock: CanNotDelete
- Diagnostic Settings: → Log Analytics Workspace

**Relationships**:
- Associated With: VM Subnet (in Virtual Network)
- Protects: Virtual Machine

**AVM Module**: Integrated into `avm/res/network/virtual-network` (subnet NSG association)

---

### 4. Azure Bastion

**Purpose**: Secure RDP access to VM without public IP exposure

**Attributes**:
- Name: `bas-legacyvm-{randomSuffix}`
- Location: `westus3`
- SKU: Basic
- Public IP: Auto-created by Bastion module
- Subnet: `AzureBastionSubnet` (10.0.0.0/26)
- Lock: CanNotDelete
- Diagnostic Settings: → Log Analytics Workspace

**Relationships**:
- Deployed In: AzureBastionSubnet (in Virtual Network)
- Provides Access To: Virtual Machine

**AVM Module**: `avm/res/network/bastion-host:0.4.0`

---

### 5. Virtual Machine

**Purpose**: Windows Server 2016 compute instance hosting legacy application

**Attributes**:
- Name: `vm-legacyvm` (15 char limit, no random suffix due to Windows constraint)
- Location: `westus3`
- Availability Zone: Parameterized (1, 2, or 3)
- Size: `Standard_D2s_v3` (2 vCPU, 8GB RAM)
- OS: Windows Server 2016 Datacenter
- OS Disk:
  - Name: `disk-vm-os-legacyvm-{randomSuffix}`
  - Size: 127GB (default OS disk size)
  - SKU: `Standard_LRS` (Standard HDD)
  - Caching: ReadWrite
- Data Disks:
  - Name: `disk-vm-data-legacyvm-{randomSuffix}`
  - Size: 500GB
  - SKU: `Standard_LRS` (Standard HDD)
  - Caching: None
  - LUN: 0
- Admin Username: `vmadmin` (parameterized)
- Admin Password: Retrieved from Key Vault secret
- Managed Identity: System-assigned (for future RBAC scenarios)
- Boot Diagnostics: Enabled (managed storage account)
- Network Interface:
  - Private IP: Dynamic allocation
  - Subnet: VM subnet
  - No public IP
- Lock: CanNotDelete
- Diagnostic Settings: → Log Analytics Workspace

**Relationships**:
- Deployed In: VM Subnet (in Virtual Network)
- Protected By: Network Security Group
- Accessed Via: Azure Bastion
- Credentials Stored In: Key Vault (admin password secret)
- Mounts: Azure Files Share (manual post-deployment)
- Monitored By: Log Analytics Workspace

**AVM Module**: `avm/res/compute/virtual-machine:0.8.0`

---

### 6. Storage Account

**Purpose**: Hosts Azure Files share for centralized file storage

**Attributes**:
- Name: `stlegacyvm{randomSuffixNoHyphens}` (3-24 lowercase alphanumeric, globally unique)
- Location: `westus3`
- SKU: `Standard_LRS` (Standard HDD, locally redundant)
- Kind: `StorageV2`
- Public Network Access: `Disabled`
- HTTPS Only: `true`
- Minimum TLS Version: `TLS1_2`
- File Services:
  - Share Name: `fs-legacyvm`
  - Quota: 100GB
  - Access Tier: `TransactionOptimized` (HDD-backed)
- Private Endpoint:
  - Name: `pe-st-legacyvm-{randomSuffix}`
  - Subnet: VM subnet
  - Sub-resource: `file`
  - Private DNS Zone Integration: Enabled
- Lock: CanNotDelete
- Diagnostic Settings: → Log Analytics Workspace

**Relationships**:
- Contains: Azure Files Share
- Exposed Via: Private Endpoint (in VM subnet)
- Accessed By: Virtual Machine (manual mount)
- DNS Resolved By: Private DNS Zone

**AVM Module**: `avm/res/storage/storage-account:0.14.3` (includes private endpoint creation)

---

### 7. Azure Files Share

**Purpose**: Centralized file storage accessible via SMB protocol

**Attributes**:
- Name: `fs-legacyvm`
- Quota: 100GB
- Access Tier: `TransactionOptimized` (Standard HDD)
- Protocol: SMB 3.0
- Mount Path (on VM): `\\{private-endpoint-ip}\fs-legacyvm`

**Relationships**:
- Hosted In: Storage Account
- Mounted On: Virtual Machine (manual post-deployment)

**AVM Module**: Integrated into `avm/res/storage/storage-account` (file services parameter)

---

### 8. Private Endpoint

**Purpose**: Private network connectivity to storage account

**Attributes**:
- Name: `pe-st-legacyvm-{randomSuffix}`
- Location: `westus3`
- Subnet: VM subnet
- Target Sub-resource: `file` (Azure Files)
- Private IP: Dynamic allocation from VM subnet range
- Private DNS Zone: `privatelink.file.core.windows.net` (auto-created)
- DNS Integration: Enabled

**Relationships**:
- Deployed In: VM Subnet (in Virtual Network)
- Targets: Storage Account (file sub-resource)
- DNS Resolved By: Private DNS Zone
- Enables Access From: Virtual Machine

**AVM Module**: Integrated into `avm/res/storage/storage-account` (privateEndpoints parameter)

---

### 9. Key Vault

**Purpose**: Secure storage for VM administrator password

**Attributes**:
- Name: `kv-legacyvm-{randomSuffix}` (3-24 chars, globally unique)
- Location: `westus3`
- SKU: `Standard`
- Soft Delete: Enabled (90 days)
- Purge Protection: Enabled
- Public Network Access: `Enabled` (for deployment-time secret creation; can be restricted post-deployment)
- RBAC Authorization: Enabled
- Secrets:
  - Name: Parameterized (e.g., `vm-admin-password`)
  - Value: Generated via `uniqueString() + guid() + special chars`
  - Content Type: `text/plain`
- Lock: CanNotDelete
- Diagnostic Settings: → Log Analytics Workspace

**Relationships**:
- Stores: VM Administrator Password (secret)
- Referenced By: Virtual Machine (admin password parameter)
- Accessed By: Deployment identity (for secret creation)
- Monitored By: Log Analytics Workspace (audit logs)

**AVM Module**: `avm/res/key-vault/vault:0.10.2` (with secrets parameter array)

---

### 10. Log Analytics Workspace

**Purpose**: Centralized diagnostic logging and monitoring

**Attributes**:
- Name: `log-legacyvm-{randomSuffix}`
- Location: `westus3`
- SKU: `PerGB2018`
- Retention: 30 days (default)
- Lock: CanNotDelete

**Relationships**:
- Receives Logs From: All resources (via diagnostic settings)
- Supports: Azure Monitor Alert Rules

**AVM Module**: `avm/res/operational-insights/workspace:0.9.1`

---

### 11. Management Locks

**Purpose**: Prevent accidental deletion of production resources

**Attributes**:
- Lock Level: `CanNotDelete`
- Applied To: All resources in resource group
- Notes: "Legacy compliance workload - deletion requires approval"

**Relationships**:
- Protects: All resources in workload

**AVM Module**: Integrated into each AVM module (`lock` parameter)

---

### 12. Azure Monitor Alert Rules

**Purpose**: Critical-only alerting for operational issues

**Entities**:
1. **VM Power State Alert**
   - Name: `alert-vm-stopped-legacyvm-{randomSuffix}`
   - Type: Metric Alert
   - Target: Virtual Machine
   - Metric: `Power State`
   - Condition: Equals `Stopped` or `Deallocated`
   - Severity: 2 (Warning)
   - Action Group: Email to operations team

2. **Disk Capacity Alert**
   - Name: `alert-disk-capacity-legacyvm-{randomSuffix}`
   - Type: Metric Alert
   - Target: Data Disk
   - Metric: `Disk Used Percentage`
   - Condition: Greater than 90%
   - Severity: 2 (Warning)
   - Action Group: Email to operations team

3. **Key Vault Access Failure Alert**
   - Name: `alert-kv-access-legacyvm-{randomSuffix}`
   - Type: Log Alert
   - Target: Key Vault
   - Query: `AzureDiagnostics | where ResourceType == 'VAULTS' and ResultType == 'failed'`
   - Condition: Count > 5 in 5 minutes
   - Severity: 1 (Error)
   - Action Group: Email to security team

**Relationships**:
- Monitors: Virtual Machine, Data Disk, Key Vault
- Sends Alerts To: Action Groups (email recipients)

**AVM Module**: **Research Needed** - Check if `avm/res/insights/metric-alert` or `avm/res/insights/scheduled-query-rule` exist. If not, use direct Bicep resource (justified exception).

---

## Entity Relationship Diagram

```text
┌─────────────────────────────────────────────────────────────────────┐
│                        Resource Group (rg-*)                         │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                    Virtual Network (vnet-*)                     │ │
│  │  ┌──────────────────────┐  ┌──────────────────────────────────┐│ │
│  │  │ AzureBastionSubnet   │  │   VM Subnet (snet-vm-*)          ││ │
│  │  │  (10.0.0.0/26)       │  │   (10.0.1.0/24)                  ││ │
│  │  │  ┌─────────────────┐ │  │  ┌─────────────────────────────┐ ││ │
│  │  │  │ Bastion (bas-*) │ │  │  │ NSG (nsg-vm-*)              │ ││ │
│  │  │  └─────────────────┘ │  │  └─────────────────────────────┘ ││ │
│  │  │                      │  │  ┌─────────────────────────────┐ ││ │
│  │  │                      │  │  │ VM (vm-legacyvm)            │ ││ │
│  │  │                      │  │  │  - OS Disk (disk-vm-os-*)   │ ││ │
│  │  │                      │  │  │  - Data Disk (disk-vm-data-*)││││
│  │  │                      │  │  └────┬────────────────────────┘ ││ │
│  │  │                      │  │       │ Retrieves password       ││ │
│  │  │                      │  │       │ from KV                  ││ │
│  │  │                      │  │  ┌────▼───────────────────────┐ ││ │
│  │  │                      │  │  │ Private Endpoint (pe-st-*) │ ││ │
│  │  │                      │  │  └────┬───────────────────────┘ ││ │
│  │  └──────────────────────┘  └───────┼─────────────────────────┘│ │
│  └─────────────────────────────────────┼──────────────────────────┘ │
│                                         │ Connects to file share     │
│  ┌──────────────────────────────────────▼──────────────────────────┐ │
│  │  Storage Account (stlegacyvm*)                                   │ │
│  │   └── File Share (fs-legacyvm)                                   │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │  Key Vault (kv-legacyvm-*)                                        │ │
│  │   └── Secret: VM Admin Password (generated via uniqueString)     │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │  Log Analytics Workspace (log-legacyvm-*)                         │ │
│  │   ← Receives diagnostic logs from all resources                   │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │  Azure Monitor Alerts                                             │ │
│  │   - VM Power State Alert                                          │ │
│  │   - Disk Capacity Alert (>90%)                                    │ │
│  │   - Key Vault Access Failure Alert                                │ │
│  └───────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

## Deployment Dependencies

Resources must be deployed in the following order (enforced by Bicep `dependsOn` or implicit dependencies):

1. **Log Analytics Workspace** (no dependencies)
2. **Virtual Network** with subnets (no dependencies)
3. **Key Vault** with generated password secret (depends on: none)
4. **Virtual Machine** (depends on: VNet, Key Vault secret)
5. **Bastion Host** (depends on: VNet with AzureBastionSubnet)
6. **Storage Account** with private endpoint (depends on: VNet)
7. **Azure Monitor Alerts** (depends on: VM, Key Vault, Log Analytics)
8. **Management Locks** (applied during resource creation via AVM module parameters)

ARM will automatically resolve dependencies based on resource ID references in Bicep template.

## Data Flow

### Deployment-Time
1. Bicep template generates admin password using `uniqueString() + guid() + special chars`
2. Password stored in Key Vault as secret (via AVM Key Vault module secrets parameter)
3. VM module retrieves password from Key Vault secret URI during VM provisioning
4. VM created with admin password from Key Vault

### Runtime
1. Administrator connects to VM via Azure Bastion (RDP over HTTPS)
2. NSG allows RDP traffic from Bastion subnet to VM subnet
3. VM accesses file share via private endpoint (no public internet exposure)
4. Private DNS zone resolves storage account FQDN to private IP
5. All resource operations logged to Log Analytics Workspace
6. Critical events trigger Azure Monitor alerts to action groups

### Manual Post-Deployment (File Share Mounting)
1. Administrator retrieves storage account key from Azure Portal
2. Administrator logs into VM via Bastion
3. Administrator runs PowerShell command to mount file share:
   ```powershell
   net use Z: \\stlegacyvmxxxxxx.file.core.windows.net\fs-legacyvm /persistent:yes
   ```
4. File share accessible at Z: drive on VM

## Validation Criteria

Each entity must satisfy:
- ✅ Deployed via AVM module (no custom Bicep resources except alerts if no AVM module exists)
- ✅ Name follows CAF abbreviation + workload + random suffix pattern
- ✅ Located in `westus3` region
- ✅ CanNotDelete lock applied (where supported)
- ✅ Diagnostic settings configured → Log Analytics Workspace
- ✅ RBAC least-privilege (system-assigned managed identities where applicable)
- ✅ Encryption at rest enabled (Azure-managed keys)
- ✅ No public IP exposure except Bastion (VM has private IP only)
