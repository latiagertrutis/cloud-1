FROM debian:11

# Workarround to parametrize COPY:
# https://docs.docker.com/reference/dockerfile/#environment-replacement
ARG SSL_CERT SSL_CERT_KEY
ENV SSL_CERT=${SSL_CERT}
ENV SSL_CERT_KEY=${SSL_CERT_KEY}

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

COPY nginx.conf /etc/nginx/
COPY ${SSL_CERT} /etc/ssl/
COPY ${SSL_CERT_KEY} /etc/ssl/

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]
