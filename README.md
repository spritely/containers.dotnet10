# containers.dotnet10

Creates a dotnet 10 devcontainer with various tools preinstalled like pulumi and kubectl, and AI tools like claude code, and codex.

Published container is available from: https://hub.docker.com/repository/docker/spritelydev/dotnet10-devcontainer

## Testing

### Automated tests

`test.sh` builds the Docker image and runs [bats](https://github.com/bats-core/bats-core) tests inside it. Bats is already installed in the image, so no local test tooling is needed — just Docker.

```bash
./test.sh
```

The script extracts expected versions from Dockerfile ARGs and verifies that all installed tools match. It also checks developer tools are present and environment configuration is correct.
