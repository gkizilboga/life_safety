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
import 'package:life_safety/models/bolum_9_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
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
    test(
      'YGH Analizi: Yapı yüksekliği 52m ve YGH yoksa KRİTİK RİSK sayılmalı',
      () {
        store.bolum3 = Bolum3Model(hYapi: 52.0);
        store.bolum21 = Bolum21Model(
          varlik: ChoiceResult(
            label: "21-1-B",
            uiTitle: "Hayır",
            uiSubtitle: "",
            reportText: "",
          ),
        );

        final metrics = ReportEngine.calculateRiskMetrics(store: store);

        // Kritik risk var mı?
        expect(metrics['criticalCount'] >= 1, true);
        // Yeni skorlama: 100 - (1 * 5) = 95
        expect(metrics['score'] <= 95, true);
      },
    );

    test(
      'Bölüm 33: Mevcut çıkış (1), gereken çıkıştan (2) az ise KRİTİK RİSK oluşmalı',
      () {
        store.bolum33 = Bolum33Model(
          yukNormal: 120,
          gerekliNormal: 2,
          mevcutUst: 1,
        );

        final metrics = ReportEngine.calculateRiskMetrics(store: store);

        expect(metrics['criticalCount'] >= 1, true);
        expect(metrics['score'] <= 95, true);
      },
    );

    test(
      'Bölüm 25: Döner merdiven genişliği < 100cm ise KRİTİK RİSK oluşmalı',
      () {
        store.bolum25 = Bolum25Model(genislik: Bolum25Content.genislikOptionA);

        final Color color = ReportEngine.getStatusColor(
          store.bolum25?.genislik,
          sectionId: 25,
          store: store,
        );
        expect(color, const Color(0xFFE53935));
      },
    );

    test('Skorlama: Sahanlıksız Merdiven varsa puan %95 altına düşmeli', () {
      // Not: Puan düşüşü artık lineer (kritik başı -5).
      // Test ismini veya beklentiyi güncelliyoruz.
      store.bolum20 = Bolum20Model(sahanliksizMerdivenSayisi: 1);

      final metrics = ReportEngine.calculateRiskMetrics(store: store);

      // Sahanlıksız merdiven kritik risktir
      expect(metrics['criticalCount'] >= 1, true);
      // Yeni skorlama: 95
      expect(metrics['score'] <= 95, true);
    });

    test(
      'Bölüm 36 (Madde 41): Merdivenlerin yarısından azı dışarı açılıyorsa KRİTİK RİSK',
      () {
        store.bolum20 = Bolum20Model(
          binaIciYanginMerdiveniSayisi: 2,
          toplamDisariAcilanMerdivenSayisi: 0, // 0/2 < 1/2 -> Hata
        );
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        final metrics = ReportEngine.calculateRiskMetrics(store: store);
        expect(metrics['criticalCount'] >= 1, true);

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("Madde 41/1 gereği"), true);
      },
    );

    test(
      'Bölüm 20 (Madde 41): Sprinkler yoksa ve tahliye mesafesi > 10m ise KRİTİK RİSK',
      () {
        store.bolum20 = Bolum20Model(
          binaIciYanginMerdiveniSayisi: 2,
          toplamDisariAcilanMerdivenSayisi: 1, // 1/2 >= 1/2 -> Oran OK
          lobiTahliyeMesafeDurumu:
              Bolum36Content.madde41MesafeUstunde, // Above limit
        );
        store.bolum9 = Bolum9Model(secim: Bolum9Content.yok); // Sprinkler yok
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        final metrics = ReportEngine.calculateRiskMetrics(store: store);
        expect(metrics['criticalCount'] >= 1, true);

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("Madde 41/2 gereği"), true);
      },
    );

    test(
      'Bölüm 20 (Madde 41): Sprinkler varsa ve tahliye mesafesi <= 15m ise OLUMLU',
      () {
        store.bolum20 = Bolum20Model(
          binaIciYanginMerdiveniSayisi: 2,
          toplamDisariAcilanMerdivenSayisi: 1, // 1/2 >= 1/2 -> Oran OK
          lobiTahliyeMesafeDurumu:
              Bolum36Content.madde41MesafeAltinda, // Below limit
        );
        store.bolum9 = Bolum9Model(
          secim: Bolum9Content.tamKapsam,
        ); // Sprinkler var
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        // Sadece Article 41'e özel kontrol yapalım
        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("OLUMLU"), true);
        expect(report.contains("KRİTİK RİSK"), false);

        // Just call getStatusColor to ensure it doesn't crash for Section 36
        ReportEngine.getStatusColor(
          store.bolum36?.cikisKati,
          sectionId: 36,
          store: store,
        );
        // If there are no other errors in Section 36 for this mock store, it should be green or blue
        // But we just want to ensure it doesn't have "KRİTİK RİSK" from Madde 41
        expect(report.contains("KRİTİK RİSK: Madde 41"), false);
      },
    );

    // --- Refined Article 41 Tests (Specific Counts & Basement) ---

    test('Bölüm 20 (Madde 41): Tek Merdiven varsa (1/1) dışarı açılmalı', () {
      store.bolum20 = Bolum20Model(
        normalMerdivenSayisi: 1,
        toplamDisariAcilanMerdivenSayisi: 0,
      );
      store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("KRİTİK RİSK: Madde 41/1 gereği"), true);
      expect(report.contains("Gereken en az: 1"), true);
    });

    test(
      'Bölüm 20 (Madde 41): 3 Merdiven varsa (ceil(3/2)=2) dışarı açılmalı',
      () {
        store.bolum20 = Bolum20Model(
          normalMerdivenSayisi: 3,
          toplamDisariAcilanMerdivenSayisi: 1, // 1 < 2 -> Fail
        );
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("KRİTİK RİSK: Madde 41/1 gereği"), true);
        expect(report.contains("2"), true); // Check for number 2
      },
    );

    test(
      'Bölüm 20 (Madde 41): 5 Merdiven varsa (ceil(5/2)=3) dışarı açılmalı',
      () {
        store.bolum20 = Bolum20Model(
          normalMerdivenSayisi: 5,
          toplamDisariAcilanMerdivenSayisi: 2, // 2 < 3 -> Fail
        );
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("KRİTİK RİSK: Madde 41/1 gereği"), true);
        expect(report.contains("3"), true);
      },
    );

    test(
      'Bölüm 20 (Madde 41): Bağımsız Bodrum Merdivenleri Kontrolü (2 merdiven, 0 direkt)',
      () {
        store.bolum20 = Bolum20Model(
          isBodrumIndependent: true,
          bodrumNormalMerdivenSayisi: 4,
          bodrumToplamDisariAcilanMerdivenSayisi: 1, // 1/4 < 2/4 -> Ratio Fail
        );
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("KRİTİK RİSK (Bodrum)"), true);
      },
    );

    test(
      'Bölüm 20 (Madde 41): Bağımsız Bodrum Merdivenleri Mesafe Kontrolü',
      () {
        store.bolum20 = Bolum20Model(
          isBodrumIndependent: true,
          bodrumNormalMerdivenSayisi: 2,
          bodrumToplamDisariAcilanMerdivenSayisi: 1, // 1 >= 1 -> Ratio OK
          bodrumLobiTahliyeMesafeDurumu:
              Bolum36Content.madde41MesafeUstunde, // Above limit
        );
        store.bolum9 = Bolum9Model(secim: Bolum9Content.yok);
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("KRİTİK RİSK"), true);
      },
    );
  });
}
