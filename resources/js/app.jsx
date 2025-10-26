// resources/js/app.jsx

import React from 'react';
import './bootstrap';
import '../css/app.css';

// 🚨 UPDATED FOR INERTIA V1
import { createInertiaApp } from '@inertiajs/react';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { createRoot } from 'react-dom/client';

createInertiaApp({
    title: (title) => title ? `${title} - Your App Name` : 'Your App Name',

    // Tiyakin na ang path ay tama at ang extension ay .jsx o .tsx
    resolve: (name) => resolvePageComponent(`./Pages/${name}.jsx`, import.meta.glob('./Pages/**/*.jsx')),

    setup({ el, App, props }) {
        return createRoot(el).render(<App {...props} />);
    },
});
