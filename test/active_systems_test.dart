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

    test('Sprinkler: Otopark > 600 -> Zorunlu', () {
      store.bolum3 = Bolum3Model(hYapi: 10.0);
      store.bolum6 = Bolum6Model(
        hasOtopark: true,
        hasTicari: false,
        hasDepo: false,
        isSadeceKonut: false,
        otoparkTipi: null,
        kapaliOtoparkAlani: 601,
      );
      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Sprinkler"));
      expect(item.isMandatory, true);
    });

    test('Sprinkler: Kaçış Mesafesi (35-1-C) -> Zorunlu', () {
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
      expect(item.isMandatory, true);
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
          seismicItem.reason.contains("Sprinkler) sistemi zorunlu olduğu için"),
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

    test('Sprinkler: Bilmiyorum Durumu (Section 35) -> Uyarı verilmeli', () {
      store.bolum3 = Bolum3Model(hYapi: 10.0);
      store.bolum6 = Bolum6Model(hasOtopark: false);

      // Setup "Bilmiyorum" in Section 35
      store.bolum35 = Bolum35Model(
        tekYon: ChoiceResult(
          label: "35-1-D (Bilmiyorum)", // Mock label with key text
          uiTitle: "Bilmiyorum",
          uiSubtitle: "",
          reportText: "Bilmiyorum",
        ),
      );

      final reqs = ActiveSystemsEngine.calculateRequirements(store);
      final item = reqs.firstWhere((e) => e.name.contains("Sprinkler"));

      expect(item.isMandatory, false); // Not mandatory automatically
      expect(item.isWarning, true); // But warned
      expect(item.reason.contains("Bilmiyorum"), true);
      expect(item.note.contains("Yangın Güvenlik Uzmanı"), true);
    });
  });
}
