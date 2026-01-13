import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/models/bolum_22_model.dart';
import 'package:life_safety/models/bolum_23_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
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
}
