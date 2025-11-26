# Imagen base con PHP-FPM
FROM php:8.2-fpm

# Instalar dependencias del sistema necesarias para Laravel y Composer
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring gd

# Instalar Composer desde la imagen oficial
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Directorio de trabajo
WORKDIR /var/www/html

# Copiamos solo composer.* primero (para aprovechar la caché de Docker)
COPY composer.json composer.lock* ./

# Instalamos dependencias de PHP (puedes dejar con dev de momento)
RUN composer install --no-interaction --prefer-dist --no-progress

# Ahora copiamos el resto del código
COPY . .

# Permisos para Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
