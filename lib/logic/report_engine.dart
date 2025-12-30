import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';

enum ReportModule {
  binaBilgileri("Bina Genel Bilgileri", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
  modul1("Modül 1: Yapısal Analiz", [11, 12, 13, 14, 15]),
  modul2("Modül 2: Tahliye Güvenliği", [16, 17, 18, 19, 20]),
  modul3("Modül 3: Yangın Sistemleri", [21, 22, 23, 24, 25]),
  modul4("Modül 4: Teknik Hacimler", [26, 27, 28, 29, 30]),
  modul5("Modül 5: Kapasite ve Final", [31, 32, 33, 34, 35, 36]);

  final String title;
  final List<int> sectionIds;
  const ReportModule(this.title, this.sectionIds);
}

class ReportEngine {
  // Özet metni getirir
  static String getSectionSummary(int id) {
    final result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Veri Girilmedi";
    return result.uiTitle.isNotEmpty ? result.uiTitle : result.label;
  }

  // Tam rapor metnini getirir (Detay penceresi için)
  static String getSectionFullReport(int id) {
    final result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Bu bölüm için veri girişi yapılmamıştır.";
    return result.reportText;
  }

  // Durum rengini belirler
  static Color getStatusColor(ChoiceResult? result) {
    if (result == null) return Colors.grey.shade300;
    final text = result.reportText.toLowerCase();
    if (text.contains("bilinmiyor") || text.contains("bilmiyorum")) return Colors.orange.shade300;
    if (text.contains("risk") || text.contains("yetersiz") || text.contains("uygun değil")) return Colors.red.shade400;
    if (text.contains("olumlu") || text.contains("uygun") || text.contains("yeterli")) return Colors.green.shade400;
    return Colors.blue.shade400;
  }
}