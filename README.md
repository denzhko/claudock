# claudock

Container environment for Go development with proxy Claude setup. Runs [Claude Code](https://code.claude.com/) inside Docker, routing traffic through a local HTTP proxy. Each repository gets its own named container reused across sessions.

## Requirements

- **Colima** — `brew install colima`
- **Docker** — `brew install docker` or [Docker Desktop](https://docs.docker.com/desktop/)
- **docker-compose** — bundled with Docker Desktop
- **make** — pre-installed on macOS

## Installation

```sh
git clone git@github.com:denzhko/claudock.git
cd claudock
make install
```

Adds a symlink at `~/.local/bin/claudock`. Make sure it's in your `PATH`.

## Usage

### Container mode

```sh
cd ~/path/to/your/project
claudock container up
```

| Command | Description |
|---|---|
| `claudock container up` | Build image if needed and open a shell |
| `claudock container down` | Stop and remove the container |
| `claudock container start` | Resume a stopped container |
| `claudock container stop` | Stop the container |

### VS Code mode

```sh
claudock vscode init
```

Generates a `.devcontainer/` directory. Open the project in VS Code and choose **Reopen in Container**.

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `8118` | Port of the host HTTP proxy. Sets `HTTP_PROXY`/`HTTPS_PROXY` inside the container. |
| `COLIMA_PROFILE` | _(unset)_ | Colima profile name for Docker GID detection. |

## Uninstallation

```sh
make uninstall
```
