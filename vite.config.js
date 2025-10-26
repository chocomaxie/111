import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.jsx'],
            refresh: true,
        }),
        tailwindcss(),
    ],
    resolve: {
        alias: {
            // Ito ay tumuturo sa resources/js folder (o resources folder mismo)
            '@': path.resolve(__dirname, 'resources/js'),
            '~': path.resolve(__dirname, 'resources'), // Maaari ding gamitin ang root resources
        },
    },
});
