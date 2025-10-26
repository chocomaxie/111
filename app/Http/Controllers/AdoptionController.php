<?php

namespace App\Http\Controllers;

use App\Models\Adoption;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;

class AdoptionController extends Controller
{
    public function index() {
        $adoption = Adoption::with('user')->orderBy('created_at', 'desc')->get();

        return Inertia::render('Adoption/Index', [
            'adoption' => [
                'data' => $adoption,
            ],
            'flash' => session('success'),
            'rawAdoptionData' => $adoption,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'pname' => 'required|string|max:20',
            'gender' => 'required|in:female,male',
            'age' => 'required|numeric|between:1,25',
            'color' => 'required|string|max:40',
            'location' => 'required|string|max:100',
            'description' => 'required|string',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,bmp|max:2048',
            'category' => 'required|in:cat,dog', // ensure category is 'cat' or 'dog'
        ]);

        $adoption = new Adoption();
        $adoption->pname = ucfirst(strtolower($request->pname));
        $adoption->gender = $request->gender;
        $adoption->age = $request->age;
        $adoption->category = $request->category; // 'cat' or 'dog'
        $adoption->color = $request->color;
        $adoption->location = $request->location;
        $adoption->description = $request->description;

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('pets', 'public');
            $adoption->image = $imagePath;
        }

        if ($request->user()) {
            $adoption->user_id = $request->user()->id;
        }

        $adoption->save();

        return redirect()->route('adoption.index')->with('success', 'Pet successfully added!');
    }

    public function show($id)
    {
        $adoption = Adoption::with('user')->findOrFail($id);

        return Inertia::render('Adoption/Show', [
            'pet' => $adoption,
        ]);
    }
}
