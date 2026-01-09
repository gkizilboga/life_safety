import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_25_model.dart';
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  final store = BinaStore.instance;

  setUp(() {
    store.reset();
  });

  group('Mühendislik ve Kapasite Hesaplama Testleri', () {
    
    test('YGH Analizi: Yapı yüksekliği 52m (51.50m üstü) ve YGH yoksa KRİTİK RİSK sayılmalı', () {
      store.bolum4 = Bolum4Model(hesaplananYapiYuksekligi: 52.0);
      store.bolum21 = Bolum21Model(
        varlik: ChoiceResult(label: "21-1-B", uiTitle: "Hayır", uiSubtitle: "", reportText: "")
      );

      final metrics = ReportEngine.calculateRiskMetrics();
      expect(metrics['criticalCount'] >= 1, true);
    });

    test('Bölüm 33: Mevcut çıkış (1), gereken çıkıştan (2) az ise KRİTİK RİSK oluşmalı', () {
      store.bolum33 = Bolum33Model(
        yukNormal: 120,
        gerekliNormal: 2,
        mevcutUst: 1,
      );
      
      final metrics = ReportEngine.calculateRiskMetrics();
      expect(metrics['criticalCount'] > 0, true);
      expect(metrics['score'] <= 60, true);
    });

    test('Bölüm 25: Döner merdiven genişliği < 100cm ise KRİTİK RİSK oluşmalı', () {
      store.bolum25 = Bolum25Model(
        genislik: Bolum25Content.genislikOptionA, 
      );
      
      final Color color = ReportEngine.getStatusColor(store.bolum25?.genislik, sectionId: 25);
      expect(color, const Color(0xFFE53935));
    });

    test('Bölüm 25: Genişlik >= 100cm ama Kişi Sayısı > 25 ise KRİTİK RİSK oluşmalı', () {
      store.bolum25 = Bolum25Model(genislik: Bolum25Content.genislikOptionB);
      store.bolum33 = Bolum33Model(yukNormal: 30); // 25 sınırını aşıyor
      
      final Color color = ReportEngine.getStatusColor(store.bolum25?.genislik, sectionId: 25);
      expect(color, const Color(0xFFE53935));
    });

    test('Bölüm 25: Genişlik >= 100cm ve Kişi Sayısı <= 25 ise OLUMLU sayılmalı', () {
      store.bolum25 = Bolum25Model(genislik: Bolum25Content.genislikOptionB);
      store.bolum33 = Bolum33Model(yukNormal: 20); // 25 sınırını aşıyor
      
      final Color color = ReportEngine.getStatusColor(store.bolum25?.genislik, sectionId: 25);
      expect(color, const Color(0xFF43A047));
    });

    test('Skorlama: 3 ve üzeri kritik riskte puan %30 bandına düşmeli', () {
      // 1. Risk: Yüksek Bina + YGH Yok
      store.bolum4 = Bolum4Model(hesaplananYapiYuksekligi: 55.0);
      store.bolum21 = Bolum21Model(varlik: ChoiceResult(label: "21-1-B", uiTitle: "", uiSubtitle: "", reportText: ""));
      
      // 2. Risk: Çıkış Yetersiz
      store.bolum33 = Bolum33Model(yukNormal: 600, gerekliNormal: 3, mevcutUst: 1);
      
      // 3. Risk: Sahanlıksız Merdiven
      store.bolum20 = Bolum20Model(sahanliksizMerdivenSayisi: 1);

      final metrics = ReportEngine.calculateRiskMetrics();
      
      expect(metrics['criticalCount'] >= 3, true);
      expect(metrics['score'] <= 30, true);
    });
  });
}