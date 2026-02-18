import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/choice_result.dart';
import '../utils/app_content.dart';

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
      if (i == 25) isSkipped = (s.bolum20?.donerMerdivenSayisi ?? 0) == 0;
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

    // Dengelenmiş Merdiven Kontrolü (H > 15.50 veya Yük > 100 yasak)
    int dengelenmis =
        (s.bolum20?.dengelenmisMerdivenSayisi ?? 0) +
        (s.bolum20?.isBodrumIndependent == true
            ? (s.bolum20?.bodrumDengelenmisMerdivenSayisi ?? 0)
            : 0);

    if (dengelenmis > 0) {
      double hBina = s.bolum3?.hBina ?? 0;
      int maxYuk = 0;
      if (s.bolum33 != null) {
        maxYuk = [
          s.bolum33?.yukZemin ?? 0,
          s.bolum33?.yukNormal ?? 0,
          s.bolum33?.yukBodrum ?? 0,
        ].reduce((curr, next) => curr > next ? curr : next);
      }

      if (hBina > 15.50 || maxYuk > 100) {
        if (!criticalTitles.contains("Bölüm 20")) {
          criticalRisks++;
          criticalTitles.add("Bölüm 20");
        }
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
    double score =
        100.0 - (criticalRisks * 5.0) - (warnings * 3.0) - (unknowns * 2.0);

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

    // Bölüm 3: Kat Adetleri
    if (id == 3) {
      final b3 = s.bolum3;
      if (b3 != null) {
        if ((b3.normalKatSayisi ?? 0) > 0) {
          details.add({
            'label': 'Normal Kat Sayısı (Zemin Üstü)',
            'value': '${b3.normalKatSayisi} adet',
            'report': '',
          });
        }
        if ((b3.bodrumKatSayisi ?? 0) > 0) {
          details.add({
            'label': 'Bodrum Kat Sayısı (Zemin Altı)',
            'value': '${b3.bodrumKatSayisi} adet',
            'report': '',
          });
        }
        // Zemin kat her zaman var
        details.add({'label': 'Zemin Kat', 'value': '1 adet', 'report': ''});
        handled = true;
      }
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
          'Asansör Makine Dairesi': b7.hasAsansor,
          'Çatı Arası': b7.hasCati,
          'Jeneratör Odası': b7.hasJenerator,
          'Elektrik Pano Odası': b7.hasElektrik,
          'Trafo Merkezi': b7.hasTrafo,
          'Eşya Deposu': b7.hasDepo,
          'Çöp Toplama Odası': b7.hasCop,
          'Sığınak': b7.hasSiginak,
          'Bitişik Bina Ortak Duvarı': b7.hasDuvar,
        };

        spaces.forEach((name, exists) {
          if (exists) {
            details.add({'label': name, 'value': 'Mevcut', 'report': ''});
          }
        });
        handled = true;
      }
    }

    // Bölüm 11: İtfaiyenin Bina Yaklaşım Mesafesi
    if (id == 11) {
      final b11 = s.bolum11;
      if (b11 != null) {
        if (b11.mesafe != null)
          details.add({
            'label':
                'İtfaiye aracının binaya yaklaşım mesafesi 45 metreyi aşıyor mu?',
            'value': b11.mesafe!.uiTitle,
            'report': b11.mesafe!.reportText,
            'advice': b11.mesafe!.adviceText,
          });
        if (b11.engel != null)
          details.add({
            'label':
                'İtfaiye aracının binaya yanaşmasını engelleyen bir bahçe duvarı veya kilitli kapılar var mı?',
            'value': b11.engel!.uiTitle,
            'report': b11.engel!.reportText,
            'advice': b11.engel!.adviceText,
          });
        if (b11.zayifNokta != null)
          details.add({
            'label':
                'Bu duvarda itfaiyenin kolayca yıkıp geçebileceği zayıf bir bölüm var mı?',
            'value': b11.zayifNokta!.uiTitle,
            'report': b11.zayifNokta!.reportText,
            'advice': b11.zayifNokta!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 22: İtfaiye (Acil Durum) Asansörü
    if (id == 22) {
      final b22 = s.bolum22;
      if (b22 != null) {
        if (b22.varlik != null)
          details.add({
            'label': 'Binanızda İtfaiye (acil durum) asansörü var mı?',
            'value': b22.varlik!.uiTitle,
            'report': b22.varlik!.reportText,
            'advice': b22.varlik!.adviceText,
          });
        if (b22.konum != null)
          details.add({
            'label':
                'Bu İtfaiye (acil durum) asansörünün kapısı nereye açılıyor?',
            'value': b22.konum!.uiTitle,
            'report': b22.konum!.reportText,
            'advice': b22.konum!.adviceText,
          });
        if (b22.boyut != null)
          details.add({
            'label':
                'İtfaiye asansörünün açıldığı yangın güvenlik holünün taban alanı kaç metrekaredir?',
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
            'label': 'İtfaiye asansörünün kuyusu basınçlandırılmış mı?',
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
        if (b28.mesafe != null)
          details.add({
            'label':
                'Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan mesafe ne kadardır?',
            'value': b28.mesafe!.uiTitle,
            'report': b28.mesafe!.reportText,
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
            'report': b28.muafiyet!.reportText,
            'advice': b28.muafiyet!.adviceText,
          });
        handled = true;
      }
    }

    // Bölüm 13: Yangın Kompartımanları
    if (id == 13) {
      final b13 = s.bolum13;
      if (b13 != null) {
        if (b13.otoparkKapi != null)
          details.add({
            'label': 'Otoparktan bina içine açılan kapının özelliği nedir?',
            'value': b13.otoparkKapi!.uiTitle,
            'report': b13.otoparkKapi!.reportText,
            'advice': b13.otoparkKapi!.adviceText,
          });
        if (b13.kazanKapi != null)
          details.add({
            'label': 'Kazan dairesinin duvarları ve kapısı nasıl?',
            'value': b13.kazanKapi!.uiTitle,
            'report': b13.kazanKapi!.reportText,
            'advice': b13.kazanKapi!.adviceText,
          });
        if (b13.asansorKapi != null)
          details.add({
            'label': 'Asansör kapısı nasıldır?',
            'value': b13.asansorKapi!.uiTitle,
            'report': b13.asansorKapi!.reportText,
            'advice': b13.asansorKapi!.adviceText,
          });
        if (b13.jeneratorKapi != null)
          details.add({
            'label': 'Jeneratör odasının duvar ve kapısı nasıl?',
            'value': b13.jeneratorKapi!.uiTitle,
            'report': b13.jeneratorKapi!.reportText,
            'advice': b13.jeneratorKapi!.adviceText,
          });
        if (b13.elektrikKapi != null)
          details.add({
            'label': 'Elektrik odasının duvarı ve kapısı nasıl?',
            'value': b13.elektrikKapi!.uiTitle,
            'report': b13.elektrikKapi!.reportText,
            'advice': b13.elektrikKapi!.adviceText,
          });
        if (b13.trafoKapi != null)
          details.add({
            'label': 'Trafo odasının kapısı nasıl?',
            'value': b13.trafoKapi!.uiTitle,
            'report': b13.trafoKapi!.reportText,
            'advice': b13.trafoKapi!.adviceText,
          });
        if (b13.depoKapi != null)
          details.add({
            'label': 'Eşya deposunun kapısı nasıl?',
            'value': b13.depoKapi!.uiTitle,
            'report': b13.depoKapi!.reportText,
            'advice': b13.depoKapi!.adviceText,
          });
        if (b13.copKapi != null)
          details.add({
            'label': 'Çöp toplama odasının kapısı nasıl?',
            'value': b13.copKapi!.uiTitle,
            'report': b13.copKapi!.reportText,
            'advice': b13.copKapi!.adviceText,
          });
        if (b13.ortakDuvar != null)
          details.add({
            'label': 'Yan bina ile ortak kullandığınız duvarın özelliği nedir?',
            'value': b13.ortakDuvar!.uiTitle,
            'report': b13.ortakDuvar!.reportText,
            'advice': b13.ortakDuvar!.adviceText,
          });
        if (b13.ticariKapi != null)
          details.add({
            'label': 'Ticari alanlardan konut merdivenine geçiş nasıl?',
            'value': b13.ticariKapi!.uiTitle,
            'report': b13.ticariKapi!.reportText,
            'advice': b13.ticariKapi!.adviceText,
          });
        handled = true;
      }
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
        // Dairesel merdiven yüksekliği
        if (b20.daireselMerdivenYuksekligi != null)
          details.add({
            'label': 'Dairesel (spiral) merdiven yüksekliği',
            'value': b20.daireselMerdivenYuksekligi!.uiTitle,
            'report': b20.daireselMerdivenYuksekligi!.reportText,
            'advice': b20.daireselMerdivenYuksekligi!.adviceText,
          });
        // Madde 45: Doğal Havalandırma
        if (b20.havalandirma != null)
          details.add({
            'label': 'Merdivenlerde doğal havalandırma var mı? (Madde 45)',
            'value': b20.havalandirma!.uiTitle,
            'report': b20.havalandirma!.reportText,
            'advice': b20.havalandirma!.adviceText,
          });
        // Sadece değer girilen merdiven tiplerini göster
        if (b20.normalMerdivenSayisi > 0)
          details.add({
            'label': 'Normal (Yangın Merdiveni Olmayan) Merdiven Sayısı (Adet)',
            'value': '${b20.normalMerdivenSayisi} adet',
            'report': 'BİLGİ: Normal merdiven mevcuttur.',
          });
        if (b20.binaIciYanginMerdiveniSayisi > 0)
          details.add({
            'label': 'Bina İçi Korunumlu Yangın Merdiveni Sayısı (Adet)',
            'value': '${b20.binaIciYanginMerdiveniSayisi} adet',
            'report': 'BİLGİ: Bina içi korunumlu yangın merdiveni mevcuttur.',
          });
        if (b20.binaDisiKapaliYanginMerdiveniSayisi > 0)
          details.add({
            'label': 'Bina Dışı Kapalı Yangın Merdiveni Sayısı (Adet)',
            'value': '${b20.binaDisiKapaliYanginMerdiveniSayisi} adet',
            'report': 'BİLGİ: Bina dışı kapalı yangın merdiveni mevcuttur.',
          });
        if (b20.binaDisiAcikYanginMerdiveniSayisi > 0)
          details.add({
            'label': 'Bina Dışı Açık Yangın Merdiveni Sayısı (Adet)',
            'value': '${b20.binaDisiAcikYanginMerdiveniSayisi} adet',
            'report': 'BİLGİ: Bina dışı açık yangın merdiveni mevcuttur.',
          });
        if (b20.donerMerdivenSayisi > 0)
          details.add({
            'label': 'Döner Merdiven Sayısı (Adet)',
            'value': '${b20.donerMerdivenSayisi} adet',
            'report': 'UYARI: Döner merdivenler kaçış güvenliğini azaltabilir.',
          });
        if (b20.sahanliksizMerdivenSayisi > 0)
          details.add({
            'label': 'Sahanlıksız (Düz) Merdiven Sayısı (Adet)',
            'value': '${b20.sahanliksizMerdivenSayisi} adet',
            'report':
                'KRİTİK RİSK: Sahanlıksız merdivenler kaçış yolu olarak kabul edilmez.',
          });
        if (b20.dengelenmisMerdivenSayisi > 0) {
          // Validation Logic
          double hBina = s.bolum3?.hBina ?? 0;
          int maxYuk = 0;
          if (s.bolum33 != null) {
            maxYuk = [
              s.bolum33?.yukZemin ?? 0,
              s.bolum33?.yukNormal ?? 0,
              s.bolum33?.yukBodrum ?? 0,
            ].reduce((curr, next) => curr > next ? curr : next);
          }

          String report =
              'OLUMLU: Binada \'Dengelenmiş Merdiven\' mevcuttur. Bina yüksekliği (≤15.50m) ve kullanıcı yükü (≤100 kişi) sınırları içerisinde kaldığı için bu merdiven tipi kaçış yolu olarak kabul edilebilir.';
          if (hBina > 15.50 || maxYuk > 100) {
            report =
                'KRİTİK RİSK: Binada \'Dengelenmiş Merdiven\' tespit edilmiştir. Yönetmelik gereği, bina yüksekliğinin 15.50 m\'den fazla olduğu binalarda veya herhangi bir katta kullanıcı yükünün 100 kişiyi aştığı durumlarda dengelenmiş merdivenlerin kaçış yolu olarak kullanılmasına izin verilmez. Mevcut durumda bu kriterler aşıldığı için merdiven uygunsuzdur. (Mevcut: $hBina m, Max Yük: $maxYuk kişi)';
          }

          details.add({
            'label': 'Dengelenmiş Merdiven Sayısı (Adet)',
            'value': '${b20.dengelenmisMerdivenSayisi} adet',
            'report': report,
          });
        }

        // --- EKSTRA KONTROL: MERDİVEN TİPİ ANALİZİ (Migrated from Section 36) ---
        final hYapi = _getHYapi(s);
        int totalProtected =
            b20.binaIciYanginMerdiveniSayisi +
            b20.binaDisiKapaliYanginMerdiveniSayisi;

        if (hYapi > 30.50) {
          int requiredProtected = (hYapi > 51.50) ? 2 : 1;
          if (totalProtected < requiredProtected) {
            details.add({
              'label': 'Yapı Yüksekliği ve Korunumlu Merdiven Analizi',
              'value': '$totalProtected / $requiredProtected Korunumlu',
              'report':
                  'KRİTİK RİSK: Bina yüksekliği $hYapi m (> 30.50m) olduğu için en az $requiredProtected adet KORUNUMLU (yangın merdiveni) gereklidir. Mevcut merdiven tipi bu zorunluluğu karşılamamaktadır.',
              'advice':
                  'Binadaki merdivenlerden en az $requiredProtected tanesi, Yangın Yönetmeliği kriterlerine uygun (korunumlu, duman sızdırmaz ve yangın güvenlik hollü) hale getirilmelidir.',
            });
          } else {
            details.add({
              'label': 'Yapı Yüksekliği ve Korunumlu Merdiven Analizi',
              'value': 'UYGUN',
              'report':
                  'OLUMLU: Bina yüksekliğine ($hYapi m) göre gereken korunumlu merdiven sayısı sağlanmaktadır.',
            });
          }
        }

        // --- Dairesel Merdiven Kontrolü (Migrated from Section 36) ---
        if (b20.hasDaireselMerdiven) {
          final daireselH = b20.daireselMerdivenYuksekligi?.label;
          final b33 = s.bolum33;
          final b34 = s.bolum34;

          bool heightOk =
              daireselH != null &&
              daireselH.contains(Bolum20Content.daireselYukseklikLabelA);

          int maxOccupancy = 0;
          if (b33 != null) {
            bool zBagimsiz = b34?.zemin?.label.contains("34-1-A") ?? false;
            if (!zBagimsiz) maxOccupancy = b33.yukZemin ?? 0;

            bool nBagimsiz = b34?.normal?.label.contains("34-3-A") ?? false;
            if (!nBagimsiz) {
              int val = b33.yukNormal ?? 0;
              if (val > maxOccupancy) maxOccupancy = val;
            }

            bool bBagimsiz = b34?.bodrum?.label.contains("34-2-A") ?? false;
            if (!bBagimsiz) {
              int val = b33.yukBodrum ?? 0;
              if (val > maxOccupancy) maxOccupancy = val;
            }
          }

          bool occupancyOk = maxOccupancy <= 25;

          if (daireselH == null ||
              daireselH.contains(Bolum20Content.daireselYukseklikLabelC)) {
            details.add({
              'label': 'Dairesel Merdiven Analizi',
              'value': 'Bilinmiyor',
              'report':
                  'UYARI: Binada dairesel merdiven bulunmaktadır ancak yüksekliği belirtilmemiştir. Dairesel merdivenler sadece 9.50m yüksekliğe kadar ve kullanıcı yükü 25 kişiyi aşmayan katlarda kaçış yolu olarak kullanılabilir.',
            });
          } else if (!heightOk || !occupancyOk) {
            String reason = !heightOk
                ? "Yükseklik sınırı (>9.50m) aşılmıştır."
                : "Kullanıcı yükü sınırı (>25 kişi) aşılmıştır.";
            details.add({
              'label': 'Dairesel Merdiven Analizi',
              'value': 'UYGUN DEĞİL',
              'report':
                  'KRİTİK RİSK: Dairesel merdiven kaçış yolu olarak kabul edilemez. $reason (Mevcut Maks Yük: $maxOccupancy kişi)',
              'advice':
                  'Yönetmelik Madde 43 gereği dairesel merdivenler her bina türünde kaçış yolu sayılamaz. Bina yüksekliği veya kullanıcı yükü sınırları aşıldığı için normal kaçış merdiveni sağlanmalıdır.',
            });
          } else {
            details.add({
              'label': 'Dairesel Merdiven Analizi',
              'value': 'UYGUN',
              'report':
                  'OLUMLU: Dairesel merdiven, yükseklik ve kullanıcı yükü sınırları (≤9.50m ve ≤25 kişi) içerisinde olduğu için kaçış yolu olarak kabul edilebilir.',
            });
          }
        }

        // Madde 41: Dış Havaya Tahliye Merdiven Oranı (Üst Katlar)
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
          final bool isPassMain = directMain >= (totalMain / 2);

          details.add({
            'label': 'Dış Havaya Tahliye (Madde 41) - Ana Katlar',
            'value': '$directMain / $totalMain Merdiven',
            'report': isPassMain
                ? 'OLUMLU: Merdivenlerin en az %50\'si doğrudan dışarıya açılmaktadır.'
                : 'KRİTİK RİSK: Kaçış merdivenlerinin en az yarısının doğrudan dışarıya açılması gerekir (Madde 41). Mevcut oran: $directMain / $totalMain.',
            'advice': !isPassMain
                ? 'Dışarıya açılmayan merdiven adetleri artırılarak veya çıkış güzergahları değiştirilerek doğrudan tahliye oranı %50\'ye yükseltilmelidir.'
                : '',
          });

          if (directMain < totalMain && b20.lobiTahliyeMesafeDurumu != null) {
            details.add({
              'label': 'Bina İçi Tahliye Koridoru Mesafesi (Ana Katlar)',
              'value': b20.lobiTahliyeMesafeDurumu!.uiTitle,
              'report': b20.lobiTahliyeMesafeDurumu!.reportText,
              'advice': b20.lobiTahliyeMesafeDurumu!.adviceText,
            });
          }
        }

        // Bodrum merdivenleri
        if (b20.isBodrumIndependent) {
          details.add({
            'label': 'Bodrum kat merdivenleri bağımsız mı?',
            'value': 'Evet (Bağımsız)',
            'report':
                'BİLGİ: Bodrum kat merdivenleri bağımsız olarak değerlendirilmiştir.',
          });
          if (b20.bodrumNormalMerdivenSayisi > 0)
            details.add({
              'label': 'Bodrum Kat Normal Merdiven Sayısı (Adet)',
              'value': '${b20.bodrumNormalMerdivenSayisi} adet',
              'report': '',
            });
          if (b20.bodrumBinaIciYanginMerdiveniSayisi > 0)
            details.add({
              'label': 'Bodrum Kat Bina İçi Yangın Merdiveni Sayısı (Adet)',
              'value': '${b20.bodrumBinaIciYanginMerdiveniSayisi} adet',
              'report': '',
            });
          if (b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi > 0)
            details.add({
              'label':
                  'Bodrum Kat Bina Dışı Kapalı Yangın Merdiveni Sayısı (Adet)',
              'value': '${b20.bodrumBinaDisiKapaliYanginMerdiveniSayisi} adet',
              'report': '',
            });
          if (b20.bodrumBinaDisiAcikYanginMerdiveniSayisi > 0)
            details.add({
              'label':
                  'Bodrum Kat Bina Dışı Açık Yangın Merdiveni Sayısı (Adet)',
              'value': '${b20.bodrumBinaDisiAcikYanginMerdiveniSayisi} adet',
              'report': '',
            });
          if (b20.bodrumDonerMerdivenSayisi > 0)
            details.add({
              'label': 'Bodrum Kat Döner Merdiven Sayısı (Adet)',
              'value': '${b20.bodrumDonerMerdivenSayisi} adet',
              'report': '',
            });
          if (b20.bodrumSahanliksizMerdivenSayisi > 0)
            details.add({
              'label': 'Bodrum Kat Sahanlıksız (Düz) Merdiven Sayısı (Adet)',
              'value': '${b20.bodrumSahanliksizMerdivenSayisi} adet',
              'report':
                  'KRİTİK RİSK: Bodrumda sahanlıksız merdiven tespit edildi.',
            });
          if (b20.bodrumDengelenmisMerdivenSayisi > 0) {
            // Validation Logic for Basement (Consistent with building-wide rule)
            double hBina = s.bolum3?.hBina ?? 0;
            int maxYuk = 0;
            if (s.bolum33 != null) {
              maxYuk = [
                s.bolum33?.yukZemin ?? 0,
                s.bolum33?.yukNormal ?? 0,
                s.bolum33?.yukBodrum ?? 0,
              ].reduce((curr, next) => curr > next ? curr : next);
            }

            String report =
                'OLUMLU: Bodrumda \'Dengelenmiş Merdiven\' mevcuttur. Bina yüksekliği (≤15.50m) ve kullanıcı yükü (≤100 kişi) sınırları içerisinde kaldığı için bu merdiven tipi kaçış yolu olarak kabul edilebilir.';
            if (hBina > 15.50 || maxYuk > 100) {
              report =
                  'KRİTİK RİSK: Bodrumda \'Dengelenmiş Merdiven\' tespit edilmiştir. Yönetmelik gereği, bina yüksekliğinin 15.50 m\'den fazla olduğu binalarda veya herhangi bir katta kullanıcı yükünün 100 kişiyi aştığı durumlarda dengelenmiş merdivenlerin kaçış yolu olarak kullanılmasına izin verilmez. Mevcut durumda bu kriterler aşıldığı için merdiven uygunsuzdur. (Mevcut H: $hBina m, Max Yük: $maxYuk kişi)';
            }

            details.add({
              'label': 'Bodrum Kat Dengelenmiş Merdiven Sayısı (Adet)',
              'value': '${b20.bodrumDengelenmisMerdivenSayisi} adet',
              'report': report,
            });
          }

          // Madde 41 (Bodrum): Dış Havaya Tahliye Merdiven Oranı
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
            final bool isPassBod = directBod >= (totalBod / 2);

            details.add({
              'label': 'Dış Havaya Tahliye (Madde 41) - Bodrum Katlar',
              'value': '$directBod / $totalBod Merdiven',
              'report': isPassBod
                  ? 'OLUMLU: Bodrum merdivenlerinin en az %50\'si doğrudan dışarıya açılmaktadır.'
                  : 'KRİTİK RİSK: Bodrum kaçış merdivenlerinin en az yarısının doğrudan dışarıya açılması gerekir (Madde 41). Mevcut oran: $directBod / $totalBod.',
              'advice': !isPassBod
                  ? 'Bodrumda doğrudan dışarıya açılmayan merdivenler için çıkış güzergahları revize edilmelidir.'
                  : '',
            });

            if (directBod < totalBod &&
                b20.bodrumLobiTahliyeMesafeDurumu != null) {
              details.add({
                'label': 'Bina İçi Tahliye Koridoru Mesafesi (Bodrum)',
                'value': b20.bodrumLobiTahliyeMesafeDurumu!.uiTitle,
                'report': b20.bodrumLobiTahliyeMesafeDurumu!.reportText,
                'advice': b20.bodrumLobiTahliyeMesafeDurumu!.adviceText,
              });
            }
          }
        }
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
        if (b27.boyut != null)
          details.add({
            'label':
                'Kaçış kapılarının genişliği ve zemini ne durumdadır? (daire kapısı hariç)',
            'value': b27.boyut!.uiTitle,
            'report': b27.boyut!.reportText,
            'advice': b27.boyut!.adviceText,
          });
        if (b27.yon != null)
          details.add({
            'label': 'Kaçış kapıları hangi yöne açılıyor? (daire kapısı hariç)',
            'value': b27.yon!.uiTitle,
            'report': b27.yon!.reportText,
            'advice': b27.yon!.adviceText,
          });
        if (b27.kilit != null)
          details.add({
            'label':
                'Kaçış kapılarının kilit mekanizması nasıldır? (daire kapısı hariç)',
            'value': b27.kilit!.uiTitle,
            'report': b27.kilit!.reportText,
            'advice': b27.kilit!.adviceText,
          });
        if (b27.dayanim != null)
          details.add({
            'label': 'Kapalı yangın merdiveni kapısının malzemesi nedir?',
            'value': b27.dayanim!.uiTitle,
            'report': b27.dayanim!.reportText,
            'advice': b27.dayanim!.adviceText,
          });
        // Override metnini de ekle (Risk uyarısı varsa)
        String overridden = getSectionFullReport(id, store: store);
        if (overridden.contains("UYARI") &&
            !overridden.contains(b27.yon!.reportText)) {
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
        if (b36.gorunurluk != null)
          details.add({
            'label': 'Kaçış kapıları/levhaları her noktadan görünüyor mu?',
            'value': b36.gorunurluk!.uiTitle,
            'report': '',
            'advice': b36.gorunurluk!.adviceText,
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

        // Madde 41 Detayları (Veri artık Bölüm 20'den geliyor)
        final b20 = s.bolum20;
        if (b20 != null) {
          int directExits = b20.toplamDisariAcilanMerdivenSayisi;
          if (directExits > 0) {
            details.add({
              'label': 'Doğrudan Dışarı Açılan Merdiven Sayısı',
              'value': '$directExits adet',
              'report': '',
            });
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
    if (sectionId != null &&
        (sectionId <= 10 || sectionId == 14 || sectionId == 20)) {
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
        if (parts.isNotEmpty) return "BİLGİ: ${parts.join(', ')}";
      }
    }

    // Bölüm 12 override
    if (id == 12 && res.label.contains("12-B (Çelik)")) {
      if ((s.bolum5?.toplamInsaatAlani ?? 0.0) < 5000) {
        return "OLUMLU: Çelik taşıyıcı elemanlar üzerinde pasif yangın yalıtımı bulunmamaktadır. (NOT: Bina toplam inşaat alanı 5000 m² altında olduğu için bu durum yönetmeliğe uygundur.)";
      }
    }

    // Bölüm 14: Tesisat Şaftları (Sadece bilgi - soru/yanıt formatı yok)
    if (id == 14) {
      final b14 = s.bolum14;
      if (b14 != null &&
          b14.raporMesaji != null &&
          b14.raporMesaji!.isNotEmpty) {
        return "BİLGİ: Şaft Duvarı: ${b14.gerekenDuvarDk} dk, Şaft Kapağı: ${b14.gerekenKapakDk} dk yangın dayanımı gereklidir. ${b14.raporMesaji}";
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

        // Duman Tahliye Sistemleri kaldırıldı (Kullanıcı talebi)

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

          if (hBina > 15.50 || maxYuk > 100) {
            parts.add(
              "KRİTİK RİSK: Binada 'Dengelenmiş Merdiven' tespit edilmiştir. Yönetmelik gereği, bina yüksekliğinin 15.50 m'den fazla olduğu binalarda veya herhangi bir katta kullanıcı yükünün 100 kişiyi aştığı durumlarda dengelenmiş merdivenlerin kaçış yolu olarak kullanılmasına izin verilmez. Mevcut durumda bu kriterler aşıldığı için merdiven uygunsuzdur. (Mevcut: $hBina m, Max Yük: $maxYuk kişi)",
            );
          } else {
            parts.add(
              "OLUMLU: Binada 'Dengelenmiş Merdiven' mevcuttur. Bina yüksekliği (≤15.50m) ve kullanıcı yükü (≤100 kişi) sınırları içerisinde kaldığı için bu merdiven tipi kaçış yolu olarak kabul edilebilir.",
            );
          }
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

            if (hBina > 15.50 || maxYuk > 100) {
              parts.add(
                "KRİTİK RİSK: Bodrumda 'Dengelenmiş Merdiven' tespit edilmiştir. Yönetmelik gereği, bina yüksekliğinin 15.50 m'den fazla olduğu binalarda veya herhangi bir katta kullanıcı yükünün 100 kişiyi aştığı durumlarda dengelenmiş merdivenlerin kaçış yolu olarak kullanılmasına izin verilmez. Mevcut durumda bu kriterler aşıldığı için merdiven uygunsuzdur.",
              );
            } else {
              parts.add(
                "OLUMLU: Bodrumda 'Dengelenmiş Merdiven' mevcuttur. Bina yüksekliği ve kullanıcı yükü sınırları sağlandığı için kabul edilebilir.",
              );
            }
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

      // YGH var ise, alt detayları raporla (Malzeme, Kapı, Eşya)
      if (hasYgh) {
        List<String> parts = [];
        parts.add("OLUMLU: Binada Yangın Güvenlik Holü (YGH) mevcuttur.");

        if (b21?.malzeme != null) parts.add(b21!.malzeme!.reportText);
        if (b21?.kapi != null) parts.add(b21!.kapi!.reportText);
        if (b21?.esya != null) parts.add(b21!.esya!.reportText);

        return parts.join("\n\n");
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
        if (b27.yon != null) reportParts.add(b27.yon!.reportText);
        if (b27.kilit != null) reportParts.add(b27.kilit!.reportText);
        if (b27.dayanim != null) reportParts.add(b27.dayanim!.reportText);

        // 3. Genel Kural Hatırlatması ve Dinamik Uyarılar
        final maxLoad = [
          b33.yukZemin ?? 0,
          b33.yukNormal ?? 0,
          b33.yukBodrum ?? 0,
        ].reduce((a, b) => a > b ? a : b);

        final yonLabel = b27.yon?.label ?? "";
        final kilitLabel = b27.kilit?.label ?? "";

        // Riskli durum tespiti
        bool yonRiski =
            (yonLabel.contains("27-2-B") || yonLabel.contains("27-2-D")) &&
            maxLoad > 50;
        bool kilitRiski =
            (kilitLabel.contains("27-3-B") || kilitLabel.contains("27-3-D")) &&
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
            b35.tekYon!.reportText.replaceAll(
              "[LİMİT]",
              limitTekYon.toString(),
            ),
          );
        }
        if (b35.ciftYon != null) {
          parts.add(
            b35.ciftYon!.reportText.replaceAll(
              "[LİMİT]",
              limitCiftYon.toString(),
            ),
          );
        }
        if (b35.cikmaz != null) {
          parts.add(b35.cikmaz!.reportText);
        }
        if (b35.cikmazMesafe != null) {
          parts.add(
            b35.cikmazMesafe!.reportText.replaceAll(
              "[LİMİT]",
              limitTekYon.toString(),
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
      if (s.bolum36?.merdivenDegerlendirme != null) {
        // Return manual choice as base, analysis results are now in Section 20
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

    // 1. Yapı Yüksekliği >= 51.50m (En üst limit - diğer yükseklik şartlarını kapsar)
    if (hYapi >= 51.50) {
      reasons.add("KRİTİK RİSK: Yapı Yüksekliği ≥ 51.50 metre");
    }
    // 2. Yapı Yüksekliği > 30.50m (Basınçlandırma yoksa zorunlu)
    else if (hYapi > 30.50) {
      final b20 = s.bolum20;
      if (b20 != null && b20.basinclandirma?.label.contains("-B") == true) {
        // 20-BAS-B: Hayır
        reasons.add(
          "KRİTİK RİSK: Yapı Yüksekliği 30.50m üzeri ve en az bir merdivende Basınçlandırma yok ise YGH zorunludur.",
        );
      }
    }
    // 3. Bina Yüksekliği > 21.50m (Varsa ek kurallar buraya eklenebilir)
    else if ((s.bolum3?.hBina ?? 0) > 21.50) {
      // Şu an için 21.50m üstü için YGH'yi doğrudan zorunlu kılan genel bir kural ekli değil
      // Ancak hiyerarşi bozulmasın diye bu blok ayrıldı.
    }

    // 3. Bodrum katlarda ticari/teknik kullanım (Bölüm 10)
    final b10 = s.bolum10;
    if (b10 != null &&
        b10.bodrumlar.any((c) => c?.label.contains("10-C") == true)) {
      reasons.add(
        "KRİTİK RİSK: Bodrum katlarda, konuttan farklı fonksiyon mevcut olduğundan merdivenlerin önünde YGH zorunludur.",
      );
    }

    // 4. İtfaiye Asansörü zorunluluğu (Bölüm 22)
    final b22 = s.bolum22;
    if (b22 != null && b22.varlik?.label.contains("22-1-B") == true) {
      reasons.add(
        "KRİTİK RİSK: Binada İtfaiye Asansörü bulunması zorunludur. İtfaiye asansörü normal (insan taşıma) asansöründen farklı özelliklere sahip olmalıdır.",
      );
    }

    // 5. Bodrum katlarda asansörün kuyu önü duman sızdırmazlığı (Bölüm 23)
    final b23 = s.bolum23;
    if (b23 != null && b23.bodrum?.label.contains("23-1-C") == true) {
      reasons.add(
        "KRİTİK RİSK: Bodrum katlarda asansörün önünde YGH gereklidir.",
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
}
