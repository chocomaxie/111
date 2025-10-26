<?php

use App\Http\Controllers\AdoptionController;
use App\Http\Controllers\PageController;
use Illuminate\Support\Facades\Route;

Route::get('/', [PageController::class, 'index']);

Route::get('/adoption', [AdoptionController::class, 'index'])->name('adoption.index');

