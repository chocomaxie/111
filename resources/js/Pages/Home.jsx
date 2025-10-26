// resources/js/Pages/Home.jsx

import React from 'react';
// 🚨 TINANGGAL: import { Inertia } from '@inertiajs/inertia';

// Kung gagamitin mo ang router functions (tulad ng visit, reload, etc.),
// gamitin ang bagong import:
// import { router } from '@inertiajs/react';

export default function Home(props) {
    // Kung gusto mong i-check ang status ng Inertia:
    // const { component, props } = router.page;

    return (
        <div>
            <h1>{props.message}</h1>
            {/* Optional: <button onClick={() => router.visit('/another-page')}>Go</button> */}
        </div>
    );
}
