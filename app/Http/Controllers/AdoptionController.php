<?php

namespace App\Http\Controllers;

use App\Models\Adoption;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;

class AdoptionController extends Controller
{
    public function index() {
       return Inertia::render('Adoption/Adoption', []);
    }
}
