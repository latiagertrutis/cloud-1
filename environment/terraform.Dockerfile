FROM alpine:3.21 AS build

RUN apk add --no-cache curl unzip
RUN curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/bin && \
    chmod +x /usr/bin/terraform

FROM python:3.14-rc-alpine

RUN mkdir -pv /opt/app
RUN apk add --no-cache curl
WORKDIR /opt/app/terraform

COPY --from=build /usr/bin/terraform /usr/bin/terraform
COPY . /opt/app/
RUN terraform init

VOLUME /opt/app

ENTRYPOINT ["terraform"]