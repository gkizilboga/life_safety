import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/utils/app_progress.dart';

class RiskCalculator {
  final BinaStore _store;

  RiskCalculator(this._store);

  Map<String, dynamic> calculateMetrics() {
    int criticalRisks = 0;
    int warnings = 0;
    int unknowns = 0;

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

    // Main section loop (Section based counts for titles and completion)
    for (int i = 1; i <= 36; i++) {
      if (AppProgress.isSectionActive(i, _store)) {
        if (_store.getResultForSection(i) != null) {
          // Titles for UI (Section level)
          if (i > 10) {
            final sectionLevel = ReportEngine.getSectionRiskLevel(
              i,
              store: _store,
            );
            if (sectionLevel == RiskLevel.critical) {
              criticalTitles.add("Bölüm $i");
            }
          }
        }
      }
    }

    // Granular scoring (Question based counts for 11-36)
    final allRiskLevels = ReportEngine.getAllQuestionsRiskLevels(store: _store);
    for (var level in allRiskLevels) {
      if (level == RiskLevel.critical) {
        criticalRisks++;
      } else if (level == RiskLevel.warning) {
        warnings++;
      } else if (level == RiskLevel.unknown) {
        unknowns++;
      }
    }

    // Special Condition S20 (Sahanliksiz) - captured in getAllQuestionsRiskLevels, add to titles
    if (_store.bolum20 != null &&
        _store.bolum20!.sahanliksizMerdivenSayisi > 0) {
      if (!criticalTitles.contains("Bölüm 20")) {
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
        criticalTitles.add("Bölüm 21");
      }
    }

    // Scoring formula (Base 100, weights: -5, -2, -1)
    double score =
        100.0 - (criticalRisks * 4.0) - (warnings * 2.0) - (unknowns * 1.0);

    return {
      'score': score.toInt().clamp(0, 100),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'unknownCount': unknowns,
      'completion': AppProgress.getAnalysisProgress(_store).percentage,
      'criticals': criticalTitles.toSet().toList().take(3).toList(),
    };
  }
}
