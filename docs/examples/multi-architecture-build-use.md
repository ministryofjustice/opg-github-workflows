# Using the Multi Architecture Build Workflow

## Calling the Workflow

The workflow builds native architecture images from ECR cache, scans IaC with Snyk before building, always scans each image with Snyk before pushing, pushes the per-architecture tags, and then publishes the final image tag. For multi-architecture builds the final tag is an image index. For single-architecture builds the workflow publishes the single native image tag without creating a multi-architecture index.

The `image_name`, `oidc_role_to_assume_build`, `oidc_role_to_assume_push`, `snyk_ecr_registry_id`, and `SNYK_TOKEN` secret are required when calling the workflow. The rest of the inputs can be found in the [workflow](../../.github/workflows/build-multi-architecture-image.yml).

Otherwise call the workflow as outlined in the [reusable workflow docs](https://docs.github.com/en/actions/sharing-automations/reusing-workflows#calling-a-reusable-workflow).

### Code Example:

```
build:
    name: Build Image
    uses: ministryofjustice/opg-github-workflows/.github/workflows/build-multi-architecture-image.yml@{ref}
    secrets:
      SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
    with:
      image_name: 123456789012.dkr.ecr.eu-west-1.amazonaws.com/example-image-name
      oidc_role_to_assume_build: ${{ vars.OIDC_ECR_BUILD_ROLE }}
      oidc_role_to_assume_push: ${{ vars.OIDC_ECR_PUSH_ROLE }}
      snyk_ecr_registry_id: ${{ vars.SNYK_ECR_REGISTRY_ID }}
      build_options: --build-arg EXAMPLE=true --file docker/Dockerfile
      cli_commands: make example
```

To override the build matrix, pass a JSON list of native build targets:

```
build:
    name: Build Image
    uses: ministryofjustice/opg-github-workflows/.github/workflows/build-multi-architecture-image.yml@{ref}
    secrets:
      SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
    with:
      image_name: 123456789012.dkr.ecr.eu-west-1.amazonaws.com/example-image-name
      oidc_role_to_assume_build: ${{ vars.OIDC_ECR_BUILD_ROLE }}
      oidc_role_to_assume_push: ${{ vars.OIDC_ECR_PUSH_ROLE }}
      snyk_ecr_registry_id: ${{ vars.SNYK_ECR_REGISTRY_ID }}
      build_target: production
      build_targets: '[{"actions_runner":"ubuntu-latest","platform":"linux/amd64","tag":"AMD64"}]'
```

### Note:

When a job references a reusable workflow, the name of the reported check will capture the names of the jobs in both the caller and called workflow. So if you want to use the build job as a required status check you must refer to the job as `<parent_job> / <child_job>`. In the above example that would be `Build Image / Build Multi Architecture Image`.

The image is pushed to ECR as `${image_name}:${image_tag}`. Native architecture build outputs are also pushed with `${image_tag}-${tag}` suffixes, for example `latest-AMD64`.
