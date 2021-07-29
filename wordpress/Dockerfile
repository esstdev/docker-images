FROM wordpress:5.8-php7.4-apache

ENV APACHE_RUN_USER=noroot
ENV APACHE_RUN_GROUP=noroot

RUN groupadd --gid 1000 noroot && \
    useradd --uid 1000 --gid noroot --shell /bin/bash --create-home noroot

RUN echo "ServerSignature Off" | tee -a /etc/apache2/apache2.conf && \
    echo "ServerTokens Prod" | tee -a /etc/apache2/apache2.conf

# PHP ini
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN touch /usr/local/etc/php/conf.d/docker-php-ext-app.ini && \
    { \
        echo "max_execution_time=60"; \
        echo "post_max_size=20M"; \
        echo "upload_max_filesize=100M"; \
        echo "memory_limit=256M"; \
        echo "expose_php=off"; \
    } | tee -a /usr/local/etc/php/conf.d/docker-php-ext-app.ini
