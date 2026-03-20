# 1. List of all available tags: https://mcr.microsoft.com/product/dotnet/sdk/tags
# 2. Details about selecting a container image: https://github.com/dotnet/dotnet-docker/blob/main/README.sdk.md
# 3. Ubuntu releases: https://www.releases.ubuntu.com/
# 4. Information on dotnet versions: https://dotnet.microsoft.com/en-us/download/dotnet
# Also see:
# - .NET tagging policy: https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-tags.md
# - .NET image variants: https://github.com/dotnet/dotnet-docker/blob/main/documentation/image-variants.md

# Starting point for this file: https://github.com/devcontainers/images/blob/main/src/dotnet/.devcontainer/Dockerfile

# To find an image tag from #1:
# - Use the linux amd64 variant from #2
# - Choose latest long-term-support (LTS) version of Ubuntu from #3
# - Select the latest dotnet version from #4 that exists in #1

# Base image versions
# Python tags: https://hub.docker.com/_/python
# renovate: datasource=docker depName=python
ARG PYTHON_VERSION=3.14
# .NET SDK tags: https://mcr.microsoft.com/product/dotnet/sdk/tags
# renovate: datasource=docker depName=mcr.microsoft.com/dotnet/sdk
ARG DOTNET_VERSION=10.0.201

# Stage with Python installed (official image)
FROM python:${PYTHON_VERSION}-slim AS py

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}-noble-amd64

# Clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# See https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=

# Copy Python runtime + stdlib from official Python image
COPY --from=py /usr/local/ /usr/local/

# Tool versions
# Obtain the version number from: https://learn.microsoft.com/en-us/cli/azure/release-notes-azure-cli
# Only use the major, minor, and patch version numbers
# renovate: datasource=github-tags depName=Azure/azure-cli extractVersion=^azure-cli-(?<version>.*)$
ARG AZURE_CLI_VERSION=2.84.0
# Pulumi releases: https://www.pulumi.com/docs/install/versions/
# renovate: datasource=github-releases depName=pulumi/pulumi extractVersion=^v(?<version>.*)$
ARG PULUMI_VERSION=3.217.1
# Obtain the version number from: https://dl.k8s.io/release/stable.txt
# Version will be something like v1.32.2 but commands below require using the major and minor version only
# kubectl releases: https://kubernetes.io/releases/
# renovate: datasource=github-releases depName=kubernetes/kubernetes extractVersion=^v(?<version>\d+\.\d+)
ARG KUBECTL_MINOR_VERSION=1.35
# Codex releases: https://github.com/openai/codex/releases
# renovate: datasource=github-releases depName=openai/codex extractVersion=^rust-v(?<version>.*)$
ARG CODEX_VERSION=0.116.0

RUN apt-get update && apt-get install -y \
    # Python runtime dependencies (required by copied Python installation)
    libssl3 \
    zlib1g \
    libbz2-1.0 \
    libreadline8 \
    libsqlite3-0 \
    libncursesw6 \
    libffi8 \
    liblzma5 \
    tk \
    # Build dependencies (required for package installations below)
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    # Docker-in-Docker support
    fuse-overlayfs \
    # Developer experience tools
    bat \
    bats \
    git \
    openssh-client \
    sudo \
    tree \
    zsh \
    # Make bat (installed as batcat) available as bat, see: https://github.com/sharkdp/bat
    && ln -s /usr/bin/batcat /usr/local/bin/bat \
    # Enable docker in docker
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce \
    # Install Azure CLI, see: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && AZ_DIST=$(lsb_release -cs) \
    && AZ_VER=${AZURE_CLI_VERSION} \
    && echo "Types: deb\nURIs: https://packages.microsoft.com/repos/azure-cli/\nSuites: ${AZ_DIST}\nComponents: main\nArchitectures: $(dpkg --print-architecture)\nSigned-by: /etc/apt/keyrings/microsoft.gpg" | tee /etc/apt/sources.list.d/azure-cli.sources \
    && apt-get update && apt-get install -y azure-cli=${AZ_VER}-1~${AZ_DIST} \
    # Install Pulumi CLI, see: https://www.pulumi.com/docs/install/
    && curl -fsSL https://get.pulumi.com | sh -s -- --version ${PULUMI_VERSION} \
    # Move pulumi to /usr/local/bin so it's in the PATH for all users
    && mv /root/.pulumi/bin/* /usr/local/bin/ \
    # Install kubectl CLI, see: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v${KUBECTL_MINOR_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBECTL_MINOR_VERSION}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y kubectl jq yq \
    # Install Claude Code (native installer)
    && curl -fsSL https://claude.ai/install.sh | bash \
    # Install OpenAI Codex (native binary)
    && wget https://github.com/openai/codex/releases/download/rust-v${CODEX_VERSION}/codex-x86_64-unknown-linux-gnu.tar.gz -O /tmp/codex.tar.gz \
    && tar -xzf /tmp/codex.tar.gz -C /tmp \
    && mv /tmp/codex-x86_64-unknown-linux-gnu /usr/local/bin/codex \
    && chmod +x /usr/local/bin/codex \
    && rm /tmp/codex.tar.gz \
    # Grant built-in app user sudo permissions without password prompt
    && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    # Add app user to the docker group to enable docker usage without sudo
    && usermod -aG docker app \
    # Install oh-my-zsh. Needs to be per user. See: https://ohmyz.sh/
    && sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended \
    # Set zsh as the default shell for the main (root) user
    && chsh -s /bin/zsh root \
    # Install uv (fast Python package installer)
    # See: https://github.com/astral-sh/uv
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    # Clean up
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

# Add uv to PATH
ENV PATH="/root/.local/bin:${PATH}"

ENV PULUMI_SKIP_UPDATE_CHECK=true

# Start docker in docker
ENTRYPOINT ["sh", "-c", "dockerd > /dev/null 2>&1 & exec \"$@\"", "--"]
