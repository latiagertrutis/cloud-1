FROM debian:11

RUN apt-get update && apt-get install -y --no-install-recommends \
    vsftpd \
    passwd \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

COPY vsftpd.conf /etc/

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "vsftpd", "/etc/vsftpd.conf" ]
