<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('uploaded_files', function (Blueprint $table) {
            $table->id();
            $table->string('file_name');
            $table->string('file_path');
            $table->string('file_type'); // Assuming only PDFs are uploaded
            $table->timestamp('upload_at');
            $table->timestamp('created_at')->useCurrent(); // don't use updated_at
        });
    }

    public function down(): void {
        Schema::dropIfExists('uploaded_files');
    }
};
