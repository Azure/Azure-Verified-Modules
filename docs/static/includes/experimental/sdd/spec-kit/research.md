<!-- markdownlint-disable -->
# Research: Legacy VM Workload AVM Modules

**Date**: 2026-01-27
**Feature**: [spec.md](../spec.md)
**Purpose**: Research and document AVM module selections, versions, and configuration approaches

## AVM Module Inventory

### Primary Infrastructure Modules

#### 1. Virtual Network
- **Module**: `avm/res/network/virtual-network`
- **Latest Version**: 0.7.2
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/network/virtual-network/0.7.2/avm/res/network/virtual-network/README.md
- **Decision**: Use this module for VNet and subnet deployment
- **Rationale**: Official AVM module with built-in support for subnets, NSG assignments, NAT gateway association, and diagnostic settings
- **Key Parameters Needed**:
  - Address space: 10.0.0.0/24
  - Subnets: VM (10.0.0.0/27), Bastion (10.0.0.64/26), Private endpoint (10.0.0.128/27)
  - NSG associations per subnet
  - NAT gateway assignment to VM subnet

#### 2. Virtual Machine
- **Module**: `avm/res/compute/virtual-machine`
- **Latest Version**: 0.21.0
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/compute/virtual-machine/0.21.0/avm/res/compute/virtual-machine/README.md
- **Decision**: Use this module for VM deployment
- **Rationale**: Comprehensive AVM module with built-in support for managed disks, managed identity, diagnostic settings, and guest configuration
- **Key Parameters Needed**:
  - VM size: Standard_D2s_v3
  - OS: Windows Server 2016
  - Computer name: ≤15 characters
  - Admin username: vmadmin
  - Admin password: Reference to Key Vault secret
  - Managed identity: System-assigned
  - Data disks: 500GB HDD
  - Availability zone: 1-3 (parameter-driven)
  - No public IP

#### 3. Azure Bastion
- **Module**: `avm/res/network/bastion-host`
- **Latest Version**: 0.8.2
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/network/bastion-host/0.8.2/avm/res/network/bastion-host/README.md
- **Decision**: Use this module for bastion deployment
- **Rationale**: AVM module with built-in diagnostic settings and public IP creation
- **Key Parameters Needed**:
  - Subnet: Bastion subnet (10.0.0.64/26)
  - SKU: Basic (cost-effective for legacy workload)
  - Diagnostic settings to Log Analytics

#### 4. Storage Account
- **Module**: `avm/res/storage/storage-account`
- **Latest Version**: 0.31.0
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/storage/storage-account/0.31.0/avm/res/storage/storage-account/README.md
- **Decision**: Use this module for storage account and file share
- **Rationale**: Comprehensive AVM module with built-in file share, private endpoint, diagnostic settings, and network rules support
- **Key Parameters Needed**:
  - SKU: Standard_LRS (HDD-based)
  - File share quota: 1024 GiB
  - Private endpoint enabled
  - Public network access disabled
  - Diagnostic settings to Log Analytics

#### 5. NAT Gateway
- **Module**: `avm/res/network/nat-gateway`
- **Latest Version**: 2.0.1
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/network/nat-gateway/2.0.1/avm/res/network/nat-gateway/README.md
- **Decision**: Use this module for NAT gateway
- **Rationale**: AVM module with public IP creation and zone support
- **Key Parameters Needed**:
  - Zone: parameter-driven (1-3)
  - Public IP: Auto-created by module

#### 6. Network Security Group
- **Module**: `avm/res/network/network-security-group`
- **Latest Version**: 0.5.2
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/network/network-security-group/0.5.2/avm/res/network/network-security-group/README.md
- **Decision**: Use this module for all three NSGs (VM subnet, bastion subnet, private endpoint subnet)
- **Rationale**: AVM module with built-in diagnostic settings and security rule definitions
- **Key Parameters Needed**:
  - VM subnet NSG: Allow outbound to internet via NAT gateway, deny other traffic
  - Bastion subnet NSG: Standard bastion rules (inbound 443, outbound to VM subnet)
  - Private endpoint subnet NSG: Allow traffic from VM subnet only

#### 7. Key Vault
- **Module**: `avm/res/key-vault/vault`
- **Latest Version**: 0.13.3
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/key-vault/vault/0.13.3/avm/res/key-vault/vault/README.md
- **Decision**: Use this module for Key Vault and secret storage
- **Rationale**: AVM module with built-in secret creation using `secrets` parameter array, RBAC support, diagnostic settings, and network rules
- **Key Features**:
  - Supports `secrets` parameter for creating secrets at deployment time
  - Can generate password using `uniqueString()` and store in secret
  - Built-in RBAC assignments
  - Private endpoint support (optional for this scenario)
  - Diagnostic settings interface
- **Password Generation Approach**:
  - Use Bicep `uniqueString()` function to generate complex password
  - Combine multiple seed values for randomness
  - Store in Key Vault secret via module's `secrets` parameter
  - Reference secret in VM module

#### 8. Log Analytics Workspace
- **Module**: `avm/res/operational-insights/workspace`
- **Latest Version**: 0.15.0
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/operational-insights/workspace/0.15.0/avm/res/operational-insights/workspace/README.md
- **Decision**: Use this module for Log Analytics
- **Rationale**: AVM module with retention configuration and solution deployment support
- **Key Parameters Needed**:
  - Retention days: 30 (default assumption)
  - SKU: PerGB2018

#### 9. Private Endpoint
- **Module**: `avm/res/network/private-endpoint`
- **Latest Version**: 0.11.1
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/network/private-endpoint/0.11.1/avm/res/network/private-endpoint/README.md
- **Decision**: Use this module for storage account file share private endpoint
- **Rationale**: AVM module with built-in private DNS zone group configuration
- **Key Parameters Needed**:
  - Service connection: Storage account file service
  - Subnet: Private endpoint subnet
  - Private DNS zone: privatelink.file.core.windows.net (manual creation)

#### 10. Azure Monitor Alerts
- **Module**: `avm/res/insights/metric-alert`
- **Latest Version**: 0.4.1
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/insights/metric-alert/0.4.1/avm/res/insights/metric-alert/README.md
- **Decision**: Use this module for all three critical alerts
- **Rationale**: AVM module supporting metric-based alerts for VM and Key Vault
- **Alerts to Create**:
  1. VM stopped/deallocated
  2. Disk space > 85%
  3. Key Vault access failures
- **Note**: Portal-only notifications (no action groups needed for this scenario)

### Supporting Modules

#### 11. Managed Disk
- **Included in VM Module**: The Virtual Machine module handles data disk creation inline
- **No separate module needed**: Data disks are specified as parameters to the VM module

#### 12. Private DNS Zone
- **Module**: `avm/res/network/private-dns-zone`
- **Latest Version**: 0.8.0
- **Documentation**: https://github.com/Azure/bicep-registry-modules/tree/avm/res/network/private-dns-zone/0.8.0/avm/res/network/private-dns-zone/README.md
- **Decision**: Use this module for private DNS zone for file share private endpoint
- **Rationale**: Required for DNS resolution of storage account file share through private endpoint
- **Key Parameters Needed**:
  - Zone name: privatelink.file.core.windows.net
  - VNet link to main VNet

## Alternative Approaches Considered

### Alternative 1: Direct Resource Declarations
- **Approach**: Use direct Bicep resource declarations instead of AVM modules
- **Rejected**: Violates constitution principle II (AVM-Only Modules)
- **Trade-offs**: Would provide more control but lose benefits of tested, maintained, secure-by-default configurations

### Alternative 2: Pattern Module for VM Workloads
- **Approach**: Search for existing AVM pattern module combining VM, networking, and storage
- **Evaluated**: No suitable pattern module exists for this specific legacy VM scenario
- **Decision**: Compose solution from resource modules per constitution

### Alternative 3: Deployment Scripts for Password Generation
- **Approach**: Use Azure Deployment Scripts to generate and store VM password
- **Rejected**: User requirement specifies using uniqueString() and avoiding external helper scripts
- **Decision**: Generate password inline using Bicep uniqueString() function and store via Key Vault module's secrets parameter

### Alternative 4: Azure Backup Integration
- **Approach**: Include Azure Backup configuration for VM
- **Rejected**: Explicitly out of scope per specification
- **Note**: Can be added later if requirements change

## Bicep Language Features Required

### Password Generation Pattern
```bicep
// Generate complex password using uniqueString with multiple seeds
var generatedPassword = 'P@ssw0rd!${uniqueString(resourceGroup().id, deployment().name, utcNow('u'))}'
```

### Resource Dependency Management
- Let ARM manage dependencies automatically
- Explicit `dependsOn` only when implicit dependency isn't detected
- Use resource symbolic names for references

### Parameter Validation
- Use decorators: `@minLength()`, `@maxLength()`, `@allowed()`
- Validate VM computer name length (≤15 chars)
- Validate storage account name (≤24 chars, lowercase, alphanumeric)

## Key Configuration Decisions

### Resource Naming
- **Pattern**: {resourceType}-{purpose}-{randomSuffix}
- **Random Suffix**: Use uniqueString() with 6 characters
- **Examples**:
  - VNet: `vnet-legacyvm-${uniqueString(resourceGroup().id)}`
  - VM: `vm-legacyvm-${uniqueString(resourceGroup().id)}`
  - Storage: `st${replace(uniqueString(resourceGroup().id), '-', '')}` (no hyphens, ≤24 chars)
  - Key Vault: `kv-legacyvm-${uniqueString(resourceGroup().id)}`

### Network Security
- **VM Subnet NSG**: Allow outbound internet (via NAT), deny all inbound except from bastion
- **Bastion Subnet NSG**: Follow Azure Bastion NSG requirements
- **Private Endpoint Subnet NSG**: Allow inbound from VM subnet on port 445 (SMB)

### Diagnostic Settings
- **Target**: Log Analytics Workspace (centralized)
- **Resources to Monitor**: VM, Key Vault, Storage Account, NSGs, Bastion
- **Log Categories**: All available categories
- **Metrics**: All available metrics

### Availability Zones
- **VM**: Deploy to zone specified by parameter (1, 2, or 3)
- **NAT Gateway**: Deploy to same zone as VM
- **Managed Disks**: Automatically zone-aligned with VM

## Implementation Notes

### Single Template Approach
- All resources in main.bicep
- No nested modules or separate Bicep files
- ARM dependency management handles deployment order

### Parameter Management
- All configurable values in main.bicepparam
- Rich comments explaining each parameter
- Default values where appropriate
- No hardcoded values in template

### Bicep CLI Version
- **Minimum**: Latest stable version (0.33.0 or higher at time of writing)
- **Recommendation**: Always use latest for newest AVM module support
- **Verification**: Run `bicep --version` before deployment

### Module Version Pinning
- **Required**: Always pin to specific versions (never 'latest' tag)
- **Format**: `br/public:avm/res/network/virtual-network:0.7.2`
- **Maintenance**: Update versions explicitly when needed

## Open Questions Resolved

1. **How to generate VM password without external scripts?**
   - **Resolution**: Use Bicep `uniqueString()` function with multiple seeds
   - **Implementation**: Store generated password in Key Vault using module's `secrets` parameter

2. **How to connect file share to VM?**
   - **Resolution**: Out of scope for initial deployment per user guidance
   - **Future**: Will require VM extension or post-deployment script

3. **Should we use private endpoint for Key Vault?**
   - **Resolution**: No, not required for this legacy workload
   - **Justification**: Adds complexity without clear benefit for single VM scenario

4. **What alert notification channels?**
   - **Resolution**: Portal notifications only (clarified during specification)
   - **Implementation**: Create metric alerts without action groups

5. **Module version for optimal features?**
   - **Resolution**: Always use latest stable version listed in AVM metadata
   - **Verification**: Confirmed all required features available in latest versions

## Next Steps

1. Create data-model.md with network topology and resource relationships
2. Write deployment quickstart guide
3. Fill implementation plan template
4. Create bicepconfig.json with module version analyzer
