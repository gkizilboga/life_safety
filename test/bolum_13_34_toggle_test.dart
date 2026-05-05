// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_34_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/utils/app_content.dart';

// ---------------------------------------------------------------------------
// Yardımcı test fabrikaları
// ---------------------------------------------------------------------------

ChoiceResult _cr(String label, String title) => ChoiceResult(
  label: label,
  uiTitle: title,
  uiSubtitle: '',
  reportText: 'Rapor: $title',
);

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() => BinaStore.instance.reset());

  // =========================================================================
  // GRUP 1: Bolum13Model — Serialization & Backward Compatibility
  // =========================================================================
  group('Bolum13Model Serializasyon ve Geriye Dönük Uyumluluk', () {
    test(
      'Yeni alanlar (ticariKapiZemin/Normal/Bodrum) toMap/fromMap ile doğru kaydedilmeli',
      () {
        final original = Bolum13Model(
          areTicariKapiSame: false,
          ticariKapiZemin: _cr('13-11-A (Ticari)', 'Evet'),
          ticariKapiNormal: _cr('13-11-B (Ticari)', 'Hayır'),
          ticariKapiBodrum: _cr('13-11-C (Ticari)', 'Geçiş Yok'),
        );

        final map = original.toMap();
        final restored = Bolum13Model.fromMap(map);

        expect(restored.areTicariKapiSame, false);
        expect(restored.ticariKapiZemin?.label, '13-11-A (Ticari)');
        expect(restored.ticariKapiNormal?.label, '13-11-B (Ticari)');
        expect(restored.ticariKapiBodrum?.label, '13-11-C (Ticari)');
      },
    );

    test(
      'Eski format: ticariKapi → ticariKapiZemin olarak yüklenmeli (backward compat)',
      () {
        // Eski kayıt formatı: sadece 'ticariKapi_label' içeriyordu
        final oldMap = {
          'ticariKapi_label': '13-11-A (Ticari)',
          'areTicariKapiSame': null, // eski dosyalarda bu alan yoktu
        };

        final restored = Bolum13Model.fromMap(oldMap);

        // Eski ticariKapi değeri zemine atanmalı, diğerleri null kalmalı
        expect(
          restored.ticariKapiZemin?.label,
          '13-11-A (Ticari)',
          reason: 'Eski ticariKapi verisi zemin katına aktarılmalı',
        );
        expect(restored.ticariKapiNormal, isNull);
        expect(restored.ticariKapiBodrum, isNull);
        // Eski dosyalarda areTicariKapiSame yoktu; varsayılan true gelmelı
        expect(restored.areTicariKapiSame, true);
      },
    );
  });

  // =========================================================================
  // GRUP 2: Bolum34Model — Serialization
  // =========================================================================
  group('Bolum34Model Serializasyon', () {
    test(
      'mutfakBacasi toMap/fromMap ile doğru kaydedilmeli',
      () {
        final original = Bolum34Model(
          mutfakBacasi: _cr('34-4-A (Mutfak Bacası)', 'Bağımsız'),
        );

        final map = original.toMap();
        final restored = Bolum34Model.fromMap(map);

        expect(restored.mutfakBacasi?.label, '34-4-A (Mutfak Bacası)');
      },
    );
  });

  // =========================================================================
  // GRUP 3: ReportEngine — Bölüm 13 Toggle ON (Unified) Raporu
  // =========================================================================
  group('ReportEngine — Bölüm 13 Toggle ON (Unified) Raporu', () {
    test('Toggle ON: tüm katlar için tek rapor satırı basılmalı', () {
      final choice = _cr('13-11-A (Ticari)', 'Evet');
      BinaStore.instance.bolum13 = Bolum13Model(
        areTicariKapiSame: true,
        // Unified seçimde her üç kat aynı değeri taşır
        ticariKapiZemin: choice,
        ticariKapiNormal: choice,
        ticariKapiBodrum: choice,
      );

      final report = ReportEngine.getSectionFullReport(
        13,
        store: BinaStore.instance,
      );

      expect(
        report.contains('Tüm Ticari Alanların Kapıları'),
        true,
        reason: 'Unified modda tek ortak başlık basılmalı',
      );
    });

    test('Toggle OFF: her kat için ayrı rapor satırı basılmalı', () {
      BinaStore.instance.bolum13 = Bolum13Model(
        areTicariKapiSame: false,
        ticariKapiZemin: _cr('13-11-A (Ticari)', 'Evet'),
        ticariKapiNormal: _cr('13-11-B (Ticari)', 'Hayır'),
        ticariKapiBodrum: _cr('13-11-C (Ticari)', 'Geçiş Yok'),
      );

      final report = ReportEngine.getSectionFullReport(
        13,
        store: BinaStore.instance,
      );

      expect(report.contains('Zemin Kat Ticari Alan Kapısı'), true);
      expect(report.contains('Normal Kat Ticari Alan Kapısı'), true);
      expect(report.contains('Bodrum Kat Ticari Alan Kapısı'), true);
    });
  });

  // =========================================================================
  // GRUP 4: ReportEngine — Bölüm 34 Raporu
  // =========================================================================
  group('ReportEngine — Bölüm 34 Raporu', () {
    test(
      'Mutfak bacası raporu basılmalı',
      () {
        BinaStore.instance.bolum34 = Bolum34Model(
          mutfakBacasi: Bolum34Content.mutfakBacasiOptionA,
        );

        final report = ReportEngine.getSectionFullReport(
          34,
          store: BinaStore.instance,
        );

        expect(report.contains('Mutfak Bacası'), true);
      },
    );
  });

  // =========================================================================
  // GRUP 5: Risk Seviyesi Hesabı
  // =========================================================================
  group('Bölüm 13 Risk Seviyesi — Kat Bazlı Ticari Alan', () {
    test(
      'Bodrum katta riskli geçiş (13-11-B) varsa bölüm risk seviyesi düşük/kritik olmalı',
      () {
        BinaStore.instance.bolum13 = Bolum13Model(
          areTicariKapiSame: false,
          ticariKapiBodrum: Bolum13Content.ticariOptionB, // Hayır
        );

        final level = ReportEngine.getSectionRiskLevel(
          13,
          store: BinaStore.instance,
        );
        expect(level, isNotNull);
        final levelName = level.toString().toLowerCase();
        expect(
          levelName.contains('ok') || levelName.contains('olumlu'),
          false,
        );
      },
    );
  });

  // =========================================================================
  // GRUP 6: getSectionDetailedReport — Bölüm 13 Toggle Doğrulaması
  // =========================================================================
  group('getSectionDetailedReport — Bölüm 13 Toggle Doğrulaması', () {
    test('Bölüm 13 Toggle ON: detaylı raporda "Tüm ticari alanlardan" etiketi gelmeli', () {
      final good = Bolum13Content.ticariOptionA;
      BinaStore.instance.bolum13 = Bolum13Model(
        areTicariKapiSame: true,
        ticariKapiZemin: good,
        ticariKapiNormal: good,
        ticariKapiBodrum: good,
      );

      final details = ReportEngine.getSectionDetailedReport(13, store: BinaStore.instance);
      expect(
        details.any((d) => (d['label'] as String).contains('Tüm ticari alanlardan')),
        true,
      );
    });

    test('Bölüm 13 Toggle OFF: detaylı raporda her kat için ayrı etiket gelmeli', () {
      BinaStore.instance.bolum13 = Bolum13Model(
        areTicariKapiSame: false,
        ticariKapiZemin: Bolum13Content.ticariOptionA,
        ticariKapiNormal: Bolum13Content.ticariOptionB,
      );

      final details = ReportEngine.getSectionDetailedReport(13, store: BinaStore.instance);
      expect(
        details.any((d) => (d['label'] as String).contains('Zemin kattaki')),
        true,
      );
      expect(
        details.any((d) => (d['label'] as String).contains('Normal katlardaki')),
        true,
      );
    });
  });
}
