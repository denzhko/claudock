# claudock

Run [Claude Code](https://code.claude.com/) inside a Docker container. Each repository gets its own named container that is reused across sessions.

Two modes are supported:

- **container** — start a container and open a shell inside it
- **vscode** — generate a `.devcontainer/` directory so VS Code can open the project natively via Dev Containers

## Requirements

- **Colima** — used to detect the Docker socket GID; install with `brew install colima`
- **Docker** — [Install Docker Desktop](https://docs.docker.com/desktop/) or use `brew install docker`
- **docker-compose** — bundled with Docker Desktop; verify with `docker-compose --version`
- **make** — pre-installed on macOS (`xcode-select --install` if missing)

Colima must be running before you use claudock. Start it with:

```sh
colima start
# or with a named profile:
colima start --profile myprofile
```

## Installation

Clone the repository and run `make install`:

```sh
git clone git@github.com:denzhko/claudock.git
cd claudock
make install
```

This creates a symlink at `~/.local/bin/claudock`. Make sure that directory is in your `PATH`. Add the following to your `~/.zshrc` or `~/.bashrc` if it is not already there:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

## Usage

### Container mode

Navigate to any repository and run:

```sh
cd ~/path/to/your/project
claudock container up
```

On the first run the Docker image is built (takes a few minutes). Subsequent runs reuse the cached image and existing container, so they start in seconds.

| Command | Description |
|---|---|
| `claudock container up` | Build image if needed and open a shell (default) |
| `claudock container down` | Stop and remove the container |
| `claudock container start` | Resume a stopped container and open a shell |
| `claudock container stop` | Stop the container without removing it |

To attach VS Code to the running container, use the **Dev Containers** extension and select "Attach to Running Container".

### VS Code mode

To use VS Code's native Dev Containers integration instead, run:

```sh
cd ~/path/to/your/project
claudock vscode init
```

This generates a `.devcontainer/` directory containing a `Dockerfile`, `docker-compose.yaml`, and a `.env` file with all variable values resolved from the current environment. Open the project in VS Code and choose **Reopen in Container**.

If `.devcontainer/` already exists, it is renamed with a timestamp (e.g. `.devcontainer.20260411_143022`) before the new one is created.

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `8118` | Port of an HTTP proxy running on the host (e.g. Privoxy). Sets `HTTP_PROXY` and `HTTPS_PROXY` inside the container to `http://host.docker.internal:PORT`. Leave unset if you are not using a local proxy. |
| `COLIMA_PROFILE` | _(unset)_ | Colima profile name for Docker GID detection. If unset, the default Colima instance is used. |

Examples:

```sh
# Use a non-default proxy port
PORT=3128 claudock container up

# Use a named Colima profile
COLIMA_PROFILE=myprofile claudock container up
```

## Uninstallation

```sh
make uninstall
```

This removes the symlink from `~/.local/bin`. The Docker image and any containers are not affected; remove them manually with:

```sh
docker rm -f <container-name>
docker rmi claudock
```
