# Stage 1
FROM php:8.3-fpm-alpine3.19 AS builder

RUN apk add --no-cache --update \
        $PHPIZE_DEPS \
        git \
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
        imap-dev \
        libzip-dev \
        libmemcached-dev \
        libldap \
        icu-dev \
        imagemagick \
        libgomp \
        imagemagick-dev \
        libtool \
        libcurl \
        curl \
        linux-headers \
    \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap \
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install -j "$(nproc)" \
        bcmath \
        exif \
        gd \
        intl \
        ldap \
        pcntl \
        pdo_mysql \
        xml \
        mbstring \
        curl \
        zip \
        sockets \
    && pecl install \
        memcached \
        redis \
        #swoole \
    && docker-php-ext-enable \
        memcached \
        redis \
        #swoole \
    \
    && git clone --depth 1 https://github.com/Imagick/imagick.git /tmp/imagick \
    && cd /tmp/imagick \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable imagick \
    \
    && rm -rf /tmp/*

# Final stage
FROM php:8.3-fpm-alpine3.19

COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-* /usr/local/lib/php/extensions/tmp

RUN \
    # copy extensions from builder
    extensions_dir=$(ls -d /usr/local/lib/php/extensions/no-debug-non-zts-*/); \
    cp -R /usr/local/lib/php/extensions/tmp/* "$extensions_dir"; \
    # install required dependencies
    apk add --no-cache --update \
        imap-dev \
        libzip-dev \
        libmemcached-dev \
        libldap \
        bash \
        supervisor \
        ghostscript \
        imagemagick \
        libgomp \
        imagemagick-dev \
        libtool \
        libcurl \
        curl \
        tar \
    \
    && addgroup -g 1000 -S noroot \
    && adduser -u 1000 -S noroot -G noroot --home /home/noroot --shell /bin/bash \
    && adduser www-data noroot \
    && sed -i 's/user = www-data/user = noroot/' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's/group = www-data/group = noroot/' /usr/local/etc/php-fpm.d/www.conf \
    && mkdir /app \
    && chown -R noroot:noroot /app /home/noroot \
    && docker-php-ext-enable \
        bcmath \
        exif \
        gd \
        intl \
        ldap \
        pcntl \
        pdo_mysql \
        xml \
        mbstring \
        curl \
        zip \
        memcached \
        redis \
        imagick \
        sockets
        #swoole

WORKDIR /app
