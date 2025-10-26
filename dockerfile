# Use PHP 8.1 CLI as the base image
FROM php:8.1-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    nodejs \
    npm

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy composer files only to leverage Docker cache
COPY composer.json composer.lock /app/

# Install dependencies without dev packages, optimize autoloader
RUN composer install --no-dev --optimize-autoloader

# Copy the rest of the application code
COPY . /app

# Optional: set permissions
RUN chown -R www-data:www-data /app

# Expose port if running a web server (if applicable)
EXPOSE 8000

# Command to run your app (for example, Laravel's artisan serve)
CMD ["php", "artisan", "serve", "--host=0.0.0.0"]
