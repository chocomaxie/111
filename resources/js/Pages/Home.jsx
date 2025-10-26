import React from 'react';
import { Inertia } from '@inertiajs/inertia';

export default function Home(props) {
    return (
        <div>
            <h1>{props.message}</h1>
        </div>
    );
}
