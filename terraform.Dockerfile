FROM alpine:3.21

RUN mkdir -pv /opt/terraform
WORKDIR /opt/terraform

RUN apk add --no-cache curl unzip
RUN curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip
RUN unzip /tmp/terraform.zip -d /usr/bin/terraform

VOLUME /opt/loadbalance

CMD terraform init