#!/bin/bash

set -e

# Move wordpress files in run time
if [ -z "$(ls -A "$WORDPRESS_DIR")" ]; then
    cp -r /wordpress/. "$WORDPRESS_DIR"
    cp /wp-config.php "$WORDPRESS_DIR/"
    cp /adminer-4.8.1.php "$WORDPRESS_DIR/"
    mkdir -p "$WORDPRESS_DIR/wp-content/mu-plugins"
    cp -r /redis-cache/. "$WORDPRESS_DIR/wp-content/mu-plugins/"
    # Make wp-contet owned by wordpress so plugins can write
    chown -R www-data:www-data /srv/www/wordpress/wp-content
fi

exec "$@"
