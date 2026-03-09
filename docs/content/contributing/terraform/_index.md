---
title: Terraform Contribution Guide
linktitle: Terraform Modules
description: Terraform Contribution Guidance for the Azure Verified Modules (AVM) program
---


{{% notice style="important" %}}
While this page describes and summarizes important aspects of contributing to AVM, it only references _some_ of the shared and language specific requirements.

Therefore, this contribution guide **MUST** be used in conjunction with the [Terraform specifications]({{% siteparam base %}}/specs/tf/). **ALL AVM modules** (Resource and Pattern modules) **MUST meet the respective requirements described in these specifications**!
{{% /notice %}}

## Summary

This section lists AVM's Terraform-specific contribution guidance.

- [Prerequisites]({{% siteparam base %}}/contributing/terraform/prerequisites/) — tooling and access requirements
- [Contribution Flow]({{% siteparam base %}}/contributing/terraform/contribution-flow/) — end-to-end guide for owners and contributors (includes testing)
- [Composition]({{% siteparam base %}}/contributing/terraform/composition/) — module structure, code styling, interfaces
- [Review]({{% siteparam base %}}/contributing/terraform/review/) — module review process before publishing
- [Advanced Topics & FAQ]({{% siteparam base %}}/contributing/terraform/advanced/) — custom subscriptions, OPA exceptions, TFLint overrides
- [Repository Setup]({{% siteparam base %}}/contributing/terraform/repository-setup/) — creating a new module repository (owners only)
