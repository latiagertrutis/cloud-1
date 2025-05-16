FROM alpine:3.21 as build

ENV ANSIBLE_HOST_KEY_CHECKING=False

COPY environment/ansible-entrypoint.sh /tmp/ansible-entrypoint.sh
RUN chmod +x /tmp/ansible-entrypoint.sh

RUN apk add --no-cache ansible openssh py3-passlib rsync

RUN mkdir -pv /playbooks
WORKDIR /playbooks

VOLUME /root/.ssh
VOLUME /playbooks

ENTRYPOINT [ "/tmp/ansible-entrypoint.sh" ]
