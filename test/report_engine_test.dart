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
      'Kriter 1: Yapı yüksekliği 51.50m ve üzeri ise YGH zorunlu olmalı',
      () {
        store.bolum3 = Bolum3Model(hYapi: 52.0, bodrumKatSayisi: 0);
        final reasons = ReportEngine.evaluateYghRequirement(store: store);
        expect(reasons.any((r) => r.contains("51.50 metre")), true);
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
        final reasons = ReportEngine.evaluateYghRequirement(store: store);
        expect(reasons.any((r) => r.contains("Bodrum katlarda")), true);
      },
    );

    test('Kriter 3: İtfaiye asansörü (22-1-B) varsa YGH zorunlu olmalı', () {
      store.bolum22 = Bolum22Model(
        varlik: ChoiceResult(
          label: "22-1-B",
          uiTitle: "",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      final reasons = ReportEngine.evaluateYghRequirement(store: store);
      expect(reasons.any((r) => r.contains("İtfaiye Asansörü")), true);
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
        final reasons = ReportEngine.evaluateYghRequirement(store: store);
        expect(
          reasons.any((r) => r.contains("Bodrum katlarda asansörün")),
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
        final reasons = ReportEngine.evaluateYghRequirement(store: store);
        expect(reasons.any((r) => r.contains("30.50m üzeri")), true);
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
        final reasons = ReportEngine.evaluateYghRequirement(store: store);
        expect(
          reasons.any((r) => r.contains("kesintisiz devam etmesi")),
          false,
        );
      },
    );
  });

  group('Dairesel Merdiven Değerlendirmesi Testleri', () {
    test(
      'Senaryo 1: Dairesel merdiven yüksekliği <= 9.50m VE kullanıcı yükü <= 25 - GEÇERLİ',
      () {
        store.bolum3 = Bolum3Model(hYapi: 20.0, bodrumKatSayisi: 0);
        store.bolum20 = Bolum20Model(
          donerMerdivenSayisi: 1,
          daireselMerdivenYuksekligi: ChoiceResult(
            label: "20-Dairesel-A",
            uiTitle: "9.50 metre veya altında",
            uiSubtitle: "",
            reportText: "",
          ),
        );
        store.bolum33 = Bolum33Model(yukZemin: 20, yukNormal: 15, yukBodrum: 0);

        final report = ReportEngine.getSectionFullReport(36, store: store);
        expect(report.contains("OLUMLU"), true);
        expect(report.contains("kaçış yolu olarak kabul edilmiştir"), true);
      },
    );

    test('Senaryo 2: Dairesel merdiven yüksekliği > 9.50m - GEÇERSİZ', () {
      store.bolum20 = Bolum20Model(
        donerMerdivenSayisi: 1,
        daireselMerdivenYuksekligi: ChoiceResult(
          label: "20-Dairesel-B",
          uiTitle: "9.50 metrenin üzerinde",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(yukZemin: 20, yukNormal: 15, yukBodrum: 0);

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("KRİTİK RİSK"), true);
      expect(report.contains("KABUL EDİLEMEZ"), true);
      expect(report.contains("9.50 metrenin üzerindedir"), true);
    });

    test('Senaryo 3: Kullanıcı yükü > 25 kişi - GEÇERSİZ', () {
      store.bolum20 = Bolum20Model(
        donerMerdivenSayisi: 1,
        daireselMerdivenYuksekligi: ChoiceResult(
          label: "20-Dairesel-A",
          uiTitle: "9.50 metre veya altında",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(yukZemin: 30, yukNormal: 28, yukBodrum: 0);

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("KRİTİK RİSK"), true);
      expect(report.contains("KABUL EDİLEMEZ"), true);
      expect(report.contains("25 kişiyi aşmaktadır"), true);
    });

    test('Senaryo 4: Yükseklik bilinmiyor - UYARI', () {
      store.bolum20 = Bolum20Model(
        donerMerdivenSayisi: 1,
        daireselMerdivenYuksekligi: ChoiceResult(
          label: "20-Dairesel-C",
          uiTitle: "Bilmiyorum",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum33 = Bolum33Model(yukZemin: 20, yukNormal: 15, yukBodrum: 0);

      final report = ReportEngine.getSectionFullReport(36, store: store);
      expect(report.contains("UYARI"), true);
      expect(report.contains("BİLİNMİYOR"), true);
    });

    test('Senaryo 5: Bölüm 34 bağımsız çıkış - Ticari alan yükü sayılmaz', () {
      store.bolum20 = Bolum20Model(
        donerMerdivenSayisi: 1,
        daireselMerdivenYuksekligi: ChoiceResult(
          label: "20-Dairesel-A",
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
      expect(report.contains("kaçış yolu olarak kabul edilmiştir"), true);
    });

    test('Senaryo 6: HER İKİ ŞART DA sağlanmıyor - Çoklu sebep', () {
      store.bolum20 = Bolum20Model(
        donerMerdivenSayisi: 1,
        daireselMerdivenYuksekligi: ChoiceResult(
          label: "20-Dairesel-B",
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
      expect(report.contains("9.50 metrenin üzerindedir"), true);
      expect(report.contains("25 kişiyi aşmaktadır"), true);
    });
  });
}
