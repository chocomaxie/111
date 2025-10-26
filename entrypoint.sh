#!/bin/bash

# --- PERMISSIONS FIX (Dagdag na layer ng security para sa write access) ---
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
# -------------------------------------------------------------------------

# Run Laravel startup commands only at runtime, when ENV variables are available
php artisan key:generate
php artisan config:clear
php artisan package:discover --ansi
php artisan migrate --force
php artisan optimize:clear

# Start the Apache server in the foreground
apache2-foreground
