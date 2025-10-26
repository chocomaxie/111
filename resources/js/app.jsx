import React from 'react';

import { createRoot } from 'react-dom/client';
import { App } from '@inertiajs/inertia-react';

const el = document.getElementById('app');

createRoot(el).render(
  <App
    initialPage={JSON.parse(el.dataset.page)}
    resolveComponent={(name) => import(`./Pages/${name}`).then(module => module.default)}
  />
);
