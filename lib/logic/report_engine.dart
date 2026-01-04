import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';

enum ReportModule {
  binaBilgileri("Bina Hakkında Genel Bilgiler", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "Aquarius", "Çeşme, sarnıç ve su kemerlerinin yerlerini avucunun içi gibi bilen kişiler. Yangın anında insan zinciri (kova elden ele) kurarak suyu olay yerine ulaştırır."),
  modul1("Modül 1", [11, 12, 13, 14, 15], "Nocturnus", "Gece Bekçisi ordusu. Geceleri sokaklarda devriye gezer, duman kokusunu almaya veya ilk kıvılcımı görmeye çalışırlar."),
  modul2("Modül 2", [16, 17, 18, 19, 20], "Siphonarius", "Ctesibius pompası denilen, çift pistonlu, bronzdan yapılmış basınçlı su makinelerini kullanan uzman asker."),
  modul3("Modül 3", [21, 22, 23, 24, 25], "Centurio", "Yaklaşık 80-100 kişilik bir itfaiye bölüğünün komutanı. Olay yerindeki kaosu yöneten, kimin nereye su püskürteceğini veya hangi duvarın yıkılacağına karar veren taktik lider."),
  modul4("Modül 4", [26, 27, 28, 29, 30], "Praefectus", "Doğrudan İmparator tarafından atanan, taburunun tamamından sorumlu en üst düzey komutan. Sadece yangınları değil, kundakçıları yargılama yetkisine de sahip bir yargıçtı. Şehrin güvenlik stratejisini belirler."),
  modul5("Modül 5", [31, 32, 33, 34, 35, 36], "Praefectus Maximus", "En üst düzey stratejik yönetim ve final raporlama yetkisine sahip komuta kademesi.");

  final String title;
  final List<int> sectionIds;
  final String rankName;
  final String rankDescription;
  const ReportModule(this.title, this.sectionIds, this.rankName, this.rankDescription);
}

class ReportEngine {
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
        if (color == const Color(0xFFE53935)) {
          criticalRisks++;
          criticalTitles.add("Bölüm $i");
        } else if (color == Colors.orange.shade600) {
          warnings++;
        }
      }
    }

    double safetyScore = filledSections == 0 ? 0 : ((filledSections - criticalRisks) / filledSections) * 100;

    return {
      'score': safetyScore.toInt(),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'completion': (filledSections / totalSections * 100).toInt(),
      'criticals': criticalTitles.take(3).toList(),
    };
  }

  static Color getStatusColor(ChoiceResult? result) {
    if (result == null) return Colors.grey.shade300;
    final text = result.reportText;
    if (text.contains("☢️") || text.contains("🚨") || text.contains("KRİTİK RİSK") || text.contains("YETERSİZ")) {
      return const Color(0xFFE53935);
    }
    if (text.contains("⚠️") || text.contains("❓") || text.contains("BİLİNMİYOR") || text.contains("UYARI")) {
      return Colors.orange.shade600;
    }
    if (text.contains("✅") || text.contains("OLUMLU") || text.contains("UYGUN") || text.contains("YETERLİ")) {
      return const Color(0xFF43A047);
    }
    return const Color(0xFF1E88E5);
  }

  static String getSectionSummary(int id) {
    final result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Veri Girilmedi";
    return result.uiTitle.isNotEmpty ? result.uiTitle : result.label;
  }

  static String getSectionFullReport(int id) {
    final store = BinaStore.instance;
    
    if (id == 13 && store.bolum13 != null) {
      final m = store.bolum13!;
      List<String> reports = [];
      if (m.kazanKapi != null) reports.add(m.kazanKapi!.reportText);
      if (m.otoparkKapi != null) reports.add(m.otoparkKapi!.reportText);
      if (m.asansorKapi != null) reports.add(m.asansorKapi!.reportText);
      if (m.ticariKapi != null) reports.add(m.ticariKapi!.reportText);
      if (m.ortakDuvar != null) reports.add(m.ortakDuvar!.reportText);
      return reports.isNotEmpty ? reports.join("\n\n") : "Veri bulunamadı.";
    }

    if (id == 20 && store.bolum20 != null) {
      final m = store.bolum20!;
      if (m.tekKatCikis != null) return m.tekKatCikis!.reportText;
      return "Tespit Edilen Merdivenler:\n"
             "• Normal Merdiven: ${m.normalMerdivenSayisi} adet\n"
             "• Bina İçi Kapalı: ${m.binaIciYanginMerdiveniSayisi} adet\n"
             "• Bina Dışı Kapalı: ${m.binaDisiKapaliYanginMerdiveniSayisi} adet\n"
             "• Bina Dışı Açık: ${m.binaDisiAcikYanginMerdiveniSayisi} adet\n"
             "• Döner Merdiven: ${m.donerMerdivenSayisi} adet";
    }

    if (id == 29 && store.bolum29 != null) {
      final m = store.bolum29!;
      List<String> reports = [];
      if (m.kazan != null) reports.add("Kazan Dairesi: ${m.kazan!.reportText}");
      if (m.otopark != null) reports.add("Otopark: ${m.otopark!.reportText}");
      if (m.asansor != null) reports.add("Asansör: ${m.asansor!.reportText}");
      if (m.pano != null) reports.add("Elektrik Panosu: ${m.pano!.reportText}");
      return reports.isNotEmpty ? reports.join("\n\n") : "Veri bulunamadı.";
    }

    final result = store.getResultForSection(id);
    if (result == null) return "Bu bölüm için veri girişi yapılmamıştır.";
    return result.reportText;
  }
}