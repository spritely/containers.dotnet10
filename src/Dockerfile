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

FROM mcr.microsoft.com/dotnet/sdk:10.0.102-noble-amd64

# Clear this environment variable so xml docs from NuGet packages are unpackaged. The default dotnet/sdk image sets it to 'skip'.
# See https://github.com/dotnet/dotnet-docker/issues/2790
ENV NUGET_XMLDOC_MODE=

RUN apt-get update && apt-get install -y \
    # Install common dependencies
    apt-transport-https \
    bat \
    bats \
    ca-certificates \
    curl \
    fuse-overlayfs \
    git \
    gnupg \
    lsb-release \
    openssh-client \
    sudo \
    tree \
    wget \
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
    # Obtain the version number from: https://learn.microsoft.com/en-us/cli/azure/release-notes-azure-cli
    # Only use the major, minor, and patch version numbers
    && AZ_VER=2.82.0 \
    && echo "Types: deb\nURIs: https://packages.microsoft.com/repos/azure-cli/\nSuites: ${AZ_DIST}\nComponents: main\nArchitectures: $(dpkg --print-architecture)\nSigned-by: /etc/apt/keyrings/microsoft.gpg" | tee /etc/apt/sources.list.d/azure-cli.sources \
    && apt-get update && apt-get install -y azure-cli=${AZ_VER}-1~${AZ_DIST} \
    # Install Pulumi CLI, see: https://www.pulumi.com/docs/install/
    # To find a new version check this page: https://www.pulumi.com/docs/install/versions/
    && curl -fsSL https://get.pulumi.com | sh -s -- --version 3.217.1 \
    # Move pulumi to /usr/local/bin so it's in the PATH for all users
    && mv /root/.pulumi/bin/* /usr/local/bin/ \
    # Install kubectl CLI, see: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    # KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    # KUBECTL_VERSION will be something like v1.32.2 but commands below require the minor version only
    && KUBECTL_MINOR_VERSION=v1.35 \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBECTL_MINOR_VERSION}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list \
    && chmod 644 /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y kubectl jq yq \
    # Add latest Active LTS node.js version
    # See: https://nodejs.org/en/about/previous-releases and https://nodejs.org/en/download/current
    && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    # Install Python (latest stable)
    # See: https://www.python.org/downloads/
    && PYTHON_VER=3.14 \
    && apt-get install -y python${PYTHON_VER} python${PYTHON_VER}-venv python3-pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VER} 1 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VER} 1 \
    # Install UV (fast Python package installer)
    # See: https://github.com/astral-sh/uv
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/ \
    # Add Claude Code and OpenAI Codex CLIs
    && npm install -g @anthropic-ai/claude-code \
    && npm install -g @openai/codex \
    && npm install -g @google/gemini-cli \
    # Grant built-in app user sudo permissions without password prompt
    && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    # Add app user to the docker group to enable docker usage without sudo
    && usermod -aG docker app \
    # Install oh-my-zsh. Needs to be per user. See: https://ohmyz.sh/
    && sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended \
    # Set zsh as the default shell for the main (root) user
    && chsh -s /bin/zsh root \
    # Clean up
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

ENV PULUMI_SKIP_UPDATE_CHECK=true

# Start docker in docker
ENTRYPOINT ["sh", "-c", "dockerd > /dev/null 2>&1 & exec \"$@\"", "--"]
