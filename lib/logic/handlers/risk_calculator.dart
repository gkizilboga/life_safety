import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/logic/report_engine.dart';

class RiskCalculator {
  final BinaStore _store;

  RiskCalculator(this._store);

  Map<String, dynamic> calculateMetrics() {
    int filledSections = 0;
    int criticalRisks = 0;
    int warnings = 0;
    int unknowns = 0;

    int totalActiveSections = 0;
    List<String> criticalTitles = [];

    // Logic Desync Guard
    final b5 = _store.bolum5;
    final b33 = _store.bolum33;
    if (b5 != null && b33 != null) {
      bool isStale =
          (b33.alanZemin != b5.tabanAlani) ||
          (b33.alanNormal != b5.normalKatAlani) ||
          (b33.alanBodrumMax != b5.bodrumKatAlani);

      if (isStale) {
        criticalRisks++;
        criticalTitles.add("Bölüm 33 (VERİ UYUMSUZLUĞU)");
      }
    }

    // Main section loop
    for (int i = 1; i <= 36; i++) {
      bool isSkipped = false;
      if (i == 22 || i == 23) isSkipped = _store.bolum7?.hasAsansor == false;
      if (i == 25) isSkipped = (_store.bolum20?.donerMerdivenSayisi ?? 0) == 0;
      if (i == 30) isSkipped = _store.bolum7?.hasKazan == false;
      if (i == 31) isSkipped = _store.bolum7?.hasTrafo == false;
      if (i == 32) isSkipped = _store.bolum7?.hasJenerator == false;
      if (i == 34) isSkipped = _store.bolum6?.hasTicari == false;

      if (!isSkipped) {
        totalActiveSections++;
        final res = _store.getResultForSection(i);
        if (res != null) {
          filledSections++;
          if (i <= 10) continue;

          // Calling ReportEngine's static level getter for now to keep it consistent
          final level = ReportEngine.getSectionRiskLevel(i, store: _store);
          if (level == RiskLevel.critical) {
            criticalRisks++;
            criticalTitles.add("Bölüm $i");
          } else if (level == RiskLevel.warning) {
            warnings++;
          } else if (level == RiskLevel.unknown) {
            unknowns++;
          }
        }
      }
    }

    // Special Condition S20 (Sahanliksiz)
    if (_store.bolum20 != null &&
        _store.bolum20!.sahanliksizMerdivenSayisi > 0) {
      if (!criticalTitles.contains("Bölüm 20")) {
        criticalRisks++;
        criticalTitles.add("Bölüm 20");
      }
    }

    // Dengelenmis Merdiven Check
    int dengelenmis =
        (_store.bolum20?.dengelenmisMerdivenSayisi ?? 0) +
        (_store.bolum20?.isBodrumIndependent == true
            ? (_store.bolum20?.bodrumDengelenmisMerdivenSayisi ?? 0)
            : 0);

    if (dengelenmis > 0) {
      double hBina = _store.bolum3?.hBina ?? 0;
      int maxYuk = 0;
      if (_store.bolum33 != null) {
        maxYuk = [
          _store.bolum33?.yukZemin ?? 0,
          _store.bolum33?.yukNormal ?? 0,
          _store.bolum33?.yukBodrum ?? 0,
        ].reduce((curr, next) => curr > next ? curr : next);
      }

      if (hBina > (15.50 - 0.001) || maxYuk > 100) {
        if (!criticalTitles.contains("Bölüm 20")) {
          criticalRisks++;
          criticalTitles.add("Bölüm 20");
        }
      }
    }

    // YGH Requirement
    final yghReasons = ReportEngine.evaluateYghRequirement(store: _store);
    final bool hasYgh =
        _store.bolum21?.varlik?.label.contains("21-1-A") ?? false;
    if (yghReasons.isNotEmpty && !hasYgh) {
      if (!criticalTitles.contains("Bölüm 21")) {
        criticalRisks++;
        criticalTitles.add("Bölüm 21");
      }
    }

    // Scoring formula
    double score =
        100.0 - (criticalRisks * 5.0) - (warnings * 2.0) - (unknowns * 1.0);

    return {
      'score': score.toInt().clamp(0, 100),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'unknownCount': unknowns,
      'completion': (_store.bolum36 != null)
          ? 100
          : totalActiveSections == 0
          ? 0
          : (filledSections / totalActiveSections * 100).toInt().clamp(0, 100),
      'criticals': criticalTitles.take(3).toList(),
    };
  }
}
