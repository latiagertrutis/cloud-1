FROM debian:11 AS installer

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/stalwartlabs/mail-server/releases/download/v0.11.6/stalwart-mail-x86_64-unknown-linux-gnu.tar.gz  /mail/

RUN tar -C /mail -zxvf /mail/stalwart-mail-x86_64-unknown-linux-gnu.tar.gz

FROM debian:11

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

COPY --from=installer /mail/stalwart-mail /
RUN chmod +x /stalwart-mail

COPY --from=installer /usr/bin/mysqladmin /usr/bin/
COPY  stalwart-mail-conf.toml /etc/

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/stalwart-mail", "-c", "/etc/stalwart-mail-conf.toml" ]
