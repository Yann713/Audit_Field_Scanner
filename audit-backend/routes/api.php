<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UploadFileController;

// This will handle POST /api/uploaded_files
Route::post('/uploaded_files', [UploadFileController::class, 'upload']);
