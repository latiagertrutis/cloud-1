FROM alpine:3.21 as build

ENV ANSIBLE_HOST_KEY_CHECKING=False

RUN mkdir /opt/app
WORKDIR /opt/app

COPY environment/ansible-entrypoint.sh /tmp/ansible-entrypoint.sh
RUN chmod +x /tmp/ansible-entrypoint.sh

RUN apk add --no-cache ansible openssh py3-passlib rsync

COPY . .

VOLUME /opt/app

ENTRYPOINT [ "/tmp/ansible-entrypoint.sh" ]