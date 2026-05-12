import re

with open('original_active_systems.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Sprinkler Fix
sprinkler_old = '''    // 10. Sprinkler Sistemi
    bool sprinklerZorunlu = false;
    List<String> sprinklerReasons = [];
    bool sprinklerBilmiyorum = false;
    String? otoparkSpecificReason;
    String? otoparkSpecificNote;

    if (hYapi >= 51.50) {
      sprinklerZorunlu = true;
      sprinklerReasons.add("Yapý Yüksekliði ? 51.50m");
    }

    // Otopark Alaný Mantýðý
    if (otoparkAlanLabel != null) {
      if (otoparkAlanLabel.contains("13-1-ALT-B") ||
          otoparkAlanLabel.contains("13-1-ALT-C") ||
          otoparkAlanLabel.contains("13-1-ALT-D")) {
        sprinklerZorunlu = true;
        sprinklerReasons.add("Kapalý Otopark Alaný > 600 m²");
      } else if (otoparkAlanLabel.contains("13-1-ALT-A")) {
        // < 600 m2
        otoparkSpecificReason =
            "Otopark alaný içerisinde kaçýþ mesafelerinin Yönetmelik limitlerinin altýnda olmasý halinde sprinkler zorunluluðu yoktur.";
      } else if (otoparkAlanLabel.contains("13-1-ALT-E")) {
        // Bilmiyorum
        sprinklerBilmiyorum = true;
        otoparkSpecificReason =
            "Eðer binanýzdaki otopark alanlarý toplamý 600 m²'nin üzerindeyse otopark alanlarýnda sprinkler sistemi zorunludur.";
        otoparkSpecificNote = "";
      }
    }

    // Nihai Durum Kararý (Sprinkler)
    if (sprinklerZorunlu) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Sprinkler Sistemi",
          isMandatory: true,
          reason: "Zorunluluk Sebebi: .",
          note: otoparkSpecificNote ?? "",
        ),
      );
    } else if (sprinklerBilmiyorum) {
      // Otopark alaný bilinmiyorsa: UYARI
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Sprinkler Sistemi",
          isMandatory: false,
          isWarning: true,
          reason:
              otoparkSpecificReason ??
              "Otopark alaný bilgisi girilmediði için sprinkler zorunluluðu netleþmemiþtir.",
          note: otoparkSpecificNote ?? "",
        ),
      );
    } else {
      // Zorunlu deðil ve otopark alaný < 600m2 veya otopark yok
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Sprinkler Sistemi",
          isMandatory: false,
          reason:
              otoparkSpecificReason ?? "Zorunluluk kriterleri oluþmamýþtýr.",
        ),
      );
    }'''

sprinkler_new = '''    // 10. Sprinkler Sistemi
    bool buildingMandatory = false;
    bool otoparkMandatory = false;
    List<String> sprinklerReasons = [];
    bool sprinklerBilmiyorum = false;
    String? otoparkSpecificReason;
    String? otoparkSpecificNote;

    if (hYapi >= 51.50) {
      buildingMandatory = true;
      sprinklerReasons.add("Yapý Yüksekliði ? 51.50m");
    }

    // Otopark Alaný Mantýðý
    if (otoparkAlanLabel != null) {
      if (otoparkAlanLabel.contains("13-1-ALT-B") ||
          otoparkAlanLabel.contains("13-1-ALT-C") ||
          otoparkAlanLabel.contains("13-1-ALT-D")) {
        otoparkMandatory = true;
        sprinklerReasons.add("Kapalý Otopark Alaný > 600 m²");
      } else if (otoparkAlanLabel.contains("13-1-ALT-A")) {
        // < 600 m2
        otoparkSpecificReason =
            "Otopark alaný içerisinde kaçýþ mesafelerinin Yönetmelik limitlerinin altýnda olmasý halinde sprinkler zorunluluðu yoktur.";
      } else if (otoparkAlanLabel.contains("13-1-ALT-E")) {
        // Bilmiyorum
        sprinklerBilmiyorum = true;
        otoparkSpecificReason =
            "Eðer binanýzdaki otopark alanlarý toplamý 600 m²'nin üzerindeyse otopark alanlarýnda sprinkler sistemi zorunludur. 600 m2 'nin altýnda ise kaçýþ mesafeleri ve diðer koþullarýn Yönetmelik sýnýrlarýný aþmadýðý durumda sprinkler sistemi zorunlu deðildir.";
        otoparkSpecificNote = "";
      }
    }

    // Nihai Durum Kararý (Sprinkler)
    bool sprinklerZorunlu = buildingMandatory || otoparkMandatory;

    if (sprinklerZorunlu) {
      String finalNote = otoparkSpecificNote ?? "";
      if (otoparkMandatory && !buildingMandatory) {
        finalNote =
            "Bu zorunluluk sadece kapalý otopark alanlarý için geçerlidir; binanýn konut bölümlerinde (yükseklik sýnýrýnýn altýnda kalýndýðý için) sprinkler sistemi zorunlu deðildir.";
      }

      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Sprinkler Sistemi",
          isMandatory: true,
          reason: "Zorunluluk Sebebi: .",
          note: finalNote,
        ),
      );
    } else if (sprinklerBilmiyorum) {
      // Otopark alaný bilinmiyorsa: UYARI
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Sprinkler Sistemi",
          isMandatory: false,
          isWarning: true,
          reason:
              otoparkSpecificReason ??
              "Otopark alaný bilgisi girilmediði için sprinkler zorunluluðu netleþmemiþtir.",
          note: otoparkSpecificNote ?? "",
        ),
      );
    } else {
      // Zorunlu deðil ve otopark alaný < 600m2 veya otopark yok
      requirements.add(
        ActiveSystemRequirement(
          name: "Otomatik Sprinkler Sistemi",
          isMandatory: false,
          reason:
              otoparkSpecificReason ?? "Zorunluluk kriterleri oluþmamýþtýr.",
        ),
      );
    }'''

content = content.replace(sprinkler_old, sprinkler_new)


# 2. Pressurization Fix
basinc_old = '''    // 13. Basýnçlandýrma Sistemi
    List<String> basincLocations = [];
    bool basincBilmiyor = false;

    if (hYapi >= 30.50 && hYapi < 51.50) {
      if (store.bolum21?.varlik?.label.contains("21-1-B") == true) {
        basincLocations.add("Merdivenlerin en az birinde");
      }
    }

    if (hYapi >= 51.50) {
      basincLocations.add("Merdivenlerin en az ikisinde");
    }

    if (store.bolum23?.havalandirma?.label.contains("23-5-B") == true) {
      basincLocations.add("Normal (Ýnsan) asansör kuyusunda");
    } else if (store.bolum23?.havalandirma?.label.contains("23-5-C") == true) {
      basincBilmiyor = true;
    }

    if (store.bolum22?.varlik?.label.contains("22-6-A") == true) {
      basincLocations.add("Ýtfaiye asansöründe");
    }

    if ((store.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      basincLocations.add("Bodrum kata hizmet veren kaçýþ merdivenlerinde");
    }

    if (basincLocations.isNotEmpty) {
      String noteText = basincLocations.join(", ");
      if (basincBilmiyor) {
        noteText +=
            ". Ayrýca asansör kuyusunda mimari proje üzerinde veya Yangýn Güvenlik Mühendisi tarafýndan yerinde inceleme yapýlmasý gereklidir.";
      }

      requirements.add(
        ActiveSystemRequirement(
          name: "Basýnçlandýrma Sistemi",
          isMandatory: true,
          reason: "Aþaðýdaki alanlarda basýnçlandýrma yapýlmasý ZORUNLUDUR:",
          note: ".",
        ),
      );
    } else if (basincBilmiyor) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basýnçlandýrma Sistemi",
          isMandatory: false,
          isWarning: true,
          reason: "Asansör kuyusunda havalandýrma durumu belirsizdir.",
          note:
              "Asansör kuyusunda mimari proje üzerinde veya Yangýn Güvenlik Mühendisi tarafýndan yerinde inceleme yapýlmasý gereklidir. Ýnceleme sonucuna göre eðer kuyu tepesinde duman tahliye penceresi/bacasý yoksa basýnçlandýrma sistemi zorunlu hale gelebilir.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basýnçlandýrma Sistemi",
          isMandatory: false,
          reason: "Basýnçlandýrma gerektiren bir durum tespit edilmemiþtir.",
        ),
      );
    }'''

basinc_new = '''    // 13. Basýnçlandýrma Sistemi
    List<String> basincLocations = [];
    bool basincBilmiyor = false;
    String? customReason;
    String? customNote;

    // 13.1 Merdiven Basýnçlandýrma (Yüksekliðe Baðlý)
    if (hYapi >= 30.50 && hYapi < 51.50) {
      final hasYgh = store.bolum21?.varlik?.label.contains("21-1-A") == true;
      final noYgh = store.bolum21?.varlik?.label.contains("21-1-B") == true;

      if (noYgh) {
        basincLocations.add("Merdivenlerin en az birinde");
        customReason =
            "Yapý yüksekliði 30.50m - 51.50m aralýðýnda olduðu ve kaçýþ merdivenlerinde Yangýn Güvenlik Holü (YGH) bulunmadýðý için basýnçlandýrma zorunludur.";
      } else if (hasYgh) {
        customReason =
            "Yapý yüksekliði 30.50m - 51.50m aralýðýnda olmasýna raðmen, merdiven giriþlerinde Yangýn Güvenlik Holü (YGH) bulunduðu için basýnçlandýrma sistemi zorunlu deðildir.";
        customNote =
            "Ancak kaçýþ güvenliðinin artýrýlmasý adýna en az bir merdivende basýnçlandýrma yapýlmasý önerilir.";
      }
    } else if (hYapi >= 51.50) {
      basincLocations.add("Merdivenlerin en az ikisinde");
      customReason =
          "Yapý yüksekliði 51.50m ve üzerinde olduðu için kaçýþ merdivenlerinde basýnçlandýrma zorunludur.";
    }

    // 13.2 Asansör Kuyusu Basýnçlandýrma
    if (store.bolum23?.havalandirma?.label.contains("23-5-B") == true) {
      basincLocations.add("Normal (Ýnsan) asansör kuyusunda");
    } else if (store.bolum23?.havalandirma?.label.contains("23-5-C") == true) {
      basincBilmiyor = true;
    }

    if (store.bolum22?.varlik?.label.contains("22-6-A") == true) {
      basincLocations.add("Ýtfaiye asansöründe");
    }

    if ((store.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      basincLocations.add("Bodrum kata hizmet veren kaçýþ merdivenlerinde");
    }

    // Nihai Deðerlendirme
    if (basincLocations.isNotEmpty) {
      String noteText = basincLocations.join(", ");
      if (basincBilmiyor) {
        noteText +=
            ". Ayrýca asansör kuyusunda mimari proje üzerinde veya uzman incelemesi yapýlmasý gereklidir.";
      }

      requirements.add(
        ActiveSystemRequirement(
          name: "Basýnçlandýrma Sistemi",
          isMandatory: true,
          reason: customReason ??
              "Aþaðýdaki alanlarda basýnçlandýrma yapýlmasý ZORUNLUDUR:",
          note: customNote ?? ".",
        ),
      );
    } else if (basincBilmiyor) {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basýnçlandýrma Sistemi",
          isMandatory: false,
          isWarning: true,
          reason: "Asansör kuyusunda havalandýrma durumu belirsizdir.",
          note:
              "Asansör kuyusunda mimari proje üzerinde veya Yangýn Güvenlik Mühendisi tarafýndan yerinde inceleme yapýlmasý gereklidir. Ýnceleme sonucuna göre eðer kuyu tepesinde duman tahliye penceresi/bacasý yoksa basýnçlandýrma sistemi zorunlu hale gelebilir.",
        ),
      );
    } else {
      requirements.add(
        ActiveSystemRequirement(
          name: "Basýnçlandýrma Sistemi",
          isMandatory: false,
          reason: customReason ??
              "Basýnçlandýrma gerektiren bir durum tespit edilmemiþtir.",
          note: customNote ?? "",
        ),
      );
    }'''

content = content.replace(basinc_old, basinc_new)


# 3. Sismik Askýlama Name Fix
content = content.replace('"Sismik Askýlama (Depreme Karþý Tesisat Koruma) Sistemleri"', '"Sismik Askýlama Sistemi"')
content = content.replace('"Sismik Askýlama (Depreme Karþý Tesisat Koruyucu) Sistemler"', '"Sismik Askýlama Sistemi"')


with open('lib/logic/active_systems_engine.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Fix applied successfully!")
