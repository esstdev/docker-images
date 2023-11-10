FROM esst/php:8.2-fpm-alpine

RUN apk del icu-data-en

RUN apk add --update --no-cache \
    nginx \
    brotli \
    nginx-mod-http-brotli \
    icu-dev \
    icu-libs \
    icu-data-full
