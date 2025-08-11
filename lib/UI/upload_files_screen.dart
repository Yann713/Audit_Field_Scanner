import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  List<File> selectedFiles = [];
  bool isUploading = false;

  Future<void> pickMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFiles = result.paths
            .whereType<String>()
            .map((path) => File(path))
            .toList();
      });
    }
  }

  Future<void> submitFiles(BuildContext context) async {
    if (selectedFiles.isEmpty) return;
    if (!mounted) return;

    setState(() => isUploading = true);

    try {
      final uri = Uri.parse('http://192.168.0.184:8000/api/uploaded_files');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'Connection': 'keep-alive',
      });

      for (var file in selectedFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'files[]',
          file.path,
          filename: basename(file.path),
        ));
      }

      print("Sending ${selectedFiles.length} files to server...");
      for (var file in selectedFiles) {
        print("File: ${file.path} (${file.lengthSync()} bytes)");
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${jsonResponse['message']}\nUploaded: ${jsonResponse['files']?.join(', ') ?? 'No files'}',
            ),
          ),
        );
        setState(() => selectedFiles.clear());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${jsonResponse['error'] ?? responseBody}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hantar Fail ke Pelayan'),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickMultipleFiles,
              icon: const Icon(Icons.attach_file),
              label: const Text('Pilih Fail'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: selectedFiles.isEmpty
                  ? const Center(child: Text('Tiada fail dipilih'))
                  : ListView.builder(
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(basename(file.path)),
                          subtitle: Text('${file.lengthSync()} bytes'),
                        );
                      },
                    ),
            ),
            if (selectedFiles.isNotEmpty)
              ElevatedButton.icon(
                onPressed: isUploading ? null : () => submitFiles(context),
                icon: const Icon(Icons.cloud_upload),
                label: Text(isUploading ? 'Memuat Naik...' : 'Hantar Fail'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
