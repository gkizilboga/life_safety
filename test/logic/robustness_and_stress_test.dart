import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/models/bolum_11_model.dart';
import 'package:life_safety/models/bolum_12_model.dart';
import 'package:life_safety/models/bolum_16_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_2_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  group('Robustness & Stress Suite', () {
    final store = BinaStore.instance;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() {
      store.clearCurrentAnalysis();
    });

    group('Edge-Case Logic (Chaos)', () {
      test('Extreme Height: 10km high building', () {
        store.bolum3 = Bolum3Model(
          hYapi: 10000.0,
          normalKatSayisi: 3000,
          bodrumKatSayisi: 50,
        );

        expect(
          () => ReportEngine.calculateRiskMetrics(store: store),
          returnsNormally,
        );
        expect(
          () => ActiveSystemsEngine.calculateRequirements(store),
          returnsNormally,
        );
      });

      test('Extreme Scale: Millions of m2', () {
        store.bolum5 = Bolum5Model(tabanAlani: 1000000000.0);
        final metrics = ReportEngine.calculateRiskMetrics(store: store);
        expect(metrics['score'], isNotNull);
      });

      test('Extreme Small: 1mm high building', () {
        store.bolum3 = Bolum3Model(
          hYapi: 0.001,
          normalKatSayisi: 0,
          bodrumKatSayisi: 0,
        );
        expect(
          () => ReportEngine.calculateRiskMetrics(store: store),
          returnsNormally,
        );
      });

      test('Robustness: Missing/Null Models Handling', () {
        store.bolum1 = null;
        store.bolum3 = null;
        store.bolum35 = null;

        expect(
          () => ReportEngine.calculateRiskMetrics(store: store),
          returnsNormally,
        );
        expect(
          () => ActiveSystemsEngine.calculateRequirements(store),
          returnsNormally,
        );
      });

      test('Robustness: Malformed Data & Large Strings', () {
        final megaString = "A" * 50000;
        final choice = ChoiceResult(
          label: "LONG_TEXT",
          uiTitle: megaString,
          uiSubtitle: megaString,
          reportText: megaString,
        );

        expect(() => ReportEngine.getStatusColor(choice), returnsNormally);
      });
    });

    group('High-Volume Scenarios (Stress)', () {
      test('Scenario: 40 Floors, 200k m2, Max Occupancy', () async {
        store.reset();

        // 30 Normal, 10 Bodrum = 40 Kat. Toplam Yükseklik 125m
        store.bolum3 = Bolum3Model(
          bodrumKatSayisi: 10,
          normalKatSayisi: 30,
          hBina: 90.0,
          hYapi: 125.0,
        );
        store.bolum4 = Bolum4Model(
          hesaplananBinaYuksekligi: 90.0,
          hesaplananYapiYuksekligi: 125.0,
        );

        // Kat başı 5.000 m2. Toplam = 200.000 m2
        store.bolum5 = Bolum5Model(
          tabanAlani: 5000,
          bodrumKatAlani: 5000,
          normalKatAlani: 5000,
          toplamInsaatAlani: 200000,
        );

        // Tüm katlar "Yüksek Yoğun Ticari" (Cafe/Restoran)
        store.bolum10 = Bolum10Model(
          zemin: Bolum10Content.yuksekYogunTicari,
          bodrumlar: List.filled(10, Bolum10Content.yuksekYogunTicari),
          normaller: List.filled(30, Bolum10Content.yuksekYogunTicari),
          bodrumlarAyni: true,
          normallerAyni: true,
        );

        store.bolum6 = Bolum6Model(
          hasOtopark: true,
          otoparkTipi: Bolum6Content.otoparkKapali,
        );

        store.bolum16 = Bolum16Model(
          cepheUzunlugu: Bolum16Content.cepheUzunluguKritik,
          mantolama: Bolum16Content.mantolamaOptionA,
        );

        store.bolum20 = Bolum20Model(
          binaIciYanginMerdiveniSayisi: 1,
          sahanliksizMerdivenSayisi: 1, 
        );

        store.bolum33 = Bolum33Model(
          yukZemin: 3333,
          yukNormal: 3333,
          yukBodrum: 3333,
          gerekliNormal: 67, 
          mevcutUst: 1,
        );

        final metrics = ReportEngine.calculateRiskMetrics(store: store);
        final activeSystems = ActiveSystemsEngine.calculateRequirements(store);

        expect(metrics['score'], lessThan(85));
        expect(store.bolum33?.gerekliNormal, greaterThan(60));
        
        // Critical systems should be mandatory
        final hasMandatory = activeSystems.any((s) => s.isMandatory);
        expect(hasMandatory, true);
      });
    });
  });
}
