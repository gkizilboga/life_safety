import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_25_model.dart';
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
    
    test('YGH Analizi: Yapı yüksekliği 52m ve YGH yoksa KRİTİK RİSK sayılmalı', () {
      store.bolum3 = Bolum3Model(hYapi: 52.0);
      store.bolum21 = Bolum21Model(varlik: ChoiceResult(label: "21-1-B", uiTitle: "Hayır", uiSubtitle: "", reportText: ""));

      final metrics = ReportEngine.calculateRiskMetrics(store: store);
      
      // Kritik risk var mı?
      expect(metrics['criticalCount'] >= 1, true);
      // Puan 60 veya altında mı? (Cezalı sistem)
      expect(metrics['score'] <= 60, true);
    });

    test('Bölüm 33: Mevcut çıkış (1), gereken çıkıştan (2) az ise KRİTİK RİSK oluşmalı', () {
      store.bolum33 = Bolum33Model(yukNormal: 120, gerekliNormal: 2, mevcutUst: 1);
      
      final metrics = ReportEngine.calculateRiskMetrics(store: store);
      
      expect(metrics['criticalCount'] >= 1, true);
      expect(metrics['score'] <= 60, true);
    });

    test('Bölüm 25: Döner merdiven genişliği < 100cm ise KRİTİK RİSK oluşmalı', () {
      store.bolum25 = Bolum25Model(genislik: Bolum25Content.genislikOptionA);
      
      final Color color = ReportEngine.getStatusColor(store.bolum25?.genislik, sectionId: 25, store: store);
      expect(color, const Color(0xFFE53935));
    });

    test('Skorlama: Sahanlıksız Merdiven varsa puan %60 altına düşmeli', () {
      store.bolum20 = Bolum20Model(sahanliksizMerdivenSayisi: 1);

      final metrics = ReportEngine.calculateRiskMetrics(store: store);
      
      // Sahanlıksız merdiven kritik risktir
      expect(metrics['criticalCount'] >= 1, true);
      // Puan 60 veya altında olmalı
      expect(metrics['score'] <= 60, true);
    });
  });
}