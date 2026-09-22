FROM eclipse-temurin:21-jre-jammy

RUN useradd -m -u 1000 -s /bin/bash minecraft

WORKDIR /data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && mkdir -p /data /opt/install \
    && chown -R minecraft:minecraft /data /opt/install

USER minecraft

EXPOSE 25565

HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=5 \
  CMD bash -c 'exec 3<>/dev/tcp/127.0.0.1/25565' || exit 1

ENTRYPOINT ["entrypoint.sh"]
