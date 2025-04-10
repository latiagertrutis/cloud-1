FROM docker:dind

ARG SSH_USER=fumon
ARG ROOT_PWD

RUN apt-get update && apt-get install -y openssh-server
RUN useradd ${SSH_USER} -m
RUN echo 'root:${ROOT_PWD}' | chpasswd
RUN mkdir -pv /run/sshd

COPY ./authorized_keys.pub /home/${SSH_USER}/.ssh/authorized_keys

CMD /usr/sbin/sshd -D