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
    uiTitle: "Bina Oturum (Taban) Alanı",
    uiSubtitle: "Binanın zeminde kapladığı alan büyüklüğü.",
    reportText: "(Sayısal veri olarak saklanır: \"Taban Alanı: X m²\")"
  );

  static final katBrut = ChoiceResult(
    label: "5-2 (Kat Brüt)",
    uiTitle: "Standart Kat Alanı",
    uiSubtitle: "Kat holleri, merdivenler, balkonlar dahil brüt ölçü.",
    reportText: "(Sayısal veri olarak saklanır: \"Kat Alanı: Y m²\")"
  );

  static final toplamInsaat = ChoiceResult(
    label: "5-3 (Toplam)",
    uiTitle: "Toplam İnşaat Alanı",
    uiSubtitle: "Bodrumlar ve çatı dahil tüm katların toplamı.",
    reportText: "(Sayısal veri olarak saklanır: \"Toplam İnşaat Alanı: Z m²\")"
  );

  static final otomatikHesap = ChoiceResult(
    label: "5-Otomatik",
    uiTitle: "OTOMATİK HESAPLA",
    uiSubtitle: "Kat sayısı x Kat alanı formülüyle tahmini hesaplar.",
    reportText: "ℹ️ BİLGİ: Toplam inşaat alanı, kullanıcı beyanına dayalı kat sayısı ve kat alanı verileri kullanılarak sistem tarafından otomatik hesaplanmıştır."
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
    uiTitle: "Yağlı Tip Trafo Odası",
    uiSubtitle: "Yüksek gerilim trafosu.",
    reportText: "☢️ KRİTİK RİSK: Binada Yağlı Tip Trafo bulunmaktadır. Patlama ve yangın riski yüksektir. Binadan bağımsız olarak ek önlemler alınması şarttır."
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
    uiSubtitle: "Binada yüksek riskli alan yok.",
    reportText: "✅ OLUMLU: Binada özel risk taşıyan teknik hacim (Kazan, Jeneratör, Elektrik Odası vb.) bulunmamaktadır."
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
  static final mesafeOptionA = ChoiceResult(
    label: "11-1-A",
    uiTitle: "Hayır, geçmiyor.",
    uiSubtitle: "İtfaiye aracının durabileceği en uzak nokta binaya 45 metreden daha yakındır. İtfaiye, tüm cephelere kolaylıkla müdahale edebilir.",
    reportText: "✅ OLUMLU: İtfaiye yaklaşım mesafesi yeterlidir. Tüm cepheler 45 metre menzil içerisindedir. İtfaiye aracı tüm cephelere kolaylıkla müdahale edebilir."
  );

  static final mesafeOptionB = ChoiceResult(
    label: "11-1-B",
    uiTitle: "Evet, geçiyor.",
    uiSubtitle: "İtfaiye aracının durabileceği en uzak nokta binaya 45 metreden daha fazladır. İtfaiye bazı cephelere ulaşmakta güçlük çekebilir.",
    reportText: "☢️ RİSK: İtfaiye yaklaşım mesafesi sınırın üzerinde gözüküyor. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir. Mevcut durumda binanın bazı cephelerine müdahale edilemeyebilir."
  );

  static final mesafeOptionC = ChoiceResult(
    label: "11-1-C",
    uiTitle: "İtfaiyenin binaya yaklaşım mesafesini bilemiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: İtfaiye yaklaşım mesafesi tarafınızca tahmin edilemedi veya ölçülemedi. Yönetmelik gereği 45 metre yaklaşım mesafesi kuralı yerinde ölçülmeli veya konu hakkında Uzman Görüşü alınması tavsiye edilir."
  );

  static final engelOptionA = ChoiceResult(
    label: "11-2-A",
    uiTitle: "Hayır, engel yok.",
    uiSubtitle: "İtfaiye aracı binaya yaklaşabiliyor. Arada duvar, kapı vs. gibi engeller yok. Bina çevresindeki sokaklar geniş sayılır (en az 4-5m), itfaiye aracı manevra yapabilir.",
    reportText: "✅ OLUMLU: İtfaiye aracı binaya yaklaşabiliyor. Arada duvar, kapı vs. gibi engeller yok. Sokak geniş (en az 4-5m'den geniş) , itfaiye aracı manevra yapabilir."
  );

  static final engelOptionB = ChoiceResult(
    label: "11-2-B",
    uiTitle: "Evet, engel var.",
    uiSubtitle: "İtfaiye aracı binaya yaklaşmakta güçlük çeker veya yaklaşamaz. Arada kapı, duvar, tel, çit vb. fiziksel engeller var. Bina çevresindeki sokaklar dar.",
    reportText: "☢️ RİSK: İtfaiye erişimini zorlaştıran fiziksel engeller (duvar, kapı vs.) tespit edilmiştir. Bina çevresindeki sokakların itfaiye aracının geçebileceği genişlikte (en az 4 metre) olmaları, otomobil parklarının da buna göre düzenlenmeleri önerilir."
  );

  static final engelOptionC = ChoiceResult(
    label: "11-2-C",
    uiTitle: "Binaya yaklaşırken arada engel var mı yok mu bilmiyorum.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Binaya yaklaşım imkanını kısıtlayan bir engel olup olmadığı bilinmiyor. İtfaiye yaklaşım imkanının uygunluğu için mevcut bina çevresinin kontrol edilmesi ve Uzman Görüşü alınması tavsiye edilir."
  );

  static final zayifNoktaOptionA = ChoiceResult(
    label: "11-3-A",
    uiTitle: "İşaretlenmiş veya zayıflatılmış geçiş noktası var.",
    uiSubtitle: "Duvarda itfaiyenin gerektiğinde yıkıp geçebileceği özel geçiş noktaları mevcuttur.",
    reportText: "✅ OLUMLU: İtfaiyenin binaya yaklaşım engeli bulunmasına rağmen, acil durumlar için en az bir duvarda işaretlenmiş zayıf geçiş noktası mevcuttur. Bu alanın önüne otomobil park edilmemelidir."
  );

  static final zayifNoktaOptionB = ChoiceResult(
    label: "11-3-B",
    uiTitle: "Herhangi bir zayıflatılmış geçiş noktası yok.",
    uiSubtitle: "Duvarda itfaiyenin gerektiğinde kullanabileceği için özel bir geçiş noktası veya düzenleme bulunmuyor.",
    reportText: "☢️ KRİTİK RİSK: İtfaiye erişimini engelleyen duvarlarda acil durum geçiş noktası bulunmamaktadır. Yangın anında itfaiyenin binaya ulaşımı imkansız hale gelebilir."
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
    uiTitle: "Ruhsat (veya bina yapım) tarihim 19.12.2007 sonrası.",
    uiSubtitle: "TS 500 standardı uyarınca, binanızın inşa tarihi baz alınarak paspayı ölçülerinin (Kolon ≥ 35mm, Kiriş ≥ 25mm) uygun olduğu varsayılmıştır.",
    reportText: "✅ OLUMLU: TS 500 standardı uyarınca, binanızın inşa tarihi baz alınarak paspayı ölçülerinin (Kolon ≥ 35mm, Kiriş ≥ 25mm) uygun olduğu varsayılmıştır."
  );

  static final betonOptionB = ChoiceResult(
    label: "12-B (Beton)",
    uiTitle: "Binadaki paspayı ölçülerini biliyorum, kendim gireceğim.",
    uiSubtitle: "Betonun içindeki demiri örten beton tabakasının kalınlıklarını biliyorum, kendim bilgi gireceğim.",
    reportText: "(Girilen değerlere göre otomatik üretilir) Örn: \"🚨 RİSK: Kolon paspayı 35mm altında tespit edilmiştir. Bu durum, yangın ısısının demirlere hızla ulaşarak genleşmeye ve betonun patlamasına yol açabilir.\""
  );

  static final betonOptionC = ChoiceResult(
    label: "12-C (Beton)",
    uiTitle: "Paspayı durumunu bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Paspayı kalınlığı bilinmediği için yapısal yangın dayanım tahmini yapılamamıştır. Bu değer, binanın çökme süresi için kritik öneme sahiptir. Statik projenin, Uzman tarafından incelenmesi önerilir."
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
    uiTitle: "Dayanıksız sac, demir, plastik, aluminyum, ahşap vb. kapı bulunmakta.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Otopark kapısı yangına dayanıksızdır. Yönetmelik gereği bu kapı en az 90 dakika yangın dayanımlı, duman sızdırmaz ve kendiliğinden kapanan bir kapı olmalıdır. Mevcut kapı, yangın anında ısı ve dumanı saniyeler içinde yaşam alanlarına geçirebilir."
  );

  static final otoparkOptionC = ChoiceResult(
    label: "13-1-C (Otopark)",
    uiTitle: "Arada kapı yok, direkt açık-serbest geçiş var.",
    uiSubtitle: "Otopark ile merdiven (veya asansör holü) arasında herhangi bir yangın kapısı bulunmamaktadır.",
    reportText: "☢️ KRİTİK RİSK: Otopark ile bina arasında kompartıman ayrımı yoktur! Bir araç yangınında duman doğrudan binanın içine dolarak tüm kaçış yollarını kapatabilir. Acilen yangın duvarı ve kapısı ile ayrım yapılmalıdır."
  );

  static final otoparkOptionD = ChoiceResult(
    label: "13-1-D (Otopark)",
    uiTitle: "Arada böyle bir kapı veya geçiş var mı yok mu emin değilim.",
    uiSubtitle: "Kapının teknik özellikleri hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Otopark kapısının özellikleri bilinmiyor. Kapı yangına dayanıklı olmalıdır. Geçiş noktasıyla ilgili Uzman Görüşü alınması tavsiye edilir."
  );

  static final kazanOptionA = ChoiceResult(
    label: "13-2-A (Kazan D.)",
    uiTitle: "Beton duvar ve dışarı açılan metal yangın kapısı.",
    uiSubtitle: "Kazan dairesi betonarme duvarlarla çevrili ve kapısı kaçış yönüne (dışarı) açılmaktadır.",
    reportText: "✅ OLUMLU: Kazan dairesi yalıtımı ve kapı açılma yönü yönetmeliğe uygundur. Betonarme duvarlar 120 dk, metal kapı ise 90 dk yangın dayanımı sağlayarak binayı koruma altına almaktadır."
  );

  static final kazanOptionB = ChoiceResult(
    label: "13-2-B (Kazan D.)",
    uiTitle: "Kapı plastik/ahşap veya içeriye doğru açılıyor.",
    uiSubtitle: "Kapı malzemesi yangına dayanıksızdır veya açılış yönü bina içine doğrudur.",
    reportText: "☢️ RİSK: Kazan dairesi kapısı yangına dayanıklı olmalı ve mutlaka kaçış yönüne (dışarıya) açılmalıdır. İçeri açılan kapılar, patlama veya panik anında basınç nedeniyle açılamaz hale gelerek içeridekileri hapsedebilir."
  );

  static final kazanOptionC = ChoiceResult(
    label: "13-2-C (Kazan D.)",
    uiTitle: "Kazan dairesi binadan tamamen ayrı bir yerde.",
    uiSubtitle: "Kazan dairesi bina kütlesinin dışında, bahçede veya ayrı bir yapıdadır.",
    reportText: "✅ OLUMLU: Kazan dairesi binadan ayrı bir yerdedir."
  );

  static final kazanOptionD = ChoiceResult(
    label: "13-2-D (Kazan D.)",
    uiTitle: "Duvar ve kapı özelliklerini bilmiyorum.",
    uiSubtitle: "Kazan dairesinin yapısal özellikleri hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Kazan dairesinin duvar ve kapı özellikleri bilinmiyor. Kazan dairesi yalıtımı hayati önem taşır, Uzman Görüşü alınması tavsiye edilir."
  );

  static final asansorOptionA = ChoiceResult(
    label: "13-3-A (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı.",
    uiSubtitle: "Katlardaki asansör kapıları yangın sertifikalı metal kapılardır.",
    reportText: "✅ OLUMLU: Asansör kat / kabin kapıları yangına dayanıklıdır."
  );

  static final asansorOptionB = ChoiceResult(
    label: "13-3-B (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı değil.",
    uiSubtitle: "Kapılar standart, yangın dayanımı olmayan tiptedir.",
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
    uiTitle: "Açıkta veya basit bir bölme ile ayrılmış.",
    uiSubtitle: "Jeneratör korumasız bir alanda veya zayıf bir bölme arkasındadır.",
    reportText: "☢️ RİSK: Jeneratör yakıtı riski taşır, 120 dk dayanıklı bölme şarttır."
  );

  static final jeneratorOptionC = ChoiceResult(
    label: "13-5-C (Jeneratör)",
    uiTitle: "Jeneratör odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın yalıtım ve kapı durumu hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Jeneratör odası özellikleri bilinmiyor. Yanıcı yakıt nedeniyle duvarlarında 120 dk, kapısında 90 dk dayanım şarttır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final elekOdasiOptionA = ChoiceResult(
    label: "13-6-A (Elek. Odası)",
    uiTitle: "Kilitli, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle: "Elektrik panolarının olduğu oda özel bir kapı ile korunmaktadır.",
    reportText: "✅ OLUMLU: Elektrik odası kilitli, yangına dayanıklı ve duman sızdırmaz kapı ile korunmaktadır."
  );

  static final elekOdasiOptionB = ChoiceResult(
    label: "13-6-B (Elek. Odası)",
    uiTitle: "Normal dayanıksız (demir, plastik, ahşap) kapı.",
    uiSubtitle: "Elektrik odasında standart bir kapı mevcuttur.",
    reportText: "⚠️ UYARI: Elektrik odaları yangın başlangıç noktasıdır, yangın dayanım özellikleri olması şarttır."
  );

  static final elekOdasiOptionC = ChoiceResult(
    label: "13-6-C (Elek. Odası)",
    uiTitle: "Elektrik odası özelliklerini bilmiyorum.",
    uiSubtitle: "Odanın kapı ve duvar dayanımı hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Elektrik odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Uzman Görüşü alınması tavsiye edilir."
  );

  static final trafoOptionA = ChoiceResult(
    label: "13-7-A (Trafo)",
    uiTitle: "Kilitli, yangına dayanıklı ve duman sızdırmaz kapı.",
    uiSubtitle: "Trafo odası özel bir yangın kapısı ile korunmaktadır.",
    reportText: "✅ OLUMLU: Trafo odasının kapısı kilitli, yangına dayanıklı ve duman sızdırmaz özelliklidir."
  );

  static final trafoOptionB = ChoiceResult(
    label: "13-7-B (Trafo)",
    uiTitle: "Normal dayanıksız kapı.",
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
    uiTitle: "Metal yangın kapısı veya sac kapı.",
    uiSubtitle: "Depo girişi metal bir kapı ile korunmaktadır.",
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
    uiTitle: "Kalın tuğla veya beton duvar (En az 20cm).",
    uiSubtitle: "Yan bina ile aradaki duvar kalın ve masif bir yapıdadır.",
    reportText: "✅ OLUMLU: Yan bina ile ortak kullanılan duvar kalın tuğla veya betondur (En az 20cm)."
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
class Bolum15Content {
  static final kaplamaOptionA = ChoiceResult(
    label: "15-1-A (Kaplama)",
    uiTitle: "Ahşap parke, laminat, pvc vinil, karo halı",
    uiSubtitle: "Yanıcılık gösterebilen malzemeler.",
    reportText: "(Yüksek Bina İse) ⚠️ UYARI: Binanız yüksek bina statüsünde olduğu için döşeme kaplamalarının 'en az zor alevlenici' sınıfta olması gerekir. Mevcut ahşap/tekstil kaplamalar yangın yükünü artırabilir. Kaplama malzemesinin yangına tepki test raporu sorgulanmalıdır. <br>(Alçak Bina İse) ⚠️ UYARI: Döşeme kaplaması 'en az normal alevlenici' olması gerekir. Kaplama malzemesinin yangına tepki test raporu sorgulanmalıdır."
  );

  static final kaplamaOptionB = ChoiceResult(
    label: "15-1-B (Kaplama)",
    uiTitle: "Taş, seramik, mermer veya özel yanmaz kaplama.",
    uiSubtitle: "Limitli yanıcılık gösteren veya hiç yanmayan malzemeler.",
    reportText: "✅ OLUMLU: Zemin kaplaması olarak binada limitli yanıcılık gösteren veya hiç yanmayan (taş, seramik vb.) malzeme kullanıldığı beyan edilmiştir. Belirtilen malzemeler yangın yükünü artırmaz. Yine de kullanılan zemin kaplama malzemesinin yangına tepki test raporu sorgulanmalıdır."
  );

  static final kaplamaOptionC = ChoiceResult(
    label: "15-1-C (Kaplama)",
    uiTitle: "Kaplama malzemesini bilmiyorum.",
    uiSubtitle: "Zemin kaplamasının cinsi veya yanıcılık sınıfı hakkında bilgim yok.",
    reportText: "❓ BİLİNMİYOR: Zemin kaplamasının yanıcılık sınıfı bilinmiyor. Eğer binanız 21.50m'den yüksekse, kullanılan malzemenin sertifikaları kontrol edilmelidir. Kolay alevlenen malzemeler yangını hızla yayar. Zemin kaplama malzemesinin yangına tepki test raporu sorgulanmalıdır."
  );

  static final yalitimOptionA = ChoiceResult(
    label: "15-2-A (Yalıtım)",
    uiTitle: "Hayır, döşeme betonunun üzerinde ısı yalıtım yok.",
    uiSubtitle: "Köpük, strafor, XPS vb. yanıcı ısı yalıtım malzemeleri.",
    reportText: "✅ OLUMLU: Döşeme betonu altında yanıcı ısı yalıtım malzemesi bulunmamaktadır."
  );

  static final yalitimOptionB = ChoiceResult(
    label: "15-2-B (Yalıtım)",
    uiTitle: "Evet, ısı yalıtımı olarak strafor/köpük/XPS vb. malzeme var.",
    uiSubtitle: "Yanıcı malzemeler.",
    reportText: "(Alt soruya göre belirlenir)<br>Şap Var: ✅ OLUMLU: Yanıcı ısı yalıtım malzemesi en az 2 cm şap ile korunmuştur.<br>Şap Yok: ☢️ KIRMIZI RİSK: Kolay alevlenen yalıtım malzemeleri (köpük, XPS vb.) çıplak şekilde kullanılamaz. Üzeri mutlaka en az 2 cm şap ile örtülmelidir."
  );

  static final yalitimOptionC = ChoiceResult(
    label: "15-2-C (Yalıtım)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Zemin detayını göremiyorum.",
    reportText: "❓ BİLİNMİYOR: Zemin altında yanıcı köpük (XPS, EPS vb. ) olup olmadığı bilinmiyor. Eğer varsa ve üzeri şap ile örtülmediyse, olası bir yangında zehirli gaz yayabilir. Uzman Görüşü alınması tavsiye edilir."
  );

  static final tavanOptionA = ChoiceResult(
    label: "15-3-A (Tavan)",
    uiTitle: "Hayır, tavanlar direkt beton üzeri sıva/boya.",
    uiSubtitle: "Tavanda asma tavan uygulaması yoktur, orijinal beton yüzeydir.",
    reportText: "✅ OLUMLU: Tavanlarda asma tavan bulunmamaktadır. Sıva ve boyalı beton tavanlar yangın yükü oluşturmaz, uygundur."
  );

  static final tavanOptionB = ChoiceResult(
    label: "15-3-B (Tavan)",
    uiTitle: "Evet, asma tavan var.",
    uiSubtitle: "Koridorlarda veya dairelerde tavan seviyesi düşürülmüş, asma tavan yapılmıştır.",
    reportText: "(Alt soruya göre belirlenir)<br>Alçı/Metal: ✅ OLUMLU: Asma tavan malzemesi yanmaz veya zor yanıcı sınıftadır.<br>Ahşap/Plastik: ☢️ KIRMIZI RİSK: Tavan malzemeleri 'en az zor alevlenici' (en az C, s3-d2) sınıfında olmalıdır. Ahşap, plastik veya köpük malzemeler kolay yanar, eriyerek damlar ve kaçış yolunu kapatır. Kullanımı yasaktır."
  );

  static final tavanOptionC = ChoiceResult(
    label: "15-3-C (Tavan)",
    uiTitle: "Tavan malzemesini tanımıyorum.",
    uiSubtitle: "Asma tavan var ancak malzemesinin ne olduğunu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Tavan malzemesinin cinsi bilinmiyor. Eğer tavanınız plastik veya cilalı ahşap ise derhal sökülmelidir, çünkü yangında eriyerek damlar ve kaçışı engeller. Uzman Görüşü alınması tavsiye edilir."
  );

  static final tesisatOptionA = ChoiceResult(
    label: "15-4-A (Tesisat)",
    uiTitle: "Beton, harç veya yanmaz mastik ile tesisat çevresi tam olarak kapatılmış ve sızdırmazlık sağlanmış.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Döşemeden geçen tesisatların çevresi yangına dayanıklı malzeme ile yalıtılmış, alev ve duman geçişi engellenmiştir."
  );

  static final tesisatOptionB = ChoiceResult(
    label: "15-4-B (Tesisat)",
    uiTitle: "Tesisat geçişlerinde boşluklar var veya poliüretan vb. (yanıcı sarı köpük) sıkılarak kapatma yapılmış.",
    uiSubtitle: "",
    reportText: "☢️ KIRMIZI RİSK: Döşemeden geçen tesisatların çevresinde ASLA boşluk kalmamalıdır. Bu boşluklar 'Baca Etkisi' yaparak dumanı ve alevi üst katlara taşır. Sarı poliüretan köpük tesisat geçişlerinde kullanılmamalıdır."
  );

  static final tesisatOptionC = ChoiceResult(
    label: "15-4-C (Tesisat)",
    uiTitle: "Tesisat geçişlerini göremiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Tesisat şaftlarının içindeki yalıtım durumu bilinmiyor. Döşemeden geçen tesisatların çevresinde ASLA boşluk kalmamalıdır. Bu boşluklar 'Baca Etkisi' yaparak dumanı ve alevi üst katlara taşır. Sarı poliüretan köpük tesisat geçişlerinde kullanılmamalıdır."
  );
}
class Bolum16Content {
  static final mantolamaOptionA = ChoiceResult(
    label: "16-1-A (Mantolama)",
    uiTitle: "Klasik Mantolama (EPS, XPS, köpük vb.).",
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
    uiTitle: "Giydirme cephe (Cam, Kompozit vb.).",
    uiSubtitle: "Bina dış yüzeyi alüminyum, cam veya kompozit panellerle kaplanmıştır.",
    reportText: "(Alt soruya göre belirlenir)<br>Boşluk Yok: ✅ OLUMLU: Giydirme cephe ile döşeme arasındaki boşluklar yangına dayanıklı malzeme ile yalıtılmıştır.<br>Boşluk Var: ☢️ KIRMIZI RİSK: Giydirme cephe ile döşeme arasındaki boşluklar, yangını ve dumanı üst katlara taşıyan en tehlikeli noktalardır (Baca Etkisi). Bu boşluklar acilen yalıtılmalıdır."
  );

  static final mantolamaOptionD = ChoiceResult(
    label: "16-1-D (Sıva/Boya)",
    uiTitle: "Sadece sıva ve boya (Yalıtım yok).",
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
    uiTitle: "En az 100 cm yüksekliğinde yangın dayanımlı (beton, tuğla  vb.) dolu yüzey var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Katlar arasındaki yanmaz dolu yüzey yüksekliği 100 cm şartını sağlamaktadır. Bu mesafe, alevin bir kattan diğerine sıçramasını zorlaştırır."
  );

  static final sagirYuzeyOptionB = ChoiceResult(
    label: "16-2-B (Sağır Yüzey)",
    uiTitle: "100 cm’den az dolu yüzey var.",
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
    uiTitle: "Kiremit, Metal Kenet, Beton veya Taş.",
    uiSubtitle: "Çatı yüzeyi yanmaz (A1 sınıfı) malzemelerle kaplanmıştır.",
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
    uiSubtitle: "İçi XPS, EPS, PIR, PUR, poliüretan vb. yanıcı madde dolgulu.",
    reportText: "☢️ RİSK: Yanıcı madde dolgulu sandviç paneller yangını çok hızlı yayar ve söndürülmesi zordur. Taşyünü dolgulu paneller tercih edilmelidir."
  );

  static final kaplamaOptionD = ChoiceResult(
    label: "17-1-D (Kaplama)",
    uiTitle: "Sandviç Panel (İçi yanmaz)",
    uiSubtitle: "İçi taşyünü, cam yünü, mineral yünü vb.. yanmaz veya limitli yanıcı malzeme ile dolgulu.",
    reportText: "✅ OLUMLU: Taşyünü vb. yanmaz malzeme dolgulu sandviç paneller yanmaz özelliktedir ve yangın güvenliği açısından uygundur."
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
    uiTitle: "Taşıyıcılar beton, çelik vb. yanmaz eleman. Yalıtımda taşyünü vb. yanmaz ürün kullanılmıştır.",
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
    uiTitle: "Çatılar arasında yüksek yangın duvarı yok.",
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
    uiTitle: "Evet, ahşap/plastik/köpük var.",
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
    uiTitle: "Döküm boru kullanılmıştır",
    uiSubtitle: "Kalın etli, mineral katkılı veya metal borular kullanılmıştır.",
    reportText: "✅ OLUMLU: Tesisat şaftlarında zor yanıcı (sessiz boru) veya yanmaz (döküm) borular kullanılmıştır."
  );

  static final boruOptionB = ChoiceResult(
    label: "18-2-B (Boru)",
    uiTitle: "Plastik boru ve yangın dayanımlı kelepçe kullanılmıştır.",
    uiSubtitle: "Plastik boruların döşeme geçişlerinde kelepçe var.",
    reportText: "✅ OLUMLU: Plastik boruların kat geçişlerinde 'Yangın Kelepçesi' kullanılarak alev geçişi engellenmiştir."
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
    label: "19-1-A (Engel)",
    uiTitle: "Kaçış yolu temiz ve açık.",
    uiSubtitle: "Kapılar kilitsiz, koridorlarda eşya yok.",
    reportText: "✅ OLUMLU: Kaçış yolları temiz, kapılar kilitsiz ve kolayca açılabilir durumdadır."
  );

  static final engelOptionB = ChoiceResult(
    label: "19-1-B (Engel)",
    uiTitle: "Kapılarda asma kilit var.",
    uiSubtitle: "Yangın merdiveni kapısı kilitlenmiş veya sürgülenmiş.",
    reportText: "☢️ KRİTİK RİSK: Yangın merdiveni kapılarına ASLA kilit, sürgü veya zincir takılamaz. Panik anında anahtar aranmaz. Kapılar her zaman içeriden kolla veya panik barla basınca açılacak şekilde olmalıdır."
  );

  static final engelOptionC = ChoiceResult(
    label: "19-1-C (Engel)",
    uiTitle: "Kaçış koridorlarında veya merdivenlerde eşya, koli, çöp vs. var.",
    uiSubtitle: "Koridorlarda veya sahanlıkta depolama yapılmış.",
    reportText: "☢️ KIRMIZI RİSK: Kaçış yolları ve merdiven sahanlıkları depo alanı değildir. Dumanlı ortamda bu eşyalar takılıp düşmenize ve kaçışın engellenmesine sebep olur. Derhal kaldırılmalıdır."
  );

  static final engelOptionD = ChoiceResult(
    label: "19-1-D (Engel)",
    uiTitle: "Kattan çıkarken başka daireden veya başka mahallerden geçilmesi gerekiyor.",
    uiSubtitle: "Merdivene ulaşmak için yatak odası veya depodan geçiliyor.",
    reportText: "☢️ KIRMIZI RİSK: Kaçış yolu, kilitlenebilir başka bir odanın içinden geçemez. Koridordan direkt merdivene ulaşım sağlanmalıdır."
  );

  static final levhaOptionA = ChoiceResult(
    label: "19-2-A (Levha)",
    uiTitle: "Evet, var ve çalışıyorlar.",
    uiSubtitle: "Işıklı 'ÇIKIŞ' işaretleri mevcut.",
    reportText: "✅ OLUMLU: Kaçış yollarında yönlendirme işaretleri mevcuttur."
  );

  static final levhaOptionB = ChoiceResult(
    label: "19-2-B (Levha)",
    uiTitle: "Hayır, yok veya bozuklar.",
    uiSubtitle: "Yönlendirme işaretleri bulunmuyor veya ışıkları yanmıyor.",
    reportText: "⚠️ UYARI: Yangın anında elektrikler kesilebilir ve duman görüşü kapatabilir. Kaçış yolunu gösteren ışıklı yönlendirme levhaları hayati önem taşır."
  );

  static final levhaOptionC = ChoiceResult(
    label: "19-2-C (Levha)",
    uiTitle: "Var ama yanlış yönü gösteriyorlar.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Yanlış yönlendirme, panik anında insanları tuzağa düşürür. Levhalar sadece gerçek çıkışları göstermelidir."
  );

  static final yanilticiOptionA = ChoiceResult(
    label: "19-3-A (Yanıltıcı)",
    uiTitle: "Hayır, sadece daire ve merdiven kapısı var.",
    uiSubtitle: "Koridorda kafa karıştırıcı başka kapı yok.",
    reportText: "✅ OLUMLU: Koridorda kaçış anında insanları yanıltıcı kapı bulunmamaktadır."
  );

  static final yanilticiOptionB = ChoiceResult(
    label: "19-3-B (Yanıltıcı)",
    uiTitle: "Evet, benzer kapılar var.",
    uiSubtitle: "Depo veya teknik oda kapıları merdivene giriş kapılarına benziyor.",
    reportText: "(Alt soruya göre belirlenir)<br>Etiket Var: ✅ OLUMLU: Kapıların üzerinde ne kapısı olduğu yazması önerilir.<br>Etiket Yok: ⚠️ UYARI: Dumanlı ortamda insanlar her kapıyı çıkış sanabilir. Çıkış olmayan kapıların üzerine 'ÇIKIŞ DEĞİLDİR' veya mahal ismi yazılması önerilir."
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
    uiTitle: "Normal Apartman Merdiveni.",
    uiSubtitle: "Binanın ana sirkülasyon merdiveni.",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption2 = ChoiceResult(
    label: "20-2 (Çok Kat)",
    uiTitle: "Bina İçi 'Kapalı' Yangın Merdiveni.",
    uiSubtitle: "Betonarme, duvarla çevrili, yangın kapısı bulunan merdiven.",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption3 = ChoiceResult(
    label: "20-3 (Çok Kat)",
    uiTitle: "Bina Dışı 'Kapalı' Yangın Merdiveni.",
    uiSubtitle: "Çelik, yangın dayanımlı alçıpanel vb. duvarla çevrili, yangın kapısı olan merdiven",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final cokKatOption4 = ChoiceResult(
    label: "20-4 (Çok Kat)",
    uiTitle: "Bina Dışı 'Açık' Çelik Merdiven.",
    uiSubtitle: "Çelik, genelde kollu-Z tipi merdiven, duvarsız, yangın kapısı olan merdiven",
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
    uiSubtitle: "",
    reportText: "(Sayısal veri olarak saklanır)"
  );

  static final bodrumOptionA = ChoiceResult(
    label: "20-Bodrum-A",
    uiTitle: "Evet, devam ediyor.",
    uiSubtitle: "Üst kat merdiveni bodruma iniyor.",
    reportText: "(Bodrum çıkış sayısı hesabında kullanılır)"
  );

  static final bodrumOptionB = ChoiceResult(
    label: "20-Bodrum-B",
    uiTitle: "Hayır, farklı yerde.",
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
    uiSubtitle: "Merdiven önünde çift kapılı bir hol (oda) var.",
    reportText: "✅ OLUMLU: Yangın merdiveni önünde Yangın Güvenlik Holü (YGH) mevcuttur."
  );

  static final varlikOptionB = ChoiceResult(
    label: "21-1-B (Varlık)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Koridordan direkt merdivene çıkılıyor.",
    reportText: "(Yüksek Bina İse) ☢️ KRİTİK RİSK: 51.50m üzeri binalarda merdiven önünde YGH ZORUNLUDUR. Dumanın merdivene dolmasını bu hol engeller.<br>(Alçak Bina İse) ⚠️ UYARI: Bodrum katlardaki riskli alanlardan merdivene geçişte YGH olması mecburidir."
  );

  static final malzemeOptionA = ChoiceResult(
    label: "21-2-A (Malzeme)",
    uiTitle: "Sıva, boya, beton, mermer.",
    uiSubtitle: "Hol içinde yanmaz malzemeler kullanılmış.",
    reportText: "✅ OLUMLU: YGH içindeki kaplamalar yanmaz özelliktedir."
  );

  static final malzemeOptionB = ChoiceResult(
    label: "21-2-B (Malzeme)",
    uiTitle: "Ahşap, duvar kağıdı, plastik.",
    uiSubtitle: "Hol içinde yanıcı kaplama veya süsleme var.",
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
    uiTitle: "Hayır, itfaiye asansörü yok sadece normal asansör var.",
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
    reportText: "✅ OLUMLU: YGH alanı yeterlidir."
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
    uiTitle: "Evet, 1,8 m2'den geniş ve 1dk 'da en üst kata hızlıca çıkabiliyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: İtfaiye asansörü kabin boyutu ve hızı yeterlidir."
  );

  static final kabinOptionB = ChoiceResult(
    label: "22-4-B (Kabin)",
    uiTitle: "Hayır, küçük veya yavaş.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: İtfaiye asansörü kabini en az 1.8 m² olmalı ve en üst kata 1 dakikada ulaşmalıdır. Aksi takdirde acil müdahale ve tahliye gecikir."
  );

  static final kabinOptionC = ChoiceResult(
    label: "22-4-C (Kabin)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Asansörün teknik kapasitesi bilinmiyor. İtfaiye asansörü kabini en az 1.8 m² olmalı ve en üst kata 1 dakikada ulaşmalıdır. Aksi takdirde acil müdahale ve tahliye gecikir."
  );

  static final enerjiOptionA = ChoiceResult(
    label: "22-5-A (Enerji)",
    uiTitle: "Evet, asansörlerin hepsi jeneratöre bağlı ve 60dk çalışabilir düzeyde.",
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
    uiTitle: "Evet, basınçlandırma var.",
    uiSubtitle: "Asansör kuyusuna temiz hava basan sistem.",
    reportText: "✅ OLUMLU: İtfaiye asansör kuyusu basınçlandırılmıştır."
  );

  static final basincOptionB = ChoiceResult(
    label: "22-6-B (Basınç)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Asansör kuyusuna temiz hava basan sistem yok.",
    reportText: "☢️ RİSK: İtfaiye asansör kuyusu basınçlandırılmalıdır. Aksi takdirde kuyuya duman dolar ve insanlar boğulma tehlikesi geçirir."
  );

  static final basincOptionC = ChoiceResult(
    label: "22-6-C (Basınç)",
    uiTitle: "Sistem var mı yok mu bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kuyu basınçlandırma durumu bilinmiyor. Bu sistem dumanın asansör kuyusuna girmesini engeller."
  );
}
class Bolum23Content {
  static final bodrumOptionA = ChoiceResult(
    label: "23-1-A (Bodrum)",
    uiTitle: "Asansör bodruma inmiyor.",
    uiSubtitle: "Asansör sadece zemin ve üst katlara çalışıyor.",
    reportText: "✅ OLUMLU: Asansör bodrum katlara inmemektedir."
  );

  static final bodrumOptionB = ChoiceResult(
    label: "23-1-B (Bodrum)",
    uiTitle: "İniyor ve kapısı hole açılıyor.",
    uiSubtitle: "Bodrumda asansör önünde korunaklı bir hol var.",
    reportText: "✅ OLUMLU: Asansör bodrum katta yangın güvenlik holüne açılmaktadır."
  );

  static final bodrumOptionC = ChoiceResult(
    label: "23-1-C (Bodrum)",
    uiTitle: "İniyor ve direkt Otoparka/Depoya açılıyor.",
    uiSubtitle: "Asansör kapısı ile otopark arasında engel yok.",
    reportText: "☢️ KRİTİK RİSK: Asansör kuyuları binanın bacası gibidir. Bodrumdaki otoparkta veya kazan dairesinde çıkacak bir yangının dumanı, direkt asansör kapısından kuyuya girer ve saniyeler içinde tüm üst katlara yayılır."
  );

  static final bodrumOptionD = ChoiceResult(
    label: "23-1-D (Bodrum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Bodrum katlardaki asansörlerin hemen önünde mutlaka 'Yangın Güvenlik Holü' olmalıdır. Mevcut durum bilinmiyor."
  );

  static final yanginModuOptionA = ChoiceResult(
    label: "23-2-A (Yangın Modu)",
    uiTitle: "Evet, otomatik iniyor ve kapısını açıyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Asansörlerde yangın modu mevcuttur."
  );

  static final yanginModuOptionB = ChoiceResult(
    label: "23-2-B (Yangın Modu)",
    uiTitle: "Hayır, asansör aksiyon almıyor.",
    uiSubtitle: "Yangın anında normal çalışmasına devam ediyor.",
    reportText: "☢️ RİSK: Asansörlerin yangın anında özel aksiyon alması gereklidir."
  );

  static final yanginModuOptionC = ChoiceResult(
    label: "23-2-C (Yangın Modu)",
    uiTitle: "Bilmiyorum, dikkat etmedim.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Asansörün yangın senaryosu bilinmiyor. Yangın anında asansörde mahsur kalmamak için bu özelliğin varlığı hayati önem taşır."
  );

  static final konumOptionA = ChoiceResult(
    label: "23-3-A (Konum)",
    uiTitle: "Kat koridoruna, kat holüne veya asansör holüne.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Asansör kapıları kat koridoruna açılmaktadır."
  );

  static final konumOptionB = ChoiceResult(
    label: "23-3-B (Konum)",
    uiTitle: "Doğrudan yangın merdiveninin içine.",
    uiSubtitle: "",
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
    uiSubtitle: "",
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
    uiTitle: "Daire kapısı koridora, hole veya apartman boşluğuna çıkılıyor.",
    uiSubtitle: "Daire kapısı bina içine açılıyor.",
    reportText: "(Bu modül atlanır, rapor notu oluşmaz)"
  );

  static final tipOptionB = ChoiceResult(
    label: "24-1-B (Tip)",
    uiTitle: "Daire kapısı dış cephede açık bir kaçış yoluna, terasa veya açık bir koridora çıkılıyor.",
    uiSubtitle: "",
    reportText: "(Analiz devam eder)"
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
    reportText: "(Alt soruya göre belirlenir)<br>Yüksek: ✅ OLUMLU: Pencereler yerden 1.80m yüksekte olduğu için duman kaçış yolunu etkilemez.<br>Alçak: ☢️ RİSK: Dış kaçış geçidine bakan pencereler, yerden en az 1.80 metre yüksekte olmalıdır. Aksi takdirde daireden çıkan alev ve duman, kaçış yolunu kapatır."
  );

  static final kapiOptionA = ChoiceResult(
    label: "24-3-A (Kapı)",
    uiTitle: "Çelik, yangına dayanıklı, duman sızdırmaz, bırakınca kendiliğinden kapanıyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Dış geçide açılan kapı yangına dayanıklı,duman sızdırmaz ve kendiliğinden kapanır özelliktedir."
  );

  static final kapiOptionB = ChoiceResult(
    label: "24-3-B (Kapı)",
    uiTitle: "Dayanıksız, kendiliğinden kapanmıyor.",
    uiSubtitle: "Kapı ahşap, pvc, demir vs.",
    reportText: "⚠️ RİSK: Dış kaçış geçitlerine açılan kapılar en az 30 dakika yangına dayanıklı olmalı ve bırakınca kendiliğinden kapanmalıdır. Aksi halde dairedeki olası yangın, kaçış yolunu bloke edebilir."
  );
}
class Bolum25Content {
  static final kapasiteOptionA = ChoiceResult(
    label: "25-1-A (Kapasite)",
    uiTitle: "Genişlik < 100 cm VEYA Kişi > 25.",
    uiSubtitle: "Merdiven dar veya çok kalabalık bir kata hizmet ediyor.",
    reportText: "☢️ KIRMIZI RİSK: Döner merdivenler 'Zorunlu Çıkış' olarak kabul edilebilmesi için en az 100 cm genişlikte olmalı ve en fazla 25 kişiye hizmet etmelidir. Aksi takdirde kaçış yolu sayılamaz."
  );

  static final kapasiteOptionB = ChoiceResult(
    label: "25-1-B (Kapasite)",
    uiTitle: "Genişlik ≥ 100 cm VE Kişi ≤ 25.",
    uiSubtitle: "Merdiven geniş ve az kişiye hizmet ediyor.",
    reportText: "✅ OLUMLU: Döner merdiven genişliği ve kullanıcı yükü yönetmelik sınırları (100cm / 25 kişi) içerisindedir."
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
}
class Bolum26Content {
  static final varlikOptionA = ChoiceResult(
    label: "26-1-A (Varlık)",
    uiTitle: "Hayır, sadece merdiven var.",
    uiSubtitle: "Binada kaçış yolunda rampa bulunmuyor.",
    reportText: "(Bu modül atlanır, rapor notu oluşmaz)"
  );

  static final varlikOptionB = ChoiceResult(
    label: "26-1-B (Varlık)",
    uiTitle: "Evet, rampa var.",
    uiSubtitle: "Binada kaçış yolunda rampa bulunuyor.",
    reportText: "(Analiz devam eder)"
  );

  static final egimOptionA = ChoiceResult(
    label: "26-2-A (Eğim)",
    uiTitle: "Eğim az (%10'dan az) ve zemin kaymaz.",
    uiSubtitle: "Rahat yürünüyor, zeminde kaymaz bant veya kaymaz malzeme kullanılmıştır.",
    reportText: "✅ OLUMLU: Rampa eğimi ve zemin kaplaması kaçış güvenliğine uygundur."
  );

  static final egimOptionB = ChoiceResult(
    label: "26-2-B (Eğim)",
    uiTitle: "Eğim fazla dik (%10'dan fazla) veya zemin kaygan.",
    uiSubtitle: "Yürürken insanı zorluyor, kayma tehlikesi var.",
    reportText: "☢️ RİSK: Kaçış rampalarının eğimi %10'dan fazla olamaz. Dik ve kaygan rampalar panik anında düşmelere sebep olur. Zemin mutlaka kaymaz malzeme ile kaplanmalıdır."
  );

  static final sahanlikOptionA = ChoiceResult(
    label: "26-3-A (Sahanlık)",
    uiTitle: "Evet, kapı önleri ve dönüşler düz.",
    uiSubtitle: "Rampa başlangıç ve bitişinde düz alanlar var.",
    reportText: "✅ OLUMLU: Rampa sahanlıkları ve kapı önü düzlükleri mevcuttur."
  );

  static final sahanlikOptionB = ChoiceResult(
    label: "26-3-B (Sahanlık)",
    uiTitle: "Hayır, hemen eğim başlıyor.",
    uiSubtitle: "Kapıyı açınca direkt eğimli yüzeye basılıyor.",
    reportText: "⚠️ UYARI: Rampa giriş ve çıkışlarında, kapı önlerinde mutlaka düz sahanlık bulunmalıdır. Kapı açıldığında eğimli yüzeye basmak tehlikelidir."
  );

  static final otoparkOptionA = ChoiceResult(
    label: "26-4-A (Otopark)",
    uiTitle: "Evet, eğimi uygun (%10 'un altı).",
    uiSubtitle: "Araç rampası yürüyerek çıkmaya müsait.",
    reportText: "✅ OLUMLU: Otopark rampası, eğimi uygun olduğu için (tek bodrum katlı otoparklarda) 2. kaçış yolu olarak kabul edilebilir."
  );

  static final otoparkOptionB = ChoiceResult(
    label: "26-4-B (Otopark)",
    uiTitle: "Hayır, çok dik (%10'dan fazla) veya kaygan.",
    uiSubtitle: "Rampayı sadece araçlar kullanabilir, yürümek zor.",
    reportText: "⚠️ BİLGİ: Otopark rampası çok dik (%10'dan fazla) veya kaygan olduğu için kaçış yolu sayılamaz. Otoparkın başka bir yaya çıkışı olmalıdır."
  );
}
class Bolum27Content {
  static final boyutOptionA = ChoiceResult(
    label: "27-1-A (Boyut)",
    uiTitle: "80 cm'den geniş ve eşiksiz (düz ayak).",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Kaçış kapısı genişliği ve zemin düzgünlüğü (eşiksiz olması) uygundur."
  );

  static final boyutOptionB = ChoiceResult(
    label: "27-1-B (Boyut)",
    uiTitle: "80 cm'den dar veya eşik/kasis/çıkıntı var.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Kaçış kapılarında temiz geçiş genişliği en az 80 cm olmalıdır. Ayrıca takılıp düşmeye sebep olacak 'Eşik' bulunması kesinlikle yasaktır."
  );

  static final boyutOptionC = ChoiceResult(
    label: "27-1-C (Boyut)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kapı ölçüleri ve eşik durumu bilinmiyor. Kaçış kapılarında temiz geçiş genişliği en az 80 cm olmalıdır. Ayrıca takılıp düşmeye sebep olacak 'Eşik' bulunması kesinlikle yasaktır. Panik anında dar kapılar yığılmaya, eşikler ise düşmelere sebep olur."
  );

  static final yonOptionA = ChoiceResult(
    label: "27-2-A (Yön)",
    uiTitle: "Dışarıya (Kaçış yönüne) açılıyor.",
    uiSubtitle: "Kapıyı itince açılıyor.",
    reportText: "✅ OLUMLU: Kapı açılış yönü (kaçış yönü) doğrudur."
  );

  static final yonOptionB = ChoiceResult(
    label: "27-2-B (Yön)",
    uiTitle: "İçeriye (Koridora) açılıyor.",
    uiSubtitle: "Kapıyı açmak için kendinize çekmeniz gerekiyor.",
    reportText: "⚠️ UYARI: Kullanıcı yükü 50 kişiyi geçen katlarda kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır. İçeri açılan kapılar, arkadan gelen kalabalığın baskısıyla açılamaz hale gelebilir."
  );

  static final yonOptionC = ChoiceResult(
    label: "27-2-C (Yön)",
    uiTitle: "Döner kapı, turnike veya sürgülü.",
    uiSubtitle: "Otomatik veya döner mekanizmalı kapı.",
    reportText: "☢️ KRİTİK RİSK: Döner kapı ve sürgülü kapı kaçış yolunda kullanılmaz, alternatif kaçış imkanı gerekir. Turnike ise yangın anında boşa düşerek kaçışı serbest hale getiriyorsa kullanılabilir. Yangın anında böyle bir açılma senaryosu oluşturulmadıysa turnike de kullanılamaz."
  );

  static final yonOptionD = ChoiceResult(
    label: "27-2-D (Yön)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Açılış yönünü hatırlamıyorum.",
    reportText: "❓ BİLİNMİYOR: Kapı açılma yönü bilinmiyor. Tüm kapılarda güvenli tahliye için kapının itince açılması önerilir. Bir kattaki kullanıcı yükü 50 kişiyi aşıyorsa itince açılır tipte olması yasal zorunluluktur."
  );

  static final kilitOptionA = ChoiceResult(
    label: "27-3-A (Kilit)",
    uiTitle: "Panik Bar var (İtince açılıyor).",
    uiSubtitle: "Kapı üzerinde yatay bar mekanizması var.",
    reportText: "✅ OLUMLU: Kapıda panik bar mekanizması mevcuttur."
  );

  static final kilitOptionB = ChoiceResult(
    label: "27-3-B (Kilit)",
    uiTitle: "Normal kapı kolu var.",
    uiSubtitle: "Standart çevirmeli kol.",
    reportText: "(Bir katta kullanıcı yükü 100'ü aşıyorsa) ⚠️ UYARI: Binanızın yoğunluğu nedeniyle kapı kolu yerine 'Panik Bar' kullanılması ZORUNLUDUR.<br>(Az Yoğun İse) ✅ OLUMLU: 100 kişinin altındaki yoğunlukta kapı kolu kabul edilebilir."
  );

  static final kilitOptionC = ChoiceResult(
    label: "27-3-C (Kilit)",
    uiTitle: "Kilitli / Anahtar gerekiyor.",
    uiSubtitle: "Kapı kilitli tutuluyor.",
    reportText: "☢️ KRİTİK RİSK: Kaçış yolundaki (özellikle merdivene ulaşan, binadan çıkış sağlayan kapılar) ASLA kilitlenemez. Daire kapıları ve teknik hacim kapıları dışında ortak hollerdeki kaçış kapıları kesinlikle kilitli tutulamaz."
  );

  static final kilitOptionD = ChoiceResult(
    label: "27-3-D (Kilit)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Kilit durumunu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Kilit mekanizması bilinmiyor. Çıkış kapılarının kontrol edilmeleri gerekir. Kaçış yolundaki (özellikle merdivene ulaşan, binadan çıkış sağlayan kapılar) ASLA kilitlenemez. Daire kapıları ve teknik hacim kapıları dışında ortak hollerdeki çıkış kapıları kesinlikle kilitli tutulamaz."
  );

  static final dayanimOptionA = ChoiceResult(
    label: "27-4-A (Dayanım)",
    uiTitle: "Çelik, yangına dayanıklı, duman sızdırmaz, bırakınca kendiliğinden kapanıyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Kapı yangına dayanıklı ve kendiliğinden kapanma özelliğine sahiptir."
  );

  static final dayanimOptionB = ChoiceResult(
    label: "27-4-B (Dayanım)",
    uiTitle: "Dayanıklı, duman sızdırmaz ancak kendiliğinden kapanmıyor.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Yangın kapıları her zaman kapalı durmalı veya kendiliğinden kapanmalıdır (Hidrolik kapı kapatıcı veya yaylı menteşe ile). Açık kalan kapı, dumanın merdivene dolmasına neden olur."
  );

  static final dayanimOptionC = ChoiceResult(
    label: "27-4-C (Dayanım)",
    uiTitle: "Ahşap, PVC veya Cam kapı (dayanıksız)",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Kaçış merdiveni kapıları yangına en az 30-60-90 dakika dayanıklı ve duman sızdırmaz olmalıdır. Ahşap, PVC vb. kapılar yangına çoğunlukla dayanmaz."
  );

  static final dayanimOptionD = ChoiceResult(
    label: "27-4-D (Dayanım)",
    uiTitle: "Kapıların özelliğini bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR: Kapının yangın dayanımı ve sızdırmazlığı bilinmiyor. Uzman Görüşü alınması önerilir."
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
  static final otoparkOptionA = ChoiceResult(
    label: "29-1-A (Otopark)",
    uiTitle: "Hayır, sadece araçlar var.",
    uiSubtitle: "Otopark alanı düzenli.",
    reportText: "✅ OLUMLU: Otopark alanı temizdir, depolama yapılmamıştır."
  );

  static final otoparkOptionB = ChoiceResult(
    label: "29-1-B (Otopark)",
    uiTitle: "Evet, eşya yığınları var.",
    uiSubtitle: "Lastik, koli, eski eşya vb. biriktirilmiş.",
    reportText: "☢️ RİSK: Otopark alanı sadece araç parkı amacıyla dizayn edilir. Eşya yığınları yangını büyütebilir ve söndürme işlemini zorlaştırabilir."
  );

  static final kazanOptionA = ChoiceResult(
    label: "29-2-A (Kazan)",
    uiTitle: "Hayır, sadece kazanlar var.",
    uiSubtitle: "Kazan dairesi boş ve temiz.",
    reportText: "✅ OLUMLU: Kazan dairesinde gereksiz yanıcı madde bulunmamaktadır."
  );

  static final kazanOptionB = ChoiceResult(
    label: "29-2-B (Kazan)",
    uiTitle: "Evet, eşyalar bulunuyor.",
    uiSubtitle: "Odun, kömür, kağıt, eski eşya vb. var.",
    reportText: "☢️ KRİTİK RİSK: Kazan daireleri depo değildir. Yakıt tankının veya kazanın yanında olası bir kıvılcımlanma oradaki eşyaları tutuşturabilir."
  );

  static final catiOptionA = ChoiceResult(
    label: "29-3-A (Çatı)",
    uiTitle: "Hayır, boş ve kilitli.",
    uiSubtitle: "Çatı arası temiz.",
    reportText: "✅ OLUMLU: Çatı arası temiz ve güvenlidir."
  );

  static final catiOptionB = ChoiceResult(
    label: "29-3-B (Çatı)",
    uiTitle: "Evet, depo gibi kullanılıyor.",
    uiSubtitle: "Eski eşyalar, arşiv, hurda var.",
    reportText: "☢️ RİSK: Çatı araları elektrik kontağından en çok yangın çıkan yerlerdir. Buradaki eşyalar yangına katkı sağlar."
  );

  static final asansorOptionA = ChoiceResult(
    label: "29-4-A (Asansör)",
    uiTitle: "Hayır, temiz.",
    uiSubtitle: "Makine dairesinde sadece motor var.",
    reportText: "✅ OLUMLU: Asansör makine dairesi temizdir."
  );

  static final asansorOptionB = ChoiceResult(
    label: "29-4-B (Asansör)",
    uiTitle: "Evet, malzemeler var.",
    uiSubtitle: "Yağ tenekesi, bez vs. yanıcı maddeler var.",
    reportText: "☢️ RİSK: Asansör motorları ısınır. Yanındaki yağlı bezler veya malzemeler tutuşabilir. Makine dairesi depo olarak kullanılamaz."
  );

  static final jeneratorOptionA = ChoiceResult(
    label: "29-5-A (Jeneratör)",
    uiTitle: "Hayır.",
    uiSubtitle: "Sadece jeneratör ve ilgili ekipmanlar var.",
    reportText: "✅ OLUMLU: Jeneratör odası temizdir."
  );

  static final jeneratorOptionB = ChoiceResult(
    label: "29-5-B (Jeneratör)",
    uiTitle: "Evet.",
    uiSubtitle: "Yanıcı malzemeler, eşya vb. bekletiliyor.",
    reportText: "☢️ KRİTİK RİSK: Jeneratör odasında sadece günlük yakıt tankı bulunabilir. Bidonla yakıt saklamak veya eşya koymak yasaktır."
  );

  static final panoOptionA = ChoiceResult(
    label: "29-6-A (Pano)",
    uiTitle: "Hayır.",
    uiSubtitle: "Pano odası boş.",
    reportText: "✅ OLUMLU: Elektrik pano odası temizdir."
  );

  static final panoOptionB = ChoiceResult(
    label: "29-6-B (Pano)",
    uiTitle: "Evet, temizlik malzemesi var.",
    uiSubtitle: "Paspas, süpürge, kağıt saklanıyor.",
    reportText: "☢️ RİSK: Pano odaları kesinlikle boş olmalıdır. Elektrik kontağı anında yanıcı malzemeleri tutuşturur."
  );

  static final trafoOptionA = ChoiceResult(
    label: "29-7-A (Trafo)",
    uiTitle: "Evet, temiz ve havadar.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU. Trafo odası havalandırılıyor ve temiz tutuluyor."
  );

  static final trafoOptionB = ChoiceResult(
    label: "29-7-B (Trafo)",
    uiTitle: "Hayır, menfezler kapalı veya içeride eşya var.",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK. Mesaj: Trafo odaları ısınır ve patlama riski taşır. Havalandırma asla kapatılmamalı ve içerisi depo gibi kullanılmamalıdır."
  );

  static final trafoOptionC = ChoiceResult(
    label: "29-7-C (Trafo)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "❓ BİLİNMİYOR. Mesaj: Trafo odasının durumu bilinmiyor. Yüksek gerilim hattı taşıyan bu odaların havalandırmasının kapanması veya içeride eşya olması yangın veya patlama riskini doğurabilir."
  );

  static final depoOptionA = ChoiceResult(
    label: "29-8-A (Depo)",
    uiTitle: "Hayır, sadece ev eşyası.",
    uiSubtitle: "Yüksek yanıcı madde yok.",
    reportText: "✅ OLUMLU: Depolarda parlayıcı madde tespit edilmemiştir."
  );

  static final depoOptionB = ChoiceResult(
    label: "29-8-B (Depo)",
    uiTitle: "Evet, boya, tiner, LPG tüpü vb. ürünler var.",
    uiSubtitle: "Yanıcı kimyasallar saklanıyor.",
    reportText: "⚠️ UYARI: Apartman altındaki depolarda parlayıcı madde (tiner, benzin, LPG tüpü vb.) saklanmamalıdır."
  );

  static final copOptionA = ChoiceResult(
    label: "29-9-A (Çöp)",
    uiTitle: "Düzenli temizleniyor.",
    uiSubtitle: "Yoğun koku veya gaz birikmesi yok.",
    reportText: "✅ OLUMLU: Çöp odası temizliği uygun gözüküyor."
  );

  static final copOptionB = ChoiceResult(
    label: "29-9-B (Çöp)",
    uiTitle: "Çöpler birikiyor.",
    uiSubtitle: "Hijyen kötü, yoğun koku var.",
    reportText: "☢️ RİSK: Biriken çöpler metan gazı oluşturur ve kendiliğinden yanabilir. Günlük temizlik şarttır."
  );
}
class Bolum30Content {
  static final konumOptionA = ChoiceResult(
    label: "30-1-A (Konum)",
    uiTitle: "Koridora veya hole açılıyor.",
    uiSubtitle: "Arada hol var.",
    reportText: "✅ OLUMLU: Kazan dairesi kapısı koridora açılmaktadır."
  );

  static final konumOptionB = ChoiceResult(
    label: "30-1-B (Konum)",
    uiTitle: "Direkt merdiven boşluğuna açılıyor.",
    uiSubtitle: "Kapıyı açınca merdiven sahanlığı var.",
    reportText: "☢️ KRİTİK RİSK: Kazan dairesi kapısı ASLA doğrudan merdiven boşluğuna açılamaz. Olası bir patlama veya gaz sızıntısında merdiven kullanılamaz hale gelir."
  );

  static final konumOptionC = ChoiceResult(
    label: "30-1-C (Konum)",
    uiTitle: "Binadan ayrı (dış cepheden uzakta veya bahçede).",
    uiSubtitle: "Bina dışında müstakil yapı.",
    reportText: "✅ OLUMLU: Kazan dairesi bina dışındadır."
  );

  static final kapasiteOption = ChoiceResult(
    label: "30-2 (Kapasite)",
    uiTitle: "(Sayısal veya Tahmini Giriş)",
    uiSubtitle: "(Kullanıcı değer girer)",
    reportText: "(Sistem \"Büyük Kazan\" olup olmadığına karar verir)"
  );

  static final kapiOptionA = ChoiceResult(
    label: "30-3-A (Kapı)",
    uiTitle: "1 Adet Kapı.",
    uiSubtitle: "Tek çıkış var.",
    reportText: "(Büyük Kazan İse) ☢️ KRİTİK RİSK: Girdiğiniz bilgilere göre kazan daireniz 'Büyük/Yüksek Kapasiteli' sınıfındadır. Yönetmeliğe göre en az 2 adet çıkış kapısı zorunludur.<br>(Küçük Kazan İse) ✅ OLUMLU: Kapı sayısı yeterlidir."
  );

  static final kapiOptionB = ChoiceResult(
    label: "30-3-B (Kapı)",
    uiTitle: "2 Adet (veya daha fazla).",
    uiSubtitle: "Çift çıkış var.",
    reportText: "✅ OLUMLU: Kazan dairesinde birden fazla çıkış mevcuttur."
  );

  static final havaOptionA = ChoiceResult(
    label: "30-4-A (Hava)",
    uiTitle: "Evet, altta ve üstte menfezler var.",
    uiSubtitle: "Temiz ve kirli hava delikleri mevcut.",
    reportText: "✅ OLUMLU: Kazan dairesi havalandırması (alt ve üst menfez) uygundur."
  );

  static final havaOptionB = ChoiceResult(
    label: "30-4-B (Hava)",
    uiTitle: "Hayır, sadece pencere, menfez vs. yok.",
    uiSubtitle: "Menfez yok, hava sirkülasyonu yetersiz.",
    reportText: "☢️ KIRMIZI RİSK: Temiz hava girişi ve kirli hava çıkışı (baca haricinde) sağlanmazsa verimsiz yanma olur ve karbonmonoksit zehirlenmesi riski doğar."
  );

  static final yakitOptionA = ChoiceResult(
    label: "30-5-A (Yakıt)",
    uiTitle: "Hayır, Doğalgazlı veya Kömürlü.",
    uiSubtitle: "Sıvı yakıt değil.",
    reportText: "(Drenaj sorusu sorulmaz)"
  );

  static final yakitOptionB = ChoiceResult(
    label: "30-5-B (Yakıt)",
    uiTitle: "Evet, Sıvı Yakıtlı.",
    uiSubtitle: "Mazot, Fuel-oil vb.",
    reportText: "(Alt soru açılır)"
  );

  static final drenajOptionA = ChoiceResult(
    label: "30-5-B-1 (Drenaj)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Kanal ve çukur mevcut.",
    reportText: "✅ OLUMLU: Sıvı yakıtlı kazanda drenaj sistemi mevcuttur."
  );

  static final drenajOptionB = ChoiceResult(
    label: "30-5-B-2 (Drenaj)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Zemin düz.",
    reportText: "⚠️ UYARI: Sıvı yakıtlı kazan dairelerinde, yakıt sızıntısını toplayacak drenaj kanalları ve yakıt ayırıcılı pis su çukuru zorunludur."
  );

  static final tupOptionA = ChoiceResult(
    label: "30-6-A (Tüp)",
    uiTitle: "Evet, en az 6kg'lık yangın söndürme tüpü var.",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Yangın söndürme tüpü mevcuttur. Büyük/Yüksek kapasiteli kazan dairelerinde yangın dolabı da olmalıdır."
  );

  static final tupOptionB = ChoiceResult(
    label: "30-6-B (Tüp)",
    uiTitle: "Evet, yangın söndürme tüpü ve yangın dolabı var.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Yangın söndürme ekipmanları tamdır."
  );

  static final tupOptionC = ChoiceResult(
    label: "30-6-C (Tüp)",
    uiTitle: "Hayır, hiçbiri yok.",
    uiSubtitle: "Söndürme cihazı yok.",
    reportText: "☢️ KRİTİK RİSK: Kazan dairesinde en az 1 adet 6 kg'lık Kuru Kimyevi Tozlu yangın söndürme cihazı bulunması yasal zorunluluktur. Büyük/Yüksek kapasiteli kazan dairelerinde yangın dolabı da olmalıdır."
  );
}
class Bolum31Content {
  static final yapiOptionA = ChoiceResult(
    label: "31-1-A (Yapı)",
    uiTitle: "Duvarları beton/tuğla, kapısı dışarıya açılıyor.",
    uiSubtitle: "Yangına dayanıklı duvar ve kapı mevcut.",
    reportText: "✅ OLUMLU: Trafo odası yangın kompartımanı olarak tasarlanmıştır. Duvarlar ve kapı yangına dayanıklıdır."
  );

  static final yapiOptionB = ChoiceResult(
    label: "31-1-B (Yapı)",
    uiTitle: "Kapısı direkt apartman koridoruna açılıyor.",
    uiSubtitle: "Kapı açılınca bina içine duman dolabilir.",
    reportText: "☢️ KRİTİK RİSK: Trafo odasından çıkacak yoğun duman ve ısı, kaçış yollarını (merdivenleri) kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır."
  );

  static final yapiOptionC = ChoiceResult(
    label: "31-1-C (Yapı)",
    uiTitle: "Duvarları ve kapısı yangın dayanımsız.",
    uiSubtitle: "Dayanıklı olmayan beyaz alçıpanel vs. ile dayanıklı olmayan metal, demir, pvc, ahşap kapı vs kullanılmıştır.",
    reportText: "☢️ RİSK: Trafo odası yangın bölmesi (kompartıman) olarak tasarlanmalıdır. Yağlı tip trafo odalarının duvarları 120dk, kapısı 90dk yangına dayanıklı olmalıdır."
  );

  static final tipOptionA = ChoiceResult(
    label: "31-2-A (Tip)",
    uiTitle: "Kuru Tip.",
    uiSubtitle: "Yağsız trafo.",
    reportText: "✅ OLUMLU: Kuru tip trafo kullanıldığı için yağ sızıntısı ve yangın riski düşüktür."
  );

  static final tipOptionB = ChoiceResult(
    label: "31-2-B (Tip)",
    uiTitle: "Yağlı Tip.",
    uiSubtitle: "İçinde soğutma yağı var.",
    reportText: "(Alt soruya göre belirlenir)"
  );

  static final cukurOptionA = ChoiceResult(
    label: "31-2-B-1 (Çukur)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Yağ toplama çukuru mevcut.",
    reportText: "✅ OLUMLU: Yağlı trafo altında toplama çukuru mevcuttur."
  );

  static final cukurOptionB = ChoiceResult(
    label: "31-2-B-2 (Çukur)",
    uiTitle: "Hayır, düz zemin.",
    uiSubtitle: "Çukur yok, yağ etrafa yayılabilir.",
    reportText: "☢️ KRİTİK RİSK: Yağlı trafolarda, ısınan yağın taşması veya tankın delinmesi durumunda yanıcı yağın çevreye yayılmaması için toplama çukuru ZORUNLUDUR."
  );

  static final sondurmeOptionA = ChoiceResult(
    label: "31-3-A (Söndürme)",
    uiTitle: "Evet, dedektörler ve söndürme var.",
    uiSubtitle: "Otomatik sistem mevcut.",
    reportText: "✅ OLUMLU: Trafo odasında otomatik yangın algılama ve söndürme sistemi mevcuttur."
  );

  static final sondurmeOptionB = ChoiceResult(
    label: "31-3-B (Söndürme)",
    uiTitle: "Hayır, hiçbir sistem yok.",
    uiSubtitle: "Sadece manuel müdahale mümkün.",
    reportText: "☢️ RİSK: Trafo odaları kapalı ve kilitli alanlardır. Yangın başladığında dışarıdan fark edilmesi zordur. Otomatik algılama ve söndürme sistemi hayati önem taşır."
  );

  static final cevreOptionA = ChoiceResult(
    label: "31-4-A (Çevre)",
    uiTitle: "Hayır, çevresi ve üstü kuru.",
    uiSubtitle: "Su tesisatı riski yok.",
    reportText: "✅ OLUMLU: Trafo odası çevresinde su tesisatı riski bulunmamaktadır."
  );

  static final cevreOptionB = ChoiceResult(
    label: "31-4-B (Çevre)",
    uiTitle: "Evet, içinden su boruları geçiyor.",
    uiSubtitle: "Odanın içinden boru geçiyor.",
    reportText: "☢️ KRİTİK RİSK: Yüksek gerilim hattının olduğu yerden su borusu geçirilemez! Boru patlarsa su ve elektrik teması büyük bir patlamaya neden olur."
  );

  static final cevreOptionC = ChoiceResult(
    label: "31-4-C (Çevre)",
    uiTitle: "Evet, üstünde banyo/tuvalet var.",
    uiSubtitle: "Üst kat ıslak hacim.",
    reportText: "☢️ RİSK: Trafo odalarının üstü ıslak hacim olamaz. Üst kattan olası bir su sızıntısı trafoya damlarsa ölümcül kazalara ve yangına yol açabilir."
  );
}
class Bolum32Content {
  static final yapiOptionA = ChoiceResult(
    label: "32-1-A (Yapı)",
    uiTitle: "Duvarlar beton/tuğla, kapı yangına dayanıklı ve dışarıya açılıyor.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Jeneratör odası yangın kompartımanı olarak uygundur."
  );

  static final yapiOptionB = ChoiceResult(
    label: "32-1-B (Yapı)",
    uiTitle: "Kapısı direkt apartman koridoruna açılıyor.",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Jeneratör odasından çıkacak zehirli egzoz gazı ve duman, kaçış yollarını kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır."
  );

  static final yapiOptionC = ChoiceResult(
    label: "32-1-C (Yapı)",
    uiTitle: "Duvarlar dayanıksız beyaz alçıpanel vb., kapısı dayanımsız.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Jeneratör odası yangın bölmesi olarak tasarlanmalıdır. Duvarlar ve kapı en az 120 dakika yangına dayanmazsa, yakıt yangını binaya sıçrar."
  );

  static final yakitOptionA = ChoiceResult(
    label: "32-2-A (Yakıt)",
    uiTitle: "Kendi tankında veya gömülü tankta.",
    uiSubtitle: "Güvenli depolama.",
    reportText: "✅ OLUMLU: Yakıt depolama yöntemi güvenlidir."
  );

  static final yakitOptionB = ChoiceResult(
    label: "32-2-B (Yakıt)",
    uiTitle: "Oda içinde bidonlarda/varillerde.",
    uiSubtitle: "Açıkta yedek yakıt var.",
    reportText: "☢️ KRİTİK RİSK: Jeneratör odasında bidonla veya açık kapta yakıt saklamak uygun değildir. Yakıt buharı elektrik kontağından alev alıp patlamaya neden olabilir."
  );

  static final cevreOptionA = ChoiceResult(
    label: "32-3-A (Çevre)",
    uiTitle: "Hayır, çevresi ve üstü kuru, ıslak zemin yok.",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Çevresel su riski bulunmamaktadır."
  );

  static final cevreOptionB = ChoiceResult(
    label: "32-3-B (Çevre)",
    uiTitle: "Evet, içinden su/doğalgaz boruları geçiyor.",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Jeneratör odasından su veya gaz tesisatı geçirilemez. Boru patlaması durumunda suyun elektrikle teması veya gaz kaçağı felakete yol açar."
  );

  static final cevreOptionC = ChoiceResult(
    label: "32-3-C (Çevre)",
    uiTitle: "Evet, üstünde banyo/tuvalet vb. ıslak hacim var.",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Jeneratör odalarının üstü ıslak hacim olamaz. Su sızıntısı kısa devreye yol açar."
  );

  static final egzozOptionA = ChoiceResult(
    label: "32-4-A (Egzoz)",
    uiTitle: "Egzoz dışarıda, havalandırma var.",
    uiSubtitle: "Gaz tahliyesi mümkün.",
    reportText: "✅ OLUMLU: Egzoz gazı bina dışına atılmaktadır."
  );

  static final egzozOptionB = ChoiceResult(
    label: "32-4-B (Egzoz)",
    uiTitle: "Egzoz içeride veya havalandırma yok.",
    uiSubtitle: "Gaz içeride birikme yapabilir.",
    reportText: "☢️ KRİTİK RİSK: Jeneratör egzozu karbonmonoksit içerir. Egzoz sağlanmalı ve mutlaka bina dışına uzatılmalıdır."
  );
}
class Bolum33Content {
  static final normalKatYeterli = ChoiceResult(
    label: "Normal Kat (Yeterli)",
    uiTitle: "Normal Kat Çıkış Sayısı Yeterli",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Normal katlardaki çıkış sayısı yeterli."
  );

  static final normalKatYetersiz = ChoiceResult(
    label: "Normal Kat (Yetersiz)",
    uiTitle: "Normal Kat Çıkış Sayısı Yetersiz",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Normal katlarda kullanıcı yüküne göre [GEREKEN] çıkış gerekirken, sadece [MEVCUT] çıkış var. YETERSİZ."
  );

  static final zeminKatYeterli = ChoiceResult(
    label: "Zemin Kat (Yeterli)",
    uiTitle: "Zemin Kat Çıkış Sayısı Yeterli",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Zemin kat çıkış kapasitesi uygun görünüyor."
  );

  static final zeminKatYetersiz = ChoiceResult(
    label: "Zemin Kat (Yetersiz)",
    uiTitle: "Zemin Kat Çıkış Sayısı Yetersiz",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Zemin kattaki yoğunluk (Örn: Dükkan/Restoran) nedeniyle [GEREKEN] adet bağımsız çıkış kapısı gerekmektedir."
  );

  static final bodrumKatYeterli = ChoiceResult(
    label: "Bodrum Kat (Yeterli)",
    uiTitle: "Bodrum Kat Çıkış Sayısı Yeterli",
    uiSubtitle: "",
    reportText: "✅ OLUMLU: Bodrum katlardaki çıkış sayısı yeterli."
  );

  static final bodrumKatYetersiz = ChoiceResult(
    label: "Bodrum Kat (Yetersiz)",
    uiTitle: "Bodrum Kat Çıkış Sayısı Yetersiz",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Bodrum katlarda kullanıcı yüküne göre [GEREKEN] çıkış gerekirken, bodruma inen sadece [MEVCUT] adet merdiven var. YETERSİZ."
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
  static final tekYonOptionA = ChoiceResult(
    label: "35-1-A (Tek Yön)",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "Mesafeyi metre cinsinden gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)"
  );

  static final tekYonOptionB = ChoiceResult(
    label: "35-1-B (Tek Yön)",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Mesafe uygun görünüyor.",
    reportText: "✅ OLUMLU: Tek yön kaçış mesafesi Yönetmelik sınırları içerisindedir."
  );

  static final tekYonOptionC = ChoiceResult(
    label: "35-1-C (Tek Yön)",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Mesafe çok uzun.",
    reportText: "☢️ RİSK: Tek yön kaçış mesafesi sınırın üzerinde! Yangın anında merdivene ulaşmak uzun sürebilir."
  );

  static final tekYonOptionD = ChoiceResult(
    label: "35-1-D (Tek Yön)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi tahmin edemiyorum.",
    reportText: "❓ BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Bu mesafe, insanların tahliye süresini belirleyen en önemli faktördür. Ölçüm yapılmalıdır."
  );

  static final ciftYonOptionA = ChoiceResult(
    label: "35-2-A (Çift Yön)",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "En yakın çıkışa olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)"
  );

  static final ciftYonOptionB = ChoiceResult(
    label: "35-2-B (Çift Yön)",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "En yakın çıkışa mesafe uygun.",
    reportText: "✅ OLUMLU: En yakın çıkışa kaçış mesafesi yönetmelik sınırları içerisindedir."
  );

  static final ciftYonOptionC = ChoiceResult(
    label: "35-2-C (Çift Yön)",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "En yakın çıkış bile çok uzak.",
    reportText: "☢️ RİSK: En yakın çıkışa mesafe sınırın üzerinde! (Limit: [LİMİT] m)."
  );

  static final ciftYonOptionD = ChoiceResult(
    label: "35-2-D (Çift Yön)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Ölçüm yapılmalıdır."
  );

  static final cikmazOptionA = ChoiceResult(
    label: "35-3-A (Çıkmaz)",
    uiTitle: "Hayır, iki yöne de gidebiliyorum.",
    uiSubtitle: "Koridor sonunda değilim.",
    reportText: "✅ OLUMLU: Daire çıkmaz koridor üzerinde değildir."
  );

  static final cikmazOptionB = ChoiceResult(
    label: "35-3-B (Çıkmaz)",
    uiTitle: "Evet, çıkmaz koridorun ucundayım.",
    uiSubtitle: "Sadece tek yöne gidebiliyorum.",
    reportText: "(Alt soru açılır)"
  );

  static final cikmazOptionC = ChoiceResult(
    label: "35-3-C (Çıkmaz)",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "Yol ayrımına kadar olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)"
  );

  static final cikmazOptionD = ChoiceResult(
    label: "35-3-D (Çıkmaz)",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Çıkmaz koridor kısa.",
    reportText: "✅ OLUMLU: Çıkmaz koridor mesafesi yönetmelik sınırları içerisindedir."
  );

  static final cikmazOptionE = ChoiceResult(
    label: "35-3-E (Çıkmaz)",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Çıkmaz koridor çok uzun.",
    reportText: "☢️ RİSK: Çıkmaz koridor mesafesi sınırın üzerinde! Duman dolduğunda kaçacak yeriniz kalmaz."
  );

  static final cikmazOptionF = ChoiceResult(
    label: "35-3-F (Çıkmaz)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Mesafeyi bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Çıkmaz koridor mesafesi bilinmiyor. Ölçüm yapılmalıdır."
  );
}
class Bolum36Content {
  static final disMerdOptionA = ChoiceResult(
    label: "36-1-A (Dış Merd.)",
    uiTitle: "Hayır, duvarlar sağır.",
    uiSubtitle: "Merdiven etrafında pencere yok.",
    reportText: "✅ OLUMLU: Dış kaçış merdiveni etrafında alev sıçrayabilecek açıklık bulunmamaktadır."
  );

  static final disMerdOptionB = ChoiceResult(
    label: "36-1-B (Dış Merd.)",
    uiTitle: "Evet, pencere/kapı var.",
    uiSubtitle: "Merdivenin hemen yanında açıklık var.",
    reportText: "☢️ RİSK: Açık dış kaçış merdiveninin 3 metre yakınında korunumsuz pencere veya kapı bulunamaz. Daireden çıkan alevler merdiveni sarabilir."
  );

  static final disMerdOptionC = ChoiceResult(
    label: "36-1-C (Dış Merd.)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Duvar durumunu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Dış merdiven çevresindeki açıklıklar bilinmiyor. Yangın anında alevlerin merdivene sıçrama riski kontrol edilmelidir."
  );

  static final konumOptionA = ChoiceResult(
    label: "36-2-A (Konum)",
    uiTitle: "Birbirlerine uzaklar.",
    uiSubtitle: "Koridorun zıt uçlarındalar.",
    reportText: "✅ OLUMLU: Merdivenlerin zıt yönlerde olması, alternatif kaçış imkanı sağlar."
  );

  static final konumOptionB = ChoiceResult(
    label: "36-2-B (Konum)",
    uiTitle: "Yan yanalar veya çok yakınlar.",
    uiSubtitle: "Birbirlerine bitişikler.",
    reportText: "☢️ KRİTİK RİSK: Kaçış merdivenleri birbirinin alternatifi olmalıdır. Yan yana yapılan merdivenler 'Alternatif Çıkış' sayılmaz. Birini duman bastığında diğeri de kullanılamaz."
  );

  static final konumOptionC = ChoiceResult(
    label: "36-2-C (Konum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Konumlarını bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Merdiven konumları net değil. Yönetmeliğe göre iki çıkış arasındaki mesafe, binanın köşegen mesafesinin en az yarısı kadar olmalıdır."
  );

  // Not: Sayısal girişlerin sonuç metinleri hesaplama sonrası kullanılır.
  // Aşağıdakiler raporlama mantığında kullanılacak şablonlardır.
  static final genislikSonucKritik = ChoiceResult(
    label: "36-3 (Genişlik-Kritik)",
    uiTitle: "Genişlik < 80cm",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Kaçış yolu genişliği ASLA 80 cm'den az olamaz!"
  );

  static final genislikSonucRisk = ChoiceResult(
    label: "36-3 (Genişlik-Risk)",
    uiTitle: "Genişlik < 120cm (Yüksek Bina)",
    uiSubtitle: "",
    reportText: "☢️ RİSK: Yüksek binalarda kaçış yolları en az 120 cm olmak zorundadır."
  );

  static final genislikSonucOlumlu = ChoiceResult(
    label: "36-3 (Genişlik-Olumlu)",
    uiTitle: "Genişlik Uygun",
    uiSubtitle: "",
    reportText: "✅ OLUMLU GÖRÜNÜYOR."
  );

  static final kapiTipiOptionA = ChoiceResult(
    label: "36-4-A (Kapı Tipi)",
    uiTitle: "Tek Kanatlı Kapı.",
    uiSubtitle: "Normal kapı.",
    reportText: "(Genişlik kontrolü yapılır)"
  );

  static final kapiTipiOptionB = ChoiceResult(
    label: "36-4-B (Kapı Tipi)",
    uiTitle: "Çift Kanatlı Kapı.",
    uiSubtitle: "İki yana açılan kapı.",
    reportText: "(Genişlik kontrolü yapılır)"
  );

  // Kapı Genişliği Sonuçları
  static final kapiGenSonucKritik = ChoiceResult(
    label: "36-4 (Kapı Gen.-Kritik)",
    uiTitle: "Genişlik < 80cm",
    uiSubtitle: "",
    reportText: "☢️ KRİTİK RİSK: Çıkış kapısı temiz genişliği en az 80 cm olmalıdır."
  );

  static final kapiGenSonucUyari = ChoiceResult(
    label: "36-4 (Kapı Gen.-Uyarı)",
    uiTitle: "Genişlik > 120cm (Tek Kanat)",
    uiSubtitle: "",
    reportText: "⚠️ UYARI: Tek kanatlı kapı en çok 120 cm olabilir. Daha geniş kapılar ağır olduğu için zor açılır."
  );

  static final kapiGenSonucOlumlu = ChoiceResult(
    label: "36-4 (Kapı Gen.-Olumlu)",
    uiTitle: "Genişlik Uygun",
    uiSubtitle: "",
    reportText: "✅ OLUMLU GÖRÜNÜYOR."
  );

  static final gorunurlukOptionA = ChoiceResult(
    label: "36-5-A (Görünürlük)",
    uiTitle: "Evet, açıkça görünüyor.",
    uiSubtitle: "Engel yok.",
    reportText: "✅ OLUMLU: Kaçış yolları ve çıkış kapıları açıkça görülebilir durumdadır."
  );

  static final gorunurlukOptionB = ChoiceResult(
    label: "36-5-B (Görünürlük)",
    uiTitle: "Hayır, önünde eşyalar var.",
    uiSubtitle: "Çıkışlar kapalı veya görünmüyor.",
    reportText: "☢️ RİSK: Çıkışlar her an kullanılabilir durumda ve engelsiz olmalıdır. Önündeki eşyalar derhal kaldırılmalıdır."
  );

  static final gorunurlukOptionC = ChoiceResult(
    label: "36-5-C (Görünürlük)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Durumu bilmiyorum.",
    reportText: "❓ BİLİNMİYOR: Çıkışların erişilebilirliği bilinmiyor. Çıkışlar her an kullanılabilir durumda ve engelsiz olmalıdır. Önündeki eşyalar derhal kaldırılmalıdır."
  );
}
