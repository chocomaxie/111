# Base image: PHP 8.2 with Apache
FROM php:8.2-apache

# Install System Dependencies (para sa git, zip, atbp.)
RUN apt-get update && apt-get install -y \
    git \
    libpq-dev \
    libonig-dev \
    zip \
    unzip \
    libzip-dev

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js (v18) para sa React/Vite build
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Copy ang lahat ng files sa loob ng container
COPY . /var/www/html

# I-set ang work directory
WORKDIR /var/www/html

# Install Composer dependencies (Tandaan: Ginamit ang --no-scripts para iwasan ang error)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# I-run ang Node/Vite build para sa React/Inertia assets
RUN npm install && npm run build

# I-set ang tamang permissions para makapagsulat ang storage
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# I-disable ang default VirtualHost at i-enable ang rewrite module
RUN a2dissite 000-default.conf
RUN a2enmod rewrite

# Gumawa ng custom VirtualHost config at i-enable ito
# (Ang file na ito ay nasa Section 2)
COPY docker/001-laravel.conf /etc/apache2/sites-available/
RUN a2ensite 001-laravel.conf

# Linisin ang cache (opsyonal, pero makakatulong)
RUN php artisan optimize:clear

# CMD: Hindi na tayo magpapatakbo ng server dito. Hahayaan natin ang Render Start Command.
CMD ["/bin/true"]
