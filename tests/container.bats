#!/usr/bin/env bats

# Sanity checks for base runtime tools

@test "dotnet is installed" {
    run dotnet --version
    [ "$status" -eq 0 ]
}

@test "python3 is installed" {
    run python3 --version
    [ "$status" -eq 0 ]
}

@test "azure cli version matches Containerfile" {
    run az version -o tsv
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_AZURE_CLI_VERSION}"* ]]
}

@test "pulumi version matches Containerfile" {
    run pulumi version
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_PULUMI_VERSION}"* ]]
}

@test "kubectl version matches Containerfile" {
    run kubectl version --client
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_KUBECTL_MINOR_VERSION}"* ]]
}

# Project-specific tools

@test "docker is installed" {
    run docker --version
    [ "$status" -eq 0 ]
}

@test "sudo is installed" {
    run sudo --version
    [ "$status" -eq 0 ]
}

# containers.base dependency validation

@test "apply-templates is installed" {
    run apply-templates --help
    [ "$status" -eq 0 ]
}

@test "merge-xml is installed" {
    [ -x /usr/local/bin/merge-xml ]
}

# Environment configuration

@test "NUGET_XMLDOC_MODE is empty" {
    [ -z "${NUGET_XMLDOC_MODE:-unset}" ] || [ "${NUGET_XMLDOC_MODE}" = "" ]
}

@test "PULUMI_SKIP_UPDATE_CHECK is true" {
    [ "$PULUMI_SKIP_UPDATE_CHECK" = "true" ]
}
