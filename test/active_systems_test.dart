import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/bolum_22_model.dart';
import 'package:life_safety/models/bolum_23_model.dart';
import 'package:life_safety/models/bolum_35_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_16_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  group('ActiveSystemsEngine Logic Tests', () {
    final store = BinaStore.instance;

    setUp(() {
      store.clearCurrentAnalysis();
    });

    test('Yangın Algılama: hYapi >= 51.50 -> Zorunlu', () {
      store.bolum3 = Bolum3Model(hYapi: 52.0);
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Algılama"));
      expect(item.isMandatory, true);
    });

    test('Yangın Algılama: hYapi < 51.50 -> Zorunlu Değil', () {
      store.bolum3 = Bolum3Model(hYapi: 50.0);
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Algılama"));
      expect(item.isMandatory, false);
    });

    test('Sprinkler: hYapi >= 51.50 -> Zorunlu', () {
      store.bolum3 = Bolum3Model(hYapi: 52.0);
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Sprinkler"));
      expect(item.isMandatory, true);
    });

    test('Sprinkler: Otopark < 600 -> Zorunlu Değil (13-1-ALT-A)', () {
      store.bolum3 = Bolum3Model(hYapi: 10.0);
      store.bolum13 = Bolum13Model(
        otoparkAlan: ChoiceResult(
          label: "13-1-ALT-A",
          uiTitle: "600 m²'nin altında",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Sprinkler"));
      expect(item.isMandatory, false);
      expect(
        item.reason.contains("limitle"),
        true,
      ); // Check for the specific reasoning text
    });

    test('Sprinkler: Otopark Bilmiyorum -> Uyarı (13-1-ALT-E)', () {
      store.bolum3 = Bolum3Model(hYapi: 10.0);
      store.bolum13 = Bolum13Model(
        otoparkAlan: ChoiceResult(
          label: "13-1-ALT-E",
          uiTitle: "Bilmiyorum",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Sprinkler"));
      expect(item.isMandatory, false);
      expect(item.isWarning, true);
      expect(item.reason.contains("600 m²'nin üzerindeyse"), true);
      expect(item.note, "");
    });

    test('Sprinkler: Kaçış Mesafesi (35-1-C) -> Zorunlu DEĞİL artık', () {
      store.bolum3 = Bolum3Model(hYapi: 10.0);
      store.bolum6 = Bolum6Model(
        hasOtopark: false,
        hasTicari: false,
        hasDepo: false,
        isSadeceKonut: true,
      );

      // Mock ChoiceResult with label containing 35-1-C
      store.bolum35 = Bolum35Model(
        tekYon: ChoiceResult(
          label: "35-1-C",
          uiTitle: "",
          uiSubtitle: "",
          reportText: "",
        ),
      );

      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Sprinkler"));
      expect(item.isMandatory, false); // Artık zorunlu değil
    });

    test('İtfaiye Su Alma: hBina >= 21.50 -> Zorunlu', () {
      store.bolum3 = Bolum3Model(hBina: 22.0, hYapi: 22.0);
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name == "İtfaiye Su Alma Ağzı");
      expect(item.isMandatory, true);
    });

    test('Hidrant: Taban > 5000 -> Zorunlu', () {
      store.bolum5 = Bolum5Model(tabanAlani: 5001);
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Hidrant"));
      expect(item.isMandatory, true);
    });

    test(
      'Basınçlandırma: 23-5-B (Kuyu Kapalı) -> Normal Asansör Kuyu Basınçlandırma',
      () {
        store.bolum3 = Bolum3Model(hYapi: 10.0);
        store.bolum23 = Bolum23Model(
          havalandirma: ChoiceResult(
            label: "23-5-B",
            uiTitle: "",
            uiSubtitle: "",
            reportText: "",
          ),
        );
        final reqs = ActiveSystemsEngine.calculateRequirements(store);
        final item = reqs.firstWhere((e) => e.name.contains("Basınçlandırma"));
        expect(item.isMandatory, true);
        expect(item.note.contains("Normal (İnsan) asansör kuyusunda"), true);
      },
    );

    test(
      'Sismik Askılama (Uyarı): Sprinkler Zorunlu -> isWarning=true, isMandatory=false',
      () {
        // Sprinkler'i zorunlu yapacak bir durum oluştur (Örn: hYapi >= 51.50)
        store.bolum3 = Bolum3Model(hYapi: 52.0);
        final reqs = ActiveSystemsEngine.calculateRequirements(store);

        final seismicItem = reqs.firstWhere((e) => e.name.contains("Sismik"));

        expect(seismicItem.isMandatory, false);
        expect(seismicItem.isWarning, true); // Verified IsWarning
        // Not/Gerekçe içinde kullanıcı metninin bir kısmı geçmeli
        expect(
          seismicItem.reason.contains(
            "Otomatik Sprinkler sistemi zorunlu olduğu için",
          ),
          true,
        );
        expect(
          seismicItem.note.contains(
            "Birinci ve ikinci derece deprem bölgelerinde",
          ),
          true,
        );
      },
    );

    test(
      'Sismik Askılama: Sprinkler Zorunlu Değil -> Sismik Öncelikli Değil',
      () {
        store.bolum3 = Bolum3Model(hYapi: 10.0); // Düşük yükseklik
        store.bolum6 = Bolum6Model(hasOtopark: false); // Otopark yok
        // (Diğer parametreler de boş/düşük)

        final reqs = ActiveSystemsEngine.calculateRequirements(store);
        final seismicItem = reqs.firstWhere((e) => e.name.contains("Sismik"));

        expect(seismicItem.isMandatory, false);
        expect(
          seismicItem.isWarning,
          false,
        ); // No Warning if not Sprinkler mandatory
        expect(
          seismicItem.reason.contains(
            "Sprinkler sistemi zorunlu olmadığı için",
          ),
          true,
        );
      },
    );

    test(
      'Sprinkler: Bilmiyorum Durumu (Section 35) -> Uyarı VERİLMEMELİ (Sprinkler için)',
      () {
        store.bolum3 = Bolum3Model(hYapi: 10.0);
        store.bolum6 = Bolum6Model(hasOtopark: false);

        // Setup "Bilmiyorum" in Section 35
        store.bolum35 = Bolum35Model(
          tekYon: ChoiceResult(
            label: "35-1-D (Bilmiyorum)",
            uiTitle: "Bilmiyorum",
            uiSubtitle: "",
            reportText: "Bilmiyorum",
          ),
        );

        final reqs = ActiveSystemsEngine.calculateRequirements(store);
        final item = reqs.firstWhere((e) => e.name.contains("Sprinkler"));

        expect(item.isMandatory, false);
        expect(
          item.isWarning,
          false,
        ); // Artık Section 35 bilinmiyorsa Sprinkler uyarısı verilmez
      },
    );

    test('Senaryo 1: Yüksek ve Karma Kullanımlı Bina (Tüm Sistemler Zorunlu)', () {
      // 55m yükseklik, 1500m2 kapalı otopark, kazan dairesi var (Bolum 6), Kazan/Mutfak gibi alanlar gaz algılama tetikler mi? Orada `hasTicari`, `hasKazanDairesi` vs var mı bakmak lazım.
      // Sadece ana sistemlerin ZORUNLU olarak döndüğünü test edelim.
      store.bolum3 = Bolum3Model(hYapi: 55.0, hBina: 55.0);
      store.bolum5 = Bolum5Model(
        tabanAlani: 6000,
        toplamInsaatAlani: 20000,
      ); // Hidrant > 5000, YSC
      store.bolum13 = Bolum13Model(
        otoparkAlan: ChoiceResult(
          label: "13-1-ALT-D", // > 600 m2
          uiTitle: "> 600 m2",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      store.bolum6 = Bolum6Model(hasOtopark: true, hasTicari: true);

      final reqs = ActiveSystemsEngine.calculateRequirements(store);

      final mandatoryNames = reqs
          .where((r) => r.isMandatory)
          .map((r) => r.name)
          .toList();

      expect(mandatoryNames.contains("Yangın Senaryosu"), true);
      expect(mandatoryNames.contains("Yangın Algılama ve Uyarı Sistemi"), true);
      expect(mandatoryNames.contains("Sesli Tahliye (Anons) Sistemi"), true);
      expect(mandatoryNames.contains("İtfaiye Su Alma Ağzı"), true);
      expect(
        mandatoryNames.contains("Yangın Hidrant Sistemi (Bina Çevresinde)"),
        true,
      );
      // Not testing ALL of them, but making sure multiple are triggered securely
      expect(mandatoryNames.contains("Yangın Dolabı Sistemi"), true);
    });

    test('Edge Case: Siyam İkizi - Cephe Genişliği > 75m', () {
      // Diğerleri düşükken sadece cephe uzunluğu Siyam zorunluluğunu tetikler
      store.bolum3 = Bolum3Model(hYapi: 10.0, hBina: 10.0);
      store.bolum5 = Bolum5Model(tabanAlani: 500);
      store.bolum16 = Bolum16Model(
        cepheUzunlugu: Bolum16Content.cepheUzunluguKritik,
      );

      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Siyam İkizi"));

      expect(item.isMandatory, true);
      expect(item.reason.contains("Cephe Genişliği > 75m"), true);
    });

    test('Edge Case: Gaz Algılama Dedektörleri (Kazan Dairesi/Ticari)', () {
      store.bolum3 = Bolum3Model(); // Defaults
      store.bolum6 = Bolum6Model(hasTicari: true);
      // The logic in active systems checks unconditionally and returns as Warning right now,
      // but if the user wants this to be checked when Kazan Dairesi or Ticari is present, we ensure it's there as a warning.
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Gaz Algılama"));

      expect(item.isMandatory, false);
      expect(item.isWarning, true);
    });

    test(
      'Mutually Exclusive Kontrolü: isMandatory ve isWarning aynı anda true olamaz',
      () {
        store.bolum3 = Bolum3Model(hYapi: 55.0); // Karmaşık senaryo
        final reqs = ActiveSystemsEngine.calculateRequirements(store);

        for (var req in reqs) {
          if (req.isMandatory) {
            expect(
              req.isWarning,
              false,
              reason: '${req.name} hem zorunlu hem uyarı olamaz.',
            );
          }
          expect(
            req.reason.isNotEmpty,
            true,
            reason: '${req.name} için reason boş olamaz.',
          );
        }
      },
    );

    test(
      'Sıralama (Ordering) Testi: Yangın Senaryosu başta, Gaz Algılama sonda',
      () {
        // Birkaç zorunlu sistem ekleyelim
        store.bolum3 = Bolum3Model(hYapi: 55.0);
        store.bolum6 = Bolum6Model(hasTicari: true);
        final reqs = ActiveSystemsEngine.calculateRequirements(store);

        expect(reqs.first.name, "Yangın Senaryosu");
        expect(reqs.last.name, "Gaz Algılama Sistemi");
      },
    );

    test('75. TEST: Basınçlandırma - Yüksek Bina Kriteri (hYapi >= 30.50)', () {
      store.bolum3 = Bolum3Model(hYapi: 31.0);
      // Pressurization is mandatory if hYapi >= 30.50 AND there is NO Fire Lobby (21-1-B)
      store.bolum21 = Bolum21Model(
        varlik: ChoiceResult(
          label: "21-1-B",
          uiTitle: "Hayır",
          uiSubtitle: "",
          reportText: "",
        ),
      );
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Basınçlandırma"));

      expect(item.isMandatory, true);
      expect(item.note.contains("Merdivenlerin en az birinde"), true);
    });
  });
}
