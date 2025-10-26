# 1. BUILD STAGE (Para i-install ang Composer dependencies)
FROM php:8.3-fpm-alpine AS composer

# Install Composer dependencies at iba pang kailangan
RUN apk add --no-cache git libzip-dev
RUN docker-php-ext-install zip

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy application code
COPY . /app

# Run Composer installation
# --ignore-platform-reqs para maiwasan ang PHP version conflicts sa local machine at container
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs

# ----------------------------------------------------------------------------------------------------

# 2. APPLICATION STAGE (Ang Final, Slim Image)
FROM php:8.3-fpm-alpine AS final

# Install System Dependencies: Git, Node.js (para sa Vite/NPM build)
RUN apk add --no-cache \
    git \
    nodejs \
    npm \
    # 🚨 I-INSTALL ANG PHP EXTENSIONS (MAHALAGA PARA SA DATABASE CONNECTION)
    php-pdo \
    php-pdo_mysql \
    # Iba pang karaniwang kailangan sa Laravel/PHP
    php-dom \
    php-xml \
    php-zip \
    php-gd \
    php-json \
    php-mbstring \
    php-fileinfo

# Set working directory
WORKDIR /var/www/html

# Copy application files (excluding node_modules/vendor)
COPY --from=composer /app /var/www/html

# Copy Composer vendor files
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy Vendor dependencies from the build stage
COPY --from=composer /app/vendor /var/www/html/vendor

# 🚨 Frontend Build (Vite/NPM)
# Install frontend dependencies (Gumamit ng npm install na walang --legacy-peer-deps para ma-force ang clean install)
RUN npm install
# Run Vite build
RUN npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 🚨 COPY ENTRYPOINT SCRIPT
# Tiyakin na ang entrypoint.sh ay nandoon sa root ng iyong project
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port (Kung saan nakikinig ang FPM)
EXPOSE 9000

# Run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command (Ito ang huling command na tatakbo pagkatapos ng entrypoint)
CMD ["php-fpm"]
