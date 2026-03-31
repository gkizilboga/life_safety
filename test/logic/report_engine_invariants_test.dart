import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:flutter/material.dart';

void main() {
  group('ReportEngine - Data Invariant Tests (Robustness)', () {
    late BinaStore store;

    setUp(() {
      store = BinaStore.instance;
      store.reset();
    });

    test('Section 36 - All possible width labels should not crash the engine', () {
      final allMerdLabels = [
        "36-Merd-A", "36-Merd-B", "36-Merd-C", "36-Merd-D", "36-Merd-E",
        "invalid-label", ""
      ];
      final allKoridorLabels = [
        "36-Koridor-A", "36-Koridor-B", "36-Koridor-C", "36-Koridor-D", "36-Koridor-E", "36-Koridor-F",
        "invalid-label", ""
      ];
      final allKapiLabels = [
        "36-Kapi-A", "36-Kapi-B", "36-Kapi-C",
        "invalid-label", ""
      ];

      for (var merd in allMerdLabels) {
        for (var kor in allKoridorLabels) {
          for (var kapi in allKapiLabels) {
            // Mock choices
            final mChoice = ChoiceResult(label: merd, uiTitle: merd, uiSubtitle: '', reportText: '');
            final cChoice = ChoiceResult(label: kor, uiTitle: kor, uiSubtitle: '', reportText: '');
            final kChoice = ChoiceResult(label: kapi, uiTitle: kapi, uiSubtitle: '', reportText: '');

            final b36 = Bolum36Model(
              genislikKorunumlu: mChoice,
              koridorGenislikKorunumlu: cChoice,
              kapiGenislikKorunumlu: kChoice,
              areWidthsSame: true,
            );

            store.bolum36 = b36;

            // Test if getSectionSummary crashes
            expect(() => ReportEngine.getSectionSummary(36), returnsNormally, 
              reason: 'Crashed with labels: Merd:$merd, Kor:$kor, Kapi:$kapi');
            
            // Test if getSectionFullReport crashes
            expect(() => ReportEngine.getSectionFullReport(36), returnsNormally,
              reason: 'Full report crashed with labels: Merd:$merd, Kor:$kor, Kapi:$kapi');
          }
        }
      }
    });

    test('Section 36 - Edge Case: Null choices should not crash the engine', () {
      store.bolum36 = Bolum36Model(
        genislikKorunumlu: null,
        koridorGenislikKorunumlu: null,
        kapiGenislikKorunumlu: null,
      );

      expect(() => ReportEngine.getSectionSummary(36), returnsNormally);
      expect(() => ReportEngine.getSectionFullReport(36), returnsNormally);
    });

    test('Global - ReportEngine.getSectionStatus should handle arbitrary IDs safely', () {
      for (int i = 0; i <= 100; i++) {
        expect(() => ReportEngine.getSectionStatus(i), returnsNormally,
          reason: 'getSectionStatus crashed for ID $i');
      }
    });
  });
}
