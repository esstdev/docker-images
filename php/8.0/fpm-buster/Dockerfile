FROM php:8.0-fpm-buster

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
  apt-get install -y --no-install-recommends libldap2-dev && \
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
  docker-php-ext-install ldap && \
  # gd
  apt-get install -y --no-install-recommends \
      libjpeg62-turbo-dev \
      libfreetype6-dev \
      libpng-dev \
      libmagickwand-dev && \
  docker-php-ext-configure gd --with-freetype --with-jpeg && \
  docker-php-ext-install gd

# Pickle
RUN curl -L -o /usr/local/bin/pickle https://github.com/FriendsOfPHP/pickle/releases/download/v0.6.0/pickle.phar \
	&& chmod +x /usr/local/bin/pickle

RUN \
  #
  # imagick
  apt-get install -y --no-install-recommends imagemagick && \
  cd /tmp && \
  git clone https://github.com/Imagick/imagick && \
  cd imagick && \
  phpize && \
  ./configure && \
  make && \
  make install && \
  echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini && \
  rm -rf /tmp/* && \
  cd && \
  #docker-php-ext-enable imagick && \
  #pickle install imagick && \
  #
  # memcached
  apt-get install -y --no-install-recommends libmemcached-dev && \
  pickle install memcached && \
  docker-php-ext-enable memcached && \
  #
  # memcache
  # pickle install memcache && \
  # docker-php-ext-enable memcache && \
  #
  # apcu
  pickle install apcu && \
  docker-php-ext-enable apcu && \
  #
  # redis
  pickle install redis && \
  docker-php-ext-enable redis

# https://docs.spatie.be/laravel-medialibrary/v8/installation-setup/#optimization-tools
RUN apt-get install -y --no-install-recommends jpegoptim optipng pngquant gifsicle

# Clean Packages
RUN apt-get remove -y libmemcached-dev libzip-dev libldap2-dev libfreetype6-dev libpng-dev libmagickwand-dev libjpeg62-turbo-dev && \
  rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN groupadd --gid 1000 noroot && \
    useradd --uid 1000 --gid noroot --shell /bin/bash --create-home noroot && \
    adduser www-data noroot

# PHP Config
RUN sed -i s/'user = www-data'/'user = noroot'/g /usr/local/etc/php-fpm.d/www.conf
RUN sed -i s/'group = www-data'/'group = noroot'/g /usr/local/etc/php-fpm.d/www.conf

RUN mkdir /app
RUN chown -R noroot:noroot /app
RUN chown -R noroot:noroot /home/noroot

WORKDIR /app
