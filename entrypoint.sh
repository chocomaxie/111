#!/bin/bash

# Run Laravel startup commands only at runtime
# Tiyakin ang tamang permission bago mag-run ng Artisan commands
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

php artisan key:generate
php artisan config:clear
php artisan package:discover --ansi
php artisan migrate --force
php artisan optimize:clear

# Start the Apache server in the foreground
apache2-foreground
