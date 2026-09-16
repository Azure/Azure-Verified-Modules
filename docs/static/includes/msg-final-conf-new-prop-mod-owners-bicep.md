<!-- markdownlint-disable -->
Hi @avm_module_owner,

Thanks for confirming that you wish to own this AVM module and understand the related requirements and responsibilities!

Before starting development, please ensure ALL the following requirements are met.

Every module owner must request and obtain approval for the [Azure Verified Modules (AVM) Module Contributors access package](https://aka.ms/avm/id/access-package/module-contributor), as outlined in [SNFR20](https://azure.github.io/Azure-Verified-Modules/spec/SNFR20#bicep). You no longer need to create per-module GitHub teams, assign parent teams, or add entries to `CODEOWNERS`.

**Use the module name and path approved in the proposal, and the assigned telemetry identifier.** The [module index](https://azure.github.io/Azure-Verified-Modules/indexes/) remains a published lookup reference:

- For your module:
  - `ModuleName` - for naming your module
  - `TelemetryIdPrefix` - for your module's [telemetry](https://azure.github.io/Azure-Verified-Modules/spec/SFR3)
  - Folder path are defined in `RepoURL`.

Once the module source exists and [metadata maintenance](https://azure.github.io/Azure-Verified-Modules/contributing/module-metadata/) is adopted, maintain supported fields in `metadata.json` through metadata code-owner review, including the assigned `telemetryIdPrefix`. The module name and repository path are derived from the source location; do not add `ModuleName` or `RepoURL` fields to metadata. If an approved value is missing or conflicts with the index, contact the AVM core team rather than inventing a replacement.

Check if this module exists in the other IaC language. If so, collaborate with the other owner for consistency. 👍

You can now start the development of this module! ✅ Happy coding! 🎉

**Please respond to this comment and request a review from the AVM core team once your module is ready to be published! Please include a link pointing to your PR, once available. 🙏**

Any further questions or clarifications needed, let us know!

Thanks,

The AVM Core Team
<!-- markdownlint-restore -->
