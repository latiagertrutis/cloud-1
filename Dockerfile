FROM alpine:3.21

WORKDIR /opt/ansible
RUN apk add --no-cache python3 bash openssh && \
    pip install ansible

VOLUME /root/.ssh/
VOLUME /opt/ansible

ENTRYPOINT []
CMD ["ansible", "--help"]
