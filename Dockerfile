# Etapa 1: Construcción
FROM php:8.2-fpm as build

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos de dependencias
COPY composer.json composer.lock ./

# Instalar dependencias de PHP (sin dev)
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Copiar el resto de la aplicación
COPY . .

# Generar clave de aplicación y optimizar
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Etapa 2: Producción
FROM php:8.2-fpm

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    nginx \
    supervisor \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar archivos desde la etapa de build
WORKDIR /var/www/html
COPY --from=build /var/www/html /var/www/html

# Copiar configuración de nginx
COPY docker/nginx/default.conf /etc/nginx/sites-available/default

# Copiar configuración de supervisor
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Establecer permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer puerto
EXPOSE 80

# Comando de inicio
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
