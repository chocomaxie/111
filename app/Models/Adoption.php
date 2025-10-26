<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Adoption extends Model
{
     protected $table = 'adoptions';
     // 🚨 IDAGDAG ANG 'age_unit' DITO!
    protected $fillable = ['pname', 'gender', 'age', 'age_unit', 'color', 'location', 'description', 'image', 'status', 'adoption_fee', 'is_featured', 'user_id'];

    protected $appends = ['image_url'] ;

    public function getImageUrlAttribute() {
        return $this->image ? Storage::url($this->image) : asset('images/default.png');
    }

    public function user() {
        return $this->belongsTo(User::class);
    }
}

