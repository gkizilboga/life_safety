import 'package:life_safety/data/bina_store.dart';

class Section36Handler {
  final BinaStore _store;

  Section36Handler(this._store);

  List<String> _buildAnalysisParts() {
    List<String> analysisParts = [];
    final b20 = _store.bolum20;
    final hasSprinkler = _store.bolum9?.secim?.label == "9-1-A";

    if (b20 != null) {
      // 0. Yükseklik Verilerini Belirle (Bölüm 4 - Doğrulanmış Veriyi Önceliklendir)
      final b3 = _store.bolum3;
      final b4 = _store.bolum4;
      double hBina = b4?.hesaplananBinaYuksekligi ?? b3?.hBina ?? 0;
      double hYapi = b4?.hesaplananYapiYuksekligi ?? b3?.hYapi ?? 0;

      // 1. Merdiven Tipleri ve Sayıları (Özet İhlaller)
      // Dairesel merdiven uyarısı detaylı analizde (#5) halledilecek, burada sadece sahanlıksız uyarısı kalsın.
      if (b20.sahanliksizMerdivenSayisi > 0) {
        analysisParts.add(
          "KRİTİK RİSK: Binada ${b20.sahanliksizMerdivenSayisi} adet sahanlıksız (kaçış yolu olarak kabul edilmeyen) merdiven tespit edilmiştir.",
        );
      }

      int maxYuk = 0;
      final b33 = _store.bolum33;
      final b34 = _store.bolum34;
      if (b33 != null) {
        bool zeminIndependent = b34?.zemin?.label.contains("34-1-A") ?? false;
        int yukZemin = zeminIndependent ? 0 : (b33.yukZemin ?? 0);
        int yukNormal = b33.yukNormal ?? 0;
        int yukBodrum = b33.yukBodrum ?? 0;
        maxYuk = [
          yukZemin,
          yukNormal,
          yukBodrum,
        ].reduce((curr, next) => curr > next ? curr : next);
      }

      if (b20.dengelenmisMerdivenSayisi > 0) {
        if (hBina > (15.50 - 0.001) || maxYuk > 100) {
          analysisParts.add(
            "KRİTİK RİSK: Binadaki Dengelenmiş Merdiven, yapı yüksekliği ($hBina m) veya kullanıcı yükü ($maxYuk kişi) sınırları aşıldığı için yönetmeliğe uygun DEĞİLDİR.",
          );
        } else {
          analysisParts.add(
            "OLUMLU: Dengelenmiş Merdiven kullanımı, bina yüksekliği ve kişi yükü sınırları içerisinde olduğu için uygundur.",
          );
        }
      }

      // 1.1 Bodrum Merdiven Hataları
      if (b20.isBodrumIndependent) {
        if (b20.bodrumSahanliksizMerdivenSayisi > 0) {
          analysisParts.add(
            "KRİTİK RİSK: Bodrum katlarda ${b20.bodrumSahanliksizMerdivenSayisi} adet sahanlıksız merdiven tespit edilmiştir.",
          );
        }
        if (b20.bodrumDengelenmisMerdivenSayisi > 0) {
          if (hBina > (15.50 - 0.001) || maxYuk > 100) {
            analysisParts.add(
              "KRİTİK RİSK: Bodrum katlardaki Dengelenmiş Merdiven sınırları aştığı için uygun DEĞİLDİR.",
            );
          } else {
            analysisParts.add(
              "OLUMLU: Bodrum katlardaki Dengelenmiş Merdiven kullanımı uygundur.",
            );
          }
        }
      }

      // 2. Madde 41/1: Doğrudan Dışarıya Tahliye Oranı (BİRLEŞTİRİLMİŞ MANTIK)
      final int totalMain =
          b20.normalMerdivenSayisi +
          b20.binaIciYanginMerdiveniSayisi +
          b20.binaDisiKapaliYanginMerdiveniSayisi +
          b20.binaDisiAcikYanginMerdiveniSayisi +
          b20.donerMerdivenSayisi +
          b20.sahanliksizMerdivenSayisi +
          b20.dengelenmisMerdivenSayisi;
      bool mainDirectFail = false;
      int reqDirectMain = 0;
      int directMain = 0;

      if (totalMain > 0) {
        directMain = b20.toplamDisariAcilanMerdivenSayisi;
        reqDirectMain = (totalMain / 2.0).ceil();
        mainDirectFail = directMain < reqDirectMain;
      }

      bool bodrumDirectFail = false;
      int reqDirectBod = 0;
      int directBod = 0;
      int totalBod = 0;

      if (b20.isBodrumIndependent) {
        totalBod =
            b20.bodrumNormalMerdivenSayisi +
            b20.bodrumBinaIciYanginMerdiveniSayisi +
            b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi +
            b20.bodrumBinaDisiAcikYanginMerdiveniSayisi +
            b20.bodrumDonerMerdivenSayisi +
            b20.bodrumSahanliksizMerdivenSayisi +
            b20.bodrumDengelenmisMerdivenSayisi;
        if (totalBod > 0) {
          directBod = b20.bodrumToplamDisariAcilanMerdivenSayisi;
          reqDirectBod = (totalBod / 2.0).ceil();
          bodrumDirectFail = directBod < reqDirectBod;
        }
      }

      // Kombine Raporlama (Madde 41 - Dışa Açılan Merdiven)
      if (mainDirectFail && bodrumDirectFail) {
        analysisParts.add(
          "KRİTİK RİSK: Hem normal hem de bodrum katlarda kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması kuralı İHLAL EDİLMİŞTİR. (Normal: $directMain/$reqDirectMain, Bodrum: $directBod/$reqDirectBod sağlanıyor)",
        );
      } else if (mainDirectFail) {
        analysisParts.add(
          "KRİTİK RİSK: Normal katlarda kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması kuralı sağlanmamaktadır. (En az $reqDirectMain açılmalı, mevcut $directMain).",
        );
      } else if (bodrumDirectFail) {
        analysisParts.add(
          "KRİTİK RİSK: Bodrum katlarda kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması kuralı sağlanmamaktadır. (En az $reqDirectBod açılmalı, mevcut $directBod).",
        );
      } else if (totalMain > 0 || totalBod > 0) {
        analysisParts.add(
          "OLUMLU: Merdivenlerin en az %50'sinin doğrudan dışarıya açılması kuralı tüm katlarda başarıyla sağlanmaktadır.",
        );
      }

      // 3. Madde 41/2: Tahliye Koridoru/Lobi Mesafesi (BİRLEŞTİRİLMİŞ MANTIK)
      int limit = hasSprinkler ? 15 : 10;
      String sprinklerNote = hasSprinkler
          ? "(Sprinkler mevcut: Limit 15m)"
          : "(Sprinkler yok: Limit 10m)";

      bool mainMesafeFail =
          (directMain < totalMain) &&
          b20.lobiTahliyeMesafeDurumu?.label == "41-MESAFE-B";
      bool mainMesafeUnknown =
          (directMain < totalMain) &&
          b20.lobiTahliyeMesafeDurumu?.label == "41-MESAFE-C";

      bool bodrumMesafeFail =
          b20.isBodrumIndependent &&
          (directBod < totalBod) &&
          b20.bodrumLobiTahliyeMesafeDurumu?.label == "41-MESAFE-B";
      bool bodrumMesafeUnknown =
          b20.isBodrumIndependent &&
          (directBod < totalBod) &&
          b20.bodrumLobiTahliyeMesafeDurumu?.label == "41-MESAFE-C";

      if (mainMesafeFail || bodrumMesafeFail) {
        String msg = "KRİTİK RİSK: ";
        if (mainMesafeFail && bodrumMesafeFail)
          msg += "Hem normal hem de bodrum katlarda ";
        else if (mainMesafeFail)
          msg += "Normal katlarda ";
        else
          msg += "Bodrum katlarda ";
        msg += "tahliye mesafesi %limit metre sınırını aşmaktadır %sprinkler."
            .replaceAll("%limit", limit.toString())
            .replaceAll("%sprinkler", sprinklerNote);
        analysisParts.add(msg);
      } else if (mainMesafeUnknown || bodrumMesafeUnknown) {
        analysisParts.add(
          "UYARI: BİLİNMİYOR - Tahliye (lobi) mesafesi beyan edilmediği için Madde 41 analizi tamamlanamamıştır.",
        );
      } else if ((totalMain > 0 &&
              b20.lobiTahliyeMesafeDurumu?.label == "41-MESAFE-A") ||
          (totalBod > 0 &&
              b20.bodrumLobiTahliyeMesafeDurumu?.label == "41-MESAFE-A")) {
        analysisParts.add(
          "OLUMLU: Tahliye (lobi) mesafeleri yönetmelik limitleri ($limit m) içerisindedir.",
        );
      }

      // 4. Korunumlu Merdiven Gereksinimi Analizi (BİRLEŞTİRİLMİŞ MANTIK)
      int currentProtected =
          b20.binaIciYanginMerdiveniSayisi +
          b20.binaDisiKapaliYanginMerdiveniSayisi;

      int requiredProtected = 0;
      // High building thresholds (21.50 and 30.50) checked against both hBina and hYapi
      double hPrimary = hYapi >= hBina ? hYapi : hBina;

      if (hPrimary >= (21.50 - 0.001) && hPrimary < (30.50 - 0.001)) {
        requiredProtected = 1;
      } else if (hPrimary >= (30.50 - 0.001)) {
        requiredProtected = 2;
      }

      if (requiredProtected > 0) {
        bool mainKoruFail = currentProtected < requiredProtected;

        bool bodrumKoruFail = false;
        int korBod = 0;
        if (b20.isBodrumIndependent) {
          korBod =
              b20.bodrumBinaIciYanginMerdiveniSayisi +
              b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi;
          bodrumKoruFail = korBod < requiredProtected;
        }

        if (mainKoruFail && bodrumKoruFail) {
          analysisParts.add(
            "KRİTİK RİSK: Bina yüksekliği ($hPrimary m) nedeniyle hem normal hem de bodrum katlarda en az $requiredProtected adet 'Korunumlu Merdiven' (Yangın Merdiveni) bulunması zorunludur. Kapasiteler yetersizdir. (Normal: $currentProtected, Bodrum: $korBod)",
          );
        } else if (mainKoruFail) {
          analysisParts.add(
            "KRİTİK RİSK: Bina yüksekliği ($hPrimary m) nedeniyle normal katlarda en az $requiredProtected adet 'Korunumlu Merdiven' zorunludur. (Mevcut: $currentProtected)",
          );
        } else if (bodrumKoruFail) {
          analysisParts.add(
            "KRİTİK RİSK: Bina yüksekliği ($hPrimary m) nedeniyle bodrum katlarda en az $requiredProtected adet 'Korunumlu Merdiven' zorunludur. (Mevcut: $korBod)",
          );
        } else {
          analysisParts.add(
            "OLUMLU: Bina yüksekliği ($hPrimary m) için gereken korunumlu merdiven adetleri ($requiredProtected adet) sağlanmaktadır.",
          );
        }
      }

      // 5. Dairesel Merdiven Değerlendirmesi
      final b25 = _store.bolum25;
      if (b20.hasDaireselMerdiven && b25 != null) {
        final yukseklikLabel = b25.yukseklik?.label ?? "";
        bool heightOk = yukseklikLabel == "25-Dairesel-A";
        bool heightFail = yukseklikLabel == "25-Dairesel-B";
        bool heightUnknown = yukseklikLabel == "25-Dairesel-C";
        bool loadOk = maxYuk <= 25;
        // Kova genişliği kontrolü (Min 100cm)
        int kovaG = b20.daireselMerdivenKovaGenisligi ?? 0;

        if (heightFail || !loadOk || (kovaG > 0 && kovaG < 100)) {
          List<String> reasons = [];
          if (heightFail) reasons.add("Yükseklik 9.50m limitini aşmaktadır");
          if (!loadOk)
            reasons.add("Kullanıcı yükü 25 kişiyi aşmaktadır ($maxYuk kişi)");
          if (kovaG > 0 && kovaG < 100)
            reasons.add(
              "Kova genişliği yetersiz (Min. 100cm, Mevcut: $kovaG cm)",
            );

          analysisParts.add(
            "KRİTİK RİSK: Dairesel (döner) merdiven Yangın Yönetmeliği kriterlerini sağlamamaktadır. (${reasons.join(", ")}) Bu merdiven kaçış yolu olarak değerlendirilemez. Merdivenin hizmet verdiği yükün 25 kişiden fazla olmadığı mahal bazlı teyit edilmelidir.",
          );
        } else if (heightUnknown) {
          analysisParts.add(
            "UYARI: BİLİNMİYOR - Dairesel merdiven yüksekliği bilinmediği için değerlendirme yapılamamıştır.",
          );
        } else if (heightOk && loadOk) {
          analysisParts.add(
            "OLUMLU: Dairesel merdivenler yönetmelik koşullarını (≤9.50m and ≤25 kişi) sağlamaktadır.",
          );
        }
      }

      // 6. Genişlik Analizi (Merkezileştirilmiş)
      final b36 = _store.bolum36;
      if (b36 != null) {
        double minMerd = 120;
        double minKori = 120;

        int nKat = _store.bolum3?.normalKatSayisi ?? 0;
        int bKat = _store.bolum3?.bodrumKatSayisi ?? 0;
        int toplamKat = nKat + bKat + 1;

        if (maxYuk >= 2001) {
          minMerd = 200;
          minKori = 200;
        } else if (maxYuk >= 501) {
          minMerd = 150;
          minKori = 150;
        } else if (hPrimary >= (21.50 - 0.001)) {
          minMerd = 120;
          minKori = 120;
        } else {
          minMerd = 120;
          minKori = 110;
          if (toplamKat == 1 || maxYuk < 50) {
            minMerd = 90;
            minKori = 100;
          }
        }

        void check(
          String prefix,
          dynamic sChoice,
          dynamic cChoice,
          dynamic kapiChoice, {
          bool isSpiralPossible = false,
        }) {
          List<String> violations = [];

          List<int>? getRange(String label) {
            if (label.contains("90 cm'den az")) return [0, 89];
            if (label.contains("90-120 cm")) return [90, 119];
            if (label.contains("120-150 cm")) return [120, 149];
            if (label.contains("150 cm ve üzeri")) return [150, 500];

            if (label.contains("100 cm'den az")) return [0, 99];
            if (label.contains("100-120 cm")) return [100, 119];
            // Koridor ranges...
            if (label.contains("150-200 cm")) return [150, 199];
            if (label.contains("200 cm ve üzeri")) return [200, 500];
            return null;
          }

          if (sChoice != null) {
            final range = getRange(sChoice.uiTitle);
            if (range != null) {
              // User instruction: For spiral-related checks, use upper bound (range[1]).
              // Otherwise use safe logic (range[0]).
              int comparisonValue = isSpiralPossible ? range[1] : range[0];
              if (comparisonValue < minMerd) {
                violations.add(
                  "Merdiven genişliği yetersiz (Gereken: $minMerd cm, Seçim: ${sChoice.uiTitle})",
                );
              }
            }
          }
          if (cChoice != null) {
            final range = getRange(cChoice.uiTitle);
            if (range != null && range[0] < minKori) {
              violations.add(
                "Koridor genişliği yetersiz (Gereken: $minKori cm, Seçim: ${cChoice.uiTitle})",
              );
            }
          }
          if (kapiChoice != null && kapiChoice.label == "36-Kapi-A") {
            violations.add(
              "Kapı temiz geçiş genişliği yetersiz (En az 80 cm olmalıdır)",
            );
          }

          if (violations.isNotEmpty) {
            analysisParts.add(
              "KRİTİK RİSK: $prefix alanlarda genişlik ihlali: ${violations.join(", ")}",
            );
          }
        }

        bool globalHasSpiral =
            (b20.donerMerdivenSayisi > 0 || b20.bodrumDonerMerdivenSayisi > 0);

        if (b36.areWidthsSame) {
          check(
            "GENEL",
            b36.genislikKorunumlu,
            b36.koridorGenislikKorunumlu,
            b36.kapiGenislikKorunumlu,
            isSpiralPossible: globalHasSpiral,
          );
        } else {
          if (currentProtected > 0)
            check(
              "KORUNUMLU",
              b36.genislikKorunumlu,
              b36.koridorGenislikKorunumlu,
              b36.kapiGenislikKorunumlu,
              isSpiralPossible: globalHasSpiral,
            );
          int korunumsuzCount =
              b20.normalMerdivenSayisi +
              b20.binaDisiAcikYanginMerdiveniSayisi +
              b20.donerMerdivenSayisi +
              b20.dengelenmisMerdivenSayisi;
          if (korunumsuzCount > 0)
            check(
              "KORUNUMSUZ",
              b36.genislikKorunumsuz,
              b36.koridorGenislikKorunumsuz,
              b36.kapiGenislikKorunumsuz,
              isSpiralPossible: globalHasSpiral,
            );
        }
      }
    }

    String manualEval = _store.bolum36?.merdivenDegerlendirme ?? "";
    if (manualEval.isNotEmpty) {
      analysisParts.insert(0, manualEval);
    }

    return analysisParts;
  }

  String getFullReport() {
    final parts = _buildAnalysisParts();
    if (parts.isNotEmpty) {
      return parts.join("\n\n");
    }
    return "OLUMLU: Merdivenler ve tahliye güzergahları Madde 41 kriterlerine uygundur.";
  }

  String getSummaryReport() {
    final parts = _buildAnalysisParts();
    List<String> summaryBullets = [];

    // Sadece KRİTİK RİSK ve UYARI mesajlarını özet ekrana taşıyalım (daha sade).
    for (String part in parts) {
      if (part.startsWith("KRİTİK RİSK:") ||
          part.startsWith("UYARI:")) {
        // Önekleri kaldıralım, UI liste tasarımı daha temiz olsun.
        String cleanText = part
            .replaceAll("KRİTİK RİSK: ", "")
            .replaceAll("UYARI: ", "");
        summaryBullets.add("• $cleanText");
      } else if (!part.startsWith("OLUMLU:")) {
        // "Mühendis Notu" artık ön eksiz geldiği için doğrudan ekleyelim.
        summaryBullets.add("• $part");
      }
    }

    if (summaryBullets.isNotEmpty) {
      return summaryBullets.join("\n");
    }
    return "Tüm kaçış merdivenleri yönetmelik kriterlerine (Korunumlu Merdiven adetleri, kapı yönleri ve %50 tahliye kuralları) uygundur.";
  }
}
