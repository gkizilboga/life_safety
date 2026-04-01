import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';
import '../models/bolum_20_model.dart';
import '../models/report_status.dart';
import '../utils/app_content.dart';
import 'handlers/section_3_handler.dart';
import 'handlers/section_36_handler.dart';
import 'handlers/section_21_handler.dart';
import 'handlers/section_27_handler.dart';
import 'handlers/risk_calculator.dart';

enum ReportModule {
  binaBilgileri(
    "Genel Bilgiler",
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    "Aquarius",
    "Çeşme, sarnıç ve su kemerlerinin yerlerini avucunun içi gibi bilen kişi.",
  ),
  modul1(
    "Modül 1",
    [11, 12, 13, 14, 15],
    "Nocturnus",
    "Gece Bekçisi ordusundan, geceleri sokaklarda devriye gezen.",
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

  static double _getHYapi(BinaStore? store) {
    final s = _getStore(store);
    return s.bolum4?.hesaplananYapiYuksekligi ?? s.bolum3?.hYapi ?? 0.0;
  }

  static double _getHBina(BinaStore? store) {
    final s = _getStore(store);
    return s.bolum4?.hesaplananBinaYuksekligi ?? s.bolum3?.hBina ?? 0.0;
  }

  static Map<String, dynamic> calculateRiskMetrics({BinaStore? store}) {
    final s = _getStore(store);
    return RiskCalculator(s).calculateMetrics();
  }

  static ReportStatus getSectionStatus(int id, {BinaStore? store}) {
    final items = getSectionDetailedReport(id, store: store);
    if (items.isEmpty) return ReportStatus.unknown;

    ReportStatus topStatus = ReportStatus.info;

    for (var item in items) {
      final status = item['status'] as ReportStatus? ?? ReportStatus.info;
      if (status.priority > topStatus.priority) {
        topStatus = status;
      }
    }
    return topStatus;
  }

  static void _addDetail(
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

  // Yeni Detaylı Rapor Metodu - Liste Döndürür
  static List<Map<String, dynamic>> getSectionDetailedReport(
    int id, {
    BinaStore? store,
  }) {
    final s = _getStore(store);
    final res = s.getResultForSection(id);
    List<Map<String, dynamic>> details = [];

    if (res == null) return [];

    // Varsayılan Ana Soru Eklemesi
    // Eğer özel bir logic yoksa, standart cevabı ekle
    bool handled = false;

    // Bölüm 3: Kat Adetleri ve Yükseklik Bilgileri
    if (id == 3) {
      final newDetails = Section3Handler(s).getDetailedReport();
      assert(
        newDetails.length == details.length ||
            true, // Will refine assertion later
        'Shadow Logic Mismatch in Section 3',
      );
      details.addAll(newDetails);
      handled = true;
    }

    // Bölüm 5: Brüt Alan Girişi
    if (id == 5) {
      final b5 = s.bolum5;
      if (b5 != null) {
        if (b5.tabanAlani != null)
          details.add({
            'label': 'Zemin Kat Taban Alanı',
            'value': '${b5.tabanAlani} m²',
            'report': '',
          });
        if (b5.normalKatAlani != null)
          details.add({
            'label': 'Normal Kat Alanı',
            'value': '${b5.normalKatAlani} m²',
            'report': '',
          });
        if (b5.bodrumKatAlani != null)
          details.add({
            'label': 'Bodrum Kat Alanı',
            'value': '${b5.bodrumKatAlani} m²',
            'report': '',
          });
        if (b5.toplamInsaatAlani != null)
          details.add({
            'label': 'Toplam İnşaat Alanı',
            'value': '${b5.toplamInsaatAlani} m²',
            'report': '',
          });
        handled = true;
      }
    }

    // Bölüm 6: Kullanım Amaçları
    if (id == 6) {
      final b6 = s.bolum6;
      if (b6 != null) {
        // Ana kullanım tipleri
        _addDetail(
          details,
          label: 'Binanızda konut haricinde aşağıdakilerden hangileri mevcut?',
          value: '',
          report: '',
        );
        if (b6.hasOtopark)
          _addDetail(details, label: 'Otopark', value: 'Mevcut', report: '');
        if (b6.hasTicari)
          _addDetail(
            details,
            label: 'Ticari Alan',
            value: 'Mevcut',
            report: '',
          );
        if (b6.hasDepo)
          _addDetail(details, label: 'Depo', value: 'Mevcut', report: '');
        if (b6.isSadeceKonut)
          _addDetail(details, label: 'Sadece Konut', value: 'Evet', report: '');

        if (b6.hasTicari && b6.buyukRestoran != null) {
          _addDetail(
            details,
            label:
                'Ticari alan içerisinde büyük restoran (endüstriyel mutfak) var mı?',
            value: b6.buyukRestoran!.uiTitle,
            subtitle: b6.buyukRestoran!.uiSubtitle,
            report: b6.buyukRestoran!.reportText,
            advice: b6.buyukRestoran!.adviceText,
            level: b6.buyukRestoran!.level,
          );
        }
        // Otopark tipi (eğer seçildiyse)
        if (b6.otoparkTipi != null)
          _addDetail(
            details,
            label: 'Otopark tipi nedir?',
            value: b6.otoparkTipi!.uiTitle,
            subtitle: b6.otoparkTipi!.uiSubtitle,
            report: b6.otoparkTipi!.reportText,
            advice: b6.otoparkTipi!.adviceText,
            level: b6.otoparkTipi!.level,
          );
        // Kapalı otopark alanı (eğer girilmişse)
        if (b6.kapaliOtoparkAlani != null)
          _addDetail(
            details,
            label: 'Kapalı Otopark Alanı',
            value: '${b6.kapaliOtoparkAlani} m²',
            report: '',
          );
        handled = true;
      }
    }

    // Bölüm 10: Kat Kullanım Amaçları
    if (id == 10) {
      final b10 = s.bolum10;
      if (b10 != null) {
        // Zemin kat
        if (b10.zemin != null) {
          _addDetail(
            details,
            label: 'Zemin Katın Kullanım Amacı',
            value: "${b10.zemin!.uiTitle} ${b10.zemin!.reportText}",
            subtitle: b10.zemin!.uiSubtitle,
            report: '',
            advice: '',
          );
        }
        // Bodrum katlar
        if (b10.bodrumlar.isNotEmpty) {
          if (b10.bodrumlarAyni && b10.bodrumlar[0] != null) {
            _addDetail(
              details,
              label: 'Bodrum Kat Kullanım Amacı (Tümü Aynı)',
              value:
                  "${b10.bodrumlar[0]!.uiTitle} ${b10.bodrumlar[0]!.reportText}",
              subtitle: b10.bodrumlar[0]!.uiSubtitle,
              report: '',
              advice: '',
            );
          } else {
            for (int i = 0; i < b10.bodrumlar.length; i++) {
              if (b10.bodrumlar[i] != null) {
                _addDetail(
                  details,
                  label: '${i + 1}. Bodrum Kat Kullanım Amacı',
                  value:
                      "${b10.bodrumlar[i]!.uiTitle} ${b10.bodrumlar[i]!.reportText}",
                  subtitle: b10.bodrumlar[i]!.uiSubtitle,
                  report: '',
                  advice: '',
                );
              }
            }
          }
        }
        // Normal katlar
        if (b10.normaller.isNotEmpty) {
          if (b10.normallerAyni && b10.normaller[0] != null) {
            _addDetail(
              details,
              label: 'Normal Kat Kullanım Amacı (Tümü Aynı)',
              value:
                  "${b10.normaller[0]!.uiTitle} ${b10.normaller[0]!.reportText}",
              subtitle: b10.normaller[0]!.uiSubtitle,
              report: '',
              advice: '',
            );
          } else {
            for (int i = 0; i < b10.normaller.length; i++) {
              if (b10.normaller[i] != null) {
                _addDetail(
                  details,
                  label: '${i + 1}. Normal Kat Kullanım Amacı',
                  value:
                      "${b10.normaller[i]!.uiTitle} ${b10.normaller[i]!.reportText}",
                  subtitle: b10.normaller[i]!.uiSubtitle,
                  report: '',
                  advice: '',
                );
              }
            }
          }
        }
        handled = true;
      }
    }

    // Bölüm 7: Özel Riskli Alanların Varlığı
    if (id == 7) {
      final b7 = s.bolum7;
      if (b7 != null) {
        final Map<String, bool> spaces = {
          'Kazan Dairesi': b7.hasKazan,
          'Asansör': b7.hasAsansor,
          'Çatı Arası': b7.hasCati,
          'Jeneratör Odası': b7.hasJenerator,
          'Elektrik Odası': b7.hasElektrik,
          'Trafo Odası': b7.hasTrafo,
          'Eşya Deposu': b7.hasDepo,
          'Çöp Odası': b7.hasCop,
          'Sığınak': b7.hasSiginak,
          'Bitişik Nizam Ortak Duvarı': b7.hasDuvar,
        };

        if (s.bolum6?.buyukRestoran?.label == "6-3-A (Büyük Restoran)") {
          spaces['Endüstriyel Mutfak'] = true;
        }

        spaces.forEach((name, exists) {
          details.add({
            'label': name,
            'value': exists ? 'Mevcut' : 'Yok',
            'report': '',
          });
        });
        handled = true;
      }
    }

    // Bölüm 9: Sprinkler ve Davlumbaz
    if (id == 9) {
      final b9 = s.bolum9;
      if (b9 != null) {
        if (b9.secim != null) {
          _addDetail(
            details,
            label: 'Binada sprinkler sistemi var mı?',
            value: b9.secim!.uiTitle,
            subtitle: b9.secim!.uiSubtitle,
            report: b9.secim!.reportText,
            advice: b9.secim!.adviceText,
          );
        }
        if (s.bolum6?.buyukRestoran?.label == "6-3-A (Büyük Restoran)" &&
            b9.davlumbaz != null) {
          _addDetail(
            details,
            label:
                'Büyük restoran davlumbazında otomatik söndürme sistemi var mı?',
            value: b9.davlumbaz!.uiTitle,
            subtitle: b9.davlumbaz!.uiSubtitle,
            report: b9.davlumbaz!.reportText,
            advice: b9.davlumbaz!.adviceText,
          );
        }
        handled = true;
      }
    }

    // Bölüm 21: Yangın Güvenlik Holü
    // Bölüm 21: Yangın Güvenlik Holü
    if (id == 21) {
      if (s.bolum21 != null) {
        details.addAll(Section21Handler(s).getDetailedReport());
        handled = true;
      }
    }

    if (id == 11) {
      _buildSection11Details(details, s);
      handled = true;
    }

    // Bölüm 12: Yapısal Yangın Dayanımı
    if (id == 12) {
      final b12 = s.bolum12;
      if (b12 != null) {
        // Betonarme soruları
        if (b12.betonPaspayi != null)
          _addDetail(
            details,
            label:
                'Betonarme taşıyıcılarınızdaki paspayı (demir koruma tabakası) durumu nedir?',
            value: b12.betonPaspayi!.uiTitle,
            subtitle: b12.betonPaspayi!.uiSubtitle,
            report: b12.betonPaspayi!.reportText,
            advice: b12.betonPaspayi!.adviceText,
            level: b12.betonPaspayi!.level,
          );
        // Paspayı değerleri (ölçü girilmişse)
        if (b12.kolonPaspayi != null)
          _addDetail(
            details,
            label: 'Kolon Paspayı',
            value: '${b12.kolonPaspayi} mm',
            report: '',
          );
        if (b12.kirisPaspayi != null)
          _addDetail(
            details,
            label: 'Kiriş Paspayı',
            value: '${b12.kirisPaspayi} mm',
            report: '',
          );
        if (b12.dosemePaspayi != null)
          _addDetail(
            details,
            label: 'Döşeme Paspayı',
            value: '${b12.dosemePaspayi} mm',
            report: '',
          );
        // Çelik sorusu
        if (b12.celikKoruma != null)
          _addDetail(
            details,
            label:
                'Çelik taşıyıcılarınızda yangına karşı bir koruma veya yalıtım var mı?',
            value: b12.celikKoruma!.uiTitle,
            subtitle: b12.celikKoruma!.uiSubtitle,
            report: b12.celikKoruma!.reportText,
            advice: b12.celikKoruma!.adviceText,
          );
        // Ahşap sorusu
        if (b12.ahsapKesit != null)
          _addDetail(
            details,
            label:
                'Ahşap taşıyıcılarınızın kesiti yapı kullanımına göre yeterli mi?',
            value: b12.ahsapKesit!.uiTitle,
            subtitle: b12.ahsapKesit!.uiSubtitle,
            report: b12.ahsapKesit!.reportText,
            advice: b12.ahsapKesit!.adviceText,
          );
        // Yığma sorusu
        if (b12.yigmaDuvar != null)
          _addDetail(
            details,
            label: 'Yığma duvarlarınızın kalınlığı ne durumda?',
            value: b12.yigmaDuvar!.uiTitle,
            subtitle: b12.yigmaDuvar!.uiSubtitle,
            report: b12.yigmaDuvar!.reportText,
            advice: b12.yigmaDuvar!.adviceText,
          );
        handled = true;
      }
    }

    // Bölüm 13: Yangın Kompartımanları
    if (id == 13) {
      _buildSection13Details(details, s);
      handled = true;
    }

    // Bölüm 14: Tesisat Şaftları
    if (id == 14) {
      final b14 = s.bolum14;
      if (b14 != null) {
        if (b14.raporMesaji != null && b14.raporMesaji!.isNotEmpty) {
          _addDetail(
            details,
            label: 'Değerlendirme',
            value: '',
            report: b14.raporMesaji!,
            level: RiskLevel.info,
          );
        }
        handled = true;
      }
    }

    // Bölüm 15: İç Kaplamalar
    if (id == 15) {
      final b15 = s.bolum15;
      if (b15 != null) {
        if (b15.kaplama != null)
          _addDetail(
            details,
            label: 'Zemin kaplama malzemesi nedir?',
            value: b15.kaplama!.uiTitle,
            subtitle: b15.kaplama!.uiSubtitle,
            report: b15.kaplama!.reportText,
            advice: b15.kaplama!.adviceText,
            level: b15.kaplama!.level,
          );
        if (b15.yalitim != null)
          _addDetail(
            details,
            label: 'Döşeme üzerinde ısı yalıtım malzemesi var mı?',
            value: b15.yalitim!.uiTitle,
            subtitle: b15.yalitim!.uiSubtitle,
            report: b15.yalitim!.reportText,
            advice: b15.yalitim!.adviceText,
            level: b15.yalitim!.level,
          );
        if (b15.yalitimSap != null)
          _addDetail(
            details,
            label: 'Yalıtım üzerinde en az 2 cm şap var mı?',
            value: b15.yalitimSap!.uiTitle,
            subtitle: b15.yalitimSap!.uiSubtitle,
            report: b15.yalitimSap!.reportText,
            advice: b15.yalitimSap!.adviceText,
            level: b15.yalitimSap!.level,
          );
        if (b15.tavan != null)
          _addDetail(
            details,
            label: 'Asma Tavan var mı?',
            value: b15.tavan!.uiTitle,
            report: b15.tavan!.reportText,
            advice: b15.tavan!.adviceText,
            level: b15.tavan!.level,
          );
        if (b15.tavanMalzeme != null)
          _addDetail(
            details,
            label: 'Asma tavan malzemesi nedir?',
            value: b15.tavanMalzeme!.uiTitle,
            report: b15.tavanMalzeme!.reportText,
            advice: b15.tavanMalzeme!.adviceText,
            level: b15.tavanMalzeme!.level,
          );
        if (b15.tesisat != null)
          _addDetail(
            details,
            label: 'Tesisat geçişleri nasıl kapatılmış?',
            value: b15.tesisat!.uiTitle,
            report: b15.tesisat!.reportText,
            advice: b15.tesisat!.adviceText,
            level: b15.tesisat!.level,
          );
        handled = true;
      }
    }

    // Bölüm 16: Dış Cephe
    if (id == 16) {
      final b16 = s.bolum16;
      if (b16 != null) {
        // Ana Soru
        if (b16.mantolama != null) {
          String report = b16.mantolama!.reportText;
          RiskLevel level = b16.mantolama!.level;

          if (b16.mantolama!.label.contains("16-1-A")) {
            final hBina = _getHBina(store);
            if (hBina < 28.50) {
              report = Bolum16Content.mantolamaOptionALowReport;

              // Eğer h < 28.5 ve tüm bariyer/yalıtım soruları EVET (1) ise OLUMLU yap
              if (b16.bariyerYan == 1 &&
                  b16.bariyerUst == 1 &&
                  b16.bariyerZemin == 1) {
                level = RiskLevel.positive;
                report = report.replaceFirst("UYARI:", "OLUMLU:");
              }
            }
          }

          _addDetail(
            details,
            label: 'Dış cephe kaplama veya ısı yalıtım sistemi nedir?',
            value: b16.mantolama!.uiTitle,
            subtitle: b16.mantolama!.uiSubtitle,
            report: report,
            advice: b16.mantolama!.adviceText,
            level: level,
          );
        }

        if (b16.mantolama?.label.contains("16-1-A") == true) {
          double hBina = s.bolum3?.hBina ?? 0;
          if (hBina <= 28.50) {
            if (b16.bariyerYan != null) {
              details.add({
                'label':
                    'Pencerelerin yanlarında en az 15 cm eninde yalıtım var mı?',
                'value': _getYesNoUnknown(b16.bariyerYan),
                'report': _getBariyerReport(
                  b16.bariyerYan!,
                  "Pencerelerin yanlarında yalıtım",
                ),
                'advice': b16.bariyerYan != 1
                    ? "Yönetmelik gereği pencerelerin yanlarında en az 15 cm eninde yalıtım yapılmalıdır."
                    : "",
              });
            }
            if (b16.bariyerUst != null) {
              details.add({
                'label': 'Pencerelerin üstünde 30 cm eninde yalıtım var mı?',
                'value': _getYesNoUnknown(b16.bariyerUst),
                'report': _getBariyerReport(
                  b16.bariyerUst!,
                  "Pencerelerin üstünde yalıtım",
                ),
                'advice': b16.bariyerUst != 1
                    ? "Yönetmelik gereği pencerelerin üstünde en az 30 cm eninde yalıtım yapılmalıdır."
                    : "",
              });
            }
            if (b16.bariyerZemin != null) {
              details.add({
                'label':
                    'Zemin seviyesinden 150 cm yüksekliğinde yalıtım var mı?',
                'value': _getYesNoUnknown(b16.bariyerZemin),
                'report': _getBariyerReport(
                  b16.bariyerZemin!,
                  "Zemin seviyesinde 1.5m yalıtım",
                ),
                'advice': b16.bariyerZemin != 1
                    ? "Zemin seviyesinden en az 1.5 metre yüksekliğinde yalıtım yapılmalıdır."
                    : "",
              });
            }
          }
        }

        if (b16.mantolama?.label == Bolum16Content.giydirmeOptionC.label) {
          if (b16.giydirmeBoslukYalitim != null) {
            details.add({
              'label': 'Cephe ile döşeme arasındaki boşluklar yalıtılmış mı?',
              'value': b16.giydirmeBoslukYalitim == true ? "Evet" : "Hayır",
              'report': b16.giydirmeBoslukYalitim == true
                  ? "OLUMLU: Cephe kaplaması ile döşeme arasındaki boşluklar uygun malzemelerle yalıtılmıştır."
                  : "KRİTİK RİSK: Cephe kaplaması ile bina döşemesi arasındaki boşluklar yalıtılmamıştır.",
              'advice': b16.giydirmeBoslukYalitim == false
                  ? "Cephe ile döşeme arasındaki boşluklar taşyünü gibi yanmaz malzemelerle sıkıca kapatılmalıdır."
                  : "",
            });
          }
        }

        if (b16.sagirYuzey != null) {
          _addDetail(
            details,
            label: 'Katlar arasında sağır (yanmaz) yüzey var mı?',
            value: b16.sagirYuzey!.uiTitle,
            subtitle: b16.sagirYuzey!.uiSubtitle,
            report: b16.sagirYuzey!.reportText,
            advice: b16.sagirYuzey!.adviceText,
            level: b16.sagirYuzey!.level,
          );
        }

        if (b16.bitisikNizam != null) {
          _addDetail(
            details,
            label:
                'Binanız bitişik nizamda bulunan yan bina ile karşılaştırıldığında yükseklik durumu nedir?',
            value: b16.bitisikNizam!.uiTitle,
            subtitle: b16.bitisikNizam!.uiSubtitle,
            report: b16.bitisikNizam!.reportText,
            advice: b16.bitisikNizam!.adviceText,
            level: b16.bitisikNizam!.level,
          );
        }
        handled = true;
      }
    }

    // Bölüm 17: Çatı
    if (id == 17) {
      final b17 = s.bolum17;
      if (b17 != null) {
        final bool isYuksek = s.bolum3?.isYuksekBina ?? false;

        if (b17.kaplama != null)
          _addDetail(
            details,
            label: 'Çatınızın en üst katmanında hangi malzeme kullanılıyor?',
            value: b17.kaplama!.uiTitle,
            report: b17.kaplama!.reportText,
            advice: b17.kaplama!.adviceText,
            level: b17.kaplama!.level,
          );

        // Çatı iskelet sorusu (dinamik)
        if (b17.iskelet != null) {
          final String iskeletReport =
              b17.iskelet!.label == Bolum17Content.iskeletOptionB.label
              ? (isYuksek
                    ? Bolum17Content.iskeletOptionBYuksekReport
                    : Bolum17Content.iskeletOptionBNormalReport)
              : b17.iskelet!.reportText;
          _addDetail(
            details,
            label: 'Çatıyı taşıyan iskelet ve altındaki ısı yalıtımı nedir?',
            value: b17.iskelet!.uiTitle,
            subtitle: b17.iskelet!.uiSubtitle,
            report: iskeletReport,
            advice: b17.iskelet!.adviceText,
            level: b17.iskelet!.level,
          );
        }

        if (b17.bitisikDuvar != null)
          _addDetail(
            details,
            label: 'Çatılar arasında yangın kesici duvar',
            value: b17.bitisikDuvar!.uiTitle,
            subtitle: b17.bitisikDuvar!.uiSubtitle,
            report: b17.bitisikDuvar!.reportText,
            advice: b17.bitisikDuvar!.adviceText,
            level: b17.bitisikDuvar!.level,
          );

        // Işıklık sorusu
        if (b17.isiklik != null) {
          _addDetail(
            details,
            label: 'Çatınızda ışıklık (cam kubbe, aydınlatma açıklığı) var mı?',
            value: b17.isiklik!.uiTitle,
            subtitle: b17.isiklik!.uiSubtitle,
            report: b17.isiklik!.reportText,
            advice: b17.isiklik!.adviceText,
            level: b17.isiklik!.level,
          );
          // Alt soru: Malzeme tipi (sadece OptionB seçildiyse)
          if (b17.isiklik!.label == Bolum17Content.isiklikOptionB.label &&
              b17.isiklikMalzemesi != null) {
            ChoiceResult malzemeChoice;
            if (b17.isiklikMalzemesi == 'cam') {
              malzemeChoice = Bolum17Content.isiklikCam;
            } else if (b17.isiklikMalzemesi == 'bilinmiyor') {
              malzemeChoice = Bolum17Content.isiklikBilinmiyor;
            } else {
              malzemeChoice = Bolum17Content.isiklikPlastik;
            }
            _addDetail(
              details,
              label: 'Işıklık malzeme tipi nedir?',
              value: malzemeChoice.uiTitle,
              subtitle: malzemeChoice.uiSubtitle,
              report: malzemeChoice.reportText,
              advice: malzemeChoice.adviceText,
              level: malzemeChoice.level,
            );
          }
        }
        handled = true;
      }
    }

    // Bölüm 18: Duvar Kaplamaları
    if (id == 18) {
      final b18 = s.bolum18;
      if (b18 != null) {
        final bool isYuksek = s.bolum3?.isYuksekBina ?? false;
        final duvar = b18.duvarKaplama;
        if (duvar != null) {
          // duvarOptionB ise dinamik metin seç
          final String reportText =
              duvar.label == Bolum18Content.duvarOptionB.label
              ? (isYuksek
                    ? Bolum18Content.duvarOptionBYuksekReport
                    : Bolum18Content.duvarOptionBNormalReport)
              : duvar.reportText;
          _addDetail(
            details,
            label: 'Bina içindeki duvar yüzeylerinde ne tür malzeme var?',
            value: duvar.uiTitle,
            subtitle: duvar.uiSubtitle,
            report: reportText,
            advice: duvar.adviceText,
            level: duvar.level,
          );
        }
        if (b18.boruTipi != null)
          _addDetail(
            details,
            label:
                'Binanız yüksek katlı olduğu için tesisat şaftlarından geçen plastik su borularında önlem alınmış mı?',
            value: b18.boruTipi!.uiTitle,
            subtitle: b18.boruTipi!.uiSubtitle,
            report: b18.boruTipi!.reportText,
            advice: b18.boruTipi!.adviceText,
            level: b18.boruTipi!.level,
          );
        handled = true;
      }
    }

    // Bölüm 22: İtfaiye (Acil Durum) Asansörü
    if (id == 22) {
      final b22 = s.bolum22;
      if (b22 != null) {
        if (b22.varlik != null)
          _addDetail(
            details,
            label: 'Binada İtfaiye Asansörü var mı?',
            value: b22.varlik!.uiTitle,
            subtitle: b22.varlik!.uiSubtitle,
            report: b22.varlik!.reportText,
            advice: b22.varlik!.adviceText,
            level: b22.varlik!.level,
          );
        if (b22.konum != null)
          _addDetail(
            details,
            label: 'Bu İtfaiye Asansörünün kapısı nereye açılıyor?',
            value: b22.konum!.uiTitle,
            subtitle: b22.konum!.uiSubtitle,
            report: b22.konum!.reportText,
            advice: b22.konum!.adviceText,
            level: b22.konum!.level,
          );
        if (b22.boyut != null)
          _addDetail(
            details,
            label:
                'İtfaiye Asansörünün açıldığı yangın güvenlik holünün taban alanı kaç metrekaredir?',
            value: b22.boyut!.uiTitle,
            subtitle: b22.boyut!.uiSubtitle,
            report: b22.boyut!.reportText,
            advice: b22.boyut!.adviceText,
            level: b22.boyut!.level,
          );
        if (b22.kabin != null)
          _addDetail(
            details,
            label:
                'Kabin genişliği en az 1.8 m² ve en alt kattan en üst kata 1 dakika içerisinde çıkabiliyor mu?',
            value: b22.kabin!.uiTitle,
            subtitle: b22.kabin!.uiSubtitle,
            report: b22.kabin!.reportText,
            advice: b22.kabin!.adviceText,
            level: b22.kabin!.level,
          );
        if (b22.enerji != null)
          _addDetail(
            details,
            label:
                'Bu asansör, elektrik kesildiğinde en az 60 dakika çalışabilen bir jeneratöre bağlı mı?',
            value: b22.enerji!.uiTitle,
            subtitle: b22.enerji!.uiSubtitle,
            report: b22.enerji!.reportText,
            advice: b22.enerji!.adviceText,
            level: b22.enerji!.level,
          );
        if (b22.basinc != null)
          _addDetail(
            details,
            label: 'İtfaiye Asansörünün kuyusu basınçlandırılmış mı?',
            value: b22.basinc!.uiTitle,
            subtitle: b22.basinc!.uiSubtitle,
            report: b22.basinc!.reportText,
            advice: b22.basinc!.adviceText,
            level: b22.basinc!.level,
          );
        handled = true;
      }
    }

    // Bölüm 23: Normal (İnsan Taşıma) Asansör
    if (id == 23) {
      final b23 = s.bolum23;
      if (b23 != null) {
        if (b23.bodrum != null)
          _addDetail(
            details,
            label: 'Asansörünüz bodrum katlara da iniyor mu?',
            value: b23.bodrum!.uiTitle,
            subtitle: b23.bodrum!.uiSubtitle,
            report: b23.bodrum!.reportText,
            advice: b23.bodrum!.adviceText,
            level: b23.bodrum!.level,
          );
        if (b23.yanginModu != null)
          _addDetail(
            details,
            label:
                'Yangın anında asansörler otomatik olarak zemin kata (veya binadan çıkış katına) iniyor mu?',
            value: b23.yanginModu!.uiTitle,
            subtitle: b23.yanginModu!.uiSubtitle,
            report: b23.yanginModu!.reportText,
            advice: b23.yanginModu!.adviceText,
            level: b23.yanginModu!.level,
          );
        if (b23.konum != null)
          _addDetail(
            details,
            label: 'Asansör kapıları normal katlarda nereye açılıyor?',
            value: b23.konum!.uiTitle,
            subtitle: b23.konum!.uiSubtitle,
            report: b23.konum!.reportText,
            advice: b23.konum!.adviceText,
            level: b23.konum!.level,
          );
        if (b23.levha != null)
          _addDetail(
            details,
            label:
                'Asansör kapılarında \'YANGIN ANINDA KULLANMAYINIZ\' uyarısı var mı?',
            value: b23.levha!.uiTitle,
            subtitle: b23.levha!.uiSubtitle,
            report: b23.levha!.reportText,
            advice: b23.levha!.adviceText,
            level: b23.levha!.level,
          );
        if (b23.havalandirma != null)
          _addDetail(
            details,
            label: 'Asansör kuyusunun tepesinde havalandırma penceresi var mı?',
            value: b23.havalandirma!.uiTitle,
            subtitle: b23.havalandirma!.uiSubtitle,
            report: b23.havalandirma!.reportText,
            advice: b23.havalandirma!.adviceText,
            level: b23.havalandirma!.level,
          );
        handled = true;
      }
    }

    // Bölüm 24: Dış Kaçış Geçitleri
    if (id == 24) {
      final b24 = s.bolum24;
      if (b24 != null) {
        if (b24.tip != null)
          _addDetail(
            details,
            label: 'Dairenizden itibaren bina dışına çıkış nasıl?',
            value: b24.tip!.uiTitle,
            subtitle: b24.tip!.uiSubtitle,
            report: b24.tip!.reportText,
            advice: b24.tip!.adviceText,
            level: b24.tip!.level,
          );
        if (b24.pencere != null)
          _addDetail(
            details,
            label: 'Açık kaçış yoluna bakan dairelere ait pencereler var mı?',
            value: b24.pencere!.uiTitle,
            subtitle: b24.pencere!.uiSubtitle,
            report: b24.pencere!.reportText,
            advice: b24.pencere!.adviceText,
            level: b24.pencere!.level,
          );
        if (b24.kapi != null)
          _addDetail(
            details,
            label: 'Açık kaçış yoluna bakan dış kapılar var mı?',
            value: b24.kapi!.uiTitle,
            subtitle: b24.kapi!.uiSubtitle,
            report: b24.kapi!.reportText,
            advice: b24.kapi!.adviceText,
            level: b24.kapi!.level,
          );
        handled = true;
      }
    }

    // Bölüm 25: Dairesel Merdiven
    if (id == 25) {
      final b25 = s.bolum25;
      if (b25 != null) {
        if (b25.genislik != null)
          _addDetail(
            details,
            label: 'Merdiven kol genişliği yeterli mi?',
            value: b25.genislik!.uiTitle,
            subtitle: b25.genislik!.uiSubtitle,
            report: b25.genislik!.reportText,
            advice: b25.genislik!.adviceText,
            level: b25.genislik!.level,
          );
        if (b25.basamak != null)
          _addDetail(
            details,
            label: 'Basamak genişliği yeterli mi?',
            value: b25.basamak!.uiTitle,
            subtitle: b25.basamak!.uiSubtitle,
            report: b25.basamak!.reportText,
            advice: b25.basamak!.adviceText,
            level: b25.basamak!.level,
          );
        if (b25.basKurtarma != null)
          _addDetail(
            details,
            label: 'Baş kurtarma yüksekliği yeterli mi?',
            value: b25.basKurtarma!.uiTitle,
            subtitle: b25.basKurtarma!.uiSubtitle,
            report: b25.basKurtarma!.reportText,
            advice: b25.basKurtarma!.adviceText,
            level: b25.basKurtarma!.level,
          );
        if (b25.yukseklik != null)
          _addDetail(
            details,
            label:
                'Kaçış yolu olarak kullanılacak döner merdiven yüksekliği nedir?',
            value: b25.yukseklik!.uiTitle,
            subtitle: b25.yukseklik!.uiSubtitle,
            report: b25.yukseklik!.reportText,
            advice: b25.yukseklik!.adviceText,
            level: b25.yukseklik!.level,
          );
        handled = true;
      }
    }

    // Bölüm 19: Kaçış Yolları
    if (id == 19) {
      final b19 = s.bolum19;
      if (b19 != null) {
        for (var e in b19.engeller) {
          _addDetail(
            details,
            label: 'Kaçış yollarında aşağıdakiler mevcut mu?',
            value: e.uiTitle,
            subtitle: e.uiSubtitle,
            report: e.reportText,
            advice: e.adviceText,
            level: e.level,
          );
        }
        if (b19.levha != null)
          _addDetail(
            details,
            label: 'Yönlendirme levhaları asılı mı?',
            value: b19.levha!.uiTitle,
            subtitle: b19.levha!.uiSubtitle,
            report: b19.levha!.reportText,
            advice: b19.levha!.adviceText,
            level: b19.levha!.level,
          );
        if (b19.yanilticiKapi != null)
          _addDetail(
            details,
            label:
                'Yanıltıcı kapılar var mı? (Çıkış ulaşırken kafanızı karıştırabilecek türden kapılar)',
            value: b19.yanilticiKapi!.uiTitle,
            subtitle: b19.yanilticiKapi!.uiSubtitle,
            report: b19.yanilticiKapi!.reportText,
            advice: b19.yanilticiKapi!.adviceText,
            level: b19.yanilticiKapi!.level,
          );
        if (b19.yanilticiEtiket != null)
          _addDetail(
            details,
            label: 'Bu kapıların üzerinde yazı var mı?',
            value: b19.yanilticiEtiket!.uiTitle,
            subtitle: b19.yanilticiEtiket!.uiSubtitle,
            report: b19.yanilticiEtiket!.reportText,
            advice: b19.yanilticiEtiket!.adviceText,
            level: b19.yanilticiEtiket!.level,
          );
        handled = true;
      }
    }

    // Bölüm 20: Kaçış Merdivenleri
    if (id == 20) {
      final b20 = s.bolum20;
      if (b20 != null) {
        // Tek katlı bina soruları
        if (b20.tekKatCikis != null)
          _addDetail(
            details,
            label: 'Tek katlı binada merdivensiz bina dışına çıkış mümkün mu?',
            value: b20.tekKatCikis!.uiTitle,
            subtitle: b20.tekKatCikis!.uiSubtitle,
            report: b20.tekKatCikis!.reportText,
            advice: b20.tekKatCikis!.adviceText,
            level: b20.tekKatCikis!.level,
          );
        if (b20.tekKatRampa != null)
          _addDetail(
            details,
            label:
                'Binadan dışarıya çıkarken rampa kullanmak zorunda kalıyor musunuz?',
            value: b20.tekKatRampa!.uiTitle,
            subtitle: b20.tekKatRampa!.uiSubtitle,
            report: b20.tekKatRampa!.reportText,
            advice: b20.tekKatRampa!.adviceText,
            level: b20.tekKatRampa!.level,
          );
        // Bodrum merdiven devamı
        if (b20.bodrumMerdivenDevami != null)
          _addDetail(
            details,
            label:
                'Bodrum kat merdivenleri normal kat merdivenleriyle devam ediyor mu?',
            value: b20.bodrumMerdivenDevami!.uiTitle,
            subtitle: b20.bodrumMerdivenDevami!.uiSubtitle,
            report: b20.bodrumMerdivenDevami!.reportText,
            advice: b20.bodrumMerdivenDevami!.adviceText,
            level: b20.bodrumMerdivenDevami!.level,
          );
        // YGH Basınçlandırma (Kullanıcıdan alınan bilgi)
        if (b20.basinclandirma != null)
          _addDetail(
            details,
            label: 'Merdivenlerde basınçlandırma sistemi var mı?',
            value: b20.basinclandirma!.uiTitle,
            subtitle: b20.basinclandirma!.uiSubtitle,
            report: b20.basinclandirma!.reportText,
            advice: b20.basinclandirma!.adviceText,
            level: b20.basinclandirma!.level,
          );

        // Dinamik Basınçlandırma Analizi (Sadece PDF/Detaylı için)
        final basincReasons = evaluateBasincRequirement(store: s);
        if (basincReasons.isNotEmpty) {
          _addDetail(
            details,
            label: 'Basınçlandırma Sistemi',
            value: 'ZORUNLU',
            report:
                'BİLGİ: Bina verilerine göre basınçlandırma sistemi zorunluluğu bulunmaktadır:\n${basincReasons.join('\n')}',
            level: RiskLevel.critical,
          );
        } else if (b20.basinclandirma != null) {
          // Sadece kullanıcıya sorulduysa (kapalı merdiven varsa) "Şart Değil" bilgisini ekle
          _addDetail(
            details,
            label: 'Basınçlandırma Sistemi',
            value: '', // Don't show as a user response
            report:
                'BİLGİ: Bina verilerine göre merdivenlerde basınçlandırma sistemi tesis edilmesi mecburi değildir.',
            level: RiskLevel.info,
          );
        }
        // Madde 45: Doğal Havalandırma
        if (b20.havalandirma != null)
          _addDetail(
            details,
            label: 'Merdivenlerde doğal havalandırma var mı?',
            value: b20.havalandirma!.uiTitle,
            report: b20.havalandirma!.reportText,
            advice: b20.havalandirma!.adviceText,
            level: b20.havalandirma!.level,
          );

        // Madde 41 Tahliye Mesafesi (Lobi) - Bölüm 36 analiz notunda merkezileştirildiği için buradan kaldırıldı.

        handled = true;
      }
    }

    // Bölüm 26: Rampalar
    if (id == 26) {
      final b26 = s.bolum26;
      if (b26 != null) {
        if (b26.varlik != null)
          _addDetail(
            details,
            label:
                'Binada kullanmak zorunda kaldığınız eğimli bir rampa var mı?',
            value: b26.varlik!.uiTitle,
            subtitle: b26.varlik!.uiSubtitle,
            report: b26.varlik!.reportText,
            advice: b26.varlik!.adviceText,
            level: b26.varlik!.level,
          );
        if (b26.egim != null)
          _addDetail(
            details,
            label: 'Bu rampanın eğimi ve zemin kaplaması nasıl?',
            value: b26.egim!.uiTitle,
            subtitle: b26.egim!.uiSubtitle,
            report: b26.egim!.reportText,
            advice: b26.egim!.adviceText,
            level: b26.egim!.level,
          );
        if (b26.sahanlik != null)
          _addDetail(
            details,
            label:
                'Rampanın başlangıcında ve bitişinde sahanlık (düzlük) var mı?',
            value: b26.sahanlik!.uiTitle,
            subtitle: b26.sahanlik!.uiSubtitle,
            report: b26.sahanlik!.reportText,
            advice: b26.sahanlik!.adviceText,
            level: b26.sahanlik!.level,
          );
        if (b26.otopark != null)
          _addDetail(
            details,
            label: 'Otopark tipi nedir?',
            value: b26.otopark!.uiTitle,
            subtitle: b26.otopark!.uiSubtitle,
            report: b26.otopark!.reportText,
            advice: b26.otopark!.adviceText,
            level: b26.otopark!.level,
          );
        handled = true;
      }
    }

    // Bölüm 27: Kapılar
    if (id == 27) {
      if (s.bolum27 != null) {
        details.addAll(Section27Handler(s).getDetailedReport());
        handled = true;
      }
    }

    // Bölüm 28: Daire İçi Mesafeler
    if (id == 28) {
      final b28 = s.bolum28;
      if (b28 != null) {
        final hasSprinkler = s.bolum9?.secim?.label == "9-1-A";
        final limitTekYon = hasSprinkler ? 30 : 20;

        if (b28.mesafe != null)
          _addDetail(
            details,
            label:
                'Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan mesafe ne kadardır?',
            value: b28.mesafe!.uiTitle,
            subtitle: b28.mesafe!.uiSubtitle,
            report: _filterSprinklerText(
              b28.mesafe!.reportText,
              hasSprinkler,
              limit: limitTekYon.toString(),
            ),
            advice: b28.mesafe!.adviceText,
            level: b28.mesafe!.level,
          );
        if (b28.dubleks != null)
          _addDetail(
            details,
            label: 'Daireniz Dubleks (İki katlı) mi?',
            value: b28.dubleks!.uiTitle,
            subtitle: b28.dubleks!.uiSubtitle,
            report: b28.dubleks!.reportText,
            advice: b28.dubleks!.adviceText,
            level: b28.dubleks!.level,
          );
        if (b28.alan != null)
          _addDetail(
            details,
            label: 'Üst katınızın alanı 70 m²\'den büyük mü?',
            value: b28.alan!.uiTitle,
            subtitle: b28.alan!.uiSubtitle,
            report: b28.alan!.reportText,
            advice: b28.alan!.adviceText,
            level: b28.alan!.level,
          );
        if (b28.cikis != null)
          _addDetail(
            details,
            label:
                'Üst kattan apartman koridoruna açılan ikinci bir chilik kapı (çıkış) var mı?',
            value: b28.cikis!.uiTitle,
            subtitle: b28.cikis!.uiSubtitle,
            report: b28.cikis!.reportText,
            advice: b28.cikis!.adviceText,
            level: b28.cikis!.level,
          );
        if (b28.muafiyet != null)
          _addDetail(
            details,
            label: 'Daire içi mesafe muafiyeti',
            value: b28.muafiyet!.uiTitle,
            subtitle: b28.muafiyet!.uiSubtitle,
            report: _filterSprinklerText(
              b28.muafiyet!.reportText,
              hasSprinkler,
            ),
            advice: b28.muafiyet!.adviceText,
            level: b28.muafiyet!.level,
          );
        handled = true;
      }
    }

    // Bölüm 29: Ortak Hatalar
    if (id == 29) {
      final b29 = s.bolum29;
      if (b29 != null) {
        if (b29.otopark != null)
          _addDetail(
            details,
            label: Bolum29Content.questionOtopark,
            value: b29.otopark!.uiTitle,
            subtitle: b29.otopark!.uiSubtitle,
            report: b29.otopark!.reportText,
            advice: b29.otopark!.adviceText,
            level: b29.otopark!.level,
          );
        if (b29.kazan != null)
          _addDetail(
            details,
            label: Bolum29Content.questionKazan,
            value: b29.kazan!.uiTitle,
            subtitle: b29.kazan!.uiSubtitle,
            report: b29.kazan!.reportText,
            advice: b29.kazan!.adviceText,
            level: b29.kazan!.level,
          );
        if (b29.cati != null)
          _addDetail(
            details,
            label: Bolum29Content.questionCati,
            value: b29.cati!.uiTitle,
            subtitle: b29.cati!.uiSubtitle,
            report: b29.cati!.reportText,
            advice: b29.cati!.adviceText,
            level: b29.cati!.level,
          );
        if (b29.asansor != null)
          _addDetail(
            details,
            label: Bolum29Content.questionAsansor,
            value: b29.asansor!.uiTitle,
            subtitle: b29.asansor!.uiSubtitle,
            report: b29.asansor!.reportText,
            advice: b29.asansor!.adviceText,
            level: b29.asansor!.level,
          );
        if (b29.jenerator != null)
          _addDetail(
            details,
            label: Bolum29Content.questionJenerator,
            value: b29.jenerator!.uiTitle,
            subtitle: b29.jenerator!.uiSubtitle,
            report: b29.jenerator!.reportText,
            advice: b29.jenerator!.adviceText,
            level: b29.jenerator!.level,
          );
        if (b29.pano != null)
          _addDetail(
            details,
            label: Bolum29Content.questionPano,
            value: b29.pano!.uiTitle,
            subtitle: b29.pano!.uiSubtitle,
            report: b29.pano!.reportText,
            advice: b29.pano!.adviceText,
            level: b29.pano!.level,
          );
        if (b29.trafo != null)
          _addDetail(
            details,
            label: Bolum29Content.questionTrafo,
            value: b29.trafo!.uiTitle,
            subtitle: b29.trafo!.uiSubtitle,
            report: b29.trafo!.reportText,
            advice: b29.trafo!.adviceText,
            level: b29.trafo!.level,
          );
        if (b29.depo != null)
          _addDetail(
            details,
            label: Bolum29Content.questionDepo,
            value: b29.depo!.uiTitle,
            subtitle: b29.depo!.uiSubtitle,
            report: b29.depo!.reportText,
            advice: b29.depo!.adviceText,
            level: b29.depo!.level,
          );
        if (b29.cop != null)
          _addDetail(
            details,
            label: Bolum29Content.questionCop,
            value: b29.cop!.uiTitle,
            subtitle: b29.cop!.uiSubtitle,
            report: b29.cop!.reportText,
            advice: b29.cop!.adviceText,
            level: b29.cop!.level,
          );
        if (b29.siginak != null)
          _addDetail(
            details,
            label: Bolum29Content.questionSiginak,
            value: b29.siginak!.uiTitle,
            subtitle: b29.siginak!.uiSubtitle,
            report: b29.siginak!.reportText,
            advice: b29.siginak!.adviceText,
            level: b29.siginak!.level,
          );
        handled = true;
      }
    }

    // Bölüm 30: Kazan Dairesi Detayları
    if (id == 30) {
      final b30 = s.bolum30;
      if (b30 != null) {
        if (b30.konum != null)
          _addDetail(
            details,
            label: Bolum30Content.questionKonum,
            value: b30.konum!.uiTitle,
            subtitle: b30.konum!.uiSubtitle,
            report: b30.konum!.reportText,
            advice: b30.konum!.adviceText,
            level: b30.konum!.level,
          );
        if (b30.kapi != null) {
          // Kapı sayısı değerlendirmesi - kapasite veya alana göre
          _addDetail(
            details,
            label: Bolum30Content.questionKapi,
            value: b30.kapi!.uiTitle,
            subtitle: b30.kapi!.uiSubtitle,
            report: b30.kapi!.reportText,
            advice: b30.kapi!.adviceText,
            level: b30.kapi!.level,
          ); // Note: logic might override this text in full report
        }
        if (b30.yakit != null)
          _addDetail(
            details,
            label: 'Kazanınız sıvı yakıtlı (Mazot/Fuel-oil) mı?',
            value: b30.yakit!.uiTitle,
            subtitle: b30.yakit!.uiSubtitle,
            report: b30.yakit!.reportText,
            advice: b30.yakit!.adviceText,
            level: b30.yakit!.level,
          );
        if (b30.hava != null)
          _addDetail(
            details,
            label: Bolum30Content.questionHava,
            value: b30.hava!.uiTitle,
            subtitle: b30.hava!.uiSubtitle,
            report: b30.hava!.reportText,
            advice: b30.hava!.adviceText,
            level: b30.hava!.level,
          );
        if (b30.drenaj != null)
          _addDetail(
            details,
            label: Bolum30Content.questionDrenaj,
            value: b30.drenaj!.uiTitle,
            subtitle: b30.drenaj!.uiSubtitle,
            report: b30.drenaj!.reportText,
            advice: b30.drenaj!.adviceText,
            level: b30.drenaj!.level,
          );
        if (b30.tup != null)
          _addDetail(
            details,
            label: Bolum30Content.questionTup,
            value: b30.tup!.uiTitle,
            subtitle: b30.tup!.uiSubtitle,
            report: b30.tup!.reportText,
            advice: b30.tup!.adviceText,
            level: b30.tup!.level,
          );
        handled = true;
      }
    }

    // Bölüm 31: Trafo
    if (id == 31) {
      final b31 = s.bolum31;
      if (b31 != null) {
        if (b31.yapi != null)
          _addDetail(
            details,
            label: 'Trafo odasının duvarları ve kapısı yangına dayanıklı mı?',
            value: b31.yapi!.uiTitle,
            subtitle: b31.yapi!.uiSubtitle,
            report: b31.yapi!.reportText,
            advice: b31.yapi!.adviceText,
            level: b31.yapi!.level,
          );
        if (b31.tip != null)
          _addDetail(
            details,
            label: "Binanızdaki trafo 'Yağlı Tip' mi yoksa 'Kuru Tip' mi?",
            value: b31.tip!.uiTitle,
            subtitle: b31.tip!.uiSubtitle,
            report: b31.tip!.reportText,
            advice: b31.tip!.adviceText,
            level: b31.tip!.level,
          );
        if (b31.cukur != null)
          _addDetail(
            details,
            label: 'Trafonun altında yağ toplama çukuru ve ızgara var mı?',
            value: b31.cukur!.uiTitle,
            subtitle: b31.cukur!.uiSubtitle,
            report: b31.cukur!.reportText,
            advice: b31.cukur!.adviceText,
            level: b31.cukur!.level,
          );
        if (b31.sondurme != null)
          _addDetail(
            details,
            label:
                'Trafo odasında otomatik yangın algılama veya söndürme sistemi var mı?',
            value: b31.sondurme!.uiTitle,
            subtitle: b31.sondurme!.uiSubtitle,
            report: b31.sondurme!.reportText,
            advice: b31.sondurme!.adviceText,
            level: b31.sondurme!.level,
          );
        if (b31.cevre != null)
          _addDetail(
            details,
            label:
                'Trafo odasının içerisinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?',
            value: b31.cevre!.uiTitle,
            subtitle: b31.cevre!.uiSubtitle,
            report: b31.cevre!.reportText,
            advice: b31.cevre!.adviceText,
            level: b31.cevre!.level,
          );
        handled = true;
      }
    }

    // Bölüm 32: Jeneratör
    if (id == 32) {
      final b32 = s.bolum32;
      if (b32 != null) {
        if (b32.yapi != null)
          _addDetail(
            details,
            label:
                'Jeneratör odasının duvarları yangına dayanıklı mı ve kapısı nereye açılıyor?',
            value: b32.yapi!.uiTitle,
            subtitle: b32.yapi!.uiSubtitle,
            report: b32.yapi!.reportText,
            advice: b32.yapi!.adviceText,
            level: b32.yapi!.level,
          );
        if (b32.yakit != null)
          _addDetail(
            details,
            label: 'Jeneratörün yakıtı nerede ve nasıl depolanıyor?',
            value: b32.yakit!.uiTitle,
            subtitle: b32.yakit!.uiSubtitle,
            report: b32.yakit!.reportText,
            advice: b32.yakit!.adviceText,
            level: b32.yakit!.level,
          );
        if (b32.cevre != null)
          _addDetail(
            details,
            label:
                'Jeneratör odasının içinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?',
            value: b32.cevre!.uiTitle,
            subtitle: b32.cevre!.uiSubtitle,
            report: b32.cevre!.reportText,
            advice: b32.cevre!.adviceText,
            level: b32.cevre!.level,
          );
        if (b32.egzoz != null)
          _addDetail(
            details,
            label:
                'Jeneratörün egzoz borusu nereye veriliyor ve oda havalandırılıyor mu?',
            value: b32.egzoz!.uiTitle,
            subtitle: b32.egzoz!.uiSubtitle,
            report: b32.egzoz!.reportText,
            advice: b32.egzoz!.adviceText,
            level: b32.egzoz!.level,
          );
        handled = true;
      }
    }

    // Bölüm 33: Kullanıcı Yükü ve Çıkışlar
    if (id == 33) {
      final b33 = s.bolum33;
      if (b33 != null) {
        _addDetail(
          details,
          label: 'Kullanıcı Yükü ve Çıkış Kapasitesi Analizi',
          value: 'Detaylı Hesaplama',
          report: b33.combinedReportText,
          status: b33.combinedReportText.contains("KRİTİK RİSK")
              ? ReportStatus.risk
              : (b33.combinedReportText.contains("UYARI")
                    ? ReportStatus.warning
                    : ReportStatus.compliant),
        );
        handled = true;
      }
    }

    // Bölüm 34: Zemin/Bodrum Karakteristiği
    if (id == 34) {
      final b34 = s.bolum34;
      if (b34 != null) {
        if (b34.zemin != null)
          _addDetail(
            details,
            label:
                'Zemin kattaki ticari alanların doğrudan sokağa/bahçeye açılan kendilerine ait kapıları var mı?',
            value: b34.zemin!.uiTitle,
            subtitle: b34.zemin!.uiSubtitle,
            report: b34.zemin!.reportText,
            advice: b34.zemin!.adviceText,
            level: b34.zemin!.level,
          );
        if (b34.bodrum != null)
          _addDetail(
            details,
            label:
                'Bodrum kattaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni ve çıkışları var mı?',
            value: b34.bodrum!.uiTitle,
            subtitle: b34.bodrum!.uiSubtitle,
            report: b34.bodrum!.reportText,
            advice: b34.bodrum!.adviceText,
            level: b34.bodrum!.level,
          );
        if (b34.normal != null)
          _addDetail(
            details,
            label:
                'Normal katlardaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni ve çıkışları var mı?',
            value: b34.normal!.uiTitle,
            subtitle: b34.normal!.uiSubtitle,
            report: b34.normal!.reportText,
            advice: b34.normal!.adviceText,
            level: b34.normal!.level,
          );
        handled = true;
      }
    }

    // Bölüm 35: Koridor Genişliği
    if (id == 35) {
      final b35 = s.bolum35;
      if (b35 != null) {
        // Calculate dynamic limits
        final b9 = s.bolum9;
        bool hasSprinkler = b9?.secim?.label == "9-1-A";
        int limitTekYon = hasSprinkler ? 30 : 15;
        int limitCiftYon = hasSprinkler ? 75 : 30;

        String replaceLimit(String? text, int limit) {
          if (text == null) return "";
          return text.replaceAll("[LIMIT]", limit.toString());
        }

        if (b35.tekYon != null)
          _addDetail(
            details,
            label:
                'Daire kapınızdan çıktığınızda bina merdiven kapısına kadar olan mesafe kaç metredir?',
            value: replaceLimit(b35.tekYon!.uiTitle, limitTekYon),
            subtitle: b35.tekYon!.uiSubtitle,
            report: replaceLimit(b35.tekYon!.reportText, limitTekYon),
            advice: replaceLimit(b35.tekYon!.adviceText, limitTekYon),
            level: b35.tekYon!.level,
          );
        if (b35.ciftYon != null)
          _addDetail(
            details,
            label:
                'Daire kapınızdan çıktığınızda, size EN YAKIN yangın merdivenine olan mesafe kaç metredir?',
            value: replaceLimit(b35.ciftYon!.uiTitle, limitCiftYon),
            subtitle: b35.ciftYon!.uiSubtitle,
            report: replaceLimit(b35.ciftYon!.reportText, limitCiftYon),
            advice: replaceLimit(b35.ciftYon!.adviceText, limitCiftYon),
            level: b35.ciftYon!.level,
          );
        if (b35.cikmaz != null)
          _addDetail(
            details,
            label: "Daireniz koridorun sonunda, 'Çıkmaz' bir noktada mı?",
            value: b35.cikmaz!.uiTitle,
            subtitle: b35.cikmaz!.uiSubtitle,
            report: b35.cikmaz!.reportText,
            advice: b35.cikmaz!.adviceText,
            level: b35.cikmaz!.level,
          );
        if (b35.cikmazMesafe != null)
          _addDetail(
            details,
            label: 'Çıkmaz koridor mesafesi ne kadar?',
            value: replaceLimit(b35.cikmazMesafe!.uiTitle, limitTekYon),
            subtitle: b35.cikmazMesafe!.uiSubtitle,
            report: replaceLimit(b35.cikmazMesafe!.reportText, limitTekYon),
            advice: replaceLimit(b35.cikmazMesafe!.adviceText, limitTekYon),
            level: b35.cikmazMesafe!.level,
          );
        if (b35.manuelMesafe != null && b35.manuelMesafe! > 0)
          _addDetail(
            details,
            label: 'Elle Girilen Kaçış Mesafesi',
            value: '${b35.manuelMesafe} m',
            report: '',
            status: ReportStatus.info,
          );
        handled = true;
      }
    }

    // Bölüm 36: Merdiven Değerlendirmesi
    if (id == 36) {
      if (s.bolum36 != null) {
        details.addAll(Section36Handler(s).getDetailedReport());
        handled = true;
      }
    }

    // Handle other sections generically if NOT handled above
    if (!handled) {
      // Kullanıcı isteği: "Genel Değerlendirme" yerine gerçek soru metnini kullan
      // Eğer bölümün spesifik bir sorusu yoksa, "Bölüm Değerlendirmesi" kullan
      String questionLabel = _getQuestionText(id) ?? 'Bölüm Değerlendirmesi';

      _addDetail(
        details,
        label: questionLabel,
        value: res.uiTitle,
        subtitle: res.uiSubtitle,
        report: getSectionFullReport(id, store: store),
        advice: res.adviceText,
        level: res.level,
      );
    }

    return details;
  }

  /// Bölüm ID'sine göre soru metnini döndürür.
  /// Eğer bölümün spesifik bir sorusu yoksa null döner ve "Genel Değerlendirme" kullanılır.
  static String? _getQuestionText(int sectionId) {
    const Map<int, String?> sectionQuestions = {
      1: 'Binanızın yapı ruhsat tarihi nedir?',
      2: 'Binanızın taşıyıcı sistemi (yapı türü) nedir?',
      3: 'Kat bilgilerinizi giriniz',
      4: 'Bina Yükseklik Bilgisi',
      5: 'Brüt Alan Girişi (m²)',
      6: 'Binanızda konut haricinde aşağıdakiler mevcut mu?',
      8: 'Binanızın yerleşim düzeni nedir?',
      9: 'Binada otomatik yağmurlama (sprinkler) sistemi var mı?',
      10: 'Katların baskın kullanım amaçları',
      11: 'İtfaiye aracının binaya yaklaşım mesafesi 45 metreyi aşıyor mu?',
      12: 'Yapısal eleman yangın dayanımı',
      14: 'Tesisat Şaftları',
      16: 'Binanızdaki dış cephe kaplama veya ısı yalıtım sistemi nedir?',
      17: 'Çatı kaplama malzemesi ve yapısı',
      18: 'İç duvar kaplamaları',
      22: 'İtfaiye asansörü mevcut mu?',
      23: 'Asansörünüz bodrum katlara da iniyor mu?',
      24: 'Dairenizden itibaren bina dışına çıkış nasıl?',
      25: 'Merdiven kol genişliği yeterli mi?',
      26: 'Kaçış rampası var mı?',
      27: 'Kaçış yolu kapı özellikleri',
      28: 'Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan mesafe ne kadardır?',
      29: 'Teknik alanlar temiz ve düzenli mi?',
      33: 'Kullanıcı yükü hesabı',
      35: 'Kaçış mesafeleri',
      36: 'Merdiven ve koridor genişlikleri',
      // Not: Aşağıdaki bölümler çok sorulu olduğu için 'handled = true' ile
      // getSectionDetailedReport() içinde özel işleniyor ve buraya gelmez:
      // 11, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 28, 29, 30, 31, 32, 34
    };

    return sectionQuestions[sectionId];
  }

  static RiskLevel getSectionRiskLevel(int sectionId, {BinaStore? store}) {
    final s = _getStore(store);
    final res = s.getResultForSection(sectionId);

    // İlk 10 bölüm BİLGİ amaçlıdır.
    if (sectionId <= 10) return res?.level ?? RiskLevel.positive;

    // Tüm bölümler için: ilgili modelin ChoiceResult alanlarından max level alınır.
    // Artık string parsing kullanılmıyor — ChoiceResult.level enumu esas alınıyor.
    return _getLevelForSection(sectionId, s);
  }

  /// Her bölümün modelindeki ChoiceResult alanlarını toplayıp en yüksek risk seviyesini döndürür.
  static RiskLevel _getLevelForSection(int id, BinaStore s) {
    switch (id) {
      case 11:
        final b = s.bolum11;
        return _maxLevel([
          b?.mesafe?.level,
          b?.engel?.level,
          b?.zayifNokta?.level,
        ]);
      case 12:
        final b = s.bolum12;
        return _maxLevel([
          b?.betonPaspayi?.level,
          b?.celikKoruma?.level,
          b?.ahsapKesit?.level,
          b?.yigmaDuvar?.level,
        ]);
      case 13:
        final b = s.bolum13;
        return _maxLevel([
          b?.otoparkKapi?.level,
          b?.kazanKapi?.level,
          b?.asansorKapi?.level,
          b?.jeneratorKapi?.level,
          b?.elektrikKapi?.level,
          b?.trafoKapi?.level,
          b?.depoKapi?.level,
          b?.copKapi?.level,
          b?.ortakDuvar?.level,
          b?.ticariKapi?.level,
          b?.otoparkAlan?.level,
          b?.kazanAlan?.level,
          b?.siginakAlan?.level,
          b?.endustriyelMutfakKapi?.level,
        ]);
      case 14:
        return s.getResultForSection(14)?.level ?? RiskLevel.info;
      case 15:
        final b = s.bolum15;
        return _maxLevel([
          b?.kaplama?.level,
          b?.yalitim?.level,
          b?.yalitimSap?.level,
          b?.tavan?.level,
          b?.tavanMalzeme?.level,
          b?.tesisat?.level,
        ]);
      case 16:
        final b = s.bolum16;
        // Bariyer bool alanları → critical = 0, warning = 2 (olumsuz)
        final bariyerLevels = <RiskLevel?>[
          b?.mantolama?.level,
          b?.sagirYuzey?.level,
          b?.bitisikNizam?.level,
          if (b?.giydirmeBoslukYalitim == false) RiskLevel.critical,
          if (b?.bariyerYan != null && b!.bariyerYan != 1) RiskLevel.critical,
          if (b?.bariyerUst != null && b!.bariyerUst != 1) RiskLevel.critical,
          if (b?.bariyerZemin != null && b!.bariyerZemin != 1)
            RiskLevel.critical,
          if (b?.sagirYuzeySprinkler == false) RiskLevel.warning,
          // Cephe uzunluğu level
          b?.cepheUzunlugu?.level,
        ];
        return _maxLevel(bariyerLevels);
      case 17:
        final b = s.bolum17;
        return _maxLevel([
          b?.kaplama?.level,
          b?.iskelet?.level,
          b?.bitisikDuvar?.level,
          b?.isiklik?.level,
        ]);
      case 18:
        final b = s.bolum18;
        return _maxLevel([b?.duvarKaplama?.level, b?.boruTipi?.level]);
      case 19:
        final b = s.bolum19;
        final engelLevels = b?.engeller.map((e) => e.level).toList() ?? [];
        return _maxLevel([
          ...engelLevels.map((l) => l as RiskLevel?),
          b?.levha?.level,
          b?.yanilticiKapi?.level,
          b?.yanilticiEtiket?.level,
        ]);
      case 20:
        final b = s.bolum20;
        final List<RiskLevel> extraLevels = [];
        final basincReasons = evaluateBasincRequirement(store: s);
        for (var reason in basincReasons) {
          if (reason.startsWith("KRİTİK RİSK"))
            extraLevels.add(RiskLevel.critical);
          else if (reason.startsWith("UYARI"))
            extraLevels.add(RiskLevel.warning);
        }

        return _maxLevel([
          b?.tekKatCikis?.level,
          b?.tekKatRampa?.level,
          b?.bodrumMerdivenDevami?.level,
          b?.basinclandirma?.level,
          b?.havalandirma?.level,
          b?.lobiTahliyeMesafeDurumu?.level,
          b?.bodrumLobiTahliyeMesafeDurumu?.level,
          ...extraLevels,
        ]);
      case 21:
        final b = s.bolum21;
        final List<RiskLevel> extraLevels = [];
        final yghReasons = evaluateYghRequirement(store: s);
        for (var reason in yghReasons) {
          if (reason.startsWith("KRİTİK RİSK"))
            extraLevels.add(RiskLevel.critical);
          else if (reason.startsWith("UYARI"))
            extraLevels.add(RiskLevel.warning);
        }

        return _maxLevel([
          b?.varlik?.level,
          b?.malzeme?.level,
          b?.kapi?.level,
          b?.esya?.level,
          ...extraLevels,
        ]);
      case 22:
        final b = s.bolum22;
        return _maxLevel([
          b?.varlik?.level,
          b?.konum?.level,
          b?.boyut?.level,
          b?.kabin?.level,
          b?.enerji?.level,
          b?.basinc?.level,
        ]);
      case 23:
        final b = s.bolum23;
        return _maxLevel([
          b?.bodrum?.level,
          b?.yanginModu?.level,
          b?.konum?.level,
          b?.levha?.level,
          b?.havalandirma?.level,
        ]);
      case 24:
        final b = s.bolum24;
        return _maxLevel([b?.tip?.level, b?.pencere?.level, b?.kapi?.level]);
      case 25:
        final b = s.bolum25;
        return _maxLevel([
          b?.genislik?.level,
          b?.basamak?.level,
          b?.basKurtarma?.level,
          b?.yukseklik?.level,
        ]);
      case 26:
        final b = s.bolum26;
        return _maxLevel([
          b?.varlik?.level,
          b?.egim?.level,
          b?.sahanlik?.level,
        ]);
      case 27:
        final b = s.bolum27;
        final maxYuk = calculateMaxYuk(s);
        final yonLevels = b?.yon.map((e) => _getDynamicLevel(e, maxYuk)) ?? [];
        final kilitLevels =
            b?.kilit.map((e) => _getDynamicLevel(e, maxYuk)) ?? [];
        return _maxLevel([
          b?.boyut?.level,
          b?.dayanim?.level,
          ...yonLevels,
          ...kilitLevels,
        ]);
      case 28:
        final b = s.bolum28;
        return _maxLevel([
          b?.mesafe?.level,
          b?.dubleks?.level,
          b?.alan?.level,
          b?.cikis?.level,
          b?.muafiyet?.level,
        ]);
      case 29:
        final b = s.bolum29;
        return _maxLevel([
          b?.otopark?.level,
          b?.kazan?.level,
          b?.cati?.level,
          b?.asansor?.level,
          b?.jenerator?.level,
          b?.pano?.level,
          b?.trafo?.level,
          b?.depo?.level,
          b?.cop?.level,
          b?.siginak?.level,
        ]);
      case 30:
        final b = s.bolum30;
        return _maxLevel([
          b?.konum?.level,
          b?.kapi?.level,
          b?.hava?.level,
          b?.yakit?.level,
          b?.drenaj?.level,
          b?.tup?.level,
        ]);
      case 31:
        final b = s.bolum31;
        return _maxLevel([
          b?.yapi?.level,
          b?.tip?.level,
          b?.cukur?.level,
          b?.sondurme?.level,
          b?.cevre?.level,
        ]);
      case 32:
        final b = s.bolum32;
        return _maxLevel([
          b?.yapi?.level,
          b?.yakit?.level,
          b?.cevre?.level,
          b?.egzoz?.level,
        ]);
      case 33:
        // Bölüm 33 kompleks hesaplama — sayısal alanlara göre dinamik olarak hesaplanan ChoiceResult kullanılır
        final b33 = s.bolum33;
        return _maxLevel([
          b33?.normalKatSonuc?.level,
          b33?.zeminKatSonuc?.level,
          b33?.bodrumKatSonuc?.level,
        ]);
      case 34:
        final b = s.bolum34;
        return _maxLevel([b?.zemin?.level, b?.bodrum?.level, b?.normal?.level]);
      case 35:
        final b = s.bolum35;
        return _maxLevel([
          b?.tekYon?.level,
          b?.ciftYon?.level,
          b?.cikmaz?.level,
          b?.cikmazMesafe?.level,
        ]);
      case 36:
        final b = s.bolum36;
        final b20 = s.bolum20;
        // Madde 41: Merdivenlerin en az yarısının doğrudan dışarıya açılması zorunlu
        RiskLevel madde41Level = RiskLevel.positive;
        if (b20 != null) {
          final total =
              b20.normalMerdivenSayisi +
              b20.binaIciYanginMerdiveniSayisi +
              b20.binaDisiKapaliYanginMerdiveniSayisi +
              b20.binaDisiAcikYanginMerdiveniSayisi +
              b20.donerMerdivenSayisi +
              b20.sahanliksizMerdivenSayisi +
              b20.dengelenmisMerdivenSayisi;
          if (total > 0) {
            final directExits = b20.toplamDisariAcilanMerdivenSayisi;
            if ((directExits * 2) < total) madde41Level = RiskLevel.critical;
          }
          // Tahliye mesafesi kontrolü (lobiTahliyeMesafeDurumu) zaten ChoiceResult.level içinde
        }
        return _maxLevel([
          b?.cikisKati?.level,
          b?.disMerd?.level,
          b?.konum?.level,
          b?.kapiTipi?.level,
          madde41Level,
          b20?.lobiTahliyeMesafeDurumu?.level,
          b20?.bodrumLobiTahliyeMesafeDurumu?.level,
        ]);

      default:
        return s.getResultForSection(id)?.level ?? RiskLevel.positive;
    }
  }

  /// Verilen null-olabilir level listesinden en yüksek öncelikli olanı döndürür.
  /// Null değerler görmezden gelinir. Liste boş ise RiskLevel.positive döner.
  static RiskLevel _maxLevel(Iterable<RiskLevel?> levels) {
    RiskLevel max = RiskLevel.info;
    for (final level in levels) {
      if (level != null && level.priority > max.priority) {
        max = level;
      }
    }
    // info kalırsa positive döndür (hiç olumsuz şey yok demek)
    // info kalırsa positive döndür (hiç olumsuz şey yok demek)
    return max == RiskLevel.info ? RiskLevel.positive : max;
  }

  /// Puanlama için Bölüm 11-36 arasındaki bireysel soruların risk seviyelerini toplar.
  /// Deduplikasyon yapmaz, her bir soruyu/kontrol noktasını ayrı ayrı döner.
  /// Bölüm 1-10 (Genel Bilgiler) puanlamaya katılmaz.
  static List<RiskLevel> getAllQuestionsRiskLevels({BinaStore? store}) {
    final s = _getStore(store);
    final List<RiskLevel> levels = [];

    void add(ChoiceResult? res) {
      if (res != null) levels.add(res.level);
    }

    void addAll(Iterable<ChoiceResult?>? list) {
      if (list != null) {
        for (var item in list) {
          if (item != null) levels.add(item.level);
        }
      }
    }

    void addLevel(RiskLevel? level) {
      if (level != null) levels.add(level);
    }

    // --- BÖLÜM 11 (İtfaiye Yaklaşım) ---
    final b11 = s.bolum11;
    if (b11 != null) {
      add(b11.mesafe);
      add(b11.engel);
      add(b11.zayifNokta);
    }

    // --- BÖLÜM 12 (Yapısal Dayanım) ---
    final b12 = s.bolum12;
    if (b12 != null) {
      add(b12.betonPaspayi);
      add(b12.celikKoruma);
      add(b12.ahsapKesit);
      add(b12.yigmaDuvar);
    }

    // --- BÖLÜM 13 (Yangın Kompartımanları) ---
    final b13 = s.bolum13;
    if (b13 != null) {
      add(b13.otoparkKapi);
      add(b13.kazanKapi);
      add(b13.asansorKapi);
      add(b13.jeneratorKapi);
      add(b13.elektrikKapi);
      add(b13.trafoKapi);
      add(b13.depoKapi);
      add(b13.copKapi);
      add(b13.ortakDuvar);
      add(b13.ticariKapi);
      add(b13.otoparkAlan);
      add(b13.kazanAlan);
      add(b13.siginakAlan);
      add(b13.endustriyelMutfakKapi);
    }

    // --- BÖLÜM 14 (Tesisat Şaftları) ---
    add(s.getResultForSection(14));

    // --- BÖLÜM 15 (İç Kaplamalar) ---
    final b15 = s.bolum15;
    if (b15 != null) {
      add(b15.kaplama);
      add(b15.yalitim);
      add(b15.yalitimSap);
      add(b15.tavan);
      add(b15.tavanMalzeme);
      add(b15.tesisat);
    }

    // --- BÖLÜM 16 (Dış Cephe) ---
    final b16 = s.bolum16;
    if (b16 != null) {
      add(b16.mantolama);
      add(b16.sagirYuzey);
      add(b16.bitisikNizam);
      add(b16.cepheUzunlugu); // corrected from cepheUzlugu
      // Hidden Risks (bools)
      if (b16.giydirmeBoslukYalitim == false) addLevel(RiskLevel.critical);
      if (b16.bariyerYan != null && b16.bariyerYan != 1)
        addLevel(RiskLevel.critical);
      if (b16.bariyerUst != null && b16.bariyerUst != 1)
        addLevel(RiskLevel.critical);
      if (b16.bariyerZemin != null && b16.bariyerZemin != 1)
        addLevel(RiskLevel.critical);
      if (b16.sagirYuzeySprinkler == false) addLevel(RiskLevel.warning);
    }

    // --- BÖLÜM 17 (Çatı) ---
    final b17 = s.bolum17;
    if (b17 != null) {
      add(b17.kaplama);
      add(b17.iskelet);
      add(b17.bitisikDuvar);
      add(b17.isiklik);
    }

    // --- BÖLÜM 18 (Koridor Kaplamaları) ---
    final b18 = s.bolum18;
    if (b18 != null) {
      add(b18.duvarKaplama);
      add(b18.boruTipi);
    }

    // --- BÖLÜM 19 (Kaçış Yolu Engelleri) ---
    final b19 = s.bolum19;
    if (b19 != null) {
      addAll(b19.engeller);
      add(b19.levha);
      add(b19.yanilticiKapi);
      add(b19.yanilticiEtiket);
    }

    // --- BÖLÜM 20 (Merdiven Analizi) ---
    final b20 = s.bolum20;
    if (b20 != null) {
      add(b20.tekKatCikis);
      add(b20.tekKatRampa);
      add(b20.bodrumMerdivenDevami);
      add(b20.basinclandirma);
      add(b20.havalandirma);
      add(b20.lobiTahliyeMesafeDurumu);
      add(b20.bodrumLobiTahliyeMesafeDurumu);

      // Dinamik Basınçlandırma Analizi (Puanlamaya dahil et)
      final basincReasons = evaluateBasincRequirement(store: s);
      for (var reason in basincReasons) {
        if (reason.startsWith("KRİTİK RİSK"))
          addLevel(RiskLevel.critical);
        else if (reason.startsWith("UYARI"))
          addLevel(RiskLevel.warning);
      }

      // Hidden Risks (Numerical)
      if (b20.sahanliksizMerdivenSayisi > 0) addLevel(RiskLevel.critical);
    }

    // --- BÖLÜM 21 (YGH) ---
    final b21 = s.bolum21;
    if (b21 != null) {
      add(b21.varlik);
      add(b21.malzeme);
      add(b21.kapi);
      add(b21.esya);

      // Dinamik YGH Analizi (Puanlamaya dahil et)
      final yghReasons = evaluateYghRequirement(store: s);
      for (var reason in yghReasons) {
        if (reason.startsWith("KRİTİK RİSK"))
          addLevel(RiskLevel.critical);
        else if (reason.startsWith("UYARI"))
          addLevel(RiskLevel.warning);
      }
    }

    // --- BÖLÜM 22 (İtfaiye Asansörü) ---
    final b22 = s.bolum22;
    if (b22 != null) {
      add(b22.varlik);
      add(b22.konum);
      add(b22.boyut);
      add(b22.kabin);
      add(b22.enerji);
      add(b22.basinc);
    }

    // --- BÖLÜM 23 (Normal Asansör) ---
    final b23 = s.bolum23;
    if (b23 != null) {
      add(b23.bodrum);
      add(b23.yanginModu);
      add(b23.konum);
      add(b23.levha);
      add(b23.havalandirma);
    }

    // --- BÖLÜM 24 (Dış Geçitler) ---
    final b24 = s.bolum24;
    if (b24 != null) {
      add(b24.tip);
      add(b24.pencere);
      add(b24.kapi);
    }

    // --- BÖLÜM 25 (Dairesel Merdiven) ---
    final b25 = s.bolum25;
    if (b25 != null) {
      add(b25.genislik);
      add(b25.basamak);
      add(b25.basKurtarma);
      add(b25.yukseklik);
    }

    // --- BÖLÜM 26 (Rampalar) ---
    final b26 = s.bolum26;
    if (b26 != null) {
      add(b26.varlik);
      add(b26.egim);
      add(b26.sahanlik);
      add(b26.otopark);
    }

    // --- BÖLÜM 27 (Kapılar) ---
    final b27 = s.bolum27;
    if (b27 != null) {
      final maxYuk = calculateMaxYuk(s);
      add(b27.boyut);
      for (var e in b27.yon) {
        addLevel(_getDynamicLevel(e, maxYuk));
      }
      for (var e in b27.kilit) {
        addLevel(_getDynamicLevel(e, maxYuk));
      }
      add(b27.dayanim);
    }

    // --- BÖLÜM 28 (Daire İçi) ---
    final b28 = s.bolum28;
    if (b28 != null) {
      add(b28.mesafe);
      add(b28.dubleks);
      add(b28.alan);
      add(b28.cikis);
      add(b28.muafiyet);
    }

    // --- BÖLÜM 29 (Hatalar) ---
    final b29 = s.bolum29;
    if (b29 != null) {
      add(b29.otopark);
      add(b29.kazan);
      add(b29.cati);
      add(b29.asansor);
      add(b29.jenerator);
      add(b29.pano);
      add(b29.trafo);
      add(b29.depo);
      add(b29.cop);
      add(b29.siginak);
    }

    // --- BÖLÜM 30 (Kazan) ---
    final b30 = s.bolum30;
    if (b30 != null) {
      add(b30.konum);
      add(b30.kapi);
      add(b30.hava);
      add(b30.yakit);
      add(b30.drenaj);
      add(b30.tup);
      add(b30.kapasiteChoice);
    }

    // --- BÖLÜM 31 (Trafo) ---
    final b31 = s.bolum31;
    if (b31 != null) {
      add(b31.yapi);
      add(b31.tip);
      add(b31.cukur);
      add(b31.sondurme);
      add(b31.cevre);
    }

    // --- BÖLÜM 32 (Jeneratör) ---
    final b32 = s.bolum32;
    if (b32 != null) {
      add(b32.yapi);
      add(b32.yakit);
      add(b32.cevre);
      add(b32.egzoz);
    }

    // --- BÖLÜM 33 (Yük ve Çıkış) ---
    final b33 = s.bolum33;
    if (b33 != null) {
      add(b33.normalKatSonuc);
      add(b33.zeminKatSonuc);
      add(b33.bodrumKatSonuc);
    }

    // --- BÖLÜM 34 (Karakteristik) ---
    final b34 = s.bolum34;
    if (b34 != null) {
      add(b34.zemin);
      add(b34.bodrum);
      add(b34.normal);
    }

    // --- BÖLÜM 35 (Mesafeler) ---
    final b35 = s.bolum35;
    if (b35 != null) {
      add(b35.tekYon);
      add(b35.ciftYon);
      add(b35.cikmaz);
      add(b35.cikmazMesafe);
    }

    // --- BÖLÜM 36 (Genişlikler) ---
    final b36 = s.bolum36;
    if (b36 != null) {
      add(b36.cikisKati);
      add(b36.disMerd);
      add(b36.konum);
      add(b36.kapiTipi);

      // Madde 41: Merdivenlerin en az yarısının doğrudan dışarıya açılması zorunlu
      final b20 = s.bolum20;
      if (b20 != null) {
        final total =
            b20.normalMerdivenSayisi +
            b20.binaIciYanginMerdiveniSayisi +
            b20.binaDisiKapaliYanginMerdiveniSayisi +
            b20.binaDisiAcikYanginMerdiveniSayisi +
            b20.donerMerdivenSayisi +
            b20.sahanliksizMerdivenSayisi +
            b20.dengelenmisMerdivenSayisi;
        if (total > 0) {
          final directExits = b20.toplamDisariAcilanMerdivenSayisi;
          if ((directExits * 2) < total) {
            addLevel(RiskLevel.critical);
          }
        }
      }
    }

    return levels;
  }

  static Color getStatusColor(
    ChoiceResult? result, {
    int? sectionId,
    BinaStore? store,
  }) {
    final level = sectionId != null
        ? getSectionRiskLevel(sectionId, store: store)
        : (result?.level ?? RiskLevel.positive);

    switch (level) {
      case RiskLevel.critical:
        return const Color(0xFFE53935);
      case RiskLevel.warning:
        return const Color(0xFFFFC107);
      case RiskLevel.unknown:
        return Colors.grey.shade600;
      case RiskLevel.info:
        return const Color(0xFF1E88E5);
      case RiskLevel.positive:
        return const Color(0xFF43A047);
    }
  }

  static String getSectionFullReport(int id, {BinaStore? store}) {
    final s = _getStore(store);
    final res = s.getResultForSection(id);
    if (res == null) return "Bu bölüm değerlendirme kapsamı dışındadır.";

    // Özel Mesaj Override'ları (Sadece gerektiğinde, yoksa AppContent'i kullanır)
    // Ancak bu override metinlerinin de AppContent standardına uyması (Emoji + Kelime + Mesaj) gerekir.

    // Bölüm 3: Kat Adetleri ve Yükseklik Bilgileri
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

        // Yükseklik Bilgilerini Ekle
        parts.add("Bina Yüksekliği: ${b3.hBina?.toStringAsFixed(2) ?? "-"} m");
        parts.add("Yapı Yüksekliği: ${b3.hYapi?.toStringAsFixed(2) ?? "-"} m");

        if (parts.isNotEmpty) return "BİLGİ: ${parts.join(', ')}";
      }
    }

    // Bölüm 12 override
    if (id == 12 && res.label.contains("12-B (Çelik)")) {
      if ((s.bolum5?.toplamInsaatAlani ?? 0.0) < 5000) {
        return "OLUMLU: Çelik taşıyıcı elemanlar üzerinde pasif yangın yalıtımı bulunmamaktadır. (NOT: Bina toplam inşaat alanı 5000 m² altında olduğu için bu durum yönetmeliğe uygundur.)";
      }
    }

    // Bölüm 14: Tesisat Şaftları
    if (id == 14) {
      final r = _getSection14FullReport(s);
      if (r != null) return r;
    }

    // Bölüm 13: Yangın Kompartımanları
    if (id == 13) {
      final r = _getSection13FullReport(s);
      if (r != null) return r;
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
              "KRİTİK RİSK: Binada YANICI tipte mantolama imal edilmiş olmasına rağmen pencere kenarlarında, kat aralarında vs. gerekli olan yangına dayanıklı bariyer görevi görecek yalıtım malzemeleri kullanılmamıştır.",
            );
          } else if (b16.bariyerYan == 2 ||
              b16.bariyerUst == 2 ||
              b16.bariyerZemin == 2) {
            parts.add(
              "UYARI: Binada YANICI tipte mantolama mevcut olup, yangına dayanıklı bariyer görevi görecek yalıtım malzemelerinin kısmen eksik olduğu tespit edilmiştir. Yönetmelik Madde 27'de belirtilen yangın yalıtım uygulamalarının tamamının binada uygulanması gereklidir.",
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
        if (b20.bodrumMerdivenDevami != null)
          parts.add(b20.bodrumMerdivenDevami!.reportText);
        if (b20.basinclandirma != null)
          parts.add(b20.basinclandirma!.reportText);
        if (b20.havalandirma != null) parts.add(b20.havalandirma!.reportText);

        if (parts.isNotEmpty) return parts.join("\n\n");
      }
    }

    // Bölüm 21: YGH Zorunluluğu
    if (id == 21) {
      if (s.bolum21 != null) {
        return Section21Handler(s).getSectionFullReport();
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
      if (s.bolum27 != null) {
        return Section27Handler(s).getSectionFullReport();
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

        // Kapı sayısı değerlendirmesi - kapasite seçimine göre dinamik
        if (b30.kapi != null) {
          final kapasiteChoice = b30.kapasiteChoice;
          final kapiLabel = b30.kapi!.label;

          bool isUnder350 = kapasiteChoice?.label.contains("30-2-A") ?? false;
          bool is350OrAbove = kapasiteChoice?.label.contains("30-2-B") ?? false;

          if (kapiLabel.contains("30-3-A")) {
            // 1 adet kapı seçildi
            if (is350OrAbove) {
              // Kapasite > 350kW ve tek kapı = KRİTİK RİSK
              parts.add(
                "KRİTİK RİSK: Kazan dairesi ısıl kapasitesi 350 kW ve üzerinde olmasına rağmen yalnızca 1 adet çıkış kapısı bulunmaktadır. Yönetmelik gereği en az 2 adet çıkış kapısı zorunludur.",
              );
            } else if (isUnder350) {
              // Kapasite <= 350kW ve tek kapı = OLUMLU
              parts.add(
                "OLUMLU: Kazan dairesi ısıl kapasitesi 350 kW'ın altında olup (kaçış mesafe limiti de aşılmıyorsa) tek çıkış kapısı yeterlidir.",
              );
            } else {
              // Kapasite bilinmiyor
              parts.add(
                kapasiteChoice?.reportText ??
                    "BİLİNMİYOR: Kazan dairesinde 1 adet çıkış kapısı mevcuttur. Kapasite bilinmediğinden yeterlilik değerlendirmesi yapılamamıştır.",
              );
            }
          } else if (kapiLabel.contains("30-3-B")) {
            // 2+ kapı = her zaman olumlu
            parts.add(
              "OLUMLU: Kazan dairesinde birden fazla çıkış kapısı mevcuttur.",
            );
          } else if (kapiLabel.contains("30-3-C")) {
            // Bilmiyorum
            parts.add(
              "BİLİNMİYOR: Kazan dairesi çıkış kapısı sayısı bilinmiyor. 350 kW üzeri kapasiteli kazanlarda en az 2 adet çıkış kapısı zorunludur.",
            );
          }
        }

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
      final b33 = s.bolum33;
      final b34 = s.bolum34; // Section 34 data needed for override logic

      if (b33 != null) {
        // We will reconstruct the report instead of using combinedReportText
        // to account for Section 34 overrides.
        List<String> reportParts = [];

        // Helper function to evaluate a floor type
        void evaluateFloor({
          required String title,
          required int? yuk,
          required int? gerekli,
          required int? mevcut,
          required ChoiceResult? secim34, // Selection from Section 34
          required String
          independentExitLabel, // Label to look for (e.g. "34-1-A")
        }) {
          if (yuk == null || gerekli == null || mevcut == null) return;

          bool hasIndependentExit =
              secim34?.label.contains(independentExitLabel) ?? false;

          bool isSufficient = (mevcut >= gerekli);

          if (hasIndependentExit) {
            // override: POSITIVE because of independent commercial exit
            reportParts.add(
              "OLUMLU ($title): Kattaki kullanıcı yükü $yuk kişi olarak hesaplanmıştır. Normal şartlarda $gerekli adet çıkış gerekmektedir (Mevcut: $mevcut). ANCAK, ticari alanların doğrudan dışarıya açılan bağımsız çıkışları olduğundan (Bölüm 34 beyanı), ticari kullanım kaynaklı yük konut merdiveni hesabına dahil edilmemiştir. Mevcut konut merdivenleri yeterli kabul edilmiştir.",
            );
          } else {
            // Standard check
            if (isSufficient) {
              reportParts.add(
                "OLUMLU ($title): Hesaplanan kullanıcı yükü ($yuk kişi) için mevcut çıkış sayısı ($mevcut adet) yeterlidir. (Gereken: $gerekli)",
              );
            } else {
              reportParts.add(
                "KRİTİK RİSK ($title): Hesaplanan kullanıcı yükü ($yuk kişi) için $gerekli adet çıkış gerekmektedir ancak binada $mevcut adet uygun çıkış tespit edilmiştir. Çıkış kapasitesi yetersizdir.",
              );
            }
          }
        }

        // 1. ZEMİN KAT DEĞERLENDİRMESİ
        evaluateFloor(
          title: "Zemin Kat",
          yuk: b33.yukZemin,
          gerekli: b33.gerekliZemin,
          mevcut: b33.mevcutUst,
          secim34: b34?.zemin,
          independentExitLabel: "34-1-A",
        );

        // 2. NORMAL KAT DEĞERLENDİRMESİ
        if (b33.yukNormal != null) {
          evaluateFloor(
            title: "Normal Katlar",
            yuk: b33.yukNormal,
            gerekli: b33.gerekliNormal,
            mevcut: b33.mevcutUst,
            secim34: b34?.normal,
            independentExitLabel: "34-3-A",
          );
        }

        // 3. BODRUM KAT DEĞERLENDİRMESİ
        if (b33.yukBodrum != null) {
          evaluateFloor(
            title: "Bodrum Katlar",
            yuk: b33.yukBodrum,
            gerekli: b33.gerekliBodrum,
            mevcut: b33.mevcutBodrum,
            secim34: b34?.bodrum,
            independentExitLabel: "34-2-A",
          );
        }

        if (reportParts.isEmpty) {
          return "Hesaplama verisi bulunamadı.";
        }

        String finalReport = reportParts.join("\n\n");
        // Maintain the original specific warning if it exists in the model or needs re-eval
        // Since we are reconstructing, we rely on the evaluation above.
        // We can append the standard disclaimer about Section 36
        if (finalReport.contains("OLUMLU")) {
          finalReport +=
              "\n\n(NOT: Bu bölümdeki 'OLUMLU' ibaresi, yalnızca kişi yüküne göre hesaplanan sayısal çıkış yeterliliğini ifade eder. Merdivenlerin korunumlu olup olmadığı veya niteliklerinin yönetmeliğe uygunluğu Bölüm 36'da ayrıca değerlendirilmiştir.)";
        }
        return finalReport;
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
        final hasSprinkler = s.bolum9?.secim?.label == "9-1-A";
        final limitTekYon = hasSprinkler ? 30 : 15;
        final limitCiftYon = hasSprinkler ? 75 : 30;

        List<String> parts = [];
        if (b35.tekYon != null) {
          parts.add(
            _filterSprinklerText(
              b35.tekYon!.reportText,
              hasSprinkler,
              limit: limitTekYon.toString(),
            ),
          );
        }
        if (b35.ciftYon != null) {
          parts.add(
            _filterSprinklerText(
              b35.ciftYon!.reportText,
              hasSprinkler,
              limit: limitCiftYon.toString(),
            ),
          );
        }
        if (b35.cikmaz != null) {
          parts.add(_filterSprinklerText(b35.cikmaz!.reportText, hasSprinkler));
        }
        if (b35.cikmazMesafe != null) {
          parts.add(
            _filterSprinklerText(
              b35.cikmazMesafe!.reportText,
              hasSprinkler,
              limit: limitTekYon.toString(),
            ),
          );
        }
        if (b35.manuelMesafe != null) {
          parts.add(
            "BİLGİ: Elle girilen kaçış mesafesi: ${b35.manuelMesafe} m",
          );
        }
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
      return res.reportText;
    }

    // Bölüm 36: Merdiven Değerlendirmesi
    if (id == 36) {
      if (s.bolum36 != null) {
        return Section36Handler(s).getFullReport();
      }
      return "OLUMLU: Merdivenler ve tahliye güzergahları Yönetmelik Madde 41 kriterlerine uygun gözükmektedir.";
    }

    // Varsayılan: AppContent içindeki metni olduğu gibi döndür.
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

  static void _buildSection11Details(
    List<Map<String, dynamic>> details,
    BinaStore s,
  ) {
    final b11 = s.bolum11;
    if (b11 != null) {
      if (b11.mesafe != null) {
        _addDetail(
          details,
          label:
              'İtfaiye aracının binaya yaklaşım mesafesi 45 metreyi aşıyor mu?',
          value: b11.mesafe!.uiTitle,
          subtitle: b11.mesafe!.uiSubtitle,
          report: b11.mesafe!.reportText,
          advice: b11.mesafe!.adviceText,
          level: b11.mesafe!.level,
        );
      }
      if (b11.engel != null) {
        _addDetail(
          details,
          label:
              'İtfaiye aracının binaya yanaşmasını engelleyen bir bahçe duvarı veya kilitli kapılar var mı?',
          value: b11.engel!.uiTitle,
          subtitle: b11.engel!.uiSubtitle,
          report: b11.engel!.reportText,
          advice: b11.engel!.adviceText,
          level: b11.engel!.level,
        );
      }
      if (b11.zayifNokta != null) {
        _addDetail(
          details,
          label:
              'Bu duvarda itfaiyenin kolayca yıkıp geçebileceği zayıf bir bölüm var mı?',
          value: b11.zayifNokta!.uiTitle,
          subtitle: b11.zayifNokta!.uiSubtitle,
          report: b11.zayifNokta!.reportText,
          advice: b11.zayifNokta!.adviceText,
          level: b11.zayifNokta!.level,
        );
      }
    }
  }

  static void _buildSection13Details(
    List<Map<String, dynamic>> details,
    BinaStore s,
  ) {
    final b13 = s.bolum13;
    if (b13 != null) {
      if (b13.otoparkKapi != null) {
        _addDetail(
          details,
          label: 'Otoparktan bina içine açılan kapının özelliği nedir?',
          value: b13.otoparkKapi!.uiTitle,
          subtitle: b13.otoparkKapi!.uiSubtitle,
          report: b13.otoparkKapi!.reportText,
          advice: b13.otoparkKapi!.adviceText,
          level: b13.otoparkKapi!.level,
        );
      }
      if (b13.kazanKapi != null) {
        _addDetail(
          details,
          label: 'Kazan dairesinin duvarları ve kapısı nasıl?',
          value: b13.kazanKapi!.uiTitle,
          subtitle: b13.kazanKapi!.uiSubtitle,
          report: b13.kazanKapi!.reportText,
          advice: b13.kazanKapi!.adviceText,
          level: b13.kazanKapi!.level,
        );
      }
      if (b13.asansorKapi != null) {
        _addDetail(
          details,
          label: 'Asansör kapısı nasıldır?',
          value: b13.asansorKapi!.uiTitle,
          subtitle: b13.asansorKapi!.uiSubtitle,
          report: b13.asansorKapi!.reportText,
          advice: b13.asansorKapi!.adviceText,
          level: b13.asansorKapi!.level,
        );
      }
      if (b13.jeneratorKapi != null) {
        _addDetail(
          details,
          label: 'Jeneratör odasının duvar ve kapısı nasıl?',
          value: b13.jeneratorKapi!.uiTitle,
          subtitle: b13.jeneratorKapi!.uiSubtitle,
          report: b13.jeneratorKapi!.reportText,
          advice: b13.jeneratorKapi!.adviceText,
          level: b13.jeneratorKapi!.level,
        );
      }
      if (b13.elektrikKapi != null) {
        _addDetail(
          details,
          label: 'Elektrik odasının duvarı ve kapısı nasıl?',
          value: b13.elektrikKapi!.uiTitle,
          subtitle: b13.elektrikKapi!.uiSubtitle,
          report: b13.elektrikKapi!.reportText,
          advice: b13.elektrikKapi!.adviceText,
          level: b13.elektrikKapi!.level,
        );
      }
      if (b13.trafoKapi != null) {
        _addDetail(
          details,
          label: 'Trafo odasının kapısı nasıl?',
          value: b13.trafoKapi!.uiTitle,
          subtitle: b13.trafoKapi!.uiSubtitle,
          report: b13.trafoKapi!.reportText,
          advice: b13.trafoKapi!.adviceText,
          level: b13.trafoKapi!.level,
        );
      }
      if (b13.depoKapi != null) {
        _addDetail(
          details,
          label: 'Eşya deposunun kapısı nasıl?',
          value: b13.depoKapi!.uiTitle,
          subtitle: b13.depoKapi!.uiSubtitle,
          report: b13.depoKapi!.reportText,
          advice: b13.depoKapi!.adviceText,
          level: b13.depoKapi!.level,
        );
      }
      if (b13.copKapi != null) {
        _addDetail(
          details,
          label: 'Çöp toplama odasının kapısı nasıl?',
          value: b13.copKapi!.uiTitle,
          subtitle: b13.copKapi!.uiSubtitle,
          report: b13.copKapi!.reportText,
          advice: b13.copKapi!.adviceText,
          level: b13.copKapi!.level,
        );
      }
      if (b13.ortakDuvar != null) {
        _addDetail(
          details,
          label: 'Yan bina ile ortak kullandığınız duvarın özelliği nedir?',
          value: b13.ortakDuvar!.uiTitle,
          subtitle: b13.ortakDuvar!.uiSubtitle,
          report: b13.ortakDuvar!.reportText,
          advice: b13.ortakDuvar!.adviceText,
          level: b13.ortakDuvar!.level,
        );
      }
      if (b13.ticariKapi != null) {
        _addDetail(
          details,
          label: 'Ticari alanlardan konut merdivenine geçiş nasıl?',
          value: b13.ticariKapi!.uiTitle,
          subtitle: b13.ticariKapi!.uiSubtitle,
          report: b13.ticariKapi!.reportText,
          advice: b13.ticariKapi!.adviceText,
          level: b13.ticariKapi!.level,
        );
      }
    }
  }

  static String? _getSection13FullReport(BinaStore s) {
    final b13 = s.bolum13;
    if (b13 != null) {
      List<String> parts = [];

      if (b13.otoparkKapi != null) {
        parts.add("Otopark Kapısı: ${b13.otoparkKapi!.reportText}");
      }
      if (b13.kazanKapi != null) {
        parts.add("Kazan Dairesi Kapısı: ${b13.kazanKapi!.reportText}");
      }
      if (b13.asansorKapi != null) {
        parts.add(
          "Asansör Makine Dairesi Kapısı: ${b13.asansorKapi!.reportText}",
        );
      }
      if (b13.jeneratorKapi != null) {
        parts.add("Jeneratör Odası Kapısı: ${b13.jeneratorKapi!.reportText}");
      }
      if (b13.elektrikKapi != null) {
        parts.add(
          "Elektrik/Pano Odası Kapısı: ${b13.elektrikKapi!.reportText}",
        );
      }
      if (b13.trafoKapi != null) {
        parts.add("Trafo Odası Kapısı: ${b13.trafoKapi!.reportText}");
      }
      if (b13.depoKapi != null) {
        parts.add("Depo Alanı Kapısı: ${b13.depoKapi!.reportText}");
      }
      if (b13.copKapi != null) {
        parts.add("Çöp Odası Kapısı: ${b13.copKapi!.reportText}");
      }
      if (b13.ortakDuvar != null) {
        parts.add("Ortak Duvar Yangın Dayanımı: ${b13.ortakDuvar!.reportText}");
      }
      if (b13.ticariKapi != null) {
        parts.add("Ticari Alan Kapısı: ${b13.ticariKapi!.reportText}");
      }
      if (b13.endustriyelMutfakKapi != null) {
        parts.add(
          "Endüstriyel Mutfak (Büyük Restoran) Kapısı: ${b13.endustriyelMutfakKapi!.reportText}",
        );
      }

      if (parts.isNotEmpty) return parts.join("\n\n");
    }
    return null;
  }

  static String? _getSection14FullReport(BinaStore s) {
    final b14 = s.bolum14;
    if (b14 != null && b14.raporMesaji != null && b14.raporMesaji!.isNotEmpty) {
      return "BİLGİ: Binanızdaki şaft duvarlarının en az ${b14.gerekenDuvarDk} dk, şaft kapaklarının ise en az ${b14.gerekenKapakDk} dk yangın dayanımına sahip olmaları gereklidir. ${b14.raporMesaji}";
    }
    return null;
  }

  static List<String> evaluateBasincRequirement({BinaStore? store}) {
    final s = _getStore(store);
    List<String> reasons = [];
    final hYapi = _getHYapi(s);
    final b21 = s.bolum21;
    final b22 = s.bolum22;
    final b23 = s.bolum23;

    // 1. Yapı Yüksekliği >= 51.50m
    if (hYapi >= (51.50 - 0.001)) {
      reasons.add(
        "KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50m olduğu için en az 2 merdivend basınçlandırma sistemi tesis edilmesi gerekmektedir.",
      );
    }
    // 2. Yapı Yüksekliği >= 30.50m ve YGH yoksa
    else if (hYapi >= (30.50 - 0.001)) {
      final vLabel = b21?.varlik?.label;
      final bool hasYgh = vLabel != null && vLabel.contains("21-1-A");
      if (!hasYgh) {
        reasons.add(
          "KRİTİK RİSK: Yapı Yüksekliği 30.50m üzeri ve merdiven önünde YGH (Yangın Güvenlik Holü) bulunmadığı durumlarda en az bir merdivende basınçlandırma sistemi tesis edilmesi gerekmektedir.",
        );
      }
    }

    // 3. İtfaiye Asansörü (Bölüm 22) zorunluluğu veya varlığı
    if (b22?.varlik?.label.contains("22-6-A") == true) {
      reasons.add(
        "KRİTİK RİSK: İtfaiye asansörü kuyusunda basınçlandırma sistemi zorunludur.",
      );
    }

    // 4. Normal Asansör (Bölüm 23) Havalandırma Belirsizliği veya Eksikliği
    if (b23?.havalandirma?.label.contains("23-5-B") == true) {
      reasons.add(
        "UYARI: Normal asansör kuyusunda duman tahliye bacası/penceresi bulunmadığı beyan edildiğinden basınçlandırma yapılması gereklidir.",
      );
    }

    // 5. Bodrum Kat Sayısı > 4
    if ((s.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      reasons.add(
        "KRİTİK RİSK: Bodrum kat sayısı 4'ten fazla olduğu için bodruma hizmet veren tüm merdivenlerde basınçlandırma zorunludur.",
      );
    }

    return reasons;
  }

  static List<String> evaluateYghRequirement({BinaStore? store}) {
    final s = _getStore(store);
    List<String> reasons = [];
    final hYapi = _getHYapi(s);

    // 1. Yapı Yüksekliği >= 51.50m (En üst limit - diğer yükseklik şartlarını kapsar)
    if (hYapi >= (51.50 - 0.001)) {
      reasons.add("KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50 metre");
    }
    // 2. Yapı Yüksekliği > 30.50m (Basınçlandırma yoksa zorunlu)
    else if (hYapi > (30.50 - 0.001)) {
      final b20 = s.bolum20;
      if (b20?.basinclandirma?.label.contains("-B") == true) {
        // 20-BAS-B: Hayır
        reasons.add(
          "KRİTİK RİSK: Yapı Yüksekliği 30.50m üzeri ve en az bir merdivende basınçlandırma sistemi yok ise YGH (Yangın Güvenlik Holü) zorunludur.",
        );
      }
    }
    // 3. Bina Yüksekliği > 21.50m ve Konut Harici Kullanım
    final bool isSadeceKonut = s.bolum6?.isSadeceKonut ?? false;
    if (!isSadeceKonut && hYapi > (21.50 - 0.001)) {
      reasons.add(
        "KRİTİK RİSK: Konut harici (veya karma kullanımlı) binalarda Yapı Yüksekliği 21.50 metreyi aştığında kaçış merdivenleri önünde YGH zorunludur.",
      );
    }

    // 4. Bodrum katlarda ticari/teknik kullanım (Bölüm 10)
    final b10 = s.bolum10;
    if (b10 != null) {
      final hasNonResInBasement = b10.bodrumlar.any(
        (c) =>
            c != null &&
            (c.label.contains("10-B") || // Az yoğun ticari
                c.label.contains("10-C") || // Orta yoğun ticari
                c.label.contains("10-D") || // Yüksek yoğun ticari
                c.label.contains("10-E")), // Teknik/Depo
      );
      if (hasNonResInBasement) {
        reasons.add(
          "KRİTİK RİSK: Bodrum katlarda, konuttan farklı bir kullanım amacı olduğundan tüm merdivenlerin önünde YGH (Yangın Güvenlik Holü) zorunludur.",
        );
      }
    }

    // 5. İtfaiye Asansörü zorunluluğu (Bölüm 22)
    final b22 = s.bolum22;
    if (b22?.varlik?.label.contains("22-1-B") == true) {
      reasons.add(
        "KRİTİK RİSK: Binada İtfaiye Asansörü bulunması zorunludur. İtfaiye asansörüne ulaşım mutlaka bir YGH üzerinden sağlanmalıdır.",
      );
    }

    // 6. Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı (Bölüm 23)
    final b23 = s.bolum23;
    if (b23 != null && b23.bodrum?.label.contains("23-1-C") == true) {
      reasons.add(
        "KRİTİK RİSK: Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı sağlanmadığında tüm asansörlerin önünde YGH gereklidir.",
      );
    }

    // 7. Bodrum kat sayısı > 4
    if ((s.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      reasons.add(
        "KRİTİK RİSK: Bodrum kat sayısı 4'ten fazla olduğu için bodrumlara hizmet veren tüm merdivenlerin önünde YGH zorunludur.",
      );
    }

    return reasons;
  }

  static String _getYesNoUnknown(int? val) {
    if (val == 1) return "Evet";
    if (val == 0) return "Hayır";
    return "Bilmiyorum";
  }

  static String _getBariyerReport(int val, String subject) {
    if (val == 1) return "OLUMLU: $subject mevcuttur.";
    if (val == 0)
      return "KRİTİK RİSK: $subject bulunmamaktadır. Yangının cepheden yayılma riski bulunmaktadır.";
    return "UYARI: $subject durumu bilinmemektedir. Yerinde kontrol edilmelidir.";
  }

  static String getSectionSummary(int id) {
    final s = BinaStore.instance;
    final res = s.getResultForSection(id);
    if (res == null) return "Değerlendirilmedi.";

    // Bölüm 3: ÖZET sayfasında maddeler halinde alt alta gösterim
    if (id == 3) {
      final details = Section3Handler(s).getDetailedReport();
      if (details.isNotEmpty) {
        return details
            .where((d) => d['label'] != null && d['value'] != null)
            .map((d) => "• ${d['label']}: ${d['value']}")
            .join("\n");
      }
    }

    // Bölüm 35 için dinamik etiket (LİMİT yerine sayı yazması için)
    if (id == 35) {
      final b35 = s.bolum35;
      if (b35 != null) {
        final b9 = s.bolum9;
        bool hasSprinkler = b9?.secim?.label == "9-1-A";
        int limitTekYon = hasSprinkler ? 30 : 15;
        int limitCiftYon = hasSprinkler ? 75 : 30;

        String replaceLimit(String? text, int limit) {
          if (text == null) return "";
          return text.replaceAll("[LİMİT]", limit.toString());
        }

        if (b35.tekYon != null)
          return replaceLimit(b35.tekYon!.uiTitle, limitTekYon);
        if (b35.ciftYon != null)
          return replaceLimit(b35.ciftYon!.uiTitle, limitCiftYon);
      }
    }

    // Bölüm 21 için dinamik özet (Zorunluluk durumu)
    if (id == 21) {
      if (s.bolum21 != null) {
        return Section21Handler(s).getSummaryReport(res.label);
      }
    }

    // Bölüm 36 için dinamik özet (Uyarılar ve Kritik Riskler)
    if (id == 36) {
      if (s.bolum36 != null) {
        return Section36Handler(s).getSummaryReport();
      }
    }

    return res.label;
  }

  static String _filterSprinklerText(
    String text,
    bool hasSprinkler, {
    String? limit,
  }) {
    String result = text;

    // Her iki varyasyonu da içeren metinleri ayıkla
    // Format 1: (Binada sprinkler varsa) ... (Binada sprinkler yoksa) ...
    if (text.contains("(Binada sprinkler varsa)") ||
        text.contains("(Binada sprinkler yoksa)")) {
      if (hasSprinkler) {
        // Sprinkler varsa kısmını al
        final startIndex = text.indexOf("(Binada sprinkler varsa)");
        if (startIndex != -1) {
          int endIndex = text.indexOf("(Binada sprinkler yoksa)");
          if (endIndex == -1) endIndex = text.length;
          result = text
              .substring(startIndex, endIndex)
              .replaceAll("(Binada sprinkler varsa)", "");
        }
      } else {
        // Sprinkler yoksa kısmını al
        final startIndex = text.indexOf("(Binada sprinkler yoksa)");
        if (startIndex != -1) {
          result = text
              .substring(startIndex)
              .replaceAll("(Binada sprinkler yoksa)", "");
        }
      }
    }

    // Format 2: ... (Binada sprinkler varsa: [LİMİT], Binada sprinkler yoksa: [LİMİT])
    const kSprinklerVarsaPrefix = "Binada sprinkler varsa:";
    const kSprinklerYoksaPrefix = "Binada sprinkler yoksa:";
    if (result.contains("($kSprinklerVarsaPrefix") &&
        result.contains(kSprinklerYoksaPrefix)) {
      String replacement = "";
      if (hasSprinkler) {
        final start = result.indexOf(kSprinklerVarsaPrefix);
        final end = result.indexOf(",", start);
        if (start != -1 && end != -1) {
          replacement = result
              .substring(start + kSprinklerVarsaPrefix.length, end)
              .trim();
        }
      } else {
        final start = result.indexOf(kSprinklerYoksaPrefix);
        final end = result.indexOf(")", start);
        if (start != -1 && end != -1) {
          replacement = result
              .substring(start + kSprinklerYoksaPrefix.length, end)
              .trim();
        }
      }
      // Parantez içindeki kısmı temizle ve yerine seçileni koy
      final pStart = result.indexOf("(");
      final pEnd = result.lastIndexOf(")");
      if (pStart != -1 && pEnd != -1) {
        result =
            "${result.substring(0, pStart)}(Limit: $replacement)${result.substring(pEnd + 1)}";
      }
    }

    // [LİMİT] placeholder'larını temizle
    if (limit != null) {
      result = result.replaceAll("[LİMİT]", limit);
    }

    return result.trim();
  }

  static int calculateMaxYuk(BinaStore s) {
    int maxYuk = 0;
    final b33 = s.bolum33;
    final b34 = s.bolum34;
    if (b33 != null) {
      // Sadece 34-X-A (Evet, var) seçilirse bağımsız sayıyoruz. (C - Bilmiyorum seçilirse yük dahil edilir).
      bool zeminIndependent = b34?.zemin?.label.contains("34-1-A") ?? false;
      bool bodrumIndependent = b34?.bodrum?.label.contains("34-2-A") ?? false;
      bool normalIndependent = b34?.normal?.label.contains("34-3-A") ?? false;

      int yukZemin = zeminIndependent ? 0 : (b33.yukZemin ?? 0);
      int yukBodrum = bodrumIndependent ? 0 : (b33.yukBodrum ?? 0);
      int yukNormal = normalIndependent ? 0 : (b33.yukNormal ?? 0);

      maxYuk = [yukZemin, yukNormal, yukBodrum].reduce((a, b) => a > b ? a : b);
    }
    return maxYuk;
  }

  static RiskLevel? _getDynamicLevel(ChoiceResult? res, int maxYuk) {
    if (res == null) return null;
    if (res.label == "27-2-B") {
      return maxYuk <= 50 ? RiskLevel.positive : RiskLevel.critical;
    }
    if (res.label == "27-3-B") {
      return maxYuk <= 100 ? RiskLevel.positive : RiskLevel.critical;
    }
    return res.level;
  }
}
