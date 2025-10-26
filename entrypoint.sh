#!/bin/sh

# 1. Wait for the database container to be ready (optional but recommended)
echo "Waiting for database to be ready..."
# (Kung gumagamit ka ng healthcheck or wait-for-it tool, ilagay dito)

# 2. Clear caches and optimize configuration (optional, but good practice)
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 3. RUN DATABASE MIGRATIONS (Ang pinaka-importante)
echo "Running database migrations..."
# --force: Kailangan ito para tumakbo ang migration sa production environment
php artisan migrate --force

# 4. Storage Link (Kung hindi pa ito naka-link)
echo "Creating storage link..."
php artisan storage:link

# 5. Run the main command (e.g., start PHP-FPM or Apache)
echo "Starting application..."
exec "$@"
# Halimbawa, kung ang CMD sa Dockerfile mo ay 'php-fpm' or 'apache2-foreground'
