import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/models/bolum_22_model.dart';
import 'package:life_safety/models/bolum_23_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    BinaStore.instance.reset();
  });

  group('YGH Zorunluluk Kriterleri Testleri', () {
    test('Kriter 1: Yapı yüksekliği 51.50m ve üzeri ise YGH zorunlu olmalı', () {
      BinaStore.instance.bolum4 = Bolum4Model(hesaplananYapiYuksekligi: 52.0);
      final List<String> reasons = ReportEngine.evaluateYghRequirement();
      expect(reasons.isNotEmpty, true, reason: "Liste boş dönmemeli");
      expect(reasons.any((String r) => r.contains("51.50 metre")), true);
    });

    test('Kriter 2: Bodrum katta ticari/teknik kullanım (10-C) varsa YGH zorunlu olmalı', () {
      BinaStore.instance.bolum10 = Bolum10Model(
        bodrumlar: [ChoiceResult(label: "10-C", uiTitle: "", uiSubtitle: "", reportText: "")],
      );
      final List<String> reasons = ReportEngine.evaluateYghRequirement();
      expect(reasons.any((String r) => r.contains("Bodrum katlarda")), true);
    });

    test('Kriter 3: İtfaiye asansörü (22-1-B) varsa YGH zorunlu olmalı', () {
      BinaStore.instance.bolum22 = Bolum22Model(
        varlik: ChoiceResult(label: "22-1-B", uiTitle: "", uiSubtitle: "", reportText: ""),
      );
      final List<String> reasons = ReportEngine.evaluateYghRequirement();
      expect(reasons.any((String r) => r.contains("İtfaiye Asansörü")), true);
    });

    test('Kriter 4: Bodrum kat var ve Bölüm 23 seçimi 23-1-C ise YGH zorunlu olmalı', () {
      BinaStore.instance.bolum3 = Bolum3Model(bodrumKatSayisi: 1);
      BinaStore.instance.bolum23 = Bolum23Model(
        bodrum: ChoiceResult(label: "23-1-C (Bodrum)", uiTitle: "", uiSubtitle: "", reportText: ""),
      );
      final List<String> reasons = ReportEngine.evaluateYghRequirement();
      expect(reasons.any((String r) => r.contains("Bodrum kata inen")), true);
    });

    test('Kriter 5: hYapi > 30.50m ve basınçlandırma yok (20-BAS-B) ise YGH zorunlu olmalı', () {
      BinaStore.instance.bolum4 = Bolum4Model(hesaplananYapiYuksekligi: 31.0);
      BinaStore.instance.bolum20 = Bolum20Model(
        basinclandirma: ChoiceResult(label: "20-BAS-B", uiTitle: "", uiSubtitle: "", reportText: ""),
      );
      final List<String> reasons = ReportEngine.evaluateYghRequirement();
      expect(reasons.any((String r) => r.contains("30.50m üzeri")), true);
    });
  });
}