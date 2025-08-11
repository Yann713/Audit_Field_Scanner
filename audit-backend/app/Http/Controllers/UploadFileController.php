<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class UploadFileController extends Controller
{
    public function upload(Request $request)
    {
        Log::info('Upload endpoint hit');

        $request->validate([
            'files' => 'required|array',
            'files.*' => 'file|max:20480', // 20MB per file
        ]);

        $uploadedFiles = [];

        DB::beginTransaction();

        try {
            foreach ($request->file('files') as $file) {
                $filename = $file->getClientOriginalName();
                $mime = $file->getMimeType();
                $path = $file->store('uploads', 'public');

                Log::info("Stored file: $filename at $path");

                $insertId = DB::table('uploaded_files')->insertGetId([
                    'file_name' => $filename,
                    'file_path' => $path,
                    'file_type' => $mime,
                    'upload_at' => now(),
                ]);

                Log::info("Inserting to DB: $filename, $mime, $insertId");

                if (!$insertId) {
                    throw new \Exception("Failed to insert file $filename into database");
                }

                $uploadedFiles[] = $filename;
            }

            DB::commit();

            return response()->json([
                'message' => 'Files uploaded successfully',
                'files' => $uploadedFiles
            ], 200);

        } catch (\Exception $e) {
            DB::rollBack();

            Log::error('File upload error: ' . $e->getMessage());
            Log::error($e->getTraceAsString());

            return response()->json([
                'message' => 'File upload failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
