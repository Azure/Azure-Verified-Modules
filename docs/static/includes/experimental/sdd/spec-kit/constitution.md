<!--
SYNC IMPACT REPORT - Constitution v1.0.0
Generated: 2026-01-22

VERSION CHANGE: NEW → 1.0.0 (initial ratification)

PRINCIPLES DEFINED:
- I. AVM-Only Modules (new)
- II. Infrastructure-as-Code First (new)
- III. Security & Reliability (NON-NEGOTIABLE) (new)
- IV. Pre-Deployment Validation (new)
- V. Resource Naming & Regional Deployment (new)

SECTIONS ADDED:
- Technology Stack & Constraints
- Deployment Workflow

TEMPLATE STATUS:
- ✅ plan-template.md - reviewed, aligned with IaC single-template principle
- ✅ spec-template.md - reviewed, user stories support compliance scenarios
- ✅ tasks-template.md - reviewed, supports validation and deployment phases
- ⚠️ checklist-template.md - pending review for AVM/security checklist items
- ⚠️ agent-file-template.md - not reviewed (no file-specific guidance needed yet)

FOLLOW-UP TODOS:
- None - all required placeholders filled
-->

# Legacy Azure Workload Constitution

## Core Principles

### I. AVM-Only Modules
Every Azure resource MUST be deployed using an Azure Verified Module (AVM) from the official registry (`br/public:avm/...`).
- No custom Bicep resource declarations allowed unless AVM does not exist for that resource type
- Module versions MUST be pinned to specific semantic versions (no `latest` tags)
- Custom wrappers around AVM modules are permitted only when necessary for workload-specific logic
- Rationale: AVM modules are tested, validated, and follow Azure best practices; they ensure consistency, reduce maintenance burden, and provide compliance-ready configurations

### II. Infrastructure-as-Code First
All infrastructure MUST be defined in Bicep templates; custom scripts are permitted only when IaC cannot accomplish the requirement.
- Single main template defines all resources; ARM manages dependencies and deployment order automatically
- Bicep features (variables, parameters, outputs, conditionals, loops) MUST be used to avoid duplication
- Custom scripts (PowerShell, Azure CLI) allowed only for: post-deployment configuration not supported by ARM, data migration tasks, external system integrations
- All scripts MUST be idempotent and documented with clear pre-conditions and post-conditions
- Rationale: Declarative IaC ensures reproducibility, enables auditing for compliance, and leverages ARM's built-in dependency resolution; imperative scripts introduce brittleness and hidden state

### III. Security & Reliability (NON-NEGOTIABLE)
Security and reliability best practices MUST be followed under all circumstances.
- Managed identities MUST be used instead of service principals or keys wherever supported
- Network isolation via private endpoints and network security groups (NSGs) MUST be implemented for all data-plane resources
- Encryption at rest MUST be enabled using Azure-managed keys (customer-managed keys if compliance requires)
- Role-Based Access Control (RBAC) with least-privilege assignments MUST be applied to all resources
- Diagnostic settings MUST be configured to send logs to Log Analytics workspace or Storage Account
- Resource locks (CanNotDelete) MUST be applied to production resources to prevent accidental deletion
- Compliance: This is a legacy workload retained for compliance reasons; audit trails and security posture are mandatory
- Rationale: Non-compliance risks legal/regulatory penalties; security breaches on legacy systems are common attack vectors

### IV. Pre-Deployment Validation
Every deployment MUST be validated before execution; failed validations MUST block deployment.
- Run `az deployment group validate` or `New-AzResourceGroupDeployment -WhatIf` before every deployment
- Validation errors MUST be resolved before retrying
- What-If output MUST be reviewed to confirm expected changes (no unintended deletions or modifications)
- Integration tests (if available) MUST pass before production deployment
- Rationale: Legacy workloads are often undocumented; unvalidated changes risk breaking critical compliance-dependent functionality

### V. Resource Naming & Regional Deployment
Resource names MUST follow a minimal uniqueness convention; all resources MUST deploy to US West 3.
- Naming pattern: `<resource-type-abbreviation>-<workload>-<random-suffix>`
  - Example: `st-legacyapp-x7k9m` (storage account), `vm-legacyapp-x7k9m` (virtual machine)
  - Random suffix: minimum length to satisfy Azure global uniqueness (typically 5-6 alphanumeric chars)
  - Resource type abbreviations follow Azure CAF recommended abbreviations (https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- Character and length limits per Azure resource type MUST be respected (e.g., storage accounts: 3-24 lowercase alphanumeric only)
- Region: `westus3` for all resources unless resource type unavailable in that region (then document exception)
- Rationale: Legacy workloads need stable naming for troubleshooting; minimal randomness balances uniqueness with human readability; single region reduces complexity (HA/DR not required per user specification)

## Technology Stack & Constraints

**Language**: Bicep (latest stable version)
**Module Source**: Azure Verified Modules (AVM) via Microsoft Container Registry (`br/public:avm/...`)
**Deployment Tool**: Azure CLI (`az deployment group create`) or Azure PowerShell (`New-AzResourceGroupDeployment`)
**Target Region**: US West 3 (`westus3`)
**Compliance Requirements**: Audit logging, encryption at rest, RBAC least-privilege, resource locks
**Excluded Requirements**: High availability (HA), disaster recovery (DR), horizontal scalability, multi-region deployment
**Performance Goals**: Not applicable (legacy workload maintenance, no performance SLAs)
**Constraints**: Must retain for compliance; minimize operational cost; single-region acceptable; no active development

## Deployment Workflow

**Pre-Deployment**:
1. Author/update Bicep template using AVM modules
2. Pin module versions (no wildcards)
3. Run `az deployment group validate` or `New-AzResourceGroupDeployment -WhatIf`
4. Review What-If output for unintended changes
5. Obtain approval if production deployment

**Deployment**:
1. Execute `az deployment group create --template-file main.bicep --parameters main.parameters.json`
2. Monitor deployment progress; capture deployment outputs
3. Verify resource creation in Azure Portal or via CLI queries

**Post-Deployment**:
1. Validate diagnostic settings are active (logs flowing to Log Analytics)
2. Verify resource locks applied
3. Document deployment in compliance log (date, version, approver)
4. Update runbook or operational documentation if configuration changed

**Rollback**:
- Redeploy previous known-good Bicep template version
- ARM incremental mode by default; use complete mode only with extreme caution

## Governance

This constitution supersedes all other development practices and conventions for this project. Any deviation MUST be:
- Documented with explicit rationale (e.g., "AVM module unavailable for Resource Type X")
- Approved by compliance officer or designated approver
- Tracked as technical debt with remediation plan if applicable

All pull requests, code reviews, and deployments MUST verify compliance with these principles. Complexity introduced outside these principles MUST be justified or rejected.

Constitution amendments require:
1. Documented proposal with rationale for change
2. Approval from project stakeholders and compliance officer
3. Migration plan if existing resources/templates affected
4. Version increment per semantic versioning rules (see version history)

Compliance review cadence: Quarterly audit of deployed resources against constitution principles (manual checklist or automated policy scan).

**Version**: 1.0.0 | **Ratified**: 2026-01-22 | **Last Amended**: 2026-01-22
