#!/bin/bash

set -e

mkdir -p /var/run/vsftpd/empty

if ! id -u "$FTP_USER" &>/dev/null; then
    adduser --disabled-login --no-create-home --gecos "" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

exec "$@"
