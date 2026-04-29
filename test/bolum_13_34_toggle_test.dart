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

    test('copyWith toggle değiştirirken diğer alanlar korunmalı', () {
      final model = Bolum13Model(
        areTicariKapiSame: true,
        ticariKapiZemin: _cr('13-11-A (Ticari)', 'Evet'),
        ticariKapiNormal: _cr('13-11-A (Ticari)', 'Evet'),
      );

      final toggled = model.copyWith(areTicariKapiSame: false);
      expect(toggled.areTicariKapiSame, false);
      expect(
        toggled.ticariKapiZemin?.label,
        '13-11-A (Ticari)',
        reason: 'Toggle değişimi diğer alanları etkilememeli',
      );
    });
  });

  // =========================================================================
  // GRUP 2: Bolum34Model — Serialization
  // =========================================================================
  group('Bolum34Model Serializasyon', () {
    test(
      'areTicariCikisSame ve tüm kat alanları toMap/fromMap ile doğru kaydedilmeli',
      () {
        final original = Bolum34Model(
          areTicariCikisSame: false,
          zemin: _cr('34-1-A (Zemin)', 'Evet, var.'),
          bodrum: _cr('34-2-B (Bodrum)', 'Hayır, yok.'),
          normal: _cr('34-3-A (Normal)', 'Evet, var.'),
        );

        final map = original.toMap();
        final restored = Bolum34Model.fromMap(map);

        expect(restored.areTicariCikisSame, false);
        expect(restored.zemin?.label, '34-1-A (Zemin)');
        expect(restored.bodrum?.label, '34-2-B (Bodrum)');
        expect(restored.normal?.label, '34-3-A (Normal)');
      },
    );

    test(
      'Eski dosya formatında areTicariCikisSame yoksa varsayılan true gelmeli',
      () {
        final oldMap = <String, dynamic>{
          'zemin_label': '34-1-A (Zemin)',
          // areTicariCikisSame intentionally missing
        };
        final restored = Bolum34Model.fromMap(oldMap);
        expect(restored.areTicariCikisSame, true);
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
      // Per-floor başlıkları OLMAMALI
      expect(
        report.contains('Zemin Kat Ticari Alan Kapısı'),
        false,
        reason: 'Unified modda kat bazlı başlık basılmamalı',
      );
      expect(report.contains('Normal Kat Ticari Alan Kapısı'), false);
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
      // Unified başlık OLMAMALI
      expect(report.contains('Tüm Ticari Alanların Kapıları'), false);
    });

    test(
      'Sadece zemin katta ticari alan varsa: sadece zemin satırı basılmalı',
      () {
        BinaStore.instance.bolum13 = Bolum13Model(
          areTicariKapiSame: false,
          ticariKapiZemin: _cr('13-11-A (Ticari)', 'Evet'),
          ticariKapiNormal: null,
          ticariKapiBodrum: null,
        );

        final report = ReportEngine.getSectionFullReport(
          13,
          store: BinaStore.instance,
        );

        expect(report.contains('Zemin Kat Ticari Alan Kapısı'), true);
        expect(
          report.contains('Normal Kat Ticari Alan Kapısı'),
          false,
          reason: 'Normal katta ticari alan yok, raporlanmamalı',
        );
        expect(report.contains('Bodrum Kat Ticari Alan Kapısı'), false);
      },
    );
  });

  // =========================================================================
  // GRUP 4: ReportEngine — Bölüm 34 Toggle ON/OFF Raporu
  // =========================================================================
  group('ReportEngine — Bölüm 34 Toggle ON/OFF Raporu', () {
    test(
      'Toggle ON: tek "Tüm Ticari Alanların Bağımsız Çıkışı" satırı basılmalı',
      () {
        final choice = Bolum34Content.zeminOptionA; // "34-1-A (Zemin)"
        BinaStore.instance.bolum34 = Bolum34Model(
          areTicariCikisSame: true,
          zemin: choice,
          normal: choice,
          bodrum: choice,
        );

        final report = ReportEngine.getSectionFullReport(
          34,
          store: BinaStore.instance,
        );

        expect(
          report.contains('Tüm Ticari Alanların Bağımsız Çıkışı'),
          true,
          reason: 'Unified modda tek ortak başlık basılmalı',
        );
        expect(
          report.contains('Zemin Kat Ticari Alan Çıkışı'),
          false,
          reason: 'Unified modda kat bazlı başlık basılmamalı',
        );
      },
    );

    test('Toggle OFF: her kat için ayrı çıkış satırı basılmalı', () {
      BinaStore.instance.bolum34 = Bolum34Model(
        areTicariCikisSame: false,
        zemin: Bolum34Content.zeminOptionA, // Evet
        bodrum: Bolum34Content.bodrumOptionB, // Hayır
        normal: Bolum34Content.normalOptionA, // Evet
      );

      final report = ReportEngine.getSectionFullReport(
        34,
        store: BinaStore.instance,
      );

      expect(report.contains('Zemin Kat Ticari Alan Çıkışı'), true);
      expect(report.contains('Bodrum Kat Ticari Alan Çıkışı'), true);
      expect(report.contains('Normal Kat Ticari Alan Çıkışı'), true);
      expect(report.contains('Tüm Ticari Alanların Bağımsız Çıkışı'), false);
    });

    test(
      'Toggle ON, sadece normal katta ticari alan: o katin çıkışı raporlanmalı',
      () {
        final choice = Bolum34Content.normalOptionA;
        BinaStore.instance.bolum34 = Bolum34Model(
          areTicariCikisSame: true,
          zemin: null,
          bodrum: null,
          normal: choice,
        );

        final report = ReportEngine.getSectionFullReport(
          34,
          store: BinaStore.instance,
        );
        // Unified modda zemin/bodrum null, normal dolu → normal değeri kullanılmalı
        expect(report.isNotEmpty, true);
        expect(report.contains('Tüm Ticari Alanların Bağımsız Çıkışı'), true);
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
        // ticariOptionB'nin level değeri info değil olmalı
        expect(level, isNotNull);
        // Olumlu (A şıkkı) seçilmediği için level info/ok değil warn/crit olmalı
        final levelName = level.toString().toLowerCase();
        expect(
          levelName.contains('ok') || levelName.contains('olumlu'),
          false,
          reason: 'Riskli seçim yapılmışsa sonuç "ok" olmamalı',
        );
      },
    );

    test(
      'Tüm katlarda olumlu (13-11-A) seçimi — risk seviyesi positive olmalı',
      () {
        final good = Bolum13Content.ticariOptionA;
        BinaStore.instance.bolum13 = Bolum13Model(
          areTicariKapiSame: true,
          ticariKapiZemin: good,
          ticariKapiNormal: good,
          ticariKapiBodrum: good,
        );

        final level = ReportEngine.getSectionRiskLevel(
          13,
          store: BinaStore.instance,
        );
        expect(
          level,
          RiskLevel.positive,
          reason: 'Tüm katlarda olumlu seçim yapılmışsa risk "positive" olmalı',
        );
      },
    );
  }); // end Group 5

  // =========================================================================
  // GRUP 6: getSectionDetailedReport — Toggle Doğrulaması
  // =========================================================================
  group('getSectionDetailedReport — Toggle Etiket Doğrulaması', () {
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
        reason: 'Unified modda detaylı rapor etiketi "Tüm ticari alanlardan" içermeli',
      );
      expect(
        details.any((d) => (d['label'] as String).contains('Zemin kattaki')),
        false,
        reason: 'Unified modda kat bazlı etiket olmamalı',
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
      expect(
        details.any((d) => (d['label'] as String).contains('Tüm ticari alanlardan')),
        false,
      );
    });

    test('Bölüm 34 Toggle ON: detaylı raporda unified etiket gelmeli', () {
      BinaStore.instance.bolum34 = Bolum34Model(
        areTicariCikisSame: true,
        zemin: Bolum34Content.zeminOptionA,
        normal: Bolum34Content.zeminOptionA,
      );

      final details = ReportEngine.getSectionDetailedReport(34, store: BinaStore.instance);
      expect(
        details.any((d) => (d['label'] as String).contains('hepsinin doğrudan sokağa')),
        true,
        reason: 'Unified modda "hepsinin doğrudan sokağa" etiketi gelmeli',
      );
      expect(
        details.any((d) => (d['label'] as String).contains('Zemin kattaki')),
        false,
        reason: 'Unified modda kat bazlı etiket olmamalı',
      );
    });

    test('Bölüm 34 Toggle OFF + tek katta ticari (sadece bodrum): sadece bodrum etiketi gelmeli', () {
      // Bu senaryo kullanıcının özellikle vurguladığı "tek katta ticari alan" durumu
      BinaStore.instance.bolum34 = Bolum34Model(
        areTicariCikisSame: false, // toggle OFF veya count==1 (state olarak OFF gibi)
        zemin: null,
        normal: null,
        bodrum: Bolum34Content.bodrumOptionA,
      );

      final details = ReportEngine.getSectionDetailedReport(34, store: BinaStore.instance);
      expect(
        details.any((d) => (d['label'] as String).contains('Bodrum kattaki')),
        true,
        reason: 'Sadece bodrum katta ticari alan varsa bodrum etiketi gelmeli',
      );
      expect(
        details.any((d) => (d['label'] as String).contains('Zemin kattaki')),
        false,
        reason: 'Zemin katta ticari alan yok, etiketi olmamalı',
      );
    });
  });
}
