import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';

enum ReportModule {
  binaBilgileri(
    "Bina Hakkında Genel Bilgiler",
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    "Aquarius",
    "Çeşme, sarnıç ve su kemerlerinin yerlerini avucunun içi gibi bilen kişi.",
  ),
  modul1(
    "Modül 1",
    [11, 12, 13, 14, 15],
    "Nocturnus",
    "Gece Bekçisi ordusundan, geceleri sokaklarda devriye gezer.",
  ),
  modul2(
    "Modül 2",
    [16, 17, 18, 19, 20],
    "Siphonarius",
    "Basınçlı su makinelerini kullanan uzman asker.",
  ),
  modul3(
    "Modül 3",
    [21, 22, 23, 24, 25],
    "Centurio",
    "İtfaiye bölüğünün komutanı, taktik lider.",
  ),
  modul4(
    "Modül 4",
    [26, 27, 28, 29, 30],
    "Praefectus",
    "Taburundan sorumlu en üst düzey komutan.",
  ),
  modul5(
    "Modül 5",
    [31, 32, 33, 34, 35, 36],
    "Praefectus Maximus",
    "Final raporlama yetkisine sahip komuta kademesi.",
  );

  final String title;
  final List<int> sectionIds;
  final String rankName;
  final String rankDescription;
  const ReportModule(
    this.title,
    this.sectionIds,
    this.rankName,
    this.rankDescription,
  );
}

class ReportEngine {
  static BinaStore _getStore(BinaStore? store) => store ?? BinaStore.instance;
  static double _getHYapi(BinaStore? store) =>
      _getStore(store).bolum3?.hYapi ?? 0.0;
  static Map<String, dynamic> calculateRiskMetrics({BinaStore? store}) {
    final s = _getStore(store);
    int filledSections = 0;
    int criticalRisks = 0;
    int warnings = 0;
    int unknowns = 0;
    int totalActiveSections = 0;
    List<String> criticalTitles = [];

    for (int i = 1; i <= 36; i++) {
      bool isSkipped = false;
      if (i == 22 || i == 23) isSkipped = s.bolum7?.hasAsansor == false;
      if (i == 25)
        isSkipped =
            (s.bolum20?.donerMerdivenSayisi ?? 0) == 0 &&
            (s.bolum20?.sahanliksizMerdivenSayisi ?? 0) == 0;
      if (i == 30) isSkipped = s.bolum7?.hasKazan == false;
      if (i == 31) isSkipped = s.bolum7?.hasTrafo == false;
      if (i == 32) isSkipped = s.bolum7?.hasJenerator == false;
      if (i == 34) isSkipped = s.bolum6?.hasTicari == false;

      if (!isSkipped) {
        totalActiveSections++;
        final res = s.getResultForSection(i);
        if (res != null) {
          filledSections++;
          // İlk 10 bölüm sadece BİLGİ - skor hesaplamasını etkilemez
          if (i <= 10) continue;

          final Color color = getStatusColor(res, sectionId: i, store: s);
          if (color == const Color(0xFFE53935)) {
            criticalRisks++;
            criticalTitles.add("Bölüm $i");
          } else if (color == const Color(0xFFFFC107)) {
            // Sarı (UYARI)
            warnings++;
          } else if (color == Colors.grey.shade600) {
            // Gri (BİLMİYORUM)
            unknowns++;
          }
        }
      }
    }

    if (s.bolum20 != null && s.bolum20!.sahanliksizMerdivenSayisi > 0) {
      if (!criticalTitles.contains("Bölüm 20")) {
        criticalRisks++;
        criticalTitles.add("Bölüm 20");
      }
    }

    final yghReasons = evaluateYghRequirement(store: s);
    final bool hasYgh = s.bolum21?.varlik?.label.contains("21-1-A") ?? false;
    if (yghReasons.isNotEmpty && !hasYgh) {
      if (!criticalTitles.contains("Bölüm 21")) {
        criticalRisks++;
        criticalTitles.add("Bölüm 21");
      }
    }

    // Yeni Skorlama Formülü (Kullanıcı onaylı):
    // Başlangıç: 100 puan
    // Kritik Risk: -10 puan
    // Uyarı: -2 puan
    // Bilinmiyor: -1 puan
    // Olumlu/Bilgi: 0 puan
    double score =
        100.0 - (criticalRisks * 10.0) - (warnings * 2.0) - (unknowns * 1.0);

    return {
      'score': score.toInt().clamp(0, 100),
      'criticalCount': criticalRisks,
      'warningCount': warnings,
      'unknownCount': unknowns,
      'completion': (s.bolum36 != null)
          ? 100
          : (filledSections / totalActiveSections * 100).toInt().clamp(0, 100),
      'criticals': criticalTitles.take(3).toList(),
    };
  }

  static Color getStatusColor(
    ChoiceResult? result, {
    int? sectionId,
    BinaStore? store,
  }) {
    if (result == null) return Colors.grey.shade300;

    // Metin Analizi (getSectionFullReport sonucuna göre hiyerarşik kontrol)
    String reportText = result.reportText;
    if (sectionId != null) {
      reportText = getSectionFullReport(sectionId, store: store);
    }
    final text = reportText.toUpperCase();

    // 1. KRİTİK RİSK (KIRMIZI) - EN YÜKSEK ÖNCELİK
    if (text.contains("KRİTİK RİSK")) {
      return const Color(0xFFE53935);
    }

    // 2. UYARI (Sarı)
    if (text.contains("UYARI")) {
      return const Color(0xFFFFC107);
    }

    // 3. BİLMİYORUM (Gri)
    if (text.contains("BİLMİYORUM")) {
      return Colors.grey.shade600;
    }

    // 4. BİLGİ (Mavi)
    if (sectionId != null && (sectionId <= 10 || sectionId == 20)) {
      return const Color(0xFF1E88E5);
    }
    if (text.contains("BİLGİ")) {
      return const Color(0xFF1E88E5);
    }

    // 5. OLUMLU (Yeşil)
    if (text.contains("OLUMLU")) {
      return const Color(0xFF43A047);
    }

    // Varsayılan
    return const Color(0xFF43A047);
  }

  static String getSectionFullReport(int id, {BinaStore? store}) {
    final s = _getStore(store);
    final res = s.getResultForSection(id);
    if (res == null) return "Bu bölüm değerlendirme kapsamı dışındadır.";

    // Özel Mesaj Override'ları (Sadece gerektiğinde, yoksa AppContent'i kullanır)
    // Ancak bu override metinlerinin de AppContent standardına uyması (Emoji + Kelime + Mesaj) gerekir.

    // Bölüm 3: Kat Adetleri
    if (id == 3) {
      final b3 = s.bolum3;
      if (b3 != null) {
        List<String> parts = [];
        parts.add("Zemin Kat: 1 adet");
        if ((b3.normalKatSayisi ?? 0) > 0) {
          parts.add("Normal Kat: ${b3.normalKatSayisi} adet");
        }
        if ((b3.bodrumKatSayisi ?? 0) > 0) {
          parts.add("Bodrum Kat: ${b3.bodrumKatSayisi} adet");
        }
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 12 override
    if (id == 12 && res.label.contains("12-B (Çelik)")) {
      if ((s.bolum5?.toplamInsaatAlani ?? 0.0) < 5000) {
        return "OLUMLU: Çelik taşıyıcı elemanlar üzerinde pasif yangın yalıtımı bulunmamaktadır. (NOT: Bina toplam inşaat alanı 5000 m² altında olduğu için bu durum yönetmeliğe uygundur.)";
      }
    }

    // Bölüm 13: Yangın Kompartımanları, Kapı Dayanımları ve Duman Tahliye Sistemleri
    if (id == 13) {
      final b13 = s.bolum13;
      if (b13 != null) {
        List<String> parts = [];

        // Kapı Dayanımları
        if (b13.otoparkKapi != null)
          parts.add("Otopark Kapısı: ${b13.otoparkKapi!.reportText}");
        if (b13.kazanKapi != null)
          parts.add("Kazan Dairesi Kapısı: ${b13.kazanKapi!.reportText}");
        if (b13.asansorKapi != null)
          parts.add(
            "Asansör Makine Dairesi Kapısı: ${b13.asansorKapi!.reportText}",
          );
        if (b13.jeneratorKapi != null)
          parts.add("Jeneratör Odası Kapısı: ${b13.jeneratorKapi!.reportText}");
        if (b13.elektrikKapi != null)
          parts.add(
            "Elektrik/Pano Odası Kapısı: ${b13.elektrikKapi!.reportText}",
          );
        if (b13.trafoKapi != null)
          parts.add("Trafo Merkezi Kapısı: ${b13.trafoKapi!.reportText}");
        if (b13.depoKapi != null)
          parts.add("Depo Alanı Kapısı: ${b13.depoKapi!.reportText}");
        if (b13.copKapi != null)
          parts.add("Çöp Odası Kapısı: ${b13.copKapi!.reportText}");
        if (b13.ortakDuvar != null)
          parts.add(
            "Ortak Duvar Yangın Dayanımı: ${b13.ortakDuvar!.reportText}",
          );
        if (b13.ticariKapi != null)
          parts.add("Ticari Alan Kapısı: ${b13.ticariKapi!.reportText}");

        // Duman Tahliye Sistemleri
        if (b13.otoparkAlan != null)
          parts.add("Otopark Duman Tahliyesi: ${b13.otoparkAlan!.reportText}");
        if (b13.kazanAlan != null)
          parts.add(
            "Kazan Dairesi Duman Tahliyesi: ${b13.kazanAlan!.reportText}",
          );
        if (b13.siginakAlan != null)
          parts.add("Sığınak Duman Tahliyesi: ${b13.siginakAlan!.reportText}");

        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 15: İç Kaplamalar (Döşeme, Yalıtım, Tavan, Tesisat)
    if (id == 15) {
      final b15 = s.bolum15;
      if (b15 != null) {
        List<String> parts = [];
        if (b15.kaplama != null) parts.add(b15.kaplama!.reportText);
        if (b15.yalitim != null) parts.add(b15.yalitim!.reportText);
        if (b15.yalitimSap != null) parts.add(b15.yalitimSap!.reportText);
        if (b15.tavan != null) parts.add(b15.tavan!.reportText);
        if (b15.tavanMalzeme != null) parts.add(b15.tavanMalzeme!.reportText);
        if (b15.tesisat != null) parts.add(b15.tesisat!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 16: Dış Cephe (Mantolama, Sağır Yüzey, Bitişik Bina)
    if (id == 16) {
      final b16 = s.bolum16;
      if (b16 != null) {
        List<String> parts = [];
        if (b16.mantolama != null) parts.add(b16.mantolama!.reportText);

        // Bariyer Analizi (Mantolama 16-1-A ise)
        if (b16.mantolama?.label.contains("16-1-A") == true) {
          if (b16.bariyerYan == 0 ||
              b16.bariyerUst == 0 ||
              b16.bariyerZemin == 0) {
            parts.add(
              "KRİTİK RİSK: Binada yanıcı mantolama kullanılmasına rağmen pencere kenarlarında veya kat aralarında yangın bariyerleri bulunmamaktadır.",
            );
          } else if (b16.bariyerYan == 2 ||
              b16.bariyerUst == 2 ||
              b16.bariyerZemin == 2) {
            parts.add(
              "UYARI: Binada yanıcı mantolama mevcut olup yangın bariyerlerinin eksik veya standart dışı olduğu tespit edilmiştir.",
            );
          }
        }

        if (b16.sagirYuzey != null) parts.add(b16.sagirYuzey!.reportText);
        if (b16.bitisikNizam != null) parts.add(b16.bitisikNizam!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 17: Çatı (Kaplama, İskelet, Bitişik, Işıklık)
    if (id == 17) {
      final b17 = s.bolum17;
      if (b17 != null) {
        List<String> parts = [];
        if (b17.kaplama != null) parts.add(b17.kaplama!.reportText);
        if (b17.iskelet != null) parts.add(b17.iskelet!.reportText);
        if (b17.bitisikDuvar != null) parts.add(b17.bitisikDuvar!.reportText);
        if (b17.isiklik != null) parts.add(b17.isiklik!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 18: Koridor Kaplamaları ve Boru Tipi
    if (id == 18) {
      final b18 = s.bolum18;
      if (b18 != null) {
        List<String> parts = [];
        if (b18.duvarKaplama != null) parts.add(b18.duvarKaplama!.reportText);
        if (b18.boruTipi != null) parts.add(b18.boruTipi!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 19: Kaçış Yolları (Engel, Levha, Yanıltıcı Kapı)
    if (id == 19) {
      final b19 = s.bolum19;
      if (b19 != null) {
        List<String> parts = [];
        for (var e in b19.engeller) {
          parts.add(e.reportText);
        }
        if (b19.levha != null) parts.add(b19.levha!.reportText);
        if (b19.yanilticiKapi != null) parts.add(b19.yanilticiKapi!.reportText);
        if (b19.yanilticiEtiket != null)
          parts.add(b19.yanilticiEtiket!.reportText);

        final b20 = s.bolum20;
        int total =
            (b20?.normalMerdivenSayisi ?? 0) +
            (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
            (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
            (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) +
            (b20?.donerMerdivenSayisi ?? 0);
        if (total <= 1)
          parts.add(
            "OLUMLU: Binada tek çıkış tespit edildiği için yönlendirme levhası zorunluluğu bulunmamaktadır.",
          );

        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 20: Merdiven Adetleri ve Tipleri
    if (id == 20) {
      final b20 = s.bolum20;
      if (b20 != null) {
        List<String> parts = [];

        // Sadece değer girilen merdiven tiplerini göster
        if (b20.normalMerdivenSayisi > 0) {
          parts.add("BİLGİ: Normal Merdiven: ${b20.normalMerdivenSayisi} adet");
        }
        if (b20.binaIciYanginMerdiveniSayisi > 0) {
          parts.add(
            "BİLGİ: Bina İçi Yangın Merdiveni: ${b20.binaIciYanginMerdiveniSayisi} adet",
          );
        }
        if (b20.binaDisiKapaliYanginMerdiveniSayisi > 0) {
          parts.add(
            "BİLGİ: Bina Dışı Kapalı Yangın Merdiveni: ${b20.binaDisiKapaliYanginMerdiveniSayisi} adet",
          );
        }
        if (b20.binaDisiAcikYanginMerdiveniSayisi > 0) {
          parts.add(
            "BİLGİ: Bina Dışı Açık Yangın Merdiveni: ${b20.binaDisiAcikYanginMerdiveniSayisi} adet",
          );
        }
        if (b20.donerMerdivenSayisi > 0) {
          parts.add("UYARI: Döner Merdiven: ${b20.donerMerdivenSayisi} adet");
        }
        if (b20.sahanliksizMerdivenSayisi > 0) {
          parts.add(
            "KRİTİK RİSK: Sahanlıksız Merdiven: ${b20.sahanliksizMerdivenSayisi} adet - Binada kaçış yolu olarak kabul edilemeyecek merdiven tespit edilmiştir.",
          );
        }

        // Bodrum merdivenleri (bağımsız ise)
        if (b20.isBodrumIndependent) {
          if (b20.bodrumNormalMerdivenSayisi > 0) {
            parts.add(
              "BİLGİ: Bodrum Normal Merdiven: ${b20.bodrumNormalMerdivenSayisi} adet",
            );
          }
          if (b20.bodrumBinaIciYanginMerdiveniSayisi > 0) {
            parts.add(
              "BİLGİ: Bodrum Bina İçi Yangın Merdiveni: ${b20.bodrumBinaIciYanginMerdiveniSayisi} adet",
            );
          }
          if (b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi > 0) {
            parts.add(
              "BİLGİ: Bodrum Bina Dışı Kapalı Yangın Merdiveni: ${b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi} adet",
            );
          }
          if (b20.bodrumBinaDisiAcikYanginMerdiveniSayisi > 0) {
            parts.add(
              "BİLGİ: Bodrum Bina Dışı Açık Yangın Merdiveni: ${b20.bodrumBinaDisiAcikYanginMerdiveniSayisi} adet",
            );
          }
          if (b20.bodrumDonerMerdivenSayisi > 0) {
            parts.add(
              "UYARI: Bodrum Döner Merdiven: ${b20.bodrumDonerMerdivenSayisi} adet",
            );
          }
          if (b20.bodrumSahanliksizMerdivenSayisi > 0) {
            parts.add(
              "KRİTİK RİSK: Bodrum Sahanlıksız Merdiven: ${b20.bodrumSahanliksizMerdivenSayisi} adet",
            );
          }
        }

        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 21: YGH Zorunluluğu
    if (id == 21) {
      final b21 = s.bolum21;
      final yghReasons = evaluateYghRequirement(store: s);
      final bool hasYgh = b21?.varlik?.label.contains("21-1-A") ?? false;
      final bool noYgh = b21?.varlik?.label.contains("21-1-B") ?? false;

      if (yghReasons.isNotEmpty && !hasYgh) {
        return "KRİTİK RİSK: Binada aşağıdaki sebeplerden dolayı Yangın Güvenlik Holü (YGH) zorunluluğu bulunmaktadır:\n\n${yghReasons.join('\n')}\n\nBinada mevcut YGH bulunmadığı beyan edilmiştir.";
      }

      // YGH yok seçildiyse ve zorunluluk yoksa BİLGİ olarak göster
      if (noYgh && yghReasons.isEmpty) {
        return "BİLGİ: Binada Yangın Güvenlik Holü (YGH) bulunmamaktadır. Mevcut yapı koşullarında YGH zorunluluğu tespit edilmemiştir.";
      }
    }

    // Bölüm 26: Rampalar
    if (id == 26) {
      final b26 = s.bolum26;
      if (b26 != null) {
        List<String> parts = [];
        if (b26.varlik != null) parts.add(b26.varlik!.reportText);
        if (b26.egim != null) parts.add(b26.egim!.reportText);
        if (b26.sahanlik != null) parts.add(b26.sahanlik!.reportText);
        if (b26.otopark != null) parts.add(b26.otopark!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 27: Kapı yönü ve kilit mekanizması için S33 kullanıcı yükü kontrolü
    if (id == 27) {
      final b27 = s.bolum27;
      final b33 = s.bolum33;

      if (b27 != null && b33 != null) {
        List<String> reportParts = [];

        // Get all user loads
        final yukZemin = b33.yukZemin ?? 0;
        final yukNormal = b33.yukNormal ?? 0;
        final yukBodrum = b33.yukBodrum ?? 0;
        final maxYuk = [
          yukZemin,
          yukNormal,
          yukBodrum,
        ].reduce((a, b) => a > b ? a : b);

        // Add base report text from selected options
        if (b27.yon != null) {
          reportParts.add(b27.yon!.reportText);
        }
        if (b27.kilit != null) {
          reportParts.add(b27.kilit!.reportText);
        }
        if (b27.dayanim != null) {
          reportParts.add(b27.dayanim!.reportText);
        }

        // Door direction check (27-2-B or 27-2-D) + user load > 50
        final yonLabel = b27.yon?.label ?? "";
        if ((yonLabel.contains("27-2-B") || yonLabel.contains("27-2-D")) &&
            maxYuk > 50) {
          reportParts.add(
            "UYARI: Kullanıcı yükü 50 kişiyi geçen mahallerde ve katlarda kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır. Mevcut kullanıcı yükü: $maxYuk kişi.",
          );
        }

        // Lock mechanism check (27-3-B or 27-3-D) + user load > 100
        final kilitLabel = b27.kilit?.label ?? "";
        if ((kilitLabel.contains("27-3-B") || kilitLabel.contains("27-3-D")) &&
            maxYuk > 100) {
          reportParts.add(
            "UYARI: Kullanıcı yükü 100 kişiyi aşan binalarda tüm kapıların panik bar ile donatılması şarttır. Normal kapı kolu kabul edilemez. Mevcut kullanıcı yükü: $maxYuk kişi.",
          );
        }

        if (reportParts.isNotEmpty) {
          return reportParts.join("\n\n");
        }
      }
    }

    // Bölüm 29: Ortak Hatalar (Depolama vb.)
    if (id == 29) {
      final b29 = s.bolum29;
      if (b29 != null) {
        List<String> parts = [];
        if (b29.otopark != null) parts.add(b29.otopark!.reportText);
        if (b29.kazan != null) parts.add(b29.kazan!.reportText);
        if (b29.cati != null) parts.add(b29.cati!.reportText);
        if (b29.asansor != null) parts.add(b29.asansor!.reportText);
        if (b29.jenerator != null) parts.add(b29.jenerator!.reportText);
        if (b29.pano != null) parts.add(b29.pano!.reportText);
        if (b29.trafo != null) parts.add(b29.trafo!.reportText);
        if (b29.depo != null) parts.add(b29.depo!.reportText);
        if (b29.cop != null) parts.add(b29.cop!.reportText);
        if (b29.siginak != null) parts.add(b29.siginak!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 30: Kazan Dairesi (Konum, Kapı, Yakıt, Havalandırma)
    if (id == 30) {
      final b30 = s.bolum30;
      if (b30 != null) {
        List<String> parts = [];
        if (b30.konum != null) parts.add(b30.konum!.reportText);
        if (b30.kapi != null) parts.add(b30.kapi!.reportText);
        if (b30.yakit != null) parts.add(b30.yakit!.reportText);
        if (b30.hava != null) parts.add(b30.hava!.reportText);
        if (b30.drenaj != null) parts.add(b30.drenaj!.reportText);
        if (b30.tup != null) parts.add(b30.tup!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 31: Trafo Odası (Yapı, Tip, Çukur, Söndürme)
    if (id == 31) {
      final b31 = s.bolum31;
      if (b31 != null) {
        List<String> parts = [];
        if (b31.yapi != null) parts.add(b31.yapi!.reportText);
        if (b31.tip != null) parts.add(b31.tip!.reportText);
        if (b31.cukur != null) parts.add(b31.cukur!.reportText);
        if (b31.sondurme != null) parts.add(b31.sondurme!.reportText);
        if (b31.cevre != null) parts.add(b31.cevre!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 32: Jeneratör (Yapı, Yakıt, Çevre, Egzoz)
    if (id == 32) {
      final b32 = s.bolum32;
      if (b32 != null) {
        List<String> parts = [];
        if (b32.yapi != null) parts.add(b32.yapi!.reportText);
        if (b32.yakit != null) parts.add(b32.yakit!.reportText);
        if (b32.cevre != null) parts.add(b32.cevre!.reportText);
        if (b32.egzoz != null) parts.add(b32.egzoz!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 33: Yetersiz Çıkış
    if (id == 33) {
      if (s.bolum33 != null) {
        return s.bolum33!.combinedReportText;
      }
    }

    // Bölüm 34: Karşı Üst Kat ve Bodrum Karakteristiği
    if (id == 34) {
      final b34 = s.bolum34;
      if (b34 != null) {
        List<String> parts = [];
        if (b34.zemin != null) parts.add(b34.zemin!.reportText);
        if (b34.bodrum != null) parts.add(b34.bodrum!.reportText);
        if (b34.normal != null) parts.add(b34.normal!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 35: Çıkış Koridoru Genişliği
    if (id == 35) {
      final b35 = s.bolum35;
      if (b35 != null) {
        List<String> parts = [];
        if (b35.tekYon != null) parts.add(b35.tekYon!.reportText);
        if (b35.ciftYon != null) parts.add(b35.ciftYon!.reportText);
        if (b35.cikmaz != null) parts.add(b35.cikmaz!.reportText);
        if (b35.cikmazMesafe != null) parts.add(b35.cikmazMesafe!.reportText);
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 36: Merdiven Değerlendirmesi
    if (id == 36) {
      if (s.bolum36?.merdivenDegerlendirme != null &&
          s.bolum36!.merdivenDegerlendirme!.isNotEmpty) {
        return s.bolum36!.merdivenDegerlendirme!;
      }
    }

    // Varsayılan: AppContent içindeki metni olduğu gibi döndür.
    // Hiçbir değiştirme, silme, ekleme yok.
    return res.reportText;
  }

  static List<Map<String, String>> getActionPlan() {
    List<Map<String, String>> plan = [];
    for (int i = 1; i <= 36; i++) {
      final res = BinaStore.instance.getResultForSection(i);
      if (res != null && res.adviceText != null && res.adviceText!.isNotEmpty) {
        plan.add({
          'id': i.toString(),
          'title': res.uiTitle,
          'advice': res.adviceText!,
        });
      }
    }
    return plan;
  }

  static Map<ReportModule, double> calculateModuleScores() {
    Map<ReportModule, double> scores = {};
    for (var module in ReportModule.values) {
      int total = 0;
      int criticals = 0;
      for (int id in module.sectionIds) {
        final res = BinaStore.instance.getResultForSection(id);
        if (res != null) {
          total++;
          if (getStatusColor(res, sectionId: id) == const Color(0xFFE53935))
            criticals++;
        }
      }
      scores[module] = total == 0 ? 0 : ((total - criticals) / total) * 100.0;
    }
    return scores;
  }

  static List<String> evaluateYghRequirement({BinaStore? store}) {
    final s = _getStore(store);
    List<String> reasons = [];
    final hYapi = _getHYapi(s);

    // 1. Yapı Yüksekliği >= 51.50m
    if (hYapi >= 51.50) {
      reasons.add("KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50 metre");
    }

    // 2. Yapı Yüksekliği > 30.50m ve basınçlandırma yoksa
    if (hYapi > 30.50) {
      final b20 = s.bolum20;
      if (b20 != null && b20.basinclandirma?.label.contains("-B") == true) {
        // 20-BAS-B: Hayır
        reasons.add(
          "KRİTİK RİSK: Yapı Yüksekliği 30.50m üzeri ve en az bir merdivende Basınçlandırma yok ise YGH zorunludur.",
        );
      }
    }

    // 3. Bodrum katlarda ticari/teknik kullanım (Bölüm 10)
    final b10 = s.bolum10;
    if (b10 != null &&
        b10.bodrumlar.any((c) => c?.label.contains("10-C") == true)) {
      reasons.add(
        "KRİTİK RİSK: Bodrum katlarda, konuttan farklı fonksiyon mevcut olduğundan(10-C)",
      );
    }

    // 4. İtfaiye Asansörü zorunluluğu (Bölüm 22)
    final b22 = s.bolum22;
    if (b22 != null && b22.varlik?.label.contains("22-1-B") == true) {
      reasons.add(
        "KRİTİK RİSK: İtfaiye Asansörü zorunluluğu mevcut olduğundan (22-1-B)",
      );
    }

    // 5. Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı (Bölüm 23)
    final b23 = s.bolum23;
    if (b23 != null && b23.bodrum?.label.contains("23-1-C") == true) {
      reasons.add(
        "KRİTİK RİSK: Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı sağlanmadığından (23-1-C)",
      );
    }

    // 6. Bodrum kat sayısı > 4
    if ((s.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      reasons.add(
        "KRİTİK RİSK: Bodrum kat sayısı > 4 olduğu için bodrum katlardaki merdiven önlerinde YGH zorunludur.",
      );
    }

    return reasons;
  }

  static String getSectionSummary(int id) {
    final res = BinaStore.instance.getResultForSection(id);
    if (res == null) return "Değerlendirilmedi";
    return res.label;
  }
}
