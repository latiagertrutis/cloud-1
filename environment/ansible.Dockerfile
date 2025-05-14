FROM alpine:3.21 as build

RUN mkdir /opt/app
WORKDIR /opt/app

COPY environment/ansible-entrypoint.sh /tmp/ansible-entrypoint.sh
RUN chmod +x /tmp/ansible-entrypoint.sh

RUN apk add --no-cache ansible openssh

COPY . .

VOLUME /opt/app

ENTRYPOINT [ "/tmp/ansible-entrypoint.sh" ]