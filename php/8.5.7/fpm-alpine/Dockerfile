# Stage 1
FROM php:8.5.7-fpm-alpine3.23 AS builder

RUN apk add --no-cache --update \
        autoconf \
        curl \
        curl-dev \
        freetype-dev \
        git \
        icu-dev \
        imagemagick \
        imagemagick-dev \
        imap-dev \
        libcurl \
        libevent-dev \
        libgomp \
        libjpeg-turbo-dev \
        libldap \
        libmcrypt-dev \
        #libmemcached-dev \
        libpng-dev \
        libtool \
        libxml2-dev \
        libzip-dev \
        linux-headers \
        oniguruma-dev \
        openldap-dev \
        openssl-dev \
        $PHPIZE_DEPS \
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
        #opcache \
        sockets \
    #&& pecl install \
        #memcached \
        #redis \
        #swoole \
    #&& docker-php-ext-enable \
        #memcached \
        #redis \
        #swoole \
    #\
    #&& git clone --depth 1 https://github.com/Imagick/imagick.git /tmp/imagick \
    #&& cd /tmp/imagick \
    #&& phpize \
    #&& ./configure \
    #&& make \
    #&& make install \
    #&& docker-php-ext-enable imagick \
    #\
    && rm -rf /tmp/*

COPY --from=ghcr.io/php/pie:bin /pie /usr/bin/pie
RUN pie install imagick/imagick:dev-master
RUN pie install phpredis/phpredis

# Final stage
FROM php:8.5.7-fpm-alpine3.23

COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-* /usr/local/lib/php/extensions/tmp

RUN \
    # copy extensions from builder \
    extensions_dir=$(ls -d /usr/local/lib/php/extensions/no-debug-non-zts-*/); \
    cp -R /usr/local/lib/php/extensions/tmp/* "$extensions_dir"; \
    # install required dependencies \
    apk add --no-cache --update \
        bash \
        curl \
        icu-libs \
        imagemagick \
        imagemagick-pdf \
        libldap \
        libzip \
        #libmemcached \
        libtool \
        libgomp \
        supervisor \
        openssl-dev \
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
        #memcached \
        redis \
        imagick \
        #opcache \
        sockets
        #swoole

# Security upgrade: curl/libcurl 8.20.0 fixes CVE-2026-6276 and CVE-2026-5773.
# The fix is not yet in Alpine 3.23 main, so pull just these two packages from
# edge/main via a one-shot --repository with an exact version pin. Using a
# version pin (not an @edge tag) forces the upgrade while leaving nothing in
# /etc/apk/world that would break later apk calls; only curl/libcurl come from
# edge, musl and the rest stay on 3.23. Bump the pin when edge moves past
# 8.21.0-r0, and remove this block once the fix lands in Alpine 3.23 main.
RUN apk add --no-cache \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
        'curl=8.21.0-r0' 'libcurl=8.21.0-r0'

WORKDIR /app
