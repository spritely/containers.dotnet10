#!/usr/bin/env bats

# Core runtimes (version-pinned)

@test "dotnet version matches Dockerfile" {
    run dotnet --version
    [ "$status" -eq 0 ]
    [[ "$output" == "${EXPECTED_DOTNET_VERSION}"* ]]
}

@test "python3 version matches Dockerfile" {
    run python3 --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_PYTHON_VERSION}"* ]]
}

@test "azure cli version matches Dockerfile" {
    run az version -o tsv
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_AZURE_CLI_VERSION}"* ]]
}

@test "pulumi version matches Dockerfile" {
    run pulumi version
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_PULUMI_VERSION}"* ]]
}

@test "kubectl version matches Dockerfile" {
    run kubectl version --client
    [ "$status" -eq 0 ]
    [[ "$output" == *"${EXPECTED_KUBECTL_MINOR_VERSION}"* ]]
}

@test "codex version matches Dockerfile" {
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

@test "ssh is installed" {
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

@test "yq is installed" {
    run yq --version
    [ "$status" -eq 0 ]
}

@test "bat is installed" {
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

@test "oh-my-zsh is installed" {
    [ -d /root/.oh-my-zsh ]
}

@test "default shell for root is zsh" {
    run grep "^root:" /etc/passwd
    [ "$status" -eq 0 ]
    [[ "$output" == */zsh ]]
}
