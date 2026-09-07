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

# Security floor for packages flagged by the container scanner. These arrive
# either from the upstream php:8.5.7-fpm-alpine3.23 image (openssl) or
# transitively via the apk add above (libexpat via python3/fontconfig,
# libblkid/libmount via glib, libuuid via libsm), and the published image had
# gone stale on all of them simply because it had not been rebuilt in months.
#
# A plain rebuild would in fact resolve these same versions on its own, since
# apk always picks the newest build in 3.23 main. The pins are therefore not
# what performs the upgrade - they are an explicit, reviewable floor: the
# versions are stated in this file instead of being an implicit function of the
# build date, and the build fails loudly if a target ever becomes unavailable
# rather than silently regressing. All targets come from Alpine 3.23 main, so
# musl and the ABI are untouched.
#
# Maintenance: raise these pins when a newer build lands in 3.23 main. If a pin
# ever breaks the build because Alpine dropped that exact release, raise it to
# the current version rather than deleting the block.
#   openssl/libssl3/libcrypto3/openssl-dev  -> 3.5.8-r0   (was 3.5.7-r0)
#   libexpat                                -> 2.8.4-r0   (was 2.8.2-r0)
#   libblkid/libmount/libuuid (util-linux)  -> 2.41.6-r1  (was 2.41.4-r0)
RUN apk add --no-cache \
        'openssl=3.5.8-r0' \
        'libssl3=3.5.8-r0' \
        'libcrypto3=3.5.8-r0' \
        'openssl-dev=3.5.8-r0' \
        'libexpat=2.8.4-r0' \
        'libblkid=2.41.6-r1' \
        'libmount=2.41.6-r1' \
        'libuuid=2.41.6-r1'

# curl/libcurl pinned to 8.22.0-r0. Originally added because the fix for
# CVE-2026-6276 / CVE-2026-5773 (curl 8.20.0) was only in edge/main; that fix has
# since reached Alpine 3.23 main, which now carries 8.22.0-r0 as well, so this
# block is no longer strictly required and is kept only to hold the exact
# version. Pulled via a one-shot --repository with an exact version pin: the
# version pin (not an @edge tag) forces the upgrade while leaving nothing in
# /etc/apk/world that would break later apk calls; only curl/libcurl come from
# edge, musl and the rest stay on 3.23. Drop this block to simply track 3.23
# main, or bump the pin when a newer curl is needed.
RUN apk add --no-cache \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
        'curl=8.22.0-r0' 'libcurl=8.22.0-r0'

WORKDIR /app
