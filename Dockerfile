FROM steamcmd/steamcmd:ubuntu-22@sha256:7d6092942e01782659b82a3d748387a2ff779d1edf78cbc8cea1a938dd56b4b4
RUN dpkg --add-architecture i386 \
    && apt update && apt -y --no-install-recommends install curl \
    && mkdir -pm755 /etc/apt/keyrings \
    && curl -o /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && curl -O --output-dir /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt update && apt -y --install-recommends install winehq-stable \
    && apt -y --no-install-recommends install winbind supervisor cron rsyslog jq && apt clean \
    && mkdir -p /usr/local/etc /var/log/supervisor /var/run/icarus /usr/local/etc/supervisor/conf.d/ /opt/icarus /home/icarus/.steam \
    && groupadd -g "${PGID:-4711}" -o icarus \
    && useradd -g "${PGID:-4711}" -u "${PUID:-4711}" -o --create-home icarus \
    && sed -i '/imklog/s/^/#/' /etc/rsyslog.conf \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY ./supervisord.conf /etc/supervisor/supervisord.conf
COPY ./scripts/* /usr/local/etc/icarus/
RUN chmod -R 755 /usr/local/etc/icarus/
CMD ["/usr/local/etc/icarus/bootstrap"]
ENTRYPOINT []
