---
title: Validate Module Locally
description: Validate a Bicep Module Locally for the Azure Verified Modules (AVM) program
---

Install `Avm.Authoring` from MAR as described in the [prerequisites]({{% siteparam base %}}/contributing/bicep/prerequisites/). From the root of your Bicep registry checkout, set the module path and run:

```powershell
$modulePath = 'avm/res/<group>/<module>'
avm pre-commit -Ecosystem bicep -Path $modulePath
avm test unit -Ecosystem bicep -Path $modulePath -Recurse
```

`avm pre-commit` updates generated files. Review and commit those changes, then run `avm pr-check -Ecosystem bicep -Path $modulePath` with a clean working tree. `avm test unit` runs authored Pester tests; a missing suite is reported as skipped, not passed.

To list deployment examples without accessing Azure:

```powershell
avm test e2e -Ecosystem bicep -Path $modulePath -Recurse -List
```

To run deployment tests locally, use `avm test e2e` with an explicitly authorized test subscription and the inputs required by your module. The command can create, update and remove Azure resources. Azure PowerShell and Azure CLI must already be signed in to the same account, tenant, cloud and selected subscription. See the [command reference](https://github.com/Azure/azure-verified-modules-tools/blob/main/docs/reference/Invoke-AvmTestE2e.md) for required inputs, test selection and cleanup.

Local checks do not replace the [pull request checks]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#6-raise-or-update-pr). Microsoft FTEs can request E2E testing on their upstream PR with the `PR: Run E2E Tests` label. For external fork PRs, use the [release-branch handoff]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#running-e2e-for-external-contributions) only when E2E testing is needed.
