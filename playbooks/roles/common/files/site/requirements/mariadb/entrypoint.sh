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

echo "Initializating temporal mariaDB server..."
mysqld --skip-networking --socket=/tmp/mariadbd.socket &

max_retries=10
while ! mariadb --socket=/tmp/mariadbd.socket -e "SELECT 1+1" >/dev/null; do
    if ((max_retries == 0)); then
        echo "mariaDB failed to start, exiting..." >&2
        exit 1
    fi
    ((max_retries--))
    echo "Waiting on mariaDB temporal server to start..."
    sleep 3
done

echo "Installing Wordpress database..."
mysql -u root --socket=/tmp/mariadbd.socket < /tmp/wordpress.sql

echo "Shutting down temporal mariaDB server..."
mysqladmin --socket=/tmp/mariadbd.socket shutdown

exec "$@"
