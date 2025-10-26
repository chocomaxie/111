// vite.config.js

import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';
// 🚨 TANGGALIN: import path from 'path';

export default defineConfig({
    plugins: [
        laravel({
            input: 'resources/js/app.jsx',
            refresh: true,
        }),
        react(),
    ],
    // 🚨 TANGGALIN ANG BUONG RESOLVE BLOCK DITO
});
