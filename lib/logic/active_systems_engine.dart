import '../data/bina_store.dart';
import '../models/active_system_requirement.dart';
import '../models/bolum_6_model.dart';
import '../models/bolum_35_model.dart';

class ActiveSystemsEngine {
  static bool needsFacadeInput(BinaStore store) {
    // Siyam ikizi kuralı: hBina >= 21.50 VEYA hYapi >= 30.50 VEYA tabanAlani > 1000 OR Cephe > 75
    // Eğer ilk 3 kural sağlanıyorsa zaten zorunlu, cepheyi sormaya gerek yok.
    // Eğer ilk 3 sağlanmıyorsa, cephe genişliği belirleyici olacak, o yüzden sor.

    final hBina = store.bolum3?.hBina ?? 0;
    final hYapi = store.bolum3?.hYapi ?? 0;
    final taban = store.bolum5?.tabanAlani ?? 0;

    if (hBina >= 21.50) return false;
    if (hYapi >= 30.50) return false;
    if (taban > 1000) return false;

    return true;
  }

  static bool needsParkingInput(BinaStore store) {
    // Sprinkler kuralı: Kapalı otopark alanı > 600 m2 ise zorunlu.
    // Eğer otopark varsa alanını sormamız lazım.
    return store.bolum6?.hasOtopark == true;
  }

  static List<ActiveSystemRequirement> calculateRequirements(
    BinaStore store, {
    double? facadeWidth,
    double? parkingArea,
  }) {
    List<ActiveSystemRequirement> requirements = [];

    final hYapi = store.bolum3?.hYapi ?? 0;
    final hBina = store.bolum3?.hBina ?? 0;
    final tabanAlani = store.bolum5?.tabanAlani ?? 0;
    final toplamInsaat = store.bolum5?.toplamInsaatAlani ?? 0;

    final yukToplam =
        (store.bolum33?.yukZemin ?? 0) +
        (store.bolum33?.yukNormal ?? 0) +
        (store.bolum33?.yukBodrum ?? 0);

    final cikisSayisi = store.bolum33?.mevcutUst ?? 0;

    // 1. Yangın Algılama Sistemi
    // Kural: hYapi >= 51.50m ise ZORUNLU.
    if (hYapi >= 51.50) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Algılama ve Uyarı Sistemi",
          isMandatory: true,
          reason: "Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Algılama ve Uyarı Sistemi",
          isMandatory: false,
          reason:
              "Yapı Yüksekliği < 51.50m (ve diğer ek şartlar oluşmadığı varsayılarak) zorunlu değildir.",
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
              ? "Yapı Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "Toplam kullanıcı yükü 200 kişiyi aştığı için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Aydınlatma Sistemi",
          isMandatory: false,
          reason: "Zorunluluk sınırlarının altındadır.",
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
          reason: "Birden fazla çıkış (kaçış yolu) bulunduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Durum Yönlendirmeleri",
          isMandatory: false,
          reason:
              "Tek çıkışlı binalarda zorunlu tutulmamıştır (ancak önerilir).",
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
          reason: "Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli Tahliye (Anons) Sistemi",
          isMandatory: false,
          reason: "Yapı Yüksekliği < 51.50m olduğu için zorunlu değildir.",
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
          name: "Elle İhbar Sistemi (Yangın Butonu)",
          isMandatory: true,
          reason: hBina >= 21.50
              ? "Bina Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "Yapı Yüksekliği ≥ 30.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Elle İhbar Sistemi (Yangın Butonu)",
          isMandatory: false,
          reason: "Zorunluluk sınırlarının altındadır.",
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
              "Uyarı sistemi (Buton) zorunlu olduğu için alarm cihazları da zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli ve Işıklı Alarm Cihazları",
          isMandatory: false,
          reason: "Uyarı sistemi zorunlu olmadığı için şart değildir.",
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
          reason: "Yapı Yüksekliği ≥ 21.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Dolabı Sistemi",
          isMandatory: false,
          reason: "Yapı Yüksekliği < 21.50m olduğu için zorunlu değildir.",
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
              ? "Bina Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "Yapı Yüksekliği ≥ 30.50m ve Taban Alanı > 1000 m² olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "İtfaiye Su Alma Ağzı",
          isMandatory: false,
          reason: "Zorunluluk sınırlarının altındadır.",
        ),
      );
    }

    // 9. İtfaiye Su Verme Bağlantısı (Siyam İkizi)
    bool siyamZorunlu = false;
    String siyamReason = "";

    if (hBina >= 21.50) {
      siyamZorunlu = true;
      siyamReason = "Bina Yüksekliği ≥ 21.50m olduğu için zorunludur.";
    } else if (hYapi >= 30.50) {
      siyamZorunlu = true;
      siyamReason = "Yapı Yüksekliği ≥ 30.50m olduğu için zorunludur.";
    } else if (tabanAlani > 1000) {
      siyamZorunlu = true;
      siyamReason = "Taban Alanı > 1000 m² olduğu için zorunludur.";
    } else if ((facadeWidth ?? 0) > 75) {
      siyamZorunlu = true;
      siyamReason = "Cephe Genişliği > 75m olduğu için zorunludur.";
    }

    requirements.add(
      ActiveSystemRequirement(
        name: "İtfaiye Su Verme Ağzı (Siyam İkizi)",
        isMandatory: siyamZorunlu,
        reason: siyamZorunlu
            ? siyamReason
            : "Bina ebatları (yükseklik, alan, cephe) zorunluluk sınırının altındadır.",
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

    if (store.bolum6?.hasOtopark == true && (parkingArea ?? 0) > 600) {
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
      sprinklerReasons.add("Kaçış mesafeleri limitlerin üzerinde (Bölüm 35)");
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
              "Kaçış mesafeleri ile ilgili bilgiler 'Bilmiyorum' olarak işaretlendiği için değerlendirme yapılamamıştır.",
          note:
              "Bu konuda bir Yangın Güvenlik Uzmanı tarafından yerinde ölçüm ve değerlendirme yapılması gerekmektedir.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Yağmurlama (Sprinkler) Sistemi",
          isMandatory: sprinklerZorunlu,
          reason: sprinklerZorunlu
              ? "Zorunluluk Sebebi: ${sprinklerReasons.join(', ')}."
              : "Zorunluluk kriterleri oluşmamıştır.",
        ),
      );
    }

    // 11. Hidrant Sistemi
    // Kural: tabanAlani > 5000m² ise ZORUNLU.
    if (tabanAlani > 5000) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Çevre Yangın Hidrant Sistemi",
          isMandatory: true,
          reason: "Taban Alanı > 5000 m² olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Çevre Yangın Hidrant Sistemi",
          isMandatory: false,
          reason: "Taban Alanı < 5000 m² olduğu için zorunludur değildir.",
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
          reason: "Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Duman Kontrol Sistemi",
          isMandatory: false,
          reason:
              "Yapı Yüksekliği < 51.50m olduğu için genel duman kontrol sistemi zorunlu değildir (özel mahaller hariç).",
        ),
      );
    }

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
          reason: "Aşağıdaki alanlarda basınçlandırma yapılması ZORUNLUDUR:",
          note: "${basincLocations.join(", ")}.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basınçlandırma Sistemi",
          isMandatory: false,
          reason:
              "Basınçlandırma gerektiren kritik bir durum tespit edilmemiştir.",
        ),
      );
    }

    // 14. Sismik Askılama (UPDATED)
    // Kural: Sprinkler Zorunlu ise UYARI olarak göster.
    if (sprinklerZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sismik Askılama (Sarsıntı Önleyici) Sistemler",
          isMandatory: false,
          isWarning: true, // Set Warning TRUE
          reason:
              "Otomatik Yağmurlama (Sprinkler) sistemi zorunlu olduğu için, binanızın deprem bölgesine göre sismik önlemler alınması gerekebilir.",
          note:
              "Birinci ve ikinci derece deprem bölgelerinde, sismik hareketlere karşı ana kolonların herhangi bir yöne sürüklenmemesi için, dört yollu destek kullanılması ve 65 mm ve daha büyük nominal çaplı boruların katlardan ana dağıtım borularına bağlanmasında esnek bağlantılar ile boruların tavanlara tutturulmasında iki yollu enlemesine ve boylamasına sabitleme askı elemanları kullanılarak boruların kırılmasının önlenmesi gerekir. Dilatasyon geçişlerinde her üç yönde hareketi karşılayacak detaylar uygulanır.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sismik Askılama Sistemleri",
          isMandatory: false,
          reason: "Sprinkler sistemi zorunlu olmadığı için öncelikli değildir.",
        ),
      );
    }

    // 15. Taşınabilir Söndürücü
    double neededExtinguishers = (toplamInsaat / 250).ceilToDouble();
    requirements.add(
      ActiveSystemRequirement(
        name: "Taşınabilir Söndürücüler (YSC)",
        isMandatory: true,
        reason: "Her yapıda zorunludur.",
        note:
            "Toplam İnşaat Alanı ($toplamInsaat m²) hesabına göre binada en az ${neededExtinguishers.toInt()} adet 6kg Kuru Kimyevi Tozlu (KKT) Yangın Söndürme Cihazı bulunmalıdır.",
      ),
    );

    return requirements;
  }
}
