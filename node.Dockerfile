FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ARG SSH_USER=fumon
ARG SSH_PWD
ARG ROOT_PWD
#RUN apt update && \
#    apt install -y ca-certificates curl && \
#    install -m 0755 -d /etc/apt/keyrings && \
#    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
#    chmod a+r /etc/apt/keyrings/docker.asc && \
#    echo \
#"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
#      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#    apt update 
#RUN apt-get install -y openssh-server docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y openssh-server
RUN useradd ${SSH_USER} -d /home/${SSH_USER} -s /bin/bash && \
    mkdir -p /home/${SSH_USER} && \
    chown -R ${SSH_USER}:${SSH_USER} /home/${SSH_USER} && \
    echo -n "root:${ROOT_PWD}" | chpasswd && \
    echo -n "${SSH_USER}:${SSH_PWD}" | chpasswd && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "AllowUsers ${SSH_USER}" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd && chmod 0755 /run/sshd

COPY ./authorized_keys.pub /home/${SSH_USER}/.ssh/authorized_keys
COPY ./authorized_keys.pub /home/root/.ssh/authorized_keys

RUN chown ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh/authorized_keys && \
    chmod 600 /home/${SSH_USER}/.ssh/authorized_keys

CMD /usr/sbin/sshd -D

