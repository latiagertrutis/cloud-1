FROM alpine:3.21 as build

RUN mkdir /opt/app
RUN apk add --no-cache ansible

VOLUME /opt/app

ENTRYPOINT [ ]
CMD [ "ansible-playbook", "--help" ]