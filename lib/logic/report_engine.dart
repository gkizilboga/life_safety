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
  // Helper: Store verilmezse Singleton'ı kullan
  static BinaStore _getStore(BinaStore? store) => store ?? BinaStore.instance;

  static double _getHYapi(BinaStore? store) => _getStore(store).bolum4?.hesaplananYapiYuksekligi ?? 0.0;
  static double _getHBina(BinaStore? store) => _getStore(store).bolum4?.hesaplananBinaYuksekligi ?? 0.0;

  static List<String> evaluateYghRequirement({BinaStore? store}) {
    final s = _getStore(store);
    final hYapi = _getHYapi(s);
    List<String> reasons = [];

    if (hYapi >= 51.50) {
      reasons.add("Yapı yüksekliğinin 51.50 metre ve üzerinde olması.");
    }

    if (s.bolum10 != null) {
      bool hasBasementRisk = s.bolum10!.bodrumlar.any((ChoiceResult? c) => 
        c != null && (c.label.contains("10-B") || c.label.contains("10-C") || c.label.contains("10-D") || c.label.contains("10-E"))
      );
      if (hasBasementRisk) {
        reasons.add("Bodrum katlarda konut harici kullanım.");
      }
    }

    if (s.bolum22?.varlik?.label.contains("22-1-B") ?? false) {
      reasons.add("İtfaiye Asansörü varlığı.");
    }

    int bodrumSayisi = s.bolum3?.bodrumKatSayisi ?? 0;
    if (bodrumSayisi >= 1 && s.bolum23 != null) {
      final String label = s.bolum23!.bodrum?.label ?? "";
      if (label.contains("23-1-B") || label.contains("23-1-C")) {
        reasons.add("Bodrum kata inen asansörün/merdivenin riskli açılımı.");
      }
    }

    if (hYapi > 30.50 && (s.bolum20?.basinclandirma?.label.contains("20-BAS-B") ?? false)) {
      reasons.add("30.50m üzeri ve basınçlandırma yok.");
    }

    return reasons;
  }

  static Map<String, dynamic> calculateRiskMetrics({BinaStore? store}) {
    final s = _getStore(store);
    int totalSections = 36;
    int filledSections = 0;
    int criticalRisks = 0;
    int warnings = 0;
    List<String> criticalTitles = [];

    for (int i = 1; i <= totalSections; i++) {
      final ChoiceResult? result = s.getResultForSection(i);
      if (result != null) {
        filledSections++;
        final Color color = getStatusColor(result, sectionId: i, store: s);
        if (color == const Color(0xFFE53935)) {
          criticalRisks++;
          criticalTitles.add("Bölüm $i");
        } else if (color == Colors.orange.shade600) {
          warnings++;
        }
      }
    }

    // Ekstra Kritik Risk Kontrolleri
    if (s.bolum20 != null && (s.bolum20!.sahanliksizMerdivenSayisi) > 0) {
      if (!criticalTitles.contains("Bölüm 20")) {
        criticalRisks++;
        criticalTitles.add("Bölüm 20");
      }
    }

    final yghReasons = evaluateYghRequirement(store: s);
    final bool hasYgh = s.bolum21?.varlik?.label.contains("21-1-A") ?? false;
    if (yghReasons.isNotEmpty && !hasYgh) {
      if (!criticalTitles.contains("Bölüm 21")) {
        criticalRisks++;
        criticalTitles.add("Bölüm 21");
      }
    }

    double baseScore = filledSections == 0 ? 0.0 : ((filledSections - criticalRisks) / filledSections) * 100.0;
    double penaltyScore = baseScore - (criticalRisks * 15.0) - (warnings * 2.0);

    if (criticalRisks >= 3) {
      penaltyScore = 30.0;
    } else if (criticalRisks > 0 && penaltyScore > 60.0) {
      penaltyScore = 60.0;
    }

    return {
      'score': penaltyScore.toInt().clamp(0, 100),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'completion': (filledSections / totalSections * 100).toInt(),
      'criticals': criticalTitles.take(3).toList(),
    };
  }

  static Color getStatusColor(ChoiceResult? result, {int? sectionId, BinaStore? store}) {
    if (result == null) return Colors.grey.shade300;
    final s = _getStore(store);
    final hYapi = _getHYapi(s);
    final hBina = _getHBina(s);
    
    if (sectionId == 33) {
      if (result.label.contains("YETERLI") || result.label.contains("OK")) return const Color(0xFF43A047);
      if (result.label.contains("YETERSIZ") || result.label.contains("FAIL")) return const Color(0xFFE53935);
    }

    if (sectionId == 25) {
      int yuk = s.bolum33?.yukNormal ?? 0;
      if (result.label == "25-1-A") return const Color(0xFFE53935);
      if (result.label == "25-1-B" && yuk > 25) return const Color(0xFFE53935);
      if (result.label == "25-1-B" && yuk <= 25) return const Color(0xFF43A047);
    }

    if (sectionId == 21 && hYapi < 30.50 && result.label.contains("21-1-B")) return const Color(0xFF1E88E5);
    if (sectionId == 22 && hYapi < 51.50 && result.label.contains("22-1-A")) return const Color(0xFF1E88E5);
    if (sectionId == 36 && hBina < 21.50 && result.label.contains("36-1-B")) return Colors.orange.shade600;

    final String text = result.reportText.toUpperCase();
    if (text.contains("🚨") || text.contains("☢️") || text.contains("KRİTİK RİSK") || 
       (text.contains("YETERSİZ") && !text.contains("YETERSİZLİK YOKTUR"))) {
      return const Color(0xFFE53935);
    }
    if (text.contains("⚠️") || text.contains("❓") || text.contains("BİLİNMİYOR") || text.contains("UYARI")) {
      return Colors.orange.shade600;
    }
    
    return const Color(0xFF43A047);
  }

  static String getSectionSummary(int id) {
    final ChoiceResult? result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Kapsam Dışı";
    return result.uiTitle.isNotEmpty ? result.uiTitle : result.label;
  }

  static String getSectionFullReport(int id) {
    final ChoiceResult? result = BinaStore.instance.getResultForSection(id);
    if (result == null) return "Bu bölüm değerlendirme kapsamı dışındadır.";

    String prefix = "";
    final Color color = getStatusColor(result, sectionId: id);
    if (color == const Color(0xFFE53935)) prefix = "🚨 KRİTİK RİSK: ";
    else if (color == Colors.orange.shade600) prefix = "⚠️ UYARI: ";
    else if (color == const Color(0xFF1E88E5)) prefix = "ℹ️ BİLGİ: ";
    else prefix = "✅ OLUMLU: ";

    return "$prefix${result.reportText.replaceAll(RegExp(r'[🚨☢️⚠️✅❓ℹ️]'), '').trim()}";
  }
  
  static List<Map<String, String>> getActionPlan() {
    final store = BinaStore.instance;
    List<Map<String, String>> plan = [];
    for (int i = 1; i <= 36; i++) {
      final res = store.getResultForSection(i);
      if (res != null && res.adviceText != null && res.adviceText!.isNotEmpty) {
        plan.add({
          'id': i.toString(),
          'title': res.uiTitle,
          'advice': res.adviceText!,
        });
      }
    }
    return plan;
  }

  static Map<ReportModule, double> calculateModuleScores() {
    Map<ReportModule, double> scores = {};
    for (var module in ReportModule.values) {
      int total = module.sectionIds.length;
      int criticals = 0;
      for (int id in module.sectionIds) {
        final res = BinaStore.instance.getResultForSection(id);
        if (res != null && getStatusColor(res, sectionId: id) == const Color(0xFFE53935)) {
          criticals++;
        }
      }
      double score = total == 0 ? 0 : ((total - criticals) / total) * 100.0;
      scores[module] = score;
    }
    return scores;
  }
}