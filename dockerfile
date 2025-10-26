# Base image: PHP 8.2 with Apache
FROM php:8.2-apache

# Install System Dependencies
RUN apt-get update && apt-get install -y \
    git \
    libpq-dev \
    libonig-dev \
    zip \
    unzip \
    libzip-dev

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js (v18)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Copy ang lahat ng files sa loob ng container
COPY . /var/www/html

# I-set ang work directory
WORKDIR /var/www/html

# Install Composer dependencies (Gamit ang --no-scripts fix)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# I-run ang Node/Vite build (ANG BAGONG FIX DITO: --legacy-peer-deps)
RUN npm install --legacy-peer-deps && npm run build

# I-set ang tamang permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Direktang i-create ang Apache config sa loob ng Docker
RUN a2dissite 000-default.conf
RUN a2enmod rewrite
RUN echo "<VirtualHost *:80>\n" > /etc/apache2/sites-available/001-laravel.conf && \
    echo "    DocumentRoot /var/www/html/public\n" >> /etc/apache2/sites-available/001-laravel.conf && \
    echo "    <Directory /var/www/html/public>\n" >> /etc/apache2/sites-available/001-laravel.conf && \
    echo "        Options Indexes FollowSymLinks\n" >> /etc/apache2/sites-available/001-laravel.conf && \
    echo "        AllowOverride All\n" >> /etc/apache2/sites-available/001-laravel.conf && \
    echo "        Require all granted\n" >> /etc/apache2/sites-available/001-laravel.conf && \
    echo "    </Directory>\n" >> /etc/apache2/sites-available/001-laravel.conf && \
    echo "</VirtualHost>" >> /etc/apache2/sites-available/001-laravel.conf
RUN a2ensite 001-laravel.conf

# Linisin ang cache
# RUN php artisan optimize:clear

# Copy entrypoint script at gawin itong executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# CMD: Gamitin ang script para patakbuhin ang lahat ng startup commands
CMD ["entrypoint.sh"]
