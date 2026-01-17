FROM mcr.microsoft.com/dotnet/runtime:8.0

ENV UID="1000" \
    GID="1000"

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget netcat-traditional jq moreutils && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /data && mkdir /data/server-file && mkdir /data/server-file/server

RUN useradd -u $UID -U -m -s /bin/false vintagestory && usermod -G users vintagestory && \
    chown -R vintagestory:vintagestory /data

HEALTHCHECK --start-period=1m --interval=5s CMD nc -z 127.0.0.1 $SERVER_PORT

VOLUME ["/data/server-file"]
EXPOSE $SERVER_PORT

WORKDIR /data

COPY serverconfig.json default-serverconfig.json
COPY entry.sh scripts/entry.sh

CMD ["bash", "./scripts/entry.sh"]
