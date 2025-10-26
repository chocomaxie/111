<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('adoptions', function (Blueprint $table) {
            // 🚨 IDAGDAG ANG COLUMN AFTER 'age'
            $table->enum('age_unit', ['months', 'years'])->default('months')->after('age');
        });
    }

    public function down(): void
    {
        Schema::table('adoptions', function (Blueprint $table) {
            $table->dropColumn('age_unit');
        });
    }
};
