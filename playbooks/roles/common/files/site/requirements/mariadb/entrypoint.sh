#!/bin/bash

set -e

# Create init file with environment variables credentials
cat <<EOF > /etc/mysql/init.sql
CREATE DATABASE IF NOT EXISTS wordpress;
-- Format is user@hostname.network_name. Network name appears here since we are using docker.

-- Wordpress user
USE wordpress;

CREATE USER IF NOT EXISTS '$MYSQL_USER'@'wordpress.$NETWORK_NAME' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON wordpress.* TO '$MYSQL_USER'@'wordpress.$NETWORK_NAME';

-- Admin user
CREATE USER IF NOT EXISTS '$MYSQL_ROOT_USER'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_ROOT_USER'@'%' WITH GRANT OPTION;
EOF

# Needed because of volume mounting
mariadb-install-db

exec "$@"
