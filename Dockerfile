FROM steamcmd/steamcmd:ubuntu@sha256:959ecc82b4752f41d41fccf7b806fee033cf21cb94c8d0b68ec3b69cbc0a24f6
RUN apt update && apt -y --no-install-recommends install supervisor cron curl rsyslog jq wine wine64 && apt clean \
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
