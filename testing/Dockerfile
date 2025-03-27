FROM ubuntu:20.04
ARG USER=fumon

RUN apt-get update && apt-get install -y openssh-server
RUN useradd $USER

COPY ./generated_keys /home/$USER/.ssh/generated_keys
RUN mkdir -pv /run/sshd

CMD /usr/sbin/sshd -D