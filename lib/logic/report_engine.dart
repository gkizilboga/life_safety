import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';

enum ReportModule {
  binaBilgileri("Bina Hakkında Genel Bilgiler", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "Aquarius", "Çeşme, sarnıç ve su kemerlerinin yerlerini avucunun içi gibi bilen kişiler."),
  modul1("Modül 1", [11, 12, 13, 14, 15], "Nocturnus", "Gece Bekçisi ordusu. Geceleri sokaklarda devriye gezerler."),
  modul2("Modül 2", [16, 17, 18, 19, 20], "Siphonarius", "Basınçlı su makinelerini kullanan uzman asker."),
  modul3("Modül 3", [21, 22, 23, 24, 25], "Centurio", "İtfaiye bölüğünün komutanı. Taktik lider."),
  modul4("Modül 4", [26, 27, 28, 29, 30], "Praefectus", "Taburundan sorumlu en üst düzey komutan."),
  modul5("Modül 5", [31, 32, 33, 34, 35, 36], "Praefectus Maximus", "Final raporlama yetkisine sahip komuta kademesi.");

  final String title;
  final List<int> sectionIds;
  final String rankName;
  final String rankDescription;
  const ReportModule(this.title, this.sectionIds, this.rankName, this.rankDescription);
}

class ReportEngine {
  static BinaStore _getStore(BinaStore? store) => store ?? BinaStore.instance;
  static double _getHYapi(BinaStore? store) => _getStore(store).bolum3?.hYapi ?? 0.0;
  static double _getHBina(BinaStore? store) => _getStore(store).bolum3?.hBina ?? 0.0;

  static Map<String, dynamic> calculateRiskMetrics({BinaStore? store}) {
    final s = _getStore(store);
    int filledSections = 0;
    int criticalRisks = 0;
    int warnings = 0;
    int totalActiveSections = 0;
    List<String> criticalTitles = [];

    for (int i = 1; i <= 36; i++) {
      bool isSkipped = false;
      if (i == 22 || i == 23) isSkipped = s.bolum7?.hasAsansor == false;
      if (i == 25) isSkipped = (s.bolum20?.donerMerdivenSayisi ?? 0) == 0 && (s.bolum20?.sahanliksizMerdivenSayisi ?? 0) == 0;
      if (i == 30) isSkipped = s.bolum7?.hasKazan == false;
      if (i == 31) isSkipped = s.bolum7?.hasTrafo == false;
      if (i == 32) isSkipped = s.bolum7?.hasJenerator == false;
      if (i == 34) isSkipped = s.bolum6?.hasTicari == false;

      if (!isSkipped) {
        totalActiveSections++;
        final res = s.getResultForSection(i);
        if (res != null) {
          filledSections++;
          final Color color = getStatusColor(res, sectionId: i, store: s);
          if (color == const Color(0xFFE53935)) {
            criticalRisks++;
            criticalTitles.add("Bölüm $i");
          } else if (color == Colors.orange.shade600) {
            warnings++;
          }
        }
      }
    }

    if (s.bolum20 != null && s.bolum20!.sahanliksizMerdivenSayisi > 0) {
      if (!criticalTitles.contains("Bölüm 20")) { criticalRisks++; criticalTitles.add("Bölüm 20"); }
    }

    final yghReasons = evaluateYghRequirement(store: s);
    final bool hasYgh = s.bolum21?.varlik?.label.contains("21-1-A") ?? false;
    if (yghReasons.isNotEmpty && !hasYgh) {
      if (!criticalTitles.contains("Bölüm 21")) { criticalRisks++; criticalTitles.add("Bölüm 21"); }
    }

    double baseScore = filledSections == 0 ? 0.0 : ((filledSections - criticalRisks) / filledSections) * 100.0;
    double penaltyScore = baseScore - (criticalRisks * 15.0) - (warnings * 2.0);

    if (criticalRisks >= 3) penaltyScore = 30.0;
    else if (criticalRisks >= 1 && penaltyScore > 60.0) penaltyScore = 60.0;

    return {
      'score': penaltyScore.toInt().clamp(0, 100),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'completion': (filledSections / totalActiveSections * 100).toInt().clamp(0, 100),
      'criticals': criticalTitles.take(3).toList(),
    };
  }

  static Color getStatusColor(ChoiceResult? result, {int? sectionId, BinaStore? store}) {
    if (result == null) return Colors.grey.shade300;
    final s = _getStore(store);
    final hYapi = _getHYapi(s);
    final hBina = _getHBina(s);
    
    if (sectionId == 12 && result.label.contains("12-B (Çelik)")) {
      return (s.bolum5?.toplamInsaatAlani ?? 0.0) < 5000 ? const Color(0xFF43A047) : const Color(0xFFE53935);
    }

    if (sectionId == 16 && result.label.contains("16-1-A")) {
      if (hBina > 28.50) return const Color(0xFFE53935);
      final m = s.bolum16;
      if (m != null) {
        if (m.bariyerYan == 0 || m.bariyerUst == 0 || m.bariyerZemin == 0) return const Color(0xFFE53935);
        if (m.bariyerYan == 2 || m.bariyerUst == 2 || m.bariyerZemin == 2) return Colors.orange.shade600;
        return const Color(0xFF43A047);
      }
    }

    if (sectionId == 19) {
      final b20 = s.bolum20;
      int total = (b20?.normalMerdivenSayisi ?? 0) + (b20?.binaIciYanginMerdiveniSayisi ?? 0) + (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) + (b20?.donerMerdivenSayisi ?? 0);
      if (total <= 1) return const Color(0xFF43A047);
    }

    if (sectionId == 33) {
      if (result.label.contains("YETERLI") || result.label.contains("OK")) return const Color(0xFF43A047);
      if (result.label.contains("YETERSIZ") || result.label.contains("FAIL")) return const Color(0xFFE53935);
    }

    if (sectionId == 25) {
      int yuk = s.bolum33?.yukNormal ?? 0;
      if (result.label == "25-1-A" || (result.label == "25-1-B" && yuk > 25)) return const Color(0xFFE53935);
      if (result.label == "25-1-B" && yuk <= 25) return const Color(0xFF43A047);
      if (result.label == "25-1-C") return Colors.orange.shade600;
    }

    if (sectionId == 21 && hYapi < 30.50 && result.label.contains("21-1-B")) return const Color(0xFF1E88E5);
    if (sectionId == 22 && hYapi < 51.50 && result.label.contains("22-1-A")) return const Color(0xFF1E88E5);
    if (sectionId == 36 && hBina < 21.50 && result.label.contains("36-1-B")) return Colors.orange.shade600;

    final String text = result.reportText.toUpperCase();
    if (text.contains("🚨") || text.contains("☢️") || text.contains("KRİTİK RİSK") || (text.contains("YETERSİZ") && !text.contains("YETERSİZLİK YOKTUR"))) return const Color(0xFFE53935);
    if (text.contains("⚠️") || text.contains("❓") || text.contains("BİLİNMİYOR") || text.contains("UYARI")) return Colors.orange.shade600;
    return const Color(0xFF43A047);
  }

  static List<String> evaluateYghRequirement({BinaStore? store}) {
    final s = _getStore(store);
    final hYapi = _getHYapi(s);
    List<String> reasons = [];
    if (hYapi >= 51.50) reasons.add("Yapı yüksekliğinin 51.50 metre ve üzerinde olması.");
    if (s.bolum10 != null && s.bolum10!.bodrumlar.any((c) => c != null && !c.label.contains("10-A"))) reasons.add("Bodrum katlarda konut harici kullanım.");
    if (s.bolum22?.varlik?.label.contains("22-1-B") ?? false) reasons.add("İtfaiye Asansörü varlığı.");
    if ((s.bolum3?.bodrumKatSayisi ?? 0) >= 1 && (s.bolum23?.bodrum?.label.contains("23-1-B") ?? false || (s.bolum23?.bodrum?.label.contains("23-1-C") ?? false))) reasons.add("Bodrum kata inen asansörün/merdivenin riskli açılımı.");
    if (hYapi > 30.50 && (s.bolum20?.basinclandirma?.label.contains("20-BAS-B") ?? false)) reasons.add("30.50m üzeri ve basınçlandırma yok.");
    if ((s.bolum3?.bodrumKatSayisi ?? 0) >= 1 && (s.bolum20?.bodrumMerdivenDevami?.label.contains("20-Bodrum-A") ?? false)) reasons.add("Kaçış merdiveninin bodrum kata kesintisiz devam etmesi.");
    return reasons;
  }

  static String getSectionSummary(int id) {
    final res = BinaStore.instance.getResultForSection(id);
    return res == null ? "Kapsam Dışı" : (res.uiTitle.isNotEmpty ? res.uiTitle : res.label);
  }

  static String getSectionFullReport(int id) {
    final s = BinaStore.instance;
    final res = s.getResultForSection(id);
    if (res == null) return "Bu bölüm değerlendirme kapsamı dışındadır.";
    if (id == 12 && res.label.contains("12-B (Çelik)")) {
      if ((s.bolum5?.toplamInsaatAlani ?? 0.0) < 5000) return "✅ OLUMLU: Çelik taşıyıcı elemanlar üzerinde pasif yangın yalıtımı bulunmamaktadır. (NOT: Bina toplam inşaat alanı 5000 m² altında olduğu için bu durum yönetmeliğe uygundur.)";
    }
    if (id == 16 && res.label.contains("16-1-A")) {
      final hBina = s.bolum3?.hBina ?? 0.0;
      if (hBina > 28.50) return "🚨 KRİTİK RİSK: 28.50 metreden yüksek binalarda yanıcı (EPS/XPS) mantolama kullanımı yönetmelik gereği yasaktır.";
      final m = s.bolum16;
      if (m != null) {
        if (m.bariyerYan == 0 || m.bariyerUst == 0 || m.bariyerZemin == 0) return "🚨 KRİTİK RİSK: Binada yanıcı mantolama kullanılmasına rağmen yangın bariyerleri bulunmamaktadır.";
        if (m.bariyerYan == 2 || m.bariyerUst == 2 || m.bariyerZemin == 2) return "⚠️ UYARI: Binada yanıcı mantolama mevcuttur ancak yangın bariyerlerinin varlığı teyit edilememiştir.";
        return "✅ OLUMLU: Binada yanıcı mantolama kullanılmış olsa da, gerekli yangın bariyerlerinin olduğu beyan edilmiştir.";
      }
    }
    if (id == 19) {
      final b20 = s.bolum20;
      int total = (b20?.normalMerdivenSayisi ?? 0) + (b20?.binaIciYanginMerdiveniSayisi ?? 0) + (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) + (b20?.donerMerdivenSayisi ?? 0);
      if (total <= 1) return "✅ OLUMLU: Binada tek çıkış tespit edildiği için yönlendirme levhası zorunluluğu bulunmamaktadır.";
    }
    String prefix = "";
    final Color color = getStatusColor(res, sectionId: id, store: s);
    if (color == const Color(0xFFE53935)) prefix = "🚨 KRİTİK RİSK: ";
    else if (color == Colors.orange.shade600) prefix = "⚠️ UYARI: ";
    else if (color == const Color(0xFF1E88E5)) prefix = "ℹ️ BİLGİ: ";
    else prefix = "✅ OLUMLU: ";
    return "$prefix${res.reportText.replaceAll(RegExp(r'[🚨☢️⚠️✅❓ℹ️]'), '').replaceAll("UYGUN", "OLUMLU").trim()}";
  }

  static List<Map<String, String>> getActionPlan() {
    List<Map<String, String>> plan = [];
    for (int i = 1; i <= 36; i++) {
      final res = BinaStore.instance.getResultForSection(i);
      if (res != null && res.adviceText != null && res.adviceText!.isNotEmpty) {
        plan.add({'id': i.toString(), 'title': res.uiTitle, 'advice': res.adviceText!});
      }
    }
    return plan;
  }

  static Map<ReportModule, double> calculateModuleScores() {
    Map<ReportModule, double> scores = {};
    for (var module in ReportModule.values) {
      int total = 0;
      int criticals = 0;
      for (int id in module.sectionIds) {
        final res = BinaStore.instance.getResultForSection(id);
        if (res != null) {
          total++;
          if (getStatusColor(res, sectionId: id) == const Color(0xFFE53935)) criticals++;
        }
      }
      scores[module] = total == 0 ? 0 : ((total - criticals) / total) * 100.0;
    }
    return scores;
  }
}