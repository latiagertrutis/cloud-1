FROM debian:11 AS unpack

RUN echo 'Acquire::Retries "100";' > /etc/apt/apt.conf.d/80-retries

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Redis cache
ADD https://downloads.wordpress.org/plugin/redis-cache.2.5.4.zip /
RUN unzip /redis-cache.2.5.4.zip -d / && rm -f /redis-cache.2.5.4.zip

# Wordpress site
ADD https://wordpress.org/wordpress-6.7.2.tar.gz /
RUN tar -C / -zxvf /wordpress-6.7.2.tar.gz && rm -f /wordpress-6.7.2.tar.gz


FROM debian:11

RUN echo 'Acquire::Retries "100";' > /etc/apt/apt.conf.d/80-retries

RUN apt-get update && apt-get install -y --no-install-recommends \
    php-fpm=2:7.4+76 \
    wget \
    ca-certificates \
    libfcgi-bin \
    php-mysqli \
    php-redis \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -O /php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /php-fpm-healthcheck

RUN mkdir -p /run/php

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

COPY www.conf /etc/php/7.4/fpm/pool.d/
COPY wp-config.php /
COPY adminer-4.8.1.php /
COPY --from=unpack /wordpress /wordpress
COPY --from=unpack /redis-cache /redis-cache

ENV WORDPRESS_DIR=/srv/www/wordpress
WORKDIR /srv/www/wordpress

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "php-fpm7.4", "-F" ]
