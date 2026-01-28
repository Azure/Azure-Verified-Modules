# Data Model: Legacy VM Workload Infrastructure

**Date**: 2026-01-27
**Feature**: [spec.md](../spec.md)
**Purpose**: Document network topology, resource relationships, and configuration data model

## Network Topology

### Virtual Network Structure

```
VNet: 10.0.0.0/24 (vnet-legacyvm-{random})
│
├── VM Subnet: 10.0.0.0/27 (snet-vm-legacyvm-{random})
│   ├── NAT Gateway attached
│   ├── NSG attached (nsg-vm-legacyvm-{random})
│   ├── VM Network Interface
│   └── Hosts: Virtual Machine
│
├── Bastion Subnet: 10.0.0.64/26 (AzureBastionSubnet - required name)
│   ├── NSG attached (nsg-bastion-legacyvm-{random})
│   └── Hosts: Azure Bastion
│
└── Private Endpoint Subnet: 10.0.0.128/27 (snet-pe-legacyvm-{random})
    ├── NSG attached (nsg-pe-legacyvm-{random})
    └── Hosts: Storage Account Private Endpoint
```

### Address Space Allocation

| Resource | CIDR | Usable IPs | Purpose |
|----------|------|------------|---------|
| VNet | 10.0.0.0/24 | 256 | Overall network |
| VM Subnet | 10.0.0.0/27 | 32 (27 usable) | Virtual machine network interfaces |
| Bastion Subnet | 10.0.0.64/26 | 64 (59 usable) | Azure Bastion (requires /26 minimum) |
| Private Endpoint Subnet | 10.0.0.128/27 | 32 (27 usable) | Storage account private endpoints |
| Reserved | 10.0.0.160/27 | 32 | Future expansion |
| Reserved | 10.0.0.192/26 | 64 | Future expansion |

## Resource Dependency Graph

```
Resource Group
│
├── Log Analytics Workspace
│   └── (Used by all diagnostic settings)
│
├── Virtual Network
│   ├── Depends on: None
│   └── Used by: Bastion, VM NIC, Private Endpoint
│
├── Network Security Groups (3)
│   ├── nsg-vm-legacyvm-{random}
│   ├── nsg-bastion-legacyvm-{random}
│   └── nsg-pe-legacyvm-{random}
│   ├── Depends on: VNet (for subnet association)
│   └── Diagnostic settings → Log Analytics
│
├── NAT Gateway
│   ├── Public IP (auto-created)
│   ├── Depends on: None
│   ├── Associated with: VM Subnet
│   └── Diagnostic settings → Log Analytics
│
├── Azure Bastion
│   ├── Public IP (auto-created)
│   ├── Depends on: VNet (Bastion subnet)
│   ├── Depends on: NSG (bastion subnet)
│   └── Diagnostic settings → Log Analytics
│
├── Key Vault
│   ├── Depends on: None (deployed early)
│   ├── Secret: VM admin password (generated)
│   ├── RBAC: VM managed identity (Key Vault Secrets User)
│   └── Diagnostic settings → Log Analytics
│
├── Private DNS Zone
│   ├── Name: privatelink.file.core.windows.net
│   ├── VNet Link: Main VNet
│   └── Depends on: VNet
│
├── Storage Account
│   ├── File Share (1024 GiB)
│   ├── Depends on: None
│   ├── Public access: Disabled
│   ├── Diagnostic settings → Log Analytics
│   └── Private Endpoint
│       ├── Depends on: Storage Account, VNet, Private DNS Zone
│       ├── Subnet: Private Endpoint Subnet
│       └── DNS integration: Private DNS Zone
│
└── Virtual Machine
    ├── Depends on: VNet, Key Vault (for password)
    ├── Managed Identity: System-assigned
    ├── OS Disk: Standard HDD
    ├── Data Disk: 500GB Standard HDD
    ├── Network Interface
    │   ├── Depends on: VM Subnet
    │   └── No Public IP
    ├── Password: Retrieved from Key Vault secret
    └── Diagnostic settings → Log Analytics

├── Azure Monitor Alerts (3)
    ├── VM Stopped Alert
    │   └── Depends on: VM
    ├── Disk Space Alert
    │   └── Depends on: VM
    └── Key Vault Access Failures Alert
        └── Depends on: Key Vault
```

## Resource Configuration Model

### Virtual Machine
```yaml
Name Pattern: vm-legacyvm-{random}
Computer Name: vm-{random} (≤15 chars total)
Configuration:
  Size: Standard_D2s_v3
  OS: Windows Server 2016
  OS Disk:
    Type: Standard_LRS (HDD performance tier)
    Size: Default (127 GB or OS default)
  Data Disks:
    - Name: datadisk-01
      Size: 500 GB
      Type: Standard_LRS (HDD performance tier)
      LUN: 0
  Admin:
    Username: vmadmin
    Password: {From Key Vault secret}
  Identity:
    Type: SystemAssigned
  Zone: {Parameter: 1, 2, or 3}
  Network:
    NIC:
      Subnet: VM Subnet
      Public IP: None
      Private IP: Dynamic
  Diagnostics:
    Boot Diagnostics: Enabled (Managed)
    Guest Diagnostics: Windows (via Log Analytics agent)
```

### Key Vault
```yaml
Name Pattern: kv-legacyvm-{random}
Configuration:
  SKU: Standard
  Access Model: RBAC (Azure role-based access control)
  Public Network Access: Enabled (simplified for legacy workload)
  Soft Delete: Enabled (90 days)
  Purge Protection: Disabled (not required for legacy workload)
  Secrets:
    - Name: {Parameter: vmAdminPasswordSecretName}
      Value: {Generated: uniqueString-based password}
      Content Type: text/plain
  RBAC Assignments:
    - Principal: VM Managed Identity
      Role: Key Vault Secrets User
      Scope: Key Vault
  Diagnostics:
    Logs: All categories
    Metrics: All metrics
    Destination: Log Analytics
```

### Storage Account
```yaml
Name Pattern: st{random-no-hyphens} (≤24 chars)
Configuration:
  Kind: StorageV2
  SKU: Standard_LRS (HDD-based)
  Access Tier: Hot
  Public Network Access: Disabled
  Minimum TLS: 1.2
  File Services:
    Shares:
      - Name: fileshare
        Quota: 1024 GiB
        Access Tier: TransactionOptimized
  Private Endpoints:
    - Service: file
      Subnet: Private Endpoint Subnet
      DNS Integration: privatelink.file.core.windows.net
  Diagnostics:
    Logs: All categories (StorageRead, StorageWrite, StorageDelete)
    Metrics: All metrics
    Destination: Log Analytics
```

### Network Security Groups

#### VM Subnet NSG
```yaml
Name: nsg-vm-legacyvm-{random}
Security Rules:
  Inbound:
    - Name: DenyAllInbound
      Priority: 4096
      Direction: Inbound
      Access: Deny
      Protocol: *
      Source: *
      Destination: *
      SourcePort: *
      DestinationPort: *
  Outbound:
    - Name: AllowInternetOutbound
      Priority: 100
      Direction: Outbound
      Access: Allow
      Protocol: *
      Source: *
      Destination: Internet
      SourcePort: *
      DestinationPort: *
    - Name: AllowVnetOutbound
      Priority: 200
      Direction: Outbound
      Access: Allow
      Protocol: *
      Source: *
      Destination: VirtualNetwork
      SourcePort: *
      DestinationPort: *
    - Name: DenyAllOutbound
      Priority: 4096
      Direction: Outbound
      Access: Deny
      Protocol: *
      Source: *
      Destination: *
      SourcePort: *
      DestinationPort: *
```

#### Bastion Subnet NSG
```yaml
Name: nsg-bastion-legacyvm-{random}
Security Rules:
  # Standard Azure Bastion required rules
  Inbound:
    - Name: AllowHttpsInbound
      Priority: 100
      Direction: Inbound
      Access: Allow
      Protocol: Tcp
      Source: Internet
      Destination: *
      SourcePort: *
      DestinationPort: 443
    - Name: AllowGatewayManagerInbound
      Priority: 110
      Direction: Inbound
      Access: Allow
      Protocol: Tcp
      Source: GatewayManager
      Destination: *
      SourcePort: *
      DestinationPort: 443
    - Name: AllowAzureLoadBalancerInbound
      Priority: 120
      Direction: Inbound
      Access: Allow
      Protocol: Tcp
      Source: AzureLoadBalancer
      Destination: *
      SourcePort: *
      DestinationPort: 443
    - Name: AllowBastionHostCommunication
      Priority: 130
      Direction: Inbound
      Access: Allow
      Protocol: *
      Source: VirtualNetwork
      Destination: VirtualNetwork
      SourcePort: *
      DestinationPort: 8080,5701
  Outbound:
    - Name: AllowSshRdpOutbound
      Priority: 100
      Direction: Outbound
      Access: Allow
      Protocol: *
      Source: *
      Destination: VirtualNetwork
      SourcePort: *
      DestinationPort: 22,3389
    - Name: AllowAzureCloudOutbound
      Priority: 110
      Direction: Outbound
      Access: Allow
      Protocol: Tcp
      Source: *
      Destination: AzureCloud
      SourcePort: *
      DestinationPort: 443
    - Name: AllowBastionCommunication
      Priority: 120
      Direction: Outbound
      Access: Allow
      Protocol: *
      Source: VirtualNetwork
      Destination: VirtualNetwork
      SourcePort: *
      DestinationPort: 8080,5701
    - Name: AllowGetSessionInformation
      Priority: 130
      Direction: Outbound
      Access: Allow
      Protocol: *
      Source: *
      Destination: Internet
      SourcePort: *
      DestinationPort: 80
```

#### Private Endpoint Subnet NSG
```yaml
Name: nsg-pe-legacyvm-{random}
Security Rules:
  Inbound:
    - Name: AllowVMSubnetInbound
      Priority: 100
      Direction: Inbound
      Access: Allow
      Protocol: Tcp
      Source: 10.0.0.0/27
      Destination: *
      SourcePort: *
      DestinationPort: 445
    - Name: DenyAllInbound
      Priority: 4096
      Direction: Inbound
      Access: Deny
      Protocol: *
      Source: *
      Destination: *
      SourcePort: *
      DestinationPort: *
  Outbound:
    - Name: AllowAllOutbound
      Priority: 100
      Direction: Outbound
      Access: Allow
      Protocol: *
      Source: *
      Destination: *
      SourcePort: *
      DestinationPort: *
```

### Azure Monitor Alerts

#### Alert 1: VM Stopped/Deallocated
```yaml
Name: alert-vm-stopped-legacyvm-{random}
Configuration:
  Type: Metric
  Target: Virtual Machine
  Metric:
    Namespace: Microsoft.Compute/virtualMachines
    Name: Percentage CPU
  Condition:
    Operator: LessThan
    Threshold: 1
    Aggregation: Average
    Window: 15 minutes
  Severity: Critical (Sev 0)
  Auto-Mitigate: false
  Description: "Critical: VM appears to be stopped or deallocated"
```

#### Alert 2: Disk Space Exceeded
```yaml
Name: alert-disk-space-legacyvm-{random}
Configuration:
  Type: Metric
  Target: Virtual Machine
  Metric:
    Namespace: Microsoft.Compute/virtualMachines
    Name: OS Disk Used Percentage
  Condition:
    Operator: GreaterThan
    Threshold: 85
    Aggregation: Average
    Window: 5 minutes
  Severity: Critical (Sev 0)
  Auto-Mitigate: false
  Description: "Critical: Disk space exceeded 85% threshold"
```

#### Alert 3: Key Vault Access Failures
```yaml
Name: alert-kv-access-fail-legacyvm-{random}
Configuration:
  Type: Metric
  Target: Key Vault
  Metric:
    Namespace: Microsoft.KeyVault/vaults
    Name: ServiceApiHit
  Filter:
    Dimension: ActivityName
    Values: SecretGet
    Result: Failed
  Condition:
    Operator: GreaterThan
    Threshold: 0
    Aggregation: Count
    Window: 5 minutes
  Severity: Critical (Sev 0)
  Auto-Mitigate: false
  Description: "Critical: Key Vault secret access failures detected"
```

## Deployment Sequence

Based on ARM dependency analysis, resources will deploy in this approximate order:

1. **Phase 1: Foundation** (Parallel)
   - Log Analytics Workspace
   - Virtual Network (with subnets)
   - Network Security Groups

2. **Phase 2: Network & Security** (Depends on Phase 1)
   - NAT Gateway (associates with VM subnet)
   - Azure Bastion (requires subnet and NSG)
   - Private DNS Zone (requires VNet)
   - Key Vault (generates and stores password)

3. **Phase 3: Storage** (Depends on Phase 2)
   - Storage Account (with file share)
   - Private Endpoint (requires storage account, VNet, DNS zone)

4. **Phase 4: Compute** (Depends on Phases 1-3)
   - Virtual Machine (requires VNet, Key Vault secret, zone assignment)

5. **Phase 5: Monitoring** (Depends on Phase 4)
   - Azure Monitor Alerts (require VM and Key Vault to be deployed)

## Parameter Data Model

```yaml
# Required Parameters
parameters:
  resourceGroupName: string
    description: Name of the resource group for deployment
    example: rg-legacyvm-prod

  location: string
    description: Azure region for deployment
    default: westus3
    validation: Must be valid Azure region

  vmSize: string
    description: Virtual machine size
    default: Standard_D2s_v3
    validation: Must support Windows Server 2016

  vmAdminUsername: string
    description: VM administrator username
    default: vmadmin
    minLength: 1
    maxLength: 20

  vmAdminPasswordSecretName: string
    description: Name of Key Vault secret for VM admin password
    default: vm-admin-password
    minLength: 1
    maxLength: 127

  availabilityZone: int
    description: Availability zone for zone-capable resources
    allowed: [1, 2, 3]
    default: 1

  fileShareQuotaGiB: int
    description: File share quota in GiB
    default: 1024
    minValue: 100
    maxValue: 102400

  logAnalyticsRetentionDays: int
    description: Log Analytics data retention in days
    default: 30
    minValue: 30
    maxValue: 730

# Generated Values (not parameters)
variables:
  randomSuffix: uniqueString(resourceGroup().id)
  vmPassword: P@ssw0rd!{uniqueString(resourceGroup().id, deployment().name)}

  # Resource Names
  vnetName: vnet-legacyvm-{randomSuffix}
  vmName: vm-legacyvm-{randomSuffix}
  storageAccountName: st{replace(randomSuffix, '-', '')}
  keyVaultName: kv-legacyvm-{randomSuffix}
  logAnalyticsName: law-legacyvm-{randomSuffix}
```

## Tags Model

All resources will be tagged with:

```yaml
tags:
  workload: legacy-vm
  environment: production
  compliance: legacy-retention
  managedBy: bicep-avm
  deploymentDate: {deployment().timestamp}
```

## Security Model

### RBAC Assignments

| Principal | Role | Scope | Purpose |
|-----------|------|-------|---------|
| VM Managed Identity | Key Vault Secrets User | Key Vault | Read VM admin password |
| VM Managed Identity | Storage Blob Data Contributor | Storage Account | Access file share (future) |

### Network Security

| Source | Destination | Protocol/Port | Action | Purpose |
|--------|-------------|---------------|--------|---------|
| Internet | Bastion (443) | TCP/443 | Allow | Admin RDP access |
| Bastion | VM (3389) | TCP/3389 | Allow | RDP to VM |
| VM | Internet | Any | Allow | Outbound via NAT Gateway |
| VM | Storage PE (445) | TCP/445 | Allow | File share access |
| Any | VM | Any | Deny | No direct access to VM |

## Monitoring Data Model

### Diagnostic Settings Targets

All resources with diagnostic settings send to:
- **Primary**: Log Analytics Workspace
- **Categories**: All available log categories
- **Metrics**: All available metrics

### Alert Notification Model

- **Channel**: Azure Portal only
- **No Action Groups**: Alerts visible in portal alerts blade
- **Severity**: All set to Critical (Sev 0)
- **Auto-Mitigation**: Disabled (require manual acknowledgment)
