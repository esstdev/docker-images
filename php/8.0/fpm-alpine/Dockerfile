FROM php:8.0-fpm-alpine3.13

RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        autoconf \
        freetype-dev \
        icu-dev \
        # libevent-dev \
        libjpeg-turbo-dev \
        # libmcrypt-dev \
        libpng-dev \
        libmemcached-dev \
        libxml2-dev \
        libzip-dev \
        openldap-dev \
        # pcre-dev \
        # postgresql-dev \
        # imagemagick-dev \
        # libwebp-dev \
        # gmp-dev \
        ghostscript \
        supervisor \
        # nano \
        gnupg \
        mysql-client \
        curl \
        # wget \
        # zip \
        # unzip \
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
        zip; \
    \
    # pecl install APCu-5.1.20; \
    pecl install memcached; \
    pecl install redis; \
    \
    docker-php-ext-enable \
        #apcu \
        memcached \
        redis; \
    \
    rm -rf /tmp/*; \
    apk del .build-deps

# https://gist.github.com/SoftCreatR/d3393d918407f0f9177f88147832e925
ENV PHPIZE_DEPS \
    git \
    make \
    gcc \
    g++ \
    zlib-dev \
    php8-dev
ENV VERSION_OS='3.12'
RUN set -eux; \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    apk add --no-cache \
        imagemagick \
        imagemagick-dev && \
    rm -rf /var/cache/apk/* && \
    cd /tmp && \
    git clone https://github.com/Imagick/imagick && \
    cd imagick && \
    git checkout master && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini && \
    rm -rf /tmp/* && \
    apk del .build-deps

# noroot user
ENV USER noroot
ENV HOME /home/$USER

RUN apk add --update sudo

RUN adduser -D $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

RUN mkdir /app; \
    chown -R noroot:noroot /app; \
    rm -rf /tmp/*

VOLUME /app