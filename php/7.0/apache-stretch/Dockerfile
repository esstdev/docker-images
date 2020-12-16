FROM php:7.0-apache-stretch

ENV APACHE_RUN_USER noroot
ENV APACHE_RUN_GROUP noroot

# create non-root user
RUN groupadd --gid 1000 noroot && \
    useradd --uid 1000 --gid noroot --shell /bin/bash --create-home noroot

RUN apt-get update && \
    apt-get -y install \
            gnupg \
            sudo \
            curl \
            cron \
            zip \
            unzip \
            nano \
            libzip-dev \
            imagemagick \
            libpng-dev \
            libjpeg-dev \
            libmagickwand-dev \
            mysql-client \
        --no-install-recommends

RUN echo '3.4.3' | pecl install imagick-3.4.3 && docker-php-ext-enable imagick

RUN docker-php-ext-install opcache && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
	    --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install \
        zip \
        bcmath \
        exif \
        gd \
        intl \
        pdo_mysql \
        mysqli \
        pcntl && \
    rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

RUN mkdir /app
RUN mkdir /home/noroot/log
RUN chown -R noroot:noroot /app
RUN chown -R noroot:noroot /home/noroot

WORKDIR /app
