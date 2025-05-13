---
title: Concepts
linktitle: Concepts
type: default
weight: 2
description: Technical decisions and concepts for the Usage Guidance of Azure Verified Modules (AVM)
---

{{% notice style="note" %}}

This page is a work in progress and will be updated as we improve & finalize the content. Please check back regularly for updates.

{{% /notice %}}

When developing an Azure solution using AVM modules, there are several aspects to consider. This page covers important concepts and provides guidance the technical decisions. Each concept/topic referenced here will be further detailed in the corresponding Bicep or Terraform specific guidance.

## Language-agnostic concepts

Topics/concepts that are relevant and applicable for both Bicep and Terraform.

### Module Sourcing

#### Public Registry

Leveraging the public registries (i.e., the Bicep Public Registry or the Terraform Public Registry) is the most common and recommended approach.

This allows you to leverage the latest and greatest features of the AVM modules, as well as the latest security updates. While there aren't any prerequisites for using the public registry - no extra software component or service needs to be installed and no configuration is needed - the client machine the deployment is initiated from will need to have access to the public registry.

#### Private Registry (synced)

A private registry - that is hosted in your own environment - can store modules originating from the public registry. Using a private registry still grants you the latest version of AVM modules while allowing you to review each version of each module before admitting them to your private registry. You also have control over who can access your own private registry. Note that using a private registry means that you're still using each module as is, without making any changes.

#### Inner-sourcing

Inner-sourcing AVM means maintaining your own, synchronized copy of AVM modules in your own internal private registry, repositories or other storage option. Customers normally look to inner-source AVM modules when they have strict security and compliance requirements, or when they want to publish their own lightly wrapped versions of the modules to meet their specific needs; for example changing some allowed or default values for parameter or variable inputs.

This is a more complex approach and requires more effort to maintain, but it can be beneficial in certain scenarios, however, it should not be the default approach as it can lead to a lot of overhead and maintenance and requires significant skills and resources to set up and maintain.

There are many ways to approach inner-sourcing AVM modules for both Bicep and Terraform. The AVM team will be publishing guidance on this topic, based on customer experience and learnings.

{{% notice style="tip" %}}

You can see the AVM team talking about inner-sourcing on the AVM February 2025 community call on [YouTube](https://youtu.be/M2dJetgK2U8?si=R0QmasBUDM0Acs9L).

{{% /notice %}}


<!-- ## Bicep-specific concepts

### Orchestration options

To build and deploy an Azure solution (i.e., application/workload/accelerator/etc.) using AVM modules, you need to decide what technique you'd like leverage to orchestrate your deployments. The choice of orchestration method will depend on your specific requirements and the complexity of your deployment.

Generally speaking, there are two main orchestration options:

- Template orchestration - using a **solution template** to reference AVM modules
- Pipeline orchestration - using a **solution workflow** with multiple steps in a CI/CD pipeline to reference AVM modules (one module per step)

#### Template orchestration

Template orchestration references individual AVM modules from a "solution template" ("main" template) while using the capabilities of this template to pass parameters and orchestrate the deployment of each individual module. By default, deployments are run in parallel by the Azure Resource Manager, while accounting for all dependencies defined. When using this approach in a DevOps environment, the deployment CI/CD pipeline only needs a single deployment job.

This is the most common approach and is recommended for most scenarios. It allows you to define your entire solution in a single template, which can be easily versioned and reused. Template orchestration is typically used for mid-size deployments or when you want to deploy a single solution.

Note: in an enterprise environment, template orchestrated deployments should be performed from CI/CD pipelines.

![TemplateOrchestration]({{% siteparam base %}}/images/usage/concepts/templateOrchestration.png?height=300px "Template Orchestration")

##### Advantages of template orchestration

- The deployment of resources in parallel is handled by Azure which means it is generally faster
- Passing information in between resource deployments is handled inside a single deployment
- The pipeline remains relatively simple as most complexity is handled by the resource template

##### Disadvantages of template orchestration

- As per Azure [template limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#template-limits), the compiled (i.e., ARM/JSON) resource template file size may not exceed 4 MB in size. This limitation is more likely to be encountered in a template orchestrated approach, in case of a more complex solution, leveraging many AVM modules. Note: this limitation doesn't apply to Terraform.
- As per Azure [template limits](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#template-limits), it is not possible to perform more than 800 deployments using a single template. This limitation is more likely to be encountered in a template orchestrated approach, in case of a more complex solution, leveraging many AVM modules. Note: this limitation doesn't apply to Terraform.
- Some application and data layer configurations cannot be done through template orchestration without workarounds, e.g., uploading files, creating Entra ID (AAD) objects, etc.. Note: some of these limitations don't apply to Terraform.
- The deploying context (user or service principal) must have permissions of all resource deployments that are defined in the solution template.

#### Pipeline orchestration

Pipeline orchestration allows you to "solution workflow" that uses platform specific pipeline capabilities (e.g., GitHub workflows, Azure DevOps pipelines) to provision individual modules, where each job deploys one module. By defining dependencies in between jobs you can make sure your resources are deployed in order. Parallelization is achieved by using a pool of pipeline agents (runners) that run the jobs, while accounting for all dependencies defined.

This approach is more complex and is typically used for larger deployments. Pipeline orchestration allows you to define your entire deployment process in a single pipeline, with more granularity and control (approvals and RBAC).

![PipelineOrchestration]({{% siteparam base %}}/images/usage/concepts/pipelineOrchestration.png?height=400px "Pipeline Orchestration")

##### Advantages of pipeline orchestration

- The deployment of an individual resource is very simple
- Most CI/CD systems provide you with a visual representation of the deployment flow
- If a deployment fails, you can re-run it independently
- Splitting your solution workflow into individual jobs makes the solution easier to troubleshoot
- Different deployment jobs can use different principals, resulting in a more granular permission model

##### Disadvantages of pipeline orchestration

- Each deployment needs its own job, and therefore, its own agent. As a consequence, parallel resource deployments require multiple agents.
- Passing information from one deployment to another requires passing information from one agent to another.
- As each agent job has to start up and check out the code first, it generally runs slower than native, template-orchestrated deployments.

Note: pipeline orchestrated deployments are not to be confused with the inner workings of CI/CD pipelines. -->
<!--
---

## DevOps and Workflow

### Automated Testing (pre-flight tests, what-if; post-deployment tests)

### Multi-environment configurations (dev/test/prod)

### Multi-environment governance

### Integrated Security and Code scanning

---

## Technology and Tooling

### Bicep

#### Traditional deployments vs. Deployment Stacks

#### Referencing template specs

In the inner-sourcing scenario, you can leverage Template specs as an alternative to setting up your own private registry. A [Template Spec](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-specs?tabs=azure-powershell) is an Azure resource with the purpose of storing & referencing Azure Resource Manager (ARM) templates. When publishing Bicep modules as Template Specs, the module is compiled - and the resulting ARM template is uploaded as a Template Spec resource version to a Resource Group of your choice. As Bicep supports the Template-Specs as linked templates, this approach enables you to fully utilize Azure's parallel deployment capabilities. Even though the published resource is an ARM template, you can reference it in you Bicep template as a remote module like it would be native Bicep.

#### Azure Deployment Environments (and integration)

### Terraform

#### Deployment / Service Catalog

#### Terraform Enterprise/Terraform Cloud/Terraform Workspaces -->
