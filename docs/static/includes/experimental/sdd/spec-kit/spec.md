# Feature Specification: Legacy Windows Server VM Workload

**Feature Branch**: `001-legacy-vm-workload`
**Created**: 2026-01-22
**Status**: Draft
**Input**: User description: "legacy business application, running as a single virtual machine connected to a virtual network. The VM must run Windows Server 2016, needs to have at least 2 CPU cores, 8 GB of RAM, standard HDD and a 500 GB HDD-based data disk attached. It must be remotely accessible via a bastion host and needs to have access to an HDD-backed file share in a storage account connected via a private endpoint. The VM's administrator password (created at the time of deployment) must be stored in a Key Vault"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Deploy Core VM Infrastructure (Priority: P1)

Operations team needs to deploy a Windows Server 2016 virtual machine in an isolated network environment with secure administrative access. The VM must be fully functional for hosting the legacy business application with adequate compute resources.

**Why this priority**: Without the core VM infrastructure, no other functionality can be deployed. This is the foundational MVP that delivers a working, accessible virtual machine.

**Independent Test**: Deploy the Bicep template and verify: (1) VM is created and running, (2) VM has correct OS version (Windows Server 2016), (3) VM meets resource specifications (2 cores, 8GB RAM, Standard HDD OS disk), (4) VM is connected to the virtual network, (5) Bastion host allows RDP connection to the VM

**Acceptance Scenarios**:

1. **Given** Azure subscription with sufficient quota, **When** Bicep template is deployed with valid parameters, **Then** Windows Server 2016 VM is created in US West 3 with 2 CPU cores and 8GB RAM
2. **Given** VM is running, **When** administrator connects via Azure Bastion, **Then** RDP session establishes successfully using credentials from Key Vault
3. **Given** VM deployment completes, **When** checking Azure Portal, **Then** VM status shows as "Running" and all resources are in the same resource group
4. **Given** VM is deployed, **When** reviewing resource locks, **Then** CanNotDelete lock is applied to prevent accidental deletion

---

### User Story 2 - Attach Additional Storage (Priority: P2)

Operations team needs to attach a 500GB HDD-based data disk to the VM to store application data separately from the OS disk, following Azure best practices for data persistence.

**Why this priority**: Application data storage is critical but can be added after the VM is operational. This allows the VM to be tested and validated before adding data storage.

**Independent Test**: After VM is running, deploy the data disk configuration and verify: (1) 500GB HDD data disk is attached to the VM, (2) Disk is visible within Windows Server as an additional volume, (3) Disk performance tier matches Standard HDD specifications

**Acceptance Scenarios**:

1. **Given** VM is running, **When** data disk deployment completes, **Then** 500GB HDD disk is attached to the VM
2. **Given** data disk is attached, **When** administrator logs into VM, **Then** additional disk is visible in Disk Management and can be initialized/formatted
3. **Given** data disk is configured, **When** checking disk properties, **Then** disk uses Standard HDD tier (not Premium SSD)

---

### User Story 3 - Connect to Secure File Share (Priority: P3)

Legacy application needs access to a centralized file share hosted in Azure Storage, accessible only via private network connectivity to meet security and compliance requirements.

**Why this priority**: File share connectivity is important for data sharing but the VM can function independently for initial testing. This builds on the network infrastructure from P1.

**Independent Test**: Deploy storage account with file share and private endpoint, then verify: (1) Storage account is created with file share, (2) Private endpoint exists and connects storage to VNet, (3) VM can mount the file share using private IP address, (4) File share uses HDD performance tier

**Acceptance Scenarios**:

1. **Given** VNet and VM exist, **When** storage account with private endpoint is deployed, **Then** storage account is accessible only via private network
2. **Given** private endpoint is configured, **When** administrator logs into VM and mounts file share, **Then** file share mounts successfully using `\\<private-endpoint-ip>\<share-name>` UNC path
3. **Given** file share is mounted, **When** administrator creates test file, **Then** file is successfully written to and read from the share
4. **Given** storage account is deployed, **When** checking network settings, **Then** public network access is disabled and only private endpoint is allowed

---

### User Story 4 - Secure Secret Management (Priority: P1)

Administrator password for the VM must be securely generated and stored in Azure Key Vault during deployment to meet compliance requirements, with the secret name configurable via parameters.

**Why this priority**: This is part of the core deployment (P1) because the password is generated at deployment time and must be stored before the VM is created. Security compliance is non-negotiable per constitution.

**Independent Test**: Deploy template and verify: (1) Key Vault is created, (2) VM admin password secret is stored in Key Vault with the configured secret name, (3) VM is created successfully using the generated password, (4) Administrator can retrieve password from Key Vault and use it to log in via Bastion

**Acceptance Scenarios**:

1. **Given** deployment parameters include secret name, **When** Bicep template deploys, **Then** Key Vault is created with the admin password stored using the specified secret name
2. **Given** Key Vault contains the secret, **When** administrator retrieves the password from Key Vault, **Then** password can be used to successfully authenticate to the VM via Bastion
3. **Given** Key Vault is deployed, **When** checking access policies, **Then** only authorized identities can read the secret (least-privilege RBAC)
4. **Given** Key Vault is deployed, **When** checking diagnostic settings, **Then** audit logs are enabled and sent to Log Analytics workspace

---

### Edge Cases

- What happens when the specified availability zone is invalid or unavailable in US West 3? (Deployment should fail with clear error message)
- How does the system handle if storage account name conflicts with existing global names? (Use sufficient random suffix to ensure uniqueness)
- What if the Key Vault secret name parameter contains invalid characters? (Validation should fail during deployment with descriptive error)
- How does the VM handle if the file share is unmounted or storage account is deleted? (Application data access fails; requires manual remediation)
- What happens if the private endpoint fails to deploy? (Storage account remains inaccessible; deployment should fail or mark as incomplete)
- How does the system handle if the Bastion host is deleted? (VM becomes inaccessible via Azure Portal; requires recreation of Bastion or alternative access method)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST deploy a Windows Server 2016 virtual machine in US West 3 region
- **FR-002**: Virtual machine MUST have at least 2 CPU cores and 8GB of RAM
- **FR-003**: Virtual machine MUST use Standard HDD storage tier for the OS disk
- **FR-004**: System MUST attach a 500GB HDD-based data disk to the virtual machine
- **FR-005**: System MUST deploy all resources within a single resource group designated for production environment
- **FR-006**: System MUST create a virtual network for VM connectivity
- **FR-007**: System MUST deploy an Azure Bastion host for secure RDP access to the VM
- **FR-008**: System MUST deploy an Azure Storage Account with an HDD-backed file share
- **FR-009**: System MUST configure a private endpoint connecting the storage account to the virtual network
- **FR-010**: System MUST deploy an Azure Key Vault to store sensitive credentials
- **FR-011**: System MUST generate and store the VM administrator password in Key Vault at deployment time
- **FR-012**: Secret name for the admin password MUST be configurable via a parameter in main.bicepparam file
- **FR-013**: All resource names MUST follow the naming convention: `<resource-type-abbreviation>-<workload>-<random-suffix>`
- **FR-014**: All resources MUST be deployed using Azure Verified Modules (AVM) from the official registry
- **FR-015**: Availability zone selection MUST be a value between 1 and 3 (never -1)
- **FR-016**: All configuration MUST be driven by parameters defined in main.bicepparam file
- **FR-017**: System MUST apply CanNotDelete resource locks to all production resources
- **FR-018**: System MUST enable diagnostic settings for all resources, sending logs to Log Analytics workspace
- **FR-019**: System MUST configure network security groups (NSGs) to restrict traffic appropriately
- **FR-020**: System MUST disable public network access to storage account (private endpoint only)

### Key Entities

- **Virtual Machine**: Windows Server 2016 compute instance with 2+ cores, 8GB RAM, Standard HDD OS disk; hosts legacy business application; connected to VNet; accessible via Bastion
- **Data Disk**: 500GB Standard HDD managed disk; attached to VM; provides persistent storage for application data separate from OS disk
- **Virtual Network**: Network infrastructure with appropriate subnets for VM, Bastion, and private endpoints; provides network isolation
- **Bastion Host**: Azure Bastion service providing secure RDP access to VM without exposing public IP; deployed in dedicated subnet
- **Storage Account**: Azure Storage account hosting file share; uses HDD performance tier; accessible only via private endpoint; provides shared file storage
- **File Share**: Azure Files share within storage account; mounted to VM; provides centralized file storage for application
- **Private Endpoint**: Network interface connecting storage account to VNet; eliminates public internet exposure; provides private IP for storage access
- **Key Vault**: Azure Key Vault storing VM administrator password; provides secure secret management; configured with RBAC and audit logging
- **Resource Group**: Logical container for all resources; designated as production environment; single group for simplified management

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Infrastructure deployment completes successfully in under 30 minutes from template execution
- **SC-002**: Administrator can establish RDP connection to VM via Bastion within 2 minutes of deployment completion
- **SC-003**: VM meets exact specifications: Windows Server 2016, 2 CPU cores minimum, 8GB RAM, Standard HDD
- **SC-004**: File share mounts successfully on VM and allows read/write operations without errors
- **SC-005**: All resources are created in US West 3 region with consistent naming convention
- **SC-006**: Deployment validation (az deployment group validate) completes with zero errors before actual deployment
- **SC-007**: VM administrator password is retrievable from Key Vault by authorized users only
- **SC-008**: Storage account is not accessible from public internet (only via private endpoint)
- **SC-009**: All resources have CanNotDelete locks applied preventing accidental deletion
- **SC-010**: Diagnostic logs flow successfully to Log Analytics workspace for all deployed resources
- **SC-011**: Template can be redeployed without errors (idempotent infrastructure-as-code)
- **SC-012**: Zero custom Bicep resource declarations (100% AVM modules used)

## Assumptions *(optional)*

- Azure subscription has sufficient quota for VM size and region deployment
- US West 3 region supports all required resource types (VM, Bastion, Storage, Key Vault)
- Administrator has appropriate RBAC permissions to deploy resources and access Key Vault
- Main.bicepparam file will be created to supply all required parameters (no hardcoded values in main.bicep)
- Legacy business application is compatible with Windows Server 2016 and does not require newer OS versions
- Standard HDD performance tier is sufficient for application workload (no high IOPS requirements)
- Single VM without high availability or disaster recovery is acceptable for this compliance workload
- Availability zones 1, 2, or 3 are all equivalent for this workload (no specific zone preference)
- Random suffix generation for resource names will be handled by Bicep parameters or functions
- Network security rules for NSGs will be determined during planning phase based on application requirements
