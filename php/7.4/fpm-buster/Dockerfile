FROM php:7.4-fpm-buster

# System
RUN apt-get update && apt-get install -y --no-install-recommends \
        ghostscript \
        supervisor \
        cron \
        nano \
        gnupg \
        sudo \
        default-mysql-client \
        curl wget \
        zip unzip

# PHP ext
RUN \
  # ldap
  apt-get install -y --no-install-recommends libldap2-dev && \
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
  docker-php-ext-install ldap && \
  # zip
  apt-get install -y --no-install-recommends libzip-dev && \
  docker-php-ext-configure zip && \
  docker-php-ext-install zip && \
  # gd
  apt-get install -y --no-install-recommends \
      libjpeg62-turbo-dev \
      libfreetype6-dev \
      libpng-dev \
      libmagickwand-dev && \
  docker-php-ext-configure gd --with-freetype --with-jpeg && \
  docker-php-ext-install gd && \
  # others
  docker-php-ext-configure bcmath && \
  docker-php-ext-install bcmath pdo_mysql exif intl mysqli pcntl

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
  docker-php-ext-enable memcache && \
  # apcu
  pecl install apcu && \
  docker-php-ext-enable apcu && \
  # redis
  pecl install redis && \
  docker-php-ext-enable redis

# https://docs.spatie.be/laravel-medialibrary/v8/installation-setup/#optimization-tools
RUN apt-get install -y --no-install-recommends jpegoptim optipng pngquant gifsicle

# clean packages
RUN apt-get remove -y libmemcached-dev libzip-dev libldap2-dev libfreetype6-dev libpng-dev libmagickwand-dev libjpeg62-turbo-dev && \
  rm -rf /var/lib/apt/lists/*

# add non-root user
RUN groupadd --gid 1000 noroot && \
    useradd --uid 1000 --gid noroot --shell /bin/bash --create-home noroot && \
    adduser www-data noroot

# PHP config
RUN sed -i s/'user = www-data'/'user = noroot'/g /usr/local/etc/php-fpm.d/www.conf
RUN sed -i s/'group = www-data'/'group = noroot'/g /usr/local/etc/php-fpm.d/www.conf

RUN mkdir /app
RUN chown -R noroot:noroot /app
RUN chown -R noroot:noroot /home/noroot

WORKDIR /app