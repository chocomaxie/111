#!/bin/bash

# --- PERMISSIONS FIX ---
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
# -----------------------

# Run Laravel startup commands
php artisan key:generate
php artisan cache:clear
php artisan view:clear
php artisan config:clear
php artisan package:discover --ansi
php artisan migrate --force
php artisan optimize:clear

# Start the Apache server
apache2-foreground
