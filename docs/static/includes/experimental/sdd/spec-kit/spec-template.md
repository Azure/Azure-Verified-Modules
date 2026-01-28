# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`
**Created**: [DATE]
**Status**: Draft
**Input**: User description: "$ARGUMENTS"

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

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: Infrastructure MUST [specific Azure resource capability, e.g., "provision Virtual Machine with managed disks"]
- **FR-002**: Infrastructure MUST [security requirement, e.g., "enable diagnostic logging for all resources"]
- **FR-003**: Infrastructure MUST [networking requirement, e.g., "isolate resources in dedicated VNet"]
- **FR-004**: Infrastructure MUST [data requirement, e.g., "provide storage account with blob containers"]
- **FR-005**: Infrastructure MUST [compliance requirement, e.g., "tag all resources with compliance identifiers"]

*Example of marking unclear requirements:*

- **FR-006**: Infrastructure MUST provide [NEEDS CLARIFICATION: VM size not specified - what compute requirements?]
- **FR-007**: Infrastructure MUST retain logs for [NEEDS CLARIFICATION: retention period not specified]

### Security & Compliance Requirements (Mandatory for all features)

- **SEC-001**: All resources MUST enable diagnostic settings and send logs to Log Analytics Workspace
- **SEC-002**: All resources MUST use managed identities for authentication (no connection strings/keys)
- **SEC-003**: Network resources MUST apply Network Security Groups with least-privilege rules
- **SEC-004**: All resources MUST be tagged with compliance identifiers
- **SEC-005**: Sensitive configuration MUST be stored in Azure Key Vault and referenced via Bicep

### Infrastructure Constraints

- **IC-001**: MUST deploy to westus3 region (US West 3)
- **IC-002**: MUST use Azure Verified Modules (AVM) exclusively (document exceptions)
- **IC-003**: MUST validate deployment with `az deployment group validate` before applying
- **IC-004**: MUST run `az deployment group what-if` to preview changes
- **IC-005**: Resource names MUST follow pattern: {resourceType}-{purpose}-{random4-6chars}

### Key Azure Resources *(include if feature involves infrastructure)*

- **[Resource 1]**: [Azure resource type, purpose, key configuration requirements]
- **[Resource 2]**: [Azure resource type, relationships to other resources, dependencies]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Deployment metric, e.g., "Infrastructure deploys successfully within 15 minutes"]
- **SC-002**: [Validation metric, e.g., "ARM validation passes without errors"]
- **SC-003**: [Security metric, e.g., "All resources pass Azure Security Center compliance checks"]
- **SC-004**: [Operational metric, e.g., "Diagnostic logs available in Log Analytics within 5 minutes of deployment"]
