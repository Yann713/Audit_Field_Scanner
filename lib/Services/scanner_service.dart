import 'package:cunning_document_scanner/cunning_document_scanner.dart';

import 'file_saver.dart';

Future<List<String>> runScanner() async {
  try {
    final images = await CunningDocumentScanner.getPictures();
    if (images != null && images.isNotEmpty) {
      await saveScannedImages(images);
    }
    return images ?? [];
  } catch (e) {
    print("Ralat Semasa Mengimbas: $e");
    return [];
  }
}