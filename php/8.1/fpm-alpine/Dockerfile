FROM php:8.1-fpm-alpine3.16

# packages that need to be kept installed
RUN apk add --no-cache --update \
    imap-dev \
    libzip-dev \
    libmemcached-dev \
    libldap \
    icu-dev \
    # bash \
    supervisor \
    ghostscript \
    imagemagick \
    libgomp \
    imagemagick-dev \
    libtool
    # sudo \
    # gnupg \
    # mysql-client
    # nano \
    # curl \
    # wget \
    # zip \
    # unzip

RUN apk add --no-cache --virtual build-deps \
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
        #curl \
        oniguruma-dev \
        # pcre-dev \
        # imagemagick-dev \
        # libwebp-dev \
        # gmp-dev \
    ; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-configure ldap; \
    docker-php-ext-configure zip --with-zip; \
    docker-php-ext-install -j "$(nproc)" \
        bcmath \
        exif \
        gd \
        intl \
        ldap \
        pcntl \
        pdo_mysql \
        xml \
        #soap \
        mbstring \
        #imap \
        curl \
        zip \
    ; \
    #pecl install APCu; \
    pecl install memcached; \
    pecl install redis; \
    pecl install imagick; \
    \
    docker-php-ext-enable \
        #apcu \
        memcached \
        imagick \
        redis; \
    \
    rm -rf /tmp/*; \
    apk del build-deps

RUN addgroup -g 1000 -S noroot; \
    adduser -u 1000 -S noroot -G noroot --home /home/noroot --shell /bin/bash; \
    adduser www-data noroot

RUN sed -i s/'user = www-data'/'user = noroot'/g /usr/local/etc/php-fpm.d/www.conf; \
    sed -i s/'group = www-data'/'group = noroot'/g /usr/local/etc/php-fpm.d/www.conf

RUN mkdir /app; \
    mkdir -p /home/noroot/logs; \
    chown noroot:noroot /app; \
    chown -R noroot:noroot /home/noroot;

WORKDIR /app
