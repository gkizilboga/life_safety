import 'package:life_safety/models/choice_result.dart';

class Bolum1Content {
  static final ruhsatSonrasi = ChoiceResult(
    label: "1-A",
    uiTitle: "19.12.2007 ve sonrasında alındı.",
    uiSubtitle: "Bina, YENİ BİNA statüsünde kabul edilecektir.",
    reportText:
        "ℹ️ BİLGİ: Binanın yapı ruhsat tarihi 19.12.2007 ve sonrası olduğu için, analiz \"Binaların Yangından Korunması Hakkında Yönetmelik\" (BYKHY) kapsamındaki \"YENİ BİNA\" hükümlerine göre yapılmıştır.",
  );

  static final ruhsatOncesi = ChoiceResult(
    label: "1-B",
    uiTitle: "19.12.2007 öncesinde alındı.",
    uiSubtitle:
        "Tarih itibarıyla MEVCUT BİNA statüsünde ancak yine de YENİ BİNA hükümlerine göre değerlendirilsin.",
    reportText:
        "ℹ️ BİLGİ: Bina, ruhsat tarihi itibarıyla \"Mevcut Bina\" statüsünde olmasına rağmen, kullanıcı talebi üzerine güncel yönetmeliğin \"YENİ BİNA\" standartlarına göre değerlendirilmiştir. MEVCUT BİNA 'nın yangın güvenlik gereksinimleri Yangın Yönetmeliği 'nde  YENİ BİNA 'ya göre daha esnek ve daha hafiftir. Bu sebeple MEVCUT BİNA için Yangın Güvenlik Uzmanı tarafından hususi değerlendirme yapılması önerilir.  ",
  );
}

class Bolum2Content {
  static final betonarme = ChoiceResult(
    label: "2-A",
    uiTitle: "Betonarme",
    uiSubtitle:
        "Türkiye'deki binaların tamamına yakını betonarmedir. Binada kolon, kiriş, perde beton vardır.",
    reportText:
        "ℹ️ BİLGİ: Binanın taşıyıcı sistemi BETONARME olarak beyan edilmiştir. Yangın dayanım hesapları (paspayı vb.) betonarme standartlarına göre değerlendirilmiştir.",
  );

  static final celik = ChoiceResult(
    label: "2-B",
    uiTitle: "Çelik",
    uiSubtitle:
        "Türkiye'deki konut sektöründe nadiren görülür. Binanın iskeleti kalın çelik profillerden oluşur.",
    reportText:
        "ℹ️ BİLGİ: Binanın taşıyıcı sistemi ÇELİK olarak beyan edilmiştir. Çelik yapılar yüksek sıcaklıkta (540°C) taşıma gücünü hızla kaybettiği için, yangın yalıtımı (boya/kaplama) kritik önem taşımaktadır.",
  );

  static final ahsap = ChoiceResult(
    label: "2-C",
    uiTitle: "Ahşap",
    uiSubtitle: "Binanın ana taşıyıcıları kalın ahşap kolon, kirişten oluşur.",
    reportText:
        "ℹ️ BİLGİ:Binanın taşıyıcı sistemi AHŞAP olarak beyan edilmiştir. Ahşap yapıların yangın dayanımı, kullanılan kesitlerin kalınlığına (kömürleşme hızına) bağlı olarak değerlendirilmiştir.",
  );

  static final yigma = ChoiceResult(
    label: "2-D",
    uiTitle: "Yığma / Kagir (Taş Duvarlı)",
    uiSubtitle:
        "Binada kolon, kiriş olmaz. Tüm yükü taşıyan kalın taş duvarlardır.",
    reportText:
        "ℹ️ BİLGİ: Binanın taşıyıcı sistemi YIĞMA (KAGİR) olarak beyan edilmiştir. Yığma binalarda duvar kalınlıkları (en az 19 cm), yangın dayanım süresini belirleyen ana faktördür.",
  );

  static final bilinmiyor = ChoiceResult(
    label: "2-E",
    uiTitle: "Bilmiyorum / Emin Değilim",
    uiSubtitle:
        "Türkiye konut sektörü baz alınarak binanın Betonarme olduğu varsayılacaktır.",
    reportText:
        "ℹ️ BİLGİ: Binanın taşıyıcı sistemi net olarak bilinmemektedir. Türkiye'deki yapı stoğunun büyük çoğunluğu betonarme olduğu için analiz BETONARME varsayımıyla yapılmıştır. Kesin sonuç için statik proje incelenmelidir.",
  );
}

class Bolum3Content {
  static final biliniyor = ChoiceResult(
    label: "3-3-A",
    uiTitle: "Kat yüksekliklerini biliyorum.",
    uiSubtitle: "Hassas ölçüm değerlerini gireceğim.",
    reportText:
        "ℹ️ BİLGİ:Bina yükseklik analizi beyan edilen değerler üzerinden yapılmıştır.",
  );

  static final bilinmiyor = ChoiceResult(
    label: "3-3-B",
    uiTitle: "Bilmiyorum / Standart değerleri kullan.",
    uiSubtitle: "Zemin: 3.5m, Normal: 3m, Bodrum: 3.5m kabul edilir.",
    reportText:
        "ℹ️ BİLGİ: Kat yükseklikleri bilinmediği için standart mühendislik değerleri kullanılmıştır.",
  );
}

class Bolum4Content {
  static final yukseklikSinifiDusuk = ChoiceResult(
    label: "Bina (Bodrum Hariç) < 21.50m",
    uiTitle: "YÜKSEK OLMAYAN BİNA",
    uiSubtitle: "",
    reportText: "",
  );

  static final yukseklikSinifiYuksek = ChoiceResult(
    label: "Bina (Bodrum Hariç) ≥ 21.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText: "",
  );

  static final yukseklikSinifiCokYuksek = ChoiceResult(
    label: "Bina (Bodrum Hariç) ≥ 30.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText: "",
  );

  static final yukseklikSinifiMaksimum = ChoiceResult(
    label: "Bina (Bodrum Hariç) ≥ 51.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText: "",
  );

  static final yapiYuksekligiUyari = ChoiceResult(
    label: "Yapı (Bodrum Dahil) > 30.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText: "",
  );
  static final yapiYuksekligiMaksimum = ChoiceResult(
    label: "Yapı (Bodrum Dahil) ≥ 51.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText: "",
  );
}

class Bolum5Content {
  static final oturumAlani = ChoiceResult(
    label: "5-1 (Oturum)",
    uiTitle: "Zemin Kat (Taban) Alanı",
    uiSubtitle: "Binanın zemin katının brüt alanı.",
    reportText: "Zemin Kat Alanı: ",
  );

  static final normalKatAlani = ChoiceResult(
    label: "5-2 (Normal)",
    uiTitle: "Normal Kat Alanı",
    uiSubtitle: "Zemin üstü standart bir katın brüt alanı.",
    reportText: "Normal Kat Alanı: ",
  );

  static final bodrumKatAlani = ChoiceResult(
    label: "5-3 (Bodrum)",
    uiTitle: "Bodrum Kat Alanı",
    uiSubtitle: "Zemin altı standart bir katın brüt alanı.",
    reportText: "Bodrum Kat Alanı: ",
  );

  static final toplamInsaat = ChoiceResult(
    label: "5-4 (Toplam)",
    uiTitle: "Toplam İnşaat Alanı",
    uiSubtitle: "Tüm katların (Zemin+Normal+Bodrum) toplam brüt alanı.",
    reportText: "Toplam İnşaat Alanı: ",
  );

  static final otomatikHesap = ChoiceResult(
    label: "5-Otomatik",
    uiTitle: "OTOMATİK HESAPLA",
    uiSubtitle: "Kat sayıları ve alan verileriyle toplamı hesaplar.",
    reportText:
        "Toplam inşaat alanı sistem tarafından otomatik hesaplanmıştır.",
  );
}

class Bolum6Content {
  static final otoparkVar = ChoiceResult(
    label: "6-1-A (Otopark)",
    uiTitle: "Binada (kapalı veya yarı-açık) otopark bulunmaktadır.",
    uiSubtitle: "Zemin (ve/veya bodrum) katta otopark alanı mevcut.",
    reportText:
        "ℹ️ BİLGİ: Binada kapalı veya yarı-açık otopark alanı bulunmaktadır. Otoparkların yangın yükü yüksek olduğundan ek önlemler almak gereklidir.",
  );

  static final ticariVar = ChoiceResult(
    label: "6-1-B (Ticari)",
    uiTitle: "Binada konut haricinde ticari alanlar bulunmaktadır.",
    uiSubtitle: "Dükkan, mağaza, kafe, ofis, her türlü işyeri vb.",
    reportText:
        "ℹ️ BİLGİ: Binada konut harici ticari kullanım (ofis, işyerleri vb.) mevcuttur. Karma kullanımlı binalarda, ticari alanların konutlardan yangın duvarlarıyla ayrılması önerilmektedir.",
  );

  static final depoVar = ChoiceResult(
    label: "6-1-C (Depo)",
    uiTitle: "Binada depolama alanları bulunmaktadır.",
    uiSubtitle: "Konut sakinlere ait eşya deposu vb.",
    reportText:
        "ℹ️ BİLGİ: Binada konutlara ait ortak depo alanı bulunmaktadır. Depolanan malzemeler yanıcılık seviyelerine göre risk oluşturabilir.",
  );

  static final sadeceKonut = ChoiceResult(
    label: "6-1-D (Sadece Konut)",
    uiTitle: "Binada konut dışında başka amaçlı herhangi bir alan yok.",
    uiSubtitle: "Sadece meskenler var.",
    reportText:
        "ℹ️ BİLGİ: Bina sadece konut amaçlı kullanılmaktadır. Ekstra yangın yükü yaratabilecek bir kullanım bulunmamaktadır.",
  );

  static final otoparkKapali = ChoiceResult(
    label: "6-2-A (Otopark Tipi)",
    uiTitle: "Otoparkın tavanı, tabanı ve tüm yan duvarları kapalı.",
    uiSubtitle: "Otopark, toprak altında veya duvarları örülü biçimdedir.",
    reportText:
        "ℹ️ BİLGİ (KAPALI OTOPARK): Otoparkın doğal havalandırma imkanı olmadığı için \"Kapalı Otopark\" statüsündedir. Yönetmeliğe göre Kapalı Otopark yangın güvenlik ihtiyaçları farklıdır. Kapalı alan bilgisine göre duman tahliyesi vb. ihtiyaçlar doğar.",
  );

  static final otoparkAcik = ChoiceResult(
    label: "6-2-B (Otopark Tipi)",
    uiTitle: "Otoparkın karşılıklı iki cephesi tamamen açık.",
    uiSubtitle: "Doğal havalandırma mevcut.",
    reportText:
        "ℹ️ BİLGİ: (AÇIK OTOPARK): Otoparkın karşılıklı cepheleri açık olduğu için doğal havalandırma yeterli kabul edilebilir. İçeride duman birikme ihtimali düşüktür.",
  );

  static final otoparkYariAcik = ChoiceResult(
    label: "6-2-C (Otopark Tipi)",
    uiTitle:
        "Otoparkın sadece tek bir cephesinde açıklık var. Diğer cepheleri duvarla örülü.",
    uiSubtitle: "Otopark cephesinde pencereler veya açıklıklar var.",
    reportText:
        "ℹ️ BİLGİ: Otoparkta sadece tek cephede açıklık olması duman tahliyesi ve havalandırma için yeterli değildir. \"Kapalı Otopark\" kuralları geçerlidir.",
  );
}

class Bolum7Content {
  static const String otoparkBilgiNotu =
      "İşaretlemeye çalışmayınız, binada kapalı otopark olup olmadığı bilgisi önceki bölümden alınıp sisteme işlenmiştir.";

  static final otopark = ChoiceResult(
    label: "7-1 (Otopark)",
    uiTitle: "Kapalı Otopark",
    uiSubtitle: "(Sistem tarafından otomatik işaretlenir)",
    reportText: "(Bölüm 6'dan gelen bilgiye göre rapora eklenir)",
  );

  static final kazan = ChoiceResult(
    label: "7-2 (Kazan)",
    uiTitle: "Kazan Dairesi / Isı Merkezi",
    uiSubtitle: "Mahal içerisinde ısıtma kazanı (boiler) bulunur.",
    reportText:
        "ℹ️ BİLGİ: Binada Kazan Dairesi mevcuttur. Yakıt ve basınç nedeniyle binanın en yüksek riskli alanıdır. 120 dk yangın dayanımlı duvarlarla ayrılmalıdır.",
  );

  static final asansor = ChoiceResult(
    label: "7-3 (Asansör)",
    uiTitle: "Normal Asansör",
    uiSubtitle: "İnsan taşıma amaçlı asansör.",
    reportText:
        "ℹ️ BİLGİ: Binada asansör mevcuttur. Asansör kuyuları alevin ve dumanın üst katlara yayılmasında baca görevi görebilir.",
  );

  static final cati = ChoiceResult(
    label: "7-5 (Çatı)",
    uiTitle: "Çatı Arası",
    uiSubtitle:
        "Çatı ile binanın en üst katı arasında kalan boşluk veya mahal.",
    reportText:
        "ℹ️ BİLGİ: Binada çatı arası ya da çatı katı mevcuttur. Bu alanlarda elektrik tesisatı veya ekipman kaynaklı yangın riski yüksektir. Yanıcı madde depo alanı olarak kullanılmamalıdır.",
  );

  static final jenerator = ChoiceResult(
    label: "7-6 (Jeneratör)",
    uiTitle: "Jeneratör Odası",
    uiSubtitle: "Bina için yedek güç kaynağının olduğu mahal.",
    reportText:
        "ℹ️ BİLGİ: Binada Jeneratör Odası mevcuttur. Jeneratörün çalışması için yakıt depolama ve çıkabilecek egzoz gazları nedeniyle yüksek yangın ve zehirlenme riski taşır.",
  );

  static final elektrik = ChoiceResult(
    label: "7-7 (Elektrik)",
    uiTitle: "Elektrik Odası / Pano Odası",
    uiSubtitle:
        "Bina için gerekli olan elektrikli ekipmanların veya cihazların bulunduğu mahal.",
    reportText:
        "ℹ️ BİLGİ: Binada elektrik odası mevcuttur. İstatistiklere göre bina yangınlarının büyük çoğunluğu elektrik panolarından çıkmaktadır.",
  );

  static final trafo = ChoiceResult(
    label: "7-8 (Trafo)",
    uiTitle: "Trafo Odası",
    uiSubtitle: "Yüksek gerilim trafosu.",
    reportText:
        "ℹ️ BİLGİ: Binada Trafo bulunmaktadır. Yağlı tip trafonun yangın riski yüksektir. Binadan bağımsız olarak ek önlemler alınması şarttır.",
  );

  static final depo = ChoiceResult(
    label: "7-9 (Depo)",
    uiTitle: "Ortak Depo / Ardiye",
    uiSubtitle: "Konutlara ait eşya saklama alanı.",
    reportText:
        "ℹ️ BİLGİ: Ortak depo alanı mevcuttur. Kontrolsüz eşya yığılması yangın yükünü artırır.",
  );

  static final cop = ChoiceResult(
    label: "7-10 (Çöp)",
    uiTitle: "Çöp Odası / Çöp Şut Odası",
    uiSubtitle: "Konutlara ait çöplerin biriktirildiği ufak odalar.",
    reportText:
        "ℹ️ BİLGİ: Çöp odası mevcuttur. Biriken çöplerden çıkan metan gazı yanıcıdır. Havalandırma şarttır.",
  );

  static final siginak = ChoiceResult(
    label: "7-11 (Sığınak)",
    uiTitle: "Sığınak",
    uiSubtitle: "Acil durumda kullanılacak alan.",
    reportText:
        "ℹ️ BİLGİ: Binada sığınak mevcuttur. Barış zamanında depo olarak kullanılsa bile yanıcı madde konulamaz.",
  );

  static final duvar = ChoiceResult(
    label: "7-12 (Duvar)",
    uiTitle: "Ortak Duvar",
    uiSubtitle: "Yan bina ile bitişikliği sağlayan aradaki duvar.",
    reportText:
        "ℹ️ BİLGİ: Yan bina ile ortak duvar mevcuttur. Komşu binada çıkacak bir yangının geçişini engellemek için duvarın yangına dayanıklı olması gerekir.",
  );
}

class Bolum8Content {
  static final ayrikNizam = ChoiceResult(
    label: "8-1-A",
    uiTitle: "Ayrık Nizam",
    uiSubtitle:
        "Binanın dört cephesi de açıktır, yan binalara yapışık veya bitişik değildir.",
    reportText:
        "ℹ️ BİLGİ: Bina AYRIK NİZAM olarak beyan edilmiştir. Bu durum, komşu binalardan yangın sirayeti riskini azaltır, cephe ve çatı yangın tedbirlerinde esneklik sağlar.",
  );

  static final bitisikNizam = ChoiceResult(
    label: "8-1-B",
    uiTitle: "Bitişik Nizam",
    uiSubtitle:
        "Binanın bir veya iki cephesi yan binaya yapışık veya bitişiktir.",
    reportText:
        "ℹ️ BİLGİ: Bina BİTİŞİK NİZAM olarak beyan edilmiştir. Bitişik nizam yapılarda, komşu bina ile ortak kullanılan duvarların yangın dayanım özelliği ve çatı birleşim detayları kritik öneme sahiptir.",
  );
}

class Bolum9Content {
  static final tamKapsam = ChoiceResult(
    label: "9-1-A",
    uiTitle: "Evet, tüm binada otomatik söndürme sistemi var.",
    uiSubtitle: "Daireler, koridorlar, dükkanlar, otopark dahil.",
    reportText:
        "ℹ️ BİLGİ: Binada tam kapsamlı otomatik yağmurlama (sprinkler) sistemi mevcuttur. Bu sistem, yangın anında kaçış mesafesi limitlerini artırır ve yangın güvenliğini daha üst seviyeye taşır.",
  );

  static final yok = ChoiceResult(
    label: "9-1-B",
    uiTitle: "Hayır, hiçbir yerde yok.",
    uiSubtitle: "Binada otomatik söndürme sistemi bulunmuyor.",
    reportText:
        "ℹ️ BİLGİ: Binada otomatik yağmurlama (sprinkler) sistemi bulunmamaktadır. Bu durumda kaçış mesafesi limitleri minimum değerler üzerinden değerlendirilmektedir. Sprinkler sistemi olmaması kaçış mesafeleri ve can güvenliği açısından büyük dezavantaj yaratır. Yangın Yönetmeliği-Madde 96 'ya göre belli özelliklerdeki konutlarda, otoparklarda, ticari amaçlı kısımlarda otomatik söndürme sistemi mecburiyeti doğabilmektedir.",
  );

  static final kismen = ChoiceResult(
    label: "9-1-C",
    uiTitle: "Kısmen var.",
    uiSubtitle: "Sadece bazı katlarda veya bazı mahallerde var.",
    reportText:
        "ℹ️ BİLGİ: Sprinkler sistemi binanın tamamını kapsamıyor. Yönetmelik gereği, kaçış güvenliği hesaplarında sistemin \"YOK\" olduğu varsayılacaktır. Sprinkler sisteminin tüm mahallerde veya katlarda olmaması kaçış mesafeleri ve can güvenliği açısından dezavantaj yaratır.",
  );
}

class Bolum10Content {
  static final konut = ChoiceResult(
    label: "10-A",
    uiTitle: "Konut.",
    uiSubtitle: "Daire, mesken",
    reportText: "(Hesaplamada kullanılır: 20 m²/kişi)",
  );

  static final azYogunTicari = ChoiceResult(
    label: "10-B",
    uiTitle: "Az yoğun ticari alan.",
    uiSubtitle: "Büro, ofis, oto galeri vb.",
    reportText: "(Hesaplamada kullanılır: 10 m²/kişi)",
  );

  static final ortaYogunTicari = ChoiceResult(
    label: "10-C",
    uiTitle: "Orta yoğun ticari alan.",
    uiSubtitle: "Market, mağaza, dükkan, banka şubesi vb.",
    reportText: "(Hesaplamada kullanılır: 5 m²/kişi)",
  );

  static final yuksekYogunTicari = ChoiceResult(
    label: "10-D",
    uiTitle: "Yüksek yoğun ticari alan.",
    uiSubtitle: "Restaurant, kafe, spor salonu vb.",
    reportText: "(Hesaplamada kullanılır: 1.5 m²/kişi)",
  );

  static final teknikDepo = ChoiceResult(
    label: "10-E",
    uiTitle: "Depo, teknik hacim, otopark.",
    uiSubtitle: "İnsan yoğunluğu az olan alan.",
    reportText: "(Hesaplamada kullanılır: 30 m²/kişi)",
  );
}

class Bolum11Content {
  // --- ADIM 1: MESAFE ---
  static final mesafeOptionA = ChoiceResult(
    label: "11-1-A",
    uiTitle: "Hayır, aşmıyor.",
    uiSubtitle:
        "İtfaiye aracı binanın tüm cephelerine 45 metre içerisinde ulaşabilir.",
    reportText:
        "✅ OLUMLU: İtfaiye yaklaşım mesafesi yeterli (tüm cepheler 45 metre menzil içerisinde).",
  );

  static final mesafeOptionB = ChoiceResult(
    label: "11-1-B",
    uiTitle: "Evet, aşıyor.",
    uiSubtitle:
        "İtfaiye aracı binanın tüm cephelerine 45 metre içerisinde ulaşamaz.",
    reportText:
        "☢️ KIRMIZI RİSK: İtfaiye yaklaşım mesafesi sınırın üzerindedir. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir. Mevcut durumda binanın bazı cephelerine müdahale edilemeyebilir.",
  );

  static final mesafeOptionC = ChoiceResult(
    label: "11-1-C",
    uiTitle: "İtfaiye yaklaşım mesafesini bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Uzman Görüşü alınması tavsiye edilir. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir.",
  );

  // --- ADIM 2: ENGEL ---
  static final engelOptionA = ChoiceResult(
    label: "11-2-A",
    uiTitle: "Hayır, engel yok.",
    uiSubtitle:
        "Araç binanın dibine kadar gelebiliyor, engelleyen bir duvar yok.",
    reportText:
        "✅ OLUMLU: İtfaiye aracı binaya yaklaşabiliyor, fiziksel engel bulunmuyor. Kilitli kapılar olsa bile bina güvenliği veya yönetim tarafından kilidi açılabiliyor.",
  );

  static final engelOptionB = ChoiceResult(
    label: "11-2-B",
    uiTitle: "Evet, duvar, kapı, çit gibi engel mevcut.",
    uiSubtitle: "İtfaiye aracı binaya kolayca erişemiyor.",
    reportText:
        "☢️ RİSK: İtfaiye erişimini zorlaştıran fiziksel engeller (duvar, kapı vs.) tespit edilmiştir.",
  );

  static final engelOptionC = ChoiceResult(
    label: "11-2-C",
    uiTitle: "İtfaiye aracının binamıza yaklaşım imkanını bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Mesafenin aşılmasının sebebinin duvar olup olmadığı bilinmiyor. Kontrol edilmesi ve Uzman Görüşü alınması tavsiye edilir.",
  );

  // --- ADIM 3: ZAYIF NOKTA ---
  static final zayifNoktaOptionA = ChoiceResult(
    label: "11-3-A",
    uiTitle: "Evet, var.",
    uiSubtitle: "İşaretlenmiş veya zayıflatılmış geçiş noktası mevcut.",
    reportText:
        "✅ OLUMLU: Duvar, çit, kapı vb. engeli var ancak yıkılabilir geçiş bölgesi mevcut. Lütfen bu alanın önüne araç park edilmemesine dikkat ediniz.",
  );

  static final zayifNoktaOptionB = ChoiceResult(
    label: "11-3-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Herhangi bir zayıflatılmış geçiş noktası yok.",
    reportText:
        "☢️ RİSK: İtfaiye erişimini engelleyen duvarlarda, acil durum geçişi için zayıflatılmış ve işaretlenmiş özel bir bölüm bulunmak zorundadır. Aksi takdirde itfaiye binaya ulaşamaz.",
  );
}

class Bolum12Content {
  static final celikOptionA = ChoiceResult(
    label: "12-A (Çelik)",
    uiTitle: "Evet, var.",
    uiSubtitle:
        "Çelik kolon ve kirişlerin üzeri yangın geciktirici boya, püskürtme sıva, alçıpanel vb. ile kaplanmıştır.",
    reportText:
        "Çelik taşıyıcı sistem üzerinde pasif yangın yalıtım uygulaması mevcuttur. Bu uygulama, yangın anında çeliğin kritik sıcaklık olan 540°C'ye ulaşmasını geciktirerek binanın çökme riskini minimize eder.",
  );

  static final celikOptionB = ChoiceResult(
    label: "12-B (Çelik)",
    uiTitle: "Hayır yok, çelik taşıyıcı profiller çıplak halde.",
    uiSubtitle:
        "Binanın iskeletini oluşturan çelik elemanlar üzerinde herhangi bir kaplama bulunmamaktadır.",
    reportText:
        "☢️ KIRMIZI RİSK: Çelik taşıyıcı elemanlar üzerinde herhangi bir pasif yangın yalıtımı bulunmamaktadır.",
  );

  static final celikOptionC = ChoiceResult(
    label: "12-C (Çelik)",
    uiTitle: "Bilmiyorum, bir gözlemim yok.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Çelik elemanlarda yangın koruması olup olmadığı bilinmiyor. Koruma yoksa, yangın anında bina taşıma kapasitesini hızla kaybedebilir.",
  );
  static final betonOptionA = ChoiceResult(
    label: "12-A (Beton)",
    uiTitle: "Bina yapım tarihimiz 2000 yılı sonrası.",
    uiSubtitle:
        "TS 500 standardı uyarınca, paspayı ölçülerinin (Kolon ≥ 35mm, Kiriş ≥ 25mm) uygun olduğu varsayılmıştır.",
    reportText:
        "✅ OLUMLU: TS 500 standardı uyarınca, binanızın inşa tarihi baz alınarak paspayı ölçülerinin uygun olduğu varsayılmıştır.",
  );

  static final betonOptionB = ChoiceResult(
    label: "12-B (Beton)",
    uiTitle: "Binadaki paspayı ölçülerini biliyorum, kendim gireceğim.",
    uiSubtitle:
        "Betonun içindeki demiri örten tabaka kalınlıklarını manuel gireceğim.",
    reportText: "(Girilen değerlere göre otomatik analiz edilir)",
  );

  // YENİ EKLENEN C ŞIKKI
  static final betonOptionC = ChoiceResult(
    label: "12-C (Beton)",
    uiTitle: "Bina yapım tarihimiz 2000 yılı öncesi.",
    uiSubtitle:
        "Eski standartlara göre inşa edilen yapılarda paspayı koruması zayıf olabilir.",
    reportText:
        "⚠️ UYARI: Bina yapım tarihi 2000 yılı öncesi olduğu için paspayı ölçülerinin (demir üzerindeki beton tabakası) güncel TS 500 standartlarını karşılamama ihtimali yüksektir. Yangın anında taşıyıcı sistemin korunması için detaylı inceleme yapılmalıdır.",
  );

  static final betonOptionD = ChoiceResult(
    label: "12-D (Beton)",
    uiTitle: "Paspayı durumunu bilmiyorum.",
    uiSubtitle: "Beton içindeki demir koruma tabakası hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Paspayı kalınlığı bilinmediği için yapısal yangın dayanım tahmini yapılamamıştır. Uzman incelemesi tavsiye edilir.",
  );

  static final ahsapOptionA = ChoiceResult(
    label: "12-A (Ahşap)",
    uiTitle: "İnce keresteler (10 cm'den ince).",
    uiSubtitle:
        "Taşıyıcı kolon ve kirişler ince ahşap plakalardan veya kerestelerden oluşmaktadır.",
    reportText:
        "☢️ KRİTİK RİSK: İnce ahşap kesitler yangında çok hızlı yanarak (yaklaşık 0.8mm/dk) taşıma gücünü kaybeder. Bu durum, yangın başlangıcından kısa süre sonra binanın çökme riskini doğurur.",
  );

  static final ahsapOptionB = ChoiceResult(
    label: "12-B (Ahşap)",
    uiTitle: "Kalın kütükler / Lamine kirişler.",
    uiSubtitle:
        "Taşıyıcı sistemde 10 cm'den daha kalın, masif veya lamine ahşap elemanlar kullanılmıştır.",
    reportText:
        "✅ OLUMLU: Kalın kesitli ahşaplar, yangın anında dış yüzeyi kömürleşerek iç kısmını korur ve yangına daha uzun süre direnç gösterir.",
  );

  static final yigmaOptionA = ChoiceResult(
    label: "12-A (Yığma)",
    uiTitle: "Evet, duvarlar kalın (19 cm+).",
    uiSubtitle:
        "Binanın yükünü taşıyan dış duvarlar en az bir tuğla boyu (19 cm) veya daha kalındır.",
    reportText:
        "✅ OLUMLU: En az 19 cm kalınlığındaki kagir duvarlar, yönetmeliklere uygun inşa edildiyse yüksek yangın dayanımı sağlayarak binanın stabilitesini korur.",
  );

  static final yigmaOptionB = ChoiceResult(
    label: "12-B (Yığma)",
    uiTitle: "Hayır, daha ince duvarlar var.",
    uiSubtitle: "Taşıyıcı duvarların kalınlığı 19 cm'den daha azdır.",
    reportText:
        "⚠️ UYARI: Taşıyıcı duvar kalınlığı 19 cm'den az ise yangın anında yeterli yapısal stabilite sağlanamayabilir. Uzman tarafından kontrol edilmesi önerilir.",
  );
}

class Bolum13Content {
  static final otoparkOptionA = ChoiceResult(
    label: "13-1-A (Otopark)",
    uiTitle:
        "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan yangın kapısı bulunmakta.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Otopark ile bina arasındaki geçişte yangına dayanıklı ve duman sızdırmaz kapı mevcuttur. Bu kapı, olası bir araç yangınında dumanın merdiven boşluğuna dolmasını engelleyerek tahliye güvenliğini sağlar.",
  );

  static final otoparkOptionB = ChoiceResult(
    label: "13-1-B (Otopark)",
    uiTitle:
        "Yangına dayanıksız sac, demir, plastik, aluminyum, ahşap vb. kapı bulunmakta.",
    uiSubtitle: "",
    reportText:
        "☢️ RİSK: Otopark kapısı yangına dayanıksızdır. Yönetmelik gereği bu kapı en az 90 dakika yangın dayanımlı, duman sızdırmaz ve kendiliğinden kapanan bir kapı olmalıdır. Mevcut kapı, yangın anında ısı ve dumanı saniyeler içinde yaşam alanlarına geçirebilir.",
  );

  static final otoparkOptionC = ChoiceResult(
    label: "13-1-C (Otopark)",
    uiTitle: "Arada kapı yok, direkt açık (serbest) geçiş var.",
    uiSubtitle:
        "Otopark ile merdiven (veya asansör holü) arasında herhangi bir yangın kapısı bulunmamaktadır.",
    reportText:
        "☢️ KRİTİK RİSK: Otopark ile bina arasında kompartıman ayrımı yoktur! Bir araç yangınında duman doğrudan binanın içine dolarak tüm kaçış yollarını kapatabilir. Acilen yangın duvarı ve kapısı ile ayrım yapılmalıdır.",
  );

  static final otoparkOptionD = ChoiceResult(
    label: "13-1-D (Otopark)",
    uiTitle: "Arada böyle bir kapı veya geçiş var mı yok mu emin değilim.",
    uiSubtitle: "Kapının teknik özellikleri hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Otopark kapısının teknik özellikleri bilinmiyor. Kapı yangına dayanıklı olmalıdır. Geçiş noktasıyla ilgili Uzman Görüşü alınması tavsiye edilir.",
  );

  static final kazanOptionA = ChoiceResult(
    label: "13-2-A (Kazan D.)",
    uiTitle:
        "Mahalin duvarları kalın betondan, kapısı ise çelik yangın kapısı ve dışarıya doğru açılmaktadır.",
    uiSubtitle: " ",
    reportText:
        "✅ OLUMLU: Kazan dairesi kompartımanyasonu ve kapı özellikleri uygun gözükmektedir. Kazan dairesi duvarları yangına en az 120 dk, kapıları en az 90dk. yangın dayanıma sahip olması gereklidir. Aksi halde burada olası bir yangın hızlıca bina içerisine sirayet edebilir.",
  );

  static final kazanOptionB = ChoiceResult(
    label: "13-2-B (Kazan D.)",
    uiTitle: "Mahal kapısı plastik, ahşap, cam vs. ve içeriye doğru açılıyor.",
    uiSubtitle:
        "Kapı malzemesi yangına dayanıksızdır veya açılış yönü bina içine doğrudur.",
    reportText:
        "☢️ RİSK: Kazan dairesi kapısı yangına dayanıklı olmalı ve kaçış yönüne (dışarıya) açılması önerilir. İçeri açılan kapılar, patlama veya panik anında basınç nedeniyle açılamaz hale gelerek içeridekileri hapsedebilir.",
  );

  static final kazanOptionC = ChoiceResult(
    label: "13-2-C (Kazan D.)",
    uiTitle: "Kazan dairesi binadan tamamen ayrı bir yerde.",
    uiSubtitle:
        "Kazan dairesi bina kütlesinin dışında, bahçede veya ayrı bir yapıdadır.",
    reportText:
        "✅ OLUMLU: Kazan dairesi binadan ayrı bir yerdedir. Olası bir yangında veya patlamada binaya etkisi az olacaktır.",
  );

  static final kazanOptionD = ChoiceResult(
    label: "13-2-D (Kazan D.)",
    uiTitle: "Duvar ve kapı özelliklerini bilmiyorum.",
    uiSubtitle: "Kazan dairesinin yapısal özellikleri hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Kazan dairesinin duvar ve kapı özellikleri bilinmiyor. Özellikle bina içerisinde yer alan kazan dairesindeki yangın güvenlik önlemleri hayati önem taşır, Uzman Görüşü alınması tavsiye edilir.",
  );

  static final asansorOptionA = ChoiceResult(
    label: "13-3-A (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı.",
    uiSubtitle: " .",
    reportText: "✅ OLUMLU: Asansör kat / kabin kapıları yangına dayanıklıdır.",
  );

  static final asansorOptionB = ChoiceResult(
    label: "13-3-B (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı değil.",
    uiSubtitle: " ",
    reportText:
        "⚠️ UYARI: Asansör kat / kabin kapıları yangına dayanıklı değildir. Makine daireleri yangın riski taşır, kapı dayanıklı olmalıdır.",
  );

  static final asansorOptionC = ChoiceResult(
    label: "13-3-C (Asansör)",
    uiTitle: "Bu konuda bir bilgim yok.",
    uiSubtitle: "Asansör kapılarının dayanım özellikleri bilinmiyor.",
    reportText:
        "❓ BİLİNMİYOR: Kapı özellikleri bilinmiyor, duvarlarıyla birlikte kapısının da yangına dayanıklı olması gereklidir. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final jeneratorOptionA = ChoiceResult(
    label: "13-5-A (Jeneratör)",
    uiTitle: "Yangına dayanıklı duvar ve kapı ile ayrılmış.",
    uiSubtitle: "Jeneratör odası binanın geri kalanından izole edilmiştir.",
    reportText:
        "✅ OLUMLU: Jeneratör odası yangına dayanıklı duvar ve kapı ile ayrılmıştır.",
  );

  static final jeneratorOptionB = ChoiceResult(
    label: "13-5-B (Jeneratör)",
    uiTitle:
        "Jeneratör, bina içerisinde açıkta muhafaza ediliyor veya basit bir bölme (dayanımsız duvar ve kapı) ile ayrılmış.",
    uiSubtitle: " ",
    reportText:
        "☢️ RİSK: Jeneratör yakıtı risklidir, bu mahal yangın dayanımlı duvar ve yangın kapısı ile binanında geri kalanından ayrılmalıdır.",
  );

  static final jeneratorOptionC = ChoiceResult(
    label: "13-5-C (Jeneratör)",
    uiTitle: "Jeneratör odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın yalıtım ve kapı durumu hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Jeneratör odası özellikleri bilinmiyor. Jeneratör yakıtı risklidir, bu mahal yangın dayanımlı duvar ve yangın kapısı ile binanında geri kalanından ayrılmalıdır. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final elekOdasiOptionA = ChoiceResult(
    label: "13-6-A (Elektrik Odası)",
    uiTitle: "Çelik, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle:
        "Elektrik panolarının olduğu oda özel bir kapı ile korunmaktadır.",
    reportText:
        "✅ OLUMLU: Elektrik odası yangına dayanıklı ve duman sızdırmaz kapı ile korunmaktadır.",
  );

  static final elekOdasiOptionB = ChoiceResult(
    label: "13-6-B (Elektrik Odası)",
    uiTitle: "Normal, dayanımsız (demir, plastik, ahşap, cam vs.) kapı.",
    uiSubtitle: "Elektrik odasında dayanımsız bir kapı mevcuttur.",
    reportText:
        "⚠️ UYARI: Elektrik odaları yangın başlangıç noktası olma ihtimali yüksektir, yangın dayanım özellikleri olması şarttır.",
  );

  static final elekOdasiOptionC = ChoiceResult(
    label: "13-6-C (Elektrik Odası)",
    uiTitle: "Elektrik odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın kapı ve duvar dayanımı hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Elektrik odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final trafoOptionA = ChoiceResult(
    label: "13-7-A (Trafo)",
    uiTitle: "Çelik, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle: "Trafo odası özel bir yangın kapısı ile korunmaktadır.",
    reportText:
        "✅ OLUMLU: Trafo odasının kapısı kilitli, yangına dayanıklı ve duman sızdırmaz özelliklidir.",
  );

  static final trafoOptionB = ChoiceResult(
    label: "13-7-B (Trafo)",
    uiTitle: "Normal, dayanımsız (demir, plastik, ahşap, cam vb.) kapı.",
    uiSubtitle: "Standart bir kapı veya ince sac kapı mevcuttur.",
    reportText:
        "⚠️ UYARI: Yağlı tip trafo odaları yüksek yangın riski taşır. Kapı ve duvarların yangın dayanım özellikli olması şarttır. Mevcut kapı bu riski karşılamamaktadır.",
  );

  static final trafoOptionC = ChoiceResult(
    label: "13-7-C (Trafo)",
    uiTitle: "Trafo odası kapı özelliklerini bilmiyorum.",
    uiSubtitle: "Kapının dayanım özellikleri hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Yağlı tip trafo odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Uzman Görüşü alınarak kapı tipi teyit edilmelidir.",
  );

  static final depoOptionA = ChoiceResult(
    label: "13-8-A (Depo)",
    uiTitle: "Çelik, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle:
        "Depo girişi dayanıklı bir kapı ile korunmaktadır. Binanın geri kalanından korunaklı şekilde ayrılmıştır.",
    reportText:
        "✅ OLUMLU: Ortak depo/ardiye alanının kapısı metal yangın kapısı veya sac kapıdır.",
  );

  static final depoOptionB = ChoiceResult(
    label: "13-8-B (Depo)",
    uiTitle: "Ahşap kapı, tel örgü veya kapısız.",
    uiSubtitle: "Depo alanı açıkta veya dayanıksız bir kapı ile ayrılmıştır.",
    reportText:
        "⚠️ UYARI: Depolardaki eşyalar büyük yangın yükü oluşturur. Duman sızdırmaz ve yangına dayanıklı kapı kullanılması önerilir. Mevcut durum yangının yayılmasını kolaylaştırabilir.",
  );

  static final depoOptionC = ChoiceResult(
    label: "13-8-C (Depo)",
    uiTitle: "Depo kapısı özelliklerini bilmiyorum.",
    uiSubtitle: "Kapının sızdırmazlık durumu hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Kapı durumu bilinmiyor. Depolarda duman sızdırmazlığı önemlidir. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final copOptionA = ChoiceResult(
    label: "13-9-A (Çöp O.)",
    uiTitle: "Duman sızdırmaz yangın kapısı ve havalandırma mevcut.",
    uiSubtitle:
        "Çöp odasında özel kapı ve aktif/pasif havalandırma sistemi vardır.",
    reportText:
        "✅ OLUMLU: Çöp toplama odasında duman sızdırmaz yangın kapısı ve havalandırma mevcuttur.",
  );

  static final copOptionB = ChoiceResult(
    label: "13-9-B (Çöp O.)",
    uiTitle: "Normal kapı veya havalandırma yok.",
    uiSubtitle:
        "Standart kapı kullanılmıştır veya havalandırma menfezi bulunmamaktadır.",
    reportText:
        "☢️ RİSK: Çöp odaları metan gazı birikme riski taşır. Kapı yangına dayanıklı olmalı ve oda mutlaka havalandırılmalıdır. Mevcut durum patlama veya zehirlenme riski oluşturabilir.",
  );

  static final copOptionC = ChoiceResult(
    label: "13-9-C (Çöp O.)",
    uiTitle: "Çöp odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın kapı ve havalandırma durumu hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Çöp odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final ortakDuvarOptionA = ChoiceResult(
    label: "13-10-A (Ortak Duvar)",
    uiTitle: "Kalın tuğla veya beton duvar (En az 20-25cm).",
    uiSubtitle: "Yan bina ile aradaki duvar kalın ve masif bir yapıdadır.",
    reportText:
        "✅ OLUMLU: Yan bina ile ortak kullanılan duvar kalın tuğla veya betondur (En az 20-25cm).",
  );

  static final ortakDuvarOptionB = ChoiceResult(
    label: "13-10-B (Ortak Duvar)",
    uiTitle: "İnce bölme duvar.",
    uiSubtitle: "Yan bina ile aradaki duvar ince ve zayıf bir yapıdadır.",
    reportText:
        "☢️ RİSK: Ortak duvarlar en az 90 dk yangına dayanıklı olmalıdır.",
  );

  static final ortakDuvarOptionC = ChoiceResult(
    label: "13-10-C (Ortak Duvar)",
    uiTitle: "Ortak duvarın cinsini bilmiyorum.",
    uiSubtitle: "Yan bina ile aradaki duvarın yapısı hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Bitişik nizam bina ile aradaki duvarın kalınlığı bilinmiyor. Duvarın 90 dk dayanım gösterecek özellikte olması şarttır. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final ticariOptionA = ChoiceResult(
    label: "13-11-A (Ticari)",
    uiTitle: "Tamamen ayrı girişleri var, bina içinden bağlantı yok.",
    uiSubtitle:
        "Dükkan/Ofis girişi sokağa bakmaktadır, bina koridoruyla bağlantısı yoktur.",
    reportText:
        "✅ OLUMLU: Ticari alanların tamamen ayrı girişleri var, bina içinden bağlantı yok.",
  );

  static final ticariOptionB = ChoiceResult(
    label: "13-11-B (Ticari)",
    uiTitle: "Aynı merdiven boşluğunu kullanıyorlar.",
    uiSubtitle:
        "Dükkan/Ofis kapısı bina sakinlerinin kullandığı koridora açılmaktadır.",
    reportText:
        "(Alt soruya göre belirlenir) Hayır ise: ☢️ RİSK: Farklı kullanımlar yangın kompartımanı ile ayrılmalıdır.",
  );

  static final ticariOptionC = ChoiceResult(
    label: "13-11-C (Ticari)",
    uiTitle: "Ticari alan geçiş durumunu bilmiyorum.",
    uiSubtitle:
        "Dükkanların bina içiyle bağlantısı olup olmadığını bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Farklı kullanım alanlarındaki geçiş bilinmiyor, Uzman Görüşü alınması tavsiye edilir.",
  );
}

class Bolum14Content {
  static const String title = "Bölüm-14: Tesisat Şaftları";
  static const String msgHigh =
      "Binanız 30.50 metreden yüksek olduğundan tüm tesisat şaft duvarları en az 120 dk, şaft kapakları ise en az 90 dk yangına dayanıklı ve duman sızdırmaz özellikte olmalıdır.";
  static const String msgMid =
      "Binanız 21.50m - 30.50m aralığında olup ‘Yüksek Bina’ sınıfındadır. Tesisat şaftı ve yangın duvarlarınızın en az 90 dk, şaft kapaklarınızın ise en az 60 dk dayanıklı, duman sızdırmaz özellikte olmaları gerekmektedir.";
  static const String msgDeepBasement =
      "DİKKAT: Binanız alçak olsa da, bodrum kat derinliğiniz 10 metreyi aştığı için bodrum katlarınız risk taşımaktadır. Bodrumdaki şaft duvarları en az 90 dk ve şaft kapakların dayanımları en az 60dk, zemin üst normal katlarda ise duvarları en az 60dk, kapakları en az 30dk olmalıdır.";
  static const String msgStandard =
      "Binanızın yüksekliği ve bodrum derinliği yüksek olmayan bina sınırları içindedir. Tesisat şaft duvarları en az 60 dk, şaft kapakları ise en az 30 dk dayanıklı olması yeterlidir.";
}

class Bolum15Content {
  static final kaplamaOptionA = ChoiceResult(
    label: "15-1-A",
    uiTitle: "Ahşap parke, laminat, pvc vinil, karo halı",
    uiSubtitle: "Yanıcı malzemeler.",
    reportText:
        "⚠️ UYARI: Döşeme kaplamasının yanıcılık sınıfı kontrol edilmelidir.",
  );

  static final kaplamaOptionB = ChoiceResult(
    label: "15-1-B",
    uiTitle: "Taş, seramik, mermer, yanmaz kaplama.",
    uiSubtitle: "Limitli yanıcı malzemeler.",
    reportText:
        "✅ OLUMLU: Zemin kaplaması yanmaz malzeme olarak beyan edilmiştir.",
  );

  static final kaplamaOptionC = ChoiceResult(
    label: "15-1-C",
    uiTitle: "Kaplama malzemesini bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Zemin kaplamasının yanıcılık sınıfı bilinmiyor.Yönetmelik gereği yüksek binalarda döşeme kaplamalarının en az zor alevlenici olması gerekmektedir; aksi durumda yanıcı kaplamalar risk teşkil eder.",
  );

  static final kaplamaOptionD = ChoiceResult(
    label: "15-1-D",
    uiTitle: "Karma zemin kaplama tipleri",
    uiSubtitle: "Farklı mahallerde farklı kaplamalar mevcut.",
    reportText:
        "⚠️ UYARI: Binada karma zemin kaplaması mevcuttur. Yönetmelik gereği yüksek binalarda döşeme kaplamalarının en az zor alevlenici olması gerekmektedir; aksi durumda yanıcı kaplamalar risk teşkil eder.",
  );

  static final yalitimOptionA = ChoiceResult(
    label: "15-2-A",
    uiTitle: "Hayır, ısı yalıtım yok.",
    uiSubtitle: "Döşeme betonunda yalıtım bulunmuyor.",
    reportText:
        "✅ OLUMLU: Döşeme betonu altında yanıcı yalıtım bulunmamaktadır.",
  );

  static final yalitimOptionB = ChoiceResult(
    label: "15-2-B",
    uiTitle: "Evet, ısı yalıtımı (strafor/köpük vb.) var.",
    uiSubtitle: "Yanıcı malzemeler tespit edildi.",
    reportText:
        "⚠️ RİSK: Yanıcı yalıtım malzemesi kullanımı tespit edilmiştir.",
  );

  static final yalitimOptionC = ChoiceResult(
    label: "15-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Zemin detayına erişilemiyor.",
    reportText:
        "❓ BİLİNMİYOR: Zemin altında yanıcı köpük olup olmadığı bilinmiyor.",
  );

  static final yalitimSapOptionA = ChoiceResult(
    label: "15-2-ALT-A",
    uiTitle: "Evet, en az 2 cm şap var.",
    uiSubtitle: "Koruma katmanı mevcut.",
    reportText: "✅ OLUMLU: Yanıcı yalıtım şap ile korunmuştur.",
  );

  static final yalitimSapOptionB = ChoiceResult(
    label: "15-2-ALT-B",
    uiTitle: "Hayır, şap yok.",
    uiSubtitle: "Yalıtım malzemesinin üzeri çıplak durumda.",
    reportText: "☢️ KRİTİK RİSK: Yalıtımın üzeri şap ile örtülmelidir.",
  );

  static final yalitimSapOptionC = ChoiceResult(
    label: "15-2-ALT-C",
    uiTitle: "Bilmiyorum / Göremiyorum.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Koruyucu şap tabakası olup olmadığı bilinmiyor.",
  );

  static final tavanOptionA = ChoiceResult(
    label: "15-3-A",
    uiTitle: "Hayır, asma tavan yok.",
    uiSubtitle: "Tavanlar direkt beton üzeri sıva/boya halindedir.",
    reportText: "✅ OLUMLU: Tavanlarda asma tavan bulunmamaktadır.",
  );

  static final tavanOptionB = ChoiceResult(
    label: "15-3-B",
    uiTitle: "Evet, asma tavan var.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Asma tavan malzemesi kontrol edilmelidir.",
  );

  static final tavanOptionC = ChoiceResult(
    label: "15-3-C",
    uiTitle: "Karma (Bazı alanlarda var, bazı alanlarda yok)",
    uiSubtitle: "Binanın genelinde farklı tavan yapıları mevcut.",
    reportText:
        "⚠️ UYARI: Binanın bazı bölümlerinde asma tavan tespit edilmiştir; kullanılan malzemenin yanıcılık sınıfı ve tavan içi tesisat yalıtımı kontrol edilmelidir.",
  );

  static final tavanOptionD = ChoiceResult(
    label: "15-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Tavan yapısı hakkında bilgi yok.",
  );

  static final tavanMalzemeOptionA = ChoiceResult(
    label: "15-3-ALT-A",
    uiTitle: "Alçıpanel, metal vb. yanmaz malzeme.",
    uiSubtitle: "A1, A2 sınıfı malzemeler.",
    reportText:
        "✅ OLUMLU: Asma tavan malzemesinin yangına tepki sınıfı A1 veya A2 sınıfıdır. Yönetmelikçe sınıf bakımından yeterli olsa da malzemelerin yangına tepki test raporlarının kontrol edilmesi önerilir.",
  );

  static final tavanMalzemeOptionB = ChoiceResult(
    label: "15-3-ALT-B",
    uiTitle: "Ahşap, plastik, lambiri vb. yanıcı malzeme.",
    uiSubtitle: "Kolay alevlenici dekoratif malzemeler.",
    reportText:
        "☢️ KRİTİK RİSK: Tavan malzemeleri kuvvetle muhtemel yanıcıdır. Asma tavan malzemelerinin yangına tepki test raporları kontrol edildikten sonra Yönetmelik şartlarını karşılayıp karşılamaadığına karar verilir.",
  );

  static final tavanMalzemeOptionC = ChoiceResult(
    label: "15-3-ALT-C",
    uiTitle: "Malzemeyi bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Asma tavan malzemesinin yanıcılığı bilinmiyor. Asma tavan malzemelerinin yangına tepki test raporları kontrol edildikten sonra Yönetmelik şartlarını karşılayıp karşılamadığına karar verilir.",
  );

  static final tesisatOptionA = ChoiceResult(
    label: "15-4-A",
    uiTitle: "Beton, harç veya yangına dayanıklı mastik vb. ile kapatılmış.",
    uiSubtitle: "Sızdırmazlık sağlanmıştır.",
    reportText:
        "✅ OLUMLU: Tesisat geçişleri yalıtılmıştır. Binadaki özellikle yangın kompartımanları, döşeme ve şaftlardaki tesisat geçişleri ve kullanılan malzemelerin akredite test raporları veya onay dokümanları kontrol edilerek uygunluklarına karar verilir. ",
  );

  static final tesisatOptionB = ChoiceResult(
    label: "15-4-B",
    uiTitle:
        "Geçişlerde boşluklar var veya yanıcı (sarı) poliüretan köpük vb. malzeme ile kapatılmış.",
    uiSubtitle: "Duman geçişine açık noktalar.",
    reportText:
        "⚠️ UYARI: Tesisat geçişlerinde boşluklar yangına dayanıklı olmayan malzemelerle kapatma yapılmış olabilir. Döşeme, şaft, yangın kompartımanı gibi mahallerde ve geçişlerde bu durum uygunsuzluk yaratır.",
  );

  static final tesisatOptionC = ChoiceResult(
    label: "15-4-C",
    uiTitle: "Karma (Bazı tesisat geçişleri yalıtımlı, bazıları yalıtımsız)",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Tesisat geçişlerinin bir kısmında sızdırmazlık sağlanmamıştır; katlar arası duman ve alev yayılımı riski bulunmaktadır. Binadaki özellikle yangın kompartımanları, döşeme ve şaftlardaki tesisat geçişleri ve kullanılan malzemelerin akredite test raporları veya onay dokümanları kontrol edilerek uygunluklarına karar verilir.",
  );

  static final tesisatOptionD = ChoiceResult(
    label: "15-4-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Tesisat geçişleri kapalı durumda.",
    reportText:
        "❓ BİLİNMİYOR: Tesisat şaft yalıtımı bilinmiyor. Binadaki özellikle yangın kompartımanları, döşeme ve şaftlardaki tesisat geçişleri ve kullanılan malzemelerin akredite test raporları veya onay dokümanları kontrol edilerek uygunluklarına karar verilir.",
  );
}

class Bolum16Content {
  static final mantolamaOptionA = ChoiceResult(
    label: "16-1-A (Mantolama)",
    uiTitle: "Klasik Mantolama (EPS, XPS vb.).",
    uiSubtitle:
        "Dış cephede sıva altında köpük esaslı ısı yalıtım levhaları kullanılmıştır.",
    reportText:
        "⚠️ UYARI: Dış cephede yanıcı özellikli (EPS, XPS vb.) ısı yalıtım levhaları kullanılmıştır. 28.50m üzerindeki binalarda bu uygulama yasaktır. Daha alçak binalarda ise pencerelerin etrafında ve zemin seviyesinde taşyünü yangın bariyerleri bulunması zorunludur.",
  );

  static final mantolamaOptionB = ChoiceResult(
    label: "16-1-B (Mantolama)",
    uiTitle: "A1 veya A2 sınıf taşyünü ile mantolama.",
    uiSubtitle: "Dış cephede yanmaz özellikli taşyünü levhalar kullanılmıştır.",
    reportText:
        "✅ OLUMLU: Dış cephe yalıtımında yanmaz (A1 veya A2 sınıfı) taşyünü malzeme kullanılmıştır. Bu tercih, cephe yangınlarının yayılmasını engelleyebilir. Cephe sisteminin veya malzemelerinin yangına tepki test raporları incelendikten sonra yönetmeliğe göre uygunluk kontrolü yapılmış olur.",
  );

  static final giydirmeOptionC = ChoiceResult(
    label: "16-1-C (Giydirme)",
    uiTitle: "Giydirme cephe (Cam, kompozit vb.).",
    uiSubtitle:
        "Bina dış yüzeyi alüminyum, cam veya kompozit panellerle kaplanmıştır.",
    reportText:
        "⚠️ UYARI: Binada giydirme cephe sistemi mevcuttur. Cephe ile döşeme arasındaki boşlukların yalıtım durumu yangın sıçrama riski açısından kritiktir. Cephe sisteminin yangına tepki test raporları incelenmelidir.",
  );

  static final mantolamaOptionD = ChoiceResult(
    label: "16-1-D (Sıva/Boya)",
    uiTitle: "Cephede sadece sıva ve boya var (yalıtım yok).",
    uiSubtitle: "Dış cephede herhangi bir ısı yalıtım katmanı bulunmamaktadır.",
    reportText:
        "✅ OLUMLU: Dış cephede yanıcı bir yalıtım malzemesi bulunmamaktadır. Yangın yükü oluşturmaz.",
  );

  static final mantolamaOptionE = ChoiceResult(
    label: "16-1-E (Bilinmiyor)",
    uiTitle: "Cephe malzemesini bilmiyorum.",
    uiSubtitle:
        "Dış cephedeki malzemenin cinsi veya yanıcılık sınıfı hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Dış cephe malzemesi bilinmiyor. Yüksek binalarda yanıcı malzeme kullanımı hayati risk taşır. Malzemelerin test raporları sorgulanmalıdır.",
  );

  static final sagirYuzeyOptionA = ChoiceResult(
    label: "16-2-A (Sağır Yüzey)",
    uiTitle:
        "Cephede en az 100 cm yüksekliğinde yangın dayanımlı yüzey (veya sistem) var.",
    uiSubtitle: " ",
    reportText:
        "✅ OLUMLU: Katlar arasındaki yangın dayanıklı yüzey (veya sistem) yüksekliği 100 cm şartını sağlamaktadır. Bu mesafe, alevin bir kattan diğerine sıçramasını zorlaştırır. Yönetmelik şartlarını sağlayıp sağlamadığına yanmaz yüzeyin yerinde kontrol edilmesi ile karar verilir.",
  );

  static final sagirYuzeyOptionB = ChoiceResult(
    label: "16-2-B (Sağır Yüzey)",
    uiTitle:
        "Cephede en az 100 cm yüksekliğinde yangın dayanımlı yüzey (veya sistem) yok.",
    uiSubtitle:
        "Pencereler birbirine çok yakın, aradaki duvar mesafesi 1 metreden az.",
    reportText:
        "☢️ KRİTİK RİSK: Katlar arasındaki yangına dayanıklı yüzey yüksekliği 100 cm'den azdır. Yangın bir kattan diğerine kolayca sıçrayabilir.",
  );

  static final sagirYuzeyOptionC = ChoiceResult(
    label: "16-2-C (Sağır Yüzey)",
    uiTitle: "Bu detay hakkında hiç fikrim yok.",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Katlar arasındaki yangına dayanıklı yüzey yüksekliği bilinmiyor. 100 cm'den az ise yangın dikeyde hızla yayılabilir.",
  );

  static final bitisikOptionA = ChoiceResult(
    label: "16-3-A (Bitişik)",
    uiTitle: "Hayır, aynı yükseklikteyiz veya daha alçaktayız.",
    uiSubtitle:
        "Yan bina ile çatı seviyemiz aynı veya bizim binamız daha alçakta.",
    reportText:
        "✅ OLUMLU: Binalar aynı hizada olduğu için yan binadan cepheye yangın sıçrama riski düşüktür.",
  );

  static final bitisikOptionB = ChoiceResult(
    label: "16-3-B (Bitişik)",
    uiTitle: "Evet, bizim bina daha yüksek.",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Yan binanın çatısının bittiği hizaya denk gelen dış cephe kaplamanız 'Hiç Yanmaz' (A1 sınıfı) malzeme olmalıdır.",
  );

  static final bitisikOptionC = ChoiceResult(
    label: "16-3-C (Bitişik)",
    uiTitle: "Yükseklik durumunu bilmiyorum.",
    uiSubtitle: "Yan bina ile olan yükseklik ilişkimizi tam olarak bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Bitişik bina ile yükseklik durumu bilinmiyor. Eğer yan binadan yüksekseniz, o bölgedeki cephe malzemesinin yangına tepki sınıfı kritik öneme sahiptir.",
  );
}

class Bolum17Content {
  static final kaplamaOptionA = ChoiceResult(
    label: "17-1-A (Kaplama)",
    uiTitle: "Kiremit, metal kenet, beton, taş türünde yanmaz malzeme.",
    uiSubtitle: "Çatı yüzeyi yanmaz malzemeyle kaplanmıştır.",
    reportText:
        "✅ OLUMLU: Çatı kaplamasında hiç yanmaz (A1 sınıfı) malzeme kullanılmıştır. Bu durum, dışarıdan gelebilecek kıvılcımlara karşı koruma sağlar.",
  );

  static final kaplamaOptionB = ChoiceResult(
    label: "17-1-B (Kaplama)",
    uiTitle: "Shingle, Onduline veya Membran.",
    uiSubtitle:
        "Çatı yüzeyinde petrol türevi (bitümlü) örtüler kullanılmıştır.",
    reportText:
        "⚠️ UYARI: Çatıda kullanılan bitümlü örtüler (Shingle/Membran) yanıcı özellik gösterebilir. Bu malzemelerin 'BROOF' özellikli (dış yangına karşı dayanıklı) olması gerekmektedir. Ürünün test raporu incelenmelidr.",
  );

  static final kaplamaOptionC = ChoiceResult(
    label: "17-1-C (Kaplama)",
    uiTitle: "Sandviç Panel (Yanıcı)",
    uiSubtitle:
        "İçi XPS, EPS, PIR, PUR, poliüretan vb. malzeme dolgulu sandviç paneller ile kaplanmıştır.",
    reportText:
        "⚠️ UYARI: Yanıcı malzeme dolgulu sandviç paneller yangını çok hızlı yayar ve söndürülmesi zordur. Taşyünü dolgulu paneller tercih edilmesi önerilir. Sandviç panellerin yangına tepki test raporları Uzman tarafından kontrol edilmesinin ardından uygunluğuna karar verilir.",
  );

  static final kaplamaOptionD = ChoiceResult(
    label: "17-1-D (Kaplama)",
    uiTitle: "Sandviç Panel (Yanmaz)",
    uiSubtitle:
        "İçi taşyünü, cam yünü, mineral yünü vb. malzeme dolgulu sandviç paneller ile kaplanmıştır.",
    reportText:
        "✅ OLUMLU: Taşyünü vb. A1, A2 sınıf malzeme dolgulu sandviç paneller Yönetmelik açısından daha uygun bulunur.",
  );

  static final kaplamaOptionE = ChoiceResult(
    label: "17-1-E (Kaplama)",
    uiTitle: "Ahşap kaplama.",
    uiSubtitle: "Çatı yüzeyi tamamen ahşap malzeme ile kaplanmıştır.",
    reportText:
        "☢️ KRİTİK RİSK: Çatı kaplamasında ahşap kullanılması yüksek yangın riski oluşturur. Kıvılcım sıçraması durumunda çatı hızla tutuşabilir.",
  );

  static final kaplamaOptionF = ChoiceResult(
    label: "17-1-F (Kaplama)",
    uiTitle: "Çatı hakkında bilgim yok.",
    uiSubtitle: "Çatının en üstünde ne olduğunu göremiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Çatı kaplama malzemesi bilinmiyor. Yanıcı bir malzeme (shingle, plastik vb.) kullanıldıysa tüm bina risk altındadır. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final iskeletOptionA = ChoiceResult(
    label: "17-2-A (İskelet)",
    uiTitle:
        "Taşıyıcılar beton veya çeliktir. Isı yalıtımda ise taşyünü vb. yanmaz ürün kullanılmıştır.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Çatı taşıyıcı sisteminin ve yalıtımının yanmaz malzemeden olması yangın güvenliği için en ideal durumdur.",
  );

  static final iskeletOptionB = ChoiceResult(
    label: "17-2-B (İskelet)",
    uiTitle: "Taşıyıcılar ve altındaki ısı yalıtım malzemesi yanıcı ürünlerdir.",
    uiSubtitle: "Ahşap, XPS, EPS vb. malzemeler.",
    reportText:
        "(Yüksek Bina İse) ☢️ KRİTİK RİSK: Yüksek binalarda ahşap çatı kullanılması yasaktır.<br>(Alçak Bina İse) ⚠️ UYARI: Ahşap çatılarda yanıcı köpük vb. kullanımı risklidir.",
  );

  static final iskeletOptionC = ChoiceResult(
    label: "17-2-C (İskelet)",
    uiTitle: "Çatı iskeletinin ve yalıtımının durumunu bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Çatı iskeletinin durumu bilinmiyor. Yüksek binalarda ahşap çatı büyük risk taşır. Uzman Görüşü alınması tavsiye edilir.",
  );

  static final bitisikOptionA = ChoiceResult(
    label: "17-3-A (Bitişik)",
    uiTitle:
        "İki binanın çatıları arasında en az 60 cm yüksekliğinde yangın dayanımlı duvar var.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Yangın duvarı mevcuttur. Komşu binadan çatı yoluyla yangın geçişi engellenmiştir.",
  );

  static final bitisikOptionB = ChoiceResult(
    label: "17-3-B (Bitişik)",
    uiTitle: "Çatılar arasında yangın dayanımlı duvarı yok.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: Bitişik nizam binalarda, çatılar arasında yangın geçişini engelleyecek, çatı seviyesinden en az 60 cm yükseltilmiş 'Yangın Duvarı' olması zorunludur.",
  );

  static final bitisikOptionC = ChoiceResult(
    label: "17-3-C (Bitişik)",
    uiTitle: "Çatı birleşim yerlerini göremiyorum, bir fikrim yok.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Komşu bina ile çatı birleşim detayı bilinmiyor. Binanıza yangın sıçrama riski olabilir.",
  );

  static final isiklikOptionA = ChoiceResult(
    label: "17-4-A (Işıklık)",
    uiTitle: "Hayır, ışıklık yok.",
    uiSubtitle: "Çatıda cam veya plastik aydınlatma açıklığı bulunmuyor.",
    reportText:
        "✅ OLUMLU: Çatıda ışıklık olmaması, yangın güvenliği açısından riski azaltır.",
  );

  static final isiklikOptionB = ChoiceResult(
    label: "17-4-B (Işıklık)",
    uiTitle: "Evet, ışıklık var.",
    uiSubtitle: "Çatıda aydınlatma feneri veya kubbesi mevcut.",
    reportText:
        "(Alt soruya göre belirlenir)<br>Cam: ✅ OLUMLU: Temperli cam ışıklıklar yeterli olabilir<br>Plastik: ⚠️ UYARI: Çatı ışıklıklarında kullanılan plastik malzemeler yangında eriyip aşağıya damlayarak yangını içeri taşıyabilir.",
  );
  static final isiklikOptionC = ChoiceResult(
    label: "17-4-C (Işıklık)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Çatıdaki açıklıkların yapısı belirsiz.",
    reportText:
        "❓ BİLİNMİYOR: Çatı ışıklık durumu bilinmiyor. Işıklık varsa ve plastikse yangın riski oluşturabilir. Uzman kontrolü önerilir.",
  );
}

class Bolum18Content {
  static final duvarOptionA = ChoiceResult(
    label: "18-1-A (Duvar)",
    uiTitle: "Hayır, sadece sıva ve boya.",
    uiSubtitle: "Duvarlarda ekstra bir kaplama malzemesi yoktur.",
    reportText: "✅ OLUMLU: Duvar yüzeylerinde yanıcı kaplama bulunmamaktadır.",
  );

  static final duvarOptionB = ChoiceResult(
    label: "18-1-B (Duvar)",
    uiTitle: "Evet, ahşap, plastik, köpük var.",
    uiSubtitle:
        "Duvarlarda lambiri, plastik panel veya strafor süslemeler var.",
    reportText:
        "⚠️ UYARI: (Yüksek Bina İse) Yüksek binalarda duvar kaplamaları ‘en az zor alevlenici’ sınıfta olmalıdır. Ahşap, plastik veya köpük gibi malzemeler yangını koridor boyunca hızla yayar.<br>(Alçak Bina İse) Duvarlarda kullanılan köpük veya plastik malzemeler 'En Az Normal Alevlenici' sınıfta olmalıdır. Kolay tutuşan malzemeler yangın yükünü artırır.",
  );

  static final duvarOptionC = ChoiceResult(
    label: "18-1-C (Duvar)",
    uiTitle: "Evet, duvar kağıdı var.",
    uiSubtitle: "Duvarlarda standart duvar kağıdı kullanılmıştır.",
    reportText:
        "⚠️ UYARI:Standart duvar kağıtları genelde kabul edilir, ancak 'Kolay Alevlenen' türde olmamalıdır.",
  );

  static final duvarOptionD = ChoiceResult(
    label: "18-1-D (Duvar)",
    uiTitle: "Kaplama malzemesini bilmiyorum.",
    uiSubtitle: "Duvar yüzeyindeki malzemenin cinsini bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Duvar kaplama malzemesi bilinmiyor. 21.50m üzeri binalarda yanıcı kaplama malzemesi kullanımı büyük risk taşır.",
  );

  static final boruOptionA = ChoiceResult(
    label: "18-2-A (Boru)",
    uiTitle: "Demir, döküm boru kullanılmıştır",
    uiSubtitle:
        "Kalın etli, mineral katkılı veya metal borular kullanılmıştır.",
    reportText:
        "✅ OLUMLU: Tesisat şaftlarında zor yanıcı (sessiz boru) veya yanmaz (döküm) borular kullanılmıştır.",
  );

  static final boruOptionB = ChoiceResult(
    label: "18-2-B (Boru)",
    uiTitle: "Plastik boru ve yangın dayanımlı kelepçe kullanılmıştır.",
    uiSubtitle: "Plastik boruların döşeme geçişlerinde kelepçe var.",
    reportText:
        "✅ OLUMLU: Plastik boruların kat geçişlerinde yangın dayanımlı kelepçe kullanılarak alev geçişi engellenmiştir.",
  );

  static final boruOptionC = ChoiceResult(
    label: "18-2-C (Boru)",
    uiTitle:
        "Plastik boru kullanılmış ancak yangın dayanımlı kelepçe kullanılmamıştır.",
    uiSubtitle: "Plastik boruların döşeme geçişlerinde kelepçe yok.",
    reportText:
        "⚠️ UYARI: 21.50m ve üzeri binalarda standart plastik borular yangın anında eriyerek yok olur ve döşemede delik açılır. Bu delikten alevler üst kata geçer. Yangın Kelepçesi ZORUNLUDUR.",
  );

  static final boruOptionD = ChoiceResult(
    label: "18-2-D (Boru)",
    uiTitle: "Tesisat geçişlerini göremiyorum.",
    uiSubtitle: "Şaftlar kapalı olduğu için boru cinsini bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Tesisat borularının yangın dayanımı veya malzeme özellikleri bilinmiyor. Yüksek binalarda plastik boruların kat geçişlerinde (döşemelerinde) yangın kesici (kelepçe) olup olmadığı hayati önem taşır.",
  );
}

class Bolum19Content {
  static final engelOptionA = ChoiceResult(
    label: "19-1-A",
    uiTitle: "Herhangi bir engel yok, yol tamamen açık.",
    uiSubtitle: "Tahliye yolu mevzuata uygun.",
    reportText:
        "✅ OLUMLU: Kaçış yollarında tahliyeyi engelleyici unsur bulunmamaktadır.",
  );

  static final engelOptionB = ChoiceResult(
    label: "19-1-B",
    uiTitle: "Eşya, bisiklet, saksı vb. malzemeler var.",
    uiSubtitle: "Yol genişliği daralmış.",
    reportText:
        "⚠️ UYARI: Kaçış yollarında eşya ve malzeme istifi tespit edilmiştir.",
  );

  static final engelOptionC = ChoiceResult(
    label: "19-1-C",
    uiTitle: "Kilitli kapı veya geçişi zorlaştıran bariyer var.",
    uiSubtitle: "Acil çıkış engellenmiş.",
    reportText:
        "☢️ KRİTİK RİSK: Kaçış yolunda kilitli kapı veya fiziksel engel mevcuttur.",
  );

  static final engelOptionD = ChoiceResult(
    label: "19-1-D",
    uiTitle: "Eşik, basamak veya kaygan zemin var.",
    uiSubtitle: "Düşme ve takılma riski.",
    reportText:
        "⚠️ UYARI: Kaçış yolu zemininde takılma veya kayma riski tespit edilmiştir.",
  );

  static final levhaOptionA = ChoiceResult(
    label: "19-2-A",
    uiTitle:
        "Evet, tüm çıkışlarda ledli, ışıklı acil yönlendirme işaretleri var.",
    uiSubtitle: "Yeterince yönlendirme var.",
    reportText: "✅ OLUMLU: Acil durum yönlendirme işaretleri mevcuttur.",
  );

  static final levhaOptionB = ChoiceResult(
    label: "19-2-B",
    uiTitle: "Hayır, hiçbir yerde yönlendirme levhası yok.",
    uiSubtitle: "Karanlıkta veya dumanlı ortamda çıkış bulunması güçtür.",
    reportText:
        "☢️ KIRMIZI RİSK: Binada acil durum yönlendirme işaretleri bulunmamaktadır.",
  );

  static final levhaOptionC = ChoiceResult(
    label: "19-2-C",
    uiTitle:
        "Yönlendirmeler var ama çalışmıyorlar, bozuk veya pilleri bitik olabilir.",
    uiSubtitle: " ",
    reportText:
        "⚠️ UYARI: Yönlendirme işaretlemeleri mevcut ancak çalışır durumda değildir. Acil durumda bu işaretlerin çalışır durumda olması büyük önem taşır.",
  );

  static final yanilticiOptionA = ChoiceResult(
    label: "19-3-A",
    uiTitle: "Hayır, yanıltıcı kapı yok, çıkış kapısını kolayca bulabilirim.",
    uiSubtitle: "Tüm kapılar amacına uygun.",
    reportText:
        "✅ OLUMLU: Kaçış yollarında kullanıcıyı yanıltacak kapı bulunmamaktadır.",
  );

  static final yanilticiOptionB = ChoiceResult(
    label: "19-3-B",
    uiTitle:
        "Evet, yanıltıcı kapı var, çıkış kapısını bulmakta güçlük çekebilirim.",
    uiSubtitle: "Depo/Elektrik odası kapıları merdiven kapısına benziyor.",
    reportText:
        "⚠️ UYARI: Kaçış yollarında yangın merdiveni ile karıştırılabilecek yanıltıcı kapılar mevcuttur.",
  );

  static final etiketOptionA = ChoiceResult(
    label: "19-3-ALT-A",
    uiTitle: "Evet, 'ÇIKIŞ DEĞİLDİR' veya mahalin adı yazıyor.",
    uiSubtitle: "İşaretleme yapılmış.",
    reportText:
        "✅ OLUMLU: Yanıltıcı kapılar üzerinde gerekli uyarı levhaları mevcuttur.",
  );

  static final etiketOptionB = ChoiceResult(
    label: "19-3-ALT-B",
    uiTitle: "Hayır, herhangi bir yazı veya levha yok.",
    uiSubtitle: " ",
    reportText:
        "⚠️ UYARI:  Yanıltıcı kapılar üzerinde uyarı levhası bulunmamaktadır.",
  );

  static final etiketOptionC = ChoiceResult(
    label: "19-3-ALT-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Konu hakkında bilgim yok.",
    reportText:
        "❓ BİLİNMİYOR: Yanıltıcı kapıların işaretleme durumu tespit edilememiştir.",
  );
}

class Bolum20Content {
  static final tekKatOptionA = ChoiceResult(
    label: "20-A (Tek Kat)",
    uiTitle: "Düz ayak, engelsiz çıkabiliyor.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Tek katlı binada düz ayak, engelsiz çıkış imkanı mevcuttur.",
  );

  static final cokKatOption1 = ChoiceResult(
    label: "20-1 (Çok Kat)",
    uiTitle: "Normal Apartman Merdiveni (Kapısız).",
    uiSubtitle:
        "Binanın ana sirkülasyon merdivenidir. Bu merdiven üzerinde yangın kapıları bulunmaz.",
    reportText: "(Sayısal veri olarak saklanır)",
  );

  static final cokKatOption2 = ChoiceResult(
    label: "20-2 (Çok Kat)",
    uiTitle: "Bina İçi 'Kapalı' Yangın Merdiveni (Kapılı).",
    uiSubtitle: "Betonarme, duvarla çevrili, yangın kapısı bulunan merdiven.",
    reportText: "(Sayısal veri olarak saklanır)",
  );

  static final cokKatOption3 = ChoiceResult(
    label: "20-3 (Çok Kat)",
    uiTitle: "Bina Dışı 'Kapalı' Yangın Merdiveni (Kapılı).",
    uiSubtitle:
        "Çelik, yangın dayanımlı alçıpanel vb. duvarla çevrili, yangın kapısı olan merdiven",
    reportText: "(Sayısal veri olarak saklanır)",
  );

  static final cokKatOption4 = ChoiceResult(
    label: "20-4 (Çok Kat)",
    uiTitle: "Bina Dışı 'Açık' Çelik Merdiven (Kapılı).",
    uiSubtitle:
        "Çelik, genelde kollu-Z tipi merdiven, duvarsız ancak üzerinde yangın kapıları olan merdiven",
    reportText: "(Sayısal veri olarak saklanır)",
  );

  static final cokKatOption5 = ChoiceResult(
    label: "20-5 (Çok Kat)",
    uiTitle: "Dairesel (Spiral, Döner) Merdiven.",
    uiSubtitle: "Yuvarlak, dönerek inilen çelik merdiven.",
    reportText: "(Sayısal veri olarak saklanır)",
  );

  static final cokKatOption6 = ChoiceResult(
    label: "20-6 (Çok Kat)",
    uiTitle: "Sahanlıksız (Dairesel) Merdiven.",
    uiSubtitle:
        "Basamak adedi 17'yi aşan ancak buna rağmen sahanlığı olmayan merdiven.",
    reportText: "(Sayısal veri olarak saklanır)",
  );

  static final basYghOptionA = ChoiceResult(
    label: "20-BAS-A",
    uiTitle: "Evet, var.",
    uiSubtitle:
        "Merdiven kovasında pozitif basınç sağlayan fan sistemi mevcut.",
    reportText:
        "✅ OLUMLU: Kapalı yangın merdivenlerinde basınçlandırma sistemi olduğu beyan edilmiştir.",
  );

  static final basYghOptionB = ChoiceResult(
    label: "20-BAS-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Herhangi bir mekanik basınçlandırma sistemi bulunmuyor.",
    reportText:
        "⚠️ UYARI: Kapalı yangın merdivenlerinde basınçlandırma sistemi bulunmamaktadır. Yönetmeliğe göre binadaki yangın merdiveninde basınçlandırma sistemi ihtiyacı yoksa uygundur, ihtiyaç varsa durum, mimari proje üzerinden veya sahada Uzman tarafından değerlendirilmelidir.",
  );

  static final basYghOptionC = ChoiceResult(
    label: "20-BAS-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Sistemin varlığı hakkında bilgi sahibi değilim.",
    reportText: "❓ BİLİNMİYOR: Merdiven basınçlandırma durumu belirsizdir.",
  );

  static final bodrumOptionA = ChoiceResult(
    label: "20-Bodrum-A",
    uiTitle: "Evet, aynı merdiven devam ediyor.",
    uiSubtitle: "Üst kat merdiveni bodruma da iniyor.",
    reportText: "(Bodrum çıkış sayısı hesabında kullanılır)",
  );

  static final bodrumOptionB = ChoiceResult(
    label: "20-Bodrum-B",
    uiTitle: "Hayır, bodrum inen merdiven farklı bir yerde.",
    uiSubtitle: "Bodruma inen merdiven ayrı bir konumda.",
    reportText: "(Bodrum çıkış sayısı hesabında kullanılır)",
  );

  static final rampaOptionB = ChoiceResult(
    label: "20-B (Tek Kat)",
    uiTitle: "Evet",
    uiSubtitle: "Eğimli yol ile çıkış sağlanıyor.",
    reportText:
        "(Rampa modülünde detaylandırılacak) Rampa ile çıkış sağlanmaktadır.",
  );

  static final rampaOptionC = ChoiceResult(
    label: "20-C (Tek Kat)",
    uiTitle: "Hayır",
    uiSubtitle: "Birkaç basamak inilerek/çıkılarak ulaşılıyor.",
    reportText: "(Merdiven sayısı not edilir) Çıkışta basamak mevcuttur.",
  );
}

class Bolum21Content {
  static final varlikOptionA = ChoiceResult(
    label: "21-1-A",
    uiTitle: "Evet, var.",
    uiSubtitle: "Giriş-çıkış kapıları olan odacık mevcut.",
    reportText:
        "✅ OLUMLU: Merdivenin önünde Yangın Güvenlik Holü (YGH) mevcuttur.",
  );

  static final varlikOptionB = ChoiceResult(
    label: "21-1-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Holden geçmeden direkt merdivene çıkılıyor.",
    reportText: "ℹ️ BİLGİ: Binada YGH bulunmamaktadır.",
    adviceText:
        "Bu raporda YGH zorunluluğu belirtildiyse ve binada YGH oluşturulamıyorsa, Madde 89 uyarınca kaçış merdiveni yuvasının basınçlandırılması alternatif bir güvenlik önlemi olarak değerlendirilebilir. Kesin değerlendirme için Yangın Güvenlik Uzmanı 'ndan bilgi alınmalıdır..",
  );

  static final malzemeOptionA = ChoiceResult(
    label: "21-2-A",
    uiTitle: "Sıva, boya, beton, mermer vb.",
    uiSubtitle: "Hol içinde yanmaz malzemeler kullanılmış.",
    reportText: "✅ OLUMLU: YGH içindeki kaplamalar yanmaz özelliktedir.",
  );

  static final malzemeOptionB = ChoiceResult(
    label: "21-2-B",
    uiTitle: "Ahşap, duvar kağıdı, plastik.",
    uiSubtitle: "Hol içinde yanıcı kaplama veya dekorasyon var.",
    reportText:
        "☢️ KRİTİK RİSK: Yangın güvenlik holleri kaçış yolunun bir parçasıdır. Duvar, tavan ve tabanında hiçbir yanıcı malzeme kullanılamaz.",
    adviceText:
        "Hol içindeki yanıcı kaplamaların sökülerek A1 sınıfı (yanmaz) malzemeler(sıva, seramik vb.) ile yenilenmesi gerekmektedir.",
  );

  static final malzemeOptionC = ChoiceResult(
    label: "21-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Malzemenin cinsini bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Holdeki malzemelerin yanıcılık özellikleri bilinmiyor. Kaçış yollarında yanıcı malzeme kullanımı risk teşkil eder.",
  );

  static final kapiOptionA = ChoiceResult(
    label: "21-3-A",
    uiTitle:
        "YGH kapıları yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanan özelliktedir.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: YGH kapıları uygun gözükmektedir.",
  );

  static final kapiOptionB = ChoiceResult(
    label: "21-3-B",
    uiTitle: "YGH kapıları yangına dayanıklı değil.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: YGH kapıları en az 90 dakika yangına dayanıklı ve duman sızdırmaz özellikte olmalıdır.",
    adviceText:
        "Mevcut kapıların akredite yangın dayanım test raporuna sahip, hidrolik kapatıcılı veya yaylı menteşeli (kendiliğinden kapanan) 'Yangın Kapıları' ile değiştirilmesi hayati önem taşır.",
  );

  static final kapiOptionC = ChoiceResult(
    label: "21-3-C",
    uiTitle: "YGH kapıları hakkında fikrim yok.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: kapıların yangın dayanımı bilinmiyor. YGH kapıları en az 90 dakika yangına dayanıklı olmalıdır.",
  );

  static final esyaOptionA = ChoiceResult(
    label: "21-4-A",
    uiTitle: "Hayır, tamamen boş.",
    uiSubtitle: "Hol içinde hiçbir eşya yok.",
    reportText: "✅ OLUMLU: YGH içi temiz ve boş olduğundan güvenli sayılır.",
  );
  static final esyaOptionB = ChoiceResult(
    label: "21-4-B",
    uiTitle: "Evet, eşya var.",
    uiSubtitle: "Bisiklet, ayakkabılık, dolap vb.",
    reportText:
        "☢️ KRİTİK RİSK: Yangın güvenlik hollerinde kaçışı engelleyecek hiçbir eşya bulundurulamaz.",
    adviceText:
        "YGH alanındaki tüm eşyaların derhal tahliye edilmesi ve bu alanın 'Sıfır Yanıcı Yük' prensibiyle boş tutulması gerekmektedir.",
  );

  static final esyaOptionC = ChoiceResult(
    label: "21-4-C",
    uiTitle: "Bazen konuluyor.",
    uiSubtitle: "Geçici depolama yapılıyor.",
    reportText:
        "☢️ KRİTİK RİSK: YGH alanları depo olarak kullanılamaz, her an boş tutulmalıdır.",
  );
}

class Bolum22Content {
  static final varlikOptionA = ChoiceResult(
    label: "22-1-A",
    uiTitle:
        "Hayır, itfaiye asansörü yok, sadece normal (insan taşıma) asansör var.",
    uiSubtitle: "",
    reportText:
        "ℹ️ BİLGİ:Binada itfaiye asansörü bulunmamaktadır. Yönetmelik gereği yapı yüksekliği 51.50 metreyi geçen binalarda yangın anında itfaiyenin kullanabileceği, jeneratöre bağlı ve korunumlu İtfaiye Asansörü tesisi mecburidir.",
  );

  static final varlikOptionB = ChoiceResult(
    label: "22-1-B",
    uiTitle: "Evet, itfaiye asansörü var.",
    uiSubtitle: "Bazı binalarda yük asansörü olarak da isimlendirilir.",
    reportText: "ℹ️ BİLGİ: Binada itfaiye asansörü mevcuttur.",
  );

  static final varlikOptionC = ChoiceResult(
    label: "22-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Binada itfaiye asansörü varlığı teyit edilememiştir. Yapı yüksekliği 51.50 metreyi geçen binalarda bu donanım zorunludur.",
  );

  static final konumOptionA = ChoiceResult(
    label: "22-2-A",
    uiTitle: "Doğrudan koridora veya lobiye açılıyor.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: İtfaiye asansörü doğrudan koridora açılmaktadır. Dumanın kuyuya girmemesi için asansörün bir yangın güvenlik holüne açılması teknik bir zorunluluktur.",
  );

  static final konumOptionB = ChoiceResult(
    label: "22-2-B",
    uiTitle: "Bir Yangın Güvenlik Holü'ne (YGH'ye) açılıyor.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: İtfaiye asansörü Yangın Güvenlik Holü'ne açılmaktadır.",
  );

  static final konumOptionC = ChoiceResult(
    label: "22-2-C",
    uiTitle: "Kapının nereye açıldığını bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: İtfaiye asansörünün açıldığı mahal belirsizdir. Güvenli tahliye ve müdahale için asansörün yangın güvenlik holüne açılması şarttır.",
  );

  static final boyutOptionA = ChoiceResult(
    label: "22-3-A",
    uiTitle: "Küçük (6 m²'den az).",
    uiSubtitle: "Hol alanı dar.",
    reportText:
        "☢️ KRİTİK RİSK: İtfaiye asansörü önündeki YGH alanı 6 m²'den azdır. Sedye ve itfaiye ekibinin sığması için bu alanın en az 6 m² olması gerekmektedir.",
  );

  static final boyutOptionB = ChoiceResult(
    label: "22-3-B",
    uiTitle: "Standart (6-10 m² arası).",
    uiSubtitle: "Hol alanı yeterli genişlikte.",
    reportText:
        "✅ OLUMLU: İtfaiye asansörü önündeki YGH alanı yeterli büyüklüktedir.",
  );

  static final boyutOptionC = ChoiceResult(
    label: "22-3-C",
    uiTitle: "Büyük (10 m²'den fazla).",
    uiSubtitle: "Hol alanı fazla geniş.",
    reportText:
        "⚠️UYARI: İtfaiye asansörü önündeki YGH alanı 10 m²'den büyüktür. Gereksiz büyük holler duman kontrolünü zorlaştırabilir.",
  );

  static final boyutOptionD = ChoiceResult(
    label: "22-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: İtfaiye asansörü önündeki holün boyutları teyit edilememiştir. Alanın 6 ila 10 m² arasında olması idealdir.",
  );

  static final kabinOptionA = ChoiceResult(
    label: "22-4-A",
    uiTitle:
        "Evet, 1,8 m2'den geniş ve 1 dakikada en üst kata hızlıca çıkabiliyor.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: İtfaiye asansörü kabin boyutu ve hızı yönetmelik şartlarını karşılamaktadır.",
  );

  static final kabinOptionB = ChoiceResult(
    label: "22-4-B",
    uiTitle: "Hayır, kabini küçük veya 1 dakikada en üst kata ulaşamıyor.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: İtfaiye asansörü kabini 1.8 m²'den küçük veya hızı yetersizdir. Bu durum acil müdahaleyi geciktirebilir.",
  );

  static final kabinOptionC = ChoiceResult(
    label: "22-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: İtfaiye asansörünün kabin ölçüleri ve hızı bilinmemektedir.",
  );

  static final enerjiOptionA = ChoiceResult(
    label: "22-5-A",
    uiTitle:
        "Evet, asansörlerin hepsi jeneratöre bağlı ve binada elektrik olmasa bile 60 dakika boyunca çalışabilir durumda.",
    uiSubtitle: "Elektrik kesilse bile asansörler çalışabiliyor.",
    reportText:
        "✅ OLUMLU: İtfaiye asansörü acil durum enerji sistemine (jeneratör) bağlıdır.",
  );

  static final enerjiOptionB = ChoiceResult(
    label: "22-5-B",
    uiTitle: "Hayır, jeneratör yok.",
    uiSubtitle: "Elektrik kesilince asansör duruyor.",
    reportText:
        "☢️ KRİTİK RİSK: İtfaiye asansörünün acil durum enerji beslemesi bulunmamaktadır. Yangın anında enerji kesilirse asansör işlevsiz kalacaktır.",
  );

  static final enerjiOptionC = ChoiceResult(
    label: "22-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: İtfaiye asansörünün jeneratör desteği olup olmadığı teyit edilememiştir.",
  );

  static final basincOptionA = ChoiceResult(
    label: "22-6-A",
    uiTitle: "Evet, basınçlandırma sistemi var.",
    uiSubtitle: "Asansör kuyusuna hava üfleyen sistem.",
    reportText:
        "✅ OLUMLU: İtfaiye asansör kuyusu basınçlandırma sistemi ile korunmaktadır.",
  );

  static final basincOptionB = ChoiceResult(
    label: "22-6-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Asansör kuyusuna hava üfleyen yok.",
    reportText:
        "☢️ KRİTİK RİSK: İtfaiye asansör kuyusunda basınçlandırma sistemi bulunmamaktadır. Bu durum kuyuya duman dolma riskini artırır.",
  );

  static final basincOptionC = ChoiceResult(
    label: "22-6-C",
    uiTitle: "Basınçlandırma var mı yok mu bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: İtfaiye asansör kuyusunun basınçlandırma durumu bilinmemektedir.",
  );
}

class Bolum23Content {
  static final bodrumOptionA = ChoiceResult(
    label: "23-1-A (Bodrum)",
    uiTitle: "Normal (insan taşıma) asansör bodrum katlara inmiyor.",
    uiSubtitle: "Asansör sadece zemin ve üst katlar arasında çalışıyor.",
    reportText: "ℹ️Bilgi: Asansör bodrum katlara inmemektedir.",
  );

  static final bodrumOptionB = ChoiceResult(
    label: "23-1-B (Bodrum)",
    uiTitle:
        "Normal asansör bodrum katlara da iniyor ve bodrum katta kapısını korunumlu bir hole açıyor.",
    uiSubtitle: " ",
    reportText:
        "✅ OLUMLU: Asansör bodrum katta yangın güvenlik holüne açılmaktadır.",
  );

  static final bodrumOptionC = ChoiceResult(
    label: "23-1-C (Bodrum)",
    uiTitle:
        "Normal asansör bodrum katlara da iniyor ve holsüz biçimde direkt otoparka, depoya veya ticari alanlara açılıyor.",
    uiSubtitle: "Asansörün bodrum kata çıktığı noktada bir YGH yok.",
    reportText:
        "☢️ KRİTİK RİSK: Asansör kuyuları binanın bacası gibidir. Bodrumdaki otoparkta veya kazan dairesinde çıkacak bir yangının dumanı, direkt asansör kapısından kuyuya girer ve saniyeler içinde tüm üst katlara yayılır.",
  );

  static final bodrumOptionD = ChoiceResult(
    label: "23-1-D (Bodrum)",
    uiTitle: "Bilmiyorum, konu hakkında fikrim yok.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Bodrum katlardaki asansörlerin hemen önünde mutlaka 'Yangın Güvenlik Holü' olmalıdır. Mevcut durum bilinmiyor.",
  );

  static final yanginModuOptionA = ChoiceResult(
    label: "23-2-A (Yangın Modu)",
    uiTitle: "Evet, otomatik olarak kendliğinden iniyor ve kapısını açıyor.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Asansörlerin yangın anında nasıl hareket etmeleri gerektiğine dair senaryo mevcut ve çalışır durumda gözüküyor.",
  );

  static final yanginModuOptionB = ChoiceResult(
    label: "23-2-B (Yangın Modu)",
    uiTitle:
        "Hayır, asansör (normalin dışında) yangın anında herhangi bir aksiyon almıyor.",
    uiSubtitle: "Yangın anında normal çalışmasına devam ediyor.",
    reportText:
        "☢️ KRİTİK RİSK: Asansörlerin yangın anında özel aksiyon alması gereklidir.",
  );

  static final yanginModuOptionC = ChoiceResult(
    label: "23-2-C (Yangın Modu)",
    uiTitle: "Bilmiyorum, fark etmedim.",
    uiSubtitle: " ",
    reportText:
        "❓ BİLİNMİYOR: Asansörün yangın senaryosu bilinmiyor. Yangın anında asansörde mahsur kalmamak için bu özelliğin varlığı hayati önem taşır.",
  );

  static final konumOptionA = ChoiceResult(
    label: "23-3-A (Konum)",
    uiTitle: "Asansör kapıları, koridora veya hole doğru açılıyor.",
    uiSubtitle: " ",
    reportText:
        "✅ OLUMLU: Asansör kapıları kat koridoruna veya holüne doğru açılmaktadır.",
  );

  static final konumOptionB = ChoiceResult(
    label: "23-3-B (Konum)",
    uiTitle: "Doğrudan merdiveninin içine açılıyor.",
    uiSubtitle: " ",
    reportText:
        "☢️ KRİTİK RİSK: Yönetmeliğe göre asansör kapıları ASLA merdiveni yuvasına açılamaz. Asansör kuyusundan sızan duman, insanların kaçtığı temiz bölgeyi (merdiveni) dumanla doldurur.",
  );

  static final konumOptionC = ChoiceResult(
    label: "23-3-C (Konum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapının tam yerini bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Asansör kapısının konumu net değil. Eğer yangın merdiveni içine açılıyorsa, kaçış yolunuz tehlike altındadır.",
  );

  static final levhaOptionA = ChoiceResult(
    label: "23-4-A (Levha)",
    uiTitle: "Evet, her katta levha var.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Asansörlerde gerekli uyarı levhaları mevcuttur.",
  );

  static final levhaOptionB = ChoiceResult(
    label: "23-4-B (Levha)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Uyarı levhası bulunmuyor.",
    reportText:
        "⚠️ UYARI: Panik anında insanlar refleks olarak asansöre yönelebilir. Bu levha, insanları merdivene yönlendirmek için yasal zorunluluktur.",
  );

  static final levhaOptionC = ChoiceResult(
    label: "23-4-C (Levha)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Levha olup olmadığına dikkat etmedim.",
    reportText:
        "❓ BİLİNMİYOR: Uyarı levhalarının varlığı bilinmiyor. Panik anında insanlar refleks olarak asansöre yönelebilir. Bu levha, insanları merdivene yönlendirmek için yasal zorunluluktur.",
  );

  static final havalandirmaOptionA = ChoiceResult(
    label: "23-5-A (Havalandırma)",
    uiTitle: "Evet, kuyuda pencere var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Asansör kuyusunda duman tahliye bacası mevcuttur.",
  );

  static final havalandirmaOptionB = ChoiceResult(
    label: "23-5-B (Havalandırma)",
    uiTitle: "Hayır, kuyu tamamen kapalı.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: Asansör kuyusuna sızan dumanın tahliye edilmesi için en üst noktada 'Duman Tahliye Bacası' (0.1 m²'den az olmamak kaydıyla) zorunludur.",
  );

  static final havalandirmaOptionC = ChoiceResult(
    label: "23-5-C (Havalandırma)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Kuyu havalandırması bilinmiyor. Asansör kuyusuna sızan dumanın tahliye edilmesi için en üst noktada 'Duman Tahliye Bacası' (0.1 m²'den az olmamak kaydıyla) zorunludur.",
  );
}

class Bolum24Content {
  static final tipOptionA = ChoiceResult(
    label: "24-1-A (Tip)",
    uiTitle:
        "Kapalı kat koridordan geçerek (dış) bina kapısına ulaşabiliyorum.",
    uiSubtitle: " ",
    reportText:
        "✅ OLUMLU: Binadan çıkışta dış kaçış geçidi yer almamaktadır, Yönetmeliğe göre bir değerlendirmeye ihtiyaç bulunmaz.",
  );

  static final tipOptionB = ChoiceResult(
    label: "24-1-B (Tip)",
    uiTitle:
        "Bina dışına çıkabilmem için cephede, üstü açık bir geçitten veya yoldan geçmem gerekiyor. ış cephedeki üstü açık bir yoldan geçmek gerekiyor.",
    uiSubtitle: "Bina içerisindeki kapalı kat koridorundan dışarı çıkış yapamıyorum.",
    reportText:
        "⚠️ UYARI: Binadan çıkışta dış kaçış geçidi yer almaktadır. Yönetmeliğe göre bu geçidin ve dış cephedeki tehlikelerin değerlendirilmesi gereklidir.",
  );

  static final tipOptionC = ChoiceResult(
    label: "24-1-C (Tip)",
    uiTitle: "Bilmiyorum / Emin değilim.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Binadan çıkışta dış kaçış geçidi (açık koridor) olup olmadığı tespit edilememiştir. Uzman kontrolü önerilir.",
  );

  static final pencereOptionA = ChoiceResult(
    label: "24-2-A (Pencere)",
    uiTitle: "Hayır, bu yola veya koridora bakan pencere hiç yok.",
    uiSubtitle:
        "Açık kaçış yolu veya koridoru tarafındaki duvar sağır (penceresiz).",
    reportText: "✅ OLUMLU: Açık koridora bakan pencere bulunmamaktadır.",
  );

  static final pencereOptionB = ChoiceResult(
    label: "24-2-B (Pencere)",
    uiTitle: "Evet, pencereler var.",
    uiSubtitle:
        "Açık kaçış yoluna veya koridora bakan daire pencereleri mevcut.",
    reportText:
        "⚠️ UYARI: Dış kaçış geçidine bakan pencereler, yerden en az 1.80 metre yüksekte olmalıdır. Aksi takdirde daireden çıkan alev ve duman, kaçış yolunu kapatır.",
  );

  static final pencereOptionC = ChoiceResult(
    label: "24-2-C (Pencere)",
    uiTitle: "Bilmiyorum / Göremiyorum.",
    uiSubtitle: "Pencere yüksekliği veya varlığı belirsiz.",
    reportText:
        "❓ BİLİNMİYOR: Dış kaçış geçidine bakan pencerelerin varlığı veya yüksekliği bilinmiyor. Bu pencereler yangın anında kaçış yolunu dumanla doldurabilir.",
  );

  static final kapiOptionA = ChoiceResult(
    label: "24-3-A (Kapı)",
    uiTitle:
        "Çelik, yangına dayanıklı, duman sızdırmaz, bırakınca kendiliğinden kapanıyor.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Dış geçide açılan kapı yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanır özelliktedir.",
  );

  static final kapiOptionB = ChoiceResult(
    label: "24-3-B (Kapı)",
    uiTitle: "Dayanıksız, kendiliğinden kapanmıyor.",
    uiSubtitle: "Kapı ahşap, pvc, demir vs.",
    reportText:
        "☢️ KRİTİK RİSK: Dış kaçış geçitlerine açılan kapılar en az 30 dakika yangına dayanıklı olmalı ve bırakınca kendiliğinden kapanmalıdır.",
  );

  static final kapiOptionC = ChoiceResult(
    label: "24-3-C (Kapı)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapı özellikleri analiz edilemedi.",
    reportText:
        "❓ BİLİNMİYOR: Dış kaçış geçidine açılan kapıların yangın dayanımı ve sızdırmazlık özellikleri bilinmiyor.",
  );
}

class Bolum25Content {
  static final genislikOptionA = ChoiceResult(
    label: "25-1-A",
    uiTitle: "Genişlik < 100 cm",
    uiSubtitle: "Merdiven kol genişliği 100 cm'den az.",
    reportText:
        "☢️ KRİTİK RİSK: Döner merdiven genişliği 100 cm'den azdır. Yönetmelik gereği döner merdivenlerin kaçış yolu sayılabilmesi için en az 100 cm genişlik şarttır.",
    adviceText:
        "Genişliği 100 cm altında kalan döner merdivenler yasal kaçış yolu kabul edilmez. Binaya yönetmelik standartlarında ikinci bir kaçış yolu eklenmesi önerilir.",
  );

  static final genislikOptionB = ChoiceResult(
    label: "25-1-B",
    uiTitle: "Genişlik ≥ 100 cm",
    uiSubtitle: "Merdiven kol genişliği yeterli.",
    reportText:
        "✅ OLUMLU: Döner merdiven genişliği 100 cm ve üzerindedir. Kattaki kişi sayısı 25 kişiyi aşmıyorsa döner merdiven kullanılabilir. 25 kişiyi aşıyorsa döner merdiven kullanılamaz.",
  );

  static final genislikOptionC = ChoiceResult(
    label: "25-1-C",
    uiTitle: "Bilmiyorum / Ölçüm yapamadım.",
    uiSubtitle: "Genişlik belirsiz.",
    reportText:
        "❓ BİLİNMİYOR: Dairesel (döner) merdiven genişliği tespit edilememiştir. Genişliğin 100 cm altında olması veya kullanıcı yükünün 25 kişiyi aşması durumunda bu merdiven kaçış yolu sayılamaz.",
  );
  static final basamakOptionA = ChoiceResult(
    label: "25-2-A",
    uiTitle: "Evet, rahat basılıyor.",
    uiSubtitle: "Basamağın orta kısmı en az 25 cm genişlikte.",
    reportText:
        "Döner merdiven basamak genişliği (basış yüzeyi) yeterli seviyededir.",
  );

  static final basamakOptionB = ChoiceResult(
    label: "25-2-B",
    uiTitle: "Hayır, basamaklar çok dar.",
    uiSubtitle: "Basamaklar üçgen şeklinde, basış alanı yetersiz.",
    reportText:
        "☢️ KRİTİK RİSK: Döner merdiven basamak genişliği yetersizdir. Dar basamaklar tahliye sırasında düşme riski oluşturur.",
    adviceText:
        "Basamakların en dar noktasında basış genişliğinin artırılması için basamak yapısının revize edilmesi veya merdivenin ana kaçış yolu olarak kullanılmaması planlanmalıdır.",
  );

  static final basamakOptionC = ChoiceResult(
    label: "25-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Basamak yapısı analiz edilemedi.",
    reportText:
        "❓ BİLİNMİYOR: Döner merdiven basamak genişliği bilinmemektedir.",
  );

  static final basKurtarmaOptionA = ChoiceResult(
    label: "25-3-A",
    uiTitle: "Ferah (2.50 metreden yüksek).",
    uiSubtitle: "İnerken başınız tavana veya üst basamağa değmiyor.",
    reportText: "✅ OLUMLU: Baş kurtarma yüksekliği yeterli seviyededir.",
  );

  static final basKurtarmaOptionB = ChoiceResult(
    label: "25-3-B",
    uiTitle: "Standart (2.10 ila 2.50 metre arası).",
    uiSubtitle: "Tavan alçak, baş çarpma riski var.",
    reportText:
        "☢️ KRİTİK RİSK: Baş kurtarma yüksekliği sınır değerlerin altındadır (2.50m altı).",
    adviceText:
        "Tahliye anında yaralanmaları önlemek için tavanın alçak olduğu noktalara yumuşak koruyucu pedler ve fosforlu uyarı işaretleri yerleştirilmelidir.",
  );

  static final basKurtarmaOptionC = ChoiceResult(
    label: "25-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Yükseklik ölçümü yapılamadı.",
    reportText: "❓ BİLİNMİYOR: Baş kurtarma yüksekliği tespit edilememiştir.",
  );
}

class Bolum26Content {
  static final varlikOptionA = ChoiceResult(
    label: "26-1-A",
    uiTitle: "Hayır, sadece merdiven var, rampa yok.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Binada rampa bulunmadığından Yönetmeliğe göre bu konuda bir değerlendirme yapılmaz.",
  );

  static final varlikOptionB = ChoiceResult(
    label: "26-1-B",
    uiTitle: "Evet, rampa var.",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Binada kaçış rampası tespit edilmiştir. Eğim ve sahanlık kriterleri analiz edilmelidir.",
  );

  static final varlikOptionC = ChoiceResult(
    label: "26-1-C",
    uiTitle: "Bilmiyorum",
    uiSubtitle: "Rampa varlığı veya konumu belirsiz.",
    reportText:
        "❓ BİLİNMİYOR: Binada kaçış rampası olup olmadığı veya konumu tespit edilememiştir.",
  );

  static final egimOptionA = ChoiceResult(
    label: "26-2-A",
    uiTitle: "Eğim az (%10'dan az) ve zemin kaymaz.",
    uiSubtitle: "Rahat yürünüyor, zeminde kaymaz bant veya malzeme var.",
    reportText:
        "✅ OLUMLU: Rampa eğimi ve zemin kaplaması kaçış güvenliği için yeterli seviyededir.",
  );

  static final egimOptionB = ChoiceResult(
    label: "26-2-B",
    uiTitle: "Eğim fazla dik (%10'dan fazla) veya zemin kaygan.",
    uiSubtitle: "Yürürken insanı zorluyor, kayma tehlikesi var.",
    reportText:
        "☢️ KIRMIZI RİSK: Kaçış rampalarının eğimi %10'dan fazla olamaz. Dik ve kaygan rampalar panik anında düşmelere sebep olur.",
  );

  static final egimOptionC = ChoiceResult(
    label: "26-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Eğim ölçümü veya zemin analizi yapılamadı.",
    reportText:
        "❓ BİLİNMİYOR: Rampa eğimi ve zemin kaymazlık durumu bilinmiyor. %10 üzerindeki eğimler tahliyeyi tehlikeye atar.",
  );

  static final sahanlikOptionA = ChoiceResult(
    label: "26-3-A",
    uiTitle: "Evet, sahanlık var, kapı önleri ve dönüşleri düz.",
    uiSubtitle: "Rampa başlangıç ve bitişinde güvenli düzlükler var.",
    reportText:
        "✅ OLUMLU: Rampa sahanlıkları ve kapı önü düzlükleri mevcuttur.",
  );

  static final sahanlikOptionB = ChoiceResult(
    label: "26-3-B",
    uiTitle: "Hayır, rampadan önce veya sonra eğim var.",
    uiSubtitle: "Kapıyı açınca direkt eğimli yüzeye basılıyor.",
    reportText:
        "⚠️ UYARI: Rampa giriş ve çıkışlarında, kapı önlerinde mutlaka düz sahanlık bulunmalıdır.",
  );

  static final sahanlikOptionC = ChoiceResult(
    label: "26-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Sahanlık varlığı tespit edilemedi.",
    reportText:
        "❓ BİLİNMİYOR: Rampa sahanlıklarının varlığı ve kapı önü düzlükleri bilinmiyor.",
  );

  static final otoparkOptionA = ChoiceResult(
    label: "26-4-A",
    uiTitle: "Evet, eğimi uygun (%10 'un altı).",
    uiSubtitle: "Araç rampası yürüyerek çıkmaya müsait.",
    reportText:
        "✅ OLUMLU: Otopark rampası, eğimi uygun olduğu için 2. kaçış yolu olarak kabul edilebilir.",
  );

  static final otoparkOptionB = ChoiceResult(
    label: "26-4-B",
    uiTitle: "Hayır, çok dik (%10'dan fazla) veya zemin kaygan.",
    uiSubtitle: "Rampayı sadece araçlar kullanabilir.",
    reportText:
        "☢️ KIRMIZI RİSK: : Otopark rampası çok dik (%10'dan fazla) olduğu için kaçış yolu sayılamaz.",
  );

  static final otoparkOptionC = ChoiceResult(
    label: "26-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Otopark rampası analiz edilemedi.",
    reportText:
        "❓ BİLİNMİYOR: Otopark rampasının kaçış yolu olarak kullanılabilirliği belirsizdir.",
  );
}

class Bolum27Content {
  // 1. BOYUT VE EŞİK
  static final boyutOptionA = ChoiceResult(
    label: "27-1-A",
    uiTitle: "80 cm'den geniş ve eşiksiz.",
    uiSubtitle: "Geçiş rahat, ayağın takılma ihtimali yok.",
    reportText:
        "✅ OLUMLU: Kaçış kapısı genişliği (min. 80cm) ve zemin düzgünlüğü uygundur.",
  );

  static final boyutOptionB = ChoiceResult(
    label: "27-1-B",
    uiTitle: "80 cm'den dar veya eşikli.",
    uiSubtitle: "Geçiş zor veya ayağın takılma ihtimali var.",
    reportText:
        "☢️ KRİTİK RİSK: Kaçış kapılarında temiz geçiş genişliği en az 80 cm olmalıdır. Ayrıca takılıp düşmeye sebep olacak 'Eşik' bulunması kesinlikle yasaktır.",
  );

  static final boyutOptionC = ChoiceResult(
    label: "27-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Ölçüm yapılamadı.",
    reportText:
        "❓ BİLİNMİYOR: Kapı ölçüleri ve eşik durumu bilinmiyor. Dar kapılar ve eşikler panik anında yığılmalara neden olabilir.",
  );

  // 2. YÖN
  static final yonOptionA = ChoiceResult(
    label: "27-2-A",
    uiTitle: "Dışarıya doğru (kaçış yönünde) açılıyor.",
    uiSubtitle: "Kapıyı itince açılıyor.",
    reportText: "✅ OLUMLU: Kapı açılış yönü (kaçış yönü) doğrudur.",
  );

  static final yonOptionB = ChoiceResult(
    label: "27-2-B",
    uiTitle: "İçeriye doğru açılıyor.",
    uiSubtitle: "Kapıyı açmak için kendinize çekmeniz gerekiyor.",
    reportText:
        "⚠️ UYARI: Kullanıcı yükü 50 kişiyi geçen mahallerde ve katlarda kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır.",
  );

  static final yonOptionC = ChoiceResult(
    label: "27-2-C",
    uiTitle: "Döner kapı, turnike veya sürgülü.",
    uiSubtitle: "Otomatik veya döner mekanizma.",
    reportText:
        "☢️ KRİTİK RİSK: Kaçış yolunda döner kapı veya sürgülü kapı kullanılamaz. Bu tip kapıların yanında mutlaka kapı kollu veya panik barlı normal kapı bulunmalıdır. Turnikeler varsa ve yangın anında serbest kalmıyorsa büyük risk oluşturur.",
  );

  static final yonOptionD = ChoiceResult(
    label: "27-2-D",
    uiTitle: "Karma.",
    uiSubtitle:
        "Kaçış yolu üzerinde farklı yönlere açılan, farklı tip kapılar mevcut.",
    reportText:
        "⚠️ UYARI: Kaçış yolu üzerinde farklı tip ve yöne açılan kapılar tespit edilmiştir. Tahliye güzergahındaki tüm kapıların kaçış yönüne açılması ve sürgülü/döner kapı içermemesi esastır. Karma yapı panik anında izdihama yol açabilir.",
  );

  static final yonOptionE = ChoiceResult(
    label: "27-2-E",
    uiTitle: "Bilmiyorum, tespit yapamıyorum.",
    uiSubtitle: " ",
    reportText:
        "❓ BİLİNMİYOR: Kapı açılma yönü ve kapı tipleri bilinmiyor. Yerinde inceleme yapılarak kaçış yolu üzerindeki kapıların özellikleri hususi olarak kontrol edilmelidir.",
  );

  // 3. KİLİT MEKANİZMASI
  static final kilitOptionA = ChoiceResult(
    label: "27-3-A",
    uiTitle: "Panik Bar var (Vücutla itince açılıyor).",
    uiSubtitle: "Yatay bar mekanizması mevcut.",
    reportText:
        "✅ OLUMLU: Kapıda panik bar mekanizması mevcuttur, gereksinimi karşılamaktadır.",
  );

  static final kilitOptionB = ChoiceResult(
    label: "27-3-B",
    uiTitle: "Normal kapı kolu var.",
    uiSubtitle: "Çevirmeli standart kol.",
    reportText:
        "⚠️ UYARI: Kullanıcı yükü 100 kişiyi aşmayan yerlerde kapı kolu kabul edilebilir. 100 kişiyi aşan yerlerde Panik Bar zorunludur.",
  );

  static final kilitOptionC = ChoiceResult(
    label: "27-3-C",
    uiTitle: "Anahtar gerekiyor veya kilitli tutuluyor.",
    uiSubtitle: " .",
    reportText:
        "☢️ KRİTİK RİSK: Kaçış yolu kapıları ASLA kilitlenemez. Her an tek hamlede açılabilir olmalıdır.",
  );

  static final kilitOptionD = ChoiceResult(
    label: "27-3-D",
    uiTitle: "Karma (Bazı kapılar panik barlı, bazıları kollu veya kilitli).",
    uiSubtitle: "Kaçış yolunda standart olmayan kilit tipleri mevcut.",
    reportText:
        "⚠️ UYARI: Kaçış güzergahında karma kilit sistemleri mevcuttur. Kullanıcı yükü 100 kişiyi aşan binalarda tüm kapıların panik bar ile donatılması şarttır. Bazı kapıların kilitli olması veya anahtar gerektirmesi tahliyeyi imkansız kılar.",
  );

  static final kilitOptionE = ChoiceResult(
    label: "27-3-E",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kilit mekanizması belirsiz.",
    reportText:
        "❓ BİLİNMİYOR: Kilit mekanizması kontrol edilmelidir. Kilitli kapılar can kaybına neden olabilir.",
  );

  // 4. DAYANIM
  static final dayanimOptionA = ChoiceResult(
    label: "27-4-A",
    uiTitle: "Çelik, yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanıyor.",
    uiSubtitle:
        "",
    reportText:
        "✅ OLUMLU: Yangın kapısı standartlara (EI60/EI90) ve sızdırmazlık şartlarına uygundur.",
  );

  static final dayanimOptionB = ChoiceResult(
    label: "27-4-B",
    uiTitle:
        "Çelik, yangına dayanıklı, duman sızdırmaz ancak kendiliğinden kapanmıyor.",
    uiSubtitle: "Hidroliği veya menteşeleri arızalı.",
    reportText:
        "⚠️ UYARI: Yangın kapıları her zaman otomatik kapanır durumda olmalıdır.",
  );

  static final dayanimOptionC = ChoiceResult(
    label: "27-4-C",
    uiTitle: "Ahşap, PVC veya cam kapı (dayanıksız).",
    uiSubtitle: "Yangın kapısı değildir.",
    reportText:
        "☢️ KRİTİK RİSK: Yangın merdiveni kapıları yanıcı malzemeden (Ahşap/PVC) yapılamaz. En az 60 dk yangına dayanıklı olmalıdır.",
  );

  static final dayanimOptionD = ChoiceResult(
    label: "27-4-D",
    uiTitle: "Karma (Bazı kapılar yangına dayanıklı, bazıları dayanıksız).",
    uiSubtitle: "Farklı katlarda farklı özellikte kapılar mevcut.",
    reportText:
        "☢️ KRİTİK RİSK: Kaçış merdivenine açılan kapıların bir kısmının yangına dayanıksız (Ahşap/PVC/Cam) olması, yangın kompartıman bütünlüğünü bozar. Tüm kapıların sertifikalı yangın kapısı olması zorunludur.",
  );

  static final dayanimOptionE = ChoiceResult(
    label: "27-4-E",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapı özelliği belirsiz.",
    reportText:
        "❓ BİLİNMİYOR: Kaçış yolu üzerindeki kapıların özellikleri bilinmiyor. Uzman tarafından yerinde inceleme yapılması önerilir.",
  );
}

class Bolum28Content {
  static final muafiyetOption = ChoiceResult(
    label: "28-1 (Muafiyet)",
    uiTitle: "(Otomatik Ekran)",
    uiSubtitle: "(Kullanıcı seçim yapmaz, sistem gösterir)",
    reportText:
        "✅ OLUMLU: Binanız bodrum dahil 4 katı geçmemektedir ve binada konut harici ticari alan da bulunmamaktadır. Yapı tek kullanım amaçlı olup, özel bir yangın merdiveni veya kaçış mesafesi şartı aranmaz.",
  );

  static final mesafeOptionA = ChoiceResult(
    label: "28-2-A (Mesafe)",
    uiTitle: "20 metreden az.",
    uiSubtitle: "En uzak odadan daire kapısına kadar olan mesafe.",
    reportText:
        "✅ OLUMLU: Daire içi kaçış mesafesi 20 metrenin altındadır, Yönetmelik talebi karşılanıyor.",
  );

  static final mesafeOptionB = ChoiceResult(
    label: "28-2-B (Mesafe)",
    uiTitle: "20 - 30 metre arası.",
    uiSubtitle: "",
    reportText:
        "(Sprinkler Varsa) ✅ OLUMLU: Sprinkler sistemi olduğu için 30 metreye kadar izin verilir.<br>(Sprinkler Yoksa) ☢️ KRİTİK RİSK: Sprinkler olmayan dairelerde en uzak noktadan çıkışa mesafe 20 metreyi geçemez.",
  );

  static final mesafeOptionC = ChoiceResult(
    label: "28-2-C (Mesafe)",
    uiTitle: "30 metreden fazla.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: Binanın tamamında sprinkler sistemi olsa bile daire içi kaçış mesafesi 30 metreyi geçemez.",
  );

  static final dubleksOptionA = ChoiceResult(
    label: "28-3-A (Dubleks)",
    uiTitle: "Hayır, tek katlı daire.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Tek katlı daire olduğu beyan edilmiştir.",
  );

  static final dubleksOptionB = ChoiceResult(
    label: "28-3-B (Dubleks)",
    uiTitle: "Evet, dubleks (çift katlı)",
    uiSubtitle: "",
    reportText: "(Alt sorulara göre belirlenir)",
  );

  static final alanOption1 = ChoiceResult(
    label: "28-3-B-1 (Alan)",
    uiTitle: "Üst kat 70 m²'den küçük.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Üst kat alanı 70 m²'den küçük olduğu için tek çıkış yeterlidir.",
  );

  static final alanOption2 = ChoiceResult(
    label: "28-3-B-2 (Alan)",
    uiTitle: "Üst kat 70 m²'den büyük.",
    uiSubtitle: "",
    reportText: "(Çıkış Kapısı sorulur)",
  );

  static final cikisOptionA = ChoiceResult(
    label: "28-3-B-2-A (Çıkış)",
    uiTitle: "Evet, üst katta kapı var.",
    uiSubtitle: "Üst kattan apartmana çıkış mevcut.",
    reportText:
        "✅ OLUMLU: Üst kat alanı 70 m²'yi geçtiği için yapılan ikinci çıkış kapısı olması halinde Yönetmelik talebi karşılanmaktadır.",
  );

  static final cikisOptionB = ChoiceResult(
    label: "28-3-B-2-B (Çıkış)",
    uiTitle: "Hayır, üst katta kapı yok.",
    uiSubtitle: "Sadece alt kattan çıkılabiliyor.",
    reportText:
        "☢️ KRİTİK RİSK: Dubleks dairelerde üst kat alanı 70 m²'yi geçerse, üst kattan da apartman koridoruna açılan ikinci bir çıkış kapısı olması zorunludur.",
  );
}

class Bolum29Content {
  // 1. OTOPARK
  static final otoparkOptionA = ChoiceResult(
    label: "29-1-A",
    uiTitle: "Hayır, sadece taşıtlar var, alan temiz.",
    uiSubtitle: "Otopark alanı düzenli.",
    reportText:
        "✅ OLUMLU: Otopark alanı temizdir, farklı risk grubuna ait depolama yapılmamıştır.",
  );
  static final otoparkOptionB = ChoiceResult(
    label: "29-1-B",
    uiTitle: "Evet, eşya yığınları var.",
    uiSubtitle: "Lastik, koli, eski eşya vb. biriktirilmiş.",
    reportText:
        "⚠️ UYARI: Otoparklar sadece araç parkı içindir. Eşya yığınları yangını büyütür ve söndürmeyi zorlaştırır. Derhal temizlenmelidir.",
  );
  static final otoparkOptionC = ChoiceResult(
    label: "29-1-C",
    uiTitle: "Bilmiyorum / Dikkat etmedim.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Otoparkın temizlik durumu bilinmiyor. Araçların yanına istiflenen eski lastikler veya eşyalar, küçük bir araç yangınını tüm binayı saracak bir felakete dönüştürebilir. Lütfen otoparkı kontrol ediniz.",
  );

  // 2. KAZAN DAİRESİ
  static final kazanOptionA = ChoiceResult(
    label: "29-2-A",
    uiTitle: "Hayır, sadece kazan ve tesisat var.",
    uiSubtitle: "Kazan dairesi boş ve temiz.",
    reportText:
        "✅ OLUMLU: Kazan dairesinde gereksiz yanıcı madde bulunmamaktadır.",
  );
  static final kazanOptionB = ChoiceResult(
    label: "29-2-B",
    uiTitle: "Evet, eşyalar var.",
    uiSubtitle: "Odun, kömür, kağıt, eski eşya vb. var.",
    reportText:
        "⚠️ UYARI: Kazan daireleri depo değildir! Yakıt tankının veya kazanın yanındaki en ufak bir kıvılcım, oradaki eşyaları tutuşturup binayı tehlikeye atar.",
  );
  static final kazanOptionC = ChoiceResult(
    label: "29-2-C",
    uiTitle: "Bilmiyorum / İçini görmedim.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Kazan dairesinin içi bilinmiyor. Burası binanın kalbidir ve en yüksek yangın riskini taşır. İçeride unutulan bir bez parçası veya kağıt yığını büyük bir patlamaya neden olabilir. Mutlaka denetlenmelidir.",
  );

  // 3. ÇATI ARASI
  static final catiOptionA = ChoiceResult(
    label: "29-3-A",
    uiTitle: "Hayır, boş ve kilitli.",
    uiSubtitle: "Çatı arası temiz.",
    reportText: "✅ OLUMLU: Çatı arası temiz ve güvenlidir.",
  );
  static final catiOptionB = ChoiceResult(
    label: "29-3-B",
    uiTitle: "Evet, depo gibi kullanılıyor.",
    uiSubtitle:
        "Eski eşyalar, mobilya, temizlik ürünleri vb. farklı yanıcı maddeler vs. var.",
    reportText:
        "⚠️ UYARI: Çatı araları elektrik kontağından en çok yangın görülen yerlerdir. Buradaki fazla eşyalar yangına sebep olur veya mevcut yangına katkı sağlayarak hızlandırır.",
  );
  static final catiOptionC = ChoiceResult(
    label: "29-3-C",
    uiTitle: "Bilmiyorum / Çatıya hiç çıkmadım.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Çatı arasının durumu bilinmiyor. Genellikle fazla eşyaların biriktirildiği yerdir. Elektrik tesisatından çıkabilecek bir kıvılcım, buradaki kuru ve tozlu eşyaları anında tutuşturur. Kontrol edilmesi hayati önem taşır.",
  );

  // 4. ASANSÖR MAKİNE DAİRESİ
  static final asansorOptionA = ChoiceResult(
    label: "29-4-A",
    uiTitle: "Hayır, temiz.",
    uiSubtitle: "Makine dairesinde sadece motor var.",
    reportText: "✅ OLUMLU: Asansör makine dairesi temizdir.",
  );
  static final asansorOptionB = ChoiceResult(
    label: "29-4-B",
    uiTitle: "Evet, malzemeler var.",
    uiSubtitle: "Yağ tenekesi, bez vs. yanıcı maddeler var.",
    reportText:
        "⚠️ UYARI: Asansör motorları ısınır. Yanındaki yağlı bezler veya malzemeler tutuşabilir. Makine dairesi depo olarak kullanılamaz.",
  );
  static final asansorOptionC = ChoiceResult(
    label: "29-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Asansör makine dairesinin durumu bilinmiyor. Motorların ısınmasıyla yanabilecek yağlı bezler veya plastik malzemeler burada büyük risk oluşturur. Yöneticiden bilgi alınız.",
  );

  // 5. JENERATÖR ODASI
  static final jeneratorOptionA = ChoiceResult(
    label: "29-5-A",
    uiTitle: "Hayır.",
    uiSubtitle: "Sadece jeneratör ve ilgili ekipmanlar var.",
    reportText: "✅ OLUMLU: Jeneratör odası temizdir.",
  );
  static final jeneratorOptionB = ChoiceResult(
    label: "29-5-B",
    uiTitle: "Evet.",
    uiSubtitle: "Yanıcı malzemeler, eşya vb. bekletiliyor.",
    reportText:
        "⚠️ UYARI: Jeneratör odasında sadece günlük yakıt tankı bulunabilir. Bidonla yakıt saklamak veya eşya koymak yasaktır.",
  );
  static final jeneratorOptionC = ChoiceResult(
    label: "29-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Jeneratör odasının durumu bilinmiyor. İçeride yakıt buharı olabilir. Depolanan gereksiz eşyalar havalandırmayı tıkayabilir veya yangın yükünü artırabilir. Uzman kontrolü önerilir.",
  );

  // 6. ELEKTRİK PANO ODASI
  static final panoOptionA = ChoiceResult(
    label: "29-6-A",
    uiTitle: "Hayır.",
    uiSubtitle: "Pano odası boş.",
    reportText: "✅ OLUMLU: Elektrik pano odası temizdir.",
  );
  static final panoOptionB = ChoiceResult(
    label: "29-6-B",
    uiTitle: "Evet.",
    uiSubtitle: "Paspas, süpürge, kağıt saklanıyor.",
    reportText:
        "⚠️ UYARI: Pano odaları kesinlikle boş olmalıdır. Elektrik kontağı anında yanıcı malzemeleri tutuşturur.",
  );
  static final panoOptionC = ChoiceResult(
    label: "29-6-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: " ",
    reportText:
        "❓ BİLİNMİYOR: Elektrik odasının içi bilinmiyor. Pano odaları yangınların en sık başladığı yerlerdir. İçeride unutulan bir paspas veya kağıt parçası, küçük bir ark (kıvılcım) sonucu büyük bir yangını başlatabilir.",
  );

  // 7. TRAFO ODASI
  static final trafoOptionA = ChoiceResult(
    label: "29-7-A",
    uiTitle: "Evet, temiz ve havadar.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Trafo odası havalandırılıyor ve temiz tutuluyor.",
  );
  static final trafoOptionB = ChoiceResult(
    label: "29-7-B",
    uiTitle: "Hayır, menfezler kapalı veya içeride eşya var.",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Trafo odaları ısınır ve patlama riski taşır. Havalandırma asla kapatılmamalı ve içerisi depo yapılmamalıdır.",
  );
  static final trafoOptionC = ChoiceResult(
    label: "29-7-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Trafo odasının durumu bilinmiyor. Yüksek gerilim hattı taşıyan bu odaların havalandırmasının kapanması veya içeride eşya olması patlama riskini doğurur. Acilen kontrol edilmelidir.",
  );

  // 8. ORTAK DEPO
  static final depoOptionA = ChoiceResult(
    label: "29-8-A",
    uiTitle: "Hayır, sadece ev eşyası.",
    uiSubtitle: "Yüksek yanıcı madde yok.",
    reportText: "✅ OLUMLU: Depolarda parlayıcı madde tespit edilmemiştir.",
  );
  static final depoOptionB = ChoiceResult(
    label: "29-8-B",
    uiTitle: "Evet, boya kutuları veya kimyasallar var.",
    uiSubtitle: "Yanıcı kimyasallar saklanıyor.",
    reportText:
        "⚠️ UYARI: Apartman altındaki depolarda parlayıcı madde saklamak yasaktır. Bu malzemeler özel güvenlikli dolaplarda tutulmalıdır.",
  );
  static final depoOptionC = ChoiceResult(
    label: "29-8-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Depolarda ne saklandığı bilinmiyor. Komşularınızın buraya koyduğu tiner, boya veya LPG tüpü gibi malzemeler tüm binayı riske atabilir. Depo denetimi yapılmalıdır.",
  );

  // 9. ÇÖP ODASI
  static final copOptionA = ChoiceResult(
    label: "29-9-A",
    uiTitle: "Düzenli atılıyor, temiz.",
    uiSubtitle: "Yoğun koku veya gaz birikmesi yok.",
    reportText: "✅ OLUMLU: Çöp odası temizliği uygun gözüküyor.",
  );
  static final copOptionB = ChoiceResult(
    label: "29-9-B",
    uiTitle: "Çöpler birikiyor, hijyen kötü.",
    uiSubtitle: "Hijyen kötü, yoğun koku var.",
    reportText:
        "⚠️ UYARI: Biriken çöpler metan gazı oluşturur ve kendiliğinden yanabilir. Günlük temizlik şarttır.",
  );
  static final copOptionC = ChoiceResult(
    label: "29-9-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: " ",
    reportText:
        "❓ BİLİNMİYOR: Çöp odasının hijyen durumu bilinmiyor. Biriken çöplerden sızan metan gazı, kapalı alanda patlama veya zehirlenme riski oluşturur. Havalandırma ve temizlik kontrol edilmelidir.",
  );

  // 10. SIĞINAK
  static final siginakOptionA = ChoiceResult(
    label: "29-10-A",
    uiTitle: "Hayır.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Sığınakta yanıcı madde depolanmamaktadır.",
  );
  static final siginakOptionB = ChoiceResult(
    label: "29-10-B",
    uiTitle: "Evet.",
    uiSubtitle: "Boya, tiner, tüp vb. var.",
    reportText:
        "⚠️ UYARI: Sığınaklar barış zamanında depo olarak kullanılabilir ANCAK yanıcı madde konulamaz. Yangın yükünü artırır.",
  );
  static final siginakOptionC = ChoiceResult(
    label: "29-10-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Sığınağın kullanım durumu bilinmiyor. Kontrolsüzce yığılan eşyalar, sığınağı güvenli bir alan olmaktan çıkarabilir. Kontrol edilmesi tavsiye edilir.",
  );
}

class Bolum30Content {
  // --- 1. KONUM ---
  static final konumOptionA = ChoiceResult(
    label: "30-1-A",
    uiTitle: "Koridora veya hole açılıyor.",
    uiSubtitle: "Arada hol var.",
    reportText: "✅ OLUMLU: Kazan dairesi kapısı koridora açılmaktadır.",
  );
  static final konumOptionB = ChoiceResult(
    label: "30-1-B",
    uiTitle: "Direkt merdiven boşluğuna açılıyor.",
    uiSubtitle: "Kapıyı açınca merdiven sahanlığı var.",
    reportText:
        "☢️ KRİTİK RİSK: Kazan dairesi kapısı ASLA doğrudan merdiven boşluğuna açılamaz. Olası bir patlama veya gaz sızıntısında merdiven kullanılamaz hale gelir.",
  );
  static final konumOptionC = ChoiceResult(
    label: "30-1-C",
    uiTitle: "Binadan ayrı (dış cepheden uzakta veya bahçede).",
    uiSubtitle: "Bina dışında müstakil yapı.",
    reportText: "✅ OLUMLU: Kazan dairesi bina dışındadır.",
  );
  static final konumOptionD = ChoiceResult(
    label: "30-1-D",
    uiTitle: "Bilmiyorum / Emin Değilim",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Kazan dairesinin konumu ve kapı açılış yönü bilinmiyor. Yangın anında müdahale ve tahliye güvenliği için bu alanın denetlenmesi önerilir.",
  );

  // --- 2. KAPASİTE ---
  static final kapasiteBilinmiyorOption = ChoiceResult(
    label: "30-2-BILMIYORUM",
    uiTitle: "Kazan dairesinin ısıl kapasitesini bilmiyorum.",
    uiSubtitle: "Kapasite bilgisine ulaşılamadı.",
    reportText:
        "⚠️ UYARI: Kazan dairesinin ısıl kapasitesi eğer 350kw 'ın üzerindeyse çift çıkış kapısı gereklidir.",
  );

  // --- 3. KAPI SAYISI ---
  static final kapiOptionA = ChoiceResult(
    label: "30-3-A",
    uiTitle: "1 Adet Kapı.",
    uiSubtitle: "Tek çıkış var.",
    reportText:
        "(Büyük Kazan İse) ☢️ KRİTİK RİSK: Girdiğiniz bilgilere göre kazan daireniz 'Büyük/Yüksek Kapasiteli' sınıfındadır. Yönetmeliğe göre en az 2 adet çıkış kapısı zorunludur.<br>(Küçük Kazan İse) ✅ OLUMLU: Kapı sayısı yeterlidir.",
  );
  static final kapiOptionB = ChoiceResult(
    label: "30-3-B",
    uiTitle: "2 Adet (veya daha fazla).",
    uiSubtitle: "Çift çıkış var.",
    reportText: "✅ OLUMLU: Kazan dairesinde birden fazla çıkış mevcuttur.",
  );
  static final kapiOptionC = ChoiceResult(
    label: "30-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Kazan dairesi çıkış kapısı sayısı bilinmiyor. Büyük kapasiteli kazanlarda acil durum tahliyesi için en az 2 çıkış şarttır.",
  );

  // --- 4. HAVALANDIRMA ---
  static final havaOptionA = ChoiceResult(
    label: "30-4-A",
    uiTitle: "Evet, altta ve üstte menfezler var.",
    uiSubtitle: "Temiz ve kirli hava delikleri mevcut.",
    reportText:
        "✅ OLUMLU: Kazan dairesi havalandırması (alt ve üst menfez) uygundur.",
  );
  static final havaOptionB = ChoiceResult(
    label: "30-4-B",
    uiTitle: "Hayır, sadece pencere, menfez vs. yok.",
    uiSubtitle: "Menfez yok, hava sirkülasyonu yetersiz.",
    reportText:
        "⚠️ UYARI: Temiz hava girişi ve kirli hava çıkışı sağlanmazsa verimsiz yanma olur ve karbonmonoksit zehirlenmesi riski doğar.",
  );
  static final havaOptionC = ChoiceResult(
    label: "30-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Havalandırma durumu bilinmiyor. Yetersiz havalandırma, yanma verimini düşürür ve patlama riski oluşturur.",
  );

  // --- 5. YAKIT TİPİ ---
  static final yakitOptionA = ChoiceResult(
    label: "30-5-A",
    uiTitle: "Hayır, Doğalgazlı veya Kömürlü.",
    uiSubtitle: "Sıvı yakıt değil.",
    reportText: "✅ BİLGİ: Kazan yakıtı sıvı yakıt (mazot vb.) değildir.",
  );
  static final yakitOptionB = ChoiceResult(
    label: "30-5-B",
    uiTitle: "Evet, Sıvı Yakıtlı.",
    uiSubtitle: "Mazot, Fuel-oil vb.",
    reportText:
        "⚠️ BİLGİ: Kazan sıvı yakıtlıdır. Sızıntı ve drenaj önlemleri kritik önem taşır.",
  );
  static final yakitOptionC = ChoiceResult(
    label: "30-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Yakıt türü bilinmiyor. Yakıt türüne göre alınması gereken özel önlemler (drenaj, söndürme sistemi vb.) belirlenememiştir.",
  );

  // --- 6. DRENAJ ---
  static final drenajOptionA = ChoiceResult(
    label: "30-5-B-1",
    uiTitle: "Evet, var.",
    uiSubtitle: "Kanal ve çukur mevcut.",
    reportText: "✅ OLUMLU: Sıvı yakıtlı kazanda drenaj sistemi mevcuttur.",
  );
  static final drenajOptionB = ChoiceResult(
    label: "30-5-B-2",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Zemin düz.",
    reportText:
        "⚠️ UYARI: Sıvı yakıtlı kazan dairelerinde, yakıt sızıntısını toplayacak drenaj kanalları ve yakıt ayırıcılı pis su çukuru zorunludur.",
  );
  static final drenajOptionC = ChoiceResult(
    label: "30-5-B-3",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Sıvı yakıtlı kazanlarda sızıntı önleme (drenaj) sistemi olup olmadığı bilinmiyor.",
  );

  // --- 7. TÜP ---
  static final tupOptionA = ChoiceResult(
    label: "30-6-A",
    uiTitle: "Evet, en az 6kg'lık yangın söndürme tüpü var.",
    uiSubtitle: "",
    reportText:
        "⚠️ UYARI: Yangın söndürme tüpü mevcuttur. Büyük/Yüksek kapasiteli kazan dairelerinde yangın dolabı da olmalıdır.",
  );
  static final tupOptionB = ChoiceResult(
    label: "30-6-B",
    uiTitle: "Evet, yangın söndürme tüpü ve yangın dolabı var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Yangın söndürme ekipmanları tamdır.",
  );
  static final tupOptionC = ChoiceResult(
    label: "30-6-C",
    uiTitle: "Hayır, hiçbiri yok.",
    uiSubtitle: "Söndürme cihazı yok.",
    reportText:
        "☢️ KRİTİK RİSK: Kazan dairesinde en az 1 adet 6 kg'lık Kuru Kimyevi Tozlu yangın söndürme cihazı bulunması yasal zorunluluktur.",
  );
  static final tupOptionD = ChoiceResult(
    label: "30-6-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Söndürme ekipmanlarının varlığı bilinmiyor. Kazan dairesinde en az 1 adet 6 kg'lık tüp bulunması şarttır.",
  );
}

class Bolum31Content {
  static final yapiOptionA = ChoiceResult(
    label: "31-1-A",
    uiTitle: "Duvarları beton/tuğla, kapısı dışarıya açılıyor.",
    uiSubtitle: "Yangına dayanıklı duvar ve kapı mevcut.",
    reportText:
        "ℹ️ BİLGİ:: Trafo odası yangın kompartımanı olarak tasarlanmıştır. Duvarlar ve kapı yangına dayanıklıdır.",
  );

  static final yapiOptionB = ChoiceResult(
    label: "31-1-B",
    uiTitle: "Kapısı direkt apartman koridoruna açılıyor.",
    uiSubtitle: "Kapı açılınca bina içine duman dolabilir.",
    reportText:
        "☢️ KRİTİK RİSK: Trafo odasından çıkacak yoğun duman ve ısı, kaçış yollarını (merdivenleri) kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır.",
  );

  static final yapiOptionC = ChoiceResult(
    label: "31-1-C",
    uiTitle: "Duvarları ve kapısı yangın dayanımsız.",
    uiSubtitle:
        "Dayanıklı olmayan malzeme (alçıpanel, ahşap kapı vb.) kullanılmıştır.",
    reportText:
        "☢️ KRİTİK RİSK: Trafo odası yangın bölmesi (kompartıman) olarak tasarlanmalıdır. Yağlı tip trafo odalarının duvarları 120dk, kapısı 90dk yangına dayanıklı olmalıdır.",
  );

  static final yapiOptionD = ChoiceResult(
    label: "31-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Yapısal özellikler tespit edilemedi.",
    reportText:
        "❓ BİLİNMİYOR: Trafo odasının yapısal özellikleri (duvar/kapı) tespit edilememiştir. Yangın güvenliği açısından bu alanın kompartıman özelliği Uzmman tarafından incelenmelidir.",
  );

  static final tipOptionA = ChoiceResult(
    label: "31-2-A",
    uiTitle: "Kuru Tip.",
    uiSubtitle: "Yağsız trafo.",
    reportText:
        "✅ OLUMLU: Kuru tip trafo kullanıldığı için yağ sızıntısı ve yangın riski düşüktür.",
  );

  static final tipOptionB = ChoiceResult(
    label: "31-2-B",
    uiTitle: "Yağlı Tip.",
    uiSubtitle: "İçinde soğutma yağı var.",
    reportText: "(Alt soruya göre belirlenir)",
  );

  static final tipOptionC = ChoiceResult(
    label: "31-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Trafo tipi belirlenemedi.",
    reportText:
        "❓ BİLİNMİYOR: Trafo tipi (yağlı/kuru) belirlenememiştir. Yağlı tip trafolar daha yüksek yangın riski taşıdığından tip tespiti kritiktir.",
  );

  static final cukurOptionA = ChoiceResult(
    label: "31-2-B-1",
    uiTitle: "Evet, var.",
    uiSubtitle: "Yağ toplama çukuru mevcut.",
    reportText: "✅ OLUMLU: Yağlı trafo altında toplama çukuru mevcuttur.",
  );

  static final cukurOptionB = ChoiceResult(
    label: "31-2-B-2",
    uiTitle: "Hayır, düz zemin.",
    uiSubtitle: "Çukur yok, yağ etrafa yayılabilir.",
    reportText:
        "☢️ KRİTİK RİSK: Yağlı trafolarda, ısınan yağın taşması veya tankın delinmesi durumunda yanıcı yağın çevreye yayılmaması için toplama çukuru ZORUNLUDUR.",
  );

  static final cukurOptionC = ChoiceResult(
    label: "31-2-B-3",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Zemin detayları görülemedi.",
    reportText:
        "❓ BİLİNMİYOR: Yağlı trafo altında yağ toplama çukuru olup olmadığı tespit edilememiştir.",
  );

  static final sondurmeOptionA = ChoiceResult(
    label: "31-3-A",
    uiTitle: "Evet, dedektör ve söndürme var.",
    uiSubtitle: "Otomatik çalışan sistemler mevcut.",
    reportText:
        "✅ OLUMLU: Trafo odasında otomatik yangın algılama ve söndürme sistemi mevcuttur.",
  );

  static final sondurmeOptionB = ChoiceResult(
    label: "31-3-B",
    uiTitle: "Hayır, hiçbir sistem yok.",
    uiSubtitle: "Sadece manuel müdahale mümkün.",
    reportText:
        "⚠️ UYARI: Trafo odaları kapalı ve kilitli alanlardır. Yangın başladığında dışarıdan fark edilmesi zordur. Otomatik algılama ve söndürme sistemi hayati önem taşır.",
  );

  static final sondurmeOptionC = ChoiceResult(
    label: "31-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Sistemlerin varlığı kontrol edilemedi.",
    reportText:
        "❓ BİLİNMİYOR: Trafo odasındaki otomatik söndürme/algılama sistemlerinin varlığı veya çalışabilirliği belirsizdir.",
  );

  static final cevreOptionA = ChoiceResult(
    label: "31-4-A",
    uiTitle: "Hayır, çevresi ve üstü kuru.",
    uiSubtitle: "Su tesisatı riski yok.",
    reportText:
        "✅ OLUMLU: Trafo odası çevresinde su tesisatı riski bulunmamaktadır.",
  );

  static final cevreOptionB = ChoiceResult(
    label: "31-4-B",
    uiTitle: "Evet, içinden su boruları geçiyor.",
    uiSubtitle: "Odanın içinden boru geçiyor.",
    reportText:
        "☢️ KRİTİK RİSK: Yüksek gerilim hattının olduğu yerden su borusu geçirilemez! Boru patlarsa su ve elektrik teması büyük bir patlamaya neden olur.",
  );

  static final cevreOptionC = ChoiceResult(
    label: "31-4-C",
    uiTitle: "Evet, üstünde banyo/tuvalet var.",
    uiSubtitle: "Üst kat ıslak hacim.",
    reportText:
        "☢️ KRİTİK RİSK: Trafo odalarının üstü ıslak hacim olamaz. Üst kattan olası bir su sızıntısı trafoya damlarsa ölümcül kazalara ve yangına yol açabilir.",
  );

  static final cevreOptionD = ChoiceResult(
    label: "31-4-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Çevresel riskler gözlemlenemedi.",
    reportText:
        "❓ BİLİNMİYOR: Trafo odası çevresindeki su tesisatı veya ıslak hacim riskleri gözlemlenememiştir.",
  );
}

class Bolum32Content {
  // --- 1. YAPI ---
  static final yapiOptionA = ChoiceResult(
    label: "32-1-A",
    uiTitle:
        "Duvarları beton / tuğla, kapısı yangına dayanıklı çelik kapı ve dışarıya doğru açılıyor.",
    uiSubtitle: "",
    reportText:
        "✅ OLUMLU: Jeneratör odasında yangın kompartımantasyonunun sağlandığı söylenebilir.",
  );
  static final yapiOptionB = ChoiceResult(
    label: "32-1-B",
    uiTitle: "Kapısı direkt apartman koridoruna ve hole açılıyor.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: Jeneratör odasından çıkacak zehirli egzoz gazı ve duman, kaçış yollarını kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır.",
  );
  static final yapiOptionC = ChoiceResult(
    label: "32-1-C",
    uiTitle:
        "Duvarlar beyaz alçıpanel vb. dayanıksız malzemeden, kapısı da yangın dayanımsız.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: Jeneratör odası yangın bölmesi olarak tasarlanmalıdır. Duvarlar ve kapı en az 90-120 dakika yangına dayanmazsa, yakıt yangını binaya sıçrayabilir.",
  );
  static final yapiOptionD = ChoiceResult(
    label: "32-1-D",
    uiTitle: "Bilmiyorum / Emin Değilim",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Jeneratör odasının yapısal özellikleri ve kapı dayanımı bilinmiyor. Yangın ve zehirli gaz yayılımı riskine karşı bu alanın teknik incelemesi yapılmalıdır.",
  );

  // --- 2. YAKIT ---
  static final yakitOptionA = ChoiceResult(
    label: "32-2-A",
    uiTitle: "Kendi tankında veya gömülü tankta.",
    uiSubtitle: "Güvenli depolama.",
    reportText: "✅ OLUMLU: Yakıt depolama yöntemi güvenli gözükmektedir.",
  );
  static final yakitOptionB = ChoiceResult(
    label: "32-2-B",
    uiTitle: "Oda içinde bidonlarda veya varillerde.",
    uiSubtitle: "Açıkta yedek yakıt var.",
    reportText:
        "⚠️ UYARI: Jeneratör odasında bidonla veya açık kapta yakıt saklamak uygun değildir. Yakıt buharı elektrik kontağından alev alıp patlamaya neden olabilir.",
  );
  static final yakitOptionC = ChoiceResult(
    label: "32-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Jeneratör yakıtının depolanma şekli bilinmiyor. Yanıcı sıvıların açıkta saklanması büyük bir patlama riskidir, kontrol edilmelidir.",
  );

  // --- 3. ÇEVRE ---
  static final cevreOptionA = ChoiceResult(
    label: "32-3-A",
    uiTitle: "Hayır, çevresi ve üstü kuru, ıslak zemin yok.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Çevresel su riski bulunmamaktadır.",
  );
  static final cevreOptionB = ChoiceResult(
    label: "32-3-B",
    uiTitle: "Evet, içinden su/doğalgaz boruları geçiyor.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: Jeneratör odasından su veya gaz tesisatı geçirilemez. Boru patlaması durumunda suyun elektrikle teması veya gaz kaçağı felakete yol açar.",
  );
  static final cevreOptionC = ChoiceResult(
    label: "32-3-C",
    uiTitle: "Evet, üstünde banyo/tuvalet vb. ıslak hacim var.",
    uiSubtitle: "",
    reportText:
        "☢️ KRİTİK RİSK: Jeneratör odalarının üstü ıslak hacim olamaz. Su sızıntısı kısa devreye yol açar.",
  );
  static final cevreOptionD = ChoiceResult(
    label: "32-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Jeneratör odası çevresindeki tesisat riskleri bilinmiyor. Olası bir su sızıntısının elektrik sistemine zarar verip vermeyeceği denetlenmelidir.",
  );

  // --- 4. EGZOZ ---
  static final egzozOptionA = ChoiceResult(
    label: "32-4-A",
    uiTitle: "Egzoz dışarıda, havalandırma var.",
    uiSubtitle: "Gaz tahliyesi mümkün.",
    reportText: "✅ OLUMLU: Egzoz gazı bina dışına atılmaktadır.",
  );
  static final egzozOptionB = ChoiceResult(
    label: "32-4-B",
    uiTitle: "Egzoz içeride veya havalandırma yok.",
    uiSubtitle: "Gaz içeride birikme yapabilir.",
    reportText:
        "☢️ KRİTİK RİSK: Jeneratör egzozu karbonmonoksit içerir. Egzoz sağlanmalı ve mutlaka bina dışına uzatılmalıdır.",
  );
  static final egzozOptionC = ChoiceResult(
    label: "32-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "❓ BİLİNMİYOR: Jeneratör egzoz tahliye sistemi bilinmiyor. Karbonmonoksit zehirlenmesi riskine karşı egzozun bina dışına verildiğinden emin olunmalıdır.",
  );
}

class Bolum33Content {
  static final normalKatYeterli = ChoiceResult(
    label: "33-NORMAL-OK",
    uiTitle: "Yeterli",
    uiSubtitle: "Çıkış sayısı yeterli.",
    reportText:
        "✅ OLUMLU: Mevcut çıkış sayısı, kişi yoğunluğuna göre yeterli görünmektedir. Kaçış mesafeleri ve çıkmaz koridor uzunlukları mimari projeden veya yerinde ayrıca kontrol edilmelidir.",
  );

  static final normalKatYetersiz = ChoiceResult(
    label: "33-NORMAL-FAIL",
    uiTitle: "Yetersiz",
    uiSubtitle: "Çıkış sayısı eksik.",
    reportText:
        "☢️ KRİTİK RİSK: Normal katlardaki mevcut çıkış sayısı, hesaplanan kullanıcı yükü için yetersizdir. İlave çıkış gereklidir.",
    adviceText:
        "Kullanıcı yükü kapasiteyi aştığı için binaya yönetmelik standartlarında ilave bir kaçış merdiveni eklenmesi, yatay tahliye koridoru oluşturulması veya kat alanlarının yangın kompartımanlarına bölünerek her bölge için ayrı çıkış tasarlanması gerekmektedir.",
  );

  static final zeminKatYeterli = ChoiceResult(
    label: "33-ZEMIN-OK",
    uiTitle: "Yeterli",
    uiSubtitle: "Çıkış sayısı yeterli.",
    reportText:
        "✅ OLUMLU: Zemin kattaki mevcut çıkış sayısı yeterli görünmektedir. Kaçış mesafeleri ve çıkmaz koridor uzunlukları mimari projeden veya yerinde ayrıca kontrol edilmelidir.",
  );

  static final zeminKatYetersiz = ChoiceResult(
    label: "33-ZEMIN-FAIL",
    uiTitle: "Yetersiz",
    uiSubtitle: "Çıkış sayısı eksik.",
    reportText:
        "☢️ KRİTİK RİSK: Zemin kattaki mevcut çıkış sayısı, hesaplanan kullanıcı yükü için yetersizdir.",
  );

  static final bodrumKatYeterli = ChoiceResult(
    label: "33-BODRUM-OK",
    uiTitle: "Yeterli",
    uiSubtitle: "Çıkış sayısı uygun.",
    reportText:
        "✅ OLUMLU: Bodrum katlardaki mevcut çıkış sayısı yeterli görünmektedir. Kaçış mesafeleri ve çıkmaz koridor uzunlukları mimari projeden veya yerinde ayrıca kontrol edilmelidir.",
  );

  static final bodrumKatYetersiz = ChoiceResult(
    label: "33-BODRUM-FAIL",
    uiTitle: "Yetersiz",
    uiSubtitle: "Çıkış sayısı eksik.",
    reportText:
        "☢️ KRİTİK RİSK: Bodrum katlardaki mevcut çıkış sayısı, hesaplanan kullanıcı yükü için yetersizdir.",
  );

  static final bos = ChoiceResult(
    label: "",
    uiTitle: "",
    uiSubtitle: "",
    reportText: "",
  );
}

class Bolum34Content {
  static final zeminOptionA = ChoiceResult(
    label: "34-1-A (Zemin)",
    uiTitle: "Evet, var.",
    uiSubtitle:
        "Müşteriler bina girişini kullanmıyor, direkt dükkan kapısından çıkabiliyor.",
    reportText:
        "✅ OLUMLU: Zemin kattaki ticari alanların kendi bağımsız çıkışları olduğu için, bina ana girişine ve merdivenlerine ek yük getirmezler.",
  );

  static final zeminOptionB = ChoiceResult(
    label: "34-1-B (Zemin)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Dükkan giriş çıkışları bina koridorunun içinden sağlanıyor.",
    reportText:
        "⚠️ UYARI: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Bina ana giriş kapısının genişliği bu ekstra yükü kaldıracak kapasitede olmalıdır.",
  );

  static final zeminOptionC = ChoiceResult(
    label: "34-1-C (Zemin)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Dükkan giriş çıkışlarının nasıl olduğunu bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir.",
  );

  static final bodrumOptionA = ChoiceResult(
    label: "34-2-A (Bodrum)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Bina ortak merdivenini kullanmak zorunda değiller.",
    reportText:
        "✅ OLUMLU: Bodrum kattaki ticari kullanımın kendine ait bağımsız kaçış yolu olması büyük avantajdır. Bina merdivenleri sadece konut sakinlerine kalır.",
  );

  static final bodrumOptionB = ChoiceResult(
    label: "34-2-B (Bodrum)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Bina ortak merdivenini kullanıyorlar.",
    reportText:
        "⚠️UYARI: Bodrum kattaki ticari alanın (Örn: Restauran, kafe, spor salonu vb.) kalabalığı, bina sakinleriyle aynı merdiveni kullanacaktır. Bu durum kaçış anında merdivende tıkanıklığa yol açabilir.",
  );

  static final bodrumOptionC = ChoiceResult(
    label: "34-2-C (Bodrum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Bodrum çıkışlarını bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir.",
  );
}

class Bolum35Content {
  // --- SENARYO 1: TEK YÖN ---
  static final tekYonOptionA = ChoiceResult(
    label: "35-1-A",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "Mesafeyi metre cinsinden gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)",
  );
  static final tekYonOptionB = ChoiceResult(
    label: "35-1-B",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Mesafe yakın.",
    reportText:
        "✅ OLUMLU: Tek yön kaçış mesafesi Yönetmelik sınırları içerisindedir.",
  );
  static final tekYonOptionC = ChoiceResult(
    label: "35-1-C",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Mesafe uzun.",
    reportText:
        "☢️ KRİTİK RİSK: Tek yön kaçış mesafesi sınırın üzerinde! Yangın anında merdivene ulaşmak uzun sürebilir.",
  );
  static final tekYonOptionD = ChoiceResult(
    label: "35-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi tahmin edemiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Bu mesafe, insanların tahliye süresini belirleyen en önemli faktördür. Ölçüm yapılmalıdır.",
  );

  // --- SENARYO 2: ÇİFT YÖN (EN YAKIN) ---
  static final ciftYonOptionA = ChoiceResult(
    label: "35-2-A",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "En yakın çıkışa olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)",
  );
  static final ciftYonOptionB = ChoiceResult(
    label: "35-2-B",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Mesafe yakın.",
    reportText:
        "✅ OLUMLU: En yakın çıkışa kaçış mesafesi yönetmelik sınırları içerisindedir.",
  );
  static final ciftYonOptionC = ChoiceResult(
    label: "35-2-C",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Mesafe uzak.",
    reportText:
        "☢️ KRİTİK RİSK: En yakın çıkışa mesafe sınırın üzerindedir. Koridor mesafesini kısaltmak için yatay tahliye koridoru vb. oluşturulabilir veya farklı önlemler almak gerekebilir. bunun için yerinde Uzman kontrolü gereklidir.",
  );
  static final ciftYonOptionD = ChoiceResult(
    label: "35-2-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi tahmin edemiyorum.",
    reportText: "❓ BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Ölçüm yapılmalıdır.",
  );

  static final cikmazOptionA = ChoiceResult(
    label: "35-3-A",
    uiTitle:
        "Hayır, daireden çıkınca sağa veya sola (iki farklı yöne) gidebiliyorum.",
    uiSubtitle: " ",
    reportText: "✅ OLUMLU: Daire çıkmaz koridor üzerinde değildir.",
  );
  static final cikmazOptionB = ChoiceResult(
    label: "35-3-B",
    uiTitle: "Evet, çıkmaz bir koridorun ucundayım.",
    uiSubtitle: "Sadece tek yöne gidebiliyorum.",
    reportText: "(Alt soru açılır)",
  );

  static final cikmazMesafeOptionA = ChoiceResult(
    label: "35-3-C",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "Yol ayrımına kadar olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)",
  );
  static final cikmazMesafeOptionB = ChoiceResult(
    label: "35-3-D",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Çıkmaz koridoru boyu kısa.",
    reportText:
        "✅ OLUMLU: Çıkmaz koridor mesafesi yönetmelik sınırları içerisindedir.",
  );
  static final cikmazMesafeOptionC = ChoiceResult(
    label: "35-3-E",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Çıkmaz koridorun boyu uzun.",
    reportText:
        "☢️ KRİTİK RİSK: Çıkmaz koridor mesafesi sınırın üzerindedir. Koridor mesafesini kısaltmak için yatay tahliye koridoru vb. oluşturulabilir veya farklı önlemler almak gerekebilir. bunun için yerinde Uzman kontrolü gereklidir. ",
  );
  static final cikmazMesafeOptionD = ChoiceResult(
    label: "35-3-F",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Çıkmaz koridor mesafesi bilinmiyor. Ölçüm yapılmalıdır.",
  );
}

class Bolum36Content {
  static final cikisKatiOptionA = ChoiceResult(
    label: "36-0-A",
    uiTitle: "Zemin kattan çıkabiliyorum.",
    uiSubtitle: "Bina çıkışı zemin kottadır.",
    reportText:
        "ℹ️ BİLGİ: Binadan dış havaya (atmosfere) çıkış Zemin Kattan sağlanmaktadır.",
  );

  static final cikisKatiOptionB = ChoiceResult(
    label: "36-0-B",
    uiTitle: "Yalnızca (zemin üstü) normal kattan çıkabiliyorum.",
    uiSubtitle: "Çıkış üst katlardadır.",
    reportText:
        "ℹ️ BİLGİ: Binadan dış havaya çıkış Normal Kattan sağlanmaktadır.",
  );

  static final cikisKatiOptionC = ChoiceResult(
    label: "36-0-C",
    uiTitle: "Yalnızca (zemin altı) bodrum kattan çıkabiliyorum.",
    uiSubtitle: "Çıkış alt kottadır.",
    reportText:
        "ℹ️ BİLGİ: Binadan dış havaya çıkış Bodrum Kattan sağlanmaktadır.",
  );

  static final disMerdOptionA = ChoiceResult(
    label: "36-1-A",
    uiTitle: "Hayır, merdiven etrafındaki duvarlar tamamen sağır (düz duvar).",
    uiSubtitle: "Merdiven etrafında pencere yok.",
    reportText:
        "✅ OLUMLU: Dış kaçış merdiveni etrafında alev sıçrayabilecek açıklık bulunmamaktadır.",
  );
  static final disMerdOptionB = ChoiceResult(
    label: "36-1-B",
    uiTitle:
        "Evet, merdivenin hemen yanında/altında daire pencereleri veya kapılar var.",
    uiSubtitle: "Merdivenin hemen yanında açıklık var.",
    reportText:
        "☢️ KRİTİK RİSK: Açık dış kaçış merdiveninin 3 metre yakınında korunumsuz pencere veya kapı bulunamaz.",
    adviceText:
        "Merdivene 3 metre mesafedeki pencerelerin yangına en az 60 dakika dayanıklı (E60) sabit camlar ile değiştirilmesi veya bu açıklıkların tuğla örülerek kapatılması gerekmektedir.",
  );
  static final disMerdOptionC = ChoiceResult(
    label: "36-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Duvar durumunu bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Dış merdiven çevresindeki açıklıklar bilinmiyor.",
  );

  static final konumOptionA = ChoiceResult(
    label: "36-2-A",
    uiTitle:
        "Birbirlerine uzaklar (Koridorun zıt uçlarındalar / Farklı cephedeler).",
    uiSubtitle: "Koridorun zıt uçlarındalar.",
    reportText:
        "✅ OLUMLU: Merdivenlerin zıt yönlerde olması, alternatif kaçış imkanı sağlar.",
  );
  static final konumOptionB = ChoiceResult(
    label: "36-2-B",
    uiTitle: "Yan yanalar veya birbirlerine çok yakınlar.",
    uiSubtitle: "Birbirlerine bitişikler.",
    reportText:
        "⚠️ UYARI: Kaçış merdivenleri birbirinin alternatifi olmalıdır. Yan yana yapılan merdivenler 'Alternatif Çıkış' sayılmaz. Merdivenler arasında Yönetmeliğe göre olması gereken minimum mesafenin tayini için mimari projenin veya sahadaki mevcut durumun Yangın Güvenlik Uzmanı tarafından hususi olarak incelenmesi gereklidir. ",
    adviceText:
        "Merdivenlerin birbirine olan mesafesi, katın en uzak iki noktasına hizmet edecek şekilde artırılmalı veya merdivenler arasında yangına dayanıklı duman sızdırmaz bölmeler oluşturulmalıdır.",
  );
  static final konumOptionC = ChoiceResult(
    label: "36-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Konumlarını bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Merdiven konumları net değil.",
  );

  static final genislikBilinmiyor = ChoiceResult(
    label: "36-3-BILMIYORUM",
    uiTitle: "Merdiven/Koridor genişliğini bilmiyorum.",
    uiSubtitle: "Ölçüm yapılamadı.",
    reportText: "❓ BİLİNMİYOR: Kaçış yolu genişliği ölçülemedi.",
  );

  static final kapiTipiOptionA = ChoiceResult(
    label: "36-4-A",
    uiTitle: "Tek Kanatlı Kapı.",
    uiSubtitle: "Normal oda kapısı gibi.",
    reportText: "ℹ️ BİLGİ: Çıkış kapısı tek kanatlıdır.",
  );
  static final kapiTipiOptionB = ChoiceResult(
    label: "36-4-B",
    uiTitle: "Çift Kanatlı Kapı.",
    uiSubtitle: "İki yana açılan kapı.",
    reportText: "ℹ️ BİLGİ: Çıkış kapısı çift kanatlıdır.",
  );
  static final kapiTipiOptionC = ChoiceResult(
    label: "36-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kapı tipi belirsiz.",
    reportText: "❓ BİLİNMİYOR: Çıkış kapısı tipi bilinmiyor.",
  );

  static final kapiGenislikBilinmiyor = ChoiceResult(
    label: "36-4-ALT-BILMIYORUM",
    uiTitle: "Kapı net geçiş genişliğini bilmiyorum.",
    uiSubtitle: "Ölçüm yapılamadı.",
    reportText: "❓ BİLİNMİYOR: Çıkış kapısı net genişliği bilinmiyor.",
  );

  static final gorunurlukOptionA = ChoiceResult(
    label: "36-5-A",
    uiTitle: "Evet, açıkça görünüyor ve engel yok.",
    uiSubtitle: "Engel yok.",
    reportText:
        "✅ OLUMLU: Kaçış yolları ve çıkış kapıları açıkça görülebilir durumdadır.",
  );
  static final gorunurlukOptionB = ChoiceResult(
    label: "36-5-B",
    uiTitle: "Hayır, önünde eşyalar var veya görmekte zorlanıyorum.",
    uiSubtitle: "Çıkışlar kapalı veya görünmüyor.",
    reportText:
        "⚠️ UYARI: Çıkışlar her an kullanılabilir durumda ve engelsiz olmalıdır.",
    adviceText:
        "Kaçış yollarındaki tüm engellerin (dolap, saksı, bisiklet vb.) derhal kaldırılması ve çıkış kapılarının önünün 7/24 açık tutulması yasal zorunluluktur.",
  );
  static final gorunurlukOptionC = ChoiceResult(
    label: "36-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Durumu bilmiyorum.",
    reportText:
        "❓ BİLİNMİYOR: Çıkışların erişilebilirliği tespit edilememiştir.",
  );
}

class AppContent {
  static String getQuestionText(int id) {
    switch (id) {
      case 1:
        return "Binanızın yapı ruhsatı hangi tarihte alındı?";
      case 2:
        return "Binanın taşıyıcı sistem ve yapı türü nedir?";
      case 3:
        return "Binanın kat adetleri ve kat yükseklikleri nedir?";
      case 4:
        return "Hesaplanan bina ve yapı yükseklik sınıfları nedir?";
      case 5:
        return "Binanın toplam inşaat alanı ve kat alanları nedir?";
      case 6:
        return "Binada konut harici ticari alanlar bulunmakta mıdır?";
      case 7:
        return "Binada hangi teknik hacimler mevcuttur?";
      case 8:
        return "Bina dış cephe malzemesinin yanıcılık sınıfı nedir?";
      case 9:
        return "Binada otomatik yağmurlama (sprinkler) sistemi var mı?";
      case 10:
        return "Katların baskın kullanım amaçları nelerdir?";
      case 11:
        return "İtfaiye araçlarının binaya yaklaşma mesafesi uygun mu?";
      case 12:
        return "Bina çevresinde itfaiye araçları için ring yolu var mı?";
      case 13:
        return "Yangın kompartımanları ve kapıların ayrımı yapılmış mı?";
      case 14:
        return "İç mekan tavan ve duvar kaplamalarının yanıcılık durumu nedir?";
      case 15:
        return "Zemin kaplamaları ve tesisat geçişleri yalıtılmış mı?";
      case 16:
        return "Dış cephe mantolama malzemesi nedir?";
      case 17:
        return "Çatı kaplama malzemesi ve yalıtımı nedir?";
      case 18:
        return "Acil durum aydınlatma sistemi mevcut mu?";
      case 19:
        return "Acil durum yönlendirme levhaları mevcut mu?";
      case 20:
        return "Kaçış merdivenlerinin tipleri ve adetleri nedir?";
      case 21:
        return "Kaçış merdivenleri önünde Yangın Güvenlik Holü (YGH) var mı?";
      case 22:
        return "Binada İtfaiye (acil durum) asansörü mevcut mu?";
      case 23:
        return "Asansörlerin yangın anındaki davranış modu nedir?";
      case 24:
        return "Kaçış yollarının atmosfere açılan son çıkış noktası nasıldır?";
      case 25:
        return "Döner merdiven kol genişliği ve basamak yapısı uygun mu?";
      case 26:
        return "Kaçış yollarında rampa kullanımı ve eğimi uygun mu?";
      case 27:
        return "Kaçış yolu kapılarının genişliği, yönü ve kilit tipi nedir?";
      case 28:
        return "En uzak noktadan çıkışa olan kaçış mesafesi ne kadardır?";
      case 29:
        return "Teknik hacimlerin genel temizlik durumu nedir?";
      case 30:
        return "Kazan dairesinin konumu ve havalandırması uygun mu?";
      case 31:
        return "Trafo odasının yangın güvenliği ve ayrımı yapılmış mı?";
      case 32:
        return "Jeneratör odasının yangın güvenliği ve ayrımı yapılmış mı?";
      case 33:
        return "Kullanıcı yüküne göre gereken minimum çıkış sayısı nedir?";
      case 34:
        return "Zemin kattaki ticari alanların bağımsız çıkışları var mı?";
      case 35:
        return "Kaçış mesafeleri yönetmelik sınırları içerisinde mi?";
      case 36:
        return "Kaçış merdivenlerinin ve kapılarının genişlik/kapasite uygunluğu nedir?";
      default:
        return "Bölüm $id Analizi";
    }
  }
}

class AppDefinitions {
  static const String yanginGuvenlikHolu =
      "Yangın anında kaçış merdivenlerine duman sızmasını önlemek ve insanların güvenli bir alanda beklemesini sağlamak için tasarlanmış, yangına dayanıklı kapılarla ayrılmış korunaklı hacimdir.";

  static const String yanginDayanimi =
      "Binanın taşıyıcı sisteminin (betonarme/çelik) yangın anında çökmeden yük taşıyabilme süresidir. Pasif koruma (boya, kaplama vb.) bu süreyi artırır.";

  static const String kacisMesafesi =
      "Binadaki herhangi bir noktadan en yakın güvenli çıkışa (merdiven veya dış kapı) kadar olan kuş uçuşu olmayan, yürüme mesafesidir.";

  static const String cikmazKoridor =
      "Kaçış yönünde ilerlerken sadece tek bir çıkışa ulaşılan ve aksi yöne dönülmedikçe başka çıkış imkanı olmayan koridor kısmıdır.";

  static const String basinclandirma =
      "Yangın anında dumanın merdiven yuvasına girmesini engellemek için, fanlar yardımıyla bu alanlarda oluşturulan yüksek hava basıncıdır.";

  static const String yanginKompartimani =
      "Binanın yangına dayanıklı elemanlarla ayrılmış, yangının belirli bir süre boyunca bu alanın dışına çıkması engellenen bölümüdür (Örn: Kazan dairesi).";

  static const String kullaniciYuku =
      "Bir binanın veya bir katın içinde aynı anda bulunabileceği kabul edilen maksimum insan sayısıdır.";

  static const String pasifYanginYalitimiCelik =
      "Çelik elemanların yangın anında taşıma kapasitelerini korumaları için kullanılan yangın geciktirici boya veya levha kaplama gibi önlemlerdir.";
}
