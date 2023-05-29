# ICARUS-Dedicated-Server

[![Docker Pulls](https://img.shields.io/docker/pulls/mornedhels/icarus-server.svg)](https://hub.docker.com/r/mornedhels/icarus-server)
[![Docker Stars](https://img.shields.io/docker/stars/mornedhels/icarus-server.svg)](https://hub.docker.com/r/mornedhels/icarus-server)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/mornedhels/icarus-server/latest)](https://hub.docker.com/r/mornedhels/icarus-server)
[![GitHub](https://img.shields.io/github/license/mornedhels/icarus-server)](https://github.com/mornedhels/icarus-server/blob/main/LICENSE)

Docker image for the game ICARUS.
The image is based on the [steamcmd](https://hub.docker.com/r/cm2network/steamcmd/) image and uses supervisor to handle
startup, automatic updates and cleanup.

## Environment Variables

|    | Variable                         | Default                          | Description                                                                     |
|:--:|----------------------------------|----------------------------------|---------------------------------------------------------------------------------|
|    | `SERVER_NAME`                    | `ICARUS Server`                  | The name of the server                                                          |
|    | `SERVER_PASSWORD`                |                                  | The password for the server                                                     |
|    | `SERVER_ADMIN_PASSWORD`          |                                  | The password for the admin login                                                |
|    | `SERVER_MAX_PLAYERS`             | `8`                              | Max allowed players                                                             |
|    | `SERVER_PORT`                    | `17777`                          | The game port for the server                                                    |
|    | `SERVER_QUERYPORT`               | `27015`                          | The steam query port for the server                                             |
|    | `SERVER_SHUTDOWN_IF_NOT_JOINED`  | `300.000000`                     | Number of seconds until started prospect returns to lobby mode                  |
|    | `SERVER_SHUTDOWN_IF_EMPTY`       | `60.000000`                      | Number of seconds until server returns to lobby mode after last prospector left |
|    | `SERVER_ALLOW_NON_ADMINS_LAUNCH` | `True`                           | Allows all prospectors to select prospect in lobby mode                         |
|    | `SERVER_ALLOW_NON_ADMINS_DELETE` | `False`                          | Allows all prospectors to delete prospects in lobby mode                        |
|    | `SERVER_RESUME_PROSPECT`         | `True`                           | After a server restart, resume last prospect                                    |
|    | `GAME_BRANCH`                    | `public`                         | Steam branch of the ICARUS server                                               |
|    | `ASYNC_TASK_TIMEOUT`             | `60`                             | Sets AsyncTaskTimeout in Engine.ini                                             |
|    | `PUID`                           | `4711`                           | The UID to run server as                                                        |
|    | `PGID`                           | `4711`                           | The GID to run server as                                                        |
|    | `UPDATE_CRON`                    | `*/30 * * * *`                   | Update check cron interval (defaults to every 30 minutes)                       |
| ⚠️ | `CLEANUP_CRON`                   |                                  | Cleanup old prospects cron (checks if all players left the prospect)            |
| ⚠️ | `CLEANUP_DAYS`                   | `1`                              | Cleanup older prospects than x days (checks if all players left the prospect)   |
|    | `STEAMCMD_ARGS`                  | `--beta "$GAME_BRANCH" validate` | Additional steamcmd args for the updater                                        |

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
