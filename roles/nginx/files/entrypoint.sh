#!/bin/bash

set -e

mkdir -p /etc/ssl
echo -n "$SSL_PASSWORD" > /etc/ssl/password

if [ -z "$(ls -A "$BELLARD_DIR")" ]; then
    cp -r /bellard/* "$BELLARD_DIR"
    rm -rf /bellard
fi

exec "$@"
