# icarus-dedicated-server (WIP)

### ⚠️ ***Under Construction*** ⚠️

Docker image for the game ICARUS.
The image is based on the [steamcmd](https://hub.docker.com/r/cm2network/steamcmd/) image and uses supervisor to handle
startup and automatic updates.

## Environment Variables

| Variable                 | Default         | Description                                                                   |
|--------------------------|-----------------|-------------------------------------------------------------------------------|
| `SERVERNAME`             | `ICARUS Server` | The name of the server                                                        |
| `SERVER_PASSWORD` ⚠️ WIP | `-`             | The password for the server                                                   |
| `PORT`                   | `17777`         | The game port for the server                                                  |
| `QUERYPORT`              | `27015`         | The steam query port for the server                                           |
| `UPDATE_CRON`            | `*/30 * * * *`  | Update check cron interval (defaults to every 30 minutes)                     |
| `CLEANUP_CRON` ⚠️ WIP    | `-`             | Cleanup old prospects cron (checks if all players left the prospect)          |
| `CLEANUP_DAYS` ⚠️ WIP    | `1`             | Cleanup older prospects than x days (checks if all players left the prospect) |
| `PUID`                   | `4711`          | The UID to run server as                                                      |
| `PGID`                   | `4711`          | The GID to run server as                                                      |
| `STEAM_ASYNC_TIMEOUT`    | `60`            | Sets AsyncTaskTimeout in Engine.ini                                           |

## Ports

| Port      | Description      |
|-----------|------------------|
| 17777/udp | Game port        |
| 27015/udp | Steam query port |

## Volumes

| Volume                            | Description                      |
|-----------------------------------|----------------------------------|
| /home/icarus/.wine/drive_c/icarus | Server config files and saves    |
| /opt/icarus                       | Game files (steam download path) |

## Usage

### Docker Compose

```yaml
version: "3"
services:
  icarus:
    image: fabiryn/icarus-server:latest
    container_name: icarus
    hostname: icarus
    restart: unless-stopped
    ports:
      - "17777:17777/udp"
      - "27015:27015/udp"
    volumes:
      - ./data:/home/icarus/.wine/drive_c/icarus
      - ./game:/opt/icarus
    environment:
      - SERVERNAME=ICARUS Server
      - PORT=17777
      - QUERYPORT=27015
      - PUID=4711
      - PGID=4711
```
