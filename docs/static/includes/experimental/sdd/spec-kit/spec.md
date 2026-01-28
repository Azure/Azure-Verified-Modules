<!-- markdownlint-disable -->
# Feature Specification: Legacy VM Workload Infrastructure

**Feature Branch**: `001-legacy-vm-workload`
**Created**: 2026-01-27
**Status**: Draft
**Input**: User description: "legacy business application, running as a single virtual machine connected to a virtual network with Windows Server 2016, 2 CPU cores, 8 GB RAM, standard HDD, 500 GB data disk, bastion access, file share via private endpoint, NAT gateway internet access, NSGs, Key Vault for VM password, Log Analytics with diagnostic logging and critical alerts"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.

  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - Core VM Infrastructure Deployment (Priority: P1)

Deploy the fundamental infrastructure including virtual network, VM with required specifications, and basic connectivity. This establishes the baseline workload environment.

**Why this priority**: Without the VM and network infrastructure, no other components can function. This is the foundation for the entire workload.

**Independent Test**: Can be fully tested by deploying the infrastructure and verifying VM is created with correct specifications (Windows Server 2016, 2 cores, 8GB RAM, standard HDD) and can communicate within the VNet.

**Acceptance Scenarios**:

1. **Given** no existing infrastructure, **When** deployment is executed, **Then** VM is created with Windows Server 2016, 2 CPU cores, 8GB RAM
2. **Given** deployment is complete, **When** checking VM configuration, **Then** VM has standard HDD OS disk and is placed in correct VNet
3. **Given** VM is deployed, **When** checking computer name, **Then** NetBIOS name is 15 characters or fewer

---

### User Story 2 - Secure Storage and Data Disk (Priority: P2)

Provision the 500GB data disk for the VM and configure the storage account with file share accessible via private endpoint. This provides the data storage layer for the application.

**Why this priority**: Data storage is critical for application functionality but depends on the VM infrastructure being in place first.

**Independent Test**: Can be tested by verifying the 500GB HDD data disk is attached to the VM and the file share is accessible from the VM through the private endpoint.

**Acceptance Scenarios**:

1. **Given** VM infrastructure exists, **When** data disk deployment executes, **Then** 500GB HDD-based managed disk is attached to the VM
2. **Given** storage account is deployed, **When** checking storage configuration, **Then** HDD-backed file share is created
3. **Given** private endpoint is deployed, **When** VM attempts to access file share, **Then** connection succeeds through private network without traversing internet

---

### User Story 3 - Secure Access and Secrets Management (Priority: P2)

Implement bastion host for secure remote access and Key Vault for storing the VM administrator password. This ensures secure access patterns for operations teams.

**Why this priority**: Secure access is essential for ongoing operations but the infrastructure must exist before access can be configured.

**Independent Test**: Can be tested by connecting to the VM through bastion host using credentials retrieved from Key Vault.

**Acceptance Scenarios**:

1. **Given** bastion and Key Vault are deployed, **When** VM administrator password is generated at deployment, **Then** password is stored in Key Vault secret
2. **Given** bastion host is deployed, **When** operator attempts to connect to VM, **Then** connection succeeds through bastion without public IP on VM
3. **Given** Key Vault access is configured, **When** retrieving VM password, **Then** secret can be accessed only by authorized identities
4. **Given** VM subnet NSG is configured, **When** bastion attempts RDP connection to VM, **Then** traffic is allowed through NSG rule (port 3389 from Bastion subnet)

---

### User Story 4 - Internet Connectivity and Network Security (Priority: P3)

Configure NAT gateway for outbound internet access and implement Network Security Groups for all subnets with least-privilege rules.

**Why this priority**: Network security controls are important but the workload can function for testing without full NSG configuration initially.

**Independent Test**: Can be tested by verifying VM can reach internet through NAT gateway and that NSG rules block unauthorized traffic.

**Acceptance Scenarios**:

1. **Given** NAT gateway is deployed, **When** VM initiates outbound internet connection, **Then** traffic routes through NAT gateway
2. **Given** NSGs are configured, **When** unauthorized traffic attempts to reach VM, **Then** traffic is blocked by NSG rules
3. **Given** NSGs are deployed, **When** checking subnet associations, **Then** each subnet has appropriate NSG assigned

---

### User Story 5 - Monitoring and Alerting (Priority: P3)

Deploy Log Analytics workspace, configure diagnostic settings for all resources, and set up critical alerts (VM stopped, disk full, Key Vault access failures).

**Why this priority**: Monitoring is important for operations but the workload can function without it. It provides operational visibility rather than core functionality.

**Independent Test**: Can be tested by verifying diagnostic logs are flowing to Log Analytics and triggering test scenarios that generate alerts.

**Acceptance Scenarios**:

1. **Given** Log Analytics workspace is deployed, **When** resources are created, **Then** diagnostic settings send logs to workspace
2. **Given** alerting is configured, **When** VM is stopped, **Then** critical alert is triggered
3. **Given** alerting is configured, **When** Key Vault access fails, **Then** critical alert is triggered
4. **Given** diagnostic logging is active, **When** querying Log Analytics, **Then** logs are available within 5 minutes

---

## Clarifications

### Session 2026-01-27

- Q: VNet address space and subnet sizing for VM, bastion, and private endpoint subnets? → A: VNet: 10.0.0.0/24, VM subnet: 10.0.0.0/27, Bastion subnet: 10.0.0.64/26, Private endpoint subnet: 10.0.0.128/27
- Q: Storage file share quota size? → A: 1024 GiB (1 TiB)
- Q: Disk space alert threshold percentage? → A: 85% full
- Q: Alert notification method for critical alerts? → A: Azure Portal notifications only
- Q: VM size SKU for 2 cores and 8GB RAM requirement? → A: Standard_D2s_v3

### Edge Cases

- What happens when VM computer name parameter would exceed 15 characters? (NetBIOS limit must be enforced)
- How does deployment handle when Key Vault secret name parameter is not provided or is invalid?
- What happens when storage account name would exceed 24 characters or contains invalid characters?
- How does system handle when no availability zone is specified for resources requiring zone selection?
- What happens when private endpoint deployment fails but storage account succeeds?
- How does deployment handle if bastion subnet already exists in the VNet from a previous deployment?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

<!-- NOTE: "Standard HDD" refers to Azure Standard_LRS disk SKU (magnetic disk storage) -->

- **FR-001**: Infrastructure MUST provision a Windows Server 2016 Virtual Machine with size Standard_D2s_v3 (2 vCPUs, 8 GiB RAM) using Standard HDD for OS disk
- **FR-002**: Infrastructure MUST attach a 500GB HDD-based managed disk to the VM as a data disk
- **FR-003**: Infrastructure MUST create Virtual Network with address space 10.0.0.0/24 containing three subnets: VM subnet (10.0.0.0/27), Bastion subnet (10.0.0.64/26), and private endpoint subnet (10.0.0.128/27)
- **FR-004**: Infrastructure MUST deploy Azure Bastion for secure remote access to the VM without public IP
- **FR-005**: Infrastructure MUST provision Storage Account with HDD-backed file share (1024 GiB quota) accessible via private endpoint
- **FR-006**: Infrastructure MUST deploy NAT Gateway for VM outbound internet connectivity
- **FR-007**: Infrastructure MUST create Network Security Groups for each subnet with least-privilege rules
- **FR-008**: Infrastructure MUST deploy Azure Key Vault to store VM administrator password
- **FR-009**: Infrastructure MUST set VM administrator account name to "vmadmin"
- **FR-010**: Infrastructure MUST ensure VM computer name (NetBIOS name) is 15 characters or fewer
- **FR-011**: Infrastructure MUST generate and store VM administrator password in Key Vault at deployment time
- **FR-012**: Infrastructure MUST accept Key Vault secret name as a parameter from main.bicepparam
- **FR-013**: Infrastructure MUST deploy all resources to a single resource group representing production environment
- **FR-014**: Infrastructure MUST select availability zone between 1-3 for zone-capable resources (never use -1)
- **FR-015**: Infrastructure MUST include rich comments in both main.bicep and main.bicepparam explaining resource purpose and parameters
- **FR-016**: Infrastructure MUST rely exclusively on parameters defined in main.bicepparam file

### Security & Compliance Requirements (Mandatory for all features)

- **SEC-001**: All resources MUST enable diagnostic settings and send logs to Log Analytics Workspace
- **SEC-002**: VM MUST use managed identity for Azure resource authentication (no connection strings/keys in configuration)
- **SEC-003**: Network Security Groups MUST restrict traffic to only necessary ports and protocols per subnet
- **SEC-003a**: VM subnet NSG MUST allow inbound RDP (port 3389) from Bastion subnet (10.0.0.64/26) to enable bastion connectivity
- **SEC-004**: All resources MUST be tagged with compliance identifier "legacy-retention"
- **SEC-005**: VM administrator password MUST be stored in Azure Key Vault, never in code or parameters
- **SEC-006**: VM MUST NOT have public IP address assigned (access only through bastion)
- **SEC-007**: Storage account file share MUST be accessible only through private endpoint, not public endpoint
- **SEC-008**: Key Vault MUST restrict access to only authorized identities using RBAC

### Infrastructure Constraints

- **IC-001**: MUST deploy to westus3 region (US West 3)
- **IC-002**: MUST use Azure Verified Modules (AVM) exclusively (read module readme.md for parameter documentation)
- **IC-003**: MUST validate deployment with `az deployment group validate` before applying
- **IC-004**: MUST run `az deployment group what-if` to preview changes
- **IC-005**: Resource names MUST follow pattern: {resourceType}-{purpose}-{random4-6chars}
- **IC-006**: MUST NOT create additional environments (dev, test, staging) - production only

### Monitoring & Alerting Requirements

- **MON-001**: Infrastructure MUST deploy Log Analytics workspace for centralized logging
- **MON-002**: Infrastructure MUST configure diagnostic logging for VM, Key Vault, Storage Account, and network resources
- **MON-003**: Infrastructure MUST create critical alert for VM stopped/deallocated condition (Portal notifications)
- **MON-004**: Infrastructure MUST create critical alert for disk space exceeding 85% threshold (Portal notifications)
- **MON-005**: Infrastructure MUST create critical alert for Key Vault access failures (Portal notifications)

### Key Azure Resources

- **Virtual Machine**: Windows Server 2016 VM with size Standard_D2s_v3 (2 vCPUs, 8 GiB RAM), Standard HDD OS disk, managed identity enabled
- **Managed Disk**: 500GB HDD-based data disk attached to VM
- **Virtual Network**: VNet with subnets for VM, bastion, and private endpoints
- **Azure Bastion**: Secure RDP access to VM without public IP
- **Storage Account**: Standard HDD storage with file share
- **Private Endpoint**: Secure connectivity between VM and storage account file share
- **NAT Gateway**: Outbound internet connectivity for VM subnet
- **Network Security Groups**: One per subnet with least-privilege rules
- **Key Vault**: Stores VM administrator password as secret
- **Log Analytics Workspace**: Centralized logging for all resources
- **Azure Monitor Alerts**: Critical alerts for VM stopped, disk full, Key Vault access failures

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: Infrastructure deploys successfully within 20 minutes including all resources
- **SC-002**: ARM validation (`az deployment group validate`) passes without errors
- **SC-003**: ARM what-if analysis shows all expected resources will be created
- **SC-004**: VM is accessible via bastion host within 5 minutes of deployment completion
- **SC-005**: VM can access file share through private endpoint connection
- **SC-006**: VM can reach internet through NAT gateway for outbound connections
- **SC-007**: Diagnostic logs from all resources appear in Log Analytics within 5 minutes
- **SC-008**: All resources pass Azure Security Center baseline compliance checks
- **SC-009**: NSG rules successfully block unauthorized traffic in test scenarios
- **SC-010**: VM administrator password can be retrieved from Key Vault by authorized identities
- **SC-011**: Critical alerts can be triggered and verified (VM stop, simulated disk full warning, Key Vault access attempt)

## Assumptions

- Azure subscription has sufficient quota for Standard_D2s_v3 VM size
- Azure Bastion service is available in westus3 region
- Windows Server 2016 image is available in Azure Marketplace for westus3 region
- Log Analytics workspace can be deployed in westus3 region
- Private endpoint feature is available for storage accounts in westus3 region
- NAT Gateway is available in westus3 region
- Deployment is executed by identity with sufficient permissions to create all resource types
- Resource group name will be provided as parameter in main.bicepparam
- Random suffix for resource names will be generated or provided as parameter
- Default log retention period of 30 days is acceptable for Log Analytics (compliance requirement may differ)
- Standard_LRS storage redundancy is acceptable for this legacy workload
- VM will be deployed without availability sets or scale sets (single instance acceptable)
- Availability zone selection (1, 2, or 3) will be provided as parameter

## Out of Scope

- Multi-region deployment or disaster recovery configuration
- High availability (availability sets, load balancers, multiple VMs)
- Auto-scaling capabilities
- Backup and restore automation (Azure Backup configuration)
- Additional environments (development, test, staging)
- Application installation or configuration on the VM
- Custom monitoring dashboards or complex alerting logic beyond critical alerts
- Network connectivity to on-premises networks (VPN or ExpressRoute)
- Azure Active Directory domain join
- Additional data disks beyond the single 500GB disk specified
- Storage account configuration beyond file share (no blob containers, tables, or queues)
- Advanced network features (Azure Firewall, Application Gateway, Traffic Manager)
- Cost optimization recommendations or reserved instance planning
