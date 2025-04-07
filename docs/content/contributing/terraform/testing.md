---
title: Terraform Module Testing
linktitle: Testing
description: The Terraform Module Testing Framework
---

When you author your Azure Verified Module (AVM) Terraform module, you should ensure that it is well tested.
This document outlines the testing framework and tools that are used to test AVM Terraform modules.

## Testing Framework Composition

For Terraform modules, we use the following tools:

Mandatory tooling:

- [avmfix](https://github.com/lonegunmanb/avmfix) for advanced formatting
- [Conftest](https://www.conftest.dev/), and Open Policy Agent (OPA) for well architected compliance
- [grept](https://github.com/Azure/grept) (Go REPository linTer) for repository contents
- [terraform-docs] for documentation generation
- [TFLint](https://github.com/terraform-linters/tflint) for spec compliance

Optional tooling:

- [terraform test](https://developer.hashicorp.com/terraform/tutorials/configuration-language/test) for unit testing

## Before Submitting a Pull Request

Before you submit a pull request to your module, you should ensure that the following checks are passed.
You can run the linting tools locally by running the following command:

### Linux / MacOS / WSL

```bash
./avm pre-commit
./avm pr-check
```

### Windows

```powershell
.\avm.bat pre-commit
.\avm.bat pr-check
```

Doing so will shorten the development cycle and ensure that your module is compliant with the AVM specifications.

## GitHub Actions and Pull Requests

We centrally manage the test workflows for your Terraform modules.
We also provide a test environment (Azure Subscription) as part of the testing framework.

### Linting

The `linting.yml` workflow in your repo (`.github/workflows/linting.yml`) is responsible for static analysis of your module.
It will run the following centralized tests:

- [`avmfix`](https://github.com/Azure/terraform-azurerm-avm-template/blob/main/.github/actions/avmfix/action.yml) to ensure that your module is formatted correctly.
- [`terraform-docs`](https://github.com/Azure/terraform-azurerm-avm-template/blob/main/.github/actions/docs-check/action.yml) to ensure that your module documentation is up to date.
- [`TFLint`](https://github.com/Azure/terraform-azurerm-avm-template/blob/main/.github/actions/linting/action.yml) to ensure that your module is compliant with the AVM specifications.

### End-to-end testing

The `e2e.yml` workflow in your repo (`.github/workflows/e2e.yml`) is responsible for end-to-end testing of your module examples.
It will run the following centralized test workflow: <https://github.com/Azure/terraform-azurerm-avm-template/blob/main/.github/workflows/test-examples-template.yml>.

It will run the following tasks:

- List all the module examples in the `examples` directory.
- Conftest will check the plan for compliance with the well-architected framework using OPA.
- Your example will be tested for idempotency by running `terraform apply` and then `terraform plan` again.
- Your example will be destroyed by running `terraform destroy`.

Currently it is not possible to run the end-to-end tests locally, however you can run `terraform apply` and `terraform destroy` commands locally to test your module examples.

## OPA (Open Policy Agent) & Conftest

Conftest is the first step in the AVM end-to-end testing framework.
It will check the plan for compliance with the well-architected framework using OPA.
The policies that we use are available here: <https://github.com/Azure/policy-library-avm>.

If you get failures, you should example them to understand how you can make your example compliant with the well-architected framework.

### Creating exceptions

In some circumstances, you may need to create an exception for a policy, you can do so by creating a `.rego` file in the `exceptions` sub-directory of your example.
For example, to exclude the rule called `"configure_aks_default_node_pool_zones"`, create a file called `exceptions/exception.rego` in your example, with the following content:

```rego
package Azure_Proactive_Resiliency_Library_v2
import rego.v1
exception contains rules if {
  rules = ["configure_aks_default_node_pool_zones"]
}
```

## TFLint

TFLint is used to check tat your module is compliant with the AVM specifications.
We use a custom ruleset for TFLint to check for AVM compliance: <https://github.com/Azure/tflint-ruleset-avm>.

### Excluding rules

If you need to exclude a rule from TFLint, you can do so by creating one of the following in the root of your module:

- `avm.tflint.override.hcl` - to override the rules for the root module
- `avm.tflint.override_module.hcl` - to override the rules for submodules
- `avm.tflint.override_example.hcl` - to override the rules for examples

These files are HCL files that contain the rules that you want to override.
Here is some example syntax:

```hcl
# Disable the required resource id output rule as this is a pattern module and it does not make sense here.
rule "required_output_rmfr7" {
  enabled = false
}
```

Please include a comment in the file explaining why you are disabling the rule.

## Excluding examples from end-to-end testing

If you have examples that you do not want to be tested, you can exclude them by creating a file called `.e2eignore` in the example directory.
The contents of the file should explain why the example is excluded from testing.

## Grept and the `chore: repository governance` pull requests

We run a weekly workflow that checks the contents of your module and creates a pull request if it finds any issues.
If you see a pull request with the title `chore: repository governance`, it means that the workflow has found some issues with your module, so please check the pull request and merge it to ensure you are compliant.
