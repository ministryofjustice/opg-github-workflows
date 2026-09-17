# Using the Multi-Architecture Build, Scan and Push Workflow

This reusable workflow builds Docker images using native runners per architecture, runs Snyk container vulnerability scanning with SARIF report uploads, and pushes the resulting image (and shared build cache) to Amazon ECR via AWS OIDC authentication.

When multiple build targets are configured, it performs native compilation on separate runner architectures in parallel, exports the build caches, and consolidates them into a single multi-architecture image index pushed to ECR.

## Permissions

The calling job must have the following permissions:

```yaml
permissions:
  contents: read
  id-token: write
  security-events: write
```

## Calling the Workflow

The workflow requires three inputs (`image_name`, `oidc_role_to_assume_build`, `oidc_role_to_assume_push`) and one secret (`SNYK_TOKEN`).

Refer to the [reusable workflow docs](https://docs.github.com/en/actions/sharing-automations/reusing-workflows#calling-a-reusable-workflow) for general guidance on calling reusable workflows.

### Single-Architecture Example (Default AMD64)

```yaml
build_and_push:
  name: Build and Push Image
  permissions:
    contents: read
    id-token: write
    security-events: write
  uses: ministryofjustice/opg-github-workflows/.github/workflows/multi-build-scan-push-workflow.yml@{ref}
  with:
    image_name: ${{ vars.AWS_ECR_REGISTRY_ID }}.dkr.ecr.eu-west-1.amazonaws.com/example-service
    image_tag: latest
    image_display_name: example-service
    oidc_role_to_assume_build: ${{ vars.OIDC_ECR_BUILD_ROLE }}
    oidc_role_to_assume_push: ${{ vars.OIDC_ECR_PUSH_ROLE }}
    build_options: --build-arg APP_ENV=production --file docker/Dockerfile
    build_path: .
  secrets:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

### Multi-Architecture Example (AMD64 and ARM64)

To build across multiple architectures using native runners, provide a JSON matrix in `build_targets`:

```yaml
build_and_push:
  name: Build, Scan and Push Multi-Arch Image
  permissions:
    contents: read
    id-token: write
    security-events: write
  uses: ministryofjustice/opg-github-workflows/.github/workflows/multi-build-scan-push-workflow.yml@{ref}
  with:
    image_name: ${{ vars.AWS_ECR_REGISTRY_ID }}.dkr.ecr.eu-west-1.amazonaws.com/example-service
    image_tag: ${{ github.sha }}
    image_display_name: example-service
    build_targets: |
      [
        {"actions_runner": "ubuntu-latest", "platform": "linux/amd64", "tag": "AMD64"},
        {"actions_runner": "arm-runner", "platform": "linux/arm64", "tag": "ARM64"}
      ]
    oidc_role_to_assume_build: ${{ vars.OIDC_ECR_BUILD_ROLE }}
    oidc_role_to_assume_push: ${{ vars.OIDC_ECR_PUSH_ROLE }}
    build_options: --file docker/Dockerfile
    enable_snyk_scanning: true
    snyk_policy_path: ./.snyk
    snyk_container_options: --severity-threshold=high
  secrets:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

### PR / Non-Push Example (Build and Scan Only)

To test builds and run Snyk scans on Pull Requests without pushing images to ECR:

```yaml
build_and_scan:
  name: Build and Scan Image
  permissions:
    contents: read
    id-token: write
    security-events: write
  uses: ministryofjustice/opg-github-workflows/.github/workflows/multi-build-scan-push-workflow.yml@{ref}
  with:
    image_name: ${{ vars.AWS_ECR_REGISTRY_ID }}.dkr.ecr.eu-west-1.amazonaws.com/example-service
    image_display_name: example-service
    push_images: false
    oidc_role_to_assume_build: ${{ vars.OIDC_ECR_BUILD_ROLE }}
    oidc_role_to_assume_push: ${{ vars.OIDC_ECR_PUSH_ROLE }}
  secrets:
    SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
```

## Status Checks

When setting up required status checks in branch protection rules, the check name is composed of `<caller_job_name> / <called_job_name>`.

For this workflow:

- **Single Architecture matrix job**:
  - Format: `<caller_job_name> / <image_display_name || image_name> - <platform>`
  - Example: `Build and Push Image / example-app - linux/amd64`
- **Multi-Architecture consolidation job** (only runs when `build_targets` has >1 entries and `push_images: true`):
  - Format: `<caller_job_name> / Multi-architecture build`
  - Example: `Build, Scan and Push Multi-Arch Image / Multi-architecture build`

## Key Inputs and Secrets

### Required

| Name                        | Type   | Description                                                       |
| --------------------------- | ------ | ----------------------------------------------------------------- |
| `image_name`                | string | Target Amazon ECR image name                                      |
| `oidc_role_to_assume_build` | string | AWS IAM OIDC role ARN used to pull base images and read ECR cache |
| `oidc_role_to_assume_push`  | string | AWS IAM OIDC role ARN used to push images and write ECR cache     |
| `SNYK_TOKEN`                | secret | Snyk API token used for container vulnerability scanning          |

### Optional Configuration

| Input                       | Default                                                                       | Description                                                                |
| --------------------------- | ----------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `image_tag`                 | `latest`                                                                      | Tag to apply to the pushed image                                           |
| `image_display_name`        | `""`                                                                          | Friendly name shown in GitHub Actions check titles                         |
| `build_targets`             | `[{"actions_runner":"ubuntu-latest","platform":"linux/amd64","tag":"AMD64"}]` | JSON matrix defining native runners, platforms, and tag identifiers        |
| `build_options`             | `""`                                                                          | Additional flags for `docker buildx build` (e.g., `--file`, `--build-arg`) |
| `build_path`                | `.`                                                                           | Directory context for Docker build                                         |
| `build_target`              | `""`                                                                          | Target stage for multi-stage Dockerfiles                                   |
| `build_cache_tag`           | `build-cache`                                                                 | Tag name used for caching build layers in ECR                              |
| `cli_commands`              | `""`                                                                          | Commands to execute prior to building (e.g. `make build`)                  |
| `push_images`               | `true`                                                                        | Whether to push built images to ECR                                        |
| `enable_snyk_scanning`      | `true`                                                                        | Whether to run Snyk container scans                                        |
| `snyk_policy_path`          | `./.snyk`                                                                     | Path to `.snyk` policy file with ignore rules/patches                      |
| `snyk_container_options`    | `""`                                                                          | Extra arguments passed to Snyk CLI test command                            |
| `aws_region`                | `eu-west-1`                                                                   | AWS region where ECR is hosted                                             |
| `multi_arch_actions_runner` | `ubuntu-latest`                                                               | Runner used for the multi-architecture consolidation job                   |
