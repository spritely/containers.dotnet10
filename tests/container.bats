#!/usr/bin/env bats

# Version checks for tools with pinned versions in Containerfile

@test "dotnet version matches Containerfile" {
    run dotnet --version
    [ "$status" -eq 0 ]
    [[ "$output" == "${EXPECTED_DOTNET_VERSION}"* ]]
}

@test "python3 version matches Containerfile" {
    run python3 --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_PYTHON_VERSION}"* ]]
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

@test "yq version matches Containerfile" {
    run yq --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_YQ_VERSION}"* ]]
}

@test "codex version matches Containerfile" {
    run codex --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_CODEX_VERSION}"* ]]
}

# Developer tools (presence check)

@test "git is installed" {
    run git --version
    [ "$status" -eq 0 ]
}

@test "curl is installed" {
    run curl --version
    [ "$status" -eq 0 ]
}

@test "wget is installed" {
    run wget --version
    [ "$status" -eq 0 ]
}

@test "ssh client is installed" {
    run ssh -V
    [ "$status" -eq 0 ]
}

@test "sudo is installed" {
    run sudo --version
    [ "$status" -eq 0 ]
}

@test "zsh is installed" {
    run zsh --version
    [ "$status" -eq 0 ]
}

@test "jq is installed" {
    run jq --version
    [ "$status" -eq 0 ]
}

@test "bat is installed and symlinked from batcat" {
    run bat --version
    [ "$status" -eq 0 ]
}

@test "bats is installed" {
    run bats --version
    [ "$status" -eq 0 ]
}

@test "tree is installed" {
    run tree --version
    [ "$status" -eq 0 ]
}

# Docker

@test "docker is installed" {
    run docker --version
    [ "$status" -eq 0 ]
}

# AI tools

@test "claude is installed" {
    run claude --version
    [ "$status" -eq 0 ]
}

# Python ecosystem

@test "uv is installed" {
    run uv --version
    [ "$status" -eq 0 ]
}

# Environment configuration

@test "NUGET_XMLDOC_MODE is empty" {
    [ -z "${NUGET_XMLDOC_MODE:-unset}" ] || [ "${NUGET_XMLDOC_MODE}" = "" ]
}

@test "PULUMI_SKIP_UPDATE_CHECK is true" {
    [ "$PULUMI_SKIP_UPDATE_CHECK" = "true" ]
}

# Shell environment

@test "zsh is the default shell" {
    run getent passwd root
    [ "$status" -eq 0 ]
    [[ "$output" == */bin/zsh ]]
}

@test "oh-my-zsh is installed" {
    [ -d "$HOME/.oh-my-zsh" ]
}
