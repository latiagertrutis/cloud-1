FROM debian:12

ARG USER=mrodrigu

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    python3 \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --gecos "" $USER

RUN mkdir -p /run/sshd && chmod 0755 /run/sshd

COPY ./authorized_keys /home/$USER/.ssh/authorized_keys

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
