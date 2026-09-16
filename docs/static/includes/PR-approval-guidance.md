<!-- markdownlint-disable -->
<table>
  <tr>
    <td></td>
    <td align="center"><b>PR is submitted by a module owner</b></td>
    <td align="center"><b>PR is submitted by anyone, other than the module owner</b></td>
  </tr>
  <tr>
    <td align="center"><b>Module has a <u>single</u> module owner</b></td>
    <td align="center">AVM core team or in case of Terraform only, the owner of another module approves the PR</td>
    <td align="center">Module owner approves the PR</td>
  </tr>
  <tr>
    <td align="center"><b>Module has <u>multiple</u> module owners</b></td>
    <td align="center">Another owner of the module (other than the submitter) approves the PR</td>
    <td align="center">One of the owners of the module approves the PR</td>
  </tr>
</table>
<!-- markdownlint-restore -->

For repositories that have adopted [metadata maintenance](https://azure.github.io/Azure-Verified-Modules/contributing/module-metadata/), changes to any `metadata.json` require approval from an eligible member of either [`@Azure/azure-verified-modules-engineering-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-engineering-owners) or [`@Azure/azure-verified-modules-module-owners`](https://github.com/orgs/Azure/teams/azure-verified-modules-module-owners). Either team is sufficient; approval from both is not required. Being listed in the module's `owners` array does not by itself authorize approval. Code changes in the same pull request still need the normal reviews described above.
