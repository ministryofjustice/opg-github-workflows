# OPG Github Workflows

A repo to share common github workflows that we can re-use.

Managed by opg-org-infra &amp; Terraform


## Available workflows

### Analysis related

- [CodeQL to Github Security Tab](./.github/workflows/analysis-application-codeql-sast-to-github-security.yml)
- [PHP Psalm  to Github Security Tab](./.github/workflows/analysis-application-php-psalm-sast-to-github-security.yml)
- [TFSec PR feedback](./.github/workflows/analysis-infrastructure-tfsec-pr-feedback.yml)
- [TFSec to Github Security Tab](./.github/workflows/analysis-infrastructure-tfsec-to-github-security.yml)

### Build related

- [Dependabot Auto Approve](./.github/workflows/automation-build-dependabot-approve-auto-merge.yml)
- [Plan and Apply Terraform](./.github/workflows/build-infrastructure-terraform.yml)

### Data parsing related

- [Add index to a matrix](./.github/workflows/data-parse-add-index.yml) - Untested
- [Parse branch name](./.github/workflows/data-parse-branch-name.yml)
- [Parse terraform version](./.github/workflows/data-parse-terraform-version.yml)
- [Parse terraform workspace](./.github/workflows/data-parse-workspace.yml)
- [Parse semver tag](./.github/workflows/release-semver-tag.yml) - Recommend [using the composite action version instead](https://github.com/ministryofjustice/opg-github-actions/blob/main/.github/actions/semver-tag/README.md)

### Linting related

- [Lint python](./.github/workflows/linting-application-python.yml)
- [Lint terraform](./.github/workflows/linting-infrastructure-terraform.yml)
