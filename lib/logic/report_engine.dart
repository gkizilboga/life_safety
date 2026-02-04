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

    // Bölüm 13: Yangın Kompartımanları
    if (id == 13) {
      final b13 = s.bolum13;
      if (b13 != null) {
        if (b13.otoparkKapi != null)
          details.add({
            'label': 'Otoparktan bina içine açılan kapının özelliği nedir?',
            'value': b13.otoparkKapi!.uiTitle,
            'report': b13.otoparkKapi!.reportText,
          });
        if (b13.kazanKapi != null)
          details.add({
            'label': 'Kazan dairesinin duvarları ve kapısı nasıl?',
            'value': b13.kazanKapi!.uiTitle,
            'report': b13.kazanKapi!.reportText,
          });
        if (b13.asansorKapi != null)
          details.add({
            'label': 'Asansör kapısı nasıldır?',
            'value': b13.asansorKapi!.uiTitle,
            'report': b13.asansorKapi!.reportText,
          });
        if (b13.jeneratorKapi != null)
          details.add({
            'label': 'Jeneratör odasının duvar ve kapısı nasıl?',
            'value': b13.jeneratorKapi!.uiTitle,
            'report': b13.jeneratorKapi!.reportText,
          });
        if (b13.elektrikKapi != null)
          details.add({
            'label': 'Elektrik odasının duvarı ve kapısı nasıl?',
            'value': b13.elektrikKapi!.uiTitle,
            'report': b13.elektrikKapi!.reportText,
          });
        if (b13.trafoKapi != null)
          details.add({
            'label': 'Trafo odasının kapısı nasıl?',
            'value': b13.trafoKapi!.uiTitle,
            'report': b13.trafoKapi!.reportText,
          });
        if (b13.depoKapi != null)
          details.add({
            'label': 'Eşya deposunun kapısı nasıl?',
            'value': b13.depoKapi!.uiTitle,
            'report': b13.depoKapi!.reportText,
          });
        if (b13.copKapi != null)
          details.add({
            'label': 'Çöp toplama odasının kapısı nasıl?',
            'value': b13.copKapi!.uiTitle,
            'report': b13.copKapi!.reportText,
          });
        if (b13.ortakDuvar != null)
          details.add({
            'label': 'Yan bina ile ortak kullandığınız duvarın özelliği nedir?',
            'value': b13.ortakDuvar!.uiTitle,
            'report': b13.ortakDuvar!.reportText,
          });
        if (b13.ticariKapi != null)
          details.add({
            'label': 'Ticari alanlardan konut merdivenine geçiş nasıl?',
            'value': b13.ticariKapi!.uiTitle,
            'report': b13.ticariKapi!.reportText,
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
          });
        if (b15.yalitim != null)
          details.add({
            'label': 'Döşeme üzerinde ısı yalıtım malzemesi var mı?',
            'value': b15.yalitim!.uiTitle,
            'report': b15.yalitim!.reportText,
          });
        if (b15.yalitimSap != null)
          details.add({
            'label': 'Yalıtım üzerinde en az 2 cm şap var mı?',
            'value': b15.yalitimSap!.uiTitle,
            'report': b15.yalitimSap!.reportText,
          });
        if (b15.tavan != null)
          details.add({
            'label': 'Asma Tavan var mı?',
            'value': b15.tavan!.uiTitle,
            'report': b15.tavan!.reportText,
          });
        if (b15.tavanMalzeme != null)
          details.add({
            'label': 'Asma tavan malzemesi nedir?',
            'value': b15.tavanMalzeme!.uiTitle,
            'report': b15.tavanMalzeme!.reportText,
          });
        if (b15.tesisat != null)
          details.add({
            'label': 'Tesisat geçişleri nasıl kapatılmış?',
            'value': b15.tesisat!.uiTitle,
            'report': b15.tesisat!.reportText,
          });
        handled = true;
      }
    }

    // Bölüm 16: Dış Cephe
    if (id == 16) {
      final b16 = s.bolum16;
      if (b16 != null) {
        if (b16.mantolama != null)
          details.add({
            'label':
                'Binanızdaki dış cephe kaplama veya ısı yalıtım sistemi nedir?',
            'value': b16.mantolama!.uiTitle,
            'report': b16.mantolama!.reportText,
          });

        // Bariyer Analizi (Ekstra not olarak ekleyelim, ayrı bir 'soru' gibi değil ama önemli)
        if (b16.mantolama?.label.contains("16-1-A") == true) {
          String barrierMsg = "";
          if (b16.bariyerYan == 0 ||
              b16.bariyerUst == 0 ||
              b16.bariyerZemin == 0) {
            barrierMsg =
                "KRİTİK RİSK: Binada yanıcı mantolama kullanılmasına rağmen pencere kenarlarında veya kat aralarında yangın bariyerleri bulunmamaktadır.";
          } else if (b16.bariyerYan == 2 ||
              b16.bariyerUst == 2 ||
              b16.bariyerZemin == 2) {
            barrierMsg =
                "UYARI: Binada yanıcı mantolama mevcut olup yangın bariyerlerinin eksik veya standart dışı olduğu tespit edilmiştir.";
          }
          if (barrierMsg.isNotEmpty) {
            details.add({
              'label':
                  'Seçtiğiniz "Klasik Mantolama (EPS/XPS)" yanıcı özellikte olduğu için, yönetmelik gereği aşağıdaki yangın bariyeri önlemlerinin alınıp alınmadığı kontrol edilmelidir.',
              'value': 'Eksik veya Standart Dışı',
              'report': barrierMsg,
            });
          }
        }

        if (b16.sagirYuzey != null)
          details.add({
            'label': 'Katlar arasında sağır (yanmaz) yüzey var mı?',
            'value': b16.sagirYuzey!.uiTitle,
            'report': b16.sagirYuzey!.reportText,
          });
        if (b16.bitisikNizam != null)
          details.add({
            'label':
                'Binanız bitişik nizamda bulunan yan bina ile karşılaştırıldığında yükseklik durumu nedir?',
            'value': b16.bitisikNizam!.uiTitle,
            'report': b16.bitisikNizam!.reportText,
          });
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
          });
        if (b17.iskelet != null)
          details.add({
            'label': 'Çatıyı taşıyan iskelet ve altındaki ısı yalıtımı nedir?',
            'value': b17.iskelet!.uiTitle,
            'report': b17.iskelet!.reportText,
          });
        if (b17.bitisikDuvar != null)
          details.add({
            'label': 'Çatılar arasında yangını kesecek bir duvar var mı?',
            'value': b17.bitisikDuvar!.uiTitle,
            'report': b17.bitisikDuvar!.reportText,
          });
        if (b17.isiklik != null)
          details.add({
            'label': 'Çatınızda camlı ışıklık veya aydınlatma kubbesi var mı?',
            'value': b17.isiklik!.uiTitle,
            'report': b17.isiklik!.reportText,
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
          });
        if (b18.boruTipi != null)
          details.add({
            'label':
                'Binanız yüksek katlı olduğu için tesisat şaftlarından geçen plastik su borularında önlem alınmış mı?',
            'value': b18.boruTipi!.uiTitle,
            'report': b18.boruTipi!.reportText,
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
          });
        }
        if (b19.levha != null)
          details.add({
            'label': 'Yönlendirme levhaları asılı mı?',
            'value': b19.levha!.uiTitle,
            'report': b19.levha!.reportText,
          });
        if (b19.yanilticiKapi != null)
          details.add({
            'label':
                'Yanıltıcı kapılar var mı? (Çıkış ulaşırken kafanızı karıştırabilecek türden kapılar)',
            'value': b19.yanilticiKapi!.uiTitle,
            'report': b19.yanilticiKapi!.reportText,
          });
        if (b19.yanilticiEtiket != null)
          details.add({
            'label': 'Bu kapıların üzerinde yazı var mı?',
            'value': b19.yanilticiEtiket!.uiTitle,
            'report': b19.yanilticiEtiket!.reportText,
          });
        handled = true;
      }
    }

    // Bölüm 20: Merdivenler
    if (id == 20) {
      final b20 = s.bolum20;
      if (b20 != null) {
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
          });
        if (b26.egim != null)
          details.add({
            'label': 'Bu rampanın eğimi ve zemin kaplaması nasıl?',
            'value': b26.egim!.uiTitle,
            'report': b26.egim!.reportText,
          });
        if (b26.sahanlik != null)
          details.add({
            'label':
                'Rampanın başlangıcında ve bitişinde sahanlık (düzlük) var mı?',
            'value': b26.sahanlik!.uiTitle,
            'report': b26.sahanlik!.reportText,
          });
        if (b26.otopark != null)
          details.add({
            'label':
                'Otopark araç rampasını acil durumda kaçış yolu olarak kullanabilir misiniz?',
            'value': b26.otopark!.uiTitle,
            'report': b26.otopark!.reportText,
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
          });
        if (b27.yon != null)
          details.add({
            'label': 'Kaçış kapıları hangi yöne açılıyor? (daire kapısı hariç)',
            'value': b27.yon!.uiTitle,
            'report': b27.yon!.reportText,
          });
        if (b27.kilit != null)
          details.add({
            'label':
                'Kaçış kapılarının kilit mekanizması nasıldır? (daire kapısı hariç)',
            'value': b27.kilit!.uiTitle,
            'report': b27.kilit!.reportText,
          });
        if (b27.dayanim != null)
          details.add({
            'label': 'Kapalı yangın merdiveni kapısının malzemesi nedir?',
            'value': b27.dayanim!.uiTitle,
            'report': b27.dayanim!.reportText,
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
          });
        if (b29.kazan != null)
          details.add({
            'label':
                'Kazan dairesinde eski eşya, mobilya, karton vb. bulunuyor mu?',
            'value': b29.kazan!.uiTitle,
            'report': b29.kazan!.reportText,
          });
        if (b29.cati != null)
          details.add({
            'label': 'Çatı arasında yanıcı malzemeler bulunuyor mu?',
            'value': b29.cati!.uiTitle,
            'report': b29.cati!.reportText,
          });
        if (b29.asansor != null)
          details.add({
            'label':
                'Asansör makine dairesinde yanıcı malzemeler bulunuyor mu?',
            'value': b29.asansor!.uiTitle,
            'report': b29.asansor!.reportText,
          });
        if (b29.jenerator != null)
          details.add({
            'label':
                'Jeneratör odasında ilgisiz malzemeler (yakıt bidonu, eşya vb.) bulunuyor mu?',
            'value': b29.jenerator!.uiTitle,
            'report': b29.jenerator!.reportText,
          });
        if (b29.pano != null)
          details.add({
            'label':
                'Elektrik pano odasında veya panoların önünde istiflenmiş eşya var mı?',
            'value': b29.pano!.uiTitle,
            'report': b29.pano!.reportText,
          });
        if (b29.trafo != null)
          details.add({
            'label': 'Trafo odası temiz mi, depo olarak kullanılıyor mu?',
            'value': b29.trafo!.uiTitle,
            'report': b29.trafo!.reportText,
          });
        if (b29.depo != null)
          details.add({
            'label':
                'Depolarda parlayıcı/patlayıcı maddeler (tiner, boya, akaryakıt vb.) var mı?',
            'value': b29.depo!.uiTitle,
            'report': b29.depo!.reportText,
          });
        if (b29.cop != null)
          details.add({
            'label': 'Çöp odası düzenli mi? Karton, kağıt vb. birikmiş mi?',
            'value': b29.cop!.uiTitle,
            'report': b29.cop!.reportText,
          });
        if (b29.siginak != null)
          details.add({
            'label': 'Sığınakta yanıcı malzeme veya eşya yığılması var mı?',
            'value': b29.siginak!.uiTitle,
            'report': b29.siginak!.reportText,
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
          });
        if (b30.kapi != null) {
          // Kapı sayısı değerlendirmesi - kapasite veya alana göre
          details.add({
            'label': 'Kazan dairesinin kaç adet çıkış kapısı var?',
            'value': b30.kapi!.uiTitle,
            'report': b30.kapi!.reportText,
          }); // Note: logic might override this text in full report
        }
        if (b30.yakit != null)
          details.add({
            'label': 'Kazanınız sıvı yakıtlı (Mazot/Fuel-oil) mı?',
            'value': b30.yakit!.uiTitle,
            'report': b30.yakit!.reportText,
          });
        if (b30.hava != null)
          details.add({
            'label':
                'İçeriye temiz hava girmesini ve kirli havanın çıkmasını sağlayan menfezler var mı?',
            'value': b30.hava!.uiTitle,
            'report': b30.hava!.reportText,
          });
        if (b30.drenaj != null)
          details.add({
            'label':
                'Zeminde dökülen yakıtı toplayacak kanallar ve bir pis su çukuru var mı?',
            'value': b30.drenaj!.uiTitle,
            'report': b30.drenaj!.reportText,
          });
        if (b30.tup != null)
          details.add({
            'label':
                'Kazan dairesinde yangın söndürme tüpü ve yangın dolabı var mı?',
            'value': b30.tup!.uiTitle,
            'report': b30.tup!.reportText,
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
          });
        if (b31.tip != null)
          details.add({
            'label': "Binanızdaki trafo 'Yağlı Tip' mi yoksa 'Kuru Tip' mi?",
            'value': b31.tip!.uiTitle,
            'report': b31.tip!.reportText,
          });
        if (b31.cukur != null)
          details.add({
            'label': 'Trafonun altında yağ toplama çukuru ve ızgara var mı?',
            'value': b31.cukur!.uiTitle,
            'report': b31.cukur!.reportText,
          });
        if (b31.sondurme != null)
          details.add({
            'label':
                'Trafo odasında otomatik yangın algılama veya söndürme sistemi var mı?',
            'value': b31.sondurme!.uiTitle,
            'report': b31.sondurme!.reportText,
          });
        if (b31.cevre != null)
          details.add({
            'label':
                'Trafo odasının içerisinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?',
            'value': b31.cevre!.uiTitle,
            'report': b31.cevre!.reportText,
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
          });
        if (b32.yakit != null)
          details.add({
            'label': 'Jeneratörün yakıtı nerede ve nasıl depolanıyor?',
            'value': b32.yakit!.uiTitle,
            'report': b32.yakit!.reportText,
          });
        if (b32.cevre != null)
          details.add({
            'label':
                'Jeneratör odasının içinden su borusu geçiyor mu veya üst katında ıslak zemin var mı?',
            'value': b32.cevre!.uiTitle,
            'report': b32.cevre!.reportText,
          });
        if (b32.egzoz != null)
          details.add({
            'label':
                'Jeneratörün egzoz borusu nereye veriliyor ve oda havalandırılıyor mu?',
            'value': b32.egzoz!.uiTitle,
            'report': b32.egzoz!.reportText,
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
          });
        if (b34.bodrum != null)
          details.add({
            'label':
                'Bodrum kattaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni ve çıkışları var mı?',
            'value': b34.bodrum!.uiTitle,
            'report': b34.bodrum!.reportText,
          });
        if (b34.normal != null)
          details.add({
            'label':
                'Normal katlardaki ticari alanların doğrudan dışarıya çıkan kendilerine ait merdiveni ve çıkışları var mı?',
            'value': b34.normal!.uiTitle,
            'report': b34.normal!.reportText,
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
          });
        if (b35.ciftYon != null)
          details.add({
            'label':
                'Daire kapınızdan çıktığınızda, size EN YAKIN yangın merdivenine olan mesafe kaç metredir?',
            'value': b35.ciftYon!.uiTitle,
            'report': b35.ciftYon!.reportText,
          });
        if (b35.cikmaz != null)
          details.add({
            'label': "Daireniz koridorun sonunda, 'Çıkmaz' bir noktada mı?",
            'value': b35.cikmaz!.uiTitle,
            'report': b35.cikmaz!.reportText,
          });
        if (b35.cikmazMesafe != null)
          details.add({
            'label': 'Çıkmaz koridor mesafesi ne kadar?',
            'value': b35.cikmazMesafe!.uiTitle,
            'report': b35.cikmazMesafe!.reportText,
          });
        handled = true;
      }
    }

    // Handle other sections generically if NOT handled above
    if (!handled) {
      details.add({
        'label': 'Genel Değerlendirme',
        'value': res.uiTitle,
        'report': getSectionFullReport(
          id,
          store: store,
        ), // Kullanılan override logic'i koru
      });
    }

    return details;
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
      if (s.bolum33 != null) {
        String report = s.bolum33!.combinedReportText;
        if (report.contains("OLUMLU") || report.contains("YETERLİ")) {
          report +=
              "\n\n(NOT: Bu bölümdeki 'OLUMLU' ibaresi, yalnızca kişi yüküne göre hesaplanan sayısal çıkış yeterliliğini ifade eder. Merdivenlerin korunumlu olup olmadığı veya niteliklerinin yönetmeliğe uygunluğu Bölüm 36'da ayrıca değerlendirilmiştir.)";
        }
        return report;
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
      if (s.bolum36?.merdivenDegerlendirme != null) {
        String baseReport = s.bolum36!.merdivenDegerlendirme!;

        // --- EKSTRA KONTROL: MERDİVEN TİPİ ANALİZİ ---
        // Kullanıcının girdiği merdiven tiplerinin (Bölüm 20),
        // gereken (Korunumlu/Korunumsuz) tiplerle uyuşup uyuşmadığını kontrol et.
        final b20 = s.bolum20;
        final hYapi = _getHYapi(s);

        if (b20 != null) {
          int actualProtected =
              (b20.binaIciYanginMerdiveniSayisi) +
              (b20.binaDisiKapaliYanginMerdiveniSayisi);
          // Bina dışı açık merdivenler genelde "Yarım Korunumlu" veya "Kaçış Merdiveni" sayılır
          // ancak H > 21.50m veya 30.50m gibi durumlarda tam korunumlu (kapalı) istenebilir.
          // Burada sıkı bir kontrol için "Kapalı/Korunumlu" şartına odaklanıyoruz.

          List<String> deviations = [];

          // KURAL 1: Yapı Yüksekliği > 30.50 m (veya 51.50 m)
          // Genelde en az 2 çıkış, en az 1'i (veya 2'si) korunumlu olmalı.
          if (hYapi > 30.50) {
            // Basitleştirilmiş kural: 30.50m üzeri binalarda normal merdivenler kaçış yolu sayılsa bile
            // en az 1 adet KORUNUMLU (yangın güvenlik holü veya basınçlandırmalı) merdiven aranır.
            // Eğer H > 51.50 ise genelde 2'si de korunumlu olmalı.

            int requiredProtected = 0;
            if (hYapi > 51.50)
              requiredProtected = 2;
            else if (hYapi > 30.50)
              requiredProtected = 1;

            if (actualProtected < requiredProtected) {
              deviations.add(
                "KRİTİK RİSK: Bina yüksekliği $hYapi m (> 30.50m) olduğu için en az $requiredProtected adet KORUNUMLU (yangın merdiveni) gereklidir. Ancak binada ${actualProtected == 0 ? 'hiç korunumlu merdiven bulunmamaktadır' : 'sadece $actualProtected adet korunumlu merdiven bulunmaktadır'}. Mevcut normal merdivenler bu zorunluluğu karşılamamaktadır.",
              );
            }
          }

          // KURAL 2: Eğer "KORUNUMLU GEREKLİ" denmişse ama Korunumlu yoksa
          // (Bu bilgi baseReport içinde "korunumlu merdiven" geçiyorsa ve bizde yoksa)
          if (baseReport.toLowerCase().contains("korunumlu merdiven gerekli") ||
              baseReport.toLowerCase().contains("yangın merdiveni gerekli")) {
            if (actualProtected == 0) {
              deviations.add(
                "KRİTİK RİSK: Raporlama sonucunda binada KORUNUMLU MERDİVEN (Yangın Merdiveni) bulunması gerektiği tespit edilmiştir. Ancak Bölüm 20'de girilen verilere göre binada korunumlu yangın merdiveni bulunmamaktadır (Sadece normal merdiven veya uygunsuz merdiven mevcuttur).",
              );
            }
          }

          if (deviations.isNotEmpty) {
            baseReport +=
                "\n\n--- TİP UYGUNSUZLUKLARI ---\n${deviations.join("\n\n")}";
          }
        }

        return baseReport;
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
