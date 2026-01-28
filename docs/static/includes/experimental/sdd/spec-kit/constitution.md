<!-- markdownlint-disable -->
<!--
SYNC IMPACT REPORT
==================
Version Change: N/A → 1.0.0 (Initial constitution ratification)

Modified Principles:
- N/A (Initial version)

Added Sections:
- Core Principles (6 principles defined)
- Infrastructure Standards
- Security & Compliance Requirements
- Development Workflow
- Governance

Removed Sections:
- N/A (Initial version)

Templates Requiring Updates:
- ✅ plan-template.md: Constitution Check section aligns with principles
- ✅ spec-template.md: Requirements structure aligns with security principles
- ✅ tasks-template.md: Task categorization aligns with validation-first workflow

Follow-up TODOs:
- None (all placeholders filled)

Change Rationale:
- MAJOR version (1.0.0) because this is the initial constitution establishing governance framework
- Principles focused on legacy workload characteristics: compliance retention, IaC-first with Bicep, AVM-only modules, validation-before-deployment
-->

# Legacy Azure Workload Constitution

## Core Principles

### I. Infrastructure-as-Code First (NON-NEGOTIABLE)
All Azure resources MUST be defined in Bicep templates. Manual Azure Portal configurations are STRICTLY PROHIBITED.

**Rationale**: Ensures compliance auditability, repeatability, and version control for regulatory requirements. Manual changes create configuration drift that violates compliance mandates.

**Rules**:
- Every feature starts with Bicep code defining the infrastructure
- Custom scripts are permitted ONLY when Bicep/ARM capabilities are insufficient
- All infrastructure changes MUST go through version control
- Single-template approach: define everything in one main.bicep, let ARM handle dependencies

### II. AVM-Only Modules
All Bicep infrastructure MUST use Azure Verified Modules (AVM). Direct resource declarations are permitted only when no AVM module exists.

**Rationale**: AVM modules are officially maintained, follow security best practices, and are compliance-tested by Microsoft.

**Rules**:
- Search for AVM module first (using `#list_avm_metadata` tool)
- Use latest stable version of AVM modules
- Document justification when direct resource declaration is necessary
- Follow AVM module documentation for parameter configuration

### III. Validation Before Deployment (NON-NEGOTIABLE)
Every deployment MUST be preceded by ARM validation. Deployments without prior validation are STRICTLY PROHIBITED.

**Rationale**: Prevents configuration errors that could impact compliance-required systems. Validation catches issues before they affect production.

**Rules**:
- Run `az deployment group validate` before every deployment
- Run `az deployment group what-if` to preview changes
- Document validation results in deployment logs
- Address all validation errors before proceeding

### IV. Security & Reliability First
Security and reliability best practices MUST be followed under all circumstances, even for legacy workloads.

**Rationale**: Compliance requirements mandate security controls regardless of workload age. Legacy status does not exempt from security obligations.

**Rules**:
- Enable Azure Monitor and diagnostic logs for all resources
- Apply network security groups and private endpoints where applicable
- Use managed identities instead of connection strings/keys
- Follow principle of least privilege for all access
- Enable Azure Security Center recommendations

### V. Minimal Naming with Type Identification
Resource names MUST be concise: minimal random characters for uniqueness + resource type identifier.

**Rationale**: Improves resource identification while respecting Azure naming limitations. Avoids verbose names that exceed character limits.

**Rules**:
- Format: `{resourceType}-{purpose}-{randomSuffix}`
- Example: `st-legacyvm-k7m3p` for storage account
- Respect Azure resource-specific length limits (e.g., storage: 24 chars, lowercase/numbers only)
- Random suffix: 4-6 alphanumeric characters
- Document naming pattern in infrastructure documentation

### VI. Region Standardization
All resources MUST deploy to US West 3 (westus3) region unless technically impossible.

**Rationale**: Centralizes resources for simplified management and cost tracking. Reduces complexity for legacy workloads with no multi-region requirements.

**Rules**:
- Default region parameter: `westus3`
- Document exceptions with technical justification
- Global resources (e.g., Azure Front Door) exempted by nature

## Infrastructure Standards

### Bicep Template Requirements
- Single main.bicep file as deployment entry point
- Use main.bicepparam for environment-specific parameters
- Leverage ARM dependency management (avoid explicit dependsOn unless necessary)
- Include detailed parameter descriptions and constraints
- Use Bicep decorators for validation (`@minLength`, `@maxLength`, `@allowed`)

### Module Management
- Reference AVM modules via Bicep Registry (br/public:avm/...)
- Pin to specific module versions (never use 'latest')
- Document module selection rationale in comments
- Review AVM module documentation for breaking changes during updates

### Documentation Requirements
- Maintain README.md with deployment instructions
- Document all parameters in main.bicepparam
- Include architecture diagram showing resource relationships
- Record compliance justifications for resource configurations

## Security & Compliance Requirements

### Mandatory Controls
- **Logging**: Enable diagnostic settings for all resources supporting it
- **Access Control**: Use Azure RBAC, no shared keys in parameters
- **Network Security**: Apply NSGs to subnet/NIC resources
- **Encryption**: Use Azure-managed encryption (minimum); customer-managed keys where compliance requires
- **Secrets Management**: Store sensitive values in Azure Key Vault, reference via Bicep getSecret()

### Compliance Documentation
- Tag all resources with compliance identifiers (e.g., `compliance: "legacy-retention"`)
- Document retention policies for data resources
- Record security exceptions with business justification
- Maintain audit trail of all infrastructure changes

### Prohibited Practices
- Hardcoded secrets or connection strings in Bicep files
- Public IP addresses without business justification
- Unrestricted network access (0.0.0.0/0 rules)
- Disabled diagnostic logging

## Development Workflow

### Pre-Deployment Phase
1. Research and select appropriate AVM modules
2. Draft Bicep templates with parameter documentation
3. Run local Bicep linting (`bicep build`)
4. Commit code to version control

### Validation Phase (MANDATORY GATE)
1. Run `az deployment group validate` and resolve all errors
2. Run `az deployment group what-if` and review changes
3. Document validation results
4. Obtain approval for resource changes (if required by organization)

### Deployment Phase
1. Deploy using validated parameters
2. Monitor deployment progress
3. Verify resource creation via Azure Portal/CLI
4. Test resource functionality
5. Document deployment outcomes

### Post-Deployment Phase
1. Verify diagnostic settings are active
2. Confirm tags applied correctly
3. Review security recommendations in Azure Security Center
4. Update documentation with deployed resource details

## Governance

This constitution supersedes all other development practices and guidelines. All infrastructure changes MUST comply with these principles.

### Amendment Process
1. Propose amendment with business/technical justification
2. Document impact on existing infrastructure
3. Update constitution with version increment following semantic versioning
4. Update all dependent templates and documentation
5. Communicate changes to all stakeholders

### Versioning Policy
- **MAJOR**: Breaking changes to core principles (e.g., removing AVM-only requirement)
- **MINOR**: New principle added or existing principle materially expanded
- **PATCH**: Clarifications, wording improvements, non-semantic fixes

### Compliance Review
All pull requests MUST verify compliance with this constitution. Constitution violations require explicit justification and approval exception.

Complexity that deviates from simplicity principles MUST be documented and justified with business or technical rationale.

**Version**: 1.0.0 | **Ratified**: 2026-01-27 | **Last Amended**: 2026-01-27
