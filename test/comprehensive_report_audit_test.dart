import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_1_model.dart';
import 'package:life_safety/models/bolum_2_model.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/models/bolum_7_model.dart';
import 'package:life_safety/models/bolum_8_model.dart';
import 'package:life_safety/models/bolum_9_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/models/bolum_11_model.dart';
import 'package:life_safety/models/bolum_12_model.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_14_model.dart';
import 'package:life_safety/models/bolum_15_model.dart';
import 'package:life_safety/models/bolum_16_model.dart';
import 'package:life_safety/models/bolum_17_model.dart';
import 'package:life_safety/models/bolum_18_model.dart';
import 'package:life_safety/models/bolum_19_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/models/bolum_22_model.dart';
import 'package:life_safety/models/bolum_23_model.dart';
import 'package:life_safety/models/bolum_24_model.dart';
import 'package:life_safety/models/bolum_25_model.dart';
import 'package:life_safety/models/bolum_26_model.dart';
import 'package:life_safety/models/bolum_27_model.dart';
import 'package:life_safety/models/bolum_28_model.dart';
import 'package:life_safety/models/bolum_29_model.dart';
import 'package:life_safety/models/bolum_30_model.dart';
import 'package:life_safety/models/bolum_31_model.dart';
import 'package:life_safety/models/bolum_32_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_34_model.dart';
import 'package:life_safety/models/bolum_35_model.dart';
import 'package:life_safety/models/bolum_36_model.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  final store = BinaStore.instance;

  test('Comprehensive Report Audit: Verify All 36 Sections', () {
    store.reset();
    store.createNewBuilding(
      name: "Audit Building",
      city: "İstanbul",
      district: "Kadıköy",
    );

    // Mock ChoiceResult
    ChoiceResult mockRes(String label, String title) => ChoiceResult(
      label: label,
      uiTitle: title,
      uiSubtitle: "",
      reportText: "Metin",
    );

    // FILL ALL SECTIONS
    store.bolum1 = Bolum1Model(secim: mockRes("1-1-A", "2007 sonrası"));
    store.bolum2 = Bolum2Model(secim: mockRes("2-1-A", "Betonarme"));
    store.bolum3 = Bolum3Model(
      hYapi: 30.5,
      hBina: 30.5,
      normalKatSayisi: 10,
      bodrumKatSayisi: 2,
    );
    store.bolum4 = Bolum4Model(binaYukseklikSinifi: mockRes("4", "BYK-4"));
    store.bolum5 = Bolum5Model(toplamInsaatAlani: 5000, tabanAlani: 500);
    store.bolum6 = Bolum6Model(
      isSadeceKonut: false,
      hasTicari: true,
      hasOtopark: true,
    );
    store.bolum7 = Bolum7Model(
      hasKazan: true,
      hasAsansor: true,
      hasSiginak: true,
    );
    store.bolum8 = Bolum8Model(secim: mockRes("8-1-A", "Ayrık"));
    store.bolum9 = Bolum9Model(secim: mockRes("9-1-A", "Yanmaz"));
    store.bolum10 = Bolum10Model(
      zemin: mockRes("10-A", "Konut"),
      normaller: [],
      bodrumlar: [],
    );
    store.bolum11 = Bolum11Model(mesafe: mockRes("11-A", "5m+"));
    store.bolum12 = Bolum12Model(betonPaspayi: mockRes("12-A", "Betonarme"));
    store.bolum13 = Bolum13Model(
      otoparkKapi: mockRes("13-1-A", "Yangına Dayanıklı"),
    );
    store.bolum14 = Bolum14Model(raporMesaji: "Test");
    store.bolum15 = Bolum15Model(kaplama: mockRes("15-1-A", "Yanmaz"));
    store.bolum16 = Bolum16Model(mantolama: mockRes("16-1-A", "Yanmaz"));
    store.bolum17 = Bolum17Model(kaplama: mockRes("17-1-A", "Yanmaz"));
    store.bolum18 = Bolum18Model(duvarKaplama: mockRes("18-1-A", "Yanmaz"));
    store.bolum19 = Bolum19Model(
      levha: mockRes("19-1-A", "Mevcut"),
      engeller: [],
    );
    store.bolum20 = Bolum20Model(
      normalMerdivenSayisi: 1,
      binaIciYanginMerdiveniSayisi: 1,
    );
    store.bolum21 = Bolum21Model(
      varlik: mockRes("21-1-A", "Evet"),
      malzeme: mockRes("21-2-A", "Yanmaz"),
      kapi: mockRes("21-3-A", "Uygun"),
      esya: mockRes("21-4-A", "Yok"),
    );
    store.bolum22 = Bolum22Model(varlik: mockRes("22-A", "Var"));
    store.bolum23 = Bolum23Model(bodrum: mockRes("23-A", "Var"));
    store.bolum24 = Bolum24Model(tip: mockRes("24-A", "Basınçlandırma"));
    store.bolum25 = Bolum25Model(genislik: mockRes("25-A", "120cm"));
    store.bolum26 = Bolum26Model(varlik: mockRes("26-A", "Yok"));
    store.bolum27 = Bolum27Model(
      yon: [mockRes("27-A", "Dışa Açılır")],
      kilit: [mockRes("27-B", "Panik Bar")],
    );
    store.bolum28 = Bolum28Model(mesafe: mockRes("28-A", "15m"));
    store.bolum29 = Bolum29Model(otopark: mockRes("29-A", "Yok"));
    store.bolum30 = Bolum30Model(konum: mockRes("30-A", "Uygun"));
    store.bolum31 = Bolum31Model(yapi: mockRes("31-A", "Uygun"));
    store.bolum32 = Bolum32Model(yapi: mockRes("32-A", "Uygun"));
    store.bolum33 = Bolum33Model(yukZemin: 50, yukNormal: 40);
    store.bolum34 = Bolum34Model(zemin: mockRes("34-A", "Bağımsız"));
    store.bolum35 = Bolum35Model(tekYon: mockRes("35-A", "15m"));
    store.bolum36 = Bolum36Model(
      cikisKati: mockRes("36-1-A", "Zemin"),
      merdivenDegerlendirme: "Detaylı Analiz Metni",
    );

    print('\n--- [DETAYLI RAPOR DENETİMİ BAŞLADI] ---\n');

    for (int i = 1; i <= 36; i++) {
      final details = ReportEngine.getSectionDetailedReport(i, store: store);
      if (details.isEmpty) {
        print('⚠️ Bölüm $i: Veri bulunamadı (Skip)');
        continue;
      }

      print('\nSECTION $i:');
      for (var d in details) {
        final label = d['label'] as String;
        final value = d['value'] as String;
        print('  - [$label]: $value');

        // GENEL DEĞERLENDİRME CHECK
        expect(
          label,
          isNot(equals('Genel Değerlendirme')),
          reason: 'Section $i label should not be generic.',
        );
      }
    }

    print('\n--- [DENETİM TAMAMLANDI] ---\n');
  });
}
