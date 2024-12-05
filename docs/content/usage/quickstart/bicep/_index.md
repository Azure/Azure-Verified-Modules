---
title: Bicep Quickstart
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

  <!-- - how do I explore what modules are there?
  - what are the built-in features of the key-vault module
  - UDTs
  - intellisense
  - explore the source of the kv module without leaving VS code
  - how can I see the readme of the kv module from vs code
  - what if there's a missing feature? --> file a module issue -->

To deploy an AVM Bicep module from the Bicep Public Registry, you'll need a few things:

- VS Code and [Bicep Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to author your Bicep template and explore modules published in the registry
- PowerShell or Azure CLI to deploy your Bicep template
- An Azure subscription to deploy your Bicep template

For more details, see the the below example steps.


1. In VS Code, create a new file with the `.bicep` extension - typically named `main.bicep`.
1. Type `module`, then give your module a symbolic name, such as `myTestModule`.
1. Hit `SPACE` then `CTRL+Tab` for the module source list to show up. Select `br/public`.
1. You'll see a list of modules published in the Bicep Public Registry. Use this to explore the published modules.
        {{< hint type=note >}}
The Bicep VSCode extension is reading metadata through [this JSON file](https://live-data.bicep.azure.com/module-index). All modules are added to this file, as part of the publication process. This lists all the modules marked as Published or Orphaned on the [AVM Bicep module index pages](https://aka.ms/AVM/ModuleIndex/Bicep).
    {{< /hint >}}

1. Select the module you want to use and the version you want to deploy.
1. Hover over the module name to see the module's documentation URL.
1. Click on the link to see the module's documentation online.
1. Explore the module's documentation for usage examples and to understand its functionality, input parameters, and outputs.
1. Set the required properties for the module. You can use the documentation URL to see the module's documentation online.

1. Save your `main.bicep` file.
1. Deploy your Bicep template using PowerShell or Azure CLI.
1. Monitor and verify the deployment in the Azure portal or in the terminal you launched it using PowerShell / CLI.
1. Clean up the resources you deployed.
1. Share your feedback with the AVM team and contribute to the AVM Bicep modules.

### Screenshots to be retaken

1. When authoring a new Bicep file, use the [VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to explore the modules published in the Bicep Public Registry.
<img src="../../../img/quickstart/bicep/use-bicep-module-01.png" width=100% alt="Select br/public:">

2. Expanding on this you can see the AVM modules that are published.
<img src="../../../img/quickstart/bicep/use-bicep-module-02.png" width=100% alt="Select module from the Public Bicep Registry">

3. Selecting the module expands on the current available versions.
<img src="../../../img/quickstart/bicep/use-bicep-module-03.png" width=100% alt="Choose from the available versions">

4. Setting required properties exposes what is required on the module.
<img src="../../../img/quickstart/bicep/use-bicep-module-04.png" width=100% alt="Select required-properties">

5. Hovering over the `myTestModule` name exposes the module's documentation URL.
<img src="../../../img/quickstart/bicep/use-bicep-module-05.png" width=100% alt="Hover over the module name">

6. Clicking on the link opens up the Bicep Registry Repo for the AVM module's source code, where you can find the documentation detailing all the module's functionality, input parameters and outputs, while providing various examples.
<img src="../../../img/quickstart/bicep/use-bicep-module-06.png" width=100% alt="See the module's documentation online">
