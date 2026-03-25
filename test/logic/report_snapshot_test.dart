// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  group('ReportEngine Snapshot Tests (Safety Net)', () {
    late BinaStore store;

    setUp(() {
      store = BinaStore(); // Using standard factory
      store.reset(); // ensure clean state
    });

    test('Section 3 - Known values produce identical report details', () {
      // Setup known state for Section 3
      store.bolum3 = Bolum3Model(
        zeminYuksekligi: 4.0,
        normalKatSayisi: 5,
        normalYuksekligi: 3.0,
        bodrumKatSayisi: 2,
        bodrumYuksekligi: 3.5,
        hBina: 19.0, // Calculated manually for the test
        hYapi: 26.0,
      );

      // Snapshot the output
      final details = ReportEngine.getSectionDetailedReport(3, store: store);

      expect(details.length, 10); // Expected fields

      // Validate core elements
      expect(details[0]['label'], 'Normal Kat Sayısı (Zemin Üstü)');
      expect(details[0]['value'], '5 adet');
      expect(details[8]['label'], 'Yapı Yüksekliği (hYapı)');
      expect(details[8]['value'], '26.00 m');
    });

    test('calculateRiskMetrics - Scenario: Complex risks and stale data', () {
      // 1. Data Mismatch (S5 vs S33) -> Logic Desync Guard
      store.bolum5 = Bolum5Model(
        tabanAlani: 500.0,
        normalKatAlani: 450.0,
        bodrumKatAlani: 300.0,
        toplamInsaatAlani: 1250.0,
      );

      store.bolum33 = Bolum33Model(
        alanZemin: 400.0, // Mismatch (400 vs 500)
        alanNormal: 450.0,
        alanBodrumMax: 300.0,
        yukZemin: 50,
        yukNormal: 40,
        yukBodrum: 20,
      );

      // 2. Special Condition S20 (Sahanliksiz merdiven)
      store.bolum20 = Bolum20Model(sahanliksizMerdivenSayisi: 1);

      // 3. Bölüm 21 Missing YGH (Required if hBina > limit)
      store.bolum3 = Bolum3Model(
        hBina: 51.0,
        hYapi: 55.0, // Now >= 51.50 to trigger YGH critical
        isYuksekBina: true,
      );

      final metrics = ReportEngine.calculateRiskMetrics(store: store);
      final criticals = metrics['criticals'] as List<String>;

      // print('DEBUG CRITICALS: $criticals'); // For manual run if needed

      expect(metrics['criticalCount'], greaterThanOrEqualTo(2));
      expect(metrics['score'], lessThan(96));
      expect(criticals.contains('Bölüm 33 (VERİ UYUMSUZLUĞU)'), isTrue);
    });
  });
}
