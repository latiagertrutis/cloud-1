FROM alpine:3.21

RUN mkdir -pv /opt/terraform
WORKDIR /opt/terraform

RUN apk add --no-cache curl unzip
RUN curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/bin && \
    chmod +x /usr/bin/terraform

VOLUME /opt/terraform

CMD terraform init