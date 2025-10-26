<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('adoptions', function (Blueprint $table) {
            $table->id();
            $table->string('pname', 20)->index();
            $table->enum('gender', ['male', 'female'])->index();
            $table->tinyInteger('age')->index();
            $table->string('category', 10); // 'cat' or 'dog'
            $table->string('color', 40);
            $table->string('location', 100)->nullable();
            $table->text('description');
            $table->string('image', 500)->nullable();
            $table->enum('status', ['available', 'pending', 'adopted'])->default('available')->index();
            $table->decimal('adoption_fee', 8, 2)->nullable();
            $table->boolean('is_featured')->default(false)->index();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('adoptions');
    }
};
