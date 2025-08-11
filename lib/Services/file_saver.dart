import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:media_scanner/media_scanner.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

Future<void> saveScannedImages(List<String> scannedPaths) async {
  // Request storage permission (only needed for Android < API 33)
  final status = await Permission.storage.request();
  if (!status.isGranted) return;

  final now = DateTime.now();
  final timestamp =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}";

  final baseDir = Directory('/storage/emulated/0/DCIM/AuditScanner/Audit_$timestamp');

  if (!await baseDir.exists()) {
    await baseDir.create(recursive: true);
  }

  List<String> savedPaths = [];

  for (var path in scannedPaths) {
    final src = File(path);
    final filename = p.basename(path);
    final dest = File('${baseDir.path}/$filename');

    await src.copy(dest.path);
    await MediaScanner.loadMedia(path: dest.path);
    print('Saved: ${dest.path}');

    savedPaths.add(dest.path);
  }

  print('All files saved to: ${baseDir.path}');
  await uploadFilesWithCreationTime(savedPaths);
}

Future<void> uploadFilesWithCreationTime(List<String> filePaths) async {
  final uri = Uri.parse("http://10.0.2.2:8000/api/upload"); // Replace with your server URL
  final request = http.MultipartRequest("POST", uri);

  for (var path in filePaths) {
    final file = File(path);
    final filename = p.basename(path);
    final lastModified = await file.lastModified();

    request.files.add(await http.MultipartFile.fromPath('files[]', path, filename: filename));
    request.fields['created_at[]'] = lastModified.toIso8601String();
  }

  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("Upload successful: $responseBody");
    } else {
      print("Upload failed (${response.statusCode}): $responseBody");
    }
  } catch (e) {
    print("Upload error: $e");
  }
}