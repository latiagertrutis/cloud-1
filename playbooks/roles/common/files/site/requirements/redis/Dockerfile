FROM debian:11 AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

ADD https://download.redis.io/redis-stable.tar.gz /

RUN tar -C / -zxvf /redis-stable.tar.gz && \
    rm -f /redis-stable.tar.gz && \
    cd /redis-stable && \
    make BUILD_TLS=yes

FROM debian:11

COPY --from=build /redis-stable/src/redis-server /
COPY --from=build /redis-stable/src/redis-cli /

ENTRYPOINT [ "/redis-server", "--protected-mode no"]
