When forking the BRM repository, all workflows from the CI environment are also part of your fork. In an earlier step it was explained, how to set them up correctly, to verify your module development.

Due to the trigger mechanism of the workflows, eventually all of them run at some point in time, creating and deleting resources on Azure in your environment. That will also happen for modules, you are not working on. This will create costs in your own subscription and it can also create a queue for workflow runs, due to the lack of enough free agents.

To limit those workflow runs, you can manually disable each pipeline you do not want to run. As this is a time consuming task, there is script in the BRM repository, to disable (or enable) pipelines in a batch process, that can also be run via a workflow. You can also use RegEx to specify which pipelines should be included and which should be excluded.

---

### _Navigation_

- [Location](#location)
- [How it works](#how-it-works)
- [Typical use cases](#typical-use-cases)
  - [Disable all but one workflow](#disable-all-but-one-workflow)
  - [Disable all but multiple workflows](#disable-all-but-multiple-workflows)
  - [Enable all workflows](#enable-all-workflows)
- [Limitations](#limitations)

---
# Location

You can find the script under [`avm/utilities/pipelines/platform/Switch-WorkflowState.ps1)`](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utilities/pipelines/platform/Switch-WorkflowState.ps1)
You can find the workflow under [`.github/workflows/platform.toggle-avm-workflows.yml`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/platform.toggle-avm-workflows.yml)

# How it works

Browse to `Actions` and select the workflow from the list

<img src="../../../../img/contribution/selectToggleWorkflows.png" alt="Select Toggle Workflows" width=50%>

Run the workflow `platform.toggle-avm-workflows` and set the following settings:
- `Enable or disable workflows` to enable or disable workflows
- `RegEx which workflows are included` include a specific set of workflows, using a RegEx.
- `RegEx which workflows are excluded` exclude a specific set of workflows, using a RegEx.

<img src="../../../../img/contribution/runToggleWorkflows.png" alt="Run Toggle Workflows" width=50%>

# Typical use cases

## Disable all but one workflow
- `Enable or disable workflows` to `Disable`
- `RegEx which workflows are included` to `avm\.(?:res|ptn)` (this is the default setting)
- `RegEx which workflows are excluded` to `avm.res.compute.virtual-machine` (use the name of your own workflow. This example uses the workflow for virtual machine)

## Disable all but multiple workflows
- `Enable or disable workflows` to `Disable`
- `RegEx which workflows are included` to `avm\.(?:res|ptn)` (this is the default setting)
- `RegEx which workflows are excluded` to `(?:avm.res.compute.virtual-machine|avm.res.compute.image|avm.res.compute.disk)` (use the names of your own workflows. This example uses the workflows for virtual machine, image, and disk)

## Enable all workflows
- `Enable or disable workflows` to `Enable`
- `RegEx which workflows are included` to `avm\.(?:res|ptn)` (this is the default setting)
- `RegEx which workflows are excluded` to `^$` (this is the default setting)

# Limitations

Please keep in mind, that the workflow run disables all workflows that match the RegEx at that point in time. If you sync your fork with the original repository and new workflows are there, they will be synced to your repository and will be enabled by default. So you will need to run the workflow to disable the new ones again after the sync.

{{< hint type=important >}}

The workflow can only be triggered in forks.

{{< /hint >}}
