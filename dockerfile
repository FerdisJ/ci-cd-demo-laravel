# Imagen base con PHP y extensiones típicas
FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias de PHP
RUN composer install --no-dev --optimize-autoloader

# Dar permisos a storage y bootstrap
RUN chown -R www-data:www-data storage bootstrap/cache

# Puerto (si luego usas nginx, este no hace falta, pero no molesta)
EXPOSE 9000

# Comando por defecto
CMD ["php-fpm"]
