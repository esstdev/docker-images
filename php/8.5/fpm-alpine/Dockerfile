# Stage 1
FROM php:8.5-fpm-alpine3.22 AS builder

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
        libmemcached-dev \
        libpng-dev \
        libtool \
        libxml2-dev \
        libzip-dev \
        linux-headers \
        oniguruma-dev \
        openldap-dev \
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
        opcache \
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
    #&& git clone --depth 1 https://github.com/Imagick/imagick.git /tmp/imagick \
    #&& cd /tmp/imagick \
    #&& phpize \
    #&& ./configure \
    #&& make \
    #&& make install \
    #&& docker-php-ext-enable imagick \
    #\
    && rm -rf /tmp/*

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN IPE_ICU_EN_ONLY=1 install-php-extensions \
    Imagick/imagick@65e27f2bc0

# Final stage
FROM php:8.5-fpm-alpine3.22

COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-* /usr/local/lib/php/extensions/tmp

RUN \
    # copy extensions from builder
    extensions_dir=$(ls -d /usr/local/lib/php/extensions/no-debug-non-zts-*/); \
    cp -R /usr/local/lib/php/extensions/tmp/* "$extensions_dir"; \
    # install required dependencies
    apk add --no-cache --update \
        bash \
        curl \
        imagemagick \
        imagemagick-pdf \
        libldap \
        libzip \
        libmemcached \
        libtool \
        libgomp \
        supervisor \
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
        opcache \
        sockets
        #swoole

WORKDIR /app
