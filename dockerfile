# 1. BUILD STAGE (Gumagamit ng PHP-Apache base image)
FROM php:8.3-apache AS composer

# Install System Dependencies (para sa Composer, Node, at Extensions BUILD)
# Tiyaking ang apt-get update ay tumatakbo bago ang install.
RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    unzip \
    nodejs \
    npm \
    # 🚨 FIX PARA SA 'libpng' ERROR: KINAKAILANGAN NG GD EXTENSION
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    # Iba pang karaniwang kailangan
    libonig-dev

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . /var/www/html

# Run Composer installation
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs

# 🚨 I-INSTALL ANG PHP EXTENSIONS SA COMPOSER STAGE (Mas madaling i-build dito)
# FIX PARA SA 'could not find driver' (pdo_mysql)
RUN docker-php-ext-install pdo pdo_mysql zip opcache exif bcmath pcntl mbstring \
    # I-configure at I-install ang GD Extension (Gumagamit ng mga na-install na dev packages)
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# ----------------------------------------------------------------------------------------------------

# 2. APPLICATION STAGE (Ang Final, Optimized Image)
FROM php:8.3-apache AS final

# Copy code and vendor from build stage
WORKDIR /var/www/html
COPY --from=composer /var/www/html /var/www/html

# I-copy ang Composer executable (para sa artisan commands)
COPY --from=composer /usr/bin/composer /usr/bin/composer

# 🚨 Frontend Build (Vite/NPM)
# Node/NPM ay kasama na sa php:8.3-apache base image natin
RUN npm install
RUN npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 🚨 APACHE CONFIGURATION (FIX PARA SA 'No open HTTP ports')
# I-enable ang rewrite module
RUN a2enmod rewrite
# I-copy ang custom VHost config
# 🚨 MAHALAGA: Dapat may 000-default.conf file sa root folder mo!
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
# I-disable ang default VHost
RUN a2dissite 000-default.conf
# I-enable ang bagong config (optional, pero minsan kailangan)
RUN a2ensite 000-default.conf


# 🚨 COPY ENTRYPOINT SCRIPT (Para sa Migrations)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose standard HTTP port 80
EXPOSE 80

# Run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command (Ito ang magpapatakbo ng Apache)
CMD ["apache2-foreground"]
