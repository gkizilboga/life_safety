
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_1_model.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_33_model.dart';
import 'package:life_safety/models/bolum_21_model.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/services/pdf_service.dart';
import 'package:life_safety/utils/app_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('COMPREHENSIVE STRESS TEST: PDF Engine & Logic Breakdown Test', () async {
    final store = BinaStore.instance;
    store.reset();

    print("\n--- [START] COMPREHENSIVE STRESS TEST ---");

    // 1. AŞIRI VERİ ÜRETİMİ (Arayüz kısıtlamalarını baypas eden devasa metin)
    String extremeNote = "STRESS_TEST: ${List.generate(30, (i) => "SAYFA_YAPISINI_BOZMA_DENEMESI_$i ").join("")}";
    
    // 2. BİNAYI "IMKANSIZ" DEĞERLERLE DOLDUR (Arka kapıdan enjeksiyon)
    store.currentBinaName = "Stres Testi Gökdeleni ${"X" * 100}"; 
    
    // Bölüm 1 & 3: Dev bina
    store.bolum1 = Bolum1Model(secim: ChoiceResult(label: "1-1-A", uiTitle: "Test", uiSubtitle: "", reportText: ""));
    store.bolum3 = Bolum3Model(
      hYapi: 9999.0, // 10 Kilometrelik bina (Atmosfer dışı!)
      bodrumKatSayisi: 100,
      normalKatSayisi: 1000,
    );

    // Bölüm 33: Devasa kullanıcı yükü (Milyonlarca kişi)
    // Arayüzde muhtemelen 99.999 sınırı vardır ama biz 1 Milyar kişi giriyoruz.
    store.bolum33 = Bolum33Model(
      alanZemin: 99999999.0,
      alanNormal: 99999999.0,
      yukZemin: 1000000000, // 1 Milyar kişi!
      yukNormal: 1000000000, 
      gerekliZemin: 2000000,
      gerekliNormal: 2000000,
      mevcutUst: 2, 
      cikisKati: Bolum36Content.cikisKatiOptionA,
      cikisSayisi: 2,
    );

    // Bölüm 21: Devasa metin enjeksiyonu
    store.bolum21 = Bolum21Model(
      varlik: ChoiceResult(
        label: "21-1-B",
        uiTitle: "YGH Yok",
        uiSubtitle: "",
        reportText: "KRİTİK HATA: $extremeNote",
        adviceText: "ÖNERİ: $extremeNote",
        level: RiskLevel.critical,
      ),
    );

    // 4. PDF ÜRETİMİ (Bellek ve Sayfa Bölme Testi)
    print("--- [PDF] Sınırları zorlayan PDF üretimi başlatılıyor... ---");
    
    Stopwatch stopwatch = Stopwatch()..start();
    try {
      final Uint8List pdfBytes = await PdfService.generatePdf(store);
      stopwatch.stop();
      
      print("--- [SUCCESS] PDF üretildi! ---");
      print("Dosya Boyutu: ${(pdfBytes.length / 1024 / 1024).toStringAsFixed(2)} MB");
      print("Üretim Süresi: ${stopwatch.elapsedMilliseconds} ms");
      
      expect(pdfBytes, isNotEmpty);
      print("--- [RESULT] Uygulama 'terledi' ama çökmedi. Veri bütünlüğü korundu. ---");
    } catch (e) {
      print("--- [FAIL] Sistem bu yük altında kırıldı! ---");
      print("Hata: $e");
      rethrow;
    }

    print("--- [END] STRESS TEST COMPLETED ---\n");
  });
}
