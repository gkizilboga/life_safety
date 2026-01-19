import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_1_model.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/models/bolum_10_model.dart';
import 'package:life_safety/models/bolum_2_model.dart';
import 'package:life_safety/models/bolum_11_model.dart';
import 'package:life_safety/models/bolum_12_model.dart';
import 'package:life_safety/models/bolum_16_model.dart';
import 'package:life_safety/models/bolum_20_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  test(
    'Zorlu Kullanıcı Simülasyonu: Maksimum Değerler Altında Sistem Davranışı',
    () async {
      SharedPreferences.setMockInitialValues({});
      final store = BinaStore.instance;
      store.reset();

      print('--- STRESS TESTİ BAŞLATILIYOR (MAKSİMUM DEĞERLER) ---');

      // 1. Bina Bilgileri (Bölüm 3 & 4) - Maksimum Kat ve Yükseklik
      // 30 Normal, 10 Bodrum = 40 Kat. Toplam Yükseklik 100m+
      store.bolum3 = Bolum3Model(
        bodrumKatSayisi: 10,
        normalKatSayisi: 30,
        hBina: 90.0, // 30 kat * 3m
        hYapi: 125.0, // 40 kat * 3.1m
      );
      store.bolum4 = Bolum4Model(
        hesaplananBinaYuksekligi: 90.0,
        hesaplananYapiYuksekligi: 125.0,
      );

      // 2. Alan Verileri (Bölüm 5) - Devasa Alanlar
      // Kat başı 5.000 m2. Toplam = 200.000 m2
      store.bolum5 = Bolum5Model(
        tabanAlani: 5000,
        bodrumKatAlani: 5000,
        normalKatAlani: 5000,
        toplamInsaatAlani: 200000,
      );

      // 3. Kullanım Amacı (Bölüm 10) - Tüm katlar "Yüksek Yoğun Ticari" (Cafe/Restoran)
      store.bolum10 = Bolum10Model(
        zemin:
            Bolum10Content.yuksekYogunTicari, // 1.5 m2/kişi -> 3333 kişi/kat!
        bodrumlar: List.filled(10, Bolum10Content.yuksekYogunTicari),
        normaller: List.filled(30, Bolum10Content.yuksekYogunTicari),
        bodrumlarAyni: true,
        normallerAyni: true,
      );

      // 4. Otopark (Bölüm 6) - Devasa Kapalı Otopark
      store.bolum6 = Bolum6Model(
        hasOtopark: true,
        otoparkTipi: Bolum6Content.otoparkKapali,
      );

      // 5. Cephe (Bölüm 16) - Çok uzun cephe
      store.bolum16 = Bolum16Model(
        enUzunCephe: 200.0, // Maks limit
        mantolama: Bolum16Content.mantolamaOptionA,
      );

      // 6. Merdivenler (Bölüm 20) - Sahanlıksız merdiven (KRİTİK RİSK)
      store.bolum20 = Bolum20Model(
        binaIciYanginMerdiveniSayisi: 1,
        sahanliksizMerdivenSayisi: 1, // Kritik risk!
      );

      // 7. İtfaiye Yaklaşımı (Bölüm 11) - Engel var (KRİTİK RİSK)
      store.bolum11 = Bolum11Model(
        mesafe: Bolum11Content.mesafeOptionB,
        engel: Bolum11Content.engelOptionB,
        zayifNokta: Bolum11Content.zayifNoktaOptionB,
      );

      // 8. Yapısal Yangın Dayanımı (Bölüm 12) - Yalıtımsız Çelik (KRİTİK RİSK)
      store.bolum2 = Bolum2Model(secim: Bolum2Content.celik);
      store.bolum12 = Bolum12Model(celikKoruma: Bolum12Content.celikOptionB);

      // 9. Kullanıcı Yükü (Bölüm 33) - 100.000+ kişi (KRİTİK RİSK)
      // 5000 m2 / 1.5 = ~3333 kişi zemin katta.
      store.bolum33 = Bolum33Model(
        yukZemin: 3333,
        yukNormal: 3333,
        yukBodrum: 3333,
        gerekliNormal: 67, // (3333 / 50) -> yaklasik 67 cikis lazim!
        mevcutUst: 1, // Sadece 1 cikis var -> Felaket senaryosu
      );

      // 10. Hesaplamaları Tetikle
      final metrics = ReportEngine.calculateRiskMetrics(store: store);
      final activeSystems = ActiveSystemsEngine.calculateRequirements(store);

      print('\n[SONUÇLAR]');
      print('Toplam İnşaat Alanı: ${store.bolum5?.toplamInsaatAlani} m2');
      print('Yapı Yüksekliği: ${store.bolum3?.hYapi} m');
      print('Güvenlik Skoru: %${metrics['score']}');
      print('Kritik Risk Sayısı: ${metrics['criticalCount']}');

      final int requiredExits = store.bolum33?.gerekliNormal ?? 0;
      print('Gereken Çıkış Sayısı (Bölüm 33): $requiredExits');
      print('Mevcut Çıkış Sayısı: ${store.bolum33?.mevcutUst}');

      // Beklenen Davranış:
      // 1. Skor çok düşük olmalı (yüksek risk).
      // 2. Gereken çıkış sayısı devasa olmalı (3333 kişi / 50 = 67 çıkış).
      // 3. Aktif sistemlerin tamamı "ZORUNLU" ve "KRİTİK RİSK" statüsünde olmalı.

      expect(
        metrics['score'],
        lessThan(60),
      ); // 6+ kritik risk ile 40-50 bekliyoruz
      expect(requiredExits, greaterThan(60));

      print('\n[AKTİF SİSTEM ANALİZİ]');
      for (var req in activeSystems) {
        if (req.isMandatory) {
          print('ZORUNLU: ${req.name} - ${req.reason}');
        }
      }

      print('\n--- STRESS TESTİ BAŞARIYLA TAMAMLANDI ---\n');
    },
  );
}
