import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_25_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  group('Regulatory Boundary (Threshold) Tests', () {
    final store = BinaStore.instance;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() {
      store.reset();
    });

    group('Height Thresholds (hYapi)', () {
      test('Threshold 30.50m: Pressurization Logic Change', () {
        store.bolum3 = Bolum3Model(hYapi: 30.40, bodrumKatSayisi: 0);
        var results = ReportEngine.evaluateBasincRequirementForStairs(store: store);
        expect(results.any((r) => r.contains("30.50")), false);

        store.bolum3 = Bolum3Model(hYapi: 30.50, bodrumKatSayisi: 0);
        results = ReportEngine.evaluateBasincRequirementForStairs(store: store);
        expect(results.any((r) => r.contains("30.50")), true);
      });

      test('Threshold 51.50m: Sprinkler & Fire Alarm (Critical)', () {
        store.bolum3 = Bolum3Model(hYapi: 51.49, bodrumKatSayisi: 0);
        var reqs = ActiveSystemsEngine.calculateRequirements(store);
        
        var sprinkler = reqs.firstWhere((r) => r.name.contains("Sprinkler"));
        var alarm = reqs.firstWhere((r) => r.name.contains("Algılama"));
        
        expect(sprinkler.isMandatory, false);
        expect(alarm.isMandatory, false);

        store.bolum3 = Bolum3Model(hYapi: 51.50, bodrumKatSayisi: 0);
        reqs = ActiveSystemsEngine.calculateRequirements(store);
        
        sprinkler = reqs.firstWhere((r) => r.name.contains("Sprinkler"));
        alarm = reqs.firstWhere((r) => r.name.contains("Algılama"));
        
        expect(sprinkler.isMandatory, true);
        expect(alarm.isMandatory, true);
      });
    });

    group('Capacity Thresholds (Occupant Load)', () {
      test('Threshold 25 People: Circular Stairs Limit', () {
        // Setup data to trigger Section 36 dairesel merdiven logic
        store.bolum33 = Bolum33Model(yukZemin: 25, yukNormal: 25, yukBodrum: 0);
        store.bolum20 = Bolum20Model(donerMerdivenSayisi: 1);
        store.bolum3 = Bolum3Model(hYapi: 10.0, hBina: 5.0);
        store.bolum25 = Bolum25Model(
          yukseklik: ChoiceResult(label: "25-Dairesel-A", uiTitle: "9.50m altı", uiSubtitle: "", reportText: ""),
        );
        // Bolum 36 MUST NOT be null for its handler to run in getSectionFullReport
        store.bolum36 = Bolum36Model();
        
        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("OLUMLU"), true);
        
        // 26 People -> Critical Risk
        store.bolum33 = Bolum33Model(yukZemin: 26, yukNormal: 26, yukBodrum: 0);
        final report2 = ReportEngine.getSectionFullReport(36, store: store);
        expect(report2.contains("KRİTİK RİSK"), true);
        expect(report2.contains("25 kişiyi aşması"), true);
      });
    });

    group('Basement Thresholds', () {
      test('Threshold 4 Basements: Pressurization Necessity', () {
        store.bolum3 = Bolum3Model(bodrumKatSayisi: 4, hYapi: 10.0);
        var results = ReportEngine.evaluateBasincRequirementForStairs(store: store);
        expect(results.any((r) => r.contains("4'ten fazla")), false);

        store.bolum3 = Bolum3Model(bodrumKatSayisi: 5, hYapi: 10.0);
        results = ReportEngine.evaluateBasincRequirementForStairs(store: store);
        expect(results.any((r) => r.contains("4'ten fazla")), true);
      });
    });
  });
}
