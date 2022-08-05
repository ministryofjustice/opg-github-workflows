# OPG Github Workflows

A repo to share common github workflows that we can re-use.

| Type       | Area       | Name       | Description                                              |
|------------|------------|------------|----------------------------------------------------------|
| Automation | Build | [Dependabot Pull Request Approve and Merge](./.github/workflows/automation-build-dependabot-approve-auto-merge.yml) | Allow dependabot to auto approve its own PR, squash and merge if all requirements pass. If Codeowners are set on the repo, this action will approve and auto rebase, but will not merge until a Codeowner approves it. |
| Data | Parse | [Branch Name](./.github/workflows/data-parse-branch-name.yml) | Use github data to generate a clean branch name |
| Data | Parse | [Terraform Workspace Name](./.github/workflows/data-parse-workspace.yml) | Generate the terraform workspace name to use |

Managed by opg-org-infra &amp; Terraform
