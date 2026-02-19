<!-- markdownlint-disable -->
# Tasks: Legacy VM Workload Infrastructure

**Feature**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md
**Date**: 2026-01-27
**Branch**: `001-legacy-vm-workload`

**Organization**: Tasks are grouped by user story (US1-US5) to enable independent implementation and testing.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Parallelizable (different files, no blocking dependencies)
- **[Story]**: User story label (US1, US2, US3, US4, US5)
- File paths included in descriptions

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Basic project structure and Bicep configuration

- [ ] T001 Create infrastructure directory structure: infra/, infra/docs/
- [ ] T002 Create bicepconfig.json with AVM analyzer rules at infra/bicepconfig.json
- [ ] T003 [P] Create .gitignore file to exclude .bicep build artifacts (*.json from main.bicep compilation)
- [ ] T004 [P] Create project README.md at repository root with quickstart reference
- [ ] T005 Initialize main.bicep with metadata, targetScope='resourceGroup', location parameter

---

## Phase 2: Foundational (Blocking Prerequisites for All User Stories)

**Purpose**: Shared infrastructure that MUST be complete before any user story implementation

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T006 Add parameters to main.bicep: vmSize (default: Standard_D2s_v3), vmAdminUsername (default: vmadmin), vmAdminPasswordSecretName (default: 'vm-admin-password'), availabilityZone (default: 1), fileShareQuotaGiB (default: 1024), logAnalyticsRetentionDays (default: 30)
- [ ] T007 Define variables in main.bicep: suffix = uniqueString(resourceGroup().id), vmPassword = 'P@ssw0rd!${uniqueString(resourceGroup().id, deployment().name, utcNow('u'))}' (NOTE: utcNow() makes deployment non-idempotent - password regenerates on each deploy. Acceptable for initial deployment; consider removing utcNow() for idempotent redeployments)
- [ ] T008 Define resource naming variables: vnetName, vmName, kvName, lawName, stName (storage: no hyphens, max 24 chars)
- [ ] T009 [P] Define tags variable: workload='legacy-vm', environment='production', compliance='legacy-retention', managedBy='bicep-avm'
- [ ] T010 Add AVM module for Log Analytics Workspace (avm/res/operational-insights/workspace:0.15.0) at infra/main.bicep
- [ ] T011 Configure Log Analytics parameters: name, location, retentionInDays, tags
- [ ] T012 Create main.bicepparam file at infra/main.bicepparam with 'using' directive and parameter defaults

**Checkpoint**: Foundation ready - user story phases can now proceed in parallel (if staffed) or sequentially by priority

---

## Phase 3: User Story 1 - Core VM Infrastructure (Priority: P1) 🎯 MVP

**Goal**: Deploy VNet, VM with Windows Server 2016, basic networking - foundational workload infrastructure

**Independent Test**: Deploy to test resource group, verify VM created with correct specs (Standard_D2s_v3, Windows Server 2016), VM communicates within VNet

### Validation for User Story 1 (MANDATORY - Constitution Principle III) ⚠️

> **NOTE: These validation tasks must be executed BEFORE deployment**

- [ ] T013 [US1] Run `bicep build infra/main.bicep` to compile and check syntax errors
- [ ] T014 [US1] Run `az deployment group validate --resource-group rg-legacyvm-test --template-file main.bicep --parameters main.bicepparam`
- [ ] T015 [US1] Run `az deployment group what-if --resource-group rg-legacyvm-test --template-file main.bicep --parameters main.bicepparam`
- [ ] T016 [US1] Review what-if output: verify VNet, VM, NIC will be created with no unexpected changes

### Implementation for User Story 1

- [ ] T017 [P] [US1] Add AVM module for Virtual Network (avm/res/network/virtual-network:0.7.2) in main.bicep
- [ ] T018 [US1] Configure VNet parameters: name, location, addressPrefixes=['10.0.0.0/24'], subnets array with 3 subnets (VM: 10.0.0.0/27, Bastion: 10.0.0.64/26, PE: 10.0.0.128/27)
- [ ] T019 [US1] Add diagnostic settings to VNet module: send to Log Analytics workspace ID reference
- [ ] T020 [P] [US1] Add AVM module for Virtual Machine (avm/res/compute/virtual-machine:0.21.0) in main.bicep
- [ ] T021 [US1] Configure VM parameters: name='vm-legacyvm-${suffix}', computerName='vm-${substring(suffix,0,10)}' (≤15 chars), size=vmSize parameter, adminUsername=vmAdminUsername, adminPassword=kvSecretReference, zone=availabilityZone
- [ ] T022 [US1] Configure VM OS: imageReference for Windows Server 2016, osDisk with Standard_LRS SKU (HDD performance tier)
- [ ] T023 [US1] Configure VM managed identity: type='SystemAssigned'
- [ ] T024 [US1] Configure VM NIC: attach to VM subnet, no public IP, dynamic private IP
- [ ] T025 [US1] Add VM diagnostic settings to Log Analytics workspace
- [ ] T026 [US1] Add VM outputs: vmName, vmResourceId, vmPrivateIP

### Deployment for User Story 1

- [ ] T027 [US1] Create Azure resource group: `az group create --name rg-legacyvm-test --location westus3`
- [ ] T028 [US1] Deploy to test resource group: `az deployment group create --resource-group rg-legacyvm-test --template-file main.bicep --parameters main.bicepparam`
- [ ] T029 [US1] Verify VNet created with 3 subnets in Azure Portal (10.0.0.0/24 address space)
- [ ] T030 [US1] Verify VM created with Windows Server 2016, Standard_D2s_v3, correct zone
- [ ] T031 [US1] Verify VM computer name is ≤15 characters (NetBIOS limit)
- [ ] T032 [US1] Verify diagnostic logs flowing to Log Analytics workspace within 5 minutes

**Checkpoint**: User Story 1 complete - VM infrastructure deployed and validated. Ready to proceed with US2 and US3 in parallel.

---

## Phase 4: User Story 2 - Secure Storage and Data Disk (Priority: P2)

**Goal**: Attach 500GB data disk to VM, deploy storage account with 1TB file share via private endpoint

**Independent Test**: Verify 500GB HDD data disk attached to VM, file share accessible from VM through private endpoint (no internet traversal)

### Implementation for User Story 2

- [ ] T033 [P] [US2] Add data disk to VM module configuration in main.bicep: dataDisks array with disk size=500, sku=Standard_LRS, lun=0, name='datadisk-01'
- [ ] T034 [P] [US2] Add AVM module for Storage Account (avm/res/storage/storage-account:0.31.0) in main.bicep
- [ ] T035 [US2] Configure storage parameters: name='st${replace(suffix, '-', '')}' (max 24 chars, no hyphens), kind='StorageV2', sku='Standard_LRS', accessTier='Hot', publicNetworkAccess='Disabled'
- [ ] T036 [US2] Configure file share in storage module: fileServices with share name='fileshare', quota=fileShareQuotaGiB (1024 GiB)
- [ ] T037 [US2] Add diagnostic settings to storage module: send to Log Analytics workspace
- [ ] T038 [P] [US2] Add AVM module for Private DNS Zone (avm/res/network/private-dns-zone:0.8.0) in main.bicep
- [ ] T039 [US2] Configure DNS zone name: 'privatelink.file.core.windows.net', VNet link to main VNet
- [ ] T040 [P] [US2] Add AVM module for Private Endpoint (avm/res/network/private-endpoint:0.11.1) in main.bicep
- [ ] T041 [US2] Configure private endpoint: subnet=PE subnet, groupIds=['file'], privateDnsZoneResourceIds=[DNS zone ID], link to storage account resource
- [ ] T042 [US2] Add storage outputs: storageAccountName, fileShareName, privateEndpointIP

### Deployment for User Story 2

- [ ] T043 [US2] Re-run validation: `bicep build`, `az deployment validate`, `what-if` analysis
- [ ] T044 [US2] Deploy updated template to test resource group
- [ ] T045 [US2] Verify 500GB data disk attached to VM in Azure Portal (LUN 0, Standard_LRS)
- [ ] T046 [US2] Verify storage account created with public access disabled
- [ ] T047 [US2] Verify file share created with 1024 GiB quota
- [ ] T048 [US2] Verify private endpoint resolves to internal IP (10.0.0.128/27 range): `nslookup st{random}.file.core.windows.net` from VM
- [ ] T049 [US2] Test file share access from VM via Bastion: `Test-NetConnection -ComputerName st{random}.file.core.windows.net -Port 445`

**Checkpoint**: User Stories 1 AND 2 complete - VM with data disk and storage file share via private endpoint validated.

---

## Phase 5: User Story 3 - Secure Access and Secrets Management (Priority: P2)

**Goal**: Deploy Azure Bastion for secure RDP access, Key Vault for storing VM password

**Independent Test**: Connect to VM through Bastion host using password retrieved from Key Vault (no public IP on VM)

### Implementation for User Story 3

- [ ] T050 [P] [US3] Add AVM module for Key Vault (avm/res/key-vault/vault:0.13.3) in main.bicep
- [ ] T051 [US3] Configure Key Vault parameters: name='kv-legacyvm-${suffix}', sku='standard', enableRbacAuthorization=true, softDeleteRetentionInDays=90
- [ ] T052 [US3] Add Key Vault secret via module's secrets parameter: name=vmAdminPasswordSecretName parameter, value=vmPassword variable, contentType='text/plain'
- [ ] T053 [US3] Add RBAC role assignment in Key Vault module: principalId=VM managed identity, roleDefinitionIdOrName='Key Vault Secrets User'
- [ ] T054 [US3] Add Key Vault diagnostic settings to Log Analytics workspace
- [ ] T055 [P] [US3] Update VM module configuration: change adminPassword to reference Key Vault secret (use getSecret() or secretReference)
- [ ] T056 [P] [US3] Add AVM module for Bastion Host (avm/res/network/bastion-host:0.8.2) in main.bicep
- [ ] T057 [US3] Configure Bastion parameters: name='bas-legacyvm-${suffix}', sku='Basic', vnetId=VNet resource ID, subnetName='AzureBastionSubnet'
- [ ] T058 [US3] Add Bastion diagnostic settings to Log Analytics workspace
- [ ] T059 [US3] Add Key Vault and Bastion outputs: kvName, kvResourceId, bastionName, bastionResourceId

### Deployment for User Story 3

- [ ] T060 [US3] Re-run validation: `bicep build`, `az deployment validate`, `what-if` analysis
- [ ] T061 [US3] Deploy updated template to test resource group (expected duration: 15-20 minutes for Bastion)
- [ ] T062 [US3] Verify Key Vault created with RBAC enabled (not access policies)
- [ ] T063 [US3] Verify VM password stored as Key Vault secret: `az keyvault secret show --name vm-admin-password --vault-name kv-legacyvm-{suffix}`
- [ ] T064 [US3] Verify VM managed identity has 'Key Vault Secrets User' role on Key Vault
- [ ] T065 [US3] Verify Azure Bastion deployed successfully in Bastion subnet
- [ ] T066 [US3] Test Bastion connectivity: Connect to VM via Azure Portal → VM → Connect → Bastion, use username='vmadmin' and password from Key Vault
- [ ] T067 [US3] Verify VM has no public IP address assigned (confirm access only through Bastion)

**Checkpoint**: User Stories 1, 2, AND 3 complete - Full VM infrastructure with secure access and storage operational.

---

## Phase 6: User Story 4 - Internet Connectivity and Network Security (Priority: P3)

**Goal**: Configure NAT Gateway for outbound internet, implement NSGs for all subnets with least-privilege rules

**Independent Test**: Verify VM reaches internet through NAT Gateway, NSG rules block unauthorized traffic

### Implementation for User Story 4

- [ ] T068 [P] [US4] Add AVM module for NAT Gateway (avm/res/network/nat-gateway:2.0.1) in main.bicep
- [ ] T069 [US4] Configure NAT Gateway parameters: name='nat-legacyvm-${suffix}', zone=availabilityZone, publicIpAddressObjects=[{name: 'pip-nat'}]
- [ ] T070 [US4] Update VNet module configuration: associate NAT Gateway with VM subnet (natGatewayId in subnet definition)
- [ ] T071 [US4] Add NAT Gateway diagnostic settings to Log Analytics workspace
- [ ] T072 [P] [US4] Add AVM module for VM Subnet NSG (avm/res/network/network-security-group:0.5.2) in main.bicep
- [ ] T073 [US4] Configure VM NSG security rules: **CRITICAL - inbound allow TCP 3389 from Bastion subnet (10.0.0.64/26) priority 100**, inbound deny all (priority 4096), outbound allow Internet (priority 100), outbound allow VNet (priority 200), outbound deny all (priority 4096)
- [ ] T074 [US4] Update VNet module: associate VM NSG with VM subnet (networkSecurityGroupId in subnet definition)
- [ ] T075 [US4] Add VM NSG diagnostic settings to Log Analytics workspace
- [ ] T076 [P] [US4] Add AVM module for Bastion Subnet NSG (avm/res/network/network-security-group:0.5.2) in main.bicep
- [ ] T077 [US4] Configure Bastion NSG security rules: inbound allow 443 from Internet, allow GatewayManager 443, allow AzureLoadBalancer 443, allow Bastion communication 8080/5701; outbound allow SSH/RDP to VNet, allow Azure Cloud 443, allow Bastion communication, allow HTTP 80
- [ ] T078 [US4] Update VNet module: associate Bastion NSG with Bastion subnet
- [ ] T079 [US4] Add Bastion NSG diagnostic settings to Log Analytics workspace
- [ ] T080 [P] [US4] Add AVM module for PE Subnet NSG (avm/res/network/network-security-group:0.5.2) in main.bicep
- [ ] T081 [US4] Configure PE NSG security rules: inbound allow TCP 445 from VM subnet (10.0.0.0/27), inbound deny all; outbound allow all
- [ ] T082 [US4] Update VNet module: associate PE NSG with PE subnet
- [ ] T083 [US4] Add PE NSG diagnostic settings to Log Analytics workspace
- [ ] T084 [US4] Add NSG and NAT Gateway outputs: nsgVmName, nsgBastionName, nsgPeName, natGatewayName

### Deployment for User Story 4

- [ ] T085 [US4] Re-run validation: `bicep build`, `az deployment validate`, `what-if` analysis
- [ ] T086 [US4] Deploy updated template to test resource group
- [ ] T087 [US4] Verify NAT Gateway created with public IP and associated with VM subnet
- [ ] T088 [US4] Verify 3 NSGs created and associated with correct subnets
- [ ] T089 [US4] Test outbound internet from VM via Bastion RDP session: `Test-NetConnection -ComputerName google.com -Port 443` (should succeed through NAT Gateway)
- [ ] T090 [US4] Test NSG deny rules: attempt unauthorized inbound connection to VM (should be blocked)
- [ ] T091 [US4] Verify all NSG diagnostic logs flowing to Log Analytics workspace

**Checkpoint**: User Stories 1-4 complete - Full network security and internet connectivity operational.

---

## Phase 7: User Story 5 - Monitoring and Alerting (Priority: P3)

**Goal**: Configure diagnostic settings for all resources, deploy 3 critical alerts (VM stopped, disk >85%, Key Vault access failures)

**Independent Test**: Verify diagnostic logs flowing to Log Analytics, trigger test alert scenarios and confirm alerts fire

### Implementation for User Story 5

- [ ] T092 [P] [US5] Add AVM module for VM Stopped Alert (avm/res/insights/metric-alert:0.4.1) in main.bicep
- [ ] T093 [US5] Configure VM stopped alert: name='alert-vm-stopped-legacyvm-${suffix}', targetResourceId=VM resource ID, metricName='Percentage CPU', operator='LessThan', threshold=1, aggregation='Average', windowSize='PT15M', severity=0 (Critical), enabled=true, autoMitigate=false
- [ ] T094 [US5] Ensure no action groups configured (Portal-only notifications per MON-003)
- [ ] T095 [P] [US5] Add AVM module for Disk Space Alert (avm/res/insights/metric-alert:0.4.1) in main.bicep
- [ ] T096 [US5] Configure disk space alert: name='alert-disk-space-legacyvm-${suffix}', targetResourceId=VM resource ID, metricName='OS Disk Used Percentage', operator='GreaterThan', threshold=85, aggregation='Average', windowSize='PT5M', severity=0, enabled=true, autoMitigate=false
- [ ] T097 [P] [US5] Add AVM module for Key Vault Access Failure Alert (avm/res/insights/metric-alert:0.4.1) in main.bicep
- [ ] T098 [US5] Configure KV alert: name='alert-kv-access-fail-legacyvm-${suffix}', targetResourceId=Key Vault resource ID, metricName='ServiceApiHit', dimensions=[{name: 'ActivityName', operator: 'Include', values: ['SecretGet']}, {name: 'StatusCode', operator: 'Include', values: ['Unauthorized']}], operator='GreaterThan', threshold=0, aggregation='Count', windowSize='PT5M', severity=0
- [ ] T099 [US5] Review all existing resource modules: verify diagnostic settings already configured for VNet, VM, Storage, Key Vault, NSGs, NAT Gateway, Bastion (completed in previous phases)
- [ ] T100 [US5] Add alert outputs: alertVmStoppedName, alertDiskSpaceName, alertKvFailureName

### Deployment for User Story 5

- [ ] T101 [US5] Re-run validation: `bicep build`, `az deployment validate`, `what-if` analysis
- [ ] T102 [US5] Deploy updated template to test resource group
- [ ] T103 [US5] Verify Log Analytics workspace contains logs from all resources: run query in Azure Portal → Log Analytics → Logs → `AzureDiagnostics | where ResourceGroup == 'rg-legacyvm-test' | summarize count() by ResourceType`
- [ ] T104 [US5] Verify 3 metric alerts created and enabled in Azure Portal → Monitor → Alerts
- [ ] T105 [US5] Test VM stopped alert: Stop VM, wait 15 minutes, verify alert fires and visible in Portal
- [ ] T106 [US5] Test Key Vault access failure alert: Attempt to access non-existent secret `az keyvault secret show --name fake-secret --vault-name kv-legacyvm-{suffix}`, wait 5 minutes, verify alert fires
- [ ] T107 [US5] Verify alert notifications visible in Azure Portal → Monitor → Alerts (no external action groups configured)
- [ ] T108 [US5] Document alert testing procedures in infra/docs/deployment.md

**Checkpoint**: All 5 user stories complete - Full monitoring and alerting operational. MVP infrastructure complete!

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements and documentation that span multiple user stories

- [ ] T109 [P] Review main.bicep for code quality: verify all resources have comments explaining purpose
- [ ] T110 [P] Review main.bicepparam for documentation: verify parameter descriptions and defaults documented
- [ ] T111 [P] Validate constitution compliance: check all 6 principles satisfied (IC-001 to IC-006, SEC-001 to SEC-008)
- [ ] T112 [P] Run final validation suite: `bicep build`, `az deployment validate`, `what-if` analysis
- [ ] T113 Update infra/docs/deployment.md with full deployment outcomes and lessons learned
- [ ] T114 [P] Create architecture diagram in infra/docs/architecture.md showing all resources and dependencies
- [ ] T115 Verify all success criteria met (SC-001 to SC-011): deployment time <20 minutes, all resources operational, logs flowing, alerts working
- [ ] T116 Execute quickstart.md validation end-to-end: follow deployment guide steps, verify successful deployment
- [ ] T117 [P] Review Azure Security Center recommendations: address any high-severity compliance issues
- [ ] T118 Document estimated monthly costs in README.md: VM ~$70, Storage ~$50, Bastion ~$140, Other ~$10 = Total ~$270/month
- [ ] T119 Create CHANGELOG.md entry: document initial deployment date, version 1.0.0, all resources deployed
- [ ] T120 Final code review: verify no hardcoded values, all parameters in main.bicepparam, rich comments present

**Checkpoint**: Production-ready infrastructure complete. Ready for operational handoff.

---

## Dependencies & Execution Order

### Phase Dependencies

1. **Setup (Phase 1)**: No dependencies - start immediately
2. **Foundational (Phase 2)**: Depends on Setup - BLOCKS all user stories
3. **User Story 1 (Phase 3)**: Depends on Foundational - MVP foundation, MUST complete first
4. **User Story 2 (Phase 4)**: Depends on Foundational - Can proceed after US1 or in parallel
5. **User Story 3 (Phase 5)**: Depends on Foundational and US1 (VM must exist for Key Vault password reference) - Bastion depends on VNet from US1
6. **User Story 4 (Phase 6)**: Depends on Foundational and US1 (NAT Gateway and NSGs associate with VNet subnets from US1)
7. **User Story 5 (Phase 7)**: Depends on all previous user stories (alerts target VM, Key Vault; diagnostic settings reference Log Analytics from Foundational)
8. **Polish (Phase 8)**: Depends on all user stories complete

### User Story Interdependencies

- **US1 (Core VM)**: Independent after Foundational - can start first
- **US2 (Storage)**: Depends on US1 (data disk attaches to VM, private endpoint needs VNet)
- **US3 (Secure Access)**: Depends on US1 (Key Vault stores password for VM, Bastion accesses VM, both need VNet)
- **US4 (Network Security)**: Depends on US1 (NAT Gateway and NSGs associate with VNet subnets)
- **US5 (Monitoring)**: Depends on US1, US3 (alerts target VM and Key Vault resources)

### Recommended Execution Sequence

**Option 1 - Sequential by Priority** (single developer):
1. Setup → Foundational → US1 → US2 → US3 → US4 → US5 → Polish

**Option 2 - Parallel with Blocking** (team of 3):
1. Setup → Foundational
2. US1 (Developer 1)
3. After US1: US2 + US3 + US4 in parallel (Developers 1, 2, 3)
4. After US2/US3/US4: US5 (any developer)
5. Polish

### Validation Cadence

- Run `bicep build` after every file modification
- Run `az deployment validate` before every deployment
- Run `what-if` analysis before every deployment to test/production
- Test each user story independently after its deployment phase

### MVP Definition

**Minimum Viable Product = User Story 1 Complete**

At T032 completion, you have:
- Windows Server 2016 VM operational
- VNet with 3 subnets configured
- Basic infrastructure validated

This is sufficient to demonstrate foundational workload capabilities. Subsequent user stories add storage, secure access, network security, and monitoring incrementally.

---

## Parallel Execution Opportunities

### Tasks That Can Run in Parallel

**Phase 1 (Setup)**: T003, T004 can run in parallel with T002

**Phase 2 (Foundational)**: T009, T012 can run in parallel after T008

**Phase 3 (US1)**: T017, T020 can run in parallel (research different modules)

**Phase 4 (US2)**: T033, T034, T038, T040 can run in parallel (different module additions)

**Phase 5 (US3)**: T050, T055, T056 can run in parallel (Key Vault, Bastion, VM update)

**Phase 6 (US4)**: T068, T072, T076, T080 can run in parallel (NAT Gateway + 3 NSGs)

**Phase 7 (US5)**: T092, T095, T097 can run in parallel (3 independent alert modules)

**Phase 8 (Polish)**: T109, T110, T111, T114, T117, T118 can run in parallel (different file updates)

### Example Parallel Workflow (3 developers)

**Sprint 1 (Week 1)**:
- Dev 1: T001-T012 (Setup + Foundational)
- Dev 2: T003-T004 in parallel with Dev 1
- Dev 3: Start planning US2 tasks

**Sprint 2 (Week 2)**:
- Dev 1: T013-T032 (US1 - Core VM)
- Dev 2 + Dev 3: Prepare for US2/US3 parallel work

**Sprint 3 (Week 3)**:
- Dev 1: T033-T049 (US2 - Storage)
- Dev 2: T050-T067 (US3 - Secure Access)
- Dev 3: T068-T091 (US4 - Network Security)

**Sprint 4 (Week 4)**:
- Dev 1: T092-T108 (US5 - Monitoring)
- Dev 2 + Dev 3: T109-T120 (Polish) in parallel

**Total Duration**: ~4 weeks with 3 developers, or ~6 weeks sequential

---

## Implementation Strategy

### MVP-First Approach

1. **Deliver US1 first** (Phase 3: Core VM Infrastructure)
  - Provides foundational value: operational VM with networking
  - Independent testable increment
  - Validates Bicep template structure and AVM module usage

2. **Add US2 + US3** (Phase 4-5: Storage + Secure Access)
  - Provides secure operations capabilities
  - Data storage layer complete
  - Bastion access operational

3. **Add US4 + US5** (Phase 6-7: Network Security + Monitoring)
  - Production-grade security and observability
  - Complete infrastructure compliance

### Incremental Delivery Value

| Completion Point | Value Delivered | Can Deploy to Production? |
|------------------|-----------------|---------------------------|
| After US1 | Basic VM workload operational | No - missing security controls |
| After US1 + US3 | VM with secure access | No - missing storage and monitoring |
| After US1 + US2 + US3 | VM with storage and secure access | Maybe - basic functionality complete, but no monitoring |
| After US1-US4 | Full network security in place | Maybe - functionally complete, limited observability |
| After US1-US5 | Full monitoring and alerting | **YES** - production-ready |

### Rollback Strategy

- Each user story deployment is incremental - previous state preserved
- ARM deployment mode: Incremental (default) - only adds/updates resources
- Rollback: Redeploy previous version of main.bicep (if maintained in git)
- Nuclear option: Delete resource group and redeploy from scratch (acceptable for this single-RG workload)

---

## Task Validation Checklist

Before marking tasks.md as complete, verify:

- [ ] All 5 user stories from spec.md mapped to task phases
- [ ] Each user story has validation tasks (T013-T016 pattern for Bicep/ARM validation)
- [ ] Each user story has implementation tasks with AVM module references
- [ ] Each user story has deployment tasks with verification steps
- [ ] Each user story is independently testable (checkpoint verifications defined)
- [ ] All 16 functional requirements (FR-001 to FR-016) covered in tasks
- [ ] All 8 security requirements (SEC-001 to SEC-008) covered in tasks
- [ ] All 6 infrastructure constraints (IC-001 to IC-006) covered in tasks
- [ ] All 5 monitoring requirements (MON-001 to MON-005) covered in tasks
- [ ] Task IDs sequential (T001 to T120)
- [ ] Parallel tasks marked with [P]
- [ ] User story tasks marked with [US1] to [US5]
- [ ] File paths included in task descriptions
- [ ] Constitution validation tasks included (T111)
- [ ] Quickstart validation task included (T116)

**Total Tasks**: 120
**Estimated Duration**: 4-6 weeks (depending on team size and parallel execution)
