import '../data/bina_store.dart';
import '../models/active_system_requirement.dart';
import '../models/bolum_6_model.dart';
import '../models/bolum_35_model.dart';

class ActiveSystemsEngine {
  static List<ActiveSystemRequirement> calculateRequirements(BinaStore store) {
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
        note:
            "Aktif sistem gereksinimlerinin belirtildiği bu çalışmadaki hiçbir sistem veya ekipman binanızda zorunlu değil ise ve binada asansör de yok ise yangın SENARYOSU ve yangın MATRİSİ oluşturulması zorunlu olmayabilir.",
      ),
    );

    requirements.add(
      ActiveSystemRequirement(
        name: "Yangın Matrisi (Cause and Effect)",
        isMandatory: true,
        reason:
            "Sistemlerin birbiriyle entegrasyonunu (Örn: Alarm çalınca asansörün inmesi, fanların devrey girmesi vb.) gösteren Cause and Effect (Sebep-Sonuç) matrisi hazırlanmalıdır.",
      ),
    );

    // 2. Yangın Algılama Sistemi
    // Kural: hYapi >= 51.50m ise ZORUNLU.
    if (hYapi >= 51.50) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Algılama ve Uyarı Sistemi",
          isMandatory: true,
          reason:
              "KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Algılama ve Uyarı Sistemi",
          isMandatory: false,
          reason:
              "OLUMLU: Yapı Yüksekliği < 51.50m (ve diğer ek şartlar oluşmadığı varsayılarak) zorunlu değildir.",
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
              ? "KRİTİK RİSK: Yapı Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "KRİTİK RİSK: Binadaki toplam kullanıcı yükü 200 kişiyi aştığı için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Aydınlatma Sistemi",
          isMandatory: false,
          reason: "OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
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
          reason:
              "KRİTİK RİSK: Birden fazla çıkış (kaçış yolu) bulunduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Acil Durum Yönlendirmeleri",
          isMandatory: false,
          reason:
              "OLUMLU: Tek çıkışlı binalarda zorunlu tutulmamıştır (ancak önerilmektedir).",
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
          reason:
              "KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli Tahliye (Anons) Sistemi",
          isMandatory: false,
          reason:
              "OLUMLU: Yapı Yüksekliği < 51.50m olduğu için zorunlu değildir.",
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
              ? "KRİTİK RİSK: Bina Yüksekliği ≥ 21.50m olduğu için zorunludur."
              : "KRİTİK RİSK: Yapı Yüksekliği ≥ 30.50m olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Elle İhbar Sistemi (Kır-Bas Yangın Butonu)",
          isMandatory: false,
          reason: "OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
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
              "KRİTİK RİSK: Elle ihbar sistemi (Buton) zorunlu olduğu için alarm cihazları da zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sesli ve Işıklı Alarm Cihazları",
          isMandatory: false,
          reason:
              "OLUMLU: Elle ihbar sistemi zorunlu olmadığı için şart değildir.",
        ),
      );
    }

    // 7. Yangın Dolabı Sistemi
    bool dolapZorunlu = false;
    List<String> dolapReasons = [];

    if (hYapi >= 21.50) {
      dolapZorunlu = true;
      dolapReasons.add("Yapı Yüksekliği ≥ 21.50m");
    }

    final otoparkAlanLabel = store.bolum13?.otoparkAlan?.label;
    // Otopark > 600 m2 (B, C, D)
    if (otoparkAlanLabel != null &&
        (otoparkAlanLabel.contains("13-1-ALT-B") ||
            otoparkAlanLabel.contains("13-1-ALT-C") ||
            otoparkAlanLabel.contains("13-1-ALT-D"))) {
      dolapZorunlu = true;
      dolapReasons.add("Kapalı Otopark Alanı > 600 m²");
    }

    if (dolapZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Dolabı Sistemi",
          isMandatory: true,
          reason:
              "KRİTİK RİSK: ${dolapReasons.join(', ')} olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Dolabı Sistemi",
          isMandatory: false,
          reason:
              "OLUMLU: Yapı Yüksekliği < 21.50m ve özel riskli alanlar (Otopark > 600m²) bulunmadığı için zorunlu değildir.",
        ),
      );
    }

    // 8. İtfaiye Su Alma Ağzı
    bool suAlmaZorunlu = false;
    List<String> suAlmaReasons = [];

    if (hBina >= 21.50) {
      suAlmaZorunlu = true;
      suAlmaReasons.add("Bina Yüksekliği ≥ 21.50m");
    } else if (hYapi >= 30.50 && tabanAlani > 1000) {
      suAlmaZorunlu = true;
      suAlmaReasons.add("Yapı Yüksekliği ≥ 30.50m ve Taban Alanı > 1000 m²");
    }

    // Otopark > 1000 m2 (C, D)
    if (otoparkAlanLabel != null &&
        (otoparkAlanLabel.contains("13-1-ALT-C") ||
            otoparkAlanLabel.contains("13-1-ALT-D"))) {
      suAlmaZorunlu = true;
      suAlmaReasons.add("Kapalı Otopark Alanı > 1000 m²");
    }

    if (suAlmaZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "İtfaiye Su Alma Ağzı",
          isMandatory: true,
          reason:
              "KRİTİK RİSK: ${suAlmaReasons.join(', ')} olduğu için zorunludur.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "İtfaiye Su Alma Ağzı",
          isMandatory: false,
          reason: "OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
        ),
      );
    }

    // 9. İtfaiye Su Verme Bağlantısı (Siyam İkizi)
    bool siyamZorunlu = false;
    String siyamReason = "";

    if (hBina >= 21.50) {
      siyamZorunlu = true;
      siyamReason =
          "KRİTİK RİSK: Bina Yüksekliği ≥ 21.50m olduğu için zorunludur.";
    } else if (hYapi >= 30.50) {
      siyamZorunlu = true;
      siyamReason =
          "KRİTİK RİSK: Yapı Yüksekliği ≥ 30.50m olduğu için zorunludur.";
    } else if (tabanAlani > 1000) {
      siyamZorunlu = true;
      siyamReason =
          "KRİTİK RİSK: Taban Alanı > 1000 m² olduğu için zorunludur.";
    } else if ((facadeWidth ?? 0) > 75) {
      siyamZorunlu = true;
      siyamReason =
          "KRİTİK RİSK: Cephe Genişliği > 75m olduğu için zorunludur.";
    }

    requirements.add(
      ActiveSystemRequirement(
        name: "İtfaiye Su Verme Ağzı (Siyam İkizi)",
        isMandatory: siyamZorunlu,
        reason: siyamZorunlu
            ? siyamReason
            : "OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
      ),
    );

    // 10. Sprinkler Sistemi
    bool sprinklerZorunlu = false;
    List<String> sprinklerReasons = [];
    bool sprinklerBilmiyorum = false;
    String? otoparkSpecificReason;
    String? otoparkSpecificNote;

    if (hYapi >= 51.50) {
      sprinklerZorunlu = true;
      sprinklerReasons.add("Yapı Yüksekliği ≥ 51.50m");
    }

    // Otopark Alanı Mantığı
    if (otoparkAlanLabel != null) {
      if (otoparkAlanLabel.contains("13-1-ALT-B") ||
          otoparkAlanLabel.contains("13-1-ALT-C") ||
          otoparkAlanLabel.contains("13-1-ALT-D")) {
        sprinklerZorunlu = true;
        sprinklerReasons.add("Kapalı Otopark Alanı > 600 m²");
      } else if (otoparkAlanLabel.contains("13-1-ALT-A")) {
        // < 600 m2
        otoparkSpecificReason =
            "OLUMLU: Otopark alanı içerisinde kaçış mesafelerinin Yönetmelik limitlerinin altında olması halinde sprinkler zorunluluğu yoktur.";
      } else if (otoparkAlanLabel.contains("13-1-ALT-E")) {
        // Bilmiyorum
        sprinklerBilmiyorum = true;
        otoparkSpecificReason =
            "BİLMİYORUM: Eğer binanızdaki otopark alanları toplamı 600 m²'nin üzerindeyse otopark alanlarında sprinkler sistemi zorunludur.";
        otoparkSpecificNote = "";
      }
    }

    // Nihai Durum Kararı (Sprinkler)
    if (sprinklerZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Yağmurlama (Sprinkler) Sistemi",
          isMandatory: true,
          reason:
              "KRİTİK RİSK: Zorunluluk Sebebi: ${sprinklerReasons.join(', ')}.",
          note: otoparkSpecificNote ?? "",
        ),
      );
    } else if (sprinklerBilmiyorum) {
      // Otopark alanı bilinmiyorsa: UYARI
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Yağmurlama (Sprinkler) Sistemi",
          isMandatory: false,
          isWarning: true,
          reason:
              otoparkSpecificReason ??
              "BİLMİYORUM: Otopark alanı bilgisi girilmediği için sprinkler zorunluluğu netleşmemiştir.",
          note: otoparkSpecificNote ?? "",
        ),
      );
    } else {
      // Zorunlu değil ve otopark alanı < 600m2 veya otopark yok
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Yağmurlama (Sprinkler) Sistemi",
          isMandatory: false,
          reason:
              otoparkSpecificReason ??
              "OLUMLU: Zorunluluk kriterleri oluşmamıştır.",
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
          reason:
              "KRİTİK RİSK: Taban Alanı > 5000 m² olduğu için zorunludur. Binanızın oturumu zemin kat seviyesinde değil de başka bir seviyede veya katta ise o katın taban alanı baz alınmalıdır.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Yangın Hidrant Sistemi(Bina Çevresinde)",
          isMandatory: false,
          reason:
              "OLUMLU: Taban Alanı < 5000 m² olduğu için zorunlu değildir. Bina taban alanı hesabında beyan ettiğiniz zemin katınızın alanı ele alınmıştır. Eğer farklı bir kat oturum alanı olarak kabul ediliyorsa ve bu alan 5000 m2 'yi aşıyorsa hidrant sistemi zorunlu olacaktır.",
        ),
      );
    }

    // 12. Duman Kontrol Sistemi
    bool dumanZorunlu = false;
    List<String> dumanReasons = [];
    bool dumanWarning = false;
    List<String> dumanNotes = [];

    // Genel Kural
    if (hYapi >= 51.50) {
      dumanZorunlu = true;
      dumanReasons.add("Yapı Yüksekliği ≥ 51.50m olduğu için zorunludur");
    }

    // OTOPARK KONTROLÜ (Bölüm 13)
    final otoparkAlan = store.bolum13?.otoparkAlan?.label;
    if (otoparkAlan != null) {
      if (otoparkAlan.contains("13-1-ALT-D")) {
        // > 2000 m2
        dumanZorunlu = true;
        dumanReasons.add(
          "Otopark alanlarının toplamda 2000 m²'nin üzerinde olduğu beyan edildiğinden bu alanda 10 hava değişimi sağlayan duman tahliye sistemi kurulması zorunludur",
        );
      } else if (otoparkAlan.contains("13-1-ALT-E")) {
        // Bilmiyorum
        dumanWarning = true;
        dumanNotes.add(
          "Otopark alanları ile ilgili bir alan bilgisi beyan edilmemiştir. Otopark alanlarının 2000 m²'yi aşması halinde 10 hava değişimi sağlayan duman tahliye sistemi kurulması zorunludur.",
        );
      }
    }

    // KAZAN DAİRESİ KONTROLÜ (Bölüm 13)
    final kazanAlan = store.bolum13?.kazanAlan?.label;
    if (kazanAlan != null) {
      if (kazanAlan.contains("13-2-ALT-B")) {
        // > 2000 m2
        dumanZorunlu = true;
        dumanReasons.add(
          "Kazan dairesinin toplamda 2000 m²'nin üzerinde olduğu beyan edildiğinden bu alanda 10 hava değişimi sağlayan duman tahliye sistemi kurulması zorunludur",
        );
      } else if (kazanAlan.contains("13-2-ALT-C")) {
        // Bilmiyorum
        dumanWarning = true;
        dumanNotes.add(
          "Kazan dairesi ile ilgili bir alan bilgisi beyan edilmemiştir. Kazan dairesinin 2000 m²'yi aşması halinde 10 hava değişimi sağlayan duman tahliye sistemi kurulması zorunludur.",
        );
      }
    }

    // SIĞINAK KONTROLÜ (Bölüm 13)
    final siginakAlan = store.bolum13?.siginakAlan?.label;
    if (siginakAlan != null) {
      if (siginakAlan.contains("13-12-B")) {
        // > 2000 m2
        dumanZorunlu = true;
        dumanReasons.add(
          "Sığınağın toplamda 2000 m²'nin üzerinde olduğu beyan edildiğinden bu alanda 10 hava değişimi sağlayan duman tahliye sistemi kurulması zorunludur",
        );
      } else if (siginakAlan.contains("13-12-C")) {
        // Bilmiyorum
        dumanWarning = true;
        dumanNotes.add(
          "Sığınak ile ilgili bir alan bilgisi beyan edilmemiştir. Sığınağın 2000 m²'yi aşması halinde 10 hava değişimi sağlayan duman tahliye sistemi kurulması zorunludur.",
        );
      }
    }

    if (dumanZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Duman Kontrol Sistemi",
          isMandatory: true,
          reason: "KRİTİK RİSK: ${dumanReasons.join('. ')}.",
          note: dumanNotes.isNotEmpty ? dumanNotes.join(' ') : "",
        ),
      );
    } else {
      if (dumanWarning) {
        requirements.add(
          ActiveSystemRequirement(
            name: "Duman Kontrol Sistemi",
            isMandatory: false,
            isWarning: true,
            reason:
                "UYARI: Genel bir duman kontrol sistemi zorunluluğu tespit edilmemiştir ancak bazı alanlar için belirsizlik bulunmaktadır.",
            note: dumanNotes.join(' '),
          ),
        );
      } else {
        List<String> positiveNotes = [];
        if (otoparkAlan != null && otoparkAlan.contains("13-1-ALT-A")) {
          positiveNotes.add(
            "Otopark alanlarının toplamda 2000 m² veya altında olduğu beyan edildiğinden bu alanda duman tahliye sistemi kurulması zorunlu değildir.",
          );
        }
        if (kazanAlan != null && kazanAlan.contains("13-2-ALT-A")) {
          positiveNotes.add(
            "Kazan dairesinin toplamda 2000 m² veya altında olduğu beyan edildiğinden bu alanda duman tahliye sistemi kurulması zorunlu değildir.",
          );
        }
        if (siginakAlan != null && siginakAlan.contains("13-12-A")) {
          positiveNotes.add(
            "Sığınağın 2000 m² veya altında olduğu beyan edildiğinden bu alanda duman tahliye sistemi kurulması zorunlu değildir.",
          );
        }

        requirements.add(
          ActiveSystemRequirement(
            name: "Duman Kontrol Sistemi",
            isMandatory: false,
            reason:
                "OLUMLU: Yapı Yüksekliği < 51.50m ve özel riskli alanlar (Otopark, Kazan Dairesi vb.) sınırların altında olduğu için duman kontrol sistemi zorunlu değildir.",
            note: positiveNotes.join(' '),
          ),
        );
      }
    }

    // 12.1 Atrium
    requirements.add(
      ActiveSystemRequirement(
        name: "Atrium Duman Kontrolü",
        isMandatory: false,
        isWarning: true,
        reason:
            "UYARI: Alanı 90 m²'den küçük olan atrium boşluklarının çevresi her katta en az 45 cm yüksekliğinde duman perdesi ile çevrelenir ve yağmurlama sistemi ile korunan binalarda duman perdesinden 15 ila 30 cm uzaklıkta, aralarındaki mesafe en çok 2 m olacak şekilde yağmurlama başlığı yerleştirilir. Atriumlarda doğal veya mekanik olarak duman kontrolü yapılır.",
        definitionTerm: "Atrium",
        definitionText:
            "İki veya daha çok sayıda katın içine açıldığı, merdiven yuvası, asansör kuyusu, yürüyenmerdiven boşluğu veya su, elektrik, havalandırma, iklimlendirme, haberleşme, tesisat bacaları ve şaftlar hariç, üstü kapalı geniş ve yüksek hacmi ifade eder.",
      ),
    );

    // 13. Basınçlandırma Sistemi
    List<String> basincLocations = [];

    if (hYapi >= 30.50 && hYapi < 51.50) {
      if (store.bolum21?.varlik?.label == "21-1-B") {
        basincLocations.add("Merdivenlerin en az birinde");
      }
    }

    if (hYapi >= 51.50) {
      basincLocations.add("Merdivenlerin en az ikisinde");
    }

    if (store.bolum23?.havalandirma?.label == "23-5-B") {
      basincLocations.add("Normal (İnsan) asansör kuyusunda");
    }

    if (store.bolum22?.varlik?.label.contains("22-6-A") == true) {
      basincLocations.add("İtfaiye asansöründe");
    }

    if ((store.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      basincLocations.add("Bodrum kata hizmet veren kaçış merdivenlerinde");
    }

    if (basincLocations.isNotEmpty) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basınçlandırma Sistemi",
          isMandatory: true,
          reason:
              "KRİTİK RİSK: Aşağıdaki alanlarda basınçlandırma yapılması ZORUNLUDUR:",
          note: "${basincLocations.join(", ")}.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basınçlandırma Sistemi",
          isMandatory: false,
          reason:
              "OLUMLU: Basınçlandırma gerektiren bir durum tespit edilmemiştir.",
        ),
      );
    }

    // 14. Sismik Askılama
    if (sprinklerZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sismik Askılama (Depreme Karşı Tesisat Koruyucu) Sistemler",
          isMandatory: false,
          isWarning: true,
          reason:
              "UYARI: Otomatik Yağmurlama (Sprinkler) sistemi zorunlu olduğu için, binanızın deprem bölgesine göre sismik önlemler alınması gerekebilir. Kesin sismik önlemler için binanızın bulunduğu bölgeye göre yorum yapılmalıdır.",
          note:
              "Birinci ve ikinci derece deprem bölgelerinde, sismik hareketlere karşı ana kolonların herhangi bir yöne sürüklenmemesi için, dört yollu destek kullanılması ve 65 mm ve daha büyük nominal çaplı boruların katlardan ana dağıtım borularına bağlanmasında esnek bağlantılar ile boruların tavanlara tutturulmasında iki yollu enlemesine ve boylamasına sabitleme askı elemanları kullanılarak boruların kırılmasının önlenmesi gerekir. Dilatasyon geçişlerinde her üç yönde hareketi karşılayacak detaylar uygulanır.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Sismik Askılama Sistemleri",
          isMandatory: false,
          reason:
              "OLUMLU: Sprinkler sistemi zorunlu olmadığı için öncelikli değildir.",
        ),
      );
    }

    // 15. Taşınabilir Söndürücü
    double neededExtinguishers = (toplamInsaat / 250).ceilToDouble();
    requirements.add(
      ActiveSystemRequirement(
        name: "Taşınabilir (Portatif) Söndürücüler (YSC)",
        isMandatory: true,
        reason: "BİLGİ: Her yapıda zorunludur.",
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
            "UYARI: Kazan dairesi (doğalgaz/LPG), otopark (karbonmonoksit) veya mutfak gibi alanlarda uygun gaz algılama dedektörleri kullanılmalıdır.",
      ),
    );

    // 17. Yangın Damperi
    requirements.add(
      ActiveSystemRequirement(
        name: "Yangın Damperi",
        isMandatory: false,
        isWarning: true,
        reason:
            "UYARI: Yangın kompartımanı veya yangın zonu olarak tanımlanmış alanların döşeme ve tüm duvarlarında yer alan, havalandırma kanalı geçişi vb. korunumsuz açıklıklarda Yangın Damperi kullanılmalıdır.",
      ),
    );

    // 18. Duman Damperi
    requirements.add(
      ActiveSystemRequirement(
        name: "Duman Damperi",
        isMandatory: false,
        isWarning: true,
        reason:
            "UYARI: Duman tahliye sistemine ait kanalların yangın kompartımanı veya yangın zonundan geçmesi halinde geçiş noktalarında duman damperi kullanılmalıdır.",
      ),
    );

    return requirements;
  }
}
