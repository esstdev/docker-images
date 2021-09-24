FROM esst/php:7.0-apache-stretch

ENV APACHE_RUN_USER=noroot
ENV APACHE_RUN_GROUP=noroot

RUN ln -snf /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime && echo Europe/Luxembourg > /etc/timezone

RUN echo "ServerSignature Off" | tee -a /etc/apache2/apache2.conf && \
    echo "ServerTokens Prod" | tee -a /etc/apache2/apache2.conf

COPY ./_internal/CRM/entrypoint.sh /entrypoint.sh
COPY ./_internal/CRM/crontab /var/spool/cron/crontabs/noroot
COPY ./_internal/CRM/apache.conf /etc/apache2/sites-available/000-default.conf

RUN crontab -u noroot /var/spool/cron/crontabs/noroot
RUN chmod +x /entrypoint.sh

# PHP ini
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN touch /usr/local/etc/php/conf.d/docker-php-ext-app.ini && \
    { \
        echo "max_execution_time=60"; \
        echo "post_max_size=20M"; \
        echo "upload_max_filesize=20M"; \
        echo "memory_limit=126M"; \
        echo "expose_php=Off"; \
    } | tee -a /usr/local/etc/php/conf.d/docker-php-ext-app.ini

# Opcache
RUN { \
        echo "opcache.enable=0"; \
        echo "opcache.enable_cli=0"; \
        echo "opcache.fast_shutdown=1"; \
        echo "opcache.validate_timestamps=0"; \
        echo "opcache.memory_consumption=2048"; \
        echo "opcache.max_accelerated_files=10000"; \
        echo "opcache.revalidate_freq=0"; \
        echo "opcache.interned_strings_buffer=128"; \
    } | tee -a /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

RUN mkdir -p /home/noroot/log
RUN chown -R noroot:noroot /home/noroot
RUN mkdir -p /app
RUN chown -R noroot:noroot /app

CMD ["/entrypoint.sh"]
