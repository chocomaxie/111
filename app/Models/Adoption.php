<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Adoption extends Model
{
     protected $table = 'adoptions';
     protected $fillable = ['pname', 'gender', 'age', 'color', 'location', 'description', 'image', 'status', 'adoption_fee', 'is_featured', 'user_id'];

    protected $appends = ['image_url'] ;

    // public function getFullAgeAttribute() {
    //     return $this->age . ' ' . ucfirst($this->unit_age);
    // }

    public function getImageUrlAttribute() {
        return $this->image ? Storage::url($this->image) : asset('images/default.png');
    }

    public function user() {
        return $this->belongsTo(User::class);
    }

}

