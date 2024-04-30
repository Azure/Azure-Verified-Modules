---
title: Contribution Q&A
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true

geekdocToC: 1
---

{{< toc >}}

{{< hint type=tip >}}

Check out the [FAQ](/Azure-Verified-Modules/faq/) for more answers to common questions about the AVM initiative in general.

{{< /hint >}}

## Proposing a module

---

### Who can propose a new module and where can I submit a new module proposal / request?

**Everyone can propose a module**

To propose a new module, simply create an issue/complete the form [here][ModuleProposal].

---

### Can I just propose / create any module?

**For example, can I propose one for managed disks or NICs or diagnostic settings? What about patterns?**

No, you cannot propose or create just any module. You can only propose modules that are aligned with requirements documented in the [module specifications][ModuleSpecifications] section.

Below, we provide some guidance on what modules you can / cannot propose.

- **Resource modules**: resource modules have bring extra value to the end user (can't just be simple wrappers) and **MUST** mapped 1:1 to RPs (resource providers) and top level resources. You **MUST** follow the [module specifications][ModuleSpecifications] and your modules **SHOULD** be [WAF aligned][WAFAligned].
  - Good examples:
    - Virtual machine: the VM module is highly complex and therefore, it brings extra value to the end user by providing a wide variety of features (e.g., diagnostics, RBAC, domain join, disk encryption, backup and more).
    - Storage account: even though, this module is mainly built around one RP, it brings extra value by providing easy access to its child resources, such as file/table/queue services, as well as additional standard interfaces (e.g., diagnostics, RBAC, encryption, firewall, etc.).
  - Bad examples:
    - NIC or Public IP (PIP) module: these would be simple wrappers around the NIC/PIP resource and wouldn't bring any extra value. NICs and PIPs **SHOULD** be surfaced as part of the VM module (or any other primary resources that require them).
    - Diagnostic settings: these are too low-level "sub resources", and highly dependent on their "primary resource's" RP defined as "interfaces" and therefore **MUST** be used as part of a resource module holding a primary resource - see [Diagnostic Settings][DiagnosticSettings] documentation about the correct implementation.

- **Pattern modules**: In case of pattern modules, ideally you should start from architectural patterns, published in the [Azure Architecture Center][AzureArchitectureCenter], and build your pattern module by leveraging resource modules that are required to implement the pattern. AVM does not provide architectural guidance on how you should design your pattern, but you **MUST** follow the module specifications and your modules **SHOULD** be [WAF aligned][WAFAligned].
  - Good examples:
    - Landing zone accelerators for N-tier web application; AKS cluster; SAP: there are numerous examples for these architectures in Azure Architecture Center that already have baked in guidance / smart defaults that are WAF Aligned, therefore these are good candidates for pattern modules. Module owners **MAY** leverage resource modules to implement the pattern.
    - Hub and spoke topology: it's a common pattern that is used by many customers and there are great examples available through Azure Architecture Center, as well as [Azure Landing Zones][ALZ]. Also a good candidate for a pattern module.
  - Bad examples:
    - A pair of Virtual machines: being a simple wrapper, this solution wouldn't bring any extra value as it doesn't provide a complete solution.
    - Key Vault that deploys automatically generated secrets: this is aligned with the definition of a resource modules, therefore it should be categorized as such.

---

### Where do I need to go to make sure the module I'd like to propose is not already in the works?

The [AVM core team][AVMCoreTeam] maintains the list of [Bicep][BicepModules] and [Terraform][TFModules] modules and tracks the status of each module. Based on this list, you can check if the module you'd like to build is already in the works (e.g., it's being worked on in a feature branch but hasn't been published yet).

To see the formatted lists with additional information, please visit the [AVM Module Indexes][ModuleIndexes] page.

---

### I need a new module but I cannot own/author it for various reasons, what should I do?

Each AVM module requires a [module owner][ModuleOwners] and **MAY** have additional [module contributors][ModuleContributors].

Essentially, you have 3 options:

1. You sign up to be a module owner (and optionally, you can find additional contributors to help you).
2. You find / request someone else to be the module owner (and optionally, you can be a contributor).
3. You propose a module and wait until the AVM core team finds a module owner for you (who then can optionally leverage the help of additional contributors).

As these options are increasingly more time consuming, we recommend you to start with considering option 1 and only if you cannot own the module, should you move to option 2 and then 3.

You can propose a new module [here][ModuleProposal].

---

### How long will it take for someone to respond and a module to be created/updated and published?

While there are SLAs defined for providing [support][ModuleSupport] for existing modules, there are currently no SLAs in place for the creation of new modules. The AVM core team is a small team and is currently working on automating the module creation process to make it as easy as possible for module owners to create and publish modules on their own.

Beside of providing program level governance, the [AVM core team][AVMCoreTeam] is mainly responsible for defining the module specifications, providing tooling (such as test frameworks and pipelines), guidance and support to module owners, as well as facilitating the creation of new modules by maintaining the module catalog and identifying volunteers for owning the modules. However, modules will be created and maintained by a broader community of [module owners][ModuleOwners].

---

### How do I let the AVM team know I really need an AVM module to unblock me / my project / my company?

- If you're an external user, you can propose a module [here][ModuleProposal] and provide as much context as possible under the "Module Details" section (e.g., why do you need the module, what's the business impact of not having it, etc.).

- If you're a Microsoft employee and have already proposed a module [here][ModuleProposal], you can reach out to the AVM core team directly via [Teams][AVMChannel] to provide more details internally.

The AVM core team will then triage the request and get back to you with next steps. You can accelerate the process of creating the module by volunteering to be a [module owner][ModuleOwners].

<!-- ### How will the AVM module index (catalog) be updated?

The [AVM core team][AVMCoreTeam] will maintain the module catalog and update it as new modules are created and published or existing ones are updated or retired. -->

<br>

## Developing a module

---

### Who is developing a modules?

Every module has an owner that is responsible for module development and maintenance. One owner can own one or multiple modules. An owner can develop modules alone or lead a team that will develop a module.
If you want to join a team and to contribute on specific module, please contact module owner.

At this moment, only Microsoft FTEs can be module owners.

---

### What do I need so I can start developing a module?

We suggest that you review [module specification][ModuleSpecifications] and [contribution guides][ModuleContributors]:

- [Bicep contribution guide][BicepContributios]
- [Terraform contribution guide][TerrafromContribution]

Feel free to reach out to the [AVM Core team][AVMCoreTeam] in case that additional help is needed.

---

### What do I do about existing modules that are available doing a similar thing to my module that I am proposing to develop and release?

As part of the [Module Proposal process][ProcessOverview], the AVM core team will work with you to triage your proposal. We also want to make sure that no similar existing modules from known Microsoft projects are already on their way to be migrated to AVM.

- If there aren't any, then you can proceed with developing your module from scratch once given approval to proceed by the AVM core team.
- However, if there are existing modules from Microsoft projects we would invite you to help us complete the migration to AVM of this module; this may also entail working with the existing module owner/team.

For existing modules that may not be directly owned and developed by Microsoft or their employees you should first review the license applied to the GitHub repository hosting the module and understand its terms and conditions. More information on GitHub repositories and licenses can be found here in [Licensing a repository][GitHubLicensing]. Most modules will use a license that will allow you to take inspiration and copy all or parts from the module source code. However, to confirm, you should always check the license and any conditions you may have to meet by doing this.

---

### What are the mandatory labels that needs to be used while managing issues, pull requests and discussions on GitHub repositories where module are held?

To get list of labels that **MUST** be created on gitHub repositories where modules are held navigate to [Shared non-functional requirement 23 (SNFR23)][MandatoryLabels].

You **SHOULD NOT** use any additional labels.

There is also a [PowerShell script][MandatoryLabels] that the [AVM core team][AVMCoreTeam] created that can help to apply those labels the GitHub module repository.

---

### Is there any naming convention for modules name, repository name, variables, parameters.... ?

[AVM specification][ModuleSpecifications] covers all naming conventions. As example:
  [Module naming specification][ModuleNaming]

<!-- ### Where are examples to follow / first sample modules to get inspiration from? -->

---

### Where module will live? Do I need to create separate repo or to place it in specific folder?

#### Bicep

For Bicep, both Resource and Pattern, AVM Modules will be homed in the Azure/bicep-registry-modules repository and live within an avm directory that will be located at the root of the repository.

If you are module owner, it is expected that you will fork the Azure/bicep-registry-modules repository and work on a branch from within their fork, before then creating a Pull Request (PR) back into the Azure/bicep-registry-modules repositories main branch. In Bice contribution guide, you can discover [Directory and File structure that will be used and examples][BicepDir].

#### Terraform

Each Terraform AVM module will have its own GitHub Repository in the Azure GitHub Organization.
This repo will be created by the Module Owners and the AVM Core team collaboratively, including the configuration of permissions.
To read more about how to start, navigate to [Terraform AVM contribution guide.][TerraformDir]

---

### I get the error 'The repository ********** already exists on this account' when I try to create a new repository, what should I do?

If you get this error, it means that the repository already exists in the Azure GitHub Organization. This can happen if someone has already created a repository with the same name in the past and then archived it.

To determine if this is the case you'll need to navigate to the [Microsoft Open Source Management Portal](https://repos.opensource.microsoft.com/orgs/Azure/repos?q=), then search for the repository name you are trying to create. Click on the repository and you will find the owner. Reach out the owner to ask them to transfer the repo to you or delete it. You'll want them to delete it if it was not created from the template.

---

### Where can I test my module during development?

During initial module development module owners/developers need to use your own environment (Azure subscriptions) to test module. In later phase, during publishing process, we will conduct automated test that will use AVM dedicated environment.

<br>

## Updating and managing a module

---

### I'm already using a module today, but its missing a feature, what should I do?

You should use GitHub issues to propose changes or improvements for specific module. Issue request will be router to module owner that **MUST** respond to logged issues within 3 business days. In case that module currently don't have owner, [AVM Core Team][AVMCoreTeam] will handle request.

---

### I am using module without owner. What will happened if I need update?

[AVM core team][AVMCoreTeam] will work to assign owner for every module, but it can happen during a time that there are modules without owner. If you would like to own that module, feel free to ask to take ownership. At this moment, only Microsoft FTEs can be module owners.

---

### How will the support SLAs be automatically enforced?

All issues created in a module repo will be automatically be picked up and tracked by the GitHub Policy Service. This service will take the necessary steps when escalation is needed as per the SLAs defined in the [Module Support][ModuleSupport] chapter .

[AVMCoreTeam]: /Azure-Verified-Modules/specs/shared/team-definitions/#avm-core-team
[BicepModules]: /Azure-Verified-Modules/indexes/bicep/
[TFModules]: /Azure-Verified-Modules/indexes/terraform/
[ModuleOwners]: /Azure-Verified-Modules/specs/shared/team-definitions/#module-owners
[ModuleContributors]: /Azure-Verified-Modules/specs/shared/team-definitions/#module-contributors
[WAFAligned]: /Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned
[ModuleProposal]: https://aka.ms/AVM/ModuleProposal
[ModuleSupport]: /Azure-Verified-Modules/help-support/module-support/
[AVMChannel]: https://aka.ms/AVM/channel
[ModuleSpecifications]: /Azure-Verified-Modules/specs/
[DiagnosticSettings]: /Azure-Verified-Modules/specs/shared/interfaces/#diagnostic-settings
[AzureArchitectureCenter]: https://learn.microsoft.com/en-us/azure/architecture/browse/
[ALZ]: https://aka.ms/alz
[ModuleIndexes]: /Azure-Verified-Modules/indexes/
[MandatoryLabels]: /Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels
[BicepDir]: /Azure-Verified-Modules/contributing/bicep/#directory-and-file-structure
[TerraformDir]: /Azure-Verified-Modules/contributing/terraform/#repositories
[BicepContributios]: /Azure-Verified-Modules/contributing/bicep/
[TerrafromContribution]: /Azure-Verified-Modules/contributing/terraform/
[ModuleNaming]: /Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming
[ProcessOverview]: /Azure-Verified-Modules/contributing/process/
[GitHubLicensing]: https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository
