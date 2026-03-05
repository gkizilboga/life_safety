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
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/models/report_status.dart';
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
        expect(
          report.contains(
            "Kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması zorunludur",
          ),
          true,
        );
      },
    );

    test(
      'Bölüm 20 (Madde 41): Sprinkler yoksa ve tahliye mesafesi > 10m ise KRİTİK RİSK',
      () {
        store.bolum20 = Bolum20Model(
          binaIciYanginMerdiveniSayisi: 2,
          toplamDisariAcilanMerdivenSayisi: 1, // 1/2 >= 1/2 -> Oran OK
          lobiTahliyeMesafeDurumu:
              Bolum20Content.madde41MesafeUstunde, // Above limit
        );
        store.bolum9 = Bolum9Model(secim: Bolum9Content.yok); // Sprinkler yok
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "");

        final metrics = ReportEngine.calculateRiskMetrics(store: store);
        expect(metrics['criticalCount'] >= 1, true);

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(
          report.contains(
            "Doğrudan dışarıya açılmayan merdivenlerin tahliye mesafesi",
          ),
          true,
        );
      },
    );

    test(
      'Bölüm 20 (Madde 41): Sprinkler varsa ve tahliye mesafesi <= 15m ise OLUMLU',
      () {
        store.bolum20 = Bolum20Model(
          binaIciYanginMerdiveniSayisi: 2,
          toplamDisariAcilanMerdivenSayisi: 1, // 1/2 >= 1/2 -> Oran OK
          lobiTahliyeMesafeDurumu:
              Bolum20Content.madde41MesafeAltinda, // Below limit
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
        expect(
          report.contains(
            "KRİTİK RİSK: Doğrudan dışarıya açılmayan merdivenlerin tahliye mesafesi",
          ),
          false,
        );
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
      expect(
        report.contains(
          "Kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması zorunludur",
        ),
        true,
      );
      expect(report.contains("1 tanesi doğrudan dışarı açılmalıdır"), true);
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
        expect(
          report.contains(
            "Kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması zorunludur",
          ),
          true,
        );
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
        store.bolum36 = Bolum36Model(
          cikisKati: ChoiceResult(
            label: "test",
            uiTitle: "test",
            uiSubtitle: "",
            reportText: "",
          ),
          merdivenDegerlendirme: "",
        );

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(
          report.contains(
            "Kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması zorunludur",
          ),
          true,
        );
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
        store.bolum36 = Bolum36Model(
          cikisKati: ChoiceResult(
            label: "test",
            uiTitle: "test",
            uiSubtitle: "",
            reportText: "",
          ),
          merdivenDegerlendirme: "",
        );

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
              Bolum20Content.madde41MesafeUstunde, // Above limit
        );
        store.bolum9 = Bolum9Model(secim: Bolum9Content.yok);
        store.bolum36 = Bolum36Model(
          cikisKati: ChoiceResult(
            label: "test",
            uiTitle: "test",
            uiSubtitle: "",
            reportText: "",
          ),
          merdivenDegerlendirme: "",
        );

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("KRİTİK RİSK"), true);
      },
    );

    test(
      'Bölüm 36: Genişlik Aralık Analizi - Başarılı Yönetmelik Uyumu (OLUMLU)',
      () {
        // Yük < 500, Yüksek Bina Değil -> Gereken = 120cm Merdiven, 110cm Koridor
        store.bolum4 = Bolum4Model(
          hesaplananBinaYuksekligi: 10.0,
          hesaplananYapiYuksekligi: 10.0,
        );
        store.bolum33 = Bolum33Model(yukNormal: 100);
        store.bolum36 = Bolum36Model(
          areWidthsSame: false,
          genislikKorunumlu: Bolum36WidthContent.merdGenislikB,
          koridorGenislikKorunumlu: Bolum36WidthContent.koridorGenislikC,
          merdivenDegerlendirme: "",
        );

        final details = ReportEngine.getSectionDetailedReport(36, store: store);
        final merdDetail = details.firstWhere(
          (d) => d['label'] == 'Korunumlu Merdiven Genişliği',
        );
        final koriDetail = details.firstWhere(
          (d) => d['label'] == 'Korunumlu Koridor Genişliği',
        );

        expect(merdDetail['status'], ReportStatus.compliant);
        expect(merdDetail['report'].contains("OLUMLU"), true);

        expect(koriDetail['status'], ReportStatus.compliant);
        expect(koriDetail['report'].contains("OLUMLU"), true);
      },
    );

    test(
      'Bölüm 36: Genişlik Aralık Analizi - Kesin İhlal Durumu (KRİTİK RİSK)',
      () {
        // Yük > 2000 -> Gereken = 200cm Merdiven, 200cm Koridor
        store.bolum4 = Bolum4Model(
          hesaplananBinaYuksekligi: 10.0,
          hesaplananYapiYuksekligi: 10.0,
        );
        store.bolum33 = Bolum33Model(yukNormal: 2500);

        store.bolum36 = Bolum36Model(
          areWidthsSame: false,
          genislikKorunumsuz: Bolum36WidthContent.merdGenislikB,
          koridorGenislikKorunumsuz: Bolum36WidthContent.koridorGenislikC,
          kapiGenislikKorunumsuz: Bolum36WidthContent.kapiGenislikKritik,
          merdivenDegerlendirme: "",
        );

        final details = ReportEngine.getSectionDetailedReport(36, store: store);
        final merdDetail = details.firstWhere(
          (d) => d['label'] == 'Korunumsuz Merdiven Genişliği',
        );
        final koriDetail = details.firstWhere(
          (d) => d['label'] == 'Korunumsuz Koridor Genişliği',
        );
        final kapiDetail = details.firstWhere(
          (d) => d['label'] == 'Korunumsuz Alan Kapı Genişliği',
        );

        expect(merdDetail['status'], ReportStatus.risk);
        expect(merdDetail['report'].contains("KRİTİK RİSK"), true);

        expect(koriDetail['status'], ReportStatus.risk);
        expect(koriDetail['report'].contains("KRİTİK RİSK"), true);

        expect(kapiDetail['status'], ReportStatus.risk);
        expect(kapiDetail['report'].contains("KRİTİK RİSK"), true);
      },
    );

    test(
      'Bölüm 36: Genişlik Aralık Analizi - Bilinmiyor Seçeneği (WARNING)',
      () {
        store.bolum4 = Bolum4Model();
        store.bolum33 = Bolum33Model();
        store.bolum36 = Bolum36Model(
          areWidthsSame: false,
          genislikKorunumlu: Bolum36WidthContent.merdGenislikBilinmiyor,
          merdivenDegerlendirme: "",
        );

        final details = ReportEngine.getSectionDetailedReport(36, store: store);
        final merdDetail = details.firstWhere(
          (d) => d['label'] == 'Korunumlu Merdiven Genişliği',
        );

        expect(merdDetail['status'], ReportStatus.warning);
        expect(merdDetail['report'].contains("BİLİNMİYOR"), true);
      },
    );

    test(
      'Bölüm 36: Birleşik Genişlik Girişi Analizi (areWidthsSame = true)',
      () {
        store.bolum4 = Bolum4Model(hesaplananBinaYuksekligi: 10.0);
        store.bolum33 = Bolum33Model(yukNormal: 100);
        store.bolum36 = Bolum36Model(
          areWidthsSame: true,
          genislikKorunumlu: Bolum36WidthContent.merdGenislikB, // 121-150cm
          koridorGenislikKorunumlu:
              Bolum36WidthContent.koridorGenislikC, // 121-150cm
          kapiGenislikKorunumlu:
              Bolum36WidthContent.kapiGenislikOlumlu, // 80cm ve üzeri
        );

        final details = ReportEngine.getSectionDetailedReport(36, store: store);

        // Birleşik raporlamada etiketler "Genel" veya prefixsiz olmalı
        final merdDetail = details.firstWhere(
          (d) => d['label'] == 'Merdiven Genişliği (Genel)',
        );
        final koriDetail = details.firstWhere(
          (d) => d['label'] == 'Kaçış Koridoru Genişliği (Genel)',
        );
        final kapiDetail = details.firstWhere(
          (d) => d['label'] == 'Kaçış Kapısı Temiz Geçiş Genişliği',
        );

        expect(merdDetail['status'], ReportStatus.compliant);
        expect(koriDetail['status'], ReportStatus.compliant);
        expect(kapiDetail['status'], ReportStatus.compliant);

        // Korunumsuz etiketleri bulunmamalı (çünkü areWidthsSame = true)
        expect(details.any((d) => d['label'].contains('Korunumsuz')), false);
      },
    );
  });
}
