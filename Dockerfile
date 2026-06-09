FROM debian:stable-slim

ARG TARGETARCH
ARG VERSION
ENV TZ=UTC

WORKDIR /usr/local/bin
COPY get_url.sh /get_url.sh
COPY start.sh /start.sh

RUN apt-get update && apt-get install -y --no-install-recommends wget unzip ca-certificates && \
    chmod +x /get_url.sh /start.sh && \
    wget -q -O "snell-server.zip" "$(/get_url.sh "${VERSION}" "${TARGETARCH}")" && \
    unzip snell-server.zip && rm snell-server.zip && \
    apt-get remove -y wget unzip && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /get_url.sh

ENTRYPOINT ["/start.sh"]
