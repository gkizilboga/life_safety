import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/report_engine.dart';
import 'package:life_safety/logic/active_systems_engine.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_5_model.dart';
import 'package:life_safety/models/bolum_6_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_35_model.dart';
import 'package:life_safety/models/choice_result.dart';

void main() {
  test('Simulation: Architect Audit of 55m Mixed-Use Building', () async {
    final store = BinaStore.instance;
    store.clearCurrentAnalysis();

    print('\n--- [SİMÜLASYON BAŞLATILDI: MİMAR GÖZÜYLE ANALİZ] ---\n');

    // 1. Temel Bilgiler (Bölüm 3 & 5)
    store.bolum3 = Bolum3Model(
      hYapi: 55.0, // Kritik eşik (51.50) geçildi
      hBina: 55.0,
      normalKatSayisi: 19,
      bodrumKatSayisi: 3,
    );
    store.bolum5 = Bolum5Model(tabanAlani: 800, toplamInsaatAlani: 16000);

    // 2. Kullanım ve Otopark (Bölüm 6)
    store.bolum6 = Bolum6Model(
      hasOtopark: true,
      hasTicari: true,
      hasDepo: false,
      isSadeceKonut: false,
      kapaliOtoparkAlani: 1200.0,
    );

    // 3. Basınçlandırma Parametresi (Bölüm 21)
    store.bolum21 = Bolum21Model(
      varlik: ChoiceResult(
        label: "21-1-B", // Doğal havalandırma yok
        uiTitle: "Hayır, yok",
        uiSubtitle: "",
        reportText: "Merdivenlerde doğal havalandırma bulunmamaktadır.",
      ),
    );

    // 4. Çıkış Kapasitesi (Bölüm 33) - KRİTİK HATA SİMÜLASYONU
    store.bolum33 = Bolum33Model(
      mevcutUst: 1, // 55 metre binada sadece 1 çıkış! (Çok riskli)
      yukNormal: 150,
      yukZemin: 30,
      yukBodrum: 20,
    );

    // 5. Kaçış Mesafeleri (Bölüm 35) - BİLMİYORUM SİMÜLASYONU
    store.bolum35 = Bolum35Model(
      tekYon: ChoiceResult(
        label: "35-1-D (Bilmiyorum)",
        uiTitle: "Bilmiyorum",
        uiSubtitle: "",
        reportText: "Mimar mesafeden emin değil.",
      ),
    );

    // ANALİZ SONUÇLARI
    print('BİNA PROFİLİ: 55m Yükseklik, Karma Kullanım, 22 Kat Toplam.');

    // Risk Analizi
    final metrics = ReportEngine.calculateRiskMetrics();
    print('\n[GENEL RİSK DURUMU]');
    print('Güvenlik Skoru: %${metrics['score']}');
    print('Kritik Risk Sayısı: ${metrics['criticalCount']}');
    print('Kritik Alanlar: ${metrics['criticals']}');

    // Aktif Sistem Analizi
    final activeReqs = ActiveSystemsEngine.calculateRequirements(store);

    print('\n[AKTİF SİSTEM GEREKSİNİMLERİ]');
    for (var req in activeReqs) {
      String status = req.isMandatory
          ? '[ZORUNLU]'
          : (req.isWarning ? '[UYARI]' : '[İSTEĞE BAĞLI]');
      print('$status ${req.name}');
      if (req.isMandatory || req.isWarning) {
        print('   - Sebep: ${req.reason}');
        if (req.note.isNotEmpty) print('   - Not: ${req.note}');
      }
    }

    print('\n--- [SİMÜLASYON TAMAMLANDI] ---\n');
  });
}
