FROM debian:11

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

COPY my.cnf /etc/mysql/my.cnf
COPY server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "mariadbd" ]
