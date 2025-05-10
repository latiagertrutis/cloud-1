#!/bin/bash

set -e

# Check mysql server is alive before starting
until mysqladmin ping --connect-timeout 1 --silent -u $MYSQL_MAIL_USER -p$MYSQL_MAIL_PASSWORD -h mariadb; do
    if (( $SECONDS > 60 )); then
	exit 1;
    fi
    sleep 1;
done

exec "$@"
