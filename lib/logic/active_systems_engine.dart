import '../data/bina_store.dart';
import '../models/active_system_requirement.dart';
import '../models/bolum_6_model.dart';
import '../models/bolum_35_model.dart';

class ActiveSystemsEngine {

  static List<ActiveSystemRequirement> calculateRequirements(
    BinaStore store,
  ) {
    List<ActiveSystemRequirement> requirements = [];

    // Facade width artık Bölüm 16 modelinden okunuyor.
    final facadeWidth = store.bolum16?.enUzunCephe;

    final hYapi = store.bolum3?.hYapi ?? 0;
    final hBina = store.bolum3?.hBina ?? 0;
    final tabanAlani = store.bolum5?.tabanAlani ?? 0;
    final toplamInsaat = store.bolum5?.toplamInsaatAlani ?? 0;

    final yukToplam =
        (store.bolum33?.yukZemin ?? 0) +
        (store.bolum33?.yukNormal ?? 0) +
        (store.bolum33?.yukBodrum ?? 0);

    final cikisSayisi = store.bolum33?.mevcutUst ?? 0;

    // 1. Yangın Senaryosu ve Matris
    requirements.add(
      ActiveSystemRequirement(
        name: "Yangın Senaryosu",
        isMandatory: true,
        reason:
            "Her binada, yangın anında sistemlerin nasıl çalışacağını, tahliyenin nasıl yapılacağını ve ekiplerin nasıl müdahale edeceğini anlatan bir Yangın Senaryosu oluşturulmalıdır.",
      ),
    );

    requirements.add(
      ActiveSystemRequirement(
        name: "Yangın Matrisi (Cause and Effect)",
        isMandatory: true,
        reason:
            "Sistemlerin birbiriyle entegrasyonunu (Örn: Alarm çalınca asansörün inmesi, fanların açılması vb.) gösteren Cause and Effect (Sebep-Sonuç) matrisi hazırlanmalıdır.",
      ),
    );

    // 2. Yangın Algılama Sistemi
    // Kural: hYapi >= 51.50m ise ZORUNLU.
    if (hYapi >= 51.50) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Algılama ve Uyarı Sistemi",
          isMandatory: true,
          reason: "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Algılama ve Uyarı Sistemi",
          isMandatory: false,
          reason:
              "✅ OLUMLU: Yapı Yüksekliği < 51.50m (ve diğer ek şartlar oluşmadığı varsayılarak) zorunlu değildir.",
        ),
      );
    }

    // 2. Acil Aydınlatma Sistemi
    // Kural: hYapi >= 21.50m VEYA Tüm katlardaki yükün toplamı > 200 ise ZORUNLU.
    if (hYapi >= 21.50 || yukToplam > 200) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Aydınlatma Sistemi",
          isMandatory: true,
          reason: hYapi >= 21.50
              ? "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "🚨 KRİTİK RİSK: Binadaki toplam kullanıcı yükü 200 kişiyi aştığı için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Aydınlatma Sistemi",
          isMandatory: false,
          reason: "✅ OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
        ),
      );
    }

    // 3. Acil Durum Yönlendirmeleri
    // Kural: Çıkış Sayısı > 1 ise ZORUNLU.
    if (cikisSayisi > 1) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Durum Yönlendirmeleri",
          isMandatory: true,
          reason: "🚨 KRİTİK RİSK: Birden fazla çıkış (kaçış yolu) bulunduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Durum Yönlendirmeleri",
          isMandatory: false,
          reason:
              "✅ OLUMLU: Tek çıkışlı binalarda zorunlu tutulmamıştır (ancak önerilmektedir).",
        ),
      );
    }

    // 4. Anons Sistemi
    // Kural: hYapi >= 51.50m ise ZORUNLU.
    if (hYapi >= 51.50) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli Tahliye (Anons) Sistemi",
          isMandatory: true,
          reason: "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli Tahliye (Anons) Sistemi",
          isMandatory: false,
          reason: "✅ OLUMLU: Yapı Yüksekliği < 51.50m olduğu için zorunlu değildir.",
        ),
      );
    }

    // 5. Elle İhbar Sistemi (Manuel Buton)
    // Kural: hBina >= 21.50m VEYA hYapi >= 30.50m ise ZORUNLU.
    bool manuelButonZorunlu = false;
    if (hBina >= 21.50 || hYapi >= 30.50) {
      manuelButonZorunlu = true;
      requirements.add(
        ActiveSystemRequirement(
          name: "Elle İhbar Sistemi (Kır-Bas Yangın Butonu)",
          isMandatory: true,
          reason: hBina >= 21.50
              ? "🚨 KRİTİK RİSK: Bina Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 30.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Elle İhbar Sistemi (Kır-Bas Yangın Butonu)",
          isMandatory: false,
          reason: "✅ OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
        ),
      );
    }

    // 6. Sesli-Işıklı Alarm Cihazları (Siren/Flaşör)
    // Kural: Manuel buton zorunluysa bu da ZORUNLU.
    if (manuelButonZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli ve Işıklı Alarm Cihazları",
          isMandatory: true,
          reason:
              "🚨 KRİTİK RİSK: Elle ihbar sistemi (Buton) zorunlu olduğu için alarm cihazları da zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli ve Işıklı Alarm Cihazları",
          isMandatory: false,
          reason: "✅ OLUMLU: Elle ihbar sistemi zorunlu olmadığı için şart değildir.",
        ),
      );
    }

    // 7. Yangın Dolabı Sistemi
    // Kural: hYapi >= 21.50m ise ZORUNLU.
    if (hYapi >= 21.50) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Dolabı Sistemi",
          isMandatory: true,
          reason: "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 21.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Dolabı Sistemi",
          isMandatory: false,
          reason: "✅ OLUMLU: Yapı Yüksekliği < 21.50m olduğu için zorunlu değildir.",
        ),
      );
    }

    // 8. İtfaiye Su Alma Ağzı
    if (hBina >= 21.50 || (hYapi >= 30.50 && tabanAlani > 1000)) {
      requirements.add(
        ActiveSystemRequirement(
          name: "İtfaiye Su Alma Ağzı",
          isMandatory: true,
          reason: hBina >= 21.50
              ? "🚨 KRİTİK RİSK: Bina Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 30.50m ve Taban Alanı > 1000 m² olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "İtfaiye Su Alma Ağzı",
          isMandatory: false,
          reason: "✅ OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
        ),
      );
    }

    // 9. İtfaiye Su Verme Bağlantısı (Siyam İkizi)
    bool siyamZorunlu = false;
    String siyamReason = "";

    if (hBina >= 21.50) {
      siyamZorunlu = true;
      siyamReason = "🚨 KRİTİK RİSK: Bina Yüksekliği ≥ 21.50m olduğu için zorunludur.";
    } else if (hYapi >= 30.50) {
      siyamZorunlu = true;
      siyamReason = "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 30.50m olduğu için zorunludur.";
    } else if (tabanAlani > 1000) {
      siyamZorunlu = true;
      siyamReason = "🚨 KRİTİK RİSK: Taban Alanı > 1000 m² olduğu için zorunludur.";
    } else if ((facadeWidth ?? 0) > 75) {
      siyamZorunlu = true;
      siyamReason = "🚨 KRİTİK RİSK: Cephe Genişliği > 75m olduğu için zorunludur.";
    }

    requirements.add(
      ActiveSystemRequirement(
        name: "İtfaiye Su Verme Ağzı (Siyam İkizi)",
        isMandatory: siyamZorunlu,
        reason: siyamZorunlu
            ? siyamReason
            : "✅ OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
      ),
    );

    // 10. Sprinkler Sistemi
    // Kural: 3 alternatiften biri varsa ZORUNLU.
    bool sprinklerZorunlu = false;
    List<String> sprinklerReasons = [];
    bool sprinklerBilmiyorum = false; // "Bilmiyorum" durumu

    if (hYapi >= 51.50) {
      sprinklerZorunlu = true;
      sprinklerReasons.add("Yapı Yüksekliği ≥ 51.50m");
    }

    if (store.bolum6?.hasOtopark == true && (store.bolum6?.kapaliOtoparkAlani ?? 0) > 600) {
      sprinklerZorunlu = true;
      sprinklerReasons.add("Kapalı Otopark Alanı > 600 m²");
    }

    final b35 = store.bolum35;
    bool mesafeLimitUstu = false;

    // "Bilmiyorum" Kontrolü (Bölüm 35)
    // Label kodları: 35-1-D (Bilmiyorum)
    bool b35Bilmiyorum = false;
    final tY = b35?.tekYon?.label ?? "";
    final cY = b35?.ciftYon?.label ?? "";
    final cM = b35?.cikmazMesafe?.label ?? "";

    if (tY.contains("35-1-D") ||
        cY.contains("35-2-D") ||
        cM.contains("35-3-F") || // Varsayılan "Bilmiyorum" kodu
        tY.toLowerCase().contains("bilmiyorum") ||
        cY.toLowerCase().contains("bilmiyorum") ||
        cM.toLowerCase().contains("bilmiyorum")) {
      b35Bilmiyorum = true;
    }

    if (!b35Bilmiyorum) {
      // 35-1-C: Tek Yön Uzun
      if (tY.contains("35-1-C")) mesafeLimitUstu = true;
      // 35-2-C: En Yakın Çıkış (Çift Yön) Uzun
      if (cY.contains("35-2-C")) mesafeLimitUstu = true;
      // 35-3-E: Çıkmaz Koridor Uzun
      if (cM.contains("35-3-E")) mesafeLimitUstu = true;
    }

    if (mesafeLimitUstu) {
      sprinklerZorunlu = true;
      sprinklerReasons.add("En az bir adet kaçış mesafesinin Yönetmelik limitinin üzerinde olduğu beyan edilmiştir.");
    } else if (b35Bilmiyorum && !sprinklerZorunlu) {
      // Eğer diğer sebeplerden ötürü zaten zorunlu değilse VE mesafe durumu bilinmiyorsa:
      sprinklerBilmiyorum = true;
    }

    if (sprinklerBilmiyorum) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Yağmurlama (Sprinkler) Sistemi",
          isMandatory: false,
          isWarning: true, // Warning
          reason:
              "❓ BİLİNMİYOR: Kaçış mesafeleri ile ilgili bilgiler 'Bilmiyorum' olarak işaretlendiği için değerlendirme yapılamamıştır.",
          note:
              "Bu konuda bir Yangın Güvenlik Uzmanı tarafından yerinde ölçüm ve değerlendirme yapılması elzemdir.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Yağmurlama (Sprinkler) Sistemi",
          isMandatory: sprinklerZorunlu,
          reason: sprinklerZorunlu
              ? "🚨 KRİTİK RİSK: Zorunluluk Sebebi: ${sprinklerReasons.join(', ')}."
              : "✅ OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
        ),
      );
    }

    // 11. Hidrant Sistemi
    // Kural: tabanAlani > 5000m² ise ZORUNLU.
    if (tabanAlani > 5000) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Hidrant Sistemi(Bina Çevresinde)",
          isMandatory: true,
          reason: "🚨 KRİTİK RİSK: Taban Alanı > 5000 m² olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Hidrant Sistemi(Bina Çevresinde)",
          isMandatory: false,
          reason: "✅ OLUMLU: Taban Alanı < 5000 m² olduğu için zorunludur değildir.",
        ),
      );
    }

    // 12. Duman Kontrol Sistemi
    // Kural: hYapi >= 51.50m ise ZORUNLU.
    if (hYapi >= 51.50) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Duman Kontrol Sistemi",
          isMandatory: true,
          reason: "🚨 KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Duman Kontrol Sistemi",
          isMandatory: false,
          reason:
              "✅ OLUMLU: Yapı Yüksekliği < 51.50m olduğu için genel duman kontrol sistemi zorunlu değildir (özel mahaller ve özel durumlar hariç).",
        ),
      );
    }

    // 12.1 Atrium (Duman Kontrol Bağlantılı)
    requirements.add(
      ActiveSystemRequirement(
        name: "Atrium Duman Kontrolü",
        isMandatory: false,
        isWarning: true,
        reason:
            "⚠️ UYARI: Alanı 90 m²'den küçük olan atrium boşluklarının çevresi her katta en az 45 cm yüksekliğinde duman perdesi ile çevrelenir ve yağmurlama sistemi ile korunan binalarda duman perdesinden 15 ila 30 cm uzaklıkta, aralarındaki mesafe en çok 2 m olacak şekilde yağmurlama başlığı yerleştirilir. Atriumlarda doğal veya mekanik olarak duman kontrolü yapılır.",
        definitionTerm: "Atrium",
        definitionText:
            "İki veya daha çok sayıda katın içine açıldığı, merdiven yuvası, asansör kuyusu, yürüyenmerdiven boşluğu veya su, elektrik, havalandırma, iklimlendirme, haberleşme, tesisat bacaları ve şaftlar hariç, üstü kapalı geniş ve yüksek hacmi ifade eder.",
      ),
    );

    // 13. Basınçlandırma Sistemi
    // Karmaşık kurallar.
    List<String> basincLocations = [];

    // a. hYapi >= 30.50m ve < 51.50m ve (21-1-B: Merdiven doğ. hav. yok) -> Merdivenlerin en az birinde YALNIZCA.
    if (hYapi >= 30.50 && hYapi < 51.50) {
      if (store.bolum21?.varlik?.label == "21-1-B") {
        basincLocations.add("Merdivenlerin en az birinde");
      }
    }

    // b. hYapi >= 51.50m -> Merdivenlerin en az ikisinde.
    if (hYapi >= 51.50) {
      basincLocations.add("Merdivenlerin en az ikisinde");
    }

    // c. Tüm yapılar, 23-5-B (kuyu kapalı) -> Normal asansör kuyusu.
    if (store.bolum23?.havalandirma?.label == "23-5-B") {
      basincLocations.add("Normal (İnsan) asansör kuyusunda");
    }

    // d. İtfaiye Asansörü Varsa Basınçlandırma Zorunlu.
    // 22-6-A: Evet, var / 22-6-B: Hayır, yok.
    // Logic Fix: Sadece VARSA (A) basınçlandırma gerekir.
    if (store.bolum22?.varlik?.label.contains("22-6-A") == true) {
      basincLocations.add("İtfaiye asansöründe");
    }

    // e. Bodrum kat sayısı > 4 -> Bodrum kaçış merdivenlerinde.
    if ((store.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      basincLocations.add("Bodrum kata hizmet veren kaçış merdivenlerinde");
    }

    if (basincLocations.isNotEmpty) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basınçlandırma Sistemi",
          isMandatory: true,
          reason: "🚨 KRİTİK RİSK: Aşağıdaki alanlarda basınçlandırma yapılması ZORUNLUDUR:",
          note: "${basincLocations.join(", ")}.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basınçlandırma Sistemi",
          isMandatory: false,
          reason:
              "✅ OLUMLU: Basınçlandırma gerektiren bir durum tespit edilmemiştir.",
        ),
      );
    }

    // 14. Sismik Askılama (UPDATED)
    // Kural: Sprinkler Zorunlu ise UYARI olarak göster.
    if (sprinklerZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sismik Askılama (Depreme Karşı Tesisat Koruyucu) Sistemler",
          isMandatory: false,
          isWarning: true, // Set Warning TRUE
          reason:
              "⚠️ UYARI: Otomatik Yağmurlama (Sprinkler) sistemi zorunlu olduğu için, binanızın deprem bölgesine göre sismik önlemler alınması gerekebilir. Kesin sismik önlemler için binanızın bulunduğu bölgeye göre yorum yapılmalıdır.",
          note:
              "Birinci ve ikinci derece deprem bölgelerinde, sismik hareketlere karşı ana kolonların herhangi bir yöne sürüklenmemesi için, dört yollu destek kullanılması ve 65 mm ve daha büyük nominal çaplı boruların katlardan ana dağıtım borularına bağlanmasında esnek bağlantılar ile boruların tavanlara tutturulmasında iki yollu enlemesine ve boylamasına sabitleme askı elemanları kullanılarak boruların kırılmasının önlenmesi gerekir. Dilatasyon geçişlerinde her üç yönde hareketi karşılayacak detaylar uygulanır.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sismik Askılama Sistemleri",
          isMandatory: false,
          reason: "✅ OLUMLU: Sprinkler sistemi zorunlu olmadığı için öncelikli değildir.",
        ),
      );
    }

    // 15. Taşınabilir Söndürücü
    double neededExtinguishers = (toplamInsaat / 250).ceilToDouble();
    requirements.add(
      ActiveSystemRequirement(
        name: "Taşınabilir (Portatif) Söndürücüler (YSC)",
        isMandatory: true,
        reason: "ℹ️ BİLGİ: Her yapıda zorunludur.",
        note:
            "Toplam İnşaat Alanı ($toplamInsaat m²) hesabına göre binada en az ${neededExtinguishers.toInt()} adet 6kg Kuru Kimyevi Tozlu (KKT) Yangın Söndürme Cihazı bulunmalıdır.",
      ),
    );

    // 16. Gaz Algılayıcı
    requirements.add(
      ActiveSystemRequirement(
        name: "Gaz Algılama Sistemi",
        isMandatory: false,
        isWarning: true,
        reason:
            "⚠️ UYARI: Kazan dairesi (doğalgaz/LPG), otopark (karbonmonoksit) veya mutfak gibi alanlarda uygun gaz algılama dedektörleri kullanılmalıdır.",
      ),
    );

    // 17. Yangın Damperi
    requirements.add(
      ActiveSystemRequirement(
        name: "Yangın Damperi",
        isMandatory: false,
        isWarning: true,
        reason:
            "⚠️ UYARI: Yangın kompartımanı veya yangın zonu olarak tanımlanmış alanların döşeme ve tüm duvarlarında yer alan, havalandırma kanalı geçişi vb. korunumsuz açıklıklarda Yangın Damperi kullanılmalıdır.",
      ),
    );

    // 18. Duman Damperi
    requirements.add(
      ActiveSystemRequirement(
        name: "Duman Damperi",
        isMandatory: false,
        isWarning: true,
        reason:
            "⚠️ UYARI: Duman tahliye sistemine ait kanalların yangın kompartımanı veya yangın zonundan geçmesi halinde geçiş noktalarında duman damperi kullanılmalıdır.",
      ),
    );

    return requirements;
  }
}

