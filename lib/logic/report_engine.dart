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
  static double _getHBina(BinaStore? store) =>
      _getStore(store).bolum3?.hBina ?? 0.0;

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
            // Gri (BİLİNMİYOR)
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
    final s = _getStore(store);

    // İlk 10 bölüm HER ZAMAN BİLGİ (Mavi) döndürür - skor etkilemez
    if (sectionId != null && sectionId <= 10) {
      return const Color(0xFF1E88E5); // Mavi
    }

    // Özel Override Durumları (Bölüm 12, 16, 25, 36 vb.)
    Color? overrideColor;

    // Bölüm 12: Çelik
    if (sectionId == 12 && result.label.contains("12-B (Çelik)")) {
      bool isSafe = (s.bolum5?.toplamInsaatAlani ?? 0.0) < 5000;
      overrideColor = isSafe
          ? const Color(0xFF43A047)
          : const Color(0xFFE53935);
    }
    // Bölüm 16: Mantolama
    else if (sectionId == 16 && result.label.contains("16-1-A")) {
      final hBina = _getHBina(s);
      if (hBina > 28.50) {
        overrideColor = const Color(0xFFE53935);
      } else {
        final m = s.bolum16;
        if (m != null) {
          if (m.bariyerYan == 0 || m.bariyerUst == 0 || m.bariyerZemin == 0)
            overrideColor = const Color(0xFFE53935);
          else if (m.bariyerYan == 2 ||
              m.bariyerUst == 2 ||
              m.bariyerZemin == 2)
            overrideColor = Colors.orange.shade600;
          else
            overrideColor = const Color(0xFF43A047);
        }
      }
    }
    // Bölüm 19: Kaçış Yolu Levhası
    else if (sectionId == 19) {
      final b20 = s.bolum20;
      int total =
          (b20?.normalMerdivenSayisi ?? 0) +
          (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
          (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
          (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) +
          (b20?.donerMerdivenSayisi ?? 0);
      if (total <= 1) overrideColor = const Color(0xFF43A047);
    }
    // Bölüm 33: Yetersiz Çıkış
    else if (sectionId == 33) {
      if (result.label.contains("YETERSIZ") || result.label.contains("FAIL"))
        overrideColor = const Color(0xFFE53935);
    }
    // Bölüm 36: Merdiven Yeterlilik Analizi - Herhangi bir uygunsuzluk = KRİTİK RİSK
    else if (sectionId == 36) {
      final b36 = s.bolum36;
      if (b36 != null && b36.merdivenDegerlendirme != null) {
        final eval = b36.merdivenDegerlendirme!.toUpperCase();
        // Eğer değerlendirmede herhangi bir uygunsuzluk varsa KRİTİK RİSK
        if (eval.contains("UYGUNSUZ") ||
            eval.contains("YETERSIZ") ||
            eval.contains("YOK") ||
            eval.contains("KULLANILA") == false) {
          // "KULLANILAMAZ" içeriyorsa
          overrideColor = const Color(0xFFE53935); // Kırmızı - KRİTİK RİSK
        } else if (!eval.contains("UYGUNSUZ") && !eval.contains("YETERSIZ")) {
          // Tüm kontroller geçti
          overrideColor = const Color(0xFF43A047); // Yeşil - OLUMLU
        }
      }
      // Ayrıca reportText'te RİSK, UYGUNSUZ veya YETERSIZ geçiyorsa KRİTİK
      final text36 = result.reportText.toUpperCase();
      if (text36.contains("UYGUNSUZ") ||
          text36.contains("YETERSIZ") ||
          text36.contains("DAİRESEL MERDİVEN")) {
        overrideColor = const Color(0xFFE53935);
      }
    }

    if (overrideColor != null) return overrideColor;

    // 2. Metin Analizi (AppContent.dart içindeki anahtar kelimelere göre)
    final text = result.reportText.toUpperCase();

    if (text.contains("RİSK") ||
        text.contains("ACİL") ||
        text.contains("TEHLİKE") ||
        text.contains("🚨") ||
        text.contains("☢️")) {
      return const Color(0xFFE53935); // Kırmızı
    }

    if (text.contains("UYARI") ||
        text.contains("DİKKAT") ||
        text.contains("⚠️") ||
        text.contains("UYARMA")) {
      return const Color(0xFFFFC107); // Sarı (UYARI)
    }

    if (text.contains("BİLİNMİYOR") ||
        text.contains("BELİRSİZ") ||
        text.contains("EMİN DEĞİLİM") ||
        text.contains("❓") ||
        text.contains("?")) {
      return Colors.grey.shade600; // Gri (Daha koyu gri okunaklılık için)
    }

    // Bilgi (Mavi) mi Olumlu (Yeşil) mi ayrımı
    // Genellikle "BİLGİ" kelimesi geçiyorsa mavidir, ama "OLUMLU" veya "UYGUN" ise yeşildir.
    if (text.contains("OLUMLU") ||
        text.contains("UYGUN") ||
        text.contains("YETERLİ") ||
        text.contains("✅")) {
      return const Color(0xFF43A047); // Yeşil
    }

    if (text.contains("BİLGİ") || text.contains("ℹ️")) {
      // Eğer yukarıdaki riskleri içermiyorsa ve sadece bilgi ise mavidir.
      return const Color(0xFF1E88E5);
    }

    // Varsayılan (Eğer hiçbir şey yoksa nötr/olumlu kabul edelim veya gri)
    return const Color(0xFF43A047);
  }

  static String getSectionFullReport(int id) {
    final s = BinaStore.instance;
    final res = s.getResultForSection(id);
    if (res == null) return "Bu bölüm değerlendirme kapsamı dışındadır.";

    // Özel Mesaj Override'ları (Sadece gerektiğinde, yoksa AppContent'i kullanır)
    // Ancak bu override metinlerinin de AppContent standardına uyması (Emoji + Kelime + Mesaj) gerekir.

    // Bölüm 12 override
    if (id == 12 && res.label.contains("12-B (Çelik)")) {
      if ((s.bolum5?.toplamInsaatAlani ?? 0.0) < 5000) {
        return "✅ OLUMLU: Çelik taşıyıcı elemanlar üzerinde pasif yangın yalıtımı bulunmamaktadır. (NOT: Bina toplam inşaat alanı 5000 m² altında olduğu için bu durum yönetmeliğe uygundur.)";
      }
    }

    // Bölüm 16 override
    if (id == 16 && res.label.contains("16-1-A")) {
      final hBina = s.bolum3?.hBina ?? 0.0;
      if (hBina > 28.50)
        return "🚨 KRİTİK RİSK: 28.50 metreden yüksek binalarda yanıcı (EPS/XPS) mantolama kullanımı yönetmelik gereği yasaktır.";

      final m = s.bolum16;
      if (m != null) {
        if (m.bariyerYan == 0 || m.bariyerUst == 0 || m.bariyerZemin == 0)
          return "🚨 KRİTİK RİSK: Binada yanıcı mantolama kullanılmasına rağmen yangın bariyerleri bulunmamaktadır.";
        if (m.bariyerYan == 2 || m.bariyerUst == 2 || m.bariyerZemin == 2)
          return "⚠️ UYARI: Binada yanıcı mantolama mevcut olabilir ancak gerekli yangın bariyerlerinin binada tam olarak uygulanmadığı tespit edilmiştir.";
        if (m.bariyerYan == 1 && m.bariyerUst == 1 && m.bariyerZemin == 1)
          return "✅ OLUMLU: Binada (kuvvetle muhtemel) yanıcı mantolama mevcut olsa da, gerekli yangın bariyerlerinin uygulandığı beyan edilmiştir.";
      }
    }

    // Bölüm 19 override
    if (id == 19) {
      final b20 = s.bolum20;
      int total =
          (b20?.normalMerdivenSayisi ?? 0) +
          (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
          (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
          (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) +
          (b20?.donerMerdivenSayisi ?? 0);
      if (total <= 1)
        return "✅ OLUMLU: Binada tek çıkış tespit edildiği için yönlendirme levhası zorunluluğu bulunmamaktadır.";
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
            "⚠️ UYARI: Kullanıcı yükü 50 kişiyi geçen mahallerde ve katlarda kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır. Mevcut kullanıcı yükü: $maxYuk kişi.",
          );
        }

        // Lock mechanism check (27-3-B or 27-3-D) + user load > 100
        final kilitLabel = b27.kilit?.label ?? "";
        if ((kilitLabel.contains("27-3-B") || kilitLabel.contains("27-3-D")) &&
            maxYuk > 100) {
          reportParts.add(
            "⚠️ UYARI: Kullanıcı yükü 100 kişiyi aşan binalarda tüm kapıların panik bar ile donatılması şarttır. Normal kapı kolu kabul edilemez. Mevcut kullanıcı yükü: $maxYuk kişi.",
          );
        }

        if (reportParts.isNotEmpty) {
          return reportParts.join("\n\n");
        }
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
      reasons.add("🚨 Yapı Yüksekliği ≥ 51.50 metre");
    }

    // 2. Yapı Yüksekliği > 30.50m ve basınçlandırma yoksa
    if (hYapi > 30.50) {
      final b20 = s.bolum20;
      if (b20 != null && b20.basinclandirma?.label.contains("-B") == true) {
        // 20-BAS-B: Hayır
        reasons.add(
          "🚨 Yapı Yüksekliği 30.50m üzeri ve en az bir merdivende Basınçlandırma yok ise YGH zorunludur.",
        );
      }
    }

    // 3. Bodrum katlarda ticari/teknik kullanım (Bölüm 10)
    final b10 = s.bolum10;
    if (b10 != null &&
        b10.bodrumlar.any((c) => c?.label.contains("10-C") == true)) {
      reasons.add(
        "🚨 Bodrum katlarda, konuttan farklı fonksiyon mevcut olduğundan(10-C)",
      );
    }

    // 4. İtfaiye Asansörü zorunluluğu (Bölüm 22)
    final b22 = s.bolum22;
    if (b22 != null && b22.varlik?.label.contains("22-1-B") == true) {
      reasons.add("🚨 İtfaiye Asansörü zorunluluğu mevcut olduğundan (22-1-B)");
    }

    // 5. Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı (Bölüm 23)
    final b23 = s.bolum23;
    if (b23 != null && b23.bodrum?.label.contains("23-1-C") == true) {
      reasons.add(
        "🚨 Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı sağlanmadığından (23-1-C)",
      );
    }

    // 6. Bodrum kat sayısı > 4
    if ((s.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      reasons.add(
        "🚨 Bodrum kat sayısı > 4 olduğu için bodrum katlardaki merdiven önlerinde YGH zorunludur.",
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
