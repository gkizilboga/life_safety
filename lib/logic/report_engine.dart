import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/choice_result.dart';

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
  static double get _hBina => BinaStore.instance.bolum4?.hesaplananBinaYuksekligi ?? 0.0;
  static double get _hYapi => BinaStore.instance.bolum4?.hesaplananYapiYuksekligi ?? 0.0;

  static List<String> evaluateYghRequirement() {
    final store = BinaStore.instance;
    List<String> reasons = [];

    if (_hYapi >= 51.50) {
      reasons.add("Yapı yüksekliğinin 51.50 metre ve üzerinde olması.");
    }

    if (store.bolum10 != null) {
      bool hasBasementRisk = store.bolum10!.bodrumlar.any((ChoiceResult? c) => 
        c != null && (c.label.contains("10-B") || c.label.contains("10-C") || c.label.contains("10-D") || c.label.contains("10-E"))
      );
      if (hasBasementRisk) {
        reasons.add("Bodrum katlarda konut harici kullanım.");
      }
    }

    if (store.bolum22?.varlik?.label.contains("22-1-B") ?? false) {
      reasons.add("İtfaiye Asansörü varlığı.");
    }

    int bodrumSayisi = int.tryParse(store.bolum3?.bodrumKatSayisi?.toString() ?? "0") ?? 0;
    if (bodrumSayisi >= 1 && store.bolum23 != null) {
      final String label = store.bolum23!.bodrum?.label ?? "";
      if (label.contains("23-1-B") || label.contains("23-1-C")) {
        reasons.add("Bodrum kata inen asansörün/merdivenin riskli açılımı.");
      }
    }

    if (_hYapi > 30.50 && (store.bolum20?.basinclandirma?.label.contains("20-BAS-B") ?? false)) {
      reasons.add("30.50m üzeri ve basınçlandırma yok.");
    }

    return reasons;
  }

  static Map<String, dynamic> calculateRiskMetrics() {
    int totalSections = 36;
    int filledSections = 0;
    int criticalRisks = 0;
    int warnings = 0;
    List<String> criticalTitles = [];

    for (int i = 1; i <= totalSections; i++) {
      final ChoiceResult? result = BinaStore.instance.getResultForSection(i);
      if (result != null) {
        filledSections++;
        final Color color = getStatusColor(result, sectionId: i);
        if (color == const Color(0xFFE53935)) {
          criticalRisks++;
          criticalTitles.add("Bölüm $i");
        } else if (color == Colors.orange.shade600) {
          warnings++;
        }
      }
    }

    // YGH Eksikliği Kritik Risk Olarak Sayılmalı
    final yghReasons = evaluateYghRequirement();
    final bool hasYgh = BinaStore.instance.bolum21?.varlik?.label.contains("21-1-A") ?? false;
    if (yghReasons.isNotEmpty && !hasYgh) {
      criticalRisks++;
      if (!criticalTitles.contains("Bölüm 21")) criticalTitles.add("Bölüm 21");
    }

    double baseScore = filledSections == 0 ? 0 : ((filledSections - criticalRisks) / filledSections) * 100;
    double penaltyScore = baseScore - (criticalRisks * 15) - (warnings * 2);

    if (criticalRisks >= 3) {
      penaltyScore = 30;
    } else if (criticalRisks > 0 && penaltyScore > 60) {
      penaltyScore = 60;
    }

    return {
      'score': penaltyScore.toInt().clamp(0, 100),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'completion': (filledSections / totalSections * 100).toInt(),
      'criticals': criticalTitles.take(3).toList(),
    };
  }

  static Color getStatusColor(ChoiceResult? result, {int? sectionId}) {
    if (result == null) return Colors.grey.shade300;
    
    if (sectionId == 21 && _hYapi < 30.50 && result.label.contains("21-1-B")) return const Color(0xFF1E88E5);
    if (sectionId == 22 && _hYapi < 51.50 && result.label.contains("22-1-A")) return const Color(0xFF1E88E5);
    if (sectionId == 25 && _hBina < 9.50 && result.label.contains("25-1-A")) return const Color(0xFF43A047);
    if (sectionId == 36 && _hBina < 21.50 && result.label.contains("36-1-B")) return Colors.orange.shade600;

    final String text = result.reportText.toUpperCase();
    if (text.contains("🚨") || text.contains("☢️") || text.contains("KRİTİK RİSK") || text.contains("YETERSİZ") || text.contains("TEHLİKE")) {
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
}