---
title: CI environment - Pipeline usage
---

This section provides a guideline on how to use the AVM CI environment pipelines.

---

## Operate the module pipelines

To validate updates to a module template, you can perform the following steps:

1. (Optionally) Update the module's test files to reflect your changes.
1. Push the local changes to the repository (using a branch that is not `main|master`).
1. Select the branch with your updated template.
1. (Optionally) disable the `Remove deployed module` input parameter in case you don't want to apply the default behavior and want to skip the deletion of the test-deployed resources to check them post-deployment.
1. Trigger the pipeline.

Once the pipeline concludes, it will either be in a green (success) or red (failed) state, depending on how the module performed.
Pipeline logs are available for troubleshooting and provide detailed information in case of failures. If errors occur in the [Static validation]({{% siteparam base %}}/contributing/bicep/ci-environment/static-validation/) phase, you may only see the failed test and need to `expand` the error message.

## Add a new module pipeline

To add a new module pipeline, we recommend to create a copy of a currently existing module pipeline and adjust all module-specific properties, e.g., triggers and module paths. The registration of the pipeline depends on the [DevOps platform](#devops-tool-specific-guidance) you're using.

## GitHub workflows

This section focuses on _GitHub_ Actions & Workflows.

### Trigger a workflow

To trigger a workflow in _GitHub_:

1. Navigate to the 'Actions' tab in your repository.

  ![Actions tab]({{% siteparam base %}}/images/bicep-ci/gh-actions-tab.png?width=400px)

1. Select the pipeline of your choice from the list on the left, followed by 'Run workflow' to the right. You can then select the branch of your choice and trigger the pipeline by clicking on the green 'Run workflow' button.

  ![Run workflow]({{% siteparam base %}}/images/bicep-ci/gh-trigger-pipeline.png?width=400px)

>**Note**: Depending on the pipeline you selected you may have additional input parameters you can provide aside from the branch. An outline can be found in the [Module pipeline inputs](./The%20CI%20environment%20-%20Pipeline%20design#module-pipeline-inputs) section.

### Register a workflow

To register a workflow in _GitHub_ you have to create the workflow file (`.yml`) and store it inside the `.github/workflows` folder.
> ***Note:*** Once merged to `main|master`, GitHub will automatically list the new workflow in the 'Actions' tab. Workflows are not registered from a branch unless you specify a temporal push trigger targeting your branch.
