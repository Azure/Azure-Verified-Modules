<!-- markdownlint-disable -->
Hi @{requestor/proposed owner's GitHub alias},

Thanks for confirming that you wish to own this AVM module and understand the related requirements and responsibilities!

We just want to ask you to double check a few important things and take the next steps before you start the development.

**Please use the following values explicitly as provided in the [module index](https://azure.github.io/Azure-Verified-Modules/indexes/) page**:

- For your module:
  - `ModuleName` - to name your module
  - `TelemetryIdPrefix` - to be used in your module's [telemetry](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry)
- For your module's repository:
  - Repository name and folder path are defined in `RepoURL`
  - Create the GitHub teams defined in the `ModuleOwnersGHTeam` and `ModuleContributorsGHTeam` columns and grant them permissions as described [here](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only).
    - In case of a Bicep module, **please let the AVM core team know** when you created these teams, and we'll help you with assigning the necessary permissions as described [here](https://azure.github.io/Azure-Verified-Modules/specs/shared/#grant-permissions---bicep).
    - In case of a Terraform module, follow the instructions [here](https://azure.github.io/Azure-Verified-Modules/specs/shared/#grant-permissions---terraform) and assign the necessary permissions.

Grant the right level of permissions for  the AVM core team and PG teams on your GitHub repo as described [here](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr9---category-contributionsupport---avm--pg-teams-github-repo-permissions).

You can now start the development of this module! ✅ Happy coding! 🎉

**Please respond to this comment and request a review from the AVM core team once your module is ready to be published!** Please include a link pointing to your PR if available. 🙏

Any further questions or clarifications needed, let us know!

Thanks,

The AVM Core Team

<br>

> **NOTE**:
>
> - This Module Proposal issue **MUST remain open** until the module is fully developed, tested and published to the relevant registry. **Do NOT close** the issue before the successful publication is confirmed!
> - Once the module is fully developed, tested and published to the relevant registry, and the Module Proposal issue was closed, it **MUST remain closed**.
<!-- markdownlint-restore -->
