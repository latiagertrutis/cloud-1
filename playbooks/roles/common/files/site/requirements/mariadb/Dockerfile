FROM debian:11

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    ca-certificates \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -O /healthcheck.sh \
    https://raw.githubusercontent.com/MariaDB/mariadb-docker/refs/heads/master/healthcheck.sh \
    && chmod +x /healthcheck.sh

RUN mkdir -p /run/mysqld

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

COPY my.cnf /etc/mysql/my.cnf
COPY server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "mariadbd" ]
