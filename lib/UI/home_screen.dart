import 'dart:io';

import 'package:audit_scanner/UI/upload_files_screen.dart';
import 'package:flutter/material.dart';

import '../Services/file_saver.dart';
import '../Services/pdf_export.dart';
import '../Services/scanner_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> scannedImages = [];

  Future<void> startScanner() async {
    final images = await runScanner();
    if (images.isNotEmpty) {
      await saveScannedImages(images);
      setState(() => scannedImages = images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('📄 Pengimbas Dokumen Audit'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: scannedImages.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tiada Dokumen Diimbas',
                      style: TextStyle(fontSize: 18, color: Colors.black54)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: scannedImages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(scannedImages[index]), fit: BoxFit.cover),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: startScanner,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Imbas Dokumen'),
            backgroundColor: Colors.blueAccent,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: scannedImages.isNotEmpty
                ? () => exportToPdf(context, scannedImages)
                : null,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Eksport ke PDF'),
            backgroundColor: Colors.deepOrange,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadFileScreen()),
              );
            },
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Hantar Fail'),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
