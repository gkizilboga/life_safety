
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_safety/logic/bina_store.dart';
import 'package:life_safety/models/bolum_models.dart';
import 'package:life_safety/models/choice_result.dart';
import 'package:life_safety/services/pdf_service.dart';

void main() {
  test('PDF Heavy Load Test: Extremely long evaluation notes should not crash PDF generation', () async {
    final store = BinaStore.instance;
    store.clear();

    // 1. Çok uzun bir metin oluştur (Yaklaşık 5000 karakter)
    String veryLongNote = "KRİTİK RİSK: " + List.generate(500, (i) => "Bu bir test cümlesidir ve PDF sayfa yapısını zorlamak için eklenmiştir ($i).").join(" ");

    // 2. Bölüm 21'e bu devasa notu ekle
    store.bolum21 = Bolum21Model(
      varlik: ChoiceResult(
        label: "21-1-B", // Hayır (YGH yok)
        uiTitle: "YGH Yok",
        uiSubtitle: "Riskli durum",
        reportText: veryLongNote, // Devasa metni buraya koyuyoruz
        adviceText: "Acilen YGH yapılmalıdır.",
      ),
    );

    // 3. Bina bilgilerini doldur (PDF için zorunlu alanlar)
    store.bolum1 = Bolum1Model(ruhsatTarihi: ChoiceResult(label: "1-1-A", uiTitle: "2007 Öncesi", reportText: ""));
    store.bolum3 = Bolum3Model(hYapi: 35.0, bodrumKatSayisi: 1);

    // 4. PDF Üretimini başlat
    print("--- DEĞERLENDİRME: Çok uzun metinli PDF üretimi başlatılıyor... ---");
    
    try {
      final Uint8List pdfBytes = await PdfService.generatePdf(store);
      
      expect(pdfBytes, isNotEmpty);
      print("--- BAŞARILI: PDF başarıyla üretildi (${pdfBytes.length} byte). ---");
      print("Not: Metin çok uzun olmasına rağmen PDF motoru çökmedi.");
    } catch (e) {
      print("--- HATA: PDF üretimi sırasında çökme yaşandı! ---");
      print("Hata detayı: $e");
      rethrow;
    }
  });
}
