#!/usr/bin/env bash

# Run database migrations
php artisan migrate --force

# Start PHP server
php artisan serve --host 0.0.0.0
