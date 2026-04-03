import 'package:flutter/foundation.dart';
import 'package:life_safety/data/bina_store.dart';
import '../../models/choice_result.dart';
import '../../models/bolum_20_model.dart';
import '../../models/report_status.dart';
import '../../utils/app_content.dart';
import '../report_engine.dart';

class Section36Handler {
  final BinaStore _store;

  static const Map<String, List<int>> _widthRanges = {
    "36-Merd-A": [0, 119],
    "36-Merd-B": [120, 150],
    "36-Merd-C": [151, 200],
    "36-Merd-D": [201, 500],
    "36-Koridor-A": [0, 99],
    "36-Koridor-B": [100, 120],
    "36-Koridor-C": [121, 150],
    "36-Koridor-D": [151, 200],
    "36-Koridor-E": [201, 500],
  };

  static List<int>? _getRangeForLabel(String label) {
    return _widthRanges[label];
  }

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

      final b33 = _store.bolum33;
      final b34 = _store.bolum34;
      final int maxYuk = ReportEngine.calculateMaxYuk(_store);

      if (b20.dengelenmisMerdivenSayisi > 0) {
        if (hBina > (15.50 - 0.001) || maxYuk > 100) {
          analysisParts.add(
            "KRİTİK RİSK: Binadaki Dengelenmiş Merdiven, bina yüksekliği ($hBina m) veya kullanıcı yükü ($maxYuk kişi) sınırı aşıldığı için Yönetmeliğe göre kaçış yolu olarak kullanılamaz.",
          );
        } else {
          analysisParts.add(
            "OLUMLU: Dengelenmiş Merdiven, bina yüksekliği ve kullanıcı yükü sınırları aşılmadığı için Yönetmeliğe göre kaçış yolu olarak kullanılabilir.",
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
              "KRİTİK RİSK: Bodrum katlardaki Dengelenmiş Merdiven, sınırları aştığı için Yönetmeliğe göre uygun DEĞİLDİR.",
            );
          } else {
            analysisParts.add(
              "OLUMLU: Bodrum katlardaki Dengelenmiş Merdiven kaçış yolu olarak kullanılabilir.",
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
          "KRİTİK RİSK: Hem normal katlara hem de bodrum katlara hitap eden kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması kuralı İHLAL EDİLMİŞTİR. (Normal: $directMain/$reqDirectMain, Bodrum: $directBod/$reqDirectBod sağlanıyor.)",
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
          "OLUMLU: Merdivenlerin en az %50'sinin doğrudan dışarıya açılması kuralı tüm katlarda sağlanmaktadır.",
        );
      }

      // 3. Madde 41/2: Çıkış Katı Tahliye Mesafesi (BİRLEŞTİRİLMİŞ MANTIK)
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
          "UYARI: BİLİNMİYOR - Çıkış katı tahliye mesafesi beyan edilmediği için %50 kriterine göre değerlendirme yapılamamıştır.",
        );
      } else if ((totalMain > 0 &&
              b20.lobiTahliyeMesafeDurumu?.label == "41-MESAFE-A") ||
          (totalBod > 0 &&
              b20.bodrumLobiTahliyeMesafeDurumu?.label == "41-MESAFE-A")) {
        analysisParts.add(
          "OLUMLU: Çıkış katı tahliye mesafeleri yönetmelik limitleri ($limit m) içerisindedir.",
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

      // 5. Dairesel Merdiven (Madde 25) Analizi
      if (b20.donerMerdivenSayisi > 0 || b20.bodrumDonerMerdivenSayisi > 0) {
        final b25 = _store.bolum25;
        // b34 ve b33 yukarıda tanımlandı
        final zLabel = b34?.zemin?.label;
        bool zeminIndependent = zLabel != null && zLabel.contains("34-1-A");
        int loadForSpiral = zeminIndependent ? (b33?.yukNormal ?? 0) : maxYuk;

        if (b25 != null) {
          bool heightOk = b25.yukseklik?.label == "25-Dairesel-A";
          bool loadOk = loadForSpiral <= 25;
          bool isUnknown = b25.yukseklik?.label == "25-Dairesel-C";

          if (isUnknown) {
            analysisParts.add(
              "UYARI: BİLİNMİYOR - Dairesel merdiven yüksekliği beyan edilmediği için Yönetmelik (Madde 25) uygunluğu değerlendirilememiştir.",
            );
          } else if (heightOk && loadOk) {
            analysisParts.add(
              "OLUMLU: Dairesel merdiven, yükseklik (${b25.yukseklik?.uiTitle}) ve kullanıcı yükü ($loadForSpiral kişi) sınırları içerisinde olduğu için kaçış yolu olarak kabul edilebilir.",
            );
          } else {
            List<String> reasons = [];
            if (!heightOk) reasons.add("9.50m limitini aşmaktadır");
            if (!loadOk) reasons.add("kullanıcı yükü 25 kişiyi aşmaktadır ($loadForSpiral)");
            analysisParts.add(
              "KRİTİK RİSK: Dairesel merdiven ${reasons.join(" VE ")} sebebiyle Yönetmelik Madde 25 kriterlerini sağlamadığı için kaçış yolu olarak kullanılamaz.",
            );
          }
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

        bool globalHasSpiral =
            (b20.donerMerdivenSayisi > 0 || b20.bodrumDonerMerdivenSayisi > 0);

        if (b36.areWidthsSame) {
          _checkWidth(
            "GENEL",
            b36.genislikKorunumlu,
            b36.koridorGenislikKorunumlu,
            b36.kapiGenislikKorunumlu,
            minMerd: minMerd,
            minKori: minKori,
            analysisParts: analysisParts,
            isSpiralPossible: globalHasSpiral,
          );
        } else {
          if (currentProtected > 0) {
            _checkWidth(
              "KORUNUMLU",
              b36.genislikKorunumlu,
              b36.koridorGenislikKorunumlu,
              b36.kapiGenislikKorunumlu,
              minMerd: minMerd,
              minKori: minKori,
              analysisParts: analysisParts,
              isSpiralPossible: globalHasSpiral,
            );
          }
          int korunumsuzCount =
              b20.normalMerdivenSayisi +
              b20.binaDisiAcikYanginMerdiveniSayisi +
              b20.donerMerdivenSayisi +
              b20.dengelenmisMerdivenSayisi;
          if (korunumsuzCount > 0) {
            _checkWidth(
              "KORUNUMSUZ",
              b36.genislikKorunumsuz,
              b36.koridorGenislikKorunumsuz,
              b36.kapiGenislikKorunumsuz,
              minMerd: minMerd,
              minKori: minKori,
              analysisParts: analysisParts,
              isSpiralPossible: globalHasSpiral,
            );
          }
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
    return "OLUMLU: Merdivenler ve tahliye güzergahları Yönetmelik kriterlerine göre yeterlidir.";
  }

  String getSummaryReport() {
    final parts = _buildAnalysisParts();
    List<String> summaryBullets = [];

    // Sadece KRİTİK RİSK ve UYARI mesajlarını özet ekrana taşıyalım (daha sade).
    for (String part in parts) {
      if (part.startsWith("KRİTİK RİSK:") || part.startsWith("UYARI:")) {
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
    return "Tüm kaçış merdivenleri Yönetmelik kriterlerine (Korunumlu Merdiven adetleri, kapı yönleri ve %50 tahliye kuralları) göre yeterlidir.";
  }

  void _addDetail(
    List<Map<String, dynamic>> details, {
    required String label,
    required String value,
    required String report,
    String? subtitle,
    String? advice,
    RiskLevel? level,
    ReportStatus? status,
    bool isBold = false,
  }) {
    details.add({
      'label': label,
      'value': value,
      'subtitle': subtitle ?? '',
      'report': report,
      'advice': advice ?? '',
      'status':
          status ??
          (level != null
              ? ReportStatus.fromRiskLevel(level)
              : ReportStatus.info),
      'isBold': isBold,
    });
  }

  void _addStaircaseRows(
    List<Map<String, dynamic>> details,
    Bolum20Model b, {
    bool isBasement = false,
  }) {
    final prefix = isBasement ? "Bodrum Kat " : "";

    void add(String label, int count) {
      if (count >= 0) {
        _addDetail(
          details,
          label: '$prefix$label (Adet)',
          value: '$count adet',
          report: '',
          status: ReportStatus.info, // Counting is info
          isBold: count > 0,
        );
      }
    }

    if (!isBasement) {
      add("Normal Merdiven", b.normalMerdivenSayisi);
      add(
        "Bina İçi Korunumlu (Yangın) Merdiven",
        b.binaIciYanginMerdiveniSayisi,
      );
      add(
        "Bina Dışı Kapalı (Yangın) Merdiven",
        b.binaDisiKapaliYanginMerdiveniSayisi,
      );
      add(
        "Bina Dışı Açık (Yangın) Merdiven",
        b.binaDisiAcikYanginMerdiveniSayisi,
      );
      add("Döner (Spiral) Merdiven", b.donerMerdivenSayisi);
      add("Sahanlıksız (Düz) Merdiven", b.sahanliksizMerdivenSayisi);
      add("Dengelenmiş Merdiven", b.dengelenmisMerdivenSayisi);
      add(
        "Doğrudan Dışarı Açılan Merdiven",
        b.toplamDisariAcilanMerdivenSayisi,
      );
    } else {
      add("Bodrum Normal Merdiven", b.bodrumNormalMerdivenSayisi);
      add(
        "Bodrum Bina İçi Yangın Merdiveni",
        b.bodrumBinaIciYanginMerdiveniSayisi,
      );
      add(
        "Bodrum Bina Dışı Kapalı Yangın Merdiveni",
        b.bodrumBinaDisiKapaliYanginMerdiveniSayisi,
      );
      add(
        "Bodrum Bina Dışı Açık Yangın Merdiveni",
        b.bodrumBinaDisiAcikYanginMerdiveniSayisi,
      );
      add("Bodrum Dairesel Merdiven", b.bodrumDonerMerdivenSayisi);
      add("Bodrum Sahanlıksız Merdiven", b.bodrumSahanliksizMerdivenSayisi);
      add("Bodrum Dengelenmiş Merdiven", b.bodrumDengelenmisMerdivenSayisi);
      add(
        "Bodrum Doğrudan Dışarı Açılan Merdiven",
        b.bodrumToplamDisariAcilanMerdivenSayisi,
      );
    }
  }

  List<Map<String, dynamic>> getDetailedReport() {
    List<Map<String, dynamic>> details = [];
    final b36 = _store.bolum36;
    if (b36 != null) {
      // 1. Merdiven Tipleri (Tablo için)
      final b20 = _store.bolum20;
      if (b20 != null) {
        _addStaircaseRows(details, b20);
        if (b20.isBodrumIndependent) {
          _addStaircaseRows(details, b20, isBasement: true);
        }
      }

      // 2. Kapsamlı Uygunluk Değerlendirmesi
      String fullEval = getFullReport();
      _addDetail(
        details,
        label: '',
        value: '',
        report: fullEval,
        status: fullEval.contains("KRİTİK RİSK")
            ? ReportStatus.risk
            : (fullEval.contains("UYARI")
                  ? ReportStatus.warning
                  : ReportStatus.compliant),
      );

      // 2. Özel Durumlar ve Beyanlar
      if (b36.cikisKati != null)
        _addDetail(
          details,
          label: Bolum36Content.questionCikisKati,
          value: b36.cikisKati!.uiTitle,
          subtitle: b36.cikisKati!.uiSubtitle,
          report: b36.cikisKati!.reportText,
          advice: b36.cikisKati!.adviceText,
          level: b36.cikisKati!.level,
        );
      if (b36.disMerd != null)
        _addDetail(
          details,
          label: Bolum36Content.questionDisMerd,
          value: b36.disMerd!.uiTitle,
          subtitle: b36.disMerd!.uiSubtitle,
          report: b36.disMerd!.reportText,
          advice: b36.disMerd!.adviceText,
          level: b36.disMerd!.level,
        );
      if (b36.konum != null)
        _addDetail(
          details,
          label: Bolum36Content.questionKonum,
          value: b36.konum!.uiTitle,
          subtitle: b36.konum!.uiSubtitle,
          report: b36.konum!.reportText,
          advice: b36.konum!.adviceText,
          level: b36.konum!.level,
        );
      if (b36.kapiTipi != null)
        _addDetail(
          details,
          label: Bolum36Content.questionKapiTipi,
          value: b36.kapiTipi!.uiTitle,
          subtitle: b36.kapiTipi!.uiSubtitle,
          report: b36.kapiTipi!.reportText,
          advice: b36.kapiTipi!.adviceText,
          level: b36.kapiTipi!.level,
        );

      final b4 = _store.bolum4;
      final b3 = _store.bolum3;
      final double hBina = b4?.hesaplananBinaYuksekligi ?? b3?.hBina ?? 0.0;
      final double hYapi = b4?.hesaplananYapiYuksekligi ?? b3?.hYapi ?? 0.0;
      final bool isYuksekBina = (hBina >= 21.50 || hYapi >= 30.50);
      final int effectiveLoad = ReportEngine.calculateMaxYuk(_store);

      int reqMerdiven = 120;
      int reqKoridor = 110;
      String reqReason = "Genel en alt limit";

      if (effectiveLoad >= 2001) {
        reqMerdiven = 200;
        reqKoridor = 200;
        reqReason = "Kullanıcı yükü > 2000 ($effectiveLoad kişi)";
      } else if (effectiveLoad >= 501) {
        reqMerdiven = 150;
        reqKoridor = 150;
        reqReason = "Kullanıcı yükü > 500 ($effectiveLoad kişi)";
      } else if (isYuksekBina) {
        reqMerdiven = 120;
        reqKoridor = 120;
        reqReason = "Yüksek Bina Kriteri";
      }

      List<int>? getMerdRange(ChoiceResult? c) {
        if (c == null) return null;
        if (c.label == "36-Merd-A") return [0, 119];
        if (c.label == "36-Merd-B") return [120, 150];
        if (c.label == "36-Merd-C") return [151, 200];
        if (c.label == "36-Merd-D") return [201, 9999];
        return null;
      }

      List<int>? getKoriRange(ChoiceResult? c) {
        if (c == null) return null;
        if (c.label == "36-Koridor-A") return [0, 99];
        if (c.label == "36-Koridor-B") return [100, 120];
        if (c.label == "36-Koridor-C") return [121, 150];
        if (c.label == "36-Koridor-D") return [151, 200];
        if (c.label == "36-Koridor-E") return [201, 9999];
        return null;
      }

      void evaluateWidth(
        String label,
        ChoiceResult? choice,
        int requiredVal,
        bool isMerdiven,
      ) {
        if (choice == null) return;
        var range = isMerdiven ? getMerdRange(choice) : getKoriRange(choice);
        if (range == null) {
          _addDetail(
            details,
            label: label,
            value: choice.uiTitle,
            subtitle: choice.uiSubtitle,
            report:
                "UYARI: BİLİNMİYOR - Genişlik beyan edilmediği için yeterlilik değerlendirmesi yapılamamıştır.",
            status: ReportStatus.warning,
          );
          return;
        }
        int wMax = range[1];

        if (wMax < requiredVal) {
          _addDetail(
            details,
            label: label,
            value: choice.uiTitle,
            subtitle: choice.uiSubtitle,
            report: "KRİTİK RİSK: Gereken: En az $requiredVal cm ($reqReason).",
            status: ReportStatus.risk,
          );
        } else {
          _addDetail(
            details,
            label: label,
            value: choice.uiTitle,
            subtitle: choice.uiSubtitle,
            report: "OLUMLU: En alt limit olan $requiredVal cm sağlanmaktadır.",
            status: ReportStatus.compliant,
          );
        }
      }

      if (b36.areWidthsSame) {
        evaluateWidth(
          'Merdiven Genişliği (Genel)',
          b36.genislikKorunumlu,
          reqMerdiven,
          true,
        );
        evaluateWidth(
          'Kaçış Koridoru Genişliği (Genel)',
          b36.koridorGenislikKorunumlu,
          reqKoridor,
          false,
        );
        if (b36.kapiGenislikKorunumlu != null) {
          _addDetail(
            details,
            label: 'Kaçış Kapısı Temiz Geçiş Genişliği',
            value: b36.kapiGenislikKorunumlu!.uiTitle,
            subtitle: b36.kapiGenislikKorunumlu!.uiSubtitle,
            report: b36.kapiGenislikKorunumlu!.label.contains("-A")
                ? "KRİTİK RİSK: En Az: 80 cm."
                : (b36.kapiGenislikKorunumlu!.label.contains("-B")
                      ? "OLUMLU: 80 cm ve üzerindedir."
                      : "BİLİNMİYOR."),
            status: b36.kapiGenislikKorunumlu!.label.contains("-A")
                ? ReportStatus.risk
                : (b36.kapiGenislikKorunumlu!.label.contains("-B")
                      ? ReportStatus.compliant
                      : ReportStatus.warning),
          );
        }
      } else {
        // Ayrı Giriş
        evaluateWidth(
          'Korunumlu Merdiven Genişliği',
          b36.genislikKorunumlu,
          reqMerdiven,
          true,
        );
        evaluateWidth(
          'Korunumlu Koridor Genişliği',
          b36.koridorGenislikKorunumlu,
          reqKoridor,
          false,
        );
        if (b36.kapiGenislikKorunumlu != null) {
          _addDetail(
            details,
            label: 'Korunumlu Alan Kapı Genişliği',
            value: b36.kapiGenislikKorunumlu!.uiTitle,
            subtitle: b36.kapiGenislikKorunumlu!.uiSubtitle,
            report: b36.kapiGenislikKorunumlu!.label.contains("-A")
                ? "KRİTİK RİSK: En Az: 80 cm."
                : (b36.kapiGenislikKorunumlu!.label.contains("-B")
                      ? "OLUMLU: 80 cm ve üzerindedir."
                      : "BİLİNMİYOR."),
            status: b36.kapiGenislikKorunumlu!.label.contains("-A")
                ? ReportStatus.risk
                : (b36.kapiGenislikKorunumlu!.label.contains("-B")
                      ? ReportStatus.compliant
                      : ReportStatus.warning),
          );
        }
        evaluateWidth(
          'Korunumsuz Merdiven Genişliği',
          b36.genislikKorunumsuz,
          reqMerdiven,
          true,
        );
        evaluateWidth(
          'Korunumsuz Koridor Genişliği',
          b36.koridorGenislikKorunumsuz,
          reqKoridor,
          false,
        );
        if (b36.kapiGenislikKorunumsuz != null) {
          _addDetail(
            details,
            label: 'Korunumsuz Alan Kapı Genişliği',
            value: b36.kapiGenislikKorunumsuz!.uiTitle,
            subtitle: b36.kapiGenislikKorunumsuz!.uiSubtitle,
            report: b36.kapiGenislikKorunumsuz!.label.contains("-A")
                ? "KRİTİK RİSK: En Az: 80 cm."
                : (b36.kapiGenislikKorunumsuz!.label.contains("-B")
                      ? "OLUMLU: 80 cm ve üzerindedir."
                      : "BİLİNMİYOR."),
            status: b36.kapiGenislikKorunumsuz!.label.contains("-A")
                ? ReportStatus.risk
                : (b36.kapiGenislikKorunumsuz!.label.contains("-B")
                      ? ReportStatus.compliant
                      : ReportStatus.warning),
          );
        }
      }

      // Madde 41 Detayları (Tablo kısmı yukarı taşındı)
      if (b20 != null) {
        // Dairesel Merdiven (Madde 25) - Analiz artık yukarıdaki 'fullEval' içinde sunuluyor.
      }

      // Mühendis Notu
      if (b36.merdivenDegerlendirme != null &&
          b36.merdivenDegerlendirme!.isNotEmpty) {
        _addDetail(
          details,
          label: "",
          value: "",
          report: b36.merdivenDegerlendirme!,
          status: ReportStatus.info,
        );
      }
    }
    return details;
  }

  void _checkWidth(
    String prefix,
    dynamic sChoice,
    dynamic cChoice,
    dynamic kapiChoice, {
    required double minMerd,
    required double minKori,
    required List<String> analysisParts,
    bool isSpiralPossible = false,
  }) {
    // DIAGNOSTIC START
    debugPrint("[BÖLÜM 36] Genişlik analizi başladı: $prefix");

    try {
      List<String> violations = [];

      if (sChoice is ChoiceResult) {
        final String label = sChoice.label;
        final range = _getRangeForLabel(label);
        if (range != null && range.length >= 2) {
          int comparisonValue = isSpiralPossible ? range[1] : range[0];
          if (comparisonValue < minMerd) {
            violations.add(
              "Merdiven genişliği yetersiz (Gereken: $minMerd cm, Seçim: ${sChoice.uiTitle})",
            );
          }
        }
      }

      if (cChoice is ChoiceResult) {
        final String label = cChoice.label;
        final range = _getRangeForLabel(label);
        if (range != null && range.isNotEmpty) {
          if (range[0] < minKori) {
            violations.add(
              "Koridor genişliği yetersiz (Gereken: $minKori cm, Seçim: ${cChoice.uiTitle})",
            );
          }
        }
      }

      if (kapiChoice is ChoiceResult && kapiChoice.label == "36-Kapi-A") {
        violations.add(
          "Kapı temiz geçiş genişliği yetersiz (Gereken: En Az 80 cm, Mevcut: ${kapiChoice.uiTitle})",
        );
      }

      if (violations.isNotEmpty) {
        analysisParts.add(
          "KRİTİK RİSK: $prefix kaçış yollarına ait genişlik ihlalleri tespit edildi:\n- ${violations.join("\n- ")}",
        );
      }
    } catch (e) {
      debugPrint("[BÖLÜM 36] HATA ($prefix): $e");
      analysisParts.add(
        "UYARI: $prefix genişlik analizinde teknik bir sorun oluştu.",
      );
    }

    // DIAGNOSTIC END
    debugPrint("[BÖLÜM 36] Genişlik analizi bitti: $prefix");
  }
}
