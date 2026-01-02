import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';

// RAPOR MODÜLLERİ (Hatanın çözümü burası)
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
  // Risk Metriklerini Hesaplar (Skor, Kritik Risk Sayısı vb.)
  static Map<String, dynamic> calculateRiskMetrics() {
    int totalSections = 36;
    int filledSections = 0;
    int criticalRisks = 0;
    int warnings = 0;
    List<String> criticalTitles = [];

    for (int i = 1; i <= totalSections; i++) {
      final result = BinaStore.instance.getResultForSection(i);
      if (result != null) {
        filledSections++;
        final color = getStatusColor(result);
        if (color == const Color(0xFFE53935)) { // Kırmızı
          criticalRisks++;
          criticalTitles.add("Bölüm $i");
        } else if (color == Colors.orange.shade400) { // Turuncu
          warnings++;
        }
      }
    }

    // Güvenlik Skoru Algoritması
    double safetyScore = filledSections == 0 ? 0 : ((filledSections - criticalRisks) / filledSections) * 100;

    return {
      'score': safetyScore.toInt(),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'completion': (filledSections / totalSections * 100).toInt(),
      'criticals': criticalTitles.take(3).toList(), // İlk 3 kritik riski göster
    };
  }

  // Durum Rengini Belirler
  static Color getStatusColor(ChoiceResult? result) {
    if (result == null) return Colors.grey.shade300;
    final text = result.reportText.toLowerCase();
    
    // Kritik Riskler (Kırmızı)
    if (text.contains("risk") || text.contains("yetersiz") || text.contains("uygun değil") || text.contains("☢️")) {
      return const Color(0xFFE53935);
    }
    // Gri Alanlar (Turuncu)
    if (text.contains("bilinmiyor") || text.contains("bilmiyorum") || text.contains("❓")) {
      return Colors.orange.shade400;
    }
    // Olumlu Durumlar (Yeşil)
    if (text.contains("olumlu") || text.contains("uygun") || text.contains("yeterli") || text.contains("✅")) {
      return const Color(0xFF43A047);
    }
    // Bilgi Amaçlı (Mavi)
    return const Color(0xFF1E88E5);
  }

  // Bölüm Özetini Getirir
  static String getSectionSummary(int id) {
    final result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Veri Girilmedi";
    return result.uiTitle.isNotEmpty ? result.uiTitle : result.label;
  }

  // Tam Rapor Metnini Getirir
  static String getSectionFullReport(int id) {
    final result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Bu bölüm için veri girişi yapılmamıştır.";
    return result.reportText;
  }
}