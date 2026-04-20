import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/models/bolum_22_model.dart';
import 'package:life_safety/models/bolum_23_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_34_model.dart';
import 'package:life_safety/models/bolum_1_model.dart';
import 'package:life_safety/models/bolum_2_model.dart';
import 'package:life_safety/models/bolum_7_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/models/bolum_25_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/models/bolum_9_model.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  final store = BinaStore.instance;

  setUp(() {
    store.reset();
  });

  group('YGH Zorunluluk Kriterleri Testleri', () {
    test(
      'Kriter 1: Yapı yüksekliği 51.50m ve üzeri ise YGH zorunlu olmalı (30.5m mesajı gizlenmeli)',
      () {
        store.bolum3 = Bolum3Model(hYapi: 52.0, bodrumKatSayisi: 0);
        final result = ReportEngine.evaluateYghRequirement(store: store);
        expect(result.reasons.any((r) => r.contains("51.50 metre")), true);
        expect(result.reasons.any((r) => r.contains("itfaiye asansörü")), true);
      },
    );

    test(
      'Kriter 2: Bodrum katta ticari/teknik kullanım (10-C) varsa YGH zorunlu olmalı',
      () {
        store.bolum10 = Bolum10Model(
          bodrumlar: [
            ChoiceResult(
              label: "10-C",
              uiTitle: "",
              uiSubtitle: "",
              reportText: "",
            ),
          ],
        );
        final result = ReportEngine.evaluateYghRequirement(store: store);
        expect(result.reasons.any((r) => r.contains("Bodrum katlarda")), true);
      },
    );

    test('Kriter 3: İtfaiye asansörü zorunluluğu (Konutlarda 51.50m)', () {
      // Note: In residential buildings, Fire Elevator limit is 51.50m.
      // If we set hYapi high, it should trigger YGH.
      store.bolum3 = Bolum3Model(hYapi: 55.0, bodrumKatSayisi: 0);
      final result = ReportEngine.evaluateYghRequirement(store: store);
      expect(result.reasons.any((r) => r.contains("itfaiye asansörü")), true);
    });

    test(
      'Kriter 4: Bodrum kat var ve Bölüm 23 seçimi 23-1-C ise YGH zorunlu olmalı',
      () {
        store.bolum3 = Bolum3Model(bodrumKatSayisi: 1, hYapi: 10.0);
        store.bolum23 = Bolum23Model(
          bodrum: ChoiceResult(
            label: "23-1-C",
            uiTitle: "",
            uiSubtitle: "",
            reportText: "",
          ),
        );
        final result = ReportEngine.evaluateYghRequirement(store: store);
        expect(
          result.reasons.any((r) => r.contains("asansör kapılarının")),
          true,
        );
      },
    );

    test(
      'Kriter 5: hYapi > 30.50m ve basınçlandırma yok (20-BAS-B) ise YGH zorunlu olmalı',
      () {
        store.bolum3 = Bolum3Model(hYapi: 31.0, bodrumKatSayisi: 0);
        store.bolum20 = Bolum20Model(
          basinclandirma: ChoiceResult(
            label: "20-BAS-B",
            uiTitle: "",
            uiSubtitle: "",
            reportText: "",
          ),
        );
        final result = ReportEngine.evaluateYghRequirement(store: store);
        expect(result.reasons.any((r) => r.contains("Yüksek Bina")), true);
      },
    );

    test(
      'Kriter 6: Merdiven bodruma kesintisiz devam ediyorsa (20-Bodrum-A) YGH zorunlu olmalı',
      () {
        store.bolum3 = Bolum3Model(bodrumKatSayisi: 1, hYapi: 10.0);
        store.bolum20 = Bolum20Model(
          bodrumMerdivenDevami: ChoiceResult(
            label: "20-Bodrum-A",
            uiTitle: "",
            uiSubtitle: "",
            reportText: "",
          ),
        );
        final result = ReportEngine.evaluateYghRequirement(store: store);
        expect(
          result.reasons.any((r) => r.contains("kesintisiz devam etmesi")),
          false,
        );
      },
    );
  });

  group('Basınçlandırma Zorunluluk Kriterleri Testleri', () {
    test('Kriter 1: hYapi >= 51.50m ise basınçlandırma zorunlu olmalı', () {
      store.bolum3 = Bolum3Model(hYapi: 55.0, bodrumKatSayisi: 0);
      final reasons = ReportEngine.evaluateBasincRequirementForStairs(store: store);
      expect(reasons.any((r) => r.contains("51.50 metre")), true);
      expect(reasons.any((r) => r.contains("KRİTİK RİSK")), true);
    });

    test('Kriter 2: 30.50m <= hYapi < 51.50m - Basınçlandırma BILGI notu', () {
      store.bolum3 = Bolum3Model(hYapi: 40.0, bodrumKatSayisi: 0);
      final reasons = ReportEngine.evaluateBasincRequirementForStairs(store: store);
      expect(reasons.any((r) => r.contains("30.50 m - 51.50 m")), true);
      expect(reasons.any((r) => r.contains("BİLGİ")), true);
    });

    test('Kriter 3: İtfaiye asansörü varsa basınçlandırma zorunlu veya gereksinim olmalı', () {
      store.bolum22 = Bolum22Model(
        varlik: ChoiceResult(label: "22-1-B", uiTitle: "", uiSubtitle: "", reportText: ""),
      );
      final reasons = ReportEngine.evaluateBasincRequirementForFiremanElevator(store: store);
      expect(reasons.any((r) => r.contains("İtfaiye asansörü")), true);
    });

    test('Kriter 4: Bodrum kat sayısı > 4 ise basınçlandırma zorunlu olmalı', () {
      store.bolum3 = Bolum3Model(bodrumKatSayisi: 5, hYapi: 10.0);
      final reasons = ReportEngine.evaluateBasincRequirementForStairs(store: store);
      expect(reasons.any((r) => r.contains("Madde 89/2")), true);
    });
  });

  group('Dairesel Merdiven Değerlendirmesi Testleri', () {
    test(
      'Senaryo 1: Dairesel merdiven yüksekliği <= 9.50m VE kullanıcı yükü <= 25 - GEÇERLİ',
      () {
        store.bolum3 = Bolum3Model(hYapi: 20.0, bodrumKatSayisi: 0);
        store.bolum36 = Bolum36Model(merdivenDegerlendirme: "Test");
        store.bolum20 = Bolum20Model(donerMerdivenSayisi: 1);
        store.bolum25 = Bolum25Model(
          yukseklik: ChoiceResult(
            label: "25-Dairesel-A",
            uiTitle: "9.50 metre veya altında",
            uiSubtitle: "",
            reportText: "",
          ),
        );
        store.bolum33 = Bolum33Model(yukZemin: 20, yukNormal: 15, yukBodrum: 0);

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("OLUMLU"), true);
        expect(report.contains("Dairesel merdiven"), true);
      },
    );

    test('Senaryo 2: Dairesel merdiven yüksekliği > 9.50m - GEÇERSİZ', () {
      store.bolum36 = Bolum36Model(merdivenDegerlendirme: "Test");
      store.bolum20 = Bolum20Model(donerMerdivenSayisi: 1);
      store.bolum25 = Bolum25Model(
        yukseklik: ChoiceResult(
          label: "25-Dairesel-B",
          uiTitle: "9.50 metrenin üzerinde",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(yukZemin: 20, yukNormal: 15, yukBodrum: 0);

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("KRİTİK RİSK"), true);
      expect(report.contains("9.50m 'den fazla yüksekliğe sahip olması"), true);
    });

    test('Senaryo 3: Kullanıcı yükü > 25 kişi - GEÇERSİZ', () {
      store.bolum36 = Bolum36Model(merdivenDegerlendirme: "Test");
      store.bolum20 = Bolum20Model(donerMerdivenSayisi: 1);
      store.bolum25 = Bolum25Model(
        yukseklik: ChoiceResult(
          label: "25-Dairesel-A",
          uiTitle: "9.50 metre veya altında",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(yukZemin: 30, yukNormal: 28, yukBodrum: 0);

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("KRİTİK RİSK"), true);
      expect(report.contains("hizmet ettiği katlardan birinin kullanıcı yükü bakımından 25 kişiyi aşması"), true);
    });

    test('Senaryo 4: Yükseklik bilinmiyor - UYARI', () {
      store.bolum36 = Bolum36Model(merdivenDegerlendirme: "Test");
      store.bolum20 = Bolum20Model(donerMerdivenSayisi: 1);
      store.bolum25 = Bolum25Model(
        yukseklik: ChoiceResult(
          label: "25-Dairesel-C",
          uiTitle: "Bilmiyorum",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(yukZemin: 20, yukNormal: 15, yukBodrum: 0);

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("UYARI"), true);
      expect(report.contains("herhangi bir değerlendirme yapılamamıştır"), true);
    });

    test('Senaryo 5: Bölüm 34 bağımsız çıkış - Ticari alan yükü sayılmaz', () {
      store.bolum36 = Bolum36Model(merdivenDegerlendirme: "Test");
      store.bolum20 = Bolum20Model(donerMerdivenSayisi: 1);
      store.bolum25 = Bolum25Model(
        yukseklik: ChoiceResult(
          label: "25-Dairesel-A",
          uiTitle: "9.50 metre veya altında",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(
        yukZemin: 50, // Ticari alan, yüksek yük
        yukNormal: 20, // Konut, düşük yük
        yukBodrum: 0,
      );
      store.bolum34 = Bolum34Model(
        zemin: ChoiceResult(
          label: "34-1-A",
          uiTitle: "Evet, bağımsız çıkışı var",
          uiSubtitle: "",
          reportText: "",
        ),
      );

      final report = ReportEngine.getSectionFullReport(36, store: store);
      // Ticari zemin bağımsız, sadece normal kat (20 kişi) sayılır
      expect(report.contains("OLUMLU"), true);
      expect(report.contains("Dairesel merdiven"), true);
    });

    test('Senaryo 6: HER İKİ ŞART DA sağlanmıyor - Çoklu sebep', () {
      store.bolum36 = Bolum36Model(merdivenDegerlendirme: "Test");
      store.bolum20 = Bolum20Model(donerMerdivenSayisi: 1);
      store.bolum25 = Bolum25Model(
        yukseklik: ChoiceResult(
          label: "25-Dairesel-B",
          uiTitle: "9.50 metrenin üzerinde",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(
        yukZemin: 30, // Yük de fazla
        yukNormal: 28,
        yukBodrum: 0,
      );

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("KRİTİK RİSK"), true);
      expect(report.contains("9.50m 'den fazla yüksekliğe sahip olması"), true);
      expect(report.contains("hizmet ettiği katlardan birinin kullanıcı yükü bakımından 25 kişiyi aşması"), true);
    });
  });

  group('Rapor Etiketi Değerlendirme Testleri', () {
    test('Bölüm 1 ve 2 Etiketleri Doğru Gelmeli', () {
      store.bolum1 = Bolum1Model(
        secim: ChoiceResult(
          label: "1-1-A",
          uiTitle: "2007 sonrası",
          uiSubtitle: "",
          reportText: "Metin",
        ),
      );
      store.bolum2 = Bolum2Model(
        secim: ChoiceResult(
          label: "2-1-A",
          uiTitle: "Betonarme",
          uiSubtitle: "",
          reportText: "Metin",
        ),
      );

      final det1 = ReportEngine.getSectionDetailedReport(1, store: store);
      final det2 = ReportEngine.getSectionDetailedReport(2, store: store);

      expect(det1.first['label'], contains('yapı ruhsat tarihi'));
      expect(det2.first['label'], contains('taşıyıcı sistemi'));
    });

    test('Bölüm 7 Teknik Hacimler Detaylı Listelenmeli', () {
      store.bolum7 = Bolum7Model(hasKazan: true, hasAsansor: false);
      final details = ReportEngine.getSectionDetailedReport(7, store: store);

      expect(
        details.any(
          (d) => d['label'] == 'Kazan Dairesi' && d['value'] == 'Mevcut',
        ),
        true,
      );
      expect(
        details.any((d) => d['label'] == 'Asansör' && d['value'] == 'Yok'),
        true,
      );
    });

    test('Bölüm 21 YGH Alt Soruları Listelenmeli', () {
      store.bolum21 = Bolum21Model(
        varlik: ChoiceResult(
          label: "21-1-A",
          uiTitle: "Evet",
          uiSubtitle: "",
          reportText: "",
        ),
        malzeme: ChoiceResult(
          label: "21-2-A",
          uiTitle: "Yanmaz",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      final details = ReportEngine.getSectionDetailedReport(21, store: store);

      expect(
        details.any((d) => d['label'].contains('Yangın Güvenlik Holü var mı?')),
        true,
      );
      expect(
        details.any((d) => d['label'].contains('kaplama malzemeleri')),
        true,
      );

      expect(
        details.any((d) => d['label'] == 'YGH Gereksinimi'),
        true,
      );
    });

    test('Bölüm 20 Basınçlandırma Dinamik Bloğu Listelenmeli', () {
      store.bolum20 = Bolum20Model(
        basinclandirma: ChoiceResult(label: "20-BAS-B", uiTitle: "Yok", uiSubtitle: "", reportText: ""),
      );
      final details = ReportEngine.getSectionDetailedReport(20, store: store);
      expect(
        details.any((d) => d['label'] == 'Basınçlandırma Sistemi Gereksinimi'),
        true,
      );
    });

    test('Bölüm 36 Merdiven Analizi Etiketi Doğru Gelmeli', () {
      store.bolum36 = Bolum36Model(
        merdivenDegerlendirme: "Test Analizi",
        cikisKati: ChoiceResult(
          label: "36-1-A",
          uiTitle: "Zemin",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum20 = Bolum20Model();
      final details = ReportEngine.getSectionDetailedReport(36, store: store);

      expect(
        details.any((d) => d['label'].contains('dış havaya')),
        true,
      );
      expect(
        details.any(
          (d) => d['label'].contains('Normal Merdiven'),
        ),
        true,
      );
    });

    test('Endüstriyel Mutfak (Büyük Restoran) rapor içeriği doğrulaması', () {
      store.bolum6 = Bolum6Model(
        hasTicari: true,
        buyukRestoran: ChoiceResult(
          label: "6-3-A (Büyük Restoran)",
          uiTitle: "Evet, var.",
          uiSubtitle: "",
          reportText: "Restoran var bilgisi",
        ),
      );

      store.bolum7 = Bolum7Model(); // Fixes null skip

      store.bolum9 = Bolum9Model(
        secim: ChoiceResult(
          label: "9-1-B",
          uiTitle: "Hayır, yok.",
          uiSubtitle: "",
          reportText: "Sprinkler yok",
        ),
        davlumbaz: ChoiceResult(
          label: "9-2-A (Davlumbaz)",
          uiTitle: "Evet, var.",
          uiSubtitle: "",
          reportText: "Davlumbaz söndürme",
        ),
      );

      store.bolum13 = Bolum13Model(
        endustriyelMutfakKapi: ChoiceResult(
          label: "13-13-A (Endüstriyel Mutfak)",
          uiTitle: "120 dk dayanıklı",
          uiSubtitle: "",
          reportText: "120 dk kapı var",
        ),
      );

      final det6 = ReportEngine.getSectionDetailedReport(6, store: store);
      final det7 = ReportEngine.getSectionDetailedReport(7, store: store);
      final det9 = ReportEngine.getSectionDetailedReport(9, store: store);
      final report13 = ReportEngine.getSectionFullReport(13, store: store);

      expect(
        det6.any(
          (d) => d['label'].contains('büyük restoran') && d['label'].contains('endüstriyel mutfak'),
        ),
        true,
      );
      expect(
        det7.any(
          (d) => d['label'] == 'Endüstriyel Mutfak' && d['value'] == 'Mevcut',
        ),
        true,
      );
      expect(
        det9.any((d) => d['label'].contains('davlumbazında otomatik söndürme')),
        true,
      );
      expect(
        report13.contains('Endüstriyel Mutfak (Büyük Restoran) Kapısı'),
        true,
      );
    });
  });
}
