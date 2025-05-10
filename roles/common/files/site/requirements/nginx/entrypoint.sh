#!/bin/bash

set -e

mkdir -p /etc/ssl
echo -n "$SSL_PASSWORD" > /etc/ssl/password

exec "$@"
