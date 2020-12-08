FROM php:7.4-apache-buster

# ENVs
ENV APACHE_RUN_USER=noroot
ENV APACHE_RUN_GROUP=noroot

# System
RUN apt-get update && apt-get install -y --no-install-recommends \
        ghostscript \
        supervisor \
        cron \
        nano \
        gnupg \
        sudo \
        libfreetype6-dev \
        default-mysql-client \
        curl wget \
        zip unzip

# PHP ext
RUN \
    # ldap installation & configuration
    apt-get install -y --no-install-recommends libldap2-dev && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap && \
    # imagick installation & configuration
    apt-get install -y --no-install-recommends \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmagickwand-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd && \
    # zip configuration
    apt-get install -y --no-install-recommends libzip-dev && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip && \
    # other extensions
    docker-php-ext-configure bcmath && \
    docker-php-ext-install bcmath pdo_mysql exif exif intl mysqli pcntl

# PECL
RUN \
    # imagick
    apt-get install -y --no-install-recommends \
        imagemagick && \
    pecl install imagick && \
    docker-php-ext-enable imagick && \
    # memcached
    apt-get install -y --no-install-recommends libmemcached-dev && \
    pecl install memcached-3.1.5 && \
    docker-php-ext-enable memcached && \
    # memcache
    pecl install memcache-4.0.5.2 && \
    docker-php-ext-enable memcache

# clean packages
RUN apt-get remove -y libmemcached-dev libzip-dev libfreetype6-dev libpng-dev libmagickwand-dev libjpeg62-turbo-dev && \
    rm -rf /var/lib/apt/lists/*

# apache config
RUN a2enmod rewrite

# add non-root user
RUN groupadd --gid 1000 noroot && \
    useradd --uid 1000 --gid noroot --shell /bin/bash --create-home noroot

RUN mkdir /app
RUN chown -R noroot:noroot /app
RUN chown -R noroot:noroot /home/noroot

WORKDIR /app