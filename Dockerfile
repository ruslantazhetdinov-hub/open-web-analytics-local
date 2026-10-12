ARG OWA_VERSION=1.14.0
FROM php:8.3-apache

ARG OWA_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl libfreetype6-dev libicu-dev libjpeg62-turbo-dev libpng-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" gd intl mysqli opcache zip \
    && a2enmod rewrite headers expires \
    && sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf \
    && curl -fsSL "https://github.com/Open-Web-Analytics/Open-Web-Analytics/releases/download/${OWA_VERSION}/owa_${OWA_VERSION}_packaged.tar" \
       -o /tmp/owa.tar \
    && tar -xf /tmp/owa.tar -C /var/www/html \
    && rm -f /tmp/owa.tar \
    && mkdir -p /var/www/html/owa-data \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/owa-entrypoint
RUN chmod +x /usr/local/bin/owa-entrypoint

WORKDIR /var/www/html
ENTRYPOINT ["owa-entrypoint"]
CMD ["apache2-foreground"]

