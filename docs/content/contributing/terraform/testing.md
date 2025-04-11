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
- [terraform-docs](https://terraform-docs.io/) for documentation generation
- [TFLint](https://github.com/terraform-linters/tflint) for spec compliance

Optional tooling:

- [terraform test](https://developer.hashicorp.com/terraform/tutorials/configuration-language/test) for unit testing

## Before Submitting a Pull Request

Before you submit a pull request to your module, you should ensure that the following checks are passed.
You can run the linting tools locally by running the following command:

### Prerequisites

You need to have the following tools installed:

- A container runtime - you can use [Docker Desktop](https://www.docker.com/products/docker-desktop) or [Podman](https://podman-desktop.io/downloads)

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

If you get failures, you should examine them to understand how you can make your example compliant with the well-architected framework.

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

TFLint is used to check that your module is compliant with the AVM specifications.
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

## Global test setup and teardown

Some modules require a global setup and teardown to be run before and after ALL examples.
We provide a way to do this by creating a file called `examples/setup.sh` in the root of your module.
This script will be run before all examples are tested, and will be authorized with the same credentials as the examples.

You can optionally supply a teardown script that will be run after all examples are tested.
This should be called `examples/teardown.sh`.

## Pre and post scripts per-example

Some examples require pre and post commands that are specific to that example.
Use cases here can be to modify the example files to ensure unique names or to run some commands before or after the example is tested.

You can do this by creating a file called `examples/example_name/pre.sh` in the example directory.
This script will be run before the example is tested, and will be authorized with the same credentials as the example.
You can optionally supply a post script that will be run after the example is tested.
This should be called `examples/example_name/post.sh`.

The pre and post scripts are run in the context of the example directory, so you can use relative paths to access files.

## Grept and the `chore: repository governance` pull requests

We run a weekly workflow that checks the contents of your module and creates a pull request if it finds any issues.
If you see a pull request with the title `chore: repository governance`, it means that the workflow has found some issues with your module, so please check the pull request and merge it to ensure you are compliant.

You do not need to release a new version of your module when you merge these pull requests, as they do not change the module code.

## Overriding the default test subscription (using a different Azure environment)

If your module deploys resource that are not compatible with the default test subscription, you can override these defaults by setting additional environment secrets in your GitHub repository.

You might need to do this if:

- The resources you are deploying are constrained by quota or subscription limits.
- You need to deploy resources at scopes higher than subscription level (e.g. management group or tenant).

To override the Azure environment, you can specify the environment in your module's configuration or set the following environment variables in your GitHub repository settings:

1. Create a user-assigned managed identity in the Azure environment you want to use.
1. Create GitHub federated credentials for the user-assigned managed identity in the Azure environment you want to use, using the github organization and repository of your module. Select entity type 'environment' and add `test` for the name.
1. Create appropriate role assignments for the user-assigned managed identity in the Azure environment you want to use.
1. Now, elevate you access to administrator by going to the open source portal: <https://repos.opensource.microsoft.com/orgs/Azure/repos/REPOSITORY-NAME/jit>.
1. Then, go to the settings of your GitHub repository and select environments.
1. Select the `test` environment.
1. Add the following secrets:
    - `ARM_CLIENT_ID_OVERRIDE` - The client ID of the user-assigned managed identity.
    - `ARM_TENANT_ID_OVERRIDE` - The tenant ID of the user-assigned managed identity.
    - `ARM_SUBSCRIPTION_ID_OVERRIDE` - The subscription ID you want to use for the tests.

## Terraform Test (Optional)

Authors may choose to use terraform test to run unit and integration tests on their modules.

###  Unit tests

Test files should be placed in the `tests/unit` directory.
They can be run using the following command:

```bash
./avm unit-test
```

Authors SHOULD use unit tests with [mocked providers](https://developer.hashicorp.com/terraform/language/tests/mocking).
This ensures that the tests are fast and do not require any external dependencies.

### Integration tests

Integration tests should be placed in the `tests/integration` directory.
They can be run using the following command:

```bash
./avm integration-test
```

Integration tests should deploy real resources and should be run against a real Azure subscription.
However, they are not fully integrated into the AVM GitHub Actions workflows.
Authors should run integration tests locally and ensure that they are passing but they will not be run automatically in the CI/CD pipeline.
