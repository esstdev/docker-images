FROM php:8.0-fpm-alpine3.14

RUN set -ex

# packages that need to be kept installed
RUN apk add --no-cache --update \
    imap-dev \
    libzip-dev \
    libmemcached-dev \
    libldap \
    icu-dev \
    sudo \
    bash \
    supervisor \
    ghostscript
    # gnupg \
    # mysql-client
    # nano \
    # curl \
    # wget \
    # zip \
    # unzip

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        autoconf \
        freetype-dev \
        libevent-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        openldap-dev \
        curl-dev \
        oniguruma-dev \
        # pcre-dev \
        # imagemagick-dev \
        # libwebp-dev \
        # gmp-dev \
    ; \
    \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-configure ldap; \
    docker-php-ext-install -j "$(nproc)" \
        bcmath \
        exif \
        gd \
        intl \
        ldap \
        pcntl \
        pdo_mysql \
        xml \
        soap \
        mbstring \
        imap \
        curl \
        sockets \
        zip; \
    \
    pecl install APCu; \
    pecl install memcached; \
    pecl install redis; \
    \
    docker-php-ext-enable \
        apcu \
        memcached \
        redis; \
    \
    rm -rf /tmp/*; \
    apk del .build-deps

# temporary solution, waiting for imagick to be released officially
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions imagick && \
    rm -rf /usr/bin/install-php-extensions

RUN rm -rf /tmp/*

RUN addgroup -g 1000 -S noroot && \
    adduser -u 1000 -S noroot -G noroot --home /home/noroot --shell /bin/bash

RUN adduser www-data noroot

RUN sed -i s/'user = www-data'/'user = noroot'/g /usr/local/etc/php-fpm.d/www.conf
RUN sed -i s/'group = www-data'/'group = noroot'/g /usr/local/etc/php-fpm.d/www.conf

RUN mkdir /home/noroot; \
    chown -R noroot:noroot /home/noroot;

RUN mkdir /app; \
    chown -R noroot:noroot /app;

WORKDIR /app
