FROM steamcmd/steamcmd:ubuntu-22@sha256:8b2511e03bb70483e32572957bcf2da3af19a4ab394d66176ee2228419834042
RUN dpkg --add-architecture i386 \
    && apt update && apt -y --no-install-recommends install curl \
    && mkdir -pm755 /etc/apt/keyrings \
    && curl -o /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && curl -O --output-dir /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt update && apt -y --install-recommends install winehq-stable \
    && curl -o /tmp/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /tmp/winetricks && install -m 755 /tmp/winetricks /usr/local/bin/winetricks \
    && apt -y --no-install-recommends install winbind xvfb supervisor cron rsyslog jq && apt clean \
    && mkdir -p /usr/local/etc /var/log/supervisor /var/run/icarus /usr/local/etc/supervisor/conf.d/ /opt/icarus /home/icarus/.steam \
    && groupadd -g "${PGID:-4711}" -o icarus \
    && useradd -g "${PGID:-4711}" -u "${PUID:-4711}" -o --create-home icarus \
    && sed -i '/imklog/s/^/#/' /etc/rsyslog.conf \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -m 1777 -p /tmp/.X11-unix
COPY ./supervisord.conf /etc/supervisor/supervisord.conf
COPY ./scripts/* /usr/local/etc/icarus/
RUN chmod -R 755 /usr/local/etc/icarus/
CMD ["/usr/local/etc/icarus/bootstrap"]
ENTRYPOINT []
