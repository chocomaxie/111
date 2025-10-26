#!/bin/bash

# Run Laravel startup commands only at runtime, when ENV variables are available
php artisan key:generate
php artisan config:clear
php artisan package:discover --ansi
php artisan migrate --force

# Start the Apache server in the foreground
apache2-foreground
