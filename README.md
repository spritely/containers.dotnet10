# containers.dotnet10

Creates a dotnet 10 devcontainer with various tools preinstalled like pulumi and kubectl, and AI tools like claude code, codex, and gemini.

Published container is available from: https://hub.docker.com/repository/docker/spritelydev/dotnet10-devcontainer

## Developer Information

### To Manually Copy a Template
1. Copy the src directory into your repository under the .devcontainer folder.
2. Rename container-compose.template to container-compose.yaml and edit the file to replace {repo-name} with the name of the repo.
3. Edit the devcontainer.json file and replace {repo-name} with the name of the repo.

### Create .env file
Copy the example .env.example file to .env and modify it as needed.

```bash
cp .devcontainer/.env.example .devcontainer/.env
# or
cd .devcontainer
cp .env.example .env
```

Do NOT commit the .env file to source control. It is local to your environment. It is listed in .gitignore.

### Testing
Run the prepare-for-test.sh script as follows. Create or modify the test/{container-name}/.devcontainer/.env file as needed. Then open the new folder in Visual Studio Code and reopen the folder inside the devcontainer to validate it.

#### First time only
```bash
chmod +x prepare-for-test.sh
```

#### To Test
```bash
# prepare-for-test.sh {container-name} {true|false - default is false if not supplied}
# code test/{container-name}

# if second argument is true then prepare-for-test also runs this line:
# cp test/{container-name}/.devcontainer/.env.example test/{container-name}/.devcontainer/.env

# Example:
./prepare-for-test.sh dotnet10 true
code test/dotnet10
```

When Visual Studio Code starts select the "Reopen in Container" option. Check that it works. It is often necessary to examine the devcontainer installation logs if something doesn't work as expected.

### Troubleshooting Notes
Some containers will fail to start because they are designed to run as root user.

This is especially problematic when using a rootless environment such as with podman.

For example: https://github.com/microsoft/vscode-remote-release/issues/1685

For additional details on this problem, see: https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user

Fortunately, there is a simple solution: use a container-compose file. So that pattern is applied here.
