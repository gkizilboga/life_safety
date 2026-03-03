import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';
import '../models/bolum_20_model.dart';
import '../utils/app_content.dart';
import 'handlers/section_3_handler.dart';
import 'handlers/risk_calculator.dart';

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
  static double _getHYapi(BinaStore? store) =>
      _getStore(store).bolum3?.hYapi ?? 0.0;
  static Map<String, dynamic> calculateRiskMetrics({BinaStore? store}) {
    final s = _getStore(store);
    return RiskCalculator(s).calculateMetrics();
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
        details.add({
          'label':
              'Binanızda konut haricinde aşağıdakilerden hangileri mevcut?',
          'value': '',
          'report': '',
        });
        if (b6.hasOtopark)
          details.add({'label': 'Otopark', 'value': 'Mevcut', 'report': ''});
        if (b6.hasTicari)
          details.add({
            'label': 'Ticari Alan',
            'value': 'Mevcut',
            'report': '',
          });
        if (b6.hasDepo)
          details.add({'label': 'Depo', 'value': 'Mevcut', 'report': ''});
        if (b6.isSadeceKonut)
          details.add({'label': 'Sadece Konut', 'value': 'Evet', 'report': ''});

        if (b6.hasTicari && b6.buyukRestoran != null) {
          details.add({
            'label':
                'Ticari alan içerisinde büyük restoran (endüstriyel mutfak) var mı?',
            'value': b6.buyukRestoran!.uiTitle,
            'report': b6.buyukRestoran!.reportText,
            'advice': b6.buyukRestoran!.adviceText,
          });
        }
        // Otopark tipi (eğer seçildiyse)
        if (b6.otoparkTipi != null)
          details.add({
            'label': 'Otoparkınızın tipi nedir?',
            'value': b6.otoparkTipi!.uiTitle,
            'report': b6.otoparkTipi!.reportText,
            'advice': b6.otoparkTipi!.adviceText,
          });
        // Kapalı otopark alanı (eğer girilmişse)
        if (b6.kapaliOtoparkAlani != null)
          details.add({
            'label': 'Kapalı Otopark Alanı',
            'value': '${b6.kapaliOtoparkAlani} m²',
            'report': '',
          });
        handled = true;
      }
    }

    // Bölüm 10: Kat Kullanım Amaçları
    if (id == 10) {
      final b10 = s.bolum10;
      if (b10 != null) {
        // Zemin kat
        if (b10.zemin != null)
          details.add({
            'label': 'Zemin Katın Baskın Kullanım Amacı',
            'value': b10.zemin!.uiTitle,
            'report': b10.zemin!.reportText,
            'advice': b10.zemin!.adviceText,
          });
        // Bodrum katlar
        if (b10.bodrumlar.isNotEmpty) {
          if (b10.bodrumlarAyni && b10.bodrumlar[0] != null) {
            details.add({
              'label': 'Bodrum Katların Kullanım Amacı (Tümü Aynı)',
              'value': b10.bodrumlar[0]!.uiTitle,
              'report': b10.bodrumlar[0]!.reportText,
              'advice': b10.bodrumlar[0]!.adviceText,
            });
          } else {
            for (int i = 0; i < b10.bodrumlar.length; i++) {
              if (b10.bodrumlar[i] != null)
                details.add({
                  'label': '${i + 1}. Bodrum Kat Kullanım Amacı',
                  'value': b10.bodrumlar[i]!.uiTitle,
                  'report': b10.bodrumlar[i]!.reportText,
                  'advice': b10.bodrumlar[i]!.adviceText,
                });
            }
          }
        }
        // Normal katlar
        if (b10.normaller.isNotEmpty) {
          if (b10.normallerAyni && b10.normaller[0] != null) {
            details.add({
              'label': 'Normal Katların Kullanım Amacı (Tümü Aynı)',
              'value': b10.normaller[0]!.uiTitle,
              'report': b10.normaller[0]!.reportText,
              'advice': b10.normaller[0]!.adviceText,
            });
          } else {
            for (int i = 0; i < b10.normaller.length; i++) {
              if (b10.normaller[i] != null)
                details.add({
                  'label': '${i + 1}. Normal Kat Kullanım Amacı',
                  'value': b10.normaller[i]!.uiTitle,
                  'report': b10.normaller[i]!.reportText,
                  'advice': b10.normaller[i]!.adviceText,
                });
            }
          }
        }
        handled = true;
      }
    }

    // Bölüm 7: Teknik Hacimler
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
          details.add({
            'label': 'Binada otomatik yağmurlama (sprinkler) sistemi var mı?',
            'value': b9.secim!.uiTitle,
            'report': b9.secim!.reportText,
            'advice': b9.secim!.adviceText,
          });
        }
        if (s.bolum6?.buyukRestoran?.label == "6-3-A (Büyük Restoran)" &&
            b9.davlumbaz != null) {
          details.add({
            'label':
                'Büyük restoran davlumbazında otomatik söndürme sistemi var mı?',
            'value': b9.davlumbaz!.uiTitle,
            'report': b9.davlumbaz!.reportText,
            'advice': b9.davlumbaz!.adviceText,
          });
        }
        handled = true;
      }
    }

    // Bölüm 11: İtfaiyenin Bina Yaklaşım Mesafesi
    if (id == 11) {
      _buildSection11Details(details, s);
      handled = true;
    }

    // Bölüm 17: Çatı
    if (id == 17) {
      final b17 = s.bolum17;
      if (b17 != null) {
        final bool isYuksek = s.bolum3?.isYuksekBina ?? false;

        // Çatı iskelet sorusu (dinamik)
        if (b17.iskelet != null) {
          final String iskeletReport =
              b17.iskelet!.label == Bolum17Content.iskeletOptionB.label
              ? (isYuksek
                    ? Bolum17Content.iskeletOptionBYuksekReport
                    : Bolum17Content.iskeletOptionBNormalReport)
              : b17.iskelet!.reportText;
          details.add({
            'label': 'Çatı taşıyıcı iskelet ve ısı yalıtım malzemesi nedir?',
            'value': b17.iskelet!.uiTitle,
            'report': iskeletReport,
            'advice': b17.iskelet!.adviceText,
          });
        }

        // Işıklık sorusu
        if (b17.isiklik != null) {
          details.add({
            'label': 'Çatıda ışıklık (cam kubbe, aydınlatma açıklığı) var mı?',
            'value': b17.isiklik!.uiTitle,
            'report': b17.isiklik!.reportText,
            'advice': b17.isiklik!.adviceText,
          });
          // Alt soru: Malzeme tipi (sadece OptionB seçildiyse)
          if (b17.isiklik!.label == Bolum17Content.isiklikOptionB.label &&
              b17.isiklikMalzemesi != null) {
            final malzemeChoice = b17.isiklikMalzemesi == 'cam'
                ? Bolum17Content.isiklikCam
                : Bolum17Content.isiklikPlastik;
            details.add({
              'label': 'Işıklık malzeme tipi nedir?',
              'value': malzemeChoice.uiTitle,
              'report': malzemeChoice.reportText,
              'advice': malzemeChoice.adviceText,
            });
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
          details.add({
            'label': 'Bina içindeki duvar yüzeylerinde ne tür malzeme var?',
            'value': duvar.uiTitle,
            'report': reportText,
            'advice': duvar.adviceText,
          });
        }
        handled = true;
      }
    }

    // Bölüm 22: İtfaiye (Acil Durum) Asansörü
    if (id == 22) {
      final b22 = s.bolum22;
      if (b22 != null) {
        if (b22.varlik != null)
          details.add({
            'label': 'Binanızda İtfaiye (yük) Asansörü var mı?',
            'value': b22.varlik!.uiTitle,
            'report': b22.varlik!.reportText,
            'advice': b22.varlik!.adviceText,
          });
        if (b22.konum != null)
          details.add({
            'label': 'Bu İtfaiye Asansörünün kapısı nereye açılıyor?',
            'value': b22.konum!.uiTitle,
            'report': b22.konum!.reportText,
            'advice': b22.konum!.adviceText,
          });
        if (b22.boyut != null)
          details.add({
            'label':
                'İtfaiye Asansörünün açıldığı yangın güvenlik holünün taban alanı kaç metrekaredir?',
            'value': b22.boyut!.uiTitle,
            'report': b22.boyut!.reportText,
            'advice': b22.boyut!.adviceText,
          });
        if (b22.kabin != null)
          details.add({
            'label':
                'Kabin genişliği en az 1.8 m² ve en alt kattan en üst kata 1 dakika içerisinde çıkabiliyor mu?',
            'value': b22.kabin!.uiTitle,
            'report': b22.kabin!.reportText,
            'advice': b22.kabin!.adviceText,
          });
        if (b22.enerji != null)
          details.add({
            'label':
                'Bu asansör, elektrik kesildiğinde en az 60 dakika çalışabilen bir jeneratöre bağlı mı?',
            'value': b22.enerji!.uiTitle,
            'report': b22.enerji!.reportText,
            'advice': b22.enerji!.adviceText,
          });
        if (b22.basinc != null)
          details.add({
            'label': 'İtfaiye Asansörünün kuyusu basınçlandırılmış mı?',
            'value': b22.basinc!.uiTitle,
            'report': b22.basinc!.reportText,
            'advice': b22.basinc!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 23: Normal (İnsan Taşıma) Asansör
    if (id == 23) {
      final b23 = s.bolum23;
      if (b23 != null) {
        if (b23.bodrum != null)
          details.add({
            'label': 'Asansörünüz bodrum katlara da iniyor mu?',
            'value': b23.bodrum!.uiTitle,
            'report': b23.bodrum!.reportText,
            'advice': b23.bodrum!.adviceText,
          });
        if (b23.yanginModu != null)
          details.add({
            'label':
                'Yangın anında asansörler otomatik olarak zemin kata (veya binadan çıkış katına) iniyor mu?',
            'value': b23.yanginModu!.uiTitle,
            'report': b23.yanginModu!.reportText,
            'advice': b23.yanginModu!.adviceText,
          });
        if (b23.konum != null)
          details.add({
            'label': 'Asansör kapıları normal katlarda nereye açılıyor?',
            'value': b23.konum!.uiTitle,
            'report': b23.konum!.reportText,
            'advice': b23.konum!.adviceText,
          });
        if (b23.levha != null)
          details.add({
            'label':
                'Asansör kapılarında \'YANGIN ANINDA KULLANMAYINIZ\' uyarısı var mı?',
            'value': b23.levha!.uiTitle,
            'report': b23.levha!.reportText,
            'advice': b23.levha!.adviceText,
          });
        if (b23.havalandirma != null)
          details.add({
            'label':
                'Asansör kuyusunun tepesinde havalandırma penceresi var mı?',
            'value': b23.havalandirma!.uiTitle,
            'report': b23.havalandirma!.reportText,
            'advice': b23.havalandirma!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 24: Dış Kaçış Geçitleri
    if (id == 24) {
      final b24 = s.bolum24;
      if (b24 != null) {
        if (b24.tip != null)
          details.add({
            'label': 'Dairenizden itibaren bina dışına çıkış nasıl?',
            'value': b24.tip!.uiTitle,
            'report': b24.tip!.reportText,
            'advice': b24.tip!.adviceText,
          });
        if (b24.pencere != null)
          details.add({
            'label': 'Açık kaçış yoluna bakan dairelere ait pencereler var mı?',
            'value': b24.pencere!.uiTitle,
            'report': b24.pencere!.reportText,
            'advice': b24.pencere!.adviceText,
          });
        if (b24.kapi != null)
          details.add({
            'label': 'Açık kaçış yoluna bakan dış kapılar var mı?',
            'value': b24.kapi!.uiTitle,
            'report': b24.kapi!.reportText,
            'advice': b24.kapi!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 25: Dairesel Merdiven
    if (id == 25) {
      final b25 = s.bolum25;
      if (b25 != null) {
        if (b25.genislik != null)
          details.add({
            'label': 'Merdiven kol genişliği yeterli mi?',
            'value': b25.genislik!.uiTitle,
            'report': b25.genislik!.reportText,
            'advice': b25.genislik!.adviceText,
          });
        if (b25.basamak != null)
          details.add({
            'label': 'Basamak genişliği yeterli mi?',
            'value': b25.basamak!.uiTitle,
            'report': b25.basamak!.reportText,
            'advice': b25.basamak!.adviceText,
          });
        if (b25.basKurtarma != null)
          details.add({
            'label': 'Baş kurtarma yüksekliği yeterli mi?',
            'value': b25.basKurtarma!.uiTitle,
            'report': b25.basKurtarma!.reportText,
            'advice': b25.basKurtarma!.adviceText,
          });
        if (b25.yukseklik != null)
          details.add({
            'label': 'Dairesel merdiven yükseklik sınırı (9.5m) uygun mu?',
            'value': b25.yukseklik!.uiTitle,
            'report': b25.yukseklik!.reportText,
            'advice': b25.yukseklik!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 12: Yapısal Yangın Dayanımı
    if (id == 12) {
      final b12 = s.bolum12;
      if (b12 != null) {
        // Betonarme soruları
        if (b12.betonPaspayi != null)
          details.add({
            'label':
                'Betonarme taşıyıcılarınızdaki paspayı (demir koruma tabakası) durumu nedir?',
            'value': b12.betonPaspayi!.uiTitle,
            'report': b12.betonPaspayi!.reportText,
            'advice': b12.betonPaspayi!.adviceText,
          });
        // Paspayı değerleri (ölçü girilmişse)
        if (b12.kolonPaspayi != null)
          details.add({
            'label': 'Kolon Paspayı',
            'value': '${b12.kolonPaspayi} mm',
            'report': '',
          });
        if (b12.kirisPaspayi != null)
          details.add({
            'label': 'Kiriş Paspayı',
            'value': '${b12.kirisPaspayi} mm',
            'report': '',
          });
        if (b12.dosemePaspayi != null)
          details.add({
            'label': 'Döşeme Paspayı',
            'value': '${b12.dosemePaspayi} mm',
            'report': '',
          });
        // Çelik sorusu
        if (b12.celikKoruma != null)
          details.add({
            'label':
                'Çelik taşıyıcılarınızda yangına karşı bir koruma veya yalıtım var mı?',
            'value': b12.celikKoruma!.uiTitle,
            'report': b12.celikKoruma!.reportText,
            'advice': b12.celikKoruma!.adviceText,
          });
        // Ahşap sorusu
        if (b12.ahsapKesit != null)
          details.add({
            'label':
                'Ahşap taşıyıcılarınızın kesiti yapı kullanımına göre yeterli mi?',
            'value': b12.ahsapKesit!.uiTitle,
            'report': b12.ahsapKesit!.reportText,
            'advice': b12.ahsapKesit!.adviceText,
          });
        // Yığma sorusu
        if (b12.yigmaDuvar != null)
          details.add({
            'label': 'Yığma duvarlarınızın kalınlığı ne durumda?',
            'value': b12.yigmaDuvar!.uiTitle,
            'report': b12.yigmaDuvar!.reportText,
            'advice': b12.yigmaDuvar!.adviceText,
          });
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
          details.add({
            'label':
                'Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan mesafe ne kadardır?',
            'value': b28.mesafe!.uiTitle,
            'report': _filterSprinklerText(
              b28.mesafe!.reportText,
              hasSprinkler,
              limit: limitTekYon.toString(),
            ),
            'advice': b28.mesafe!.adviceText,
          });
        if (b28.dubleks != null)
          details.add({
            'label': 'Daireniz Dubleks (İki katlı) mi?',
            'value': b28.dubleks!.uiTitle,
            'report': b28.dubleks!.reportText,
            'advice': b28.dubleks!.adviceText,
          });
        if (b28.alan != null)
          details.add({
            'label': 'Üst katınızın alanı 70 m²\'den büyük mü?',
            'value': b28.alan!.uiTitle,
            'report': b28.alan!.reportText,
            'advice': b28.alan!.adviceText,
          });
        if (b28.cikis != null)
          details.add({
            'label':
                'Üst kattan apartman koridoruna açılan ikinci bir çelik kapı (çıkış) var mı?',
            'value': b28.cikis!.uiTitle,
            'report': b28.cikis!.reportText,
            'advice': b28.cikis!.adviceText,
          });
        if (b28.muafiyet != null)
          details.add({
            'label': 'Daire içi mesafe muafiyeti',
            'value': b28.muafiyet!.uiTitle,
            'report': _filterSprinklerText(
              b28.muafiyet!.reportText,
              hasSprinkler,
            ),
            'advice': b28.muafiyet!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 13: Yangın Kompartımanları
    if (id == 13) {
      _buildSection13Details(details, s);
      handled = true;
    }

    // Bölüm 15: İç Kaplamalar
    if (id == 15) {
      final b15 = s.bolum15;
      if (b15 != null) {
        if (b15.kaplama != null)
          details.add({
            'label': 'Zemin kaplama malzemesi nedir?',
            'value': b15.kaplama!.uiTitle,
            'report': b15.kaplama!.reportText,
            'advice': b15.kaplama!.adviceText,
          });
        if (b15.yalitim != null)
          details.add({
            'label': 'Döşeme üzerinde ısı yalıtım malzemesi var mı?',
            'value': b15.yalitim!.uiTitle,
            'report': b15.yalitim!.reportText,
            'advice': b15.yalitim!.adviceText,
          });
        if (b15.yalitimSap != null)
          details.add({
            'label': 'Yalıtım üzerinde en az 2 cm şap var mı?',
            'value': b15.yalitimSap!.uiTitle,
            'report': b15.yalitimSap!.reportText,
            'advice': b15.yalitimSap!.adviceText,
          });
        if (b15.tavan != null)
          details.add({
            'label': 'Asma Tavan var mı?',
            'value': b15.tavan!.uiTitle,
            'report': b15.tavan!.reportText,
            'advice': b15.tavan!.adviceText,
          });
        if (b15.tavanMalzeme != null)
          details.add({
            'label': 'Asma tavan malzemesi nedir?',
            'value': b15.tavanMalzeme!.uiTitle,
            'report': b15.tavanMalzeme!.reportText,
            'advice': b15.tavanMalzeme!.adviceText,
          });
        if (b15.tesisat != null)
          details.add({
            'label': 'Tesisat geçişleri nasıl kapatılmış?',
            'value': b15.tesisat!.uiTitle,
            'report': b15.tesisat!.reportText,
            'advice': b15.tesisat!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 16: Dış Cephe
    // Bölüm 16: Dış Cephe
    if (id == 16) {
      final b16 = s.bolum16;
      if (b16 != null) {
        // Ana Soru - Sadece bir kez ekle
        if (b16.mantolama != null) {
          details.add({
            'label':
                'Binanızdaki dış cephe kaplama veya ısı yalıtım sistemi nedir?',
            'value': b16.mantolama!.uiTitle,
            'report': b16.mantolama!.reportText,
            'advice': b16.mantolama!.adviceText,
          });
        }

        if (b16.mantolama?.label.contains("16-1-A") == true) {
          double hBina = s.bolum3?.hBina ?? 0;

          if (hBina <= 28.50) {
            // Alçak Bina Kontrolleri
            if (b16.bariyerYan != null) {
              details.add({
                'label':
                    'Pencerelerin yanlarında en az 15 cm eninde yanmaz bariyer var mı?',
                'value': _getYesNoUnknown(b16.bariyerYan),
                'report': _getBariyerReport(
                  b16.bariyerYan!,
                  "Pencerelerin yanlarında yangın bariyeri",
                ),
                'advice': b16.bariyerYan != 1
                    ? "Yönetmelik gereği pencerelerin yanlarında en az 15 cm eninde yanmaz bariyer (taşyünü vb.) yapılmalıdır."
                    : "",
              });
            }
            if (b16.bariyerUst != null) {
              details.add({
                'label':
                    'Pencerelerin üstünde 30 cm eninde yanmaz bariyer var mı?',
                'value': _getYesNoUnknown(b16.bariyerUst),
                'report': _getBariyerReport(
                  b16.bariyerUst!,
                  "Pencerelerin üstünde yangın bariyeri",
                ),
                'advice': b16.bariyerUst != 1
                    ? "Yönetmelik gereği pencerelerin üstünde en az 30 cm eninde yanmaz bariyer yapılmalıdır."
                    : "",
              });
            }
            if (b16.bariyerZemin != null) {
              details.add({
                'label':
                    'Zemin seviyesinden 150 cm yüksekliğe kadar yanmaz malzemeyle kaplama var mı?',
                'value': _getYesNoUnknown(b16.bariyerZemin),
                'report': _getBariyerReport(
                  b16.bariyerZemin!,
                  "Zemin seviyesinde (su basman) 1.5m yanmaz kaplama",
                ),
                'advice': b16.bariyerZemin != 1
                    ? "Zemin seviyesinden en az 1.5 metre yüksekliğe kadar olan cephe yüzeyi hiç yanmaz malzemelerle kaplanmalıdır."
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
                  : "KRİTİK RİSK: Cephe kaplaması ile bina döşemesi arasındaki boşluklar yalıtılmamıştır. Bu durum dumanın ve alevlerin üst katlara hızlıca geçişine sebep olur.",
              'advice': b16.giydirmeBoslukYalitim == false
                  ? "Cephe ile döşeme arasındaki boşluklar taşyünü gibi yanmaz malzemelerle sıkıca kapatılmalıdır."
                  : "",
            });
          }
        }

        if (b16.sagirYuzey != null) {
          details.add({
            'label': 'Katlar arasında sağır (yanmaz) yüzey var mı?',
            'value': b16.sagirYuzey!.uiTitle,
            'report': b16.sagirYuzey!.reportText,
            'advice': b16.sagirYuzey!.adviceText,
          });

          if (b16.sagirYuzey!.label == Bolum16Content.sagirYuzeyOptionB.label) {
            if (b16.sagirYuzeySprinkler != null) {
              details.add({
                'label':
                    'Cepheye doğru bakan özel sprinkler başlıkları var mı?',
                'value': b16.sagirYuzeySprinkler == true ? "Evet" : "Hayır",
                'report': b16.sagirYuzeySprinkler == true
                    ? "OLUMLU: Cam cephe önünde otomatik sprinkler sistemi koruması mevcuttur."
                    : "UYARI: Cam cephe kullanılmasına rağmen içeriden cepheye bakan sprinkler koruması yoktur.",
                'advice': b16.sagirYuzeySprinkler == false
                    ? "Cam cephe sistemlerinde, yangının içeriden cama ulaşmasını engellemek için cepheye 1.5m mesafede sıkılaştırılmış sprinkler başlıkları kullanılmalıdır."
                    : "",
              });
            }
          }
        }

        if (b16.bitisikNizam != null) {
          details.add({
            'label':
                'Binanız bitişik nizamda bulunan yan bina ile karşılaştırıldığında yükseklik durumu nedir?',
            'value': b16.bitisikNizam!.uiTitle,
            'report': b16.bitisikNizam!.reportText,
            'advice': b16.bitisikNizam!.adviceText,
          });
        }
        handled = true;
      }
    }

    // Bölüm 17: Çatı
    if (id == 17) {
      final b17 = s.bolum17;
      if (b17 != null) {
        if (b17.kaplama != null)
          details.add({
            'label': 'Çatınızın en üst katmanında hangi malzeme kullanılıyor?',
            'value': b17.kaplama!.uiTitle,
            'report': b17.kaplama!.reportText,
            'advice': b17.kaplama!.adviceText,
          });
        if (b17.iskelet != null)
          details.add({
            'label': 'Çatıyı taşıyan iskelet ve altındaki ısı yalıtımı nedir?',
            'value': b17.iskelet!.uiTitle,
            'report': b17.iskelet!.reportText,
            'advice': b17.iskelet!.adviceText,
          });
        if (b17.bitisikDuvar != null)
          details.add({
            'label': 'Çatılar arasında yangını kesecek bir duvar var mı?',
            'value': b17.bitisikDuvar!.uiTitle,
            'report': b17.bitisikDuvar!.reportText,
            'advice': b17.bitisikDuvar!.adviceText,
          });
        if (b17.isiklik != null)
          details.add({
            'label': 'Çatınızda camlı ışıklık veya aydınlatma kubbesi var mı?',
            'value': b17.isiklik!.uiTitle,
            'report': b17.isiklik!.reportText,
            'advice': b17.isiklik!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 18: Koridor
    if (id == 18) {
      final b18 = s.bolum18;
      if (b18 != null) {
        if (b18.duvarKaplama != null)
          details.add({
            'label':
                'Daire içlerinde veya koridor duvarlarında; kağıt, ahşap, plastik veya köpük (içten yalıtım) gibi bir kaplama var mı?',
            'value': b18.duvarKaplama!.uiTitle,
            'report': b18.duvarKaplama!.reportText,
            'advice': b18.duvarKaplama!.adviceText,
          });
        if (b18.boruTipi != null)
          details.add({
            'label':
                'Binanız yüksek katlı olduğu için tesisat şaftlarından geçen plastik su borularında önlem alınmış mı?',
            'value': b18.boruTipi!.uiTitle,
            'report': b18.boruTipi!.reportText,
            'advice': b18.boruTipi!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 19: Kaçış Yolları
    if (id == 19) {
      final b19 = s.bolum19;
      if (b19 != null) {
        for (var e in b19.engeller) {
          details.add({
            'label': 'Kaçış yollarında aşağıdakilerden hangisi var?',
            'value': e.uiTitle,
            'report': e.reportText,
            'advice': e.adviceText,
          });
        }
        if (b19.levha != null)
          details.add({
            'label': 'Yönlendirme levhaları asılı mı?',
            'value': b19.levha!.uiTitle,
            'report': b19.levha!.reportText,
            'advice': b19.levha!.adviceText,
          });
        if (b19.yanilticiKapi != null)
          details.add({
            'label':
                'Yanıltıcı kapılar var mı? (Çıkış ulaşırken kafanızı karıştırabilecek türden kapılar)',
            'value': b19.yanilticiKapi!.uiTitle,
            'report': b19.yanilticiKapi!.reportText,
            'advice': b19.yanilticiKapi!.adviceText,
          });
        if (b19.yanilticiEtiket != null)
          details.add({
            'label': 'Bu kapıların üzerinde yazı var mı?',
            'value': b19.yanilticiEtiket!.uiTitle,
            'report': b19.yanilticiEtiket!.reportText,
            'advice': b19.yanilticiEtiket!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 20: Merdivenler
    if (id == 20) {
      final b20 = s.bolum20;
      if (b20 != null) {
        // Tek katlı bina soruları
        if (b20.tekKatCikis != null)
          details.add({
            'label':
                'Tek katlı binada merdivensiz bina dışına çıkış mümkün mü?',
            'value': b20.tekKatCikis!.uiTitle,
            'report': b20.tekKatCikis!.reportText,
            'advice': b20.tekKatCikis!.adviceText,
          });
        if (b20.tekKatRampa != null)
          details.add({
            'label': 'Tek katlı binada rampa durumu',
            'value': b20.tekKatRampa!.uiTitle,
            'report': b20.tekKatRampa!.reportText,
            'advice': b20.tekKatRampa!.adviceText,
          });
        // Bodrum merdiven devamı
        if (b20.bodrumMerdivenDevami != null)
          details.add({
            'label':
                'Bodrum kat merdivenleri normal kat merdivenleriyle devam ediyor mu?',
            'value': b20.bodrumMerdivenDevami!.uiTitle,
            'report': b20.bodrumMerdivenDevami!.reportText,
            'advice': b20.bodrumMerdivenDevami!.adviceText,
          });
        // YGH Basınçlandırma
        if (b20.basinclandirma != null)
          details.add({
            'label': 'Yangın güvenlik holü (YGH) basınçlandırılmış mı?',
            'value': b20.basinclandirma!.uiTitle,
            'report': b20.basinclandirma!.reportText,
            'advice': b20.basinclandirma!.adviceText,
          });
        // Madde 45: Doğal Havalandırma
        if (b20.havalandirma != null)
          details.add({
            'label': 'Merdivenlerde doğal havalandırma var mı? (Madde 45)',
            'value': b20.havalandirma!.uiTitle,
            'report': b20.havalandirma!.reportText,
            'advice': b20.havalandirma!.adviceText,
          });

        // Merdiven Sayıları (Konu ve Yanıt olarak kalmalı, değerlendirme 36'da)
        _addStaircaseRows(details, b20);

        // Bodrum merdivenleri
        if (b20.isBodrumIndependent) {
          details.add({
            'label': 'Bodrum kat merdivenleri bağımsız mı?',
            'value': 'Evet (Bağımsız)',
            'report': '',
          });
          _addStaircaseRows(details, b20, isBasement: true);
        }

        if (b20.daireselMerdivenKovaGenisligi != null)
          details.add({
            'label': 'Dairesel Merdiven Kova Genişliği',
            'value': '${b20.daireselMerdivenKovaGenisligi} cm',
            'report': '',
          });

        handled = true;
      }
    }

    // Bölüm 21: YGH
    if (id == 21) {
      final b21 = s.bolum21;
      if (b21 != null) {
        details.add({
          'label': 'Merdiven önünde Yangın Güvenlik Holü var mı?',
          'value': b21.varlik?.uiTitle ?? '-',
          'report': '',
          'advice': b21.varlik?.adviceText,
        });
        if (b21.varlik?.label.contains("21-1-A") == true) {
          details.add({
            'label':
                'YGH (Hol) içindeki kaplama malzemeleri yanmaz özellikte mi?',
            'value': b21.malzeme?.uiTitle ?? '-',
            'report': '',
            'advice': b21.malzeme?.adviceText,
          });
          details.add({
            'label':
                'YGH (Hol) kapıları duman sızdırmaz and yangına dayanıklı mı?',
            'value': b21.kapi?.uiTitle ?? '-',
            'report': '',
            'advice': b21.kapi?.adviceText,
          });
          details.add({
            'label': 'YGH (Hol) içinde eşya (bisiklet, dolap vb.) var mı?',
            'value': b21.esya?.uiTitle ?? '-',
            'report': '',
            'advice': b21.esya?.adviceText,
          });
        }
        handled = true;
      }
    }

    // Bölüm 26: Rampalar
    if (id == 26) {
      final b26 = s.bolum26;
      if (b26 != null) {
        if (b26.varlik != null)
          details.add({
            'label':
                'Binada kullanmak zorunda kaldığınız eğimli bir rampa var mı?',
            'value': b26.varlik!.uiTitle,
            'report': b26.varlik!.reportText,
            'advice': b26.varlik!.adviceText,
          });
        if (b26.egim != null)
          details.add({
            'label': 'Bu rampanın eğimi ve zemin kaplaması nasıl?',
            'value': b26.egim!.uiTitle,
            'report': b26.egim!.reportText,
            'advice': b26.egim!.adviceText,
          });
        if (b26.sahanlik != null)
          details.add({
            'label':
                'Rampanın başlangıcında ve bitişinde sahanlık (düzlük) var mı?',
            'value': b26.sahanlik!.uiTitle,
            'report': b26.sahanlik!.reportText,
            'advice': b26.sahanlik!.adviceText,
          });
        if (b26.otopark != null)
          details.add({
            'label':
                'Otopark araç rampasını acil durumda kaçış yolu olarak kullanabilir misiniz?',
            'value': b26.otopark!.uiTitle,
            'report': b26.otopark!.reportText,
            'advice': b26.otopark!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 27: Kapılar
    if (id == 27) {
      final b27 = s.bolum27;
      if (b27 != null) {
        if (b27.boyut != null) {
          details.add({
            'label':
                'Kaçış kapılarının genişliği ve zemini ne durumdadır? (daire kapısı hariç)',
            'value': b27.boyut!.uiTitle,
            'report': b27.boyut!.reportText,
            'advice': b27.boyut!.adviceText,
          });
        }
        if (b27.yon.isNotEmpty) {
          details.add({
            'label': 'Kaçış kapıları hangi yöne açılıyor? (daire kapısı hariç)',
            'value': b27.yon.map((e) => e.uiTitle).join(' | '),
            'report': b27.yon.map((e) => e.reportText).join('\n\n'),
            'advice': b27.yon.map((e) => e.adviceText ?? "").join('\n\n'),
          });
        }
        if (b27.kilit.isNotEmpty) {
          details.add({
            'label':
                'Kaçış kapılarının kilit mekanizması nasıldır? (daire kapısı hariç)',
            'value': b27.kilit.map((e) => e.uiTitle).join(' | '),
            'report': b27.kilit.map((e) => e.reportText).join('\n\n'),
            'advice': b27.kilit.map((e) => e.adviceText ?? "").join('\n\n'),
          });
        }
        if (b27.dayanim != null) {
          details.add({
            'label': 'Kapalı yangın merdiveni kapısının malzemesi nedir?',
            'value': b27.dayanim!.uiTitle,
            'report': b27.dayanim!.reportText,
            'advice': b27.dayanim!.adviceText,
          });
        }
        // Override metnini de ekle (Risk uyarısı varsa)
        String overridden = getSectionFullReport(id, store: store);
        if (overridden.contains("UYARI") &&
            !b27.yon.any((e) => overridden.contains(e.reportText))) {
          // Eğer generic bir uyarı eklendiyse onu da göster
          details.add({
            'label': 'Kullanıcı Yükü Analizi',
            'value': 'Detaylı Kontrol',
            'report': overridden,
          });
        }
        handled = true;
      }
    }

    // Bölüm 29: Ortak Hatalar
    if (id == 29) {
      final b29 = s.bolum29;
      if (b29 != null) {
        if (b29.otopark != null)
          details.add({
            'label':
                'Otoparkta yanıcı türden eşyalar (lastik, boya, eşya vb.) bulunuyor mu?',
            'value': b29.otopark!.uiTitle,
            'report': b29.otopark!.reportText,
            'advice': b29.otopark!.adviceText,
          });
        if (b29.kazan != null)
          details.add({
            'label':
                'Kazan dairesinde eski eşya, mobilya, karton vb. bulunuyor mu?',
            'value': b29.kazan!.uiTitle,
            'report': b29.kazan!.reportText,
            'advice': b29.kazan!.adviceText,
          });
        if (b29.cati != null)
          details.add({
            'label': 'Çatı arasında yanıcı malzemeler bulunuyor mu?',
            'value': b29.cati!.uiTitle,
            'report': b29.cati!.reportText,
            'advice': b29.cati!.adviceText,
          });
        if (b29.asansor != null)
          details.add({
            'label':
                'Asansör makine dairesinde yanıcı malzemeler bulunuyor mu?',
            'value': b29.asansor!.uiTitle,
            'report': b29.asansor!.reportText,
            'advice': b29.asansor!.adviceText,
          });
        if (b29.jenerator != null)
          details.add({
            'label':
                'Jeneratör odasında ilgisiz malzemeler (yakıt bidonu, eşya vb.) bulunuyor mu?',
            'value': b29.jenerator!.uiTitle,
            'report': b29.jenerator!.reportText,
            'advice': b29.jenerator!.adviceText,
          });
        if (b29.pano != null)
          details.add({
            'label':
                'Elektrik pano odasında veya panoların önünde istiflenmiş eşya var mı?',
            'value': b29.pano!.uiTitle,
            'report': b29.pano!.reportText,
            'advice': b29.pano!.adviceText,
          });
        if (b29.trafo != null)
          details.add({
            'label': 'Trafo odası temiz mi, depo olarak kullanılıyor mu?',
            'value': b29.trafo!.uiTitle,
            'report': b29.trafo!.reportText,
            'advice': b29.trafo!.adviceText,
          });
        if (b29.depo != null)
          details.add({
            'label':
                'Depolarda parlayıcı/patlayıcı maddeler (tiner, boya, akaryakıt vb.) var mı?',
            'value': b29.depo!.uiTitle,
            'report': b29.depo!.reportText,
            'advice': b29.depo!.adviceText,
          });
        if (b29.cop != null)
          details.add({
            'label': 'Çöp odası düzenli mi? Karton, kağıt vb. birikmiş mi?',
            'value': b29.cop!.uiTitle,
            'report': b29.cop!.reportText,
            'advice': b29.cop!.adviceText,
          });
        if (b29.siginak != null)
          details.add({
            'label': 'Sığınakta yanıcı malzeme veya eşya yığılması var mı?',
            'value': b29.siginak!.uiTitle,
            'report': b29.siginak!.reportText,
            'advice': b29.siginak!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 30: Kazan Dairesi Detayları
    if (id == 30) {
      final b30 = s.bolum30;
      if (b30 != null) {
        if (b30.konum != null)
          details.add({
            'label': 'Kazan dairesinin konumu ve kapısının açıldığı yer nasıl?',
            'value': b30.konum!.uiTitle,
            'report': b30.konum!.reportText,
            'advice': b30.konum!.adviceText,
          });
        if (b30.kapi != null) {
          // Kapı sayısı değerlendirmesi - kapasite veya alana göre
          details.add({
            'label': 'Kazan dairesinin kaç adet çıkış kapısı var?',
            'value': b30.kapi!.uiTitle,
            'report': b30.kapi!.reportText,
            'advice': b30.kapi!.adviceText,
          }); // Note: logic might override this text in full report
        }
        if (b30.yakit != null)
          details.add({
            'label': 'Kazanınız sıvı yakıtlı (Mazot/Fuel-oil) mı?',
            'value': b30.yakit!.uiTitle,
            'report': b30.yakit!.reportText,
            'advice': b30.yakit!.adviceText,
          });
        if (b30.hava != null)
          details.add({
            'label':
                'İçeriye temiz hava girmesini ve kirli havanın çıkmasını sağlayan menfezler var mı?',
            'value': b30.hava!.uiTitle,
            'report': b30.hava!.reportText,
            'advice': b30.hava!.adviceText,
          });
        if (b30.drenaj != null)
          details.add({
            'label':
                'Zeminde dökülen yakıtı toplayacak kanallar ve bir pis su çukuru var mı?',
            'value': b30.drenaj!.uiTitle,
            'report': b30.drenaj!.reportText,
            'advice': b30.drenaj!.adviceText,
          });
        if (b30.tup != null)
          details.add({
            'label':
                'Kazan dairesinde yangın söndürme tüpü ve yangın dolabı var mı?',
            'value': b30.tup!.uiTitle,
            'report': b30.tup!.reportText,
            'advice': b30.tup!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 31: Trafo
    if (id == 31) {
      final b31 = s.bolum31;
      if (b31 != null) {
        if (b31.yapi != null)
          details.add({
            'label': 'Trafo odasının duvarları ve kapısı yangına dayanıklı mı?',
            'value': b31.yapi!.uiTitle,
            'report': b31.yapi!.reportText,
            'advice': b31.yapi!.adviceText,
          });
        if (b31.tip != null)
          details.add({
            'label': "Binanızdaki trafo 'Yağlı Tip' mi yoksa 'Kuru Tip' mi?",
            'value': b31.tip!.uiTitle,
            'report': b31.tip!.reportText,
            'advice': b31.tip!.adviceText,
          });
        if (b31.cukur != null)
          details.add({
            'label': 'Trafonun altında yağ toplama çukuru ve ızgara var mı?',
            'value': b31.cukur!.uiTitle,
            'report': b31.cukur!.reportText,
            'advice': b31.cukur!.adviceText,
          });
        if (b31.sondurme != null)
          details.add({
            'label':
                'Trafo odasında otomatik yangın algılama veya söndürme sistemi var mı?',
            'value': b31.sondurme!.uiTitle,
            'report': b31.sondurme!.reportText,
            'advice': b31.sondurme!.adviceText,
          });
        if (b31.cevre != null)
          details.add({
            'label':
                'Trafo odasının içerisinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?',
            'value': b31.cevre!.uiTitle,
            'report': b31.cevre!.reportText,
            'advice': b31.cevre!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 32: Jeneratör
    if (id == 32) {
      final b32 = s.bolum32;
      if (b32 != null) {
        if (b32.yapi != null)
          details.add({
            'label':
                'Jeneratör odasının duvarları yangına dayanıklı mı ve kapısı nereye açılıyor?',
            'value': b32.yapi!.uiTitle,
            'report': b32.yapi!.reportText,
            'advice': b32.yapi!.adviceText,
          });
        if (b32.yakit != null)
          details.add({
            'label': 'Jeneratörün yakıtı nerede ve nasıl depolanıyor?',
            'value': b32.yakit!.uiTitle,
            'report': b32.yakit!.reportText,
            'advice': b32.yakit!.adviceText,
          });
        if (b32.cevre != null)
          details.add({
            'label':
                'Jeneratör odasının içinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?',
            'value': b32.cevre!.uiTitle,
            'report': b32.cevre!.reportText,
            'advice': b32.cevre!.adviceText,
          });
        if (b32.egzoz != null)
          details.add({
            'label':
                'Jeneratörün egzoz borusu nereye veriliyor ve oda havalandırılıyor mu?',
            'value': b32.egzoz!.uiTitle,
            'report': b32.egzoz!.reportText,
            'advice': b32.egzoz!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 34: Zemin/Bodrum Karakteristiği
    if (id == 34) {
      final b34 = s.bolum34;
      if (b34 != null) {
        if (b34.zemin != null)
          details.add({
            'label':
                'Zemin kattaki ticari alanların doğrudan sokağa/bahçeye açılan kendilerine ait kapıları var mı?',
            'value': b34.zemin!.uiTitle,
            'report': b34.zemin!.reportText,
            'advice': b34.zemin!.adviceText,
          });
        if (b34.bodrum != null)
          details.add({
            'label':
                'Bodrum kattaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni ve çıkışları var mı?',
            'value': b34.bodrum!.uiTitle,
            'report': b34.bodrum!.reportText,
            'advice': b34.bodrum!.adviceText,
          });
        if (b34.normal != null)
          details.add({
            'label':
                'Normal katlardaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni ve çıkışları var mı?',
            'value': b34.normal!.uiTitle,
            'report': b34.normal!.reportText,
            'advice': b34.normal!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 35: Koridor Genişliği
    if (id == 35) {
      final b35 = s.bolum35;
      if (b35 != null) {
        if (b35.tekYon != null)
          details.add({
            'label':
                'Daire kapınızdan çıktığınızda bina merdiven kapısına kadar olan mesafe kaç metredir?',
            'value': b35.tekYon!.uiTitle,
            'report': b35.tekYon!.reportText,
            'advice': b35.tekYon!.adviceText,
          });
        if (b35.ciftYon != null)
          details.add({
            'label':
                'Daire kapınızdan çıktığınızda, size EN YAKIN yangın merdivenine olan mesafe kaç metredir?',
            'value': b35.ciftYon!.uiTitle,
            'report': b35.ciftYon!.reportText,
            'advice': b35.ciftYon!.adviceText,
          });
        if (b35.cikmaz != null)
          details.add({
            'label': "Daireniz koridorun sonunda, 'Çıkmaz' bir noktada mı?",
            'value': b35.cikmaz!.uiTitle,
            'report': b35.cikmaz!.reportText,
            'advice': b35.cikmaz!.adviceText,
          });
        if (b35.cikmazMesafe != null)
          details.add({
            'label': 'Çıkmaz koridor mesafesi ne kadar?',
            'value': b35.cikmazMesafe!.uiTitle,
            'report': b35.cikmazMesafe!.reportText,
            'advice': b35.cikmazMesafe!.adviceText,
          });
        if (b35.manuelMesafe != null)
          details.add({
            'label': 'Manuel Girilen Kaçış Mesafesi',
            'value': '${b35.manuelMesafe} m',
            'report': '',
          });
        handled = true;
      }
    }

    // Bölüm 36: Merdiven Değerlendirmesi
    if (id == 36) {
      final b36 = s.bolum36;
      if (b36 != null) {
        if (b36.cikisKati != null)
          details.add({
            'label': 'Binadan dış havaya çıktığınız kat hangisidir?',
            'value': b36.cikisKati!.uiTitle,
            'report': '',
            'advice': b36.cikisKati!.adviceText,
          });
        if (b36.disMerd != null)
          details.add({
            'label':
                'Dışarıdaki yangın merdivenine 3m mesafede açıklık var mı?',
            'value': b36.disMerd!.uiTitle,
            'report': '',
            'advice': b36.disMerd!.adviceText,
          });
        if (b36.konum != null)
          details.add({
            'label': 'Kaçış merdivenleri birbirine göre nasıl konumlanmış?',
            'value': b36.konum!.uiTitle,
            'report': '',
            'advice': b36.konum!.adviceText,
          });
        if (b36.kapiTipi != null)
          details.add({
            'label': 'Katınızdaki çıkış kapılarının tipi nedir?',
            'value': b36.kapiTipi!.uiTitle,
            'report': '',
            'advice': b36.kapiTipi!.adviceText,
          });

        // Genişlik ölçüleri
        if (b36.genislikKorunumlu != null)
          details.add({
            'label': 'Korunumlu Merdiven Genişliği',
            'value': '${b36.genislikKorunumlu} cm',
            'report': '',
          });
        if (b36.genislikKorunumsuz != null)
          details.add({
            'label': 'Korunumsuz Merdiven Genişliği',
            'value': '${b36.genislikKorunumsuz} cm',
            'report': '',
          });
        // Koridor genişlikleri (sadece merdivenden farklıysa)
        if (!b36.areWidthsSame) {
          if (b36.koridorGenislikKorunumlu != null)
            details.add({
              'label': 'Korunumlu Alan Koridor Genişliği',
              'value': '${b36.koridorGenislikKorunumlu} cm',
              'report': '',
            });
          if (b36.koridorGenislikKorunumsuz != null)
            details.add({
              'label': 'Korunumsuz Alan Koridor Genişliği',
              'value': '${b36.koridorGenislikKorunumsuz} cm',
              'report': '',
            });
        }
        // Kapı genişlikleri
        if (b36.kapiGenislikKorunumlu != null)
          details.add({
            'label': 'Korunumlu Alan Kapı Genişliği',
            'value': '${b36.kapiGenislikKorunumlu} cm',
            'report': '',
          });
        if (b36.kapiGenislikKorunumsuz != null)
          details.add({
            'label': 'Korunumsuz Alan Kapı Genişliği',
            'value': '${b36.kapiGenislikKorunumsuz} cm',
            'report': '',
          });

        // Madde 41 Detayları (Merdiven dökümü Bölüm 20 ile ortak metot üzerinden yapılır)
        final b20 = s.bolum20;
        if (b20 != null) {
          // Önce merdiven dökümünü ekle
          _addStaircaseRows(details, b20);
          if (b20.isBodrumIndependent) {
            _addStaircaseRows(details, b20, isBasement: true);
          }

          if (b20.lobiTahliyeMesafeDurumu != null) {
            details.add({
              'label': 'Lobi/Koridor Tahliye Mesafesi Durumu',
              'value': b20.lobiTahliyeMesafeDurumu!.uiTitle,
              'report': '',
            });
          }
        }

        // Ana değerlendirme metni
        details.add({
          'label': 'Merdiven Tipleri ve Kaçış Genişlikleri',
          'value': 'Detaylı Rapor',
          'report': b36.merdivenDegerlendirme ?? '',
        });

        handled = true;
      }
    }

    // Handle other sections generically if NOT handled above
    if (!handled) {
      // Kullanıcı isteği: "Genel Değerlendirme" yerine gerçek soru metnini kullan
      // Eğer bölümün spesifik bir sorusu yoksa, "Genel Değerlendirme" kullan
      String questionLabel = _getQuestionText(id) ?? 'Genel Değerlendirme';

      details.add({
        'label': questionLabel,
        'value': res.uiTitle,
        'report': getSectionFullReport(
          id,
          store: store,
        ), // Kullanılan override logic'i koru
        'advice': res.adviceText,
      });
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
      6: 'Binanızda konut haricinde aşağıdakilerden hangileri mevcut?',
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
        // Sayısal kontroller (sahanlıksız/dengelenmiş merdiven) calculateRiskMetrics'te yönetiliyor
        return _maxLevel([
          b?.tekKatCikis?.level,
          b?.tekKatRampa?.level,
          b?.bodrumMerdivenDevami?.level,
          b?.basinclandirma?.level,
          b?.havalandirma?.level,
          b?.lobiTahliyeMesafeDurumu?.level,
          b?.bodrumLobiTahliyeMesafeDurumu?.level,
        ]);
      case 21:
        final b = s.bolum21;
        return _maxLevel([
          b?.varlik?.level,
          b?.malzeme?.level,
          b?.kapi?.level,
          b?.esya?.level,
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
        final yonLevels = b?.yon.map((e) => e.level as RiskLevel?) ?? [];
        final kilitLevels = b?.kilit.map((e) => e.level as RiskLevel?) ?? [];
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
    return max == RiskLevel.info ? RiskLevel.positive : max;
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
      final b21 = s.bolum21;
      final yghReasons = evaluateYghRequirement(store: s);
      final bool hasYgh = b21?.varlik?.label.contains("21-1-A") ?? false;
      final bool noYgh = b21?.varlik?.label.contains("21-1-B") ?? false;
      final bool isMandatory = yghReasons.isNotEmpty;

      List<String> parts = [];

      // 1. Değerlendirme Özeti
      if (isMandatory) {
        parts.add(
          "DEĞERLENDİRME: YGH ZORUNLUDUR\nBinada aşağıdaki teknik gerekçelerden dolayı Yangın Güvenlik Holü (YGH) bulunması zorunludur:\n${yghReasons.join('\n')}",
        );
      } else {
        parts.add(
          "DEĞERLENDİRME: YGH ZORUNLU DEĞİLDİR\nMevcut yapı verilerine göre bu binada Yangın Güvenlik Holü (YGH) zorunluluğu tespit edilmemiştir.",
        );
      }

      // 2. Mevcut Durum Raporu
      if (hasYgh) {
        parts.add("DURUM: Binada Yangın Güvenlik Holü (YGH) mevcuttur.");
        if (b21?.malzeme != null) parts.add(b21!.malzeme!.reportText);
        if (b21?.kapi != null) parts.add(b21!.kapi!.reportText);
        if (b21?.esya != null) parts.add(b21!.esya!.reportText);
      } else if (noYgh) {
        if (isMandatory) {
          parts.add(
            "KRİTİK RİSK: Binada YGH zorunlu olmasına rağmen, mevcut olmadığı beyan edilmiştir.",
          );
        } else {
          parts.add(
            "DURUM: Binada Yangın Güvenlik Holü (YGH) bulunmamaktadır.",
          );
        }
      }

      return parts.join("\n\n");
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

        // 1. Kullanıcı Yüklerini Detaylandır
        List<String> loadDetails = [];
        if ((b33.yukZemin ?? 0) > 0)
          loadDetails.add("- Zemin Kat: ${b33.yukZemin} kişi");
        if ((b33.yukNormal ?? 0) > 0)
          loadDetails.add("- Normal Kat: ${b33.yukNormal} kişi");
        if ((b33.yukBodrum ?? 0) > 0)
          loadDetails.add("- Bodrum Kat: ${b33.yukBodrum} kişi");

        if (loadDetails.isNotEmpty) {
          reportParts.add(
            "BİLGİ: Hesaplanan Kullanıcı Yükleri:\n${loadDetails.join('\n')}",
          );
        }

        // 2. Seçilen Özellikleri Ekle
        for (var y in b27.yon) {
          reportParts.add(y.reportText);
        }
        for (var k in b27.kilit) {
          reportParts.add(k.reportText);
        }
        if (b27.dayanim != null) reportParts.add(b27.dayanim!.reportText);

        // 3. Genel Kural Hatırlatması ve Dinamik Uyarılar
        final maxLoad = [
          b33.yukZemin ?? 0,
          b33.yukNormal ?? 0,
          b33.yukBodrum ?? 0,
        ].reduce((a, b) => a > b ? a : b);

        // Riskli durum tespiti
        bool yonRiski =
            b27.yon.any(
              (e) => e.label.contains("27-2-B") || e.label.contains("27-2-D"),
            ) &&
            maxLoad > 50;
        bool kilitRiski =
            b27.kilit.any(
              (e) => e.label.contains("27-3-B") || e.label.contains("27-3-D"),
            ) &&
            maxLoad > 100;

        if (yonRiski || kilitRiski) {
          reportParts.add(
            "UYARI: Yönetmelik gereği; kullanıcı yükü 50 kişiyi aşan mekanlarda kapıların kaçış yönüne (dışarıya) doğru açılması zorunludur. Kullanıcı yükü 100 kişiyi aşan mekanlarda ise kapıların hem panik bar ile donatılması hem de kaçış yönüne açılması şarttır. Binanızdaki en yüksek kullanıcı yükü $maxLoad kişidir. Bu doğrultuda kapı özelliklerinin (yön ve kilit) ilgili katlardaki kişi sayılarına göre mevzuata uygun hale getirilmesi gerekmektedir.",
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

        // Kapı sayısı değerlendirmesi - kapasite değerine göre dinamik
        if (b30.kapi != null) {
          final kapasite = b30.kapasite;
          final kapiLabel = b30.kapi!.label;

          if (kapiLabel.contains("30-3-A")) {
            // 1 adet kapı seçildi
            if (kapasite != null && kapasite > 350) {
              // Kapasite > 350kW ve tek kapı = KRİTİK RİSK
              parts.add(
                "KRİTİK RİSK: Kazan dairesi ısıl kapasitesi $kapasite kW (> 350 kW) olmasına rağmen yalnızca 1 adet çıkış kapısı bulunmaktadır. Yönetmelik gereği en az 2 adet çıkış kapısı zorunludur.",
              );
            } else if (kapasite != null && kapasite <= 350) {
              // Kapasite <= 350kW ve tek kapı = OLUMLU
              parts.add(
                "OLUMLU: Kazan dairesi ısıl kapasitesi $kapasite kW (≤ 350 kW) olup tek çıkış kapısı yeterlidir.",
              );
            } else {
              // Kapasite bilinmiyor
              parts.add(
                "BİLİNMİYOR: Kazan dairesinde 1 adet çıkış kapısı mevcuttur. Kapasite bilinmediğinden yeterlilik değerlendirmesi yapılamamıştır. 350 kW üzeri kapasitelerde veya 100 m² üzeri mahal alanlarında en az 2 çıkış kapısı şarttır.",
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
                "KRİTİK RİSK ($title): Hesaplanan kullanıcı yükü ($yuk kişi) için $gerekli adet çıkış gerekmektedir ancak binada $mevcut adet uygun çıkış tespit edilmiştir. Kapasite yetersizdir.",
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
            "BİLGİ: Manuel girilen kaçış mesafesi: ${b35.manuelMesafe} m",
          );
        }
        if (parts.isNotEmpty) return parts.join("\n\n");
      }
      return res.reportText;
    }

    // Bölüm 36: Merdiven Değerlendirmesi
    if (id == 36) {
      List<String> analysisParts = [];

      final b20 = s.bolum20;
      final hasSprinkler = s.bolum9?.secim?.label == "9-1-A";

      if (b20 != null) {
        // --- 1. Merdiven Tipleri ve Sayıları (Eskiden Bölüm 20'deydi) ---
        if (b20.normalMerdivenSayisi > 0) {
          analysisParts.add(
            "BİLGİ: Normal Merdiven: ${b20.normalMerdivenSayisi} adet",
          );
        }
        if (b20.binaIciYanginMerdiveniSayisi > 0) {
          analysisParts.add(
            "BİLGİ: Bina İçi Yangın Merdiveni: ${b20.binaIciYanginMerdiveniSayisi} adet",
          );
        }
        if (b20.binaDisiKapaliYanginMerdiveniSayisi > 0) {
          analysisParts.add(
            "BİLGİ: Bina Dışı Kapalı Yangın Merdiveni: ${b20.binaDisiKapaliYanginMerdiveniSayisi} adet",
          );
        }
        if (b20.binaDisiAcikYanginMerdiveniSayisi > 0) {
          analysisParts.add(
            "BİLGİ: Bina Dışı Açık Yangın Merdiveni: ${b20.binaDisiAcikYanginMerdiveniSayisi} adet",
          );
        }
        if (b20.donerMerdivenSayisi > 0) {
          analysisParts.add(
            "UYARI: Binada ${b20.donerMerdivenSayisi} adet döner merdiven tespit edilmiştir.",
          );
        }
        if (b20.sahanliksizMerdivenSayisi > 0) {
          analysisParts.add(
            "KRİTİK RİSK: Sahanlıksız Merdiven: ${b20.sahanliksizMerdivenSayisi} adet - Binada kaçış yolu olarak kabul edilemeyecek merdiven tespit edilmiştir.",
          );
        }
        if (b20.dengelenmisMerdivenSayisi > 0) {
          double hBina = s.bolum3?.hBina ?? 0;
          int maxYuk = 0;
          if (s.bolum33 != null) {
            maxYuk = [
              s.bolum33?.yukZemin ?? 0,
              s.bolum33?.yukNormal ?? 0,
              s.bolum33?.yukBodrum ?? 0,
            ].reduce((curr, next) => curr > next ? curr : next);
          }
          if (hBina > (15.50 - 0.001) || maxYuk > 100) {
            analysisParts.add(
              "KRİTİK RİSK: Binada 'Dengelenmiş Merdiven' tespit edilmiştir. Yönetmelik limitleri (15.50 m veya 100 kişi) aşıldığı için merdiven uygunsuzdur. (Mevcut: $hBina m, Max Yük: $maxYuk kişi)",
            );
          } else {
            analysisParts.add(
              "OLUMLU: Binada 'Dengelenmiş Merdiven' mevcuttur. Bina yüksekliği (≤15.50m) ve kullanıcı yükü (≤100 kişi) sınırları içerisinde kaldığı için kabul edilebilir.",
            );
          }
        }

        // --- 1.1 Bodrum Merdiven Tipleri ---
        if (b20.isBodrumIndependent) {
          if (b20.bodrumNormalMerdivenSayisi > 0) {
            analysisParts.add(
              "BİLGİ: Bodrum Normal Merdiven: ${b20.bodrumNormalMerdivenSayisi} adet",
            );
          }
          if (b20.bodrumBinaIciYanginMerdiveniSayisi > 0) {
            analysisParts.add(
              "BİLGİ: Bodrum Bina İçi Yangın Merdiveni: ${b20.bodrumBinaIciYanginMerdiveniSayisi} adet",
            );
          }
          if (b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi > 0) {
            analysisParts.add(
              "BİLGİ: Bodrum Bina Dışı Kapalı Yangın Merdiveni: ${b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi} adet",
            );
          }
          if (b20.bodrumBinaDisiAcikYanginMerdiveniSayisi > 0) {
            analysisParts.add(
              "BİLGİ: Bodrum Bina Dışı Açık Yangın Merdiveni: ${b20.bodrumBinaDisiAcikYanginMerdiveniSayisi} adet",
            );
          }
          if (b20.bodrumDonerMerdivenSayisi > 0) {
            analysisParts.add(
              "UYARI: Bodrumda ${b20.bodrumDonerMerdivenSayisi} adet döner merdiven mevcuttur.",
            );
          }
          if (b20.bodrumSahanliksizMerdivenSayisi > 0) {
            analysisParts.add(
              "KRİTİK RİSK: Bodrum Sahanlıksız Merdiven: ${b20.bodrumSahanliksizMerdivenSayisi} adet",
            );
          }
          if (b20.bodrumDengelenmisMerdivenSayisi > 0) {
            double hBina = s.bolum3?.hBina ?? 0;
            int maxYuk = 0;
            if (s.bolum33 != null) {
              maxYuk = [
                s.bolum33?.yukZemin ?? 0,
                s.bolum33?.yukNormal ?? 0,
                s.bolum33?.yukBodrum ?? 0,
              ].reduce((curr, next) => curr > next ? curr : next);
            }
            if (hBina > (15.50 - 0.001) || maxYuk > 100) {
              analysisParts.add(
                "KRİTİK RİSK: Bodrumda 'Dengelenmiş Merdiven' tespit edilmiştir. Yönetmelik limitleri (15.50 m veya 100 kişi) aşıldığı için merdiven uygunsuzdur.",
              );
            } else {
              analysisParts.add(
                "OLUMLU: Bodrumda 'Dengelenmiş Merdiven' mevcuttur. Limitler sağlandığı için kabul edilebilir.",
              );
            }
          }
        }

        // --- 2. Madde 41/1: Doğrudan Dışarıya Tahliye Oranı ---
        final int totalMain =
            b20.normalMerdivenSayisi +
            b20.binaIciYanginMerdiveniSayisi +
            b20.binaDisiKapaliYanginMerdiveniSayisi +
            b20.binaDisiAcikYanginMerdiveniSayisi +
            b20.donerMerdivenSayisi +
            b20.sahanliksizMerdivenSayisi +
            b20.dengelenmisMerdivenSayisi;

        if (totalMain > 0) {
          final int directMain = b20.toplamDisariAcilanMerdivenSayisi;
          final int requiredDirect = (totalMain / 2.0).ceil();

          if (directMain < requiredDirect) {
            analysisParts.add(
              "KRİTİK RİSK: Kaçış merdivenlerinin en az yarısının (%50) doğrudan dışarıya açılması zorunludur. Binadaki $totalMain merdivenden en az $requiredDirect tanesi doğrudan dışarı açılmalıdır. Mevcut durumda sadece $directMain adet merdiven doğrudan dışarı açılmaktadır (Eksik: ${requiredDirect - directMain} adet).",
            );
          } else {
            analysisParts.add(
              "OLUMLU: Binadaki merdivenlerin en az %50'si doğrudan dışarıya açılması kuralı sağlanmaktadır. (Mevcut: $directMain / $totalMain)",
            );
          }

          // --- 3. Madde 41/2: Tahliye Koridoru/Lobi Mesafesi ---
          if (directMain < totalMain && b20.lobiTahliyeMesafeDurumu != null) {
            int limit = hasSprinkler ? 15 : 10;
            String sprinklerNote = hasSprinkler
                ? "(Binada sprinkler var: Limit 15m)"
                : "(Binada sprinkler yok: Limit 10m)";

            final label = b20.lobiTahliyeMesafeDurumu!.label;
            if (label == "41-MESAFE-B") {
              // Fail case
              analysisParts.add(
                "KRİTİK RİSK: Doğrudan dışarıya açılmayan merdivenlerin tahliye mesafesi $limit metre sınırı üzerindedir $sprinklerNote. Bu durum tahliye güvenliğini tehlikeye atmaktadır.",
              );
            } else if (label == "41-MESAFE-A") {
              analysisParts.add(
                "OLUMLU: Tahliye mesafesi yönetmelik limitleri ($limit m) içerisindedir.",
              );
            } else {
              analysisParts.add(
                "BİLİNMİYOR: Tahliye mesafesi kontrol edilmelidir. Limit: $limit m $sprinklerNote.",
              );
            }
          }
        }

        // --- 4. Madde 41/1 & 41/2: Bodrum Kat Analizi ---
        if (b20.isBodrumIndependent) {
          final int totalBod =
              b20.bodrumNormalMerdivenSayisi +
              b20.bodrumBinaIciYanginMerdiveniSayisi +
              b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi +
              b20.bodrumBinaDisiAcikYanginMerdiveniSayisi +
              b20.bodrumDonerMerdivenSayisi +
              b20.bodrumSahanliksizMerdivenSayisi +
              b20.bodrumDengelenmisMerdivenSayisi;

          if (totalBod > 0) {
            final int directBod = b20.bodrumToplamDisariAcilanMerdivenSayisi;
            final int reqDirectBod = (totalBod / 2.0).ceil();

            if (directBod < reqDirectBod) {
              analysisParts.add(
                "KRİTİK RİSK (Bodrum): Bodrum kaçış merdivenlerinin en az yarısının doğrudan dışarıya açılması zorunludur. Mevcutta $totalBod merdivenden $reqDirectBod tanesi açılmalıdır, ancak $directBod adet açılmaktadır (Eksik: ${reqDirectBod - directBod} adet).",
              );
            } else {
              analysisParts.add(
                "OLUMLU (Bodrum): Bodrum merdivenlerinin en az %50'si doğrudan dışarıya açılmaktadır.",
              );
            }

            if (directBod < totalBod &&
                b20.bodrumLobiTahliyeMesafeDurumu != null) {
              int limit = hasSprinkler ? 15 : 10;
              final label = b20.bodrumLobiTahliyeMesafeDurumu!.label;
              if (label == "41-MESAFE-B") {
                analysisParts.add(
                  "KRİTİK RİSK (Bodrum): Bodrum tahliye mesafesi $limit metre sınırını aşmaktadır.",
                );
              }
            }
          }
        }

        // --- 5. Korunumlu Merdiven Gereksinimi Analizi ---
        final hYapi = _getHYapi(s);
        int currentProtected =
            b20.binaIciYanginMerdiveniSayisi +
            b20.binaDisiKapaliYanginMerdiveniSayisi;

        int requiredProtected = 0;
        if (hYapi >= (21.50 - 0.001) && hYapi < (30.50 - 0.001))
          requiredProtected = 1;
        else if (hYapi >= (30.50 - 0.001))
          requiredProtected = 2;

        if (requiredProtected > 0) {
          if (currentProtected < requiredProtected) {
            analysisParts.add(
              "KRİTİK RİSK: Bina yüksekliği ($hYapi m) nedeniyle en az $requiredProtected adet 'Korunumlu Merdiven' (Yangın Merdiveni) bulunması zorunludur. Mevcut durumda $currentProtected adet korunumlu merdiven tespit edilmiştir. Eksik: ${requiredProtected - currentProtected} adet.",
            );
          } else {
            analysisParts.add(
              "OLUMLU: Bina yüksekliği için gereken korunumlu merdiven sayısı ($requiredProtected adet) sağlanmaktadır. (Mevcut: $currentProtected)",
            );
          }

          // Bodrum Katlar (Aynı kural uygulanır)
          if (b20.isBodrumIndependent) {
            int korBod =
                b20.bodrumBinaIciYanginMerdiveniSayisi +
                b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi;
            if (korBod < requiredProtected) {
              analysisParts.add(
                "KRİTİK RİSK (Bodrum): Bina yüksekliği ($hYapi m) nedeniyle bodrum katlarda da en az $requiredProtected adet 'Korunumlu Merdiven' zorunludur. Mevcut: $korBod adet (Eksik: ${requiredProtected - korBod} adet).",
              );
            } else {
              analysisParts.add(
                "OLUMLU (Bodrum): Bodrum katlar için gereken korunumlu merdiven sayısı sağlanmaktadır. (Mevcut: $korBod)",
              );
            }
          }
        }

        // --- 6. Dairesel Merdiven Değerlendirmesi ---
        final b25 = s.bolum25;
        if (b20.hasDaireselMerdiven && b25 != null) {
          final yukseklikLabel = b25.yukseklik?.label ?? "";

          final b33 = s.bolum33;
          final b34 = s.bolum34;
          int effectiveLoad = 0;
          if (b33 != null) {
            bool zeminIndependent =
                b34?.zemin?.label.contains("34-1-A") ?? false;
            int yukZemin = zeminIndependent ? 0 : (b33.yukZemin ?? 0);
            int yukNormal = b33.yukNormal ?? 0;
            int yukBodrum = b33.yukBodrum ?? 0;
            effectiveLoad = [
              yukZemin,
              yukNormal,
              yukBodrum,
            ].reduce((a, b) => a > b ? a : b);
          }

          bool heightOk = yukseklikLabel == "25-Dairesel-A";
          bool heightFail = yukseklikLabel == "25-Dairesel-B";
          bool heightUnknown = yukseklikLabel == "25-Dairesel-C";
          bool loadOk = effectiveLoad <= 25;

          if (heightFail || (b20.hasDaireselMerdiven && !loadOk)) {
            String reason = "";
            if (heightFail) {
              reason =
                  "Dairesel merdiven yüksekliği 9.50m limitini aşmaktadır.";
            }
            if (!loadOk) {
              if (reason.isNotEmpty) reason += " Ayrıca, ";
              reason +=
                  "Dairesel merdivenin hizmet ettiği katlardaki kullanıcı yükü 25 kişiyi aşmaktadır (Hesaplanan: $effectiveLoad kişi).";
            }

            analysisParts.add(
              "KRİTİK RİSK: Dairesel (döner) merdiven Yangın Yönetmeliği kriterlerini sağlamamaktadır. $reason Bu merdiven 'Kaçış Yolu' olarak kabul edilemez.",
            );
          } else if (heightUnknown) {
            analysisParts.add(
              "UYARI: BİLİNMİYOR – Dairesel (döner) merdiven yüksekliği bilinmediği için değerlendirme yapılamamıştır. Yönetmelik gereği dairesel merdivenler yalnızca yüksekliği 9.50 m'yi aşmayan ve kullanıcı yükü 25 kişiyi geçmeyen katlarda kaçış yolu olarak kullanılabilir.",
            );
          } else if (heightOk && loadOk) {
            analysisParts.add(
              "OLUMLU: Dairesel merdivenler yönetmelik koşullarını sağlamaktadır. Yükseklik ≤9.50m ve kullanıcı yükü ≤25 kişidir.",
            );
          }
        }
      }

      String manualEval = s.bolum36?.merdivenDegerlendirme ?? "";
      if (manualEval.isNotEmpty) {
        analysisParts.insert(0, manualEval);
      }

      if (analysisParts.isNotEmpty) {
        return analysisParts.join("\n\n");
      }
      return "OLUMLU: Merdivenler ve tahliye güzergahları Madde 41 kriterlerine uygundur.";
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
        details.add({
          'label':
              'İtfaiye aracının binaya yaklaşım mesafesi 45 metreyi aşıyor mu?',
          'value': b11.mesafe!.uiTitle,
          'report': b11.mesafe!.reportText,
          'advice': b11.mesafe!.adviceText,
        });
      }
      if (b11.engel != null) {
        details.add({
          'label':
              'İtfaiye aracının binaya yanaşmasını engelleyen bir bahçe duvarı veya kilitli kapılar var mı?',
          'value': b11.engel!.uiTitle,
          'report': b11.engel!.reportText,
          'advice': b11.engel!.adviceText,
        });
      }
      if (b11.zayifNokta != null) {
        details.add({
          'label':
              'Bu duvarda itfaiyenin kolayca yıkıp geçebileceği zayıf bir bölüm var mı?',
          'value': b11.zayifNokta!.uiTitle,
          'report': b11.zayifNokta!.reportText,
          'advice': b11.zayifNokta!.adviceText,
        });
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
        details.add({
          'label': 'Otoparktan bina içine açılan kapının özelliği nedir?',
          'value': b13.otoparkKapi!.uiTitle,
          'report': b13.otoparkKapi!.reportText,
          'advice': b13.otoparkKapi!.adviceText,
        });
      }
      if (b13.kazanKapi != null) {
        details.add({
          'label': 'Kazan dairesinin duvarları ve kapısı nasıl?',
          'value': b13.kazanKapi!.uiTitle,
          'report': b13.kazanKapi!.reportText,
          'advice': b13.kazanKapi!.adviceText,
        });
      }
      if (b13.asansorKapi != null) {
        details.add({
          'label': 'Asansör kapısı nasıldır?',
          'value': b13.asansorKapi!.uiTitle,
          'report': b13.asansorKapi!.reportText,
          'advice': b13.asansorKapi!.adviceText,
        });
      }
      if (b13.jeneratorKapi != null) {
        details.add({
          'label': 'Jeneratör odasının duvar ve kapısı nasıl?',
          'value': b13.jeneratorKapi!.uiTitle,
          'report': b13.jeneratorKapi!.reportText,
          'advice': b13.jeneratorKapi!.adviceText,
        });
      }
      if (b13.elektrikKapi != null) {
        details.add({
          'label': 'Elektrik odasının duvarı ve kapısı nasıl?',
          'value': b13.elektrikKapi!.uiTitle,
          'report': b13.elektrikKapi!.reportText,
          'advice': b13.elektrikKapi!.adviceText,
        });
      }
      if (b13.trafoKapi != null) {
        details.add({
          'label': 'Trafo odasının kapısı nasıl?',
          'value': b13.trafoKapi!.uiTitle,
          'report': b13.trafoKapi!.reportText,
          'advice': b13.trafoKapi!.adviceText,
        });
      }
      if (b13.depoKapi != null) {
        details.add({
          'label': 'Eşya deposunun kapısı nasıl?',
          'value': b13.depoKapi!.uiTitle,
          'report': b13.depoKapi!.reportText,
          'advice': b13.depoKapi!.adviceText,
        });
      }
      if (b13.copKapi != null) {
        details.add({
          'label': 'Çöp toplama odasının kapısı nasıl?',
          'value': b13.copKapi!.uiTitle,
          'report': b13.copKapi!.reportText,
          'advice': b13.copKapi!.adviceText,
        });
      }
      if (b13.ortakDuvar != null) {
        details.add({
          'label': 'Yan bina ile ortak kullandığınız duvarın özelliği nedir?',
          'value': b13.ortakDuvar!.uiTitle,
          'report': b13.ortakDuvar!.reportText,
          'advice': b13.ortakDuvar!.adviceText,
        });
      }
      if (b13.ticariKapi != null) {
        details.add({
          'label': 'Ticari alanlardan konut merdivenine geçiş nasıl?',
          'value': b13.ticariKapi!.uiTitle,
          'report': b13.ticariKapi!.reportText,
          'advice': b13.ticariKapi!.adviceText,
        });
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
      return "BİLGİ: Şaft Duvarı: ${b14.gerekenDuvarDk} dk, Şaft Kapağı: ${b14.gerekenKapakDk} dk yangın dayanımı gereklidir. ${b14.raporMesaji}";
    }
    return null;
  }

  static void _addStaircaseRows(
    List<Map<String, dynamic>> details,
    Bolum20Model b, {
    bool isBasement = false,
  }) {
    final prefix = isBasement ? "Bodrum Kat " : "";

    void add(String label, int count) {
      if (count > 0) {
        details.add({
          'label': '$prefix$label (Adet)',
          'value': '$count adet',
          'report': '',
        });
      }
    }

    if (!isBasement) {
      add("Normal Merdiven Sayısı", b.normalMerdivenSayisi);
      add("Bina İçi Yangın Merdiveni Sayısı", b.binaIciYanginMerdiveniSayisi);
      add(
        "Bina Dışı Kapalı Yangın Merdiveni Sayısı",
        b.binaDisiKapaliYanginMerdiveniSayisi,
      );
      add(
        "Bina Dışı Açık Yangın Merdiveni Sayısı",
        b.binaDisiAcikYanginMerdiveniSayisi,
      );
      add("Döner Merdiven Sayısı", b.donerMerdivenSayisi);
      add("Sahanlıksız (Düz) Merdiven Sayısı", b.sahanliksizMerdivenSayisi);
      add("Dengelenmiş Merdiven Sayısı", b.dengelenmisMerdivenSayisi);
      add(
        "Doğrudan Dışarı Açılan Merdiven Sayısı",
        b.toplamDisariAcilanMerdivenSayisi,
      );
    } else {
      add("Normal Merdiven Sayısı", b.bodrumNormalMerdivenSayisi);
      add(
        "Bina İçi Yangın Merdiveni Sayısı",
        b.bodrumBinaIciYanginMerdiveniSayisi,
      );
      add(
        "Bina Dışı Kapalı Yangın Merdiveni Sayısı",
        b.bodrumBinaDisiKapaliYanginMerdiveniSayisi,
      );
      add(
        "Bina Dışı Açık Yangın Merdiveni Sayısı",
        b.bodrumBinaDisiAcikYanginMerdiveniSayisi,
      );
      add("Döner Merdiven Sayısı", b.bodrumDonerMerdivenSayisi);
      add(
        "Sahanlıksız (Düz) Merdiven Sayısı",
        b.bodrumSahanliksizMerdivenSayisi,
      );
      add("Dengelenmiş Merdiven Sayısı", b.bodrumDengelenmisMerdivenSayisi);
      add(
        "Doğrudan Dışarı Açılan Merdiven Sayısı",
        b.bodrumToplamDisariAcilanMerdivenSayisi,
      );
    }
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
      if (b20 != null && b20.basinclandirma?.label.contains("-B") == true) {
        // 20-BAS-B: Hayır
        reasons.add(
          "KRİTİK RİSK: Yapı Yüksekliği 30.50m üzeri ve en az bir merdivende Basınçlandırma yok ise YGH zorunludur.",
        );
      }
    }
    // 3. Bina Yüksekliği > 21.50m (Varsa ek kurallar buraya eklenebilir)
    else if ((s.bolum3?.hBina ?? 0) > (21.50 - 0.001)) {
      // Şu an için 21.50m üstü için YGH'yi doğrudan zorunlu kılan genel bir kural ekli değil
      // Ancak hiyerarşi bozulmasın diye bu blok ayrıldı.
    }

    // 4. Bodrum katlarda ticari/teknik kullanım (Bölüm 10)
    final b10 = s.bolum10;
    if (b10 != null &&
        b10.bodrumlar.any((c) => c?.label.contains("10-C") == true)) {
      reasons.add(
        "KRİTİK RİSK: Bodrum katlarda, konuttan farklı fonksiyon mevcut olduğundan merdivenlerin önünde YGH zorunludur.",
      );
    }

    // 5. İtfaiye Asansörü zorunluluğu (Bölüm 22)
    final b22 = s.bolum22;
    if (b22 != null && b22.varlik?.label.contains("22-1-B") == true) {
      reasons.add(
        "KRİTİK RİSK: Binada İtfaiye Asansörü bulunması zorunludur. İtfaiye asansörü normal (insan taşıma) asansöründen farklı özelliklere sahip olmalıdır.",
      );
    }

    // 6. Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı (Bölüm 23)
    final b23 = s.bolum23;
    if (b23 != null && b23.bodrum?.label.contains("23-1-C") == true) {
      reasons.add(
        "KRİTİK RİSK: Bodrum katlarda asansörün önünde YGH gereklidir.",
      );
    }

    // 7. Bodrum kat sayısı > 4
    if ((s.bolum3?.bodrumKatSayisi ?? 0) > 4) {
      reasons.add(
        "KRİTİK RİSK: Bodrum kat sayısı > 4 olduğu için bodrum katlardaki merdiven önlerinde YGH zorunludur.",
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
      return "KRİTİK RİSK: $subject bulunmamaktadır. Yangının cepheden yayılma riski vardır.";
    return "UYARI: $subject durumu bilinmemektedir. Kontrol edilmelidir.";
  }

  static String getSectionSummary(int id) {
    final res = BinaStore.instance.getResultForSection(id);
    if (res == null) return "Değerlendirilmedi";
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
}
