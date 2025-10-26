// resources/js/app.jsx

import React from 'react';
import './bootstrap';
import '../css/app.css';

// 🚨 BAGO: createInertiaApp ang gamitin, hindi App component
import { createInertiaApp } from '@inertiajs/react';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';

createInertiaApp({
    // Siguraduhin na ang title ay nasa inyong pages
    title: (title) => title ? `${title} - Your App Name` : 'Your App Name',

    resolve: (name) => resolvePageComponent(`./Pages/${name}.jsx`, import.meta.glob('./Pages/**/*.jsx')),

    setup({ el, App, props }) {
        return createRoot(el).render(<App {...props} />);
    },
});

import { createRoot } from 'react-dom/client';
