# 1. BUILD STAGE (Gumamit ng PHP-Apache base)
FROM php:8.3-apache AS composer

# Install System Dependencies (para sa Composer at Extensions)
RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    unzip \
    nodejs \
    npm

# Install PHP Extensions
# 🚨 I-INSTALL ANG DRIVER NA NAG-CA-CAUSE NG 'could not find driver' ERROR
RUN docker-php-ext-install pdo pdo_mysql zip opcache gd exif bcmath pcntl

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . /var/www/html

# Run Composer installation
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs

# ----------------------------------------------------------------------------------------------------

# 2. APPLICATION STAGE (Ang Final Image)
FROM php:8.3-apache AS final

# Install Node.js (Kung hindi mo ito ginawa sa base image)
RUN apt-get update && apt-get install -y nodejs npm

# Copy code and vendor from build stage
WORKDIR /var/www/html
COPY --from=composer /var/www/html /var/www/html

# 🚨 Frontend Build (Vite/NPM)
RUN npm install
RUN npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# 🚨 I-SET ANG APACHE DOCUMENT ROOT (Kung hindi pa na-set up ang virtual host)
# Tiyakin na ang Apache ay tumuturo sa public folder ng Laravel
RUN a2enmod rewrite
# Create virtual host config for Laravel's public folder
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
# Note: Kailangan mo ring i-create ang '000-default.conf' file na ito sa baba.

# 🚨 COPY ENTRYPOINT SCRIPT
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 🚨 EXPOSE standard HTTP port 80
EXPOSE 80

# 🚨 RUN THE ENTRYPOINT SCRIPT BAGO SIMULAN ANG APACHE
# Ito ay tumatakbo at mag-mi-migrate, pagkatapos ay ipapasa ang control sa Apache.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# 🚨 Ang default command ng php:apache image ay magpapatakbo ng Apache
CMD ["apache2-foreground"]
