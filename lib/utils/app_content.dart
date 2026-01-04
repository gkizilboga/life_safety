import 'package:life_safety/models/choice_result.dart';
class Bolum1Content {
  static final ruhsatSonrasi = ChoiceResult(
    label: "1-A",
    uiTitle: "19.12.2007 ve sonrasında alındı.",
    uiSubtitle: "Bina, YENİ BİNA statüsünde kabul edilecektir.",
    reportText: "✅ BİLGİ: Binanın yapı ruhsat tarihi 19.12.2007 ve sonrası olduğu için, analiz \"Binaların Yangından Korunması Hakkında Yönetmelik\" (BYKHY) kapsamındaki \"YENİ BİNA\" hükümlerine göre yapılmıştır."
  );

  static final ruhsatOncesi = ChoiceResult(
    label: "1-B",
    uiTitle: "19.12.2007 öncesinde alındı.",
    uiSubtitle: "Tarih itibarıyla MEVCUT BİNA statüsünde ancak yine de YENİ BİNA hükümlerine göre değerlendirilsin.",
    reportText: "⚠️ UYARI: Bina, ruhsat tarihi itibarıyla \"Mevcut Bina\" statüsünde olmasına rağmen, kullanıcı talebi üzerine güncel yönetmeliğin \"YENİ BİNA\" standartlarına göre analiz edilmiştir. Bu rapor, binanın güncel güvenlik şartlarını ne kadar sağladığını gösterir."
  );
}
class Bolum2Content {
  static final betonarme = ChoiceResult(
    label: "2-A",
    uiTitle: "Betonarme",
    uiSubtitle: "Türkiye'deki binaların tamamına yakını betonarmedir. Binada kolon, kiriş, perde beton vardır.",
    reportText: "✅ BİLGİ: Binanın taşıyıcı sistemi BETONARME olarak beyan edilmiştir. Yangın dayanım hesapları (paspayı vb.) betonarme standartlarına göre değerlendirilmiştir."
  );

  static final celik = ChoiceResult(
    label: "2-B",
    uiTitle: "Çelik",
    uiSubtitle: "Türkiye'deki konut sektöründe nadiren görülür. Binanın iskeleti kalın çelik profillerden oluşur.",
    reportText: "⚠️ BİLGİ: Binanın taşıyıcı sistemi ÇELİK olarak beyan edilmiştir. Çelik yapılar yüksek sıcaklıkta (540°C) taşıma gücünü hızla kaybettiği için, yangın yalıtımı (boya/kaplama) kritik önem taşımaktadır."
  );

  static final ahsap = ChoiceResult(
    label: "2-C",
    uiTitle: "Ahşap",
    uiSubtitle: "Binanın ana taşıyıcıları kalın ahşap kolon, kirişten oluşur.",
    reportText: "⚠️ BİLGİ: Binanın taşıyıcı sistemi AHŞAP olarak beyan edilmiştir. Ahşap yapıların yangın dayanımı, kullanılan kesitlerin kalınlığına (kömürleşme hızına) bağlı olarak değerlendirilmiştir."
  );

  static final yigma = ChoiceResult(
    label: "2-D",
    uiTitle: "Yığma / Kagir (Taş Duvarlı)",
    uiSubtitle: "Binada kolon, kiriş olmaz. Tüm yükü taşıyan kalın taş duvarlardır.",
    reportText: "✅ BİLGİ: Binanın taşıyıcı sistemi YIĞMA (KAGİR) olarak beyan edilmiştir. Yığma binalarda duvar kalınlıkları (en az 19 cm), yangın dayanım süresini belirleyen ana faktördür."
  );

  static final bilinmiyor = ChoiceResult(
    label: "2-E",
    uiTitle: "Bilmiyorum / Emin Değilim",
    uiSubtitle: "Türkiye konut sektörü baz alınarak binanın Betonarme olduğu varsayılacaktır.",
    reportText: "❓ BİLİNMİYOR: Binanın taşıyıcı sistemi net olarak bilinmemektedir. Türkiye'deki yapı stoğunun büyük çoğunluğu betonarme olduğu için analiz BETONARME varsayımıyla yapılmıştır. Kesin sonuç için statik proje incelenmelidir."
  );
}

class Bolum3Content {
  static final normalKatGiris = ChoiceResult(
    label: "3-1 (Normal Kat)",
    uiTitle: "Normal Kat Adedi (Zemin Üstü)",
    uiSubtitle: "Örn: 5 (Sadece 0-20 arası tam sayı).",
    reportText: "(Sayısal veri olarak saklanır: \"Zemin Üstü: X Kat\")"
  );

  static final bodrumKatGiris = ChoiceResult(
    label: "3-2 (Bodrum Kat)",
    uiTitle: "Bodrum Kat Adedi (Zemin Altı)",
    uiSubtitle: "Bodrum yoksa 0 yazınız.",
    reportText: "(Sayısal veri olarak saklanır: \"Zemin Altı: Y Kat\")"
  );

  static final yukseklikBiliniyor = ChoiceResult(
    label: "3-3-A (Yükseklik)",
    uiTitle: "Kat yüksekliklerini biliyorum.",
    uiSubtitle: "(Hassas Giriş)",
    reportText: "(Girilen metre değerleri rapora işlenir)"
  );

  static final yukseklikStandart = ChoiceResult(
    label: "3-3-B (Yükseklik)",
    uiTitle: "Bilmiyorum / Standart değerleri kabul et.",
    uiSubtitle: "Standart Değerler: Zemin: 3.5m, Normal: 3m, Bodrum: 3.5m",
    reportText: "ℹ️ BİLGİ: Bina kat yükseklikleri kullanıcı tarafından bilinmediği için, analizde standart kabul edilen değerler kullanılacaktır."
  );
}

class Bolum4Content {
  static final yukseklikSinifiDusuk = ChoiceResult(
    label: "Bina (Bodrum Hariç) < 21.50m",
    uiTitle: "",
    uiSubtitle: "",
    reportText: "✅ BİLGİ (YÜKSEK OLMAYAN BİNA): Binanın yüksekliği [H_BINA] metredir. Yönetmeliğe göre 21.50 metrenin altında olduğu için \"Yüksek Bina\" kategorisine girmemektedir."
  );

  static final yukseklikSinifiYuksek = ChoiceResult(
    label: "Bina (Bodrum Hariç) ≥ 21.50m",
    uiTitle: "",
    uiSubtitle: "",
    reportText: "✅ BİLGİ (YÜKSEK BİNA): Bina yüksekliği [H_BINA] metredir. 21.50 metreyi aştığı için \"Yüksek Bina\" kategorisindedir."
  );

  static final yukseklikSinifiCokYuksek = ChoiceResult(
    label: "Bina (Bodrum Hariç) ≥ 30.50m",
    uiTitle: "",
    uiSubtitle: "",
    reportText: "✅ BİLGİ (YÜKSEK BİNA): Bina yüksekliği [H_BINA] metredir. 30.50 metreyi aştığı için \"Yüksek Bina\" kategorisindedir."
  );

  static final yukseklikSinifiMaksimum = ChoiceResult(
    label: "Bina (Bodrum Hariç) ≥ 51.50m",
    uiTitle: "",
    uiSubtitle: "",
    reportText: "✅ BİLGİ (YÜKSEK BİNA): Bina yüksekliği [H_BINA] metredir. 51.50 metreyi aştığı için \"Yüksek Bina\" kategorisindedir."
  );

  static final yapiYuksekligiUyari = ChoiceResult(
    label: "Yapı (Bodrum Dahil) > 30.50m",
    uiTitle: "",
    uiSubtitle: "",
    reportText: "⚠️ UYARI (YAPI YÜKSEKLİĞİ): Binanın bodrumlar dahil toplam yapı yüksekliği [H_YAPI] metredir. Bodrum katlar dahil yapı yüksekliği 30.50 metreyi aştığı için \"Yüksek Bina\" kategorisindedir."
  );
}
class Bolum5Content {
  static final oturumAlani = ChoiceResult(
    label: "5-1 (Oturum)",
    uiTitle: "Zemin Kat (Taban) Alanı",
    uiSubtitle: "Binanın zemin katının brüt alanı.",
    reportText: "Zemin Kat Alanı: "
  );

  static final normalKatAlani = ChoiceResult(
    label: "5-2 (Normal)",
    uiTitle: "Normal Kat Alanı",
    uiSubtitle: "Zemin üstü standart bir katın brüt alanı.",
    reportText: "Normal Kat Alanı: "
  );

  static final bodrumKatAlani = ChoiceResult(
    label: "5-3 (Bodrum)",
    uiTitle: "Bodrum Kat Alanı",
    uiSubtitle: "Zemin altı standart bir katın brüt alanı.",
    reportText: "Bodrum Kat Alanı: "
  );

  static final toplamInsaat = ChoiceResult(
    label: "5-4 (Toplam)",
    uiTitle: "Toplam İnşaat Alanı",
    uiSubtitle: "Tüm katların (Zemin+Normal+Bodrum) toplam brüt alanı.",
    reportText: "Toplam İnşaat Alanı: "
  );

  static final otomatikHesap = ChoiceResult(
    label: "5-Otomatik",
    uiTitle: "OTOMATİK HESAPLA",
    uiSubtitle: "Kat sayıları ve alan verileriyle toplamı hesaplar.",
    reportText: "ℹ️ BİLGİ: Toplam inşaat alanı sistem tarafından otomatik hesaplanmıştır."
  );
}
class Bolum6Content {
  static final otoparkVar = ChoiceResult(
    label: "6-1-A (Otopark)",
    uiTitle: "Binanın altında otopark bulunmaktadır.",
    uiSubtitle: "Bodrum veya zemin katta otopark mevcut.",
    reportText: "⚠️ BİLGİ: Binada kapalı otopark bulunmaktadır. Otoparkların yangın yükü yüksek olduğundan ek önlemler almak gereklidir."
  );

  static final ticariVar = ChoiceResult(
    label: "6-1-B (Ticari)",
    uiTitle: "Binada konut haricinde ticari alanlar bulunmaktadır.",
    uiSubtitle: "Dükkan, mağaza, kafe, ofis, her türlü işyeri vb.",
    reportText: "⚠️ BİLGİ: Binada konut harici ticari kullanım (ofis, işyerleri vb.) mevcuttur. Karma kullanımlı binalarda, ticari alanların konutlardan yangın duvarlarıyla ayrılması önerilmektedir."
  );

  static final depoVar = ChoiceResult(
    label: "6-1-C (Depo)",
    uiTitle: "Binada depolama alanları bulunmaktadır.",
    uiSubtitle: "Konut sakinlere ait eşya deposu vb.",
    reportText: "⚠️ BİLGİ: Binada konutlara ait ortak depo alanı bulunmaktadır. Depolanan malzemeler yanıcılık seviyelerine göre risk oluşturabilir."
  );

  static final sadeceKonut = ChoiceResult(
    label: "6-1-D (Sadece Konut)",
    uiTitle: "Binada konut dışında başka amaçlı herhangi bir alan yok.",
    uiSubtitle: "Sadece meskenler var.",
    reportText: "✅ BİLGİ: Bina sadece konut amaçlı kullanılmaktadır. Ekstra yangın yükü yaratabilecek bir kullanım yer almamaktadır."
  );

  static final otoparkKapali = ChoiceResult(
    label: "6-2-A (Otopark Tipi)",
    uiTitle: "Otoparkın tavanı, tabanı ve tüm yan duvarları kapalı.",
    uiSubtitle: "Otopark, toprak altında veya duvarları örülü biçimdedir.",
    reportText: "ℹ️ BİLGİ (KAPALI OTOPARK): Otoparkın doğal havalandırma imkanı olmadığı için \"Kapalı Otopark\" statüsündedir. Yönetmeliğe göre Kapalı Otopark yangın güvenlik ihtiyaçları farklıdır. Kapalı alan bilgisine göre duman tahliyesi vb. ihtiyaçlar doğar."
  );

  static final otoparkAcik = ChoiceResult(
    label: "6-2-B (Otopark Tipi)",
    uiTitle: "Otoparkın karşılıklı iki cephesi tamamen açık.",
    uiSubtitle: "Doğal havalandırma mevcut.",
    reportText: "✅ BİLGİ (AÇIK OTOPARK): Otoparkın karşılıklı cepheleri açık olduğu için doğal havalandırma yeterli kabul edilebilir. İçeride duman birikme ihtimali düşüktür."
  );

  static final otoparkYariAcik = ChoiceResult(
    label: "6-2-C (Otopark Tipi)",
    uiTitle: "Otoparkın sadece tek bir cephesinde açıklık var. Diğer cepheleri duvarla örülü.",
    uiSubtitle: "Otopark cephesinde pencereler veya açıklıklar var.",
    reportText: "⚠️ UYARI: Otoparkta sadece tek cephede açıklık olması duman tahliyesi ve havalandırma için yeterli değildir. \"Kapalı Otopark\" kuralları geçerlidir."
  );
}

class Bolum7Content {
  static const String otoparkBilgiNotu = "Binada kapalı otopark olup olmadığı bilgisi bir önceki bölümden alınarak sisteme işlenmiştir.";

  static final otopark = ChoiceResult(
    label: "7-1 (Otopark)",
    uiTitle: "Kapalı Otopark",
    uiSubtitle: "(Sistem tarafından otomatik işaretlenir)",
    reportText: "(Bölüm 6'dan gelen bilgiye göre rapora eklenir)"
  );

  static final kazan = ChoiceResult(
    label: "7-2 (Kazan)",
    uiTitle: "Kazan Dairesi / Isı Merkezi",
    uiSubtitle: "Mahal içerisinde ısıtma kazanı (boiler) bulunur.",
    reportText: "☢️ RİSK KAYNAĞI: Binada Kazan Dairesi mevcuttur. Yakıt ve basınç nedeniyle binanın en yüksek riskli alanıdır. 120 dk yangın dayanımlı duvarlarla ayrılmalıdır."
  );

  static final asansor = ChoiceResult(
    label: "7-3 (Asansör)",
    uiTitle: "Normal Asansör",
    uiSubtitle: "İnsan taşıma amaçlı asansör.",
    reportText: "ℹ️ BİLGİ: Binada asansör mevcuttur. Asansör kuyuları alevin ve dumanın üst katlara yayılmasında baca görevi görebilir."
  );

  static final cati = ChoiceResult(
    label: "7-5 (Çatı)",
    uiTitle: "Çatı Arası",
    uiSubtitle: "Çatı ile binanın en üst katı arasında kalan boşluk veya mahal.",
    reportText: "⚠️ UYARI: Binada çatı arası ya da çatı katı mevcuttur. Bu alanlarda elektrik tesisatı veya ekipman kaynaklı yangın riski yüksektir. Yanıcı madde depo alanı olarak kullanılmamalıdır."
  );

  static final jenerator = ChoiceResult(
    label: "7-6 (Jeneratör)",
    uiTitle: "Jeneratör Odası",
    uiSubtitle: "Bina için yedek güç kaynağının olduğu mahal.",
    reportText: "☢️ RİSK KAYNAĞI: Binada Jeneratör Odası mevcuttur. Jeneratörün çalışması için yakıt depolama ve çıkabilecek egzoz gazları nedeniyle yüksek yangın ve zehirlenme riski taşır."
  );

  static final elektrik = ChoiceResult(
    label: "7-7 (Elektrik)",
    uiTitle: "Elektrik Odası / Pano Odası",
    uiSubtitle: "Bina için gerekli olan elektrikli ekipmanların veya cihazların bulunduğu mahal.",
    reportText: "⚠️ UYARI: Binada elektrik odası mevcuttur. İstatistiklere göre bina yangınlarının büyük çoğunluğu elektrik panolarından çıkmaktadır."
  );

  static final trafo = ChoiceResult(
    label: "7-8 (Trafo)",
    uiTitle: "Trafo Odası",
    uiSubtitle: "Yüksek gerilim trafosu.",
    reportText: "☢️ KRİTİK RİSK: Binada Trafo bulunmaktadır. Yağlı tip trafonun yangın riski yüksektir. Binadan bağımsız olarak ek önlemler alınması şarttır."
  );

  static final depo = ChoiceResult(
    label: "7-9 (Depo)",
    uiTitle: "Ortak Depo / Ardiye",
    uiSubtitle: "Konutlara ait eşya saklama alanı.",
    reportText: "⚠️ UYARI: Ortak depo alanı mevcuttur. Kontrolsüz eşya yığılması yangın yükünü artırır."
  );

  static final cop = ChoiceResult(
    label: "7-10 (Çöp)",
    uiTitle: "Çöp Odası / Çöp Şut Odası",
    uiSubtitle: "Konutlara ait çöplerin biriktirildiği ufak odalar.",
    reportText: "☢️ RİSK KAYNAĞI: Çöp odası mevcuttur. Biriken çöplerden çıkan metan gazı yanıcıdır. Havalandırma şarttır."
  );

  static final siginak = ChoiceResult(
    label: "7-11 (Sığınak)",
    uiTitle: "Sığınak",
    uiSubtitle: "Acil durumda kullanılacak alan.",
    reportText: "ℹ️ BİLGİ: Binada sığınak mevcuttur. Barış zamanında depo olarak kullanılsa bile yanıcı madde konulamaz."
  );

  static final duvar = ChoiceResult(
    label: "7-12 (Duvar)",
    uiTitle: "Ortak Duvar",
    uiSubtitle: "Yan bina ile bitişikliği sağlayan aradaki duvar.",
    reportText: "⚠️ UYARI: Yan bina ile ortak duvar mevcuttur. Komşu binada çıkacak bir yangının geçişini engellemek için duvarın yangına dayanıklı olması gerekir."
  );

  static final hicbiri = ChoiceResult(
    label: "7-13 (Hiçbiri)",
    uiTitle: "Yukarıdakilerden hiçbiri binada bulunmamaktadır.",
    uiSubtitle: "Binada özel riskli alan yok.",
    reportText: "✅ OLUMLU: Binada özel risk taşıyan teknik hacim (kazan, jeneratör, elektrik odası vb.) bulunmamaktadır."
  );
}
class Bolum8Content {
  static final ayrikNizam = ChoiceResult(
    label: "8-1-A",
    uiTitle: "Ayrık Nizam",
    uiSubtitle: "Binanın dört cephesi de açıktır, yan binalara yapışık veya bitişik değildir.",
    reportText: "✅ BİLGİ: Bina AYRIK NİZAM olarak beyan edilmiştir. Bu durum, komşu binalardan yangın sirayeti riskini azaltır, cephe ve çatı yangın tedbirlerinde esneklik sağlar."
  );

  static final bitisikNizam = ChoiceResult(
    label: "8-1-B",
    uiTitle: "Bitişik Nizam",
    uiSubtitle: "Binanın bir veya iki cephesi yan binaya yapışık veya bitişiktir.",
    reportText: "⚠️ UYARI: Bina BİTİŞİK NİZAM olarak beyan edilmiştir. Bitişik nizam yapılarda, komşu bina ile ortak kullanılan duvarların yangın dayanım özelliği ve çatı birleşim detayları kritik öneme sahiptir."
  );
}

class Bolum9Content {
  static final tamKapsam = ChoiceResult(
    label: "9-1-A",
    uiTitle: "Evet, tüm binada otomatik söndürme sistemi var.",
    uiSubtitle: "Daireler, koridorlar, dükkanlar, otopark dahil.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Binada tam kapsamlı otomatik yağmurlama (sprinkler) sistemi mevcuttur. Bu sistem, yangın anında kaçış mesafesi limitlerini artırır (Örn: Tek yönde 15m yerine 30m) ve yangın güvenliğini üst seviyeye taşır."
  );

  static final yok = ChoiceResult(
    label: "9-1-B",
    uiTitle: "Hayır, hiçbir yerde yok.",
    uiSubtitle: "Binada otomatik söndürme sistemi bulunmuyor.",
    reportText: "⚠️ BİLGİ: Binada otomatik yağmurlama (sprinkler) sistemi bulunmamaktadır. Bu durumda kaçış mesafesi limitleri minimum değerler üzerinden değerlendirilmektedir. Sprinkler sistemi olmaması kaçış mesafeleri ve can güvenliği açısından büyük dezavantaj yaratır."
  );

  static final kismen = ChoiceResult(
    label: "9-1-C",
    uiTitle: "Kısmen var.",
    uiSubtitle: "Sadece bazı katlarda veya bazı mahallerde var.",
    reportText: "☢️ RİSK: Sprinkler sistemi binanın tamamını kapsamıyor. Yönetmelik gereği, kaçış güvenliği hesaplarında sistemin \"YOK\" olduğu varsayılacaktır. Kısmi koruma, can güvenliği tam olarak sağlamaz."
  );
}

class Bolum10Content {
  static final konut = ChoiceResult(
    label: "10-A",
    uiTitle: "Konut (Daire, mesken).",
    uiSubtitle: "Kullanıcı Yükü Katsayısı: 10 m²/kişi",
    reportText: "(Hesaplamada kullanılır: \"Konut Kullanımı\")"
  );

  static final azYogunTicari = ChoiceResult(
    label: "10-B",
    uiTitle: "Az yoğun ticari alan.",
    uiSubtitle: "Büro, ofis, oto galeri vb. (10 m²/kişi)",
    reportText: "(Hesaplamada kullanılır: \"Ticari Kullanım - Az Yoğun\")"
  );

  static final ortaYogunTicari = ChoiceResult(
    label: "10-C",
    uiTitle: "Orta yoğun ticari alan.",
    uiSubtitle: "Market, mağaza, banka vb. (5 m²/kişi)",
    reportText: "(Hesaplamada kullanılır: \"Ticari Kullanım - Orta Yoğun\")"
  );

  static final yuksekYogunTicari = ChoiceResult(
    label: "10-D",
    uiTitle: "Yüksek yoğun ticari alan.",
    uiSubtitle: "Restaurant, cafe, spor salonu vb. (1.5 m²/kişi)",
    reportText: "(Hesaplamada kullanılır: \"Ticari Kullanım - Yüksek Yoğun\")"
  );

  static final teknikDepo = ChoiceResult(
    label: "10-E",
    uiTitle: "Otopark, depo veya teknik hacim.",
    uiSubtitle: "İnsan yoğunluğu az olan alanlar. (30 m²/kişi)",
    reportText: "(Hesaplamada kullanılır: \"Teknik/Depo Kullanımı\")"
  );
}
class Bolum11Content {
  // --- ADIM 1: MESAFE ---
  static final mesafeOptionA = ChoiceResult(
    label: "11-1-A",
    uiTitle: "Hayır, aşmıyor.",
    uiSubtitle: "İtfaiye aracı binanın tüm cephelerine 45 metre içerisinde ulaşabilir.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: İtfaiye yaklaşım mesafesi uygun (Tüm cepheler 45 metre menzil içerisinde)."
  );

  static final mesafeOptionB = ChoiceResult(
    label: "11-1-B",
    uiTitle: "Evet, aşıyor.",
    uiSubtitle: "İtfaiye aracı binanın tüm cephelerine 45 metre içerisinde ulaşamaz.",
    reportText: "☢️ KIRMIZI RİSK: İtfaiye yaklaşım mesafesi sınırın üzerinde! Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir. Mevcut durumda binanın bazı cephelerine müdahale edilemeyebilir."
  );

  static final mesafeOptionC = ChoiceResult(
    label: "11-1-C",
    uiTitle: "İtfaiye yaklaşım mesafesini bilmiyorum.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Uzman Görüşü alınması tavsiye edilir. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir."
  );

  // --- ADIM 2: ENGEL ---
  static final engelOptionA = ChoiceResult(
    label: "11-2-A",
    uiTitle: "Hayır, engel yok.",
    uiSubtitle: "Araç binanın dibine kadar gelebiliyor, engelleyen bir duvar yok.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: İtfaiye aracı binaya yaklaşabiliyor, fiziksel engel bulunmuyor. Kilitli kapılar olsa bile bina güvenliği veya yönetim tarafından kilidi açılabiliyor."
  );

  static final engelOptionB = ChoiceResult(
    label: "11-2-B",
    uiTitle: "Evet, duvar, kapı, çit gibi engel mevcut.",
    uiSubtitle: "İtfaiye aracı binaya kolayca erişemiyor.",
    reportText: "🚨 RİSKLİ: İtfaiye erişimini zorlaştıran fiziksel engeller (duvar, kapı vs.) tespit edilmiştir."
  );

  static final engelOptionC = ChoiceResult(
    label: "11-2-C",
    uiTitle: "İtfaiye aracının binamıza yaklaşım imkanını bilmiyorum.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Mesafenin aşılmasının sebebinin duvar olup olmadığı bilinmiyor. Kontrol edilmesi ve Uzman Görüşü alınması tavsiye edilir."
  );

  // --- ADIM 3: ZAYIF NOKTA ---
  static final zayifNoktaOptionA = ChoiceResult(
    label: "11-3-A",
    uiTitle: "Evet, var.",
    uiSubtitle: "İşaretlenmiş veya zayıflatılmış geçiş noktası mevcut.",
    reportText: "✅ OLUMLU (Şartlı): Duvar, çit, kapı vb. engeli var ancak yıkılabilir geçiş bölgesi mevcut. Lütfen bu alanın önüne araç park edilmemesine dikkat ediniz."
  );

  static final zayifNoktaOptionB = ChoiceResult(
    label: "11-3-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Herhangi bir zayıflatılmış geçiş noktası yok.",
    reportText: "☢️ KIRMIZI RİSK: İtfaiye erişimini engelleyen duvarlarda, acil durum geçişi için zayıflatılmış ve işaretlenmiş özel bir bölüm bulunmak zorundadır. Aksi takdirde itfaiye binaya ulaşamaz."
  );
}
 class Bolum12Content {
  static final celikOptionA = ChoiceResult(
    label: "12-A (Çelik)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Çelik kolon ve kirişlerin üzeri yangın geciktirici boya, püskürtme sıva, alçıpanel vb. ile kaplanmıştır.",
    reportText: "✅ OLUMLU: Çelik taşıyıcı sistem üzerinde pasif yangın yalıtım uygulaması mevcuttur. Bu uygulama, yangın anında çeliğin kritik sıcaklık olan 540°C'ye ulaşmasını geciktirerek binanın çökme riskini minimize eder."
  );

  static final celikOptionB = ChoiceResult(
    label: "12-B (Çelik)",
    uiTitle: "Hayır yok, çelik taşıyıcı profiller çıplak halde.",
    uiSubtitle: "Binanın iskeletini oluşturan çelik elemanlar üzerinde herhangi bir kaplama bulunmamaktadır.",
    reportText: "☢️ KIRMIZI RİSK: Çok katlı veya 5000 m²'den büyük çelik yapılarda çıplak çelik kullanımı hayati risk taşır! 540°C sıcaklıkta çelik taşıma gücünü kaybeder ve bina aniden çökebilir. Acilen yangın yalıtımı planlanmalıdır."
  );

  static final celikOptionC = ChoiceResult(
    label: "12-C (Çelik)",
    uiTitle: "Bilmiyorum, bir gözlemim yok.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Çelik elemanlarda yangın koruması olup olmadığı bilinmiyor. Koruma yoksa, yangın anında bina taşıma kapasitesini hızla kaybedebilir. Uzman Görüşü alınarak yalıtım durumu netleştirilmesi önerilir."
  );

    static final betonOptionA = ChoiceResult(
    label: "12-A (Beton)",
    uiTitle: "Bina yapım tarihimiz 2000 yılı sonrası.",
    uiSubtitle: "TS 500 standardı uyarınca, paspayı ölçülerinin (Kolon ≥ 35mm, Kiriş ≥ 25mm) uygun olduğu varsayılmıştır.",
    reportText: "✅ OLUMLU: TS 500 standardı uyarınca, binanızın inşa tarihi baz alınarak paspayı ölçülerinin uygun olduğu varsayılmıştır."
  );

  static final betonOptionB = ChoiceResult(
    label: "12-B (Beton)",
    uiTitle: "Binadaki paspayı ölçülerini biliyorum, kendim gireceğim.",
    uiSubtitle: "Betonun içindeki demiri örten tabaka kalınlıklarını manuel gireceğim.",
    reportText: "(Girilen değerlere göre otomatik analiz edilir)"
  );

  // YENİ EKLENEN C ŞIKKI
  static final betonOptionC = ChoiceResult(
    label: "12-C (Beton)",
    uiTitle: "Bina yapım tarihimiz 2000 yılı öncesi.",
    uiSubtitle: "Eski standartlara göre inşa edilen yapılarda paspayı koruması zayıf olabilir.",
    reportText: "⚠️ UYARI: Bina yapım tarihi 2000 yılı öncesi olduğu için paspayı ölçülerinin (demir üzerindeki beton tabakası) güncel TS 500 standartlarını karşılamama ihtimali yüksektir. Yangın anında taşıyıcı sistemin korunması için detaylı inceleme yapılmalıdır."
  );

  static final betonOptionD = ChoiceResult(
    label: "12-D (Beton)",
    uiTitle: "Paspayı durumunu bilmiyorum.",
    uiSubtitle: "Beton içindeki demir koruma tabakası hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Paspayı kalınlığı bilinmediği için yapısal yangın dayanım tahmini yapılamamıştır. Uzman incelemesi tavsiye edilir."
  );

  static final ahsapOptionA = ChoiceResult(
    label: "12-A (Ahşap)",
    uiTitle: "İnce keresteler (10 cm'den ince).",
    uiSubtitle: "Taşıyıcı kolon ve kirişler ince ahşap plakalardan veya kerestelerden oluşmaktadır.",
    reportText: "☢️ KIRMIZI RİSK: İnce ahşap kesitler yangında çok hızlı yanarak (yaklaşık 0.8mm/dk) taşıma gücünü kaybeder. Bu durum, yangın başlangıcından kısa süre sonra binanın çökme riskini doğurur."
  );

  static final ahsapOptionB = ChoiceResult(
    label: "12-B (Ahşap)",
    uiTitle: "Kalın kütükler / Lamine kirişler.",
    uiSubtitle: "Taşıyıcı sistemde 10 cm'den daha kalın, masif veya lamine ahşap elemanlar kullanılmıştır.",
    reportText: "✅ OLUMLU: Kalın kesitli ahşaplar, yangın anında dış yüzeyi kömürleşerek iç kısmını korur ve yangına daha uzun süre direnç gösterir."
  );

  static final yigmaOptionA = ChoiceResult(
    label: "12-A (Yığma)",
    uiTitle: "Evet, duvarlar kalın (19 cm+).",
    uiSubtitle: "Binanın yükünü taşıyan dış duvarlar en az bir tuğla boyu (19 cm) veya daha kalındır.",
    reportText: "✅ OLUMLU: En az 19 cm kalınlığındaki kagir duvarlar, yönetmeliklere uygun inşa edildiyse yüksek yangın dayanımı sağlayarak binanın stabilitesini korur."
  );

  static final yigmaOptionB = ChoiceResult(
    label: "12-B (Yığma)",
    uiTitle: "Hayır, daha ince duvarlar var.",
    uiSubtitle: "Taşıyıcı duvarların kalınlığı 19 cm'den daha azdır.",
    reportText: "⚠️ UYARI: Taşıyıcı duvar kalınlığı 19 cm'den az ise yangın anında yeterli yapısal stabilite sağlanamayabilir. Uzman tarafından kontrol edilmesi önerilir."
  );
}
class Bolum13Content {
  static final otoparkOptionA = ChoiceResult(
    label: "13-1-A (Otopark)",
    uiTitle: "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan yangın kapısı bulunmakta.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Otopark ile bina arasındaki geçişte yangına dayanıklı ve duman sızdırmaz kapı mevcuttur. Bu kapı, olası bir araç yangınında dumanın merdiven boşluğuna dolmasını engelleyerek tahliye güvenliğini sağlar."
  );

  static final otoparkOptionB = ChoiceResult(
    label: "13-1-B (Otopark)",
    uiTitle: "Yangına dayanıksız sac, demir, plastik, aluminyum, ahşap vb. kapı bulunmakta.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Otopark kapısı yangına dayanıksızdır. Yönetmelik gereği bu kapı en az 90 dakika yangın dayanımlı, duman sızdırmaz ve kendiliğinden kapanan bir kapı olmalıdır. Mevcut kapı, yangın anında ısı ve dumanı saniyeler içinde yaşam alanlarına geçirebilir."
  );

  static final otoparkOptionC = ChoiceResult(
    label: "13-1-C (Otopark)",
    uiTitle: "Arada kapı yok, direkt açık (serbest) geçiş var.",
    uiSubtitle: "Otopark ile merdiven (veya asansör holü) arasında herhangi bir yangın kapısı bulunmamaktadır.",
    reportText: "☢️ KRİTİK RİSK: Otopark ile bina arasında kompartıman ayrımı yoktur! Bir araç yangınında duman doğrudan binanın içine dolarak tüm kaçış yollarını kapatabilir. Acilen yangın duvarı ve kapısı ile ayrım yapılmalıdır."
  );

  static final otoparkOptionD = ChoiceResult(
    label: "13-1-D (Otopark)",
    uiTitle: "Arada böyle bir kapı veya geçiş var mı yok mu emin değilim.",
    uiSubtitle: "Kapının teknik özellikleri hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Otopark kapısının teknik özellikleri bilinmiyor. Kapı yangına dayanıklı olmalıdır. Geçiş noktasıyla ilgili Uzman Görüşü alınması tavsiye edilir."
  );

  static final kazanOptionA = ChoiceResult(
    label: "13-2-A (Kazan D.)",
    uiTitle: "Mahalin duvarları kalın betondan, kapısı ise çelik yangın kapısı ve dışarıya doğru açılmaktadır.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Kazan dairesi kompartımanyasonu ve kapı özellikleri uygun gözükmektedir. Kazan dairesi duvarları yangına en az 120 dk, kapıları en az 90dk. yangın dayanıma sahip olması gereklidir. Aksi halde burada olası bir yangın hızlıca bina içerisine sirayet edebilir."
  );

  static final kazanOptionB = ChoiceResult(
    label: "13-2-B (Kazan D.)",
    uiTitle: "Mahal kapısı plastik, ahşap, cam vs. ve içeriye doğru açılıyor.",
    uiSubtitle: "Kapı malzemesi yangına dayanıksızdır veya açılış yönü bina içine doğrudur.",
    reportText: "☢️ RİSK: Kazan dairesi kapısı yangına dayanıklı olmalı ve kaçış yönüne (dışarıya) açılması önerilir. İçeri açılan kapılar, patlama veya panik anında basınç nedeniyle açılamaz hale gelerek içeridekileri hapsedebilir."
  );

  static final kazanOptionC = ChoiceResult(
    label: "13-2-C (Kazan D.)",
    uiTitle: "Kazan dairesi binadan tamamen ayrı bir yerde.",
    uiSubtitle: "Kazan dairesi bina kütlesinin dışında, bahçede veya ayrı bir yapıdadır.",
    reportText: "✅ OLUMLU: Kazan dairesi binadan ayrı bir yerdedir. Olası bir yangında veya patlamada binaya etkisi az olacaktır."
  );

  static final kazanOptionD = ChoiceResult(
    label: "13-2-D (Kazan D.)",
    uiTitle: "Duvar ve kapı özelliklerini bilmiyorum.",
    uiSubtitle: "Kazan dairesinin yapısal özellikleri hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Kazan dairesinin duvar ve kapı özellikleri bilinmiyor. Özellikle bina içerisinde yer alan kazan dairesindeki yangın güvenlik önlemleri hayati önem taşır, Uzman Görüşü alınması tavsiye edilir."
  );

  static final asansorOptionA = ChoiceResult(
    label: "13-3-A (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı.",
    uiSubtitle: " .",
    reportText: "✅ OLUMLU: Asansör kat / kabin kapıları yangına dayanıklıdır."
  );

  static final asansorOptionB = ChoiceResult(
    label: "13-3-B (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı değil.",
    uiSubtitle: " ",
    reportText: "⚠️ UYARI: Asansör kat / kabin kapıları yangına dayanıklı değildir. Makine daireleri yangın riski taşır, kapı dayanıklı olmalıdır."
  );

  static final asansorOptionC = ChoiceResult(
    label: "13-3-C (Asansör)",
    uiTitle: "Bu konuda bir bilgim yok.",
    uiSubtitle: "Asansör kapılarının dayanım özellikleri bilinmiyor.",
    reportText: "❓ BİLİNMİYOR: Kapı özellikleri bilinmiyor, duvarlarıyla birlikte kapısının da yangına dayanıklı olması gereklidir. Uzman Görüşü alınması tavsiye edilir."
  );

  static final jeneratorOptionA = ChoiceResult(
    label: "13-5-A (Jeneratör)",
    uiTitle: "Yangına dayanıklı duvar ve kapı ile ayrılmış.",
    uiSubtitle: "Jeneratör odası binanın geri kalanından izole edilmiştir.",
    reportText: "✅ OLUMLU: Jeneratör odası yangına dayanıklı duvar ve kapı ile ayrılmıştır."
  );

  static final jeneratorOptionB = ChoiceResult(
    label: "13-5-B (Jeneratör)",
    uiTitle: "Jeneratör, bina içerisinde açıkta muhafaza ediliyor veya basit bir bölme (dayanımsız duvar ve kapı) ile ayrılmış.",
    uiSubtitle: " ",
    reportText: "☢️ RİSK: Jeneratör yakıtı risklidir, bu mahal yangın dayanımlı duvar ve yangın kapısı ile binanında geri kalanından ayrılmalıdır."
  );

  static final jeneratorOptionC = ChoiceResult(
    label: "13-5-C (Jeneratör)",
    uiTitle: "Jeneratör odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın yalıtım ve kapı durumu hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Jeneratör odası özellikleri bilinmiyor. Jeneratör yakıtı risklidir, bu mahal yangın dayanımlı duvar ve yangın kapısı ile binanında geri kalanından ayrılmalıdır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final elekOdasiOptionA = ChoiceResult(
    label: "13-6-A (Elektrik Odası)",
    uiTitle: "Çelik, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle: "Elektrik panolarının olduğu oda özel bir kapı ile korunmaktadır.",
    reportText: "✅ OLUMLU: Elektrik odası yangına dayanıklı ve duman sızdırmaz kapı ile korunmaktadır."
  );

  static final elekOdasiOptionB = ChoiceResult(
    label: "13-6-B (Elektrik Odası)",
    uiTitle: "Normal, dayanımsız (demir, plastik, ahşap, cam vs.) kapı.",
    uiSubtitle: "Elektrik odasında dayanımsız bir kapı mevcuttur.",
    reportText: "⚠️ UYARI: Elektrik odaları yangın başlangıç noktası olma ihtimali yüksektir, yangın dayanım özellikleri olması şarttır."
  );

  static final elekOdasiOptionC = ChoiceResult(
    label: "13-6-C (Elektrik Odası)",
    uiTitle: "Elektrik odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın kapı ve duvar dayanımı hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Elektrik odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final trafoOptionA = ChoiceResult(
    label: "13-7-A (Trafo)",
    uiTitle: "Çelik, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle: "Trafo odası özel bir yangın kapısı ile korunmaktadır.",
    reportText: "✅ OLUMLU: Trafo odasının kapısı kilitli, yangına dayanıklı ve duman sızdırmaz özelliklidir."
  );

  static final trafoOptionB = ChoiceResult(
    label: "13-7-B (Trafo)",
    uiTitle: "Normal, dayanımsız (demir, plastik, ahşap, cam vb.) kapı.",
    uiSubtitle: "Standart bir kapı veya ince sac kapı mevcuttur.",
    reportText: "⚠️ UYARI: Yağlı tip trafo odaları yüksek yangın riski taşır. Kapı ve duvarların yangın dayanım özellikli olması şarttır. Mevcut kapı bu riski karşılamamaktadır."
  );

  static final trafoOptionC = ChoiceResult(
    label: "13-7-C (Trafo)",
    uiTitle: "Trafo odası kapı özelliklerini bilmiyorum.",
    uiSubtitle: "Kapının dayanım özellikleri hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Yağlı tip trafo odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Uzman Görüşü alınarak kapı tipi teyit edilmelidir."
  );

  static final depoOptionA = ChoiceResult(
    label: "13-8-A (Depo)",
    uiTitle: "Çelik, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle: "Depo girişi dayanıklı bir kapı ile korunmaktadır. Binanın geri kalanından korunaklı şekilde ayrılmıştır.",
    reportText: "✅ OLUMLU: Ortak depo/ardiye alanının kapısı metal yangın kapısı veya sac kapıdır."
  );

  static final depoOptionB = ChoiceResult(
    label: "13-8-B (Depo)",
    uiTitle: "Ahşap kapı, tel örgü veya kapısız.",
    uiSubtitle: "Depo alanı açıkta veya dayanıksız bir kapı ile ayrılmıştır.",
    reportText: "⚠️ UYARI: Depolardaki eşyalar büyük yangın yükü oluşturur. Duman sızdırmaz ve yangına dayanıklı kapı kullanılması önerilir. Mevcut durum yangının yayılmasını kolaylaştırabilir."
  );

  static final depoOptionC = ChoiceResult(
    label: "13-8-C (Depo)",
    uiTitle: "Depo kapısı özelliklerini bilmiyorum.",
    uiSubtitle: "Kapının sızdırmazlık durumu hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Kapı durumu bilinmiyor. Depolarda duman sızdırmazlığı önemlidir. Uzman Görüşü alınması tavsiye edilir."
  );

  static final copOptionA = ChoiceResult(
    label: "13-9-A (Çöp O.)",
    uiTitle: "Duman sızdırmaz yangın kapısı ve havalandırma mevcut.",
    uiSubtitle: "Çöp odasında özel kapı ve aktif/pasif havalandırma sistemi vardır.",
    reportText: "✅ OLUMLU: Çöp toplama odasında duman sızdırmaz yangın kapısı ve havalandırma mevcuttur."
  );

  static final copOptionB = ChoiceResult(
    label: "13-9-B (Çöp O.)",
    uiTitle: "Normal kapı veya havalandırma yok.",
    uiSubtitle: "Standart kapı kullanılmıştır veya havalandırma menfezi bulunmamaktadır.",
    reportText: "☢️ RİSK: Çöp odaları metan gazı birikme riski taşır. Kapı yangına dayanıklı olmalı ve oda mutlaka havalandırılmalıdır. Mevcut durum patlama veya zehirlenme riski oluşturabilir."
  );

  static final copOptionC = ChoiceResult(
    label: "13-9-C (Çöp O.)",
    uiTitle: "Çöp odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın kapı ve havalandırma durumu hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Çöp odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final ortakDuvarOptionA = ChoiceResult(
    label: "13-10-A (Ortak Duvar)",
    uiTitle: "Kalın tuğla veya beton duvar (En az 20-25cm).",
    uiSubtitle: "Yan bina ile aradaki duvar kalın ve masif bir yapıdadır.",
    reportText: "✅ OLUMLU: Yan bina ile ortak kullanılan duvar kalın tuğla veya betondur (En az 20-25cm)."
  );

  static final ortakDuvarOptionB = ChoiceResult(
    label: "13-10-B (Ortak Duvar)",
    uiTitle: "İnce bölme duvar.",
    uiSubtitle: "Yan bina ile aradaki duvar ince ve zayıf bir yapıdadır.",
    reportText: "☢️ RİSK: Ortak duvarlar en az 90 dk yangına dayanıklı olmalıdır."
  );

  static final ortakDuvarOptionC = ChoiceResult(
    label: "13-10-C (Ortak Duvar)",
    uiTitle: "Ortak duvarın cinsini bilmiyorum.",
    uiSubtitle: "Yan bina ile aradaki duvarın yapısı hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Bitişik nizam bina ile aradaki duvarın kalınlığı bilinmiyor. Duvarın 90 dk dayanım gösterecek özellikte olması şarttır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final ticariOptionA = ChoiceResult(
    label: "13-11-A (Ticari)",
    uiTitle: "Tamamen ayrı girişleri var, bina içinden bağlantı yok.",
    uiSubtitle: "Dükkan/Ofis girişi sokağa bakmaktadır, bina koridoruyla bağlantısı yoktur.",
    reportText: "✅ OLUMLU: Ticari alanların tamamen ayrı girişleri var, bina içinden bağlantı yok."
  );

  static final ticariOptionB = ChoiceResult(
    label: "13-11-B (Ticari)",
    uiTitle: "Aynı merdiven boşluğunu kullanıyorlar.",
    uiSubtitle: "Dükkan/Ofis kapısı bina sakinlerinin kullandığı koridora açılmaktadır.",
    reportText: "(Alt soruya göre belirlenir) Hayır ise: ☢️ RİSK: Farklı kullanımlar yangın kompartımanı ile ayrılmalıdır."
  );

  static final ticariOptionC = ChoiceResult(
    label: "13-11-C (Ticari)",
    uiTitle: "Ticari alan geçiş durumunu bilmiyorum.",
    uiSubtitle: "Dükkanların bina içiyle bağlantısı olup olmadığını bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Farklı kullanım alanlarındaki geçiş bilinmiyor, Uzman Görüşü alınması tavsiye edilir."
  );
}
class Bolum14Content {
  static const String title = "Bölüm-14: Tesisat Şaftları";
  static const String msgHigh = "Binanız 30.50 metreden yüksek olduğundan tüm tesisat şaft duvarları en az 120 dk, şaft kapakları ise en az 90 dk yangına dayanıklı ve duman sızdırmaz özellikte olmalıdır.";
  static const String msgMid = "Binanız 21.50m - 30.50m aralığında olup ‘Yüksek Bina’ sınıfındadır. Tesisat şaftı ve yangın duvarlarınızın en az 90 dk, şaft kapaklarınızın ise en az 60 dk dayanıklı, duman sızdırmaz özellikte olmaları gerekmektedir.";
  static const String msgDeepBasement = "DİKKAT: Binanız alçak olsa da, bodrum kat derinliğiniz 10 metreyi aştığı için bodrum katlarınız risk taşımaktadır. Bodrumdaki şaft duvarları en az 90 dk ve şaft kapakların dayanımları en az 60dk, zemin üst normal katlarda ise duvarları en az 60dk, kapakları en az 30dk olmalıdır.";
  static const String msgStandard = "Binanızın yüksekliği ve bodrum derinliği yüksek olmayan bina sınırları içindedir. Tesisat şaft duvarları en az 60 dk, şaft kapakları ise en az 30 dk dayanıklı olması yeterlidir.";
}
class Bolum15Content {
  static final kaplamaOptionA = ChoiceResult(
    label: "15-1-A",
    uiTitle: "Ahşap parke, laminat, pvc vinil, karo halı",
    uiSubtitle: "Yanıcılık gösterebilen malzemeler.",
    reportText: "⚠️ UYARI: Döşeme kaplamasının yanıcılık sınıfı kontrol edilmelidir."
  );

  static final kaplamaOptionB = ChoiceResult(
    label: "15-1-B",
    uiTitle: "Taş, seramik, mermer veya özel yanmaz kaplama.",
    uiSubtitle: "Limitli yanıcılık gösteren malzemeler.",
    reportText: "✅ OLUMLU: Zemin kaplaması yanmaz malzeme olarak beyan edilmiştir."
  );

  static final kaplamaOptionC = ChoiceResult(
    label: "15-1-C",
    uiTitle: "Kaplama malzemesini bilmiyorum.",
    uiSubtitle: "Zemin kaplamasının cinsi belirsiz.",
    reportText: "❓ BİLİNMİYOR: Zemin kaplamasının yanıcılık sınıfı bilinmiyor."
  );

  static final yalitimOptionA = ChoiceResult(
    label: "15-2-A",
    uiTitle: "Hayır, ısı yalıtım yok.",
    uiSubtitle: "Döşeme betonunda yalıtım bulunmuyor.",
    reportText: "✅ OLUMLU: Döşeme betonu altında yanıcı yalıtım bulunmamaktadır."
  );

  static final yalitimOptionB = ChoiceResult(
    label: "15-2-B",
    uiTitle: "Evet, ısı yalıtımı (strafor/köpük vb.) var.",
    uiSubtitle: "Yanıcı malzemeler tespit edildi.",
    reportText: "⚠️ RİSK: Yanıcı yalıtım malzemesi kullanımı tespit edilmiştir."
  );

  static final yalitimOptionC = ChoiceResult(
    label: "15-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Zemin detayına erişilemiyor.",
    reportText: "❓ BİLİNMİYOR: Zemin altında yanıcı köpük olup olmadığı bilinmiyor."
  );

  static final yalitimSapOptionA = ChoiceResult(
    label: "15-2-ALT-A",
    uiTitle: "Evet, en az 2 cm şap var.",
    uiSubtitle: "Beton koruma katmanı mevcut.",
    reportText: "✅ OLUMLU: Yanıcı yalıtım şap ile korunmuştur."
  );

  static final yalitimSapOptionB = ChoiceResult(
    label: "15-2-ALT-B",
    uiTitle: "Hayır, şap yok.",
    uiSubtitle: "Yalıtım malzemesi çıplak durumda.",
    reportText: "☢️ KIRMIZI RİSK: Yalıtımın üzeri şap ile örtülmelidir."
  );

  static final yalitimSapOptionC = ChoiceResult(
    label: "15-2-ALT-C",
    uiTitle: "Bilmiyorum / Göremiyorum.",
    uiSubtitle: "Şap tabakası belirsiz.",
    reportText: "⚠️ RİSK: Koruyucu şap tabakası olup olmadığı bilinmiyor."
  );

  static final tavanOptionA = ChoiceResult(
    label: "15-3-A",
    uiTitle: "Hayır, asma tavan yok.",
    uiSubtitle: "Tavanlar direkt beton üzeri sıva/boya.",
    reportText: "✅ OLUMLU: Tavanlarda asma tavan bulunmamaktadır."
  );

  static final tavanOptionB = ChoiceResult(
    label: "15-3-B",
    uiTitle: "Evet, asma tavan var.",
    uiSubtitle: "Tavan seviyesi düşürülmüş uygulama.",
    reportText: "⚠️ UYARI: Asma tavan malzemesi kontrol edilmelidir."
  );

  static final tavanOptionC = ChoiceResult(
    label: "15-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Tavan yapısı belirsiz.",
    reportText: "❓ BİLİNMİYOR: Tavan yapısı hakkında bilgi yok."
  );

  static final tavanMalzemeOptionA = ChoiceResult(
    label: "15-3-ALT-A",
    uiTitle: "Alçıpanel, metal vb. yanmaz malzeme.",
    uiSubtitle: "A1 veya A2 sınıfı malzemeler.",
    reportText: "✅ OLUMLU: Asma tavan malzemesi yanmaz sınıftadır."
  );

  static final tavanMalzemeOptionB = ChoiceResult(
    label: "15-3-ALT-B",
    uiTitle: "Ahşap, plastik, lambiri vb. yanıcı malzeme.",
    uiSubtitle: "Kolay alevlenici dekoratif malzemeler.",
    reportText: "☢️ KIRMIZI RİSK: Tavan malzemeleri yanıcı seçilmiştir."
  );

  static final tavanMalzemeOptionC = ChoiceResult(
    label: "15-3-ALT-C",
    uiTitle: "Malzemeyi bilmiyorum.",
    uiSubtitle: "Yanıcılık sınıfı belirsiz.",
    reportText: "⚠️ UYARI: Asma tavan malzemesinin yanıcılığı bilinmiyor."
  );

  static final tesisatOptionA = ChoiceResult(
    label: "15-4-A",
    uiTitle: "Beton, harç veya yanmaz mastik ile kapatılmış.",
    uiSubtitle: "Sızdırmazlık sağlanmış.",
    reportText: "✅ OLUMLU: Tesisat geçişleri yalıtılmıştır."
  );

  static final tesisatOptionB = ChoiceResult(
    label: "15-4-B",
    uiTitle: "Boşluklar var veya yanıcı köpük sıkılmış.",
    uiSubtitle: "Duman geçişine açık noktalar.",
    reportText: "☢️ KIRMIZI RİSK: Tesisat geçişlerinde boşluklar mevcuttur."
  );

  static final tesisatOptionC = ChoiceResult(
    label: "15-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Tesisat geçişleri kapalı durumda.",
    reportText: "❓ BİLİNMİYOR: Tesisat şaft yalıtımı bilinmiyor."
  );
}
class Bolum16Content {
  static final mantolamaOptionA = ChoiceResult(
    label: "16-1-A (Mantolama)",
    uiTitle: "Klasik Mantolama (EPS, XPS vb.).",
    uiSubtitle: "Dış cephede sıva altında köpük esaslı ısı yalıtım levhaları kullanılmıştır.",
    reportText: "(Yüksek Bina İse) ☢️ KIRMIZI RİSK: 28.50 metreden yüksek binalarda EPS, XPS vb. gibi yanıcı malzemeler kullanılamaz. Cephe malzemesinin 'Hiç Yanmaz' (A1) veya 'Zor Yanıcı' (A2) olması gerekir. Mevcut cephe, yangını çatıya kadar taşıyabilir.<br>(Alçak Bina İse) ⚠️ UYARI (BARİYER KONTROLÜ): 28.50m altındaki binalarda EPS, XPS kullanılabilir ANCAK pencerelerin etrafında ve zemin seviyesinde (1.5m) taşyünü gibi yanmaz malzemeden 'Yangın Bariyeri' yapılması ZORUNLUDUR."
  );

  static final mantolamaOptionB = ChoiceResult(
    label: "16-1-B (Mantolama)",
    uiTitle: "A1 veya A2 sınıf taşyünü ile mantolama.",
    uiSubtitle: "Dış cephede yanmaz özellikli taşyünü levhalar kullanılmıştır.",
    reportText: "✅ OLUMLU: Dış cephe yalıtımında yanmaz (A1 veya A2 sınıfı) taşyünü malzeme kullanılmıştır. Bu tercih, cephe yangınlarının yayılmasını engelleyebilir."
  );

  static final giydirmeOptionC = ChoiceResult(
    label: "16-1-C (Giydirme)",
    uiTitle: "Giydirme cephe (Cam, kompozit vb.).",
    uiSubtitle: "Bina dış yüzeyi alüminyum, cam veya kompozit panellerle kaplanmıştır.",
    reportText: "(Alt soruya göre belirlenir)<br>Boşluk Yok: ✅ OLUMLU: Giydirme cephe ile döşeme arasındaki boşluklar yangına dayanıklı malzeme ile yalıtılmıştır.<br>Boşluk Var: ☢️ KIRMIZI RİSK: Giydirme cephe ile döşeme arasındaki boşluklar, yangını ve dumanı üst katlara taşıyan en tehlikeli noktalardır (Baca Etkisi). Bu boşluklar acilen yalıtılmalıdır."
  );

  static final mantolamaOptionD = ChoiceResult(
    label: "16-1-D (Sıva/Boya)",
    uiTitle: "Cephede sadece sıva ve boya var (yalıtım yok).",
    uiSubtitle: "Dış cephede herhangi bir ısı yalıtım katmanı bulunmamaktadır.",
    reportText: "✅ OLUMLU: Dış cephede yanıcı bir yalıtım malzemesi bulunmamaktadır. Yangın yükü oluşturmaz."
  );

  static final mantolamaOptionE = ChoiceResult(
    label: "16-1-E (Bilinmiyor)",
    uiTitle: "Cephe malzemesini bilmiyorum.",
    uiSubtitle: "Dış cephedeki malzemenin cinsi veya yanıcılık sınıfı hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Dış cephe malzemesi bilinmiyor. Yüksek binalarda yanıcı malzeme kullanımı ölümcül risk taşır. Dış cephe sisteminin veya kullanılan malzemelerin test raporları sorgulanmalıdır."
  );

  static final sagirYuzeyOptionA = ChoiceResult(
    label: "16-2-A (Sağır Yüzey)",
    uiTitle: "Cephede en az 100 cm yüksekliğinde yangın dayanımlı (beton, tuğla  vb.) dolu yüzey var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Katlar arasındaki yanmaz dolu yüzey yüksekliği 100 cm şartını sağlamaktadır. Bu mesafe, alevin bir kattan diğerine sıçramasını zorlaştırır."
  );

  static final sagirYuzeyOptionB = ChoiceResult(
    label: "16-2-B (Sağır Yüzey)",
    uiTitle: "Cephede 100 cm’den az yükseklikte yangına dayanımlı yüzey var.",
    uiSubtitle: "Pencereler birbirine çok yakın, aradaki duvar mesafesi 1 metreden az.",
    reportText: "(Alt soruya göre belirlenir)<br>Sprinkler Var: ✅ OLUMLU (Şartlı): Dolu yüzey yüksekliği yetersiz olsa da, cepheye bakan özel sprinkler sistemi riski azaltmaktadır.<br>Sprinkler Yok: ☢️ KIRMIZI RİSK: Katlar arasındaki yangına dayanıklı yüzey yüksekliği 100 cm'den azdır. Yangın bir kattan diğerine kolayca sıçrayabilir. Cephe sprinklerı veya yangın bariyeri gereklidir."
  );

  static final sagirYuzeyOptionC = ChoiceResult(
    label: "16-2-C (Sağır Yüzey)",
    uiTitle: "Bu detay hakkında hiç fikrim yok.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Katlar arasındaki yangına dayanıklı yüzey yüksekliği bilinmiyor. 100 cm'den az ise yangın dikeyde hızla yayılabilir. Uzman Görüşü alınması tavsiye edilir."
  );

  static final bitisikOptionA = ChoiceResult(
    label: "16-3-A (Bitişik)",
    uiTitle: "Hayır, aynı yükseklikteyiz veya daha alçaktayız.",
    uiSubtitle: "Yan bina ile çatı seviyemiz aynı veya bizim binamız daha alçakta.",
    reportText: "✅ OLUMLU: Binalar aynı hizada olduğu için yan binadan cepheye yangın sıçrama riski düşüktür."
  );

  static final bitisikOptionB = ChoiceResult(
    label: "16-3-B (Bitişik)",
    uiTitle: "Evet, bizim bina daha yüksek.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Yan binanın çatısının bittiği hizaya denk gelen dış cephe kaplamanız 'Hiç Yanmaz' (A1 sınıfı) malzeme olmalıdır. Aksi takdirde yan binanın çatısında çıkacak yangın sizin cephenizi tutuşturabilir."
  );

  static final bitisikOptionC = ChoiceResult(
    label: "16-3-C (Bitişik)",
    uiTitle: "Yükseklik durumunu bilmiyorum.",
    uiSubtitle: "Yan bina ile olan yükseklik ilişkimizi tam olarak bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Bitişik bina ile yükseklik durumu bilinmiyor. Eğer yan binadan yüksekseniz, o bölgedeki cephe malzemesinin yangına tepki sınıfı kritik öneme sahiptir."
  );
}
class Bolum17Content {
  static final kaplamaOptionA = ChoiceResult(
    label: "17-1-A (Kaplama)",
    uiTitle: "Kiremit, metal kenet, beton, taş vb. türünde yanmaz malzeme.",
    uiSubtitle: "Çatı yüzeyi yanmaz (A1 sınıf) malzemeyle kaplanmıştır.",
    reportText: "✅ OLUMLU: Çatı kaplamasında hiç yanmaz (A1 sınıfı) malzeme kullanılmıştır. Bu durum, dışarıdan gelebilecek kıvılcımlara karşı koruma sağlar."
  );

  static final kaplamaOptionB = ChoiceResult(
    label: "17-1-B (Kaplama)",
    uiTitle: "Shingle, Onduline veya Membran.",
    uiSubtitle: "Çatı yüzeyinde petrol türevi (bitümlü) örtüler kullanılmıştır.",
    reportText: "⚠️ UYARI: Çatıda kullanılan bitümlü örtüler (Shingle/Membran) yanıcı özellik gösterebilir. Bu malzemelerin 'BROOF' özellikli (dış yangına karşı dayanıklı) olması gerekmektedir."
  );

  static final kaplamaOptionC = ChoiceResult(
    label: "17-1-C (Kaplama)",
    uiTitle: "Sandviç Panel (İçi yanıcı)",
    uiSubtitle: "İçi XPS, EPS, PIR, PUR, poliüretan vb. yanıcı dolgulu panel ile kaplanmıştır.",
    reportText: "☢️ RİSK: Yanıcı madde dolgulu sandviç paneller yangını çok hızlı yayar ve söndürülmesi zordur. Taşyünü dolgulu paneller tercih edilmelidir."
  );

  static final kaplamaOptionD = ChoiceResult(
    label: "17-1-D (Kaplama)",
    uiTitle: "Sandviç Panel (İçi yanmaz)",
    uiSubtitle: "İçi taşyünü, cam yünü, mineral yünü vb.. yanmaz veya limitli yanıcı dolgu malzemesiyle kaplanmıştır.",
    reportText: "✅ OLUMLU: Taşyünü vb. yanmaz veya zor yanıcı malzeme dolgulu sandviç paneller Yönetmelik açısından daha uygun bulunur."
  );

  static final kaplamaOptionE = ChoiceResult(
    label: "17-1-E (Kaplama)",
    uiTitle: "Ahşap kaplama.",
    uiSubtitle: "Çatı yüzeyi tamamen ahşap malzeme ile kaplanmıştır.",
    reportText: "☢️ KRİTİK RİSK: Çatı kaplamasında ahşap kullanılması yüksek yangın riski oluşturur. Kıvılcım sıçraması durumunda çatı hızla tutuşabilir."
  );

  static final kaplamaOptionF = ChoiceResult(
    label: "17-1-F (Kaplama)",
    uiTitle: "Çatı hakkında bilgim yok.",
    uiSubtitle: "Çatının en üstünde ne olduğunu göremiyorum.",
    reportText: "❓ BİLİNMİYOR: Çatı kaplama malzemesi bilinmiyor. Yanıcı bir malzeme (shingle, plastik vb.) kullanıldıysa tüm bina risk altındadır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final iskeletOptionA = ChoiceResult(
    label: "17-2-A (İskelet)",
    uiTitle: "Taşıyıcılar beton, çelik vb. dir. Yalıtımda ise taşyünü vb. yanmaz ürün kullanılmıştır.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Çatı taşıyıcı sisteminin ve yalıtımının yanmaz malzemeden olması yangın güvenliği için en ideal durumdur."
  );

  static final iskeletOptionB = ChoiceResult(
    label: "17-2-B (İskelet)",
    uiTitle: "Taşıyıcılar ve altındaki ısı yalıtım yanabilir ürünler.",
    uiSubtitle: "Ahşap, XPS, EPS vb. malzemeler.",
    reportText: "(Yüksek Bina İse) ☢️ KRİTİK RİSK: Yüksek binalarda ahşap çatı kullanılması yasaktır.<br>(Alçak Bina İse) ⚠️ UYARI: Ahşap çatılarda yanıcı köpük vb. kullanımı risklidir."
  );

  static final iskeletOptionC = ChoiceResult(
    label: "17-2-C (İskelet)",
    uiTitle: "Çatı iskeletinin ve yalıtımının durumunu bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Çatı iskeletinin durumu bilinmiyor. Yüksek binalarda ahşap çatı büyük risk taşır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final bitisikOptionA = ChoiceResult(
    label: "17-3-A (Bitişik)",
    uiTitle: "İki binanın çatıları arasında en az 60 cm yüksekliğinde yangın dayanımlı duvar var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Yangın duvarı mevcuttur. Komşu binadan çatı yoluyla yangın geçişi engellenmiştir."
  );

  static final bitisikOptionB = ChoiceResult(
    label: "17-3-B (Bitişik)",
    uiTitle: "Çatılar arasında yangın dayanımlı duvarı yok.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Bitişik nizam binalarda, çatılar arasında yangın geçişini engelleyecek, çatı seviyesinden en az 60 cm yükseltilmiş 'Yangın Duvarı' olması zorunludur."
  );

  static final bitisikOptionC = ChoiceResult(
    label: "17-3-C (Bitişik)",
    uiTitle: "Çatı birleşim yerlerini göremiyorum, bir fikrim yok.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Komşu bina ile çatı birleşim detayı bilinmiyor. Binanıza yangın sıçrama riski olabilir."
  );

  static final isiklikOptionA = ChoiceResult(
    label: "17-4-A (Işıklık)",
    uiTitle: "Hayır, ışıklık yok.",
    uiSubtitle: "Çatıda cam veya plastik aydınlatma açıklığı bulunmuyor.",
    reportText: "✅ OLUMLU: Çatıda ışıklık olmaması, yangın güvenliği açısından riski azaltır."
  );

  static final isiklikOptionB = ChoiceResult(
    label: "17-4-B (Işıklık)",
    uiTitle: "Evet, ışıklık var.",
    uiSubtitle: "Çatıda aydınlatma feneri veya kubbesi mevcut.",
    reportText: "(Alt soruya göre belirlenir)<br>Cam: ✅ OLUMLU: Temperli cam ışıklıklar yeterli olabilir<br>Plastik: ⚠️ UYARI: Çatı ışıklıklarında kullanılan plastik malzemeler yangında eriyip aşağıya damlayarak yangını içeri taşıyabilir."
  );
  static final isiklikOptionC = ChoiceResult(
    label: "17-4-C (Işıklık)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Çatıdaki açıklıkların yapısı belirsiz.",
    reportText: "❓ BİLİNMİYOR: Çatı ışıklık durumu bilinmiyor. Işıklık varsa ve plastikse yangın riski oluşturabilir. Uzman kontrolü önerilir."
  );
}
class Bolum18Content {
  static final duvarOptionA = ChoiceResult(
    label: "18-1-A (Duvar)",
    uiTitle: "Hayır, sadece sıva ve boya.",
    uiSubtitle: "Duvarlarda ekstra bir kaplama malzemesi yoktur.",
    reportText: "✅ OLUMLU: Duvar yüzeylerinde yanıcı kaplama bulunmamaktadır."
  );

  static final duvarOptionB = ChoiceResult(
    label: "18-1-B (Duvar)",
    uiTitle: "Evet, ahşap, plastik, köpük var.",
    uiSubtitle: "Duvarlarda lambiri, plastik panel veya strafor süslemeler var.",
    reportText: "(Yüksek Bina İse) ☢️ KIRMIZI RİSK: Yüksek binalarda duvar kaplamaları ‘en az zor alevlenici’ sınıfta olmalıdır. Ahşap, plastik veya köpük gibi malzemeler yangını koridor boyunca hızla yayar.<br>(Alçak Bina İse) ⚠️ UYARI: Duvarlarda kullanılan köpük veya plastik malzemeler 'En Az Normal Alevlenici' sınıfta olmalıdır. Kolay tutuşan malzemeler yangın yükünü artırır."
  );

  static final duvarOptionC = ChoiceResult(
    label: "18-1-C (Duvar)",
    uiTitle: "Evet, duvar kağıdı var.",
    uiSubtitle: "Duvarlarda standart duvar kağıdı kullanılmıştır.",
    reportText: "✅ OLUMLU: Standart duvar kağıtları genelde kabul edilir, ancak 'Kolay Alevlenen' türde olmamalıdır."
  );

  static final duvarOptionD = ChoiceResult(
    label: "18-1-D (Duvar)",
    uiTitle: "Kaplama malzemesini bilmiyorum.",
    uiSubtitle: "Duvar yüzeyindeki malzemenin cinsini bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Duvar kaplama malzemesi bilinmiyor. 21.50m üzeri binalarda yanıcı kaplama malzemesi kullanımı büyük risk taşır."
  );

  static final boruOptionA = ChoiceResult(
    label: "18-2-A (Boru)",
    uiTitle: "Demir, döküm boru kullanılmıştır",
    uiSubtitle: "Kalın etli, mineral katkılı veya metal borular kullanılmıştır.",
    reportText: "✅ OLUMLU: Tesisat şaftlarında zor yanıcı (sessiz boru) veya yanmaz (döküm) borular kullanılmıştır."
  );

  static final boruOptionB = ChoiceResult(
    label: "18-2-B (Boru)",
    uiTitle: "Plastik boru ve yangın dayanımlı kelepçe kullanılmıştır.",
    uiSubtitle: "Plastik boruların döşeme geçişlerinde kelepçe var.",
    reportText: "✅ OLUMLU: Plastik boruların kat geçişlerinde yangın dayanımlı kelepçe kullanılarak alev geçişi engellenmiştir."
  );

  static final boruOptionC = ChoiceResult(
    label: "18-2-C (Boru)",
    uiTitle: "Plastik boru kullanılmış ancak yangın dayanımlı kelepçe kullanılmamıştır.",
    uiSubtitle: "Plastik boruların döşeme geçişlerinde kelepçe yok.",
    reportText: "☢️ KIRMIZI RİSK: 21.50m ve üzeri binalarda standart plastik borular yangın anında eriyerek yok olur ve döşemede delik açılır. Bu delikten alevler üst kata geçer. Yangın Kelepçesi ZORUNLUDUR."
  );

  static final boruOptionD = ChoiceResult(
    label: "18-2-D (Boru)",
    uiTitle: "Tesisat geçişlerini göremiyorum.",
    uiSubtitle: "Şaftlar kapalı olduğu için boru cinsini bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Tesisat borularının yangın dayanımı veya malzeme özellikleri bilinmiyor. Yüksek binalarda plastik boruların kat geçişlerinde (döşemelerinde) yangın kesici (kelepçe) olup olmadığı hayati önem taşır."
  );
}
class Bolum19Content {
  static final engelOptionA = ChoiceResult(
    label: "19-1-A",
    uiTitle: "Herhangi bir engel yok, yol tamamen açık.",
    uiSubtitle: "Tahliye yolu mevzuata uygun.",
    reportText: "✅ OLUMLU: Kaçış yollarında tahliyeyi engelleyici unsur bulunmamaktadır."
  );

  static final engelOptionB = ChoiceResult(
    label: "19-1-B",
    uiTitle: "Eşya, bisiklet, saksı vb. malzemeler var.",
    uiSubtitle: "Yol genişliği daralmış.",
    reportText: "⚠️ RİSK: Kaçış yollarında eşya ve malzeme istifi tespit edilmiştir."
  );

  static final engelOptionC = ChoiceResult(
    label: "19-1-C",
    uiTitle: "Kilitli kapı veya geçişi zorlaştıran bariyer var.",
    uiSubtitle: "Acil çıkış engellenmiş.",
    reportText: "☢️ KIRMIZI RİSK: Kaçış yolunda kilitli kapı veya fiziksel engel mevcuttur."
  );

  static final engelOptionD = ChoiceResult(
    label: "19-1-D",
    uiTitle: "Eşik, basamak veya kaygan zemin var.",
    uiSubtitle: "Düşme ve takılma riski.",
    reportText: "⚠️ RİSK: Kaçış yolu zemininde takılma veya kayma riski tespit edilmiştir."
  );

  static final levhaOptionA = ChoiceResult(
    label: "19-2-A",
    uiTitle: "Evet, tüm çıkışlarda ledli, ışıklı acil yönlendirme işaretleri var.",
    uiSubtitle: "Yönlendirme yeterli.",
    reportText: "✅ OLUMLU: Acil durum yönlendirme işaretleri ."
  );

  static final levhaOptionB = ChoiceResult(
    label: "19-2-B",
    uiTitle: "Hayır, hiçbir yerde yönlendirme levhası yok.",
    uiSubtitle: "Karanlıkta veya dumanlı ortamda çıkış bulunması çok güçtür.",
    reportText: "☢️ KIRMIZI RİSK: Binada acil durum yönlendirme işaretleri bulunmamaktadır."
  );

  static final levhaOptionC = ChoiceResult(
    label: "19-2-C",
    uiTitle: "Yönlendirmeler var ama çalışmıyorlar, bozuk veya pilleri bitik olabilir.",
    uiSubtitle: " ",
    reportText: "⚠️ RİSK: Yönlendirme işaretlemeleri mevcut ancak çalışır durumda değildir."
  );

  static final yanilticiOptionA = ChoiceResult(
    label: "19-3-A",
    uiTitle: "Hayır, yanıltıcı kapı yok.",
    uiSubtitle: "Tüm kapılar amacına uygun.",
    reportText: "✅ OLUMLU: Kaçış yollarında kullanıcıyı yanıltacak kapı bulunmamaktadır."
  );

  static final yanilticiOptionB = ChoiceResult(
    label: "19-3-B",
    uiTitle: "Evet, yanıltıcı kapılar var.",
    uiSubtitle: "Depo/Elektrik odası kapıları merdiven kapısına benziyor.",
    reportText: "⚠️ RİSK: Kaçış yollarında yangın merdiveni ile karıştırılabilecek yanıltıcı kapılar mevcuttur."
  );

  static final etiketOptionA = ChoiceResult(
    label: "19-3-ALT-A",
    uiTitle: "Evet, 'ÇIKIŞ DEĞİLDİR' veya mahalin adı yazıyor.",
    uiSubtitle: "İşaretleme yapılmış.",
    reportText: "✅ OLUMLU: Yanıltıcı kapılar üzerinde gerekli uyarı levhaları mevcuttur."
  );

  static final etiketOptionB = ChoiceResult(
    label: "19-3-ALT-B",
    uiTitle: "Hayır, herhangi bir yazı veya levha yok.",
    uiSubtitle: " ",
    reportText: "☢️ KIRMIZI RİSK: Yanıltıcı kapılar üzerinde uyarı levhası bulunmamaktadır."
  );

  static final etiketOptionC = ChoiceResult(
    label: "19-3-ALT-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Konu hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Yanıltıcı kapıların işaretleme durumu tespit edilememiştir."
  );
}
class Bolum20Content {
  static final tekKatOptionA = ChoiceResult(
    label: "20-A (Tek Kat)",
    uiTitle: "Düz ayak, engelsiz çıkabiliyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Tek katlı binada düz ayak, engelsiz çıkış imkanı mevcuttur."
  );

  // Not: Aşağıdaki çok katlı seçenekleri sayısal veri girişi içindir ancak
  // metinleri buradan çekilecektir.
  static final cokKatOption1 = ChoiceResult(
    label: "20-1 (Çok Kat)",
    uiTitle: "Normal Apartman Merdiveni (Kapısız).",
    uiSubtitle: "Binanın ana sirkülasyon merdivenidir. Bu merdiven üzerinde yangın kapıları bulunmaz.",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption2 = ChoiceResult(
    label: "20-2 (Çok Kat)",
    uiTitle: "Bina İçi 'Kapalı' Yangın Merdiveni (Kapılı).",
    uiSubtitle: "Betonarme, duvarla çevrili, yangın kapısı bulunan merdiven.",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption3 = ChoiceResult(
    label: "20-3 (Çok Kat)",
    uiTitle: "Bina Dışı 'Kapalı' Yangın Merdiveni (Kapılı).",
    uiSubtitle: "Çelik, yangın dayanımlı alçıpanel vb. duvarla çevrili, yangın kapısı olan merdiven",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption4 = ChoiceResult(
    label: "20-4 (Çok Kat)",
    uiTitle: "Bina Dışı 'Açık' Çelik Merdiven (Kapılı).",
    uiSubtitle: "Çelik, genelde kollu-Z tipi merdiven, duvarsız ancak üzerinde yangın kapıları olan merdiven",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption5 = ChoiceResult(
    label: "20-5 (Çok Kat)",
    uiTitle: "Döner (Spiral, Dairesel) Merdiven.",
    uiSubtitle: "Yuvarlak, dönerek inilen çelik merdiven.",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption6 = ChoiceResult(
    label: "20-6 (Çok Kat)",
    uiTitle: "Sahanlıksız Merdiven.",
    uiSubtitle: "Basamak adedi 17'yi aşan ancak buna rağmen sahanlığı olmayan merdiven.",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final bodrumOptionA = ChoiceResult(
    label: "20-Bodrum-A",
    uiTitle: "Evet, aynı merdiven devam ediyor.",
    uiSubtitle: "Üst kat merdiveni bodruma da iniyor.",
    reportText: "(Bodrum çıkış sayısı hesabında kullanılır)"
  );

  static final bodrumOptionB = ChoiceResult(
    label: "20-Bodrum-B",
    uiTitle: "Hayır, bodrum inen merdiven farklı bir yerde.",
    uiSubtitle: "Bodruma inen merdiven ayrı bir konumda.",
    reportText: "(Bodrum çıkış sayısı hesabında kullanılır)"
  );

  static final rampaOptionB = ChoiceResult(
    label: "20-B (Tek Kat)",
    uiTitle: "Evet",
    uiSubtitle: "Eğimli yol ile çıkış sağlanıyor.",
    reportText: "(Rampa modülünde detaylandırılacak) Rampa ile çıkış sağlanmaktadır."
  );

  static final rampaOptionC = ChoiceResult(
    label: "20-C (Tek Kat)",
    uiTitle: "Hayır",
    uiSubtitle: "Birkaç basamak inilerek/çıkılarak ulaşılıyor.",
    reportText: "(Merdiven sayısı not edilir) Çıkışta basamak mevcuttur."
  );
}
class Bolum21Content {
  static final varlikOptionA = ChoiceResult(
    label: "21-1-A (Varlık)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Merdiven önünde çift kapılı bir hol (yangın güvenlik holü) var.",
    reportText: "✅ OLUMLU: Yangın merdiveni önünde Yangın Güvenlik Holü (YGH) mevcuttur."
  );

  static final varlikOptionB = ChoiceResult(
    label: "21-1-B (Varlık)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Koridordan direkt merdivene çıkılıyor,arada hol yok.",
    reportText: "(Yüksek Bina İse) ☢️ KRİTİK RİSK: 51.50m üzeri binalarda merdiven önünde YGH ZORUNLUDUR. Dumanın merdivene dolmasını bu hol engeller.<br>(Alçak Bina İse) ⚠️ UYARI: Bodrum katlardaki riskli alanlardan merdivene geçişte YGH olması mecburidir."
  );

  static final malzemeOptionA = ChoiceResult(
    label: "21-2-A (Malzeme)",
    uiTitle: "Sıva, boya, beton, mermer vb.",
    uiSubtitle: "Hol içinde yanmaz malzemeler kullanılmış.",
    reportText: "✅ OLUMLU: YGH içindeki kaplamalar yanmaz özelliktedir."
  );

  static final malzemeOptionB = ChoiceResult(
    label: "21-2-B (Malzeme)",
    uiTitle: "Ahşap, duvar kağıdı, plastik.",
    uiSubtitle: "Hol içinde yanıcı kaplama veya dekorasyon var.",
    reportText: "☢️ KIRMIZI RİSK: Yangın güvenlik holleri 'Kaçış Yolu'nun bir parçasıdır. Duvar, tavan ve tabanında HİÇBİR yanıcı malzeme (ahşap, plastik, duvar kağıdı) kullanılamaz. Bu malzemeler varsa sökülmelidir."
  );

  static final malzemeOptionC = ChoiceResult(
    label: "21-2-C (Malzeme)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Malzemenin cinsini bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Holdeki malzemelerin yanıcılıkları bilinmiyor. Yangın güvenlik holleri 'Kaçış Yolu'nun bir parçasıdır. Duvar, tavan ve tabanında HİÇBİR yanıcı malzeme (ahşap, plastik, duvar kağıdı) kullanılamaz. Bu malzemeler varsa sökülmelidir."
  );

  static final kapiOptionA = ChoiceResult(
    label: "21-3-A (Kapı)",
    uiTitle: "YGH kapıları yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanan özelliktedir.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: YGH kapıları yangına dayanıklı ve duman sızdırmaz özelliktedir."
  );

  static final kapiOptionB = ChoiceResult(
    label: "21-3-B (Kapı)",
    uiTitle: "YGH kapıları yangına dayanıklı değil.",
    uiSubtitle: "",
    reportText: "☢️ KIRMIZI RİSK: YGH kapıları en az 90 dakika yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanır özellikte olmalıdır. Bu özelliklere sahip değilse değiştirilmelidirler."
  );

  static final kapiOptionC = ChoiceResult(
    label: "21-3-C (Kapı)",
    uiTitle: "YGH kapıları hakkında fikrim yok.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kapıların yangın dayanımı bilinmiyor. YGH kapıları en az 90 dakika yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanır özellikte olmalıdır. Test raporuyla bu özellikler kanıtlanmış olmalıdır. Bu özelliklere sahip değilse değiştirilmelidirler."
  );

  static final esyaOptionA = ChoiceResult(
    label: "21-4-A (Eşya)",
    uiTitle: "Hayır, tamamen boş.",
    uiSubtitle: "Hol içinde hiçbir eşya yok.",
    reportText: "✅ OLUMLU: YGH içi temiz ve boş olduğundan güvenli sayılır."
  );

  static final esyaOptionB = ChoiceResult(
    label: "21-4-B (Eşya)",
    uiTitle: "Evet; mobilya, koli, çöp, bisiklet vb. eşyalar var.",
    uiSubtitle: "Hol depo gibi kullanılıyor.",
    reportText: "☢️ KIRMIZI RİSK: Yangın güvenlik holleri ve merdiven sahanlıkları ASLA eşya vb. depolama alanı olarak kullanılamaz. Olası bir panik anında bu eşyalar takılıp düşmeye sebep olur ve kaçışı engeller. Derhal boşaltılmalıdır."
  );

  static final esyaOptionC = ChoiceResult(
    label: "21-4-C (Eşya)",
    uiTitle: "Bilmiyorum, dikkat etmedim.",
    uiSubtitle: "Holün kullanım durumunu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Holün kullanım durumu bilinmiyor. Yangın güvenlik holleri ve merdiven sahanlıkları ASLA eşya vb. depolama alanı olarak kullanılamaz. Olası bir panik anında bu eşyalar takılıp düşmeye sebep olur ve kaçışı engeller. Derhal boşaltılmalıdır."
  );
}
class Bolum22Content {
  static final varlikOptionA = ChoiceResult(
    label: "22-1-A (Varlık)",
    uiTitle: "Hayır, itfaiye asansörü yok sadece normal (insan taşıma) asansör var.",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Yönetmeliğe aykırı durum. 51.50 metreden yüksek binalarda yangın anında itfaiyenin kullanabileceği, jeneratöre bağlı ve korunumlu İtfaiye Asansörü olması ZORUNLUDUR."
  );

  static final varlikOptionB = ChoiceResult(
    label: "22-1-B (Varlık)",
    uiTitle: "Evet, itfaiye asansörü var.",
    uiSubtitle: "Bazı binalarda yük asansörü olarak da isimlendirilir.",
    reportText: "✅ OLUMLU: Binada itfaiye asansörü mevcut."
  );

  static final varlikOptionC = ChoiceResult(
    label: "22-1-C (Varlık)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Binada itfaiye asansörü olup olmadığı bilinmiyor. 51.50 metreden yüksek binalarda yangın anında itfaiyenin kullanabileceği, jeneratöre bağlı ve korunumlu itfaiye asansörü olması ZORUNLUDUR."
  );

  static final konumOptionA = ChoiceResult(
    label: "22-2-A (Konum)",
    uiTitle: "Doğrudan koridora ve lobiye açılıyor.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: İtfaiye asansörleri doğrudan koridora açılamaz. Dumanın kuyuya girmemesi için yangın güvenlik holüne açılması zorunludur."
  );

  static final konumOptionB = ChoiceResult(
    label: "22-2-B (Konum)",
    uiTitle: "Bir Yangın Güvenlik Holü'ne (YGH'ye) açılıyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: İtfaiye asansörü Yangın Güvenlik Holü'ne açılmaktadır."
  );

  static final konumOptionC = ChoiceResult(
    label: "22-2-C (Konum)",
    uiTitle: "Kapının nereye açıldığını bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: İtfaiye asansörünün nereye açıldığı bilinmiyor. İtfaiye asansörleri doğrudan koridora açılamaz. Dumanın kuyuya girmemesi için yangın güvenlik holüne açılması zorunludur."
  );

  static final boyutOptionA = ChoiceResult(
    label: "22-3-A (Boyut)",
    uiTitle: "Küçük (6 m²'den az).",
    uiSubtitle: "Hol alanı dar.",
    reportText: "☢️ RİSK: İtfaiye asansörü önündeki YGH, sedye ve itfaiye ekibinin sığması için EN AZ 6 m² olmalıdır. Mevcut alan yetersiz."
  );

  static final boyutOptionB = ChoiceResult(
    label: "22-3-B (Boyut)",
    uiTitle: "Standart (6-10 m² arası).",
    uiSubtitle: "Hol alanı yeterli genişlikte.",
    reportText: "✅ OLUMLU: YGH alanı yeterlidir.",
  );

  static final boyutOptionC = ChoiceResult(
    label: "22-3-C (Boyut)",
    uiTitle: "Büyük (10 m²'den fazla).",
    uiSubtitle: "Hol alanı fazla geniş.",
    reportText: "⚠️ UYARI: YGH alanı 10 m²'yi geçmemelidir. Gereksiz büyük hol duman kontrolünü zorlaştırır veya içeride insanların beklemesine yol açabilir."
  );

  static final boyutOptionD = ChoiceResult(
    label: "22-3-D (Boyut)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Holün boyutları bilinmiyor. İtfaiye ekiplerinin rahat çalışabilmesi için alanın 6 ila 10 m² arasında olması şarttır."
  );

  static final kabinOptionA = ChoiceResult(
    label: "22-4-A (Kabin)",
    uiTitle: "Evet, 1,8 m2'den geniş ve 1 dakikada en üst kata hızlıca çıkabiliyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: İtfaiye asansörü kabin boyutu ve hızı yeterlidir."
  );

  static final kabinOptionB = ChoiceResult(
    label: "22-4-B (Kabin)",
    uiTitle: "Hayır, kabini küçük veya 1 dakikada en üst kata ulaşamıyor.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: İtfaiye asansörü kabini en az 1.8 m² olmalı ve en üst kata 1 dakikada ulaşmalıdır. Aksi takdirde acil müdahale ve tahliye gecikir."
  );

  static final kabinOptionC = ChoiceResult(
    label: "22-4-C (Kabin)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: İtfaiye asansörünün teknik özellikleri bilinmiyor. İtfaiye asansörü kabini en az 1.8 m² olmalı ve en üst kata 1 dakikada ulaşmalıdır. Aksi takdirde acil müdahale ve tahliye gecikir."
  );

  static final enerjiOptionA = ChoiceResult(
    label: "22-5-A (Enerji)",
    uiTitle: "Evet, asansörlerin hepsi jeneratöre bağlı ve binada elektrik olmasa bile 60 dakika boyunca  çalışabilir durumda.",
    uiSubtitle: "Elektrik kesilse bile asansörler çalışabiliyor.",
    reportText: "✅ OLUMLU: İtfaiye asansörü acil durum enerji sistemine bağlıdır."
  );

  static final enerjiOptionB = ChoiceResult(
    label: "22-5-B (Enerji)",
    uiTitle: "Hayır, jeneratör yok.",
    uiSubtitle: "Elektrik kesilince asansör duruyor.",
    reportText: "☢️ KRİTİK RİSK: İtfaiye asansörü, enerji kesilse bile en az 60 dakika çalışmak zorundadır. Jeneratörsüz asansör yangında işlevsizdir."
  );

  static final enerjiOptionC = ChoiceResult(
    label: "22-5-C (Enerji)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Asansörün acil durum enerji beslemesi bilinmiyor. Yangın anında elektriğin kesilmesi muhtemeldir. İtfaiye asansörü, enerji kesilse bile en az 60 dakika çalışmak zorundadır. Jeneratörsüz asansör yangında işlevsizdir."
  );

  static final basincOptionA = ChoiceResult(
    label: "22-6-A (Basınç)",
    uiTitle: "Evet, basınçlandırma sistemi var.",
    uiSubtitle: "Asansör kuyusuna hava üfleyen sistem.",
    reportText: "✅ OLUMLU: İtfaiye asansör kuyusu basınçlandırılmıştır."
  );

  static final basincOptionB = ChoiceResult(
    label: "22-6-B (Basınç)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Asansör kuyusuna hava üfleyen yok.",
    reportText: "☢️ RİSK: İtfaiye asansör kuyusu basınçlandırılmalıdır. Aksi takdirde kuyuya duman dolar ve insanlar boğulma tehlikesi geçirir."
  );

  static final basincOptionC = ChoiceResult(
    label: "22-6-C (Basınç)",
    uiTitle: "Basınçlandırma var mı yok mu bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kuyunun basınçlandırma durumu bilinmiyor. Bu sistem dumanın asansör kuyusuna girmesini engeller ve itfaiye asansör kuyusunda olmalıdır."
  );
}
class Bolum23Content {
  static final bodrumOptionA = ChoiceResult(
    label: "23-1-A (Bodrum)",
    uiTitle: "Normal (insan taşıma) asansör bodrum katlara inmiyor.",
    uiSubtitle: "Asansör sadece zemin ve üst katlar arasında çalışıyor.",
    reportText: "✅ OLUMLU: Asansör bodrum katlara inmemektedir."
  );

  static final bodrumOptionB = ChoiceResult(
    label: "23-1-B (Bodrum)",
    uiTitle: "Normal asansör bodrum katlara da iniyor ve bodrum katta kapısını korunumlu bir hole açıyor.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Asansör bodrum katta yangın güvenlik holüne açılmaktadır."
  );

  static final bodrumOptionC = ChoiceResult(
    label: "23-1-C (Bodrum)",
    uiTitle: "Normal asansör bodrum katlara da iniyor ve holsüz biçimde direkt otoparka, depoya veya ticari alanlara açılıyor.",
    uiSubtitle: "Asansörün bodrum kata çıktığı noktada bir YGH yok.",
    reportText: "☢️ KRİTİK RİSK: Asansör kuyuları binanın bacası gibidir. Bodrumdaki otoparkta veya kazan dairesinde çıkacak bir yangının dumanı, direkt asansör kapısından kuyuya girer ve saniyeler içinde tüm üst katlara yayılır."
  );

  static final bodrumOptionD = ChoiceResult(
    label: "23-1-D (Bodrum)",
    uiTitle: "Bilmiyorum, konu hakkında fikrim yok.",
    uiSubtitle: " ",
    reportText: "❓ BİLİNMİYOR: Bodrum katlardaki asansörlerin hemen önünde mutlaka 'Yangın Güvenlik Holü' olmalıdır. Mevcut durum bilinmiyor."
  );

  static final yanginModuOptionA = ChoiceResult(
    label: "23-2-A (Yangın Modu)",
    uiTitle: "Evet, otomatik olarak kendliğinden iniyor ve kapısını açıyor.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Asansörlerde yangın modu mevcuttur."
  );

  static final yanginModuOptionB = ChoiceResult(
    label: "23-2-B (Yangın Modu)",
    uiTitle: "Hayır, asansör normalin dışında farklı bir aksiyon almıyor.",
    uiSubtitle: "Yangın anında normal çalışmasına devam ediyor.",
    reportText: "☢️ RİSK: Asansörlerin yangın anında özel aksiyon alması gereklidir."
  );

  static final yanginModuOptionC = ChoiceResult(
    label: "23-2-C (Yangın Modu)",
    uiTitle: "Bilmiyorum, buna dikkat etmedim.",
    uiSubtitle: " ",
    reportText: "❓ BİLİNMİYOR: Asansörün yangın senaryosu bilinmiyor. Yangın anında asansörde mahsur kalmamak için bu özelliğin varlığı hayati önem taşır."
  );

  static final konumOptionA = ChoiceResult(
    label: "23-3-A (Konum)",
    uiTitle: "Kat koridoruna, kat holüne veya asansör holüne açılıyor.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Asansör kapıları kat koridoruna açılmaktadır."
  );

  static final konumOptionB = ChoiceResult(
    label: "23-3-B (Konum)",
    uiTitle: "Doğrudan yangın merdiveninin içine açılıyor.",
    uiSubtitle: " ",
    reportText: "☢️ KRİTİK RİSK: Yönetmeliğe göre asansör kapıları ASLA yangın merdiveni yuvasına açılamaz. Asansör kuyusundan sızan duman, insanların kaçtığı temiz bölgeyi (merdiveni) dumanla doldurur."
  );

  static final konumOptionC = ChoiceResult(
    label: "23-3-C (Konum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapının tam yerini bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Asansör kapısının konumu net değil. Eğer yangın merdiveni içine açılıyorsa, kaçış yolunuz tehlike altındadır."
  );

  static final levhaOptionA = ChoiceResult(
    label: "23-4-A (Levha)",
    uiTitle: "Evet, her katta levha var.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Asansörlerde gerekli uyarı levhaları mevcuttur."
  );

  static final levhaOptionB = ChoiceResult(
    label: "23-4-B (Levha)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Uyarı levhası bulunmuyor.",
    reportText: "⚠️ UYARI: Panik anında insanlar refleks olarak asansöre yönelebilir. Bu levha, insanları merdivene yönlendirmek için yasal zorunluluktur."
  );

  static final levhaOptionC = ChoiceResult(
    label: "23-4-C (Levha)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Levha olup olmadığına dikkat etmedim.",
    reportText: "❓ BİLİNMİYOR: Uyarı levhalarının varlığı bilinmiyor. Panik anında insanlar refleks olarak asansöre yönelebilir. Bu levha, insanları merdivene yönlendirmek için yasal zorunluluktur."
  );

  static final havalandirmaOptionA = ChoiceResult(
    label: "23-5-A (Havalandırma)",
    uiTitle: "Evet, kuyuda pencere var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Asansör kuyusunda duman tahliye bacası mevcuttur."
  );

  static final havalandirmaOptionB = ChoiceResult(
    label: "23-5-B (Havalandırma)",
    uiTitle: "Hayır, kuyu tamamen kapalı.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Asansör kuyusuna sızan dumanın tahliye edilmesi için en üst noktada 'Duman Tahliye Bacası' (0.1 m²'den az olmamak kaydıyla) zorunludur."
  );

  static final havalandirmaOptionC = ChoiceResult(
    label: "23-5-C (Havalandırma)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kuyu havalandırması bilinmiyor. Asansör kuyusuna sızan dumanın tahliye edilmesi için en üst noktada 'Duman Tahliye Bacası' (0.1 m²'den az olmamak kaydıyla) zorunludur."
  );
}
class Bolum24Content {
  static final tipOptionA = ChoiceResult(
    label: "24-1-A (Tip)",
    uiTitle: "Önce kapalı apartman koridoruna, sonrasında cadde seviyesindeki dış havaya çıkılabiliyor.",
    uiSubtitle: " ",
    reportText: "Binadan çıkışta dış kaçış geçidi yer almamaktadır, Yönetmeliğe göre bir değerlendirmeye ihtiyaç bulunmaz."
  );

  static final tipOptionB = ChoiceResult(
    label: "24-1-B (Tip)",
    uiTitle: "Daire kapısı veya kat koridorundan çıkışta öncelikle dış cephede bulunan açık bir kaçış yoluna çıkılması gerekiyor.",
    uiSubtitle: " ",
    reportText: "Binadan çıkışta dış kaçış geçidi yer almaktadır. Yönetmeliğe göre bu geçidin ve dış cephedeki tehlikelerin değerlendirilmesi gereklidir."
  );

  static final tipOptionC = ChoiceResult(
    label: "24-1-C (Tip)",
    uiTitle: "Bilmiyorum / Emin değilim.",
    uiSubtitle: "Çıkış güzergahı tam olarak analiz edilemedi.",
    reportText: "❓ BİLİNMİYOR: Binadan çıkışta dış kaçış geçidi (açık koridor) olup olmadığı tespit edilememiştir. Uzman kontrolü önerilir."
  );

  static final pencereOptionA = ChoiceResult(
    label: "24-2-A (Pencere)",
    uiTitle: "Hayır, bu yola veya koridora bakan pencere hiç yok.",
    uiSubtitle: "Açık kaçış yolu veya koridoru tarafındaki duvar sağır (penceresiz).",
    reportText: "✅ OLUMLU: Açık koridora bakan pencere bulunmamaktadır."
  );

  static final pencereOptionB = ChoiceResult(
    label: "24-2-B (Pencere)",
    uiTitle: "Evet, pencereler var.",
    uiSubtitle: "Açık kaçış yoluna veya koridora bakan daire pencereleri mevcut.",
    reportText: "⚠️ RİSK: Dış kaçış geçidine bakan pencereler, yerden en az 1.80 metre yüksekte olmalıdır. Aksi takdirde daireden çıkan alev ve duman, kaçış yolunu kapatır."
  );

  static final pencereOptionC = ChoiceResult(
    label: "24-2-C (Pencere)",
    uiTitle: "Bilmiyorum / Göremiyorum.",
    uiSubtitle: "Pencere yüksekliği veya varlığı belirsiz.",
    reportText: "❓ BİLİNMİYOR: Dış kaçış geçidine bakan pencerelerin varlığı veya yüksekliği bilinmiyor. Bu pencereler yangın anında kaçış yolunu dumanla doldurabilir."
  );

  static final kapiOptionA = ChoiceResult(
    label: "24-3-A (Kapı)",
    uiTitle: "Çelik, yangına dayanıklı, duman sızdırmaz, bırakınca kendiliğinden kapanıyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Dış geçide açılan kapı yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanır özelliktedir."
  );

  static final kapiOptionB = ChoiceResult(
    label: "24-3-B (Kapı)",
    uiTitle: "Dayanıksız, kendiliğinden kapanmıyor.",
    uiSubtitle: "Kapı ahşap, pvc, demir vs.",
    reportText: "⚠️ RİSK: Dış kaçış geçitlerine açılan kapılar en az 30 dakika yangına dayanıklı olmalı ve bırakınca kendiliğinden kapanmalıdır."
  );

  static final kapiOptionC = ChoiceResult(
    label: "24-3-C (Kapı)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapı özellikleri analiz edilemedi.",
    reportText: "❓ BİLİNMİYOR: Dış kaçış geçidine açılan kapıların yangın dayanımı ve sızdırmazlık özellikleri bilinmiyor."
  );
}
class Bolum25Content {
  static final kapasiteOptionA = ChoiceResult(
    label: "25-1-A (Kapasite)",
    uiTitle: "Dairesel mrdiveninin kol genişliği 100 cm'den az VEYA katta 25 kişiden fazla kişi bulunuyor",
    uiSubtitle: "Merdiven dar veya çok kalabalık bir kata hizmet ediyor.",
    reportText: "☢️ KIRMIZI RİSK: Dairesel merdivenler 'Zorunlu Çıkış' olarak kabul edilebilmesi için en az 100 cm genişlikte olmalı ve en fazla 25 kişiye hizmet etmelidir. Aksi takdirde kaçış yolu sayılamaz."
  );

  static final kapasiteOptionB = ChoiceResult(
    label: "25-1-B (Kapasite)",
    uiTitle: "Dairesel merdivenin kol genişliği 100 cm'den fazla VE katta 25 kişiden az kişi bulunuyor",
    uiSubtitle: "Merdiven geniş ve az kişiye hizmet ediyor.",
    reportText: "✅ OLUMLU: Dairesel merdiven genişliği ve kullanıcı yükü yönetmelik sınırları (100cm / 25 kişi) içerisindedir."
  );

  static final kapasiteOptionC = ChoiceResult(
    label: "25-1-C (Kapasite)",
    uiTitle: "Bilmiyorum / Ölçüm yapamadım.",
    uiSubtitle: "Genişlik ve kullanıcı kapasitesi belirsiz.",
    reportText: "❓ BİLİNMİYOR: Dairesel merdiven genişliği ve hizmet verdiği kişi sayısı bilinmiyor. 100 cm altındaki genişlikler acil durumlarda yığılmaya neden olabilir."
  );

  static final basamakOptionA = ChoiceResult(
    label: "25-2-A (Basamak)",
    uiTitle: "Evet, rahat basılıyor.",
    uiSubtitle: "Basamağın orta kısmı (basılan yer) en az 25 cm genişlikte.",
    reportText: "✅ OLUMLU: Döner merdiven basamak genişliği (basış yüzeyi) yeterlidir."
  );

  static final basamakOptionB = ChoiceResult(
    label: "25-2-B (Basamak)",
    uiTitle: "Hayır, basamaklar çok dar.",
    uiSubtitle: "Basamaklar üçgen şeklinde, sadece en dıştan basılabiliyor.",
    reportText: "⚠️ UYARI: Döner merdivenlerde basamak genişliği, merkezden 50 cm uzaklıkta en az 25 cm olmalıdır. Çok dar basamaklar panik anında düşme riskini artırır."
  );

  static final basamakOptionC = ChoiceResult(
    label: "25-2-C (Basamak)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Basamak yapısı analiz edilemedi.",
    reportText: "❓ BİLİNMİYOR: Döner merdiven basamak genişliği bilinmiyor. Basamakların dar olması tahliye hızını ciddi oranda düşürür."
  );

  static final basKurtarmaOptionA = ChoiceResult(
    label: "25-3-A (Baş Kurtarma)",
    uiTitle: "Ferah (2.50 metreden yüksek).",
    uiSubtitle: "İnerken başınız tavana veya üst basamağa değmiyor.",
    reportText: "✅ OLUMLU: Baş kurtarma yüksekliği yeterlidir."
  );

  static final basKurtarmaOptionB = ChoiceResult(
    label: "25-3-B (Baş Kurtarma)",
    uiTitle: "Standart (2.10 - 2.50 metre arası).",
    uiSubtitle: "Tavan alçak, baş çarpma riski var.",
    reportText: "⚠️ UYARI: Döner merdivenlerde baş kurtarma yüksekliği, normal merdivenlerden daha fazla (en az 2.50 m) olmalıdır. Dönüş sırasında baş çarpma riski daha yüksektir."
  );

  static final basKurtarmaOptionC = ChoiceResult(
    label: "25-3-C (Baş Kurtarma)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Yükseklik ölçümü yapılamadı.",
    reportText: "❓ BİLİNMİYOR: Döner merdiven baş kurtarma yüksekliği bilinmiyor. Alçak tavanlar tahliye sırasında yaralanmalara yol açabilir."
  );
}
class Bolum26Content {
  static final varlikOptionA = ChoiceResult(
    label: "26-1-A",
    uiTitle: "Hayır, sadece merdiven var, rampa yok.",
    uiSubtitle: "Binada kaçış yolunda hiç rampa yok.",
    reportText: "Binada rampa bulunmadığından Yönetmeliğe göre bu konuda bir değerlendirme yapılmaz."
  );

  static final varlikOptionB = ChoiceResult(
    label: "26-1-B",
    uiTitle: "Evet, rampa var.",
    uiSubtitle: "Binada kaçış yolunda rampa bulunuyor.",
    reportText: "Binada kaçış rampası tespit edilmiştir. Eğim ve sahanlık kriterleri analiz edilmelidir."
  );

  static final varlikOptionC = ChoiceResult(
    label: "26-1-C",
    uiTitle: "Bilmiyorum",
    uiSubtitle: "Rampa varlığı veya konumu belirsiz.",
    reportText: "❓ BİLİNMİYOR: Binada kaçış rampası olup olmadığı veya konumu tespit edilememiştir."
  );

  static final egimOptionA = ChoiceResult(
    label: "26-2-A",
    uiTitle: "Eğim az (%10'dan az) ve zemin kaymaz.",
    uiSubtitle: "Rahat yürünüyor, zeminde kaymaz bant veya malzeme var.",
    reportText: "✅ OLUMLU: Rampa eğimi ve zemin kaplaması kaçış güvenliğine uygundur."
  );

  static final egimOptionB = ChoiceResult(
    label: "26-2-B",
    uiTitle: "Eğim fazla dik (%10'dan fazla) veya zemin kaygan.",
    uiSubtitle: "Yürürken insanı zorluyor, kayma tehlikesi var.",
    reportText: "☢️ RİSK: Kaçış rampalarının eğimi %10'dan fazla olamaz. Dik ve kaygan rampalar panik anında düşmelere sebep olur."
  );

  static final egimOptionC = ChoiceResult(
    label: "26-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Eğim ölçümü veya zemin analizi yapılamadı.",
    reportText: "❓ BİLİNMİYOR: Rampa eğimi ve zemin kaymazlık durumu bilinmiyor. %10 üzerindeki eğimler tahliyeyi tehlikeye atar."
  );

  static final sahanlikOptionA = ChoiceResult(
    label: "26-3-A",
    uiTitle: "Evet, sahanlık var, kapı önleri ve dönüşler düz.",
    uiSubtitle: "Rampa başlangıç ve bitişinde düz alanlar var.",
    reportText: "✅ OLUMLU: Rampa sahanlıkları ve kapı önü düzlükleri mevcuttur."
  );

  static final sahanlikOptionB = ChoiceResult(
    label: "26-3-B",
    uiTitle: "Hayır, rampadan önce veya sonra eğim var.",
    uiSubtitle: "Kapıyı açınca direkt eğimli yüzeye basılıyor.",
    reportText: "⚠️ UYARI: Rampa giriş ve çıkışlarında, kapı önlerinde mutlaka düz sahanlık bulunmalıdır."
  );

  static final sahanlikOptionC = ChoiceResult(
    label: "26-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Sahanlık varlığı tespit edilemedi.",
    reportText: "❓ BİLİNMİYOR: Rampa sahanlıklarının varlığı ve kapı önü düzlükleri bilinmiyor."
  );

  static final otoparkOptionA = ChoiceResult(
    label: "26-4-A",
    uiTitle: "Evet, eğimi uygun (%10 'un altı).",
    uiSubtitle: "Araç rampası yürüyerek çıkmaya müsait.",
    reportText: "✅ OLUMLU: Otopark rampası, eğimi uygun olduğu için 2. kaçış yolu olarak kabul edilebilir."
  );

  static final otoparkOptionB = ChoiceResult(
    label: "26-4-B",
    uiTitle: "Hayır, çok dik (%10'dan fazla) veya zemin kaygan.",
    uiSubtitle: "Rampayı sadece araçlar kullanabilir.",
    reportText: "⚠️ BİLGİ: Otopark rampası çok dik (%10'dan fazla) olduğu için kaçış yolu sayılamaz."
  );

  static final otoparkOptionC = ChoiceResult(
    label: "26-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Otopark rampası analiz edilemedi.",
    reportText: "❓ BİLİNMİYOR: Otopark rampasının kaçış yolu olarak kullanılabilirliği belirsizdir."
  );
}
class Bolum27Content {
  // 1. BOYUT VE EŞİK
  static final boyutOptionA = ChoiceResult(
    label: "27-1-A",
    uiTitle: "80 cm'den geniş ve eşiksiz (düz ayak).",
    uiSubtitle: "Geçiş rahat, takılma riski yok.",
    reportText: "✅ OLUMLU: Kaçış kapısı genişliği (min. 80cm) ve zemin düzgünlüğü uygundur."
  );

  static final boyutOptionB = ChoiceResult(
    label: "27-1-B",
    uiTitle: "80 cm'den dar veya yerde eşik/kasis var.",
    uiSubtitle: "Geçiş zor veya takılma riski var.",
    reportText: "☢️ RİSK: Kaçış kapılarında temiz geçiş genişliği en az 80 cm olmalıdır. Ayrıca takılıp düşmeye sebep olacak 'Eşik' bulunması kesinlikle yasaktır."
  );

  static final boyutOptionC = ChoiceResult(
    label: "27-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Ölçüm yapılamadı.",
    reportText: "❓ BİLİNMİYOR: Kapı ölçüleri ve eşik durumu bilinmiyor. Dar kapılar ve eşikler panik anında yığılmalara neden olabilir."
  );

  // 2. YÖN (50 Kişi kuralı burada işletilecek)
  static final yonOptionA = ChoiceResult(
    label: "27-2-A",
    uiTitle: "Dışarıya (Kaçış yönüne) açılıyor.",
    uiSubtitle: "Kapıyı itince açılıyor.",
    reportText: "✅ OLUMLU: Kapı açılış yönü (kaçış yönü) doğrudur."
  );

  static final yonOptionB = ChoiceResult(
    label: "27-2-B",
    uiTitle: "İçeriye (Koridora) açılıyor.",
    uiSubtitle: "Kapıyı açmak için kendinize çekmeniz gerekiyor.",
    reportText: "⚠️ UYARI: Kullanıcı yükü 50 kişiyi geçen mahallerde kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır."
  );

  static final yonOptionC = ChoiceResult(
    label: "27-2-C",
    uiTitle: "Döner kapı, turnike veya sürgülü.",
    uiSubtitle: "Otomatik veya döner mekanizma.",
    reportText: "☢️ KRİTİK RİSK: Kaçış yolunda döner kapı veya sürgülü kapı kullanılamaz. Turnikeler yangın anında serbest kalmıyorsa büyük risk oluşturur."
  );

  static final yonOptionD = ChoiceResult(
    label: "27-2-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Yön tespiti yapılamadı.",
    reportText: "❓ BİLİNMİYOR: Kapı açılma yönü bilinmiyor. 50 kişiyi aşan alanlarda dışarı açılması zorunludur."
  );

  // 3. KİLİT MEKANİZMASI (100 Kişi kuralı burada işletilecek)
  static final kilitOptionA = ChoiceResult(
    label: "27-3-A",
    uiTitle: "Panik Bar var (Vücutla itince açılıyor).",
    uiSubtitle: "Yatay bar mekanizması mevcut.",
    reportText: "✅ OLUMLU: Kapıda panik bar mekanizması mevcuttur ve kullanıma uygundur."
  );

  static final kilitOptionB = ChoiceResult(
    label: "27-3-B",
    uiTitle: "Normal kapı kolu var.",
    uiSubtitle: "Çevirmeli standart kol.",
    reportText: "⚠️ BİLGİ: Kullanıcı yükü 100 kişiyi aşmayan yerlerde kapı kolu kabul edilebilir. 100 kişiyi aşan yerlerde Panik Bar zorunludur."
  );

  static final kilitOptionC = ChoiceResult(
    label: "27-3-C",
    uiTitle: "Kilitli / Anahtar gerekiyor.",
    uiSubtitle: "Kapı kilitli tutuluyor.",
    reportText: "☢️ KRİTİK RİSK: Kaçış yolu kapıları ASLA kilitlenemez. Her an tek hamlede açılabilir olmalıdır."
  );

  static final kilitOptionD = ChoiceResult(
    label: "27-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kilit mekanizması belirsiz.",
    reportText: "❓ BİLİNMİYOR: Kilit mekanizması kontrol edilmelidir. Kilitli kapılar can kaybına neden olur."
  );

  // 4. DAYANIM (Sadece Yangın Merdiveni Varsa Sorulacak)
  static final dayanimOptionA = ChoiceResult(
    label: "27-4-A",
    uiTitle: "Çelik, yangına dayanıklı, duman sızdırmaz.",
    uiSubtitle: "Üzerinde sertifikası var, kendiliğinden kapanıyor.",
    reportText: "✅ OLUMLU: Yangın kapısı standartlara (EI60/EI90) ve sızdırmazlık şartlarına uygundur."
  );

  static final dayanimOptionB = ChoiceResult(
    label: "27-4-B",
    uiTitle: "Metal ama kendiliğinden kapanmıyor.",
    uiSubtitle: "Hidrolik yok veya bozuk.",
    reportText: "☢️ RİSK: Yangın kapıları her zaman otomatik kapanır durumda (hidrolikli) olmalıdır."
  );

  static final dayanimOptionC = ChoiceResult(
    label: "27-4-C",
    uiTitle: "Ahşap, PVC veya Cam kapı (Dayanıksız).",
    uiSubtitle: "Yangın kapısı değil.",
    reportText: "☢️ KRİTİK RİSK: Yangın merdiveni kapıları yanıcı malzemeden (Ahşap/PVC) yapılamaz. En az 60 dk yangına dayanıklı olmalıdır."
  );

  static final dayanimOptionD = ChoiceResult(
    label: "27-4-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapı özelliği belirsiz.",
    reportText: "❓ BİLİNMİYOR: Yangın merdiveni kapısının dayanım sınıfı bilinmiyor."
  );
}
class Bolum28Content {
  static final muafiyetOption = ChoiceResult(
    label: "28-1 (Muafiyet)",
    uiTitle: "(Otomatik Ekran)",
    uiSubtitle: "(Kullanıcı seçim yapmaz, sistem gösterir)",
    reportText: "✅ MUAFİYET: Binanız bodrum dahil 4 katı geçmemektedir ve binada konut harici ticari alan da bulunmamaktadır. Yapı tek kullanım amaçlı olup, özel bir yangın merdiveni veya kaçış mesafesi şartı aranmaz."
  );

  static final mesafeOptionA = ChoiceResult(
    label: "28-2-A (Mesafe)",
    uiTitle: "Kısa (20 metreden az).",
    uiSubtitle: "En uzak odadan daire kapısına kadar olan mesafe.",
    reportText: "✅ OLUMLU: Daire içi kaçış mesafesi 20 metrenin altındadır, Yönetmelik talebi karşılanıyor."
  );

  static final mesafeOptionB = ChoiceResult(
    label: "28-2-B (Mesafe)",
    uiTitle: "Orta (20 - 30 metre arası).",
    uiSubtitle: "En uzak odadan daire kapısına kadar olan mesafe.",
    reportText: "(Sprinkler Varsa) ✅ OLUMLU: Sprinkler sistemi olduğu için 30 metreye kadar izin verilir.<br>(Sprinkler Yoksa) ☢️ RİSK: Sprinkler olmayan dairelerde en uzak noktadan çıkışa mesafe 20 metreyi geçemez."
  );

  static final mesafeOptionC = ChoiceResult(
    label: "28-2-C (Mesafe)",
    uiTitle: "Uzun (30 metreden fazla).",
    uiSubtitle: "En uzak odadan daire kapısına kadar olan mesafe.",
    reportText: "☢️ RİSK: Sprinkler olsa bile daire içi kaçış mesafesi 30 metreyi geçemez."
  );

  static final dubleksOptionA = ChoiceResult(
    label: "28-3-A (Dubleks)",
    uiTitle: "Hayır, tek katlı daire.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Normal daire."
  );

  static final dubleksOptionB = ChoiceResult(
    label: "28-3-B (Dubleks)",
    uiTitle: "Evet, dubleks (çift katlı)",
    uiSubtitle: "",
    reportText: "(Alt sorulara göre belirlenir)"
  );

  static final alanOption1 = ChoiceResult(
    label: "28-3-B-1 (Alan)",
    uiTitle: "Üst kat 70 m²'den küçük.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Üst kat alanı 70 m²'den küçük olduğu için tek çıkış yeterlidir."
  );

  static final alanOption2 = ChoiceResult(
    label: "28-3-B-2 (Alan)",
    uiTitle: "Üst kat 70 m²'den büyük.",
    uiSubtitle: "",
    reportText: "(Çıkış Kapısı sorulur)"
  );

  static final cikisOptionA = ChoiceResult(
    label: "28-3-B-2-A (Çıkış)",
    uiTitle: "Evet, üst katta kapı var.",
    uiSubtitle: "Üst kattan apartmana çıkış mevcut.",
    reportText: "✅ OLUMLU: Üst kat alanı 70 m²'yi geçtiği için yapılan ikinci çıkış kapısı olması Yönetmelik talebini karşılamaktadır."
  );

  static final cikisOptionB = ChoiceResult(
    label: "28-3-B-2-B (Çıkış)",
    uiTitle: "Hayır, üst katta kapı yok.",
    uiSubtitle: "Sadece alt kattan çıkılabiliyor.",
    reportText: "⚠️ UYARI: Dubleks dairelerde üst kat alanı 70 m²'yi geçerse, üst kattan da apartman koridoruna açılan ikinci bir çıkış kapısı olması zorunludur."
  );
}
class Bolum29Content {
  // 1. OTOPARK
  static final otoparkOptionA = ChoiceResult(
    label: "29-1-A",
    uiTitle: "Hayır, sadece taşıtlar var, alan temiz.",
    uiSubtitle: "Otopark alanı düzenli.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Otopark alanı temizdir, farklı risk grubuna ait depolama yapılmamıştır."
  );
  static final otoparkOptionB = ChoiceResult(
    label: "29-1-B",
    uiTitle: "Evet, eşya yığınları var.",
    uiSubtitle: "Lastik, koli, eski eşya vb. biriktirilmiş.",
    reportText: "🚨 RİSK: Otoparklar sadece araç parkı içindir. Eşya yığınları yangını büyütür ve söndürmeyi zorlaştırır. Derhal temizlenmelidir."
  );
  static final otoparkOptionC = ChoiceResult(
    label: "29-1-C",
    uiTitle: "Bilmiyorum / Dikkat etmedim.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Otoparkın temizlik durumu bilinmiyor. Araçların yanına istiflenen eski lastikler veya eşyalar, küçük bir araç yangınını tüm binayı saracak bir felakete dönüştürebilir. Lütfen otoparkı kontrol ediniz."
  );

  // 2. KAZAN DAİRESİ
  static final kazanOptionA = ChoiceResult(
    label: "29-2-A",
    uiTitle: "Hayır, sadece kazan ve tesisat var.",
    uiSubtitle: "Kazan dairesi boş ve temiz.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Kazan dairesinde gereksiz yanıcı madde bulunmamaktadır."
  );
  static final kazanOptionB = ChoiceResult(
    label: "29-2-B",
    uiTitle: "Evet, eşyalar var.",
    uiSubtitle: "Odun, kömür, kağıt, eski eşya vb. var.",
    reportText: "🚨 KRİTİK RİSK: Kazan daireleri depo değildir! Yakıt tankının veya kazanın yanındaki en ufak bir kıvılcım, oradaki eşyaları tutuşturup binayı tehlikeye atar."
  );
  static final kazanOptionC = ChoiceResult(
    label: "29-2-C",
    uiTitle: "Bilmiyorum / İçini görmedim.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kazan dairesinin içi bilinmiyor. Burası binanın kalbidir ve en yüksek yangın riskini taşır. İçeride unutulan bir bez parçası veya kağıt yığını büyük bir patlamaya neden olabilir. Mutlaka denetlenmelidir."
  );

  // 3. ÇATI ARASI
  static final catiOptionA = ChoiceResult(
    label: "29-3-A",
    uiTitle: "Hayır, boş ve kilitli.",
    uiSubtitle: "Çatı arası temiz.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Çatı arası temiz ve güvenlidir."
  );
  static final catiOptionB = ChoiceResult(
    label: "29-3-B",
    uiTitle: "Evet, depo gibi kullanılıyor.",
    uiSubtitle: "Eski eşyalar, mobilya, temizlik ürünleri vb. farklı yanıcı maddeler vs. var.",
    reportText: "🚨 RİSK: Çatı araları elektrik kontağından en çok yangın görülen yerlerdir. Buradaki fazla eşyalar yangına sebep olur veya mevcut yangına katkı sağlayarak hızlandırır."
  );
  static final catiOptionC = ChoiceResult(
    label: "29-3-C",
    uiTitle: "Bilmiyorum / Çatıya hiç çıkmadım.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Çatı arasının durumu bilinmiyor. Genellikle fazla eşyaların biriktirildiği yerdir. Elektrik tesisatından çıkabilecek bir kıvılcım, buradaki kuru ve tozlu eşyaları anında tutuşturur. Kontrol edilmesi hayati önem taşır."
  );

  // 4. ASANSÖR MAKİNE DAİRESİ
  static final asansorOptionA = ChoiceResult(
    label: "29-4-A",
    uiTitle: "Hayır, temiz.",
    uiSubtitle: "Makine dairesinde sadece motor var.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Asansör makine dairesi temizdir."
  );
  static final asansorOptionB = ChoiceResult(
    label: "29-4-B",
    uiTitle: "Evet, malzemeler var.",
    uiSubtitle: "Yağ tenekesi, bez vs. yanıcı maddeler var.",
    reportText: "🚨 RİSK: Asansör motorları ısınır. Yanındaki yağlı bezler veya malzemeler tutuşabilir. Makine dairesi depo olarak kullanılamaz."
  );
  static final asansorOptionC = ChoiceResult(
    label: "29-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Asansör makine dairesinin durumu bilinmiyor. Motorların ısınmasıyla yanabilecek yağlı bezler veya plastik malzemeler burada büyük risk oluşturur. Yöneticiden bilgi alınız."
  );

  // 5. JENERATÖR ODASI
  static final jeneratorOptionA = ChoiceResult(
    label: "29-5-A",
    uiTitle: "Hayır.",
    uiSubtitle: "Sadece jeneratör ve ilgili ekipmanlar var.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Jeneratör odası temizdir."
  );
  static final jeneratorOptionB = ChoiceResult(
    label: "29-5-B",
    uiTitle: "Evet.",
    uiSubtitle: "Yanıcı malzemeler, eşya vb. bekletiliyor.",
    reportText: "🚨 KRİTİK RİSK: Jeneratör odasında sadece günlük yakıt tankı bulunabilir. Bidonla yakıt saklamak veya eşya koymak yasaktır."
  );
  static final jeneratorOptionC = ChoiceResult(
    label: "29-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Jeneratör odasının durumu bilinmiyor. İçeride yakıt buharı olabilir. Depolanan gereksiz eşyalar havalandırmayı tıkayabilir veya yangın yükünü artırabilir. Uzman kontrolü önerilir."
  );

  // 6. ELEKTRİK PANO ODASI
  static final panoOptionA = ChoiceResult(
    label: "29-6-A",
    uiTitle: "Hayır.",
    uiSubtitle: "Pano odası boş.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Elektrik pano odası temizdir."
  );
  static final panoOptionB = ChoiceResult(
    label: "29-6-B",
    uiTitle: "Evet.",
    uiSubtitle: "Paspas, süpürge, kağıt saklanıyor.",
    reportText: "🚨 RİSK: Pano odaları kesinlikle boş olmalıdır. Elektrik kontağı anında yanıcı malzemeleri tutuşturur."
  );
  static final panoOptionC = ChoiceResult(
    label: "29-6-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: " ",
    reportText: "❓ BİLİNMİYOR: Elektrik odasının içi bilinmiyor. Pano odaları yangınların en sık başladığı yerlerdir. İçeride unutulan bir paspas veya kağıt parçası, küçük bir ark (kıvılcım) sonucu büyük bir yangını başlatabilir."
  );

  // 7. TRAFO ODASI
  static final trafoOptionA = ChoiceResult(
    label: "29-7-A",
    uiTitle: "Evet, temiz ve havadar.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Trafo odası havalandırılıyor ve temiz tutuluyor."
  );
  static final trafoOptionB = ChoiceResult(
    label: "29-7-B",
    uiTitle: "Hayır, menfezler kapalı veya içeride eşya var.",
    uiSubtitle: "",
    reportText: "🚨 KRİTİK RİSK: Trafo odaları ısınır ve patlama riski taşır. Havalandırma asla kapatılmamalı ve içerisi depo yapılmamalıdır."
  );
  static final trafoOptionC = ChoiceResult(
    label: "29-7-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Trafo odasının durumu bilinmiyor. Yüksek gerilim hattı taşıyan bu odaların havalandırmasının kapanması veya içeride eşya olması patlama riskini doğurur. Acilen kontrol edilmelidir."
  );

  // 8. ORTAK DEPO
  static final depoOptionA = ChoiceResult(
    label: "29-8-A",
    uiTitle: "Hayır, sadece ev eşyası.",
    uiSubtitle: "Yüksek yanıcı madde yok.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Depolarda parlayıcı madde tespit edilmemiştir."
  );
  static final depoOptionB = ChoiceResult(
    label: "29-8-B",
    uiTitle: "Evet, boya kutuları veya kimyasallar var.",
    uiSubtitle: "Yanıcı kimyasallar saklanıyor.",
    reportText: "⚠️ UYARI: Apartman altındaki depolarda parlayıcı madde saklamak yasaktır. Bu malzemeler özel güvenlikli dolaplarda tutulmalıdır."
  );
  static final depoOptionC = ChoiceResult(
    label: "29-8-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Depolarda ne saklandığı bilinmiyor. Komşularınızın buraya koyduğu tiner, boya veya LPG tüpü gibi malzemeler tüm binayı riske atabilir. Depo denetimi yapılmalıdır."
  );

  // 9. ÇÖP ODASI
  static final copOptionA = ChoiceResult(
    label: "29-9-A",
    uiTitle: "Düzenli atılıyor, temiz.",
    uiSubtitle: "Yoğun koku veya gaz birikmesi yok.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Çöp odası temizliği uygun gözüküyor."
  );
  static final copOptionB = ChoiceResult(
    label: "29-9-B",
    uiTitle: "Çöpler birikiyor, hijyen kötü.",
    uiSubtitle: "Hijyen kötü, yoğun koku var.",
    reportText: "🚨 RİSK: Biriken çöpler metan gazı oluşturur ve kendiliğinden yanabilir. Günlük temizlik şarttır."
  );
  static final copOptionC = ChoiceResult(
    label: "29-9-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: " ",
    reportText: "❓ BİLİNMİYOR: Çöp odasının hijyen durumu bilinmiyor. Biriken çöplerden sızan metan gazı, kapalı alanda patlama veya zehirlenme riski oluşturur. Havalandırma ve temizlik kontrol edilmelidir."
  );

  // 10. SIĞINAK
  static final siginakOptionA = ChoiceResult(
    label: "29-10-A",
    uiTitle: "Hayır.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Sığınakta yanıcı madde depolanmamaktadır."
  );
  static final siginakOptionB = ChoiceResult(
    label: "29-10-B",
    uiTitle: "Evet.",
    uiSubtitle: "Boya, tiner, tüp vb. var.",
    reportText: "⚠️ UYARI: Sığınaklar barış zamanında depo olarak kullanılabilir ANCAK yanıcı madde konulamaz. Yangın yükünü artırır."
  );
  static final siginakOptionC = ChoiceResult(
    label: "29-10-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Sığınağın kullanım durumu bilinmiyor. Kontrolsüzce yığılan eşyalar, sığınağı güvenli bir alan olmaktan çıkarabilir. Kontrol edilmesi tavsiye edilir."
  );
}
class Bolum30Content {
  // --- 1. KONUM ---
  static final konumOptionA = ChoiceResult(
    label: "30-1-A",
    uiTitle: "Koridora veya hole açılıyor.",
    uiSubtitle: "Arada hol var.",
    reportText: "✅ OLUMLU: Kazan dairesi kapısı koridora açılmaktadır."
  );
  static final konumOptionB = ChoiceResult(
    label: "30-1-B",
    uiTitle: "Direkt merdiven boşluğuna açılıyor.",
    uiSubtitle: "Kapıyı açınca merdiven sahanlığı var.",
    reportText: "☢️ KRİTİK RİSK: Kazan dairesi kapısı ASLA doğrudan merdiven boşluğuna açılamaz. Olası bir patlama veya gaz sızıntısında merdiven kullanılamaz hale gelir."
  );
  static final konumOptionC = ChoiceResult(
    label: "30-1-C",
    uiTitle: "Binadan ayrı (dış cepheden uzakta veya bahçede).",
    uiSubtitle: "Bina dışında müstakil yapı.",
    reportText: "✅ OLUMLU: Kazan dairesi bina dışındadır."
  );
  static final konumOptionD = ChoiceResult(
    label: "30-1-D",
    uiTitle: "Bilmiyorum / Emin Değilim",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kazan dairesinin konumu ve kapı açılış yönü bilinmiyor. Yangın anında müdahale ve tahliye güvenliği için bu alanın denetlenmesi önerilir."
  );

  // --- 2. KAPASİTE ---
  static final kapasiteBilinmiyorOption = ChoiceResult(
    label: "30-2-BILMIYORUM",
    uiTitle: "Kazan dairesinin ısıl kapasitesini bilmiyorum.",
    uiSubtitle: "Kapasite bilgisine ulaşılamadı.",
    reportText: "⚠️ UYARI: Kazan dairesinin ısıl kapasitesi eğer 350kw 'ın üzerindeyse çift çıkış kapısı gereklidir."
  );

  // --- 3. KAPI SAYISI ---
  static final kapiOptionA = ChoiceResult(
    label: "30-3-A",
    uiTitle: "1 Adet Kapı.",
    uiSubtitle: "Tek çıkış var.",
    reportText: "(Büyük Kazan İse) ☢️ KRİTİK RİSK: Girdiğiniz bilgilere göre kazan daireniz 'Büyük/Yüksek Kapasiteli' sınıfındadır. Yönetmeliğe göre en az 2 adet çıkış kapısı zorunludur.<br>(Küçük Kazan İse) ✅ OLUMLU: Kapı sayısı yeterlidir."
  );
  static final kapiOptionB = ChoiceResult(
    label: "30-3-B",
    uiTitle: "2 Adet (veya daha fazla).",
    uiSubtitle: "Çift çıkış var.",
    reportText: "✅ OLUMLU: Kazan dairesinde birden fazla çıkış mevcuttur."
  );
  static final kapiOptionC = ChoiceResult(
    label: "30-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kazan dairesi çıkış kapısı sayısı bilinmiyor. Büyük kapasiteli kazanlarda acil durum tahliyesi için en az 2 çıkış şarttır."
  );

  // --- 4. HAVALANDIRMA ---
  static final havaOptionA = ChoiceResult(
    label: "30-4-A",
    uiTitle: "Evet, altta ve üstte menfezler var.",
    uiSubtitle: "Temiz ve kirli hava delikleri mevcut.",
    reportText: "✅ OLUMLU: Kazan dairesi havalandırması (alt ve üst menfez) uygundur."
  );
  static final havaOptionB = ChoiceResult(
    label: "30-4-B",
    uiTitle: "Hayır, sadece pencere, menfez vs. yok.",
    uiSubtitle: "Menfez yok, hava sirkülasyonu yetersiz.",
    reportText: "☢️ KIRMIZI RİSK: Temiz hava girişi ve kirli hava çıkışı sağlanmazsa verimsiz yanma olur ve karbonmonoksit zehirlenmesi riski doğar."
  );
  static final havaOptionC = ChoiceResult(
    label: "30-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Havalandırma durumu bilinmiyor. Yetersiz havalandırma, yanma verimini düşürür ve patlama riski oluşturur."
  );

  // --- 5. YAKIT TİPİ ---
  static final yakitOptionA = ChoiceResult(
    label: "30-5-A",
    uiTitle: "Hayır, Doğalgazlı veya Kömürlü.",
    uiSubtitle: "Sıvı yakıt değil.",
    reportText: "✅ BİLGİ: Kazan yakıtı sıvı yakıt (mazot vb.) değildir."
  );
  static final yakitOptionB = ChoiceResult(
    label: "30-5-B",
    uiTitle: "Evet, Sıvı Yakıtlı.",
    uiSubtitle: "Mazot, Fuel-oil vb.",
    reportText: "⚠️ BİLGİ: Kazan sıvı yakıtlıdır. Sızıntı ve drenaj önlemleri kritik önem taşır."
  );
  static final yakitOptionC = ChoiceResult(
    label: "30-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Yakıt türü bilinmiyor. Yakıt türüne göre alınması gereken özel önlemler (drenaj, söndürme sistemi vb.) belirlenememiştir."
  );

  // --- 6. DRENAJ ---
  static final drenajOptionA = ChoiceResult(
    label: "30-5-B-1",
    uiTitle: "Evet, var.",
    uiSubtitle: "Kanal ve çukur mevcut.",
    reportText: "✅ OLUMLU: Sıvı yakıtlı kazanda drenaj sistemi mevcuttur."
  );
  static final drenajOptionB = ChoiceResult(
    label: "30-5-B-2",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Zemin düz.",
    reportText: "⚠️ UYARI: Sıvı yakıtlı kazan dairelerinde, yakıt sızıntısını toplayacak drenaj kanalları ve yakıt ayırıcılı pis su çukuru zorunludur."
  );
  static final drenajOptionC = ChoiceResult(
    label: "30-5-B-3",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Sıvı yakıtlı kazanlarda sızıntı önleme (drenaj) sistemi olup olmadığı bilinmiyor."
  );

  // --- 7. TÜP ---
  static final tupOptionA = ChoiceResult(
    label: "30-6-A",
    uiTitle: "Evet, en az 6kg'lık yangın söndürme tüpü var.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Yangın söndürme tüpü mevcuttur. Büyük/Yüksek kapasiteli kazan dairelerinde yangın dolabı da olmalıdır."
  );
  static final tupOptionB = ChoiceResult(
    label: "30-6-B",
    uiTitle: "Evet, yangın söndürme tüpü ve yangın dolabı var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Yangın söndürme ekipmanları tamdır."
  );
  static final tupOptionC = ChoiceResult(
    label: "30-6-C",
    uiTitle: "Hayır, hiçbiri yok.",
    uiSubtitle: "Söndürme cihazı yok.",
    reportText: "☢️ KRİTİK RİSK: Kazan dairesinde en az 1 adet 6 kg'lık Kuru Kimyevi Tozlu yangın söndürme cihazı bulunması yasal zorunluluktur."
  );
  static final tupOptionD = ChoiceResult(
    label: "30-6-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Söndürme ekipmanlarının varlığı bilinmiyor. Kazan dairesinde en az 1 adet 6 kg'lık tüp bulunması şarttır."
  );
}
class Bolum31Content {
  static final yapiOptionA = ChoiceResult(
    label: "31-1-A",
    uiTitle: "Duvarları beton/tuğla, kapısı dışarıya açılıyor.",
    uiSubtitle: "Yangına dayanıklı duvar ve kapı mevcut.",
    reportText: "✅ OLUMLU: Trafo odası yangın kompartımanı olarak tasarlanmıştır. Duvarlar ve kapı yangına dayanıklıdır."
  );

  static final yapiOptionB = ChoiceResult(
    label: "31-1-B",
    uiTitle: "Kapısı direkt apartman koridoruna açılıyor.",
    uiSubtitle: "Kapı açılınca bina içine duman dolabilir.",
    reportText: "☢️ KRİTİK RİSK: Trafo odasından çıkacak yoğun duman ve ısı, kaçış yollarını (merdivenleri) kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır."
  );

  static final yapiOptionC = ChoiceResult(
    label: "31-1-C",
    uiTitle: "Duvarları ve kapısı yangın dayanımsız.",
    uiSubtitle: "Dayanıklı olmayan malzeme (alçıpanel, ahşap kapı vb.) kullanılmıştır.",
    reportText: "☢️ RİSK: Trafo odası yangın bölmesi (kompartıman) olarak tasarlanmalıdır. Yağlı tip trafo odalarının duvarları 120dk, kapısı 90dk yangına dayanıklı olmalıdır."
  );

  static final yapiOptionD = ChoiceResult(
    label: "31-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Yapısal özellikler tespit edilemedi.",
    reportText: "❓ BİLİNMİYOR: Trafo odasının yapısal özellikleri (duvar/kapı) tespit edilememiştir. Yangın güvenliği açısından bu alanın kompartıman özelliği Uzmman tarafından incelenmelidir."
  );

  static final tipOptionA = ChoiceResult(
    label: "31-2-A",
    uiTitle: "Kuru Tip.",
    uiSubtitle: "Yağsız trafo.",
    reportText: "✅ OLUMLU: Kuru tip trafo kullanıldığı için yağ sızıntısı ve yangın riski düşüktür."
  );

  static final tipOptionB = ChoiceResult(
    label: "31-2-B",
    uiTitle: "Yağlı Tip.",
    uiSubtitle: "İçinde soğutma yağı var.",
    reportText: "(Alt soruya göre belirlenir)"
  );

  static final tipOptionC = ChoiceResult(
    label: "31-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Trafo tipi belirlenemedi.",
    reportText: "❓ BİLİNMİYOR: Trafo tipi (yağlı/kuru) belirlenememiştir. Yağlı tip trafolar daha yüksek yangın riski taşıdığından tip tespiti kritiktir."
  );

  static final cukurOptionA = ChoiceResult(
    label: "31-2-B-1",
    uiTitle: "Evet, var.",
    uiSubtitle: "Yağ toplama çukuru mevcut.",
    reportText: "✅ OLUMLU: Yağlı trafo altında toplama çukuru mevcuttur."
  );

  static final cukurOptionB = ChoiceResult(
    label: "31-2-B-2",
    uiTitle: "Hayır, düz zemin.",
    uiSubtitle: "Çukur yok, yağ etrafa yayılabilir.",
    reportText: "☢️ KRİTİK RİSK: Yağlı trafolarda, ısınan yağın taşması veya tankın delinmesi durumunda yanıcı yağın çevreye yayılmaması için toplama çukuru ZORUNLUDUR."
  );

  static final cukurOptionC = ChoiceResult(
    label: "31-2-B-3",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Zemin detayları görülemedi.",
    reportText: "❓ BİLİNMİYOR: Yağlı trafo altında yağ toplama çukuru olup olmadığı tespit edilememiştir."
  );

  static final sondurmeOptionA = ChoiceResult(
    label: "31-3-A",
    uiTitle: "Evet, dedektör ve söndürme var.",
    uiSubtitle: "Otomatik çalışan sistemler mevcut.",
    reportText: "✅ OLUMLU: Trafo odasında otomatik yangın algılama ve söndürme sistemi mevcuttur."
  );

  static final sondurmeOptionB = ChoiceResult(
    label: "31-3-B",
    uiTitle: "Hayır, hiçbir sistem yok.",
    uiSubtitle: "Sadece manuel müdahale mümkün.",
    reportText: "☢️ RİSK: Trafo odaları kapalı ve kilitli alanlardır. Yangın başladığında dışarıdan fark edilmesi zordur. Otomatik algılama ve söndürme sistemi hayati önem taşır."
  );

  static final sondurmeOptionC = ChoiceResult(
    label: "31-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Sistemlerin varlığı kontrol edilemedi.",
    reportText: "❓ BİLİNMİYOR: Trafo odasındaki otomatik söndürme/algılama sistemlerinin varlığı veya çalışabilirliği belirsizdir."
  );

  static final cevreOptionA = ChoiceResult(
    label: "31-4-A",
    uiTitle: "Hayır, çevresi ve üstü kuru.",
    uiSubtitle: "Su tesisatı riski yok.",
    reportText: "✅ OLUMLU: Trafo odası çevresinde su tesisatı riski bulunmamaktadır."
  );

  static final cevreOptionB = ChoiceResult(
    label: "31-4-B",
    uiTitle: "Evet, içinden su boruları geçiyor.",
    uiSubtitle: "Odanın içinden boru geçiyor.",
    reportText: "☢️ KRİTİK RİSK: Yüksek gerilim hattının olduğu yerden su borusu geçirilemez! Boru patlarsa su ve elektrik teması büyük bir patlamaya neden olur."
  );

  static final cevreOptionC = ChoiceResult(
    label: "31-4-C",
    uiTitle: "Evet, üstünde banyo/tuvalet var.",
    uiSubtitle: "Üst kat ıslak hacim.",
    reportText: "☢️ RİSK: Trafo odalarının üstü ıslak hacim olamaz. Üst kattan olası bir su sızıntısı trafoya damlarsa ölümcül kazalara ve yangına yol açabilir."
  );

  static final cevreOptionD = ChoiceResult(
    label: "31-4-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Çevresel riskler gözlemlenemedi.",
    reportText: "❓ BİLİNMİYOR: Trafo odası çevresindeki su tesisatı veya ıslak hacim riskleri gözlemlenememiştir."
  );
}
class Bolum32Content {
  // --- 1. YAPI ---
  static final yapiOptionA = ChoiceResult(
    label: "32-1-A",
    uiTitle: "Duvarları beton / tuğla, kapısı yangına dayanıklı çelik kapı ve dışarıya doğru açılıyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Jeneratör odasında yangın kompartımantasyonunun sağlandığı söylenebilir."
  );
  static final yapiOptionB = ChoiceResult(
    label: "32-1-B",
    uiTitle: "Kapısı direkt apartman koridoruna ve hole açılıyor.",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Jeneratör odasından çıkacak zehirli egzoz gazı ve duman, kaçış yollarını kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır."
  );
  static final yapiOptionC = ChoiceResult(
    label: "32-1-C",
    uiTitle: "Duvarlar beyaz alçıpanel vb. dayanıksız malzemeden, kapısı da yangın dayanımsız.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Jeneratör odası yangın bölmesi olarak tasarlanmalıdır. Duvarlar ve kapı en az 90-120 dakika yangına dayanmazsa, yakıt yangını binaya sıçrayabilir."
  );
  static final yapiOptionD = ChoiceResult(
    label: "32-1-D",
    uiTitle: "Bilmiyorum / Emin Değilim",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Jeneratör odasının yapısal özellikleri ve kapı dayanımı bilinmiyor. Yangın ve zehirli gaz yayılımı riskine karşı bu alanın teknik incelemesi yapılmalıdır."
  );

  // --- 2. YAKIT ---
  static final yakitOptionA = ChoiceResult(
    label: "32-2-A",
    uiTitle: "Kendi tankında veya gömülü tankta.",
    uiSubtitle: "Güvenli depolama.",
    reportText: "✅ OLUMLU: Yakıt depolama yöntemi güvenli gözükmektedir."
  );
  static final yakitOptionB = ChoiceResult(
    label: "32-2-B",
    uiTitle: "Oda içinde bidonlarda veya varillerde.",
    uiSubtitle: "Açıkta yedek yakıt var.",
    reportText: "☢️ KRİTİK RİSK: Jeneratör odasında bidonla veya açık kapta yakıt saklamak uygun değildir. Yakıt buharı elektrik kontağından alev alıp patlamaya neden olabilir."
  );
  static final yakitOptionC = ChoiceResult(
    label: "32-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Jeneratör yakıtının depolanma şekli bilinmiyor. Yanıcı sıvıların açıkta saklanması büyük bir patlama riskidir, kontrol edilmelidir."
  );

  // --- 3. ÇEVRE ---
  static final cevreOptionA = ChoiceResult(
    label: "32-3-A",
    uiTitle: "Hayır, çevresi ve üstü kuru, ıslak zemin yok.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Çevresel su riski bulunmamaktadır."
  );
  static final cevreOptionB = ChoiceResult(
    label: "32-3-B",
    uiTitle: "Evet, içinden su/doğalgaz boruları geçiyor.",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Jeneratör odasından su veya gaz tesisatı geçirilemez. Boru patlaması durumunda suyun elektrikle teması veya gaz kaçağı felakete yol açar."
  );
  static final cevreOptionC = ChoiceResult(
    label: "32-3-C",
    uiTitle: "Evet, üstünde banyo/tuvalet vb. ıslak hacim var.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Jeneratör odalarının üstü ıslak hacim olamaz. Su sızıntısı kısa devreye yol açar."
  );
  static final cevreOptionD = ChoiceResult(
    label: "32-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Jeneratör odası çevresindeki tesisat riskleri bilinmiyor. Olası bir su sızıntısının elektrik sistemine zarar verip vermeyeceği denetlenmelidir."
  );

  // --- 4. EGZOZ ---
  static final egzozOptionA = ChoiceResult(
    label: "32-4-A",
    uiTitle: "Egzoz dışarıda, havalandırma var.",
    uiSubtitle: "Gaz tahliyesi mümkün.",
    reportText: "✅ OLUMLU: Egzoz gazı bina dışına atılmaktadır."
  );
  static final egzozOptionB = ChoiceResult(
    label: "32-4-B",
    uiTitle: "Egzoz içeride veya havalandırma yok.",
    uiSubtitle: "Gaz içeride birikme yapabilir.",
    reportText: "☢️ KRİTİK RİSK: Jeneratör egzozu karbonmonoksit içerir. Egzoz sağlanmalı ve mutlaka bina dışına uzatılmalıdır."
  );
  static final egzozOptionC = ChoiceResult(
    label: "32-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Jeneratör egzoz tahliye sistemi bilinmiyor. Karbonmonoksit zehirlenmesi riskine karşı egzozun bina dışına verildiğinden emin olunmalıdır."
  );
}
class Bolum33Content {
  static final normalKatYeterli = ChoiceResult(
    label: "Normal Kat (Yeterli)",
    uiTitle: "Normal Kat Çıkış İmkanı Yeterli",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Normal katlardaki çıkış sayısı Yönetmelik şartlarını sağlamaktadır."
  );

  static final normalKatYetersiz = ChoiceResult(
    label: "Normal Kat (Yetersiz)",
    uiTitle: "Normal Kat Çıkış İmkanı Yetersiz",
    uiSubtitle: "",
    // "kullanıcı yüküne göre" ifadesini kaldırdık, daha kapsayıcı yaptık:
    reportText: "☢️ RİSK: Normal katlarda Yönetmelik kriterlerine (Kullanıcı Yükü ve Bina Yüksekliği) göre en az [GEREKEN] çıkış gerekirken, sadece [MEVCUT] çıkış var. YETERSİZ."
  );

  static final zeminKatYeterli = ChoiceResult(
    label: "Zemin Kat (Yeterli)",
    uiTitle: "Zemin Kat Çıkış İmkanı Yeterli",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Zemin kat çıkış kapasitesi yeterli görünüyor."
  );

  static final zeminKatYetersiz = ChoiceResult(
    label: "Zemin Kat (Yetersiz)",
    uiTitle: "Zemin Kat Çıkış İmkanı Yetersiz",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Zemin kattaki yoğunluk ve yapısal kriterler nedeniyle [GEREKEN] adet bağımsız çıkış kapısı gerekmektedir."
  );

  static final bodrumKatYeterli = ChoiceResult(
    label: "Bodrum Kat (Yeterli)",
    uiTitle: "Bodrum Kat Çıkış İmkanı Yeterli",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Bodrum katlardaki çıkış sayısı yeterli görünüyor."
  );

  static final bodrumKatYetersiz = ChoiceResult(
    label: "Bodrum Kat (Yetersiz)",
    uiTitle: "Bodrum Kat Çıkış Sayısı Yetersiz",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Bodrum katlarda Yönetmelik kriterlerine göre [GEREKEN] çıkış gerekirken, bodruma inen sadece [MEVCUT] adet merdiven var. YETERSİZ."
  );
}
class Bolum34Content {
  static final zeminOptionA = ChoiceResult(
    label: "34-1-A (Zemin)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Müşteriler bina girişini kullanmıyor, direkt dükkan kapısından çıkabiliyor.",
    reportText: "✅ OLUMLU: Zemin kattaki ticari alanların kendi bağımsız çıkışları olduğu için, bina ana girişine ve merdivenlerine ek yük getirmezler."
  );

  static final zeminOptionB = ChoiceResult(
    label: "34-1-B (Zemin)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Dükkan giriş çıkışları bina koridorunun içinden sağlanıyor.",
    reportText: "⚠️ UYARI: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Bina ana giriş kapısının genişliği bu ekstra yükü kaldıracak kapasitede olmalıdır."
  );

  static final zeminOptionC = ChoiceResult(
    label: "34-1-C (Zemin)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Dükkan giriş çıkışlarının nasıl olduğunu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir."
  );

  static final bodrumOptionA = ChoiceResult(
    label: "34-2-A (Bodrum)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Bina ortak merdivenini kullanmak zorunda değiller.",
    reportText: "✅ OLUMLU: Bodrum kattaki ticari kullanımın kendine ait bağımsız kaçış yolu olması büyük avantajdır. Bina merdivenleri sadece konut sakinlerine kalır."
  );

  static final bodrumOptionB = ChoiceResult(
    label: "34-2-B (Bodrum)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Bina ortak merdivenini kullanıyorlar.",
    reportText: "☢️ RİSK: Bodrum kattaki ticari alanın (Örn: Restauran, kafe, spor salonu vb.) kalabalığı, bina sakinleriyle aynı merdiveni kullanacaktır. Bu durum kaçış anında merdivende tıkanıklığa yol açabilir."
  );

  static final bodrumOptionC = ChoiceResult(
    label: "34-2-C (Bodrum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Bodrum çıkışlarını bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir."
  );
}
class Bolum35Content {
  // --- SENARYO 1: TEK YÖN ---
  static final tekYonOptionA = ChoiceResult(
    label: "35-1-A",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "Mesafeyi metre cinsinden gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)"
  );
  static final tekYonOptionB = ChoiceResult(
    label: "35-1-B",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Mesafe yakın.",
    reportText: "✅ OLUMLU: Tek yön kaçış mesafesi Yönetmelik sınırları içerisindedir."
  );
  static final tekYonOptionC = ChoiceResult(
    label: "35-1-C",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Mesafe uzun.",
    reportText: "☢️ RİSK: Tek yön kaçış mesafesi sınırın üzerinde! Yangın anında merdivene ulaşmak uzun sürebilir."
  );
  static final tekYonOptionD = ChoiceResult(
    label: "35-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi tahmin edemiyorum.",
    reportText: "❓ BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Bu mesafe, insanların tahliye süresini belirleyen en önemli faktördür. Ölçüm yapılmalıdır."
  );

  // --- SENARYO 2: ÇİFT YÖN (EN YAKIN) ---
  static final ciftYonOptionA = ChoiceResult(
    label: "35-2-A",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "En yakın çıkışa olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)"
  );
  static final ciftYonOptionB = ChoiceResult(
    label: "35-2-B",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Mesafe yakın.",
    reportText: "✅ OLUMLU: En yakın çıkışa kaçış mesafesi yönetmelik sınırları içerisindedir."
  );
  static final ciftYonOptionC = ChoiceResult(
    label: "35-2-C",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Mesafe uzak.",
    reportText: "☢️ RİSK: En yakın çıkışa mesafe sınırın üzerinde! (Limit: [LİMİT] m)."
  );
  static final ciftYonOptionD = ChoiceResult(
    label: "35-2-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi tahmin edemiyorum.",
    reportText: "❓ BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Ölçüm yapılmalıdır."
  );

  static final cikmazOptionA = ChoiceResult(
    label: "35-3-A",
    uiTitle: "Hayır, daireden çıkınca sağa veya sola (iki farklı yöne) gidebiliyorum.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Daire çıkmaz koridor üzerinde değildir."
  );
  static final cikmazOptionB = ChoiceResult(
    label: "35-3-B",
    uiTitle: "Evet, çıkmaz bir koridorun ucundayım.",
    uiSubtitle: "Sadece tek yöne gidebiliyorum.",
    reportText: "(Alt soru açılır)"
  );

  static final cikmazMesafeOptionA = ChoiceResult(
    label: "35-3-C",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "Yol ayrımına kadar olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)"
  );
  static final cikmazMesafeOptionB = ChoiceResult(
    label: "35-3-D",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Çıkmaz koridoru boyu kısa.",
    reportText: "✅ OLUMLU: Çıkmaz koridor mesafesi yönetmelik sınırları içerisindedir."
  );
  static final cikmazMesafeOptionC = ChoiceResult(
    label: "35-3-E",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Çıkmaz koridorun boyu uzun.",
    reportText: "☢️ RİSK: Çıkmaz koridor mesafesi sınırın üzerinde! Duman dolduğunda kaçacak yeriniz kalmaz."
  );
  static final cikmazMesafeOptionD = ChoiceResult(
    label: "35-3-F",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Çıkmaz koridor mesafesi bilinmiyor. Ölçüm yapılmalıdır."
  );
}
class Bolum36Content {
  static final disMerdOptionA = ChoiceResult(
    label: "36-1-A",
    uiTitle: "Hayır, merdiven etrafındaki duvarlar tamamen sağır (düz duvar).",
    uiSubtitle: "Merdiven etrafında pencere yok.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Dış kaçış merdiveni etrafında alev sıçrayabilecek açıklık bulunmamaktadır."
  );
  static final disMerdOptionB = ChoiceResult(
    label: "36-1-B",
    uiTitle: "Evet, merdivenin hemen yanında/altında daire pencereleri veya kapılar var.",
    uiSubtitle: "Merdivenin hemen yanında açıklık var.",
    reportText: "🚨 RİSK: Açık dış kaçış merdiveninin 3 metre yakınında korunumsuz pencere veya kapı bulunamaz. Daireden çıkan alevler merdiveni sarabilir ve kaçışı imkansız hale getirebilir."
  );
  static final disMerdOptionC = ChoiceResult(
    label: "36-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Duvar durumunu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Dış merdiven çevresindeki açıklıklar bilinmiyor. Yangın anında alevlerin merdivene sıçrama riski kontrol edilmelidir."
  );

  static final konumOptionA = ChoiceResult(
    label: "36-2-A",
    uiTitle: "Birbirlerine uzaklar (Koridorun zıt uçlarındalar / Farklı cephedeler).",
    uiSubtitle: "Koridorun zıt uçlarındalar.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Merdivenlerin zıt yönlerde olması, alternatif kaçış imkanı sağlar."
  );
  static final konumOptionB = ChoiceResult(
    label: "36-2-B",
    uiTitle: "Yan yanalar veya birbirlerine çok yakınlar.",
    uiSubtitle: "Birbirlerine bitişikler.",
    reportText: "🚨 KRİTİK RİSK: Kaçış merdivenleri birbirinin alternatifi olmalıdır. Yan yana yapılan merdivenler 'Alternatif Çıkış' sayılmaz."
  );
  static final konumOptionC = ChoiceResult(
    label: "36-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Konumlarını bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Merdiven konumları net değil. Çıkışlar arası mesafe yönetmelik kriterlerine göre incelenmelidir."
  );

  static final genislikBilinmiyor = ChoiceResult(
    label: "36-3-BILMIYORUM",
    uiTitle: "Merdiven/Koridor genişliğini bilmiyorum.",
    uiSubtitle: "Ölçüm yapılamadı.",
    reportText: "⚠️ UYARI: Kaçış yolu genişliği ölçülemediği için tahliye kapasitesi doğrulaması yapılamamıştır."
  );

  static final kapiTipiOptionA = ChoiceResult(
    label: "36-4-A",
    uiTitle: "Tek Kanatlı Kapı.",
    uiSubtitle: "Normal oda kapısı gibi.",
    reportText: "ℹ️ BİLGİ: Çıkış kapısı tek kanatlı olarak beyan edilmiştir."
  );
  static final kapiTipiOptionB = ChoiceResult(
    label: "36-4-B",
    uiTitle: "Çift Kanatlı Kapı.",
    uiSubtitle: "İki yana açılan kapı.",
    reportText: "ℹ️ BİLGİ: Çıkış kapısı çift kanatlı olarak beyan edilmiştir."
  );
  static final kapiTipiOptionC = ChoiceResult(
    label: "36-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapı tipi belirsiz.",
    reportText: "❓ BİLİNMİYOR: Çıkış kapısı tipi bilinmiyor."
  );

  static final kapiGenislikBilinmiyor = ChoiceResult(
    label: "36-4-ALT-BILMIYORUM",
    uiTitle: "Kapı net geçiş genişliğini bilmiyorum.",
    uiSubtitle: "Ölçüm yapılamadı.",
    reportText: "⚠️ UYARI: Çıkış kapısı net genişliği bilinmiyor. Kapı genişliği kullanıcı yüküne göre yetersiz olabilir."
  );

  static final gorunurlukOptionA = ChoiceResult(
    label: "36-5-A",
    uiTitle: "Evet, açıkça görünüyor ve engel yok.",
    uiSubtitle: "Engel yok.",
    reportText: "✅ OLUMLU GÖRÜNÜYOR: Kaçış yolları ve çıkış kapıları açıkça görülebilir durumdadır."
  );
  static final gorunurlukOptionB = ChoiceResult(
    label: "36-5-B",
    uiTitle: "Hayır, önünde eşyalar var veya görmekte zorlanıyorum.",
    uiSubtitle: "Çıkışlar kapalı veya görünmüyor.",
    reportText: "🚨 RİSK: Çıkışlar her an kullanılabilir durumda ve engelsiz olmalıdır."
  );
  static final gorunurlukOptionC = ChoiceResult(
    label: "36-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Durumu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Çıkışların erişilebilirliği ve görünürlüğü tespit edilememiştir."
  );
}