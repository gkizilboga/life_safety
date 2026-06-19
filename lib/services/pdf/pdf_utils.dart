import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/report_status.dart';

class PdfUtils {
  static final RegExp _emojiRegex = RegExp(
    r'[\u{1f300}-\u{1f5ff}\u{1f600}-\u{1f64f}\u{1f680}-\u{1f6ff}\u{1f900}-\u{1f9ff}\u{2600}-\u{26ff}\u{2700}-\u{27bf}\u{fe00}-\u{fe0f}]',
    unicode: true,
  );

  static final List<String> _prefixesToRemove = [
    "KRİTİK RİSK",
    "UYARI",
    "BİLİNMİYOR",
    "BİLGİ",
    "OLUMLU",
    "UYGUN",
    "ÖNERİ",
  ];

  static final List<RegExp> _prefixRegexes = _prefixesToRemove
      .map((prefix) => RegExp(
            '^(DURUM:\\s*)?$prefix:?\\s*',
            multiLine: true,
            caseSensitive: false,
          ))
      .toList();

  static final RegExp _durumCheckRegex = RegExp(
    r'^DURUM:\s*(?!ZORUNLU|ŞART DEĞİL)',
    caseSensitive: false,
  );

  static final RegExp _durumReplaceRegex = RegExp(
    r'^DURUM:\s*',
    caseSensitive: false,
  );

  static String cleanEmojis(String? text) {
    if (text == null) return "";

    // 1. Emoji Clean
    String cleaned = text.replaceAll(_emojiRegex, '').trim();

    // 2. Technical Prefix Clean (PDF Output Only)
    for (var regex in _prefixRegexes) {
      cleaned = cleaned.replaceAll(regex, '');
    }

    // Preserve DURUM: ZORUNLU but clean DURUM: OLUMLU etc.
    if (cleaned.startsWith(_durumCheckRegex)) {
      cleaned = cleaned.replaceFirst(_durumReplaceRegex, '');
    }

    return cleaned.trim();
  }

  static PdfColor getRiskColor(String text) {
    final t = text.trim();
    if (t.startsWith('KRİTİK RİSK')) return PdfColors.red700;
    if (t.startsWith('UYARI')) return PdfColors.amber700;
    if (t.startsWith('OLUMLU') || t.startsWith('Olumlu')) {
      return PdfColors.green700;
    }
    if (t.startsWith('BİLGİ')) return PdfColors.blue700;
    if (t.startsWith('BİLİNMİYOR') || t.startsWith('Bilinmiyor')) {
      return PdfColors.grey500;
    }
    if (t.startsWith('DURUM:') || t.startsWith('ZORUNLU')) {
      return PdfColors.red700;
    }
    return PdfColors.grey500;
  }

  static PdfColor getColorForItem(Map<String, dynamic> item) {
    if (item['status'] != null && item['status'] is ReportStatus) {
      return getColorFromStatus(item['status'] as ReportStatus);
    }
    final String reportText = item['report']?.toString() ?? '';
    if (reportText.trim().isNotEmpty) {
      return getRiskColor(reportText);
    }
    return PdfColors.grey500;
  }

  static PdfColor getColorFromStatus(ReportStatus status) {
    if (status == ReportStatus.risk) return PdfColors.red700;
    if (status == ReportStatus.warning) return PdfColors.amber700;
    if (status == ReportStatus.compliant) return PdfColors.green700;
    if (status == ReportStatus.info) return PdfColors.blue700;
    if (status == ReportStatus.unknown) return PdfColors.grey500;
    return PdfColors.grey500;
  }

  static PdfColor getScoreColorForPdf(int score) {
    if (score >= 80) return PdfColors.green300;
    if (score >= 50) return PdfColors.orange300;
    return PdfColors.red300;
  }

  static String generateTimestamp() {
    final now = DateTime.now();
    return "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";
  }

  static Future<String> saveBytesToDevice(
    List<int> bytes,
    String fileName,
  ) async {
    String dirPath;
    if (Platform.isAndroid) {
      dirPath = '/storage/emulated/0/Download';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      dirPath = dir.path;
    }
    final file = File('$dirPath/$fileName');
    await file.writeAsBytes(bytes);
    if (Platform.isAndroid) {
      notifyMediaStore(file.path);
    }
    return file.path;
  }

  static void notifyMediaStore(String filePath) {
    try {
      const channel = MethodChannel('com.example.life_safety/media');
      channel.invokeMethod('scanFile', {'path': filePath});
    } catch (_) {}
  }

  static Future<String> saveBytesToTemp(
    List<int> bytes,
    String fileName,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
