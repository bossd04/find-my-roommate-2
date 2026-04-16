FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip \
    && docker-php-ext-install zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer install

# Fix permissions
RUN chmod -R 775 storage bootstrap/cache

# Laravel cache fix
RUN php artisan config:clear
RUN php artisan cache:clear
RUN php artisan config:cache

EXPOSE 10000

CMD php -S 0.0.0.0:10000 -t public