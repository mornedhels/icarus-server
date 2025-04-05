# ICARUS-Dedicated-Server

[![Docker Pulls](https://img.shields.io/docker/pulls/mornedhels/icarus-server.svg)](https://hub.docker.com/r/mornedhels/icarus-server)
[![Docker Stars](https://img.shields.io/docker/stars/mornedhels/icarus-server.svg)](https://hub.docker.com/r/mornedhels/icarus-server)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/mornedhels/icarus-server/latest)](https://hub.docker.com/r/mornedhels/icarus-server)
[![GitHub](https://img.shields.io/github/license/mornedhels/icarus-server)](https://github.com/mornedhels/icarus-server/blob/main/LICENSE)

[![GitHub](https://img.shields.io/badge/Repository-mornedhels/icarus--server-blue?logo=github)](https://github.com/mornedhels/icarus-server)

Docker image for the game ICARUS.
The image is based on the [steamcmd](https://hub.docker.com/r/cm2network/steamcmd/) image and uses supervisor to handle
startup, automatic updates and cleanup.

## Environment Variables

| Variable                         | Default                          | Constraints          | Description                                                                                 | WIP | 
|----------------------------------|----------------------------------|----------------------|---------------------------------------------------------------------------------------------|:---:|
| `SERVER_NAME`                    | `ICARUS Server`                  | string               | The name of the server                                                                      |     |
| `SERVER_PASSWORD`                |                                  | string               | The password for the server                                                                 |     |
| `SERVER_ADMIN_PASSWORD`          |                                  | string               | The password for the admin login                                                            |     |
| `SERVER_MAX_PLAYERS`             | `8`                              | integer              | Max allowed players                                                                         |     |
| `SERVER_PORT`                    | `17777`                          | integer              | The game port for the server                                                                |     |
| `SERVER_QUERYPORT`               | `27015`                          | integer              | The steam query port for the server                                                         |     |
| `SERVER_IP`                      |                                  | string (ipv4)        | Server IP for the server empty check (update cron)                                          |     |
| `SERVER_SHUTDOWN_IF_NOT_JOINED`  | `300.000000`                     | float                | Number of seconds until started prospect returns to lobby mode                              |     |
| `SERVER_SHUTDOWN_IF_EMPTY`       | `60.000000`                      | float                | Number of seconds until server returns to lobby mode after last prospector left             |     |
| `SERVER_ALLOW_NON_ADMINS_LAUNCH` | `True`                           | boolean              | Allows all prospectors to select prospect in lobby mode                                     |     |
| `SERVER_ALLOW_NON_ADMINS_DELETE` | `False`                          | boolean              | Allows all prospectors to delete prospects in lobby mode                                    |     |
| `SERVER_RESUME_PROSPECT`         | `True`                           | boolean              | After a server restart, resume last prospect                                                |     |
| `GAME_BRANCH`                    | `public`                         | string               | Steam branch of the ICARUS server                                                           |     |
| `ASYNC_TASK_TIMEOUT`             | `60`                             | integer              | Sets AsyncTaskTimeout in Engine.ini                                                         |     |
| `PUID`                           | `4711`                           | integer              | The UID to run server as                                                                    |     |
| `PGID`                           | `4711`                           | integer              | The GID to run server as                                                                    |     |
| `UPDATE_CRON`                    |                                  | string (cron format) | Update game server files cron (eg. `*/30 * * * *` check for updates every 30 minutes)       |     |
| `UPDATE_SKIP`                    | `false`                          | boolean              | Skips Update on container startup (but still runs with command or if server files not found |     |
| `CLEANUP_CRON`                   |                                  | string (cron format) | Cleanup old prospects cron (checks if all players left the prospect)                        |     |
| `CLEANUP_DAYS`                   | `1`                              | integer              | Cleanup older prospects than x days (checks if all players left the prospect)               |     |
| `CLEANUP_DELETE_BACKUPS`         | `false`                          | boolean              | Remove backup files from pruned prospects                                                   |     |
| `CLEANUP_PRUNE_FOLDER`           | `pruned`                         | string               | Folder for cleaned prospects (relative to Prospects folder)                                 |     |
| `CLEANUP_EXCLUDES`               |                                  | string               | Exclude pattern (regex) for cleanup cron eg. world1\|world2                                 |     |
| `STEAM_API_KEY` **(DEPRECATED)** |                                  | string               | SteamApi key to authorize requests (needed for empty server check)                          |     |
| `STEAMCMD_ARGS`                  | `--beta "$GAME_BRANCH" validate` | string               | Additional steamcmd args for the updater                                                    |     |

⚠️: Work in Progress

### Additional Information

* During the update process, the container temporarily requires more disk space (up to 2x the game size).

### Hooks

| Variable           | Description                            | WIP |
|--------------------|----------------------------------------|:---:|
| `BOOTSTRAP_HOOK`   | Command to run after general bootstrap |     |
| `UPDATE_PRE_HOOK`  | Command to run before update           |     |
| `UPDATE_POST_HOOK` | Command to run after update            |     |

The scripts will wait for the hook to resolve/return before continuing.

⚠️: Work in Progress

## Ports

| Port      | Description      |
|-----------|------------------|
| 17777/udp | Game port        |
| 27015/udp | Steam query port |

## Volumes

| Volume                      | Description                      |
|-----------------------------|----------------------------------|
| /home/icarus/drive_c/icarus | Server config files and saves    |
| /opt/icarus                 | Game files (steam download path) |

**Note:** By default the volumes are created with the UID and GID 4711 (that user should not exist). To change this, set
the environment variables `PUID` and `PGID`.

## Recommended System Requirements

* **CPU:** min 2 CPU (preferred high single core performance)
* **RAM:** > 8 GB (16 GB recommended)
* **Disk:** ~20 GB
* **Docker Host\*:** Linux, macOS

*Windows is not supported (see [#46](https://github.com/mornedhels/icarus-server/issues/46))

## Usage

### Docker Compose

```yaml
version: "3"
services:
  icarus:
    image: mornedhels/icarus-server:latest
    container_name: icarus
    hostname: icarus
    restart: unless-stopped
    stop_grace_period: 90s
    ports:
      - "17777:17777/udp"
      - "27015:27015/udp"
    volumes:
      - ./data:/home/icarus/drive_c/icarus
      - ./game:/opt/icarus
    environment:
      - SERVER_NAME=ICARUS Server
      - SERVER_PASSWORD=secret
      - SERVER_ADMIN_PASSWORD=evenmoresecret
      - SERVER_PORT=17777
      - SERVER_QUERYPORT=27015
      - PUID=4711
      - PGID=4711
```

**Note:** The volumes are created next to the docker-compose.yml file. If you want to create the volumes, in the default
location (eg. /var/lib/docker) you can use the following compose file:

```yaml
version: "3"
services:
  icarus:
    image: mornedhels/icarus-server:latest
    container_name: icarus
    hostname: icarus
    restart: unless-stopped
    stop_grace_period: 90s
    ports:
      - "17777:17777/udp"
      - "27015:27015/udp"
    volumes:
      - data:/home/icarus/drive_c/icarus
      - game:/opt/icarus
    environment:
      - SERVER_NAME=ICARUS Server
      - SERVER_PASSWORD=secret
      - SERVER_ADMIN_PASSWORD=evenmoresecret
      - SERVER_PORT=17777
      - SERVER_QUERYPORT=27015
      - PUID=4711
      - PGID=4711

volumes:
  data:
  game:
```

## Commands

* **Force Update:**
  ```bash
  docker compose exec icarus supervisorctl start icarus-force-update
  ```
* **Load Prospect (⚠️: Work in Progress):**
  ```bash
  docker compose exec icarus ./icarus-commands loadProspect <ProspectName>
  ```

## Known Issues

* OOM: Server logs `Freeing x bytes from backup pool to handle out of memory`
  and `Fatal error: [File: Unknown] [Line: 197] \nRan out of memory allocating 0 bytes with alignment 0\n` but system
  has enough memory.
    * **Solution:** Increase maximum number of memory map areas (vm.max_map_count) on **docker host**. Tested
      with `262144`<br/>
      **temporary:**
      ```bash
        sysctl -w vm.max_map_count=262144
      ```
      **permanent:**
      ```bash
        echo "vm.max_map_count=262144" >> /etc/sysctl.conf && sysctl -p
      ```
