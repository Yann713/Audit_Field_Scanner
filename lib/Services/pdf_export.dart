import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart'; 

Future<void> exportToPdf(BuildContext context, List<String> imagePaths) async {
  final pdf = pw.Document();

  for (final path in imagePaths) {
    final image = pw.MemoryImage(File(path).readAsBytesSync());
    pdf.addPage(pw.Page(build: (context) => pw.Center(child: pw.Image(image))));
  }

  final now = DateTime.now();
  final timestamp =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  final filename = 'Audit_$timestamp.pdf';

  final dir = Directory('/storage/emulated/0/Documents/AuditScanner');
  if (!await dir.exists()) await dir.create(recursive: true);

  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(await pdf.save());

  await MediaScanner.loadMedia(path: file.path);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('PDF exported to: ${file.path}'),
      action: SnackBarAction(
        label: 'Share',
        onPressed: () {
          Share.shareXFiles([XFile(file.path)], text: 'Audit PDF: $filename');
        },
      ),
      duration: const Duration(seconds: 6),
    ),
  );

  print('PDF disimpan di: ${file.path}');
}
