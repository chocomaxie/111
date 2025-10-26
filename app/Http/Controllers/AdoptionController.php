<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class AdoptionController extends Controller
{
    public function index() {
        return Inertia::render('Adoption/Adoption', []);
    }
}
