import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/bina_store.dart';

class AnalysisFileService {
  /// Exports the provided building data as an .lsf file.
  static Future<void> exportAnalysis(Map<String, dynamic> data) async {
    try {
      final String binaName = data['name'] ?? 'Bina';
      final String jsonStr = json.encode(data);

      final tempDir = await getTemporaryDirectory();
      final String safeName = binaName
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .trim();
      final file = File('${tempDir.path}/${safeName}_Analizi.lsf');

      await file.writeAsString(jsonStr);

      await Share.shareXFiles([
        XFile(file.path),
      ], subject: '$binaName Yangın Risk Analizi Verisi');
    } catch (e) {
      debugPrint('Export Error: $e');
      rethrow;
    }
  }

  /// Opens a file picker to select an .lsf file and imports it into BinaStore.
  static Future<bool> importAnalysis(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['lsf'],
      );

      if (result == null || result.files.isEmpty) return false;

      final file = File(result.files.single.path!);
      final String content = await file.readAsString();
      final Map<String, dynamic> data = json.decode(content);

      // Basic validation
      if (!data.containsKey('sections') || !data.containsKey('id')) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Geçersiz analiz dosyası formatı.')),
          );
        }
        return false;
      }

      // Check if it's potentially a duplicate or needs a new ID
      // For simplicity, we'll keep the ID but BinaStore should handle clashing when adding to archive
      final String originalId = data['id'];
      final String newId =
          '${originalId}_imported_${DateTime.now().millisecondsSinceEpoch}';
      data['id'] = newId;
      data['name'] = '${data['name'] ?? 'İçe Aktarılan'} (Kopya)';

      await BinaStore.instance.importBuilding(data);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data['name']} başarıyla içe aktarıldı.')),
        );
      }
      return true;
    } catch (e) {
      debugPrint('Import Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('İçe aktarma hatası: $e')));
      }
      return false;
    }
  }
}
