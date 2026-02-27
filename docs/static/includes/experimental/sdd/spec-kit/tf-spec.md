# Feature Specification: Legacy Business Application Infrastructure

**Feature Branch**: `001-my-legacy-workload`
**Created**: 2026-02-18
**Status**: Draft
**Input**: User description: "Legacy business application running as a single virtual machine with Windows Server 2016, networking (VNet, Bastion, NAT Gateway, NSGs), storage (file share via private endpoint), Key Vault for secrets, and Log Analytics for monitoring"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Core Compute and Network Infrastructure (Priority: P1)

Deploy a Windows Server 2016 virtual machine within an isolated virtual network with proper subnet segmentation and network security controls. This provides the foundational compute and network infrastructure required for the legacy application.

**Why this priority**: Without the VM and basic networking, the application cannot run. This is the minimum viable infrastructure that delivers compute capability in an isolated, secure network environment.

**Independent Test**: Deploy Terraform configuration, verify VM is created and running in the specified VNet with proper subnets. Confirm NSGs are attached to subnets and default deny rules are in place. VM should be isolated with no internet or external access at this stage.

**Acceptance Scenarios**:

1. **Given** Terraform configuration with VM and VNet resources, **When** `terraform apply` is executed, **Then** a Windows Server 2016 VM is created with 2+ CPU cores, 8GB RAM, standard HDD OS disk, and 500GB HDD data disk
2. **Given** the VM is deployed, **When** checking the virtual network, **Then** VNet contains at least 3 subnets (VM subnet, Bastion subnet, Private Endpoint subnet) with appropriate CIDR ranges
3. **Given** subnets are created, **When** checking NSG assignments, **Then** each subnet has an NSG attached with deny-by-default rules configured
4. **Given** VM is running, **When** checking VM properties, **Then** computer name is 15 characters or fewer, administrator account is "vmadmin", and password is stored in Key Vault (secret name configurable)
5. **Given** VM subnet NSG rules, **When** checking inbound rules, **Then** NSG allows RDP (port 3389) from Bastion subnet only

---

### User Story 2 - Secure Remote Access (Priority: P2)

Enable secure remote access to the virtual machine through Azure Bastion and store the VM administrator password securely in Azure Key Vault. This allows administrators to manage the VM without exposing it to the internet.

**Why this priority**: Secure access is critical for managing the VM and performing administrative tasks. Without Bastion, the VM would need a public IP (violating security requirements) or would be completely inaccessible.

**Independent Test**: After deploying US1, deploy Bastion and Key Vault infrastructure. Verify administrators can connect to the VM via Azure Bastion using credentials retrieved from Key Vault. Confirm VM has no public IP address.

**Acceptance Scenarios**:

1. **Given** Bastion host and Key Vault are deployed, **When** administrator navigates to VM in Azure Portal, **Then** "Connect via Bastion" option is available
2. **Given** Bastion connection initiated, **When** using "vmadmin" username and password from Key Vault, **Then** RDP session to VM is successfully established
3. **Given** Key Vault is deployed, **When** checking secrets, **Then** VM administrator password is stored as a secret with configurable name (defined in terraform.tfvars)
4. **Given** VM networking configuration, **When** checking VM properties, **Then** VM has no public IP address and is not directly accessible from internet
5. **Given** Key Vault access policies, **When** Terraform deploys the infrastructure, **Then** Key Vault uses managed identity for authentication (no service principal credentials in code)

---

### User Story 3 - Application Storage Integration (Priority: P3)

Provide secure access to an Azure Files share for application data storage, connected via private endpoint to ensure data does not traverse the public internet.

**Why this priority**: The legacy application requires access to a file share for data persistence. This enables the application's core functionality while maintaining security through private connectivity.

**Independent Test**: After deploying US1 and US2, deploy storage account with file share and private endpoint. From the VM, mount the Azure Files share using private endpoint IP. Verify data can be written to and read from the share without public internet connectivity.

**Acceptance Scenarios**:

1. **Given** storage account is deployed, **When** checking storage configuration, **Then** storage account has HDD-backed file share created (Standard tier, not Premium)
2. **Given** private endpoint is deployed, **When** checking network connectivity, **Then** private endpoint is connected to the Private Endpoint subnet in the VNet
3. **Given** private endpoint exists, **When** checking DNS resolution from VM, **Then** storage account FQDN resolves to private endpoint IP address (not public IP)
4. **Given** VM is running, **When** attempting to mount file share, **Then** file share is accessible from VM using private IP and SMB protocol
5. **Given** storage NSG rules, **When** checking Private Endpoint subnet NSG, **Then** NSG allows SMB traffic (port 445) from VM subnet only

---

### User Story 4 - Internet Access and Observability (Priority: P4)

Enable outbound internet access via NAT Gateway for Windows Updates and patches, and implement comprehensive monitoring through Log Analytics with diagnostic logging and critical alerts.

**Why this priority**: While not required for basic application functionality, internet access enables the VM to download security updates. Monitoring and alerting provide operational visibility and compliance evidence.

**Independent Test**: After deploying US1-US3, deploy NAT Gateway and Log Analytics. From VM, verify outbound internet connectivity (e.g., download Windows Update). Confirm diagnostic logs are flowing to Log Analytics and test alerts trigger correctly.

**Acceptance Scenarios**:

1. **Given** NAT Gateway is deployed and associated with VM subnet, **When** VM attempts outbound HTTP/HTTPS connection, **Then** connection succeeds with traffic routed through NAT Gateway
2. **Given** VM attempts inbound connection from internet, **When** traffic reaches VM subnet, **Then** connection is blocked (VM remains inaccessible from internet)
3. **Given** Log Analytics workspace is deployed, **When** checking diagnostic settings, **Then** VM, Key Vault, and Storage Account have diagnostic logging enabled sending logs to Log Analytics
4. **Given** alerts are configured, **When** VM is stopped, **Then** critical alert notification is triggered
5. **Given** alerts are configured, **When** VM disk reaches 90% capacity, **Then** critical alert notification is triggered
6. **Given** alerts are configured, **When** Key Vault access failure occurs (e.g., permission denied), **Then** critical alert notification is triggered

---

### Edge Cases

- **VM naming constraints**: What happens when generated VM computer name exceeds 15 characters (NetBIOS limit)? Truncate or error during validation.
- **Availability zone selection**: If availability zones 1-3 are unavailable in westus3 region, how does deployment handle this? Fail with clear error or fall back to no-zone deployment?
- **Private endpoint DNS**: What happens when private DNS zone for storage account doesn't exist or isn't linked to VNet? File share mount will fail without proper DNS resolution.
- **Key Vault secret naming**: What happens when the secret name specified in terraform.tfvars already exists in Key Vault? Overwrite or error?
- **NSG rule conflicts**: What happens when custom NSG rules conflict with required rules (e.g., accidentally blocking RDP from Bastion)? Terraform should fail validation.
- **Storage account naming**: What happens when randomly generated storage account name conflicts with existing global namespace? Terraform apply will fail - require retry with new random suffix.
- **Bastion subnet size**: What happens when VNet address space is too small for required subnets including /26 for Bastion? Deployment fails with clear CIDR allocation error.
- **Managed disk attachment**: What happens when 500GB data disk fails to attach to VM? Deployment should fail atomically (VM should not be left in inconsistent state).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Infrastructure MUST deploy a Windows Server 2016 virtual machine with minimum 2 CPU cores and 8GB RAM
- **FR-002**: VM MUST use standard HDD for OS disk (not SSD) for cost optimization
- **FR-003**: VM MUST have a 500GB HDD-based managed disk attached as data disk
- **FR-004**: VM computer name (NetBIOS name) MUST be 15 characters or fewer to comply with Windows naming limits
- **FR-005**: VM administrator account MUST be named "vmadmin"
- **FR-006**: VM administrator password MUST be generated at deployment time and stored in Key Vault
- **FR-007**: Infrastructure MUST deploy a virtual network with at least 3 subnets (VM subnet, Bastion subnet, Private Endpoint subnet)
- **FR-008**: Infrastructure MUST deploy Network Security Groups for each subnet with deny-by-default posture
- **FR-009**: VM subnet NSG MUST allow inbound RDP (port 3389) from Bastion subnet ONLY
- **FR-010**: Infrastructure MUST deploy Azure Bastion for secure RDP access to VM (no public IP on VM)
- **FR-011**: VM MUST NOT be accessible directly from the internet (no public IP address on VM)
- **FR-012**: Infrastructure MUST deploy NAT Gateway associated with VM subnet for outbound internet access
- **FR-013**: Infrastructure MUST deploy storage account with HDD-backed (Standard tier) Azure Files share
- **FR-014**: Storage account file share MUST be accessible from VM via private endpoint (no public access)
- **FR-015**: Infrastructure MUST deploy Key Vault for storing VM administrator password securely
- **FR-016**: Key Vault secret name for VM password MUST be configurable via terraform.tfvars variable
- **FR-017**: Infrastructure MUST use managed identities for authentication (no service principal credentials in Terraform code)
- **FR-018**: Infrastructure MUST deploy Log Analytics workspace for centralized logging
- **FR-019**: VM, Key Vault, and Storage Account MUST have diagnostic settings enabled sending logs to Log Analytics
- **FR-020**: Infrastructure MUST configure critical alerts: VM stopped, VM disk usage >90%, Key Vault access failures
- **FR-021**: All configurable values (VM size, disk sizes, subnet CIDRs, secret names, etc.) MUST be defined in terraform.tfvars (not hardcoded in main.tf)
- **FR-022**: All Terraform files (main.tf, terraform.tfvars) MUST include rich comments explaining purpose of each resource, variable, and configuration block
- **FR-023**: When selecting availability zones, MUST choose zone 1, 2, or 3 (NEVER use -1 or no-zone unless region doesn't support zones)
- **FR-024**: All resources MUST be deployed in a single resource group representing production environment
- **FR-025**: Infrastructure MUST reference AVM module documentation (readme.md) to determine correct variable names and object structures (no guessing)

### Infrastructure Requirements *(for Terraform IaC projects)*

**Azure Resources Required**:
- **Resource 1**: Resource Group for all resources - Built-in: `azurerm_resource_group`
- **Resource 2**: Virtual Network with 3+ subnets - AVM Module: `Azure/avm-res-network-virtualnetwork/azurerm`
- **Resource 3**: Network Security Groups (3 minimum) - AVM Module: `Azure/avm-res-network-networksecuritygroup/azurerm`
- **Resource 4**: Windows Server 2016 Virtual Machine - AVM Module: `Azure/avm-res-compute-virtualmachine/azurerm`
- **Resource 5**: Azure Bastion Host - AVM Module: `Azure/avm-res-network-bastionhost/azurerm`
- **Resource 6**: Key Vault for password storage - AVM Module: `Azure/avm-res-keyvault-vault/azurerm`
- **Resource 7**: Storage Account with file share - AVM Module: `Azure/avm-res-storage-storageaccount/azurerm`
- **Resource 8**: Private Endpoint for storage - AVM Module: `Azure/avm-res-network-privateendpoint/azurerm` (or part of storage module)
- **Resource 9**: NAT Gateway - AVM Module: `Azure/avm-res-network-natgateway/azurerm`
- **Resource 10**: Log Analytics Workspace - AVM Module: `Azure/avm-res-operationalinsights-workspace/azurerm`
- **Resource 11**: Alerts/Action Groups - AVM Module: `Azure/avm-res-insights-actiongroup/azurerm` and alert resources
- **Resource 12**: Random string for naming suffix - Built-in: `random_string` from random provider

**Infrastructure Constraints**:
- **IC-001**: All resources MUST be deployed to `westus3` region (per constitution)
- **IC-002**: Terraform state MUST be stored in Azure Storage backend with state locking enabled
- **IC-003**: Resource naming MUST follow `<type>-<workload>-<suffix>` pattern (per constitution, e.g., `vm-avmlegacy-8k3m9x`)
- **IC-004**: No high-availability or geo-redundancy configurations (legacy workload constraint, single VM acceptable)
- **IC-005**: All resources MUST be deployed in single Resource Group (named per convention: `rg-my-legacy-workload-prod-wus3`)
- **IC-006**: Availability zone MUST be selected (zone 1, 2, or 3) - NEVER use -1 or disable zones explicitly
- **IC-007**: Use HDD/Standard tier storage for cost optimization (OS disk, data disk, storage account)
- **IC-008**: VNet MUST have sufficient address space for minimum 3 subnets (recommend /23 or larger for VNet, /26 for Bastion per Azure requirements)
- **IC-009**: Private Endpoint subnet MUST have `privateEndpointNetworkPolicies` disabled per Azure requirements
- **IC-010**: Computer name generation MUST enforce 15-character limit (Windows NetBIOS constraint)

**Security & Compliance**:
- **SEC-001**: VM MUST use managed identity (system-assigned) for Azure service authentication
- **SEC-002**: VM administrator password MUST be stored in Key Vault with secret name defined in terraform.tfvars
- **SEC-003**: NO service principal credentials or secrets in Terraform files (.tf or .tfvars)
- **SEC-004**: Network Security Groups MUST implement deny-by-default posture with explicit allow rules only
- **SEC-005**: VM subnet NSG MUST allow RDP (3389) ONLY from Bastion subnet CIDR (source IP restricted)
- **SEC-006**: Bastion subnet NSG MUST allow inbound 443 from internet (Azure Bastion requirement) and outbound RDP to VM subnet
- **SEC-007**: Private Endpoint subnet NSG MUST allow SMB (445) from VM subnet for file share access
- **SEC-008**: VM MUST NOT have public IP address (internet inaccessible)
- **SEC-009**: Storage account MUST have public network access disabled (private endpoint only)
- **SEC-010**: Diagnostic logging MUST be enabled on VM, Key Vault, and Storage Account sending logs to Log Analytics
- **SEC-011**: Resource locks (CanNotDelete) MUST be applied to Resource Group, VM, Key Vault, and Storage Account (compliance-critical resources)
- **SEC-012**: Key Vault MUST have soft-delete and purge protection enabled
- **SEC-013**: Storage account MUST use encryption at rest with Microsoft-managed keys (minimum)
- **SEC-014**: All network traffic between VM and storage MUST traverse private endpoint (verified via NSG flow logs or connection test)

**State Management**:
- **State Backend**: Azure Storage Account in separate resource group (pre-existing, not created by this Terraform)
- **State File**: `my-legacy-workload-prod.tfstate`
- **State Locking**: Enabled via blob lease mechanism
- **Workspaces/Key Prefix**: Single production environment only - use `prod.tfvars` for variable values

### Key Entities *(include if feature involves data)*

- **Virtual Machine**: Windows Server 2016 compute instance running legacy business application. Attributes: computer name (≤15 chars), size (Standard_D2s_v3 or similar with 2+ cores, 8GB RAM), OS disk (Standard HDD), data disk (500GB Standard HDD), administrator credentials (username: vmadmin, password in Key Vault).

- **Virtual Network**: Isolated network containing all infrastructure. Attributes: address space (e.g., 10.0.0.0/23), subnets (VM subnet, Bastion subnet /26, Private Endpoint subnet).

- **Network Security Group**: Firewall rules for subnet-level traffic control. Attributes: associated subnet, inbound rules (RDP from Bastion, SMB to private endpoint), outbound rules (allow NAT Gateway for internet, deny all else).

- **Azure Bastion**: Managed PaaS service providing secure RDP/SSH access. Attributes: Bastion subnet (/26 minimum), public IP (managed by Bastion), SKU (Basic or Standard).

- **Key Vault**: Secure secrets store for VM password. Attributes: soft-delete enabled, purge protection enabled, access policies (Terraform managed identity for deployment, VM managed identity for runtime access if needed).

- **Storage Account**: Azure Files storage for application data. Attributes: Standard performance tier (HDD), LRS replication, file share (e.g., 100GB quota), private endpoint connection.

- **Private Endpoint**: Network interface in VNet providing private IP for storage account. Attributes: subnet (Private Endpoint subnet), private DNS integration (optional but recommended).

- **NAT Gateway**: Managed outbound internet gateway. Attributes: public IP address, associated with VM subnet for outbound traffic.

- **Log Analytics Workspace**: Centralized log repository. Attributes: retention period (e.g., 30-90 days per compliance requirements), diagnostic settings (VM, Key Vault, Storage Account).

- **Alerts**: Monitoring rules triggering on critical conditions. Attributes: VM stopped alert, disk space alert (>90%), Key Vault access failure alert, action group for notifications.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Infrastructure deployment completes successfully via `terraform apply` within 30 minutes with all resources in "healthy" state
- **SC-002**: Administrator can establish RDP connection to VM via Azure Bastion within 2 minutes of infrastructure deployment completion
- **SC-003**: VM administrator password retrieved from Key Vault successfully authenticates RDP session via Bastion (100% success rate)
- **SC-004**: VM can mount Azure Files share via private endpoint and read/write files without errors (verified via test file operations)
- **SC-005**: VM can download content from internet via NAT Gateway (e.g., successful Windows Update check or HTTP GET to microsoft.com)
- **SC-006**: VM is NOT reachable via direct internet connection (verified via external port scan showing no open ports)
- **SC-007**: Diagnostic logs from VM, Key Vault, and Storage Account appear in Log Analytics within 15 minutes of deployment
- **SC-008**: Critical alerts (VM stopped, disk >90%, Key Vault access failure) trigger notifications within 5 minutes of condition occurring (tested via controlled failure scenarios)
- **SC-009**: All Terraform validation steps pass (`terraform fmt -check`, `terraform validate`, `tfsec` with no HIGH/CRITICAL findings)
- **SC-010**: Infrastructure deployment uses ONLY values from terraform.tfvars (no hardcoded values in main.tf) - verified via code review
- **SC-011**: All AVM module variables are correctly structured per module documentation (verified by successful deployment without Terraform errors)
- **SC-012**: Computer name is 15 characters or fewer (verified via VM properties after deployment)
- **SC-013**: Total monthly cost of deployed infrastructure is under $200/month (estimated based on Azure pricing calculator)

## Assumptions

- **A-001**: Azure subscription has sufficient quota for VM size, NAT Gateway, and Bastion in westus3 region
- **A-002**: Terraform state backend (Azure Storage Account) already exists and is configured prior to deployment (not managed by this Terraform code)
- **A-003**: Deployment identity (user, service principal, or managed identity running Terraform) has Contributor access to target subscription or resource group scope
- **A-004**: No existing resources with conflicting names in the subscription (e.g., duplicate storage account name, Key Vault name)
- **A-005**: Azure region westus3 supports availability zones (deployment assumes zone selection 1-3 is valid)
- **A-006**: Legacy application compatibility with Windows Server 2016 has been validated (not part of infrastructure scope)
- **A-007**: Legacy application does not require specific VM size beyond minimum 2 cores, 8GB RAM (actual VM SKU chosen for cost-performance balance)
- **A-008**: 500GB data disk is sufficient for application data storage requirements (not dynamically scaled)
- **A-009**: Standard HDD performance is adequate for legacy application workload (no IOPS/throughput requirements specified)
- **A-010**: File share quota (e.g., 100GB) is sufficient for application needs - configurable in terraform.tfvars if different
- **A-011**: Alert notifications can use email or webhook action group (specific notification target configured separately or in variables)
- **A-012**: VNet address space 10.0.0.0/23 (512 IPs) is sufficient and does not conflict with on-premises networks or VPN peering requirements
- **A-013**: No ExpressRoute or VPN gateway integration required (VM internet access is outbound only via NAT Gateway)
- **A-014**: VM does not require domain join (workgroup/standalone configuration acceptable)
- **A-015**: No existing Azure Policy assignments block required configuration (e.g., policy preventing public IP on Bastion, policy requiring specific encryption)

## Dependencies

- **D-001**: Terraform >= 1.5.0 installed on deployment machine
- **D-002**: Azure CLI authenticated with sufficient permissions (`az login` completed)
- **D-003**: AVM modules available from Terraform Registry (internet connectivity required during `terraform init`)
- **D-004**: Azure subscription with active valid payment method and sufficient credits
- **D-005**: Pre-existing Azure Storage Account and container for Terraform state backend
- **D-006**: Pre-existing Resource Group for Terraform state backend (separate from workload resource group)
- **D-007**: Azure region westus3 supports all required resource types (VM, Bastion, NAT Gateway, availability zones)
- **D-008**: AVM module documentation (readme.md) accessible for each module used (refer to Terraform Registry or GitHub)
- **D-009**: Terraform providers: azurerm (~> 3.75), random (~> 3.5) (specified in versions.tf)
- **D-010**: Security scanning tools (tfsec or checkov) installed if enforcing constitution security requirements
- **D-011**: Windows Server 2016 image available in Azure Marketplace (standard Microsoft image)
- **D-012**: Understanding of Terraform module composition (reading AVM module documentation to determine input variables and complex objects)

## Out of Scope

- **OS-001**: Installation or configuration of legacy business application on the VM (infrastructure only, app deployment separate)
- **OS-002**: Domain join or Active Directory integration (standalone/workgroup VM)
- **OS-003**: VPN gateway or ExpressRoute connectivity to on-premises networks
- **OS-004**: Multiple environments (dev, test, staging) - ONLY production environment deployed
- **OS-005**: High availability configuration (multiple VMs, load balancer, availability set) - single VM by design per legacy constraint
- **OS-006**: Disaster recovery or geo-replication configuration (no backup policies, no secondary region)
- **OS-007**: Auto-scaling or dynamic resource sizing (fixed VM size, fixed disk sizes)
- **OS-008**: Custom VM extensions or DSC configuration (beyond basic deployment)
- **OS-009**: Application-level monitoring or APM (only infrastructure-level diagnostics in Log Analytics)
- **OS-010**: Database deployment (if legacy app uses database, assumed to be on separate server or managed service)
- **OS-011**: DNS records in public or private DNS zones (beyond private endpoint DNS if AVM module handles it)
- **OS-012**: Certificate management or SSL/TLS termination (application responsibility if needed)
- **OS-013**: Cost management tags beyond basic workload identification (detailed cost center, project, owner tags)
- **OS-014**: Compliance frameworks implementation (HIPAA, PCI-DSS, SOC2) - basic security controls only per constitution
- **OS-015**: Terraform module development (using existing AVM modules only, no custom module authoring)
