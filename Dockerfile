FROM alpine:3.21

WORKDIR /opt/ansible
RUN apk add --no-cache python3 bash openssh py-pip
RUN python -m venv .venv && \
    source ./.venv/bin/activate && \
    pip install ansible
RUN echo "PATH=$PATH:/opt/ansible/.venv/bin"

VOLUME /root/.ssh/
VOLUME /opt/ansible

ENTRYPOINT []
CMD ["bash", "-c", "ansible --help"]
