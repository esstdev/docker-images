FROM php:8.3-fpm-alpine3.19

RUN \
    # packages that need to be kept installed
    apk add --no-cache --update \
    imap-dev \
    libzip-dev \
    libmemcached-dev \
    libldap \
    icu-dev \
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
    ; \
    # virtual deps
    apk add --no-cache --virtual build-deps \
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
    ; \
    # PHP extensions
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
        mbstring \
        curl \
        zip \
    ; \
    pecl install \
        memcached \
        redis; \
    docker-php-ext-enable \
        memcached \
        redis;

# install imagick directly from master
# TODO: remove in future version? rely only in GD which is enough for our use-case
RUN git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick; \
    cd /tmp/imagick; \
    phpize; \
    ./configure; \
    make; \
    make install; \
    docker-php-ext-enable imagick;

RUN addgroup -g 1000 -S noroot; \
    adduser -u 1000 -S noroot -G noroot --home /home/noroot --shell /bin/bash; \
    adduser www-data noroot; \
    sed -i s/'user = www-data'/'user = noroot'/g /usr/local/etc/php-fpm.d/www.conf; \
    sed -i s/'group = www-data'/'group = noroot'/g /usr/local/etc/php-fpm.d/www.conf; \
    mkdir /app; \
    chown -R noroot:noroot /app /home/noroot;

RUN rm -rf /tmp/*; \
    apk del build-deps;

WORKDIR /app
