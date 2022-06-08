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
        git \
        default-mysql-client \
        curl wget libicu-dev \
        zip unzip

RUN \
  # zip
  apt-get install -y --no-install-recommends libzip-dev && \
  docker-php-ext-configure zip && \
  docker-php-ext-install zip && \
  # others
  docker-php-ext-configure bcmath && \
  docker-php-ext-install bcmath pdo_mysql exif intl mysqli pcntl  && \
  # ldap
  apt-get install -y --no-install-recommends libldap2-dev libldb-dev && \
  ln -s /usr/lib/$(uname -m)-linux-gnu/libldap.so /usr/lib/libldap.so && \
  ln -s /usr/lib/$(uname -m)-linux-gnu/liblber.so /usr/lib/liblber.so && \
  docker-php-ext-configure ldap --with-libdir=lib/$(uname -m)-linux-gnu && \
  docker-php-ext-install ldap && \
  # gd
  apt-get install -y --no-install-recommends \
      libjpeg62-turbo-dev \
      libfreetype6-dev \
      libpng-dev \
      libmagickwand-dev && \
  docker-php-ext-configure gd --with-freetype --with-jpeg && \
  docker-php-ext-install gd

RUN \
  #
  # imagick
  apt-get install -y --no-install-recommends imagemagick && \
  pecl install imagick && \
  #
  # memcached
  apt-get install -y --no-install-recommends libmemcached-dev && \
  pecl install memcached && \
  #
  # apcu
  pecl install APCu && \
  #
  # redis
  pecl install redis && \
  #
  docker-php-ext-enable \
    apcu \
    memcached \
    imagick \
    redis

# https://docs.spatie.be/laravel-medialibrary/v8/installation-setup/#optimization-tools
RUN apt-get install -y --no-install-recommends jpegoptim optipng pngquant gifsicle

# Clean Packages
RUN apt-get remove -y libmemcached-dev libzip-dev libldap2-dev libfreetype6-dev libpng-dev libmagickwand-dev libjpeg62-turbo-dev && \
  rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite && \
    # create non-root user
    groupadd --gid 1000 noroot && \
    useradd --uid 1000 --gid noroot --shell /bin/bash --create-home noroot

RUN mkdir /app
RUN chown -R noroot:noroot /app
RUN chown -R noroot:noroot /home/noroot

WORKDIR /app
