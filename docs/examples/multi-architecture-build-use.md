# Using the Multi Architecture Build Workflow


## Calling the Workflow

Only the `image_name` input is required when calling the workflow. The rest of the inputs can be found in the [workflow](../../.github/workflows/build-multi-architecture-image.yml).

Otherwise call the workflow as outlined in the [reusable workflow docs](https://docs.github.com/en/actions/sharing-automations/reusing-workflows#calling-a-reusable-workflow).

### Code Example:

```
build:
    name: Build Image
    uses: ministryofjustice/opg-github-workflows/.github/workflows/build-multi-architecture-image.yml@{ref}
    with:
      image_name: example-image-name
      build_options: --build-arg EXAMPLE=true --file docker/Dockerfile
      cli_commands: make example
```

### Note:

When a job references a reusable workflow, the name of the reported check will capture the names of the jobs in both the caller and called workflow. So if you want to use the build job as a reuired status check you must refer to the job as `<parent_job> / <child_job>`. In the above example that would be `Build Image / Build Multi Architecture Image`.

## Using the Image

### Setup Docker

First set up docker to enable multi architecture images to be used, the setup buildx action isn't sufficient for this currently.

```
- name: Set up Docker
  run: |
    echo '{"experimental": true, "features": { "containerd-snapshotter": true }}' | sudo tee -a /etc/docker/daemon.json
    sudo systemctl restart docker
    docker run --privileged --rm tonistiigi/binfmt --install all
```

### Load the Image

Then download the artifact with the download artifact action and load the image into docker (remember to change the artifact name if you changed it from the default earlier).

```
- uses: actions/download-artifact@v4
  with:
    path: /tmp/images
    name: multi-arch-image
- name: Load Images
  run: |
    docker load -i /tmp/images/multi-arch-image.tar
```
