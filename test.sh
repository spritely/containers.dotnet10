#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="dotnet10-test"
DOCKERFILE="./src/Dockerfile"

# Extract ARG values from the Dockerfile
extract_arg() {
    grep -m1 "^ARG ${1}=" "$DOCKERFILE" | cut -d= -f2
}

DOTNET_VERSION=$(extract_arg DOTNET_VERSION)
PYTHON_VERSION=$(extract_arg PYTHON_VERSION)
AZURE_CLI_VERSION=$(extract_arg AZURE_CLI_VERSION)
PULUMI_VERSION=$(extract_arg PULUMI_VERSION)
KUBECTL_MINOR_VERSION=$(extract_arg KUBECTL_MINOR_VERSION)
CODEX_VERSION=$(extract_arg CODEX_VERSION)

echo "Building image..."
docker build -t "$IMAGE_NAME" ./src

echo "Running tests..."
mkdir -p test-results
docker run --rm \
    -v "$(pwd)/tests:/tests:ro" \
    -v "$(pwd)/test-results:/test-results" \
    -e "EXPECTED_DOTNET_VERSION=$DOTNET_VERSION" \
    -e "EXPECTED_PYTHON_VERSION=$PYTHON_VERSION" \
    -e "EXPECTED_AZURE_CLI_VERSION=$AZURE_CLI_VERSION" \
    -e "EXPECTED_PULUMI_VERSION=$PULUMI_VERSION" \
    -e "EXPECTED_KUBECTL_MINOR_VERSION=$KUBECTL_MINOR_VERSION" \
    -e "EXPECTED_CODEX_VERSION=$CODEX_VERSION" \
    --entrypoint bats \
    "$IMAGE_NAME" \
    --report-formatter junit --output /test-results \
    /tests/container.bats
