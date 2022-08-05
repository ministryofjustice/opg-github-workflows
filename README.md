# OPG Github Workflows

A repo to share common github workflows that we can re-use.

| Action       | Description                                              |
|--------------|----------------------------------------------------------|
| [automation-build-dependabot-approve-auto-merge](./.github/workflows/automation-build-dependabot-approve-auto-merge.yml) | Allow dependabot to auto approve its own PR, squash and merge if all requirements pass. If Codeowners are set on the repo, this action will approve and auto rebase, but will not merge until a Codeowner approves it. |

Managed by opg-org-infra &amp; Terraform
