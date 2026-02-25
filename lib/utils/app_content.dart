import 'package:life_safety/models/choice_result.dart';

class Bolum1Content {
  static final ruhsatSonrasi = ChoiceResult(
    label: "1-A",
    uiTitle: "19.12.2007 ve sonrası.",
    uiSubtitle: "Yeni Bina",
    reportText:
        "BİLGİ: Binanın yapı ruhsat tarihi 19.12.2007 veya sonrasında alındığı için analiz, \"Binaların Yangından Korunması Hakkında Yönetmelik\"(BYKHY) kapsamındaki \"YENİ BİNA\"hükümlerine göre yapılmıştır.",
    level: RiskLevel.info,
  );

  static final ruhsatOncesi = ChoiceResult(
    label: "1-B",
    uiTitle: "19.12.2007 öncesi.",
    uiSubtitle: "Mevcut Bina",
    reportText:
        "BİLGİ: Bina, yapı ruhsat tarihi itibarıyla \"Mevcut Bina\"statüsünde olmasına rağmen, kullanıcı talebi üzerine güncel yönetmeliğin \"YENİ BİNA\"standartlarına göre değerlendirilmiştir. MEVCUT BİNA kriterleri, Binaların Yangından Korunması Hakkında Yönetmeliği 'ndeki YENİ BİNA kriterlerine göre çoğunlukla daha esnektir. Bu sebeple binanız için Yangın Güvenlik Uzmanı tarafından hususi değerlendirme yapılması önerilir. ",
    level: RiskLevel.info,
  );
}

class Bolum2Content {
  static final betonarme = ChoiceResult(
    label: "2-A",
    uiTitle: "Betonarme",
    uiSubtitle:
        "Konut sektöründeki yapıların tamamına yakını betonarmedir. Binada kolon, kiriş, perde beton bulunur.",
    reportText:
        "BİLGİ: Binanın taşıyıcı sistemi BETONARME olarak beyan edilmiştir. Yangın performansı (paspayı vb.) betonarme yapı gereksinimlerine göre değerlendirilmiştir.",
    level: RiskLevel.info,
  );

  static final celik = ChoiceResult(
    label: "2-B",
    uiTitle: "Çelik",
    uiSubtitle:
        "Konut sektöründe nadiren görülür. Binanın iskeleti kalın çelik profillerden oluşur.",
    reportText:
        "BİLGİ: Binanın taşıyıcı sistemi ÇELİK olarak beyan edilmiştir. Çelik yapılar yüksek sıcaklıkta (540°C) taşıma gücünü hızla kaybettiği için, yangın yalıtımı (boya/kaplama) kritik önem taşımaktadır.",
    level: RiskLevel.info,
  );

  static final ahsap = ChoiceResult(
    label: "2-C",
    uiTitle: "Ahşap",
    uiSubtitle: "Binanın ana taşıyıcıları kalın ahşap kolon, kirişten oluşur.",
    reportText:
        "BİLGİ:Binanın taşıyıcı sistemi AHŞAP olarak beyan edilmiştir. Ahşap yapıların yangın performansı, kullanılan kesitlerin kalınlığına bağlı olarak değerlendirilmiştir.",
    level: RiskLevel.info,
  );

  static final yigma = ChoiceResult(
    label: "2-D",
    uiTitle: "Yığma / Kagir (Taş Duvarlı)",
    uiSubtitle:
        "Binada kolon, kiriş olmaz. Tüm yükü taşıyan kalın taş duvarlardır.",
    reportText:
        "BİLGİ: Binanın taşıyıcı sistemi YIĞMA (KAGİR) olarak beyan edilmiştir. Yığma binalarda duvar kalınlıkları (en az 19 cm), yangın performansını belirleyen ana faktördür.",
    level: RiskLevel.info,
  );

  static final bilinmiyor = ChoiceResult(
    label: "2-E",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "Binanın Betonarme olduğu varsayılacaktır.",
    reportText:
        "BİLGİ: Binanın taşıyıcı sistemi net olarak bilinmemektedir. Türkiye'deki yapı stoğunun çoğunluğu betonarme olduğu için risk değerlendirmesi BETONARME yapı varsayımıyla yapılmıştır. Kesin bilgi edinmek için binanın statik projesi incelenmelidir.",
    level: RiskLevel.info,
  );
}

class Bolum3Content {
  static final biliniyor = ChoiceResult(
    label: "3-3-A",
    uiTitle: "Kat yüksekliklerini kendim gireceğim.",
    uiSubtitle: "",
    reportText:
        "BİLGİ:Binanın yükseklik bilgileri beyan edilen kat yükseklik bilgileri üzerinden yapılmıştır.",
    level: RiskLevel.info,
  );

  static final bilinmiyor = ChoiceResult(
    label: "3-3-B",
    uiTitle: "Bilmiyorum, aşağıdaki değerleri kullan.",
    uiSubtitle: "Zemin: 3.5m, Normal: 3m, Bodrum: 3.5m",
    reportText:
        "BİLGİ: Bina kat yükseklikleri net olarak beyan edilmediğinden Uygulama tarafından belirlenen ortalama değerler kullanılmıştır.",
    level: RiskLevel.info,
  );
}

class Bolum4Content {
  static final yukseklikSinifiDusuk = ChoiceResult(
    label: "Bina < 21.5m ve Yapı < 30.5m",
    uiTitle: "YÜKSEK OLMAYAN BİNA",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Bina yüksekliği (bodrum katlar hariç) 21.50m ve yapı yüksekliği (bodrum katlar dahil) 30.50m sınırlarının altında kaldığı için yönetmelik kapsamında YÜKSEK OLMAYAN BİNA sınıfındadır.",
    level: RiskLevel.info,
  );

  static final yukseklikSinifiYuksek = ChoiceResult(
    label: "Bina ≥ 21.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Bina yüksekliği(bodrum katlar hariç)21.50 metre ve üzerinde olduğu için YÜKSEK BİNA sınıfındadır. Yüksek binalar, itfaiyenin üst katlara erişimi ve insan tahliyesi güç olduğu için özel yangın güvenliği önlemleri gerektirir.",
    level: RiskLevel.info,
  );

  static final yukseklikSinifiCokYuksek = ChoiceResult(
    label: "Yapı ≥ 30.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Yapı yüksekliği (bodrum katlar dahil) 30.50 metre ve üzerinde olduğu için YÜKSEK BİNA sınıfındadır. Yüksek binalar, itfaiyenin üst katlara erişimi ve insan tahliyesi güç olduğu için özel yangın güvenliği önlemleri gerektirir.",
    level: RiskLevel.info,
  );

  static final yukseklikSinifiMaksimum = ChoiceResult(
    label: "Yapı ≥ 51.50m",
    uiTitle: "YÜKSEK BİNA",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Yapı yüksekliği (bodrum katlar dahil) 51.50 metre ve üzerinde olduğu için YÜKSEK BİNA sınıfındadır. Yüksek binalar, itfaiyenin üst katlara erişimi ve insan tahliyesi güç olduğu için özel yangın güvenliği önlemleri gerektirir.",
    level: RiskLevel.info,
  );
}

class Bolum5Content {
  static final oturumAlani = ChoiceResult(
    label: "5-1 (Oturum)",
    uiTitle: "Zemin Kat (Taban) Alanı",
    uiSubtitle: "Binanın zemin katının brüt alanı.",
    reportText: "BİLGİ: Zemin Kat (Taban) Alanı:",
    level: RiskLevel.info,
  );

  static final normalKatAlani = ChoiceResult(
    label: "5-2 (Normal)",
    uiTitle: "Normal Kat Alanı",
    uiSubtitle: "Zemin üstü standart bir katın brüt alanı.",
    reportText: "BİLGİ: Normal Kat Alanı:",
    level: RiskLevel.info,
  );

  static final bodrumKatAlani = ChoiceResult(
    label: "5-3 (Bodrum)",
    uiTitle: "Bodrum Kat Alanı",
    uiSubtitle: "Zemin altı standart bir katın brüt alanı.",
    reportText: "BİLGİ: Bodrum Kat Alanı:",
    level: RiskLevel.info,
  );

  static final toplamInsaat = ChoiceResult(
    label: "5-4 (Toplam)",
    uiTitle: "Toplam İnşaat Alanı",
    uiSubtitle: "Tüm katların (Zemin+Normal+Bodrum) toplam brüt alanı.",
    reportText: "BİLGİ: Toplam İnşaat Alanı:",
    level: RiskLevel.info,
  );

  static final otomatikHesap = ChoiceResult(
    label: "5-Otomatik",
    uiTitle: "OTOMATİK HESAPLA",
    uiSubtitle: "Kat sayıları ve alan verileriyle toplamı hesaplar.",
    reportText:
        "BİLGİ: Toplam inşaat alanı Uygulama tarafından otomatik hesaplanmıştır.",
    level: RiskLevel.info,
  );
}

class Bolum6Content {
  static final otoparkVar = ChoiceResult(
    label: "6-1-A (Otopark)",
    uiTitle: "Otopark bulunmaktadır.",
    uiSubtitle: "Zemin (ve/veya bodrum) katta kapalı otopark alanı mevcut.",
    reportText:
        "BİLGİ: Binada kapalı veya yarı-açık (tek cephesinde açıklık olan) otopark alanı bulunmaktadır. Özellikle lpg 'li araçların, elektrik motorlu araçların park edildiği / şarj edildiği otoparklar yangın yükü bakımından konut katlarına göre yüksek olduğundan ek önlemler almak mutlaka şarttır. ",
    level: RiskLevel.info,
  );

  static final ticariVar = ChoiceResult(
    label: "6-1-B (Ticari)",
    uiTitle: "Ticari alanlar bulunmaktadır.",
    uiSubtitle: "Dükkan, mağaza, kafe, ofis, her türlü işyeri vb.",
    reportText:
        "BİLGİ: Binada konut harici ticari kullanım (işyerleri vb.) mevcuttur. Karma kullanımlı binalarda, ticari alanların konutlardan yangın duvarı ile ayrılması önerilmektedir. Özellikle içerisinde endüstriyel mutfak bulunan işletmelerin binanın diğer bölümlerinden ayrılması ve yönetmelikçe belirlenen önlemlerin alınması şiddetle önerilir.",
    level: RiskLevel.info,
  );

  static final depoVar = ChoiceResult(
    label: "6-1-C (Depo)",
    uiTitle: "Depolama alanları bulunmaktadır.",
    uiSubtitle: "Apartman sakinlerine ait ortak eşya deposu.",
    reportText:
        "BİLGİ: Binada konutlara ait ortak depo alanı bulunmaktadır. Depolanan malzemeler yangın yükleri sebebiyle risk oluşturur, depolama alanlarında ek önlemler alınması gereklidir.",
    level: RiskLevel.info,
  );

  static final sadeceKonut = ChoiceResult(
    label: "6-1-D (Sadece Konut)",
    uiTitle: "Konut harici hiçbir alan yok.",
    uiSubtitle: "Sadece daireler var.",
    reportText:
        "BİLGİ: Bina sadece konut amaçlı kullanılmaktadır. Ekstra yangın yükü oluşturabilecek bir fonksiyon bulunmamaktadır. Konut risklerine göre alınacak yangın güvenlik önlemleri yeterli olacaktır.",
    level: RiskLevel.info,
  );

  static final otoparkKapali = ChoiceResult(
    label: "6-2-A (Otopark Tipi)",
    uiTitle: "Otoparkın tavanı, tabanı ve tüm yan duvarları kapalı.",
    uiSubtitle: "Otopark, toprak altında veya duvarları örülü biçimdedir.",
    reportText:
        "BİLGİ (KAPALI OTOPARK): Otoparkın doğal havalandırma imkanı olmadığı için \"Kapalı Otopark\"statüsündedir. Yönetmeliğe göre kapalı otoparklarda alınması gereken, algılama, söndürme, duman tahliye vb. gibi önlemler değerlendirilmeli, elektrik araç şarj istasyonları vs. bulunması halinde mevcut duruma göre, Yönetmelik'te henüz işlenmeyen ancak Yangın Güvenlik Uzmanı tarafından belirlenebilecek ekstra önlemler alınması önerilir. ",
    level: RiskLevel.info,
  );

  static final otoparkAcik = ChoiceResult(
    label: "6-2-B (Otopark Tipi)",
    uiTitle: "Otoparkın karşılıklı İKİ CEPHESİ tamamen açık.",
    uiSubtitle: "Doğal havalandırma mevcut.",
    reportText:
        "BİLGİ: (AÇIK OTOPARK): Otoparkın karşılıklı cepheleri açık olduğu için doğal havalandırma yeterli kabul edilebilir. İçeride duman birikme ihtimali daha düşüktür.",
    level: RiskLevel.info,
  );

  static final otoparkYariAcik = ChoiceResult(
    label: "6-2-C (Otopark Tipi)",
    uiTitle:
        "Otoparkın sadece TEK CEPHESİNDE açıklık var. Diğer cepheleri duvarla örülü.",
    uiSubtitle: "",
    reportText:
        "BİLGİ: (YARI AÇIK OTOPARK): Otoparkta sadece tek cephede açıklık olması duman tahliyesi ve havalandırma için yeterli değildir. \"Kapalı Otopark\"kuralları geçerlidir.",
    level: RiskLevel.info,
  );

  static final buyukRestoranVar = ChoiceResult(
    label: "6-3-A (Büyük Restoran)",
    uiTitle: "Evet, var.",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Ticari alanda büyük restoran (endüstriyel mutfak) olduğu beyan edilmiştir. Endüstriyel mutfaklar yüksek yangın riski taşır. Yönetmelik gereği, ticari alan içerisinde yer alan endüstriyel mutfaklar, binanın diğer kısımlarından en az 120 dakika süreyle yangına dayanıklı duvar ve kapılar ile ayrılmış biçimde konumlandırılır. Aynı anda 100’den fazla kişiye hizmet verebilen restoranların davlumbazlarına otomatik söndürme sistemi yapılması ve ocaklarında kullanılan gazın özelliklerine göre gaz algılama, gaz kesme ve uyarı tesisatının kurulması şarttır.",
    level: RiskLevel.info,
  );

  static final buyukRestoranYok = ChoiceResult(
    label: "6-3-B (Büyük Restoran)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "",
    reportText:
        "Binanın ticari alanında büyük restoran (endüstriyel mutfak) bulunmamaktadır. Ektra önlem alınmasına gerek yoktur.",
    level: RiskLevel.info,
  );

  static final buyukRestoranBilmiyorum = ChoiceResult(
    label: "6-3-C (Büyük Restoran)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Ticari alanda büyük restoran (endüstriyel mutfak) olup olmadığı bilinmemektedir. Endüstriyel mutfaklar yüksek yangın riski taşır. Mevcudiyeti halinde; Yönetmelik gereği, ticari alan içerisinde yer alan endüstriyel mutfaklar, binanın diğer kısımlarından en az 120 dakika süreyle yangına dayanıklı duvar ve kapılar ile ayrılmış biçimde konumlandırılması gerekir. Ayrıca belirli kapasite üzerindeki mutfaklarda otomatik söndürme ve gaz algılama sistemleri zorunludur. Uzman tarafından yerinde tespit yapılması önerilir.",
    level: RiskLevel.info,
  );
}

class Bolum7Content {
  static const String otoparkBilgiNotu =
      "İşaretlemeye çalışmayınız, binada kapalı otopark olup olmadığı bilgisi önceki bölümden alınıp sisteme işlenmiştir. ";

  static final otopark = ChoiceResult(
    label: "7-1 (Otopark)",
    uiTitle: "Kapalı Otopark",
    uiSubtitle: "(Sistem tarafından otomatik işaretlendi)",
    reportText: "Bölüm 6'dan gelen bilgiye göre rapora eklenmiştir.",
    level: RiskLevel.positive,
  );

  static final kazan = ChoiceResult(
    label: "7-2 (Kazan)",
    uiTitle: "Kazan Dairesi / Isı Merkezi",
    uiSubtitle: "Mahal içerisinde ısıtma kazanı (boiler) bulunur.",
    reportText:
        "BİLGİ: Binada kazan dairesi mevcuttur. Basınçlı ekipmanlar ve yakıt sebebiyle binadaki yüksek riskli alanlarından biridir. Kazan dairesi 120 dk yangın dayanımlı duvar ve 90 dk dayanıklı kapı ile binanın diğer alanlarından ayrılmalıdır.",
    level: RiskLevel.info,
  );

  static final asansor = ChoiceResult(
    label: "7-3 (Asansör)",
    uiTitle: "Asansör",
    uiSubtitle: "Kuyu ve makine dairesi dahil.",
    reportText:
        "BİLGİ: Binada asansör mevcuttur. Asansör kuyusunda ve kabininde alevin ve dumanın üst katlara yayılmasında baca görevi gördüğünden özel önlemler alınır.",
    level: RiskLevel.info,
  );

  static final cati = ChoiceResult(
    label: "7-5 (Çatı)",
    uiTitle: "Çatı Arası",
    uiSubtitle: "Çatı ile binanın en üst katı arasında kalan mahal.",
    reportText:
        "BİLGİ: Binada çatı arası ya da çatı katı mevcuttur. Bu alanlarda elektrik tesisatı veya ekipman kaynaklı yangın riski yüksektir. Yanıcı madde depo alanı olarak kullanılmamalıdır.",
    level: RiskLevel.info,
  );

  static final jenerator = ChoiceResult(
    label: "7-6 (Jeneratör)",
    uiTitle: "Jeneratör Odası",
    uiSubtitle: "Bina için yedek güç kaynağının olduğu mahal.",
    reportText:
        "BİLGİ: Binada jeneratör odası mevcuttur. Jeneratörün çalışması için yakıt depolama ve çıkan egzoz gazları nedeniyle yangın ve zehirlenme riski yüksektir. Bu mahal için hususi önlemler alınmalıdır.",
    level: RiskLevel.info,
  );

  static final elektrik = ChoiceResult(
    label: "7-7 (Elektrik)",
    uiTitle: "Elektrik Odası, Pano Odası",
    uiSubtitle:
        "Bina için gerekli olan elektrikli ekipmanların veya cihazların bulunduğu mahal.",
    reportText:
        "BİLGİ: Binada elektrik odası mevcuttur. İstatistiklere göre bina yangınlarının büyük çoğunluğu elektrik panolarından çıkmaktadır. Bu mahal için hususi önlemler alınmalıdır.",
    level: RiskLevel.info,
  );

  static final trafo = ChoiceResult(
    label: "7-8 (Trafo)",
    uiTitle: "Trafo Odası",
    uiSubtitle: "Yüksek gerilim trafosu.",
    reportText:
        "BİLGİ: Binada trafo bulunmaktadır. Yağlı tip trafonun yangın riski yüksektir. Binadan bağımsız olarak ek önlemler alınması şarttır.",
    level: RiskLevel.info,
  );

  static final depo = ChoiceResult(
    label: "7-9 (Depo)",
    uiTitle: "Ortak Depo, Ardiye",
    uiSubtitle: "Konutlara ait eşya saklama alanı.",
    reportText:
        "BİLGİ: Ortak depo alanı mevcuttur. Kontrolsüz eşya yığılması yangın yükünü artırır.",
    level: RiskLevel.info,
  );

  static final cop = ChoiceResult(
    label: "7-10 (Çöp)",
    uiTitle: "Çöp Odası",
    uiSubtitle: "Daire çöplerinin biriktirildiği ufak odalar.",
    reportText:
        "BİLGİ: Çöp odası mevcuttur. Biriken çöplerden çıkan metan gazı yanıcıdır. Havalandırma şarttır. Ayrıca yangın yükü sebebiyle bu odalarda ek önlemler alınması şarttır.",
    level: RiskLevel.info,
  );

  static final siginak = ChoiceResult(
    label: "7-11 (Sığınak)",
    uiTitle: "Sığınak",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Binada sığınak mevcuttur. Havalandırma, duman tahliye, yanıcı madde bulundurulmaması, hol, hususi jeneratör vb. gibi ek önlemler alınması şarttır. Sığınak Yönetmeliği 2025 yılında güncellenmiştir, bu Yönetmelik kriterlerine göre sığınakta yeni düzenlemeler yapmak gerekebilir.",
    level: RiskLevel.info,
  );

  static final duvar = ChoiceResult(
    label: "7-12 (Duvar)",
    uiTitle: "Ortak Duvar",
    uiSubtitle: "Yan bina ile bitişikliği sağlayan aradaki duvar.",
    reportText:
        "BİLGİ: Yan bina ile ortak duvar mevcuttur. Komşu binada çıkacak bir yangının geçişini engellemek için duvarın yangına dayanıklı olması gerekir.",
    level: RiskLevel.info,
  );

  static final endustriyelMutfak = ChoiceResult(
    label: "7-13 (Endüstriyel Mutfak)",
    uiTitle: "Endüstriyel Mutfak (Büyük Restoran)",
    uiSubtitle: "Bölüm 6'daki seçiminize istinaden eklenmiştir.",
    reportText:
        "BİLGİ: Binada endüstriyel mutfak (büyük restoran) mevcuttur. Yangın Yönetmeliği Madde 57/3'e göre mutfak ve çay ocakları binanın diğer kısımlarından en az 120 dakika süreyle yangına dayanıklı bölmeler ile ayrılmış biçimde konumlandırılmalıdır.",
    level: RiskLevel.info,
  );
}

class Bolum8Content {
  static final ayrikNizam = ChoiceResult(
    label: "8-1-A",
    uiTitle: "Ayrık Nizam",
    uiSubtitle:
        "Binanın dört cephesi de açıktır, herhangi bir binaya yapışık veya bitişik değildir.",
    reportText:
        "BİLGİ: Bina AYRIK NİZAM olarak beyan edilmiştir. Bu durum, komşu binalardan yangın sirayeti riskini azaltır, cephe ve çatı yangın tedbirlerinde esneklik sağlar.",
    level: RiskLevel.info,
  );

  static final bitisikNizam = ChoiceResult(
    label: "8-1-B",
    uiTitle: "Bitişik Nizam",
    uiSubtitle: "Binanın en az bir cephesi yan binaya yapışık veya bitişiktir.",
    reportText:
        "BİLGİ: Bina BİTİŞİK NİZAM olarak beyan edilmiştir. Bitişik nizam yapılarda, komşu bina ile ortak kullanılan duvarların yangın dayanım özelliği ve çatı birleşim detayları kritik öneme sahiptir.",
    level: RiskLevel.info,
  );
}

class Bolum9Content {
  static final tamKapsam = ChoiceResult(
    label: "9-1-A",
    uiTitle: "Evet, tüm binada otomatik söndürme sistemi var.",
    uiSubtitle: "Daireler, koridorlar, (varsa) dükkanlar, otopark dahil.",
    reportText:
        "BİLGİ: Binanın tüm katlarında ve tüm alanlarında otomatik yağmurlama (sprinkler) sistemi mevcuttur. Bu sistem, yangın anında kaçış mesafesi toleransını artırır ve yangın güvenliğini daha üst seviyeye taşır.",
    level: RiskLevel.info,
  );

  static final yok = ChoiceResult(
    label: "9-1-B",
    uiTitle: "Hayır, hiçbir yerde yok.",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Binanın hiçbir yerinde otomatik yağmurlama (sprinkler) sistemi bulunmamaktadır. Bu durumda kaçış mesafesi limitleri minimum değerler üzerinden değerlendirilmektedir. Sprinkler sistemi olmaması kaçış mesafeleri ve can güvenliği açısından dezavantaj yaratır. Yangın Yönetmeliği-Madde 96 'ya göre belli özelliklerdeki konutlarda, otoparklarda, işyerlerinde otomatik söndürme sistemi mecburiyeti doğabilmektedir. Bu Uygulama içerisinde yer alan Aktif Sistem Gereksinimleri çıktısında binanın sprinkler sistemi ihtiyacı belirtilmekteidir. Bu çıktıda sprinkler sistemi zorunlu olmadığı belirtilse bile proje üzerinde kat ve mahal bazında hususi çalışma yapılması mutlaka önerilir. ",
    level: RiskLevel.info,
  );

  static final kismen = ChoiceResult(
    label: "9-1-C",
    uiTitle: "Kısmen var.",
    uiSubtitle: "Sadece bazı katlarda veya bazı mahallerde var.",
    reportText:
        "BİLGİ: Sprinkler sistemi binada kısmi olarak bulunuyor. Yönetmelik gereği, kaçış güvenliği hesaplarında sistemin \"YOK\"olduğu varsayılacaktır. Sprinkler sisteminin binada kısmi bulunması, kaçış mesafeleri ve can güvenliği açısından dezavantaj yaratır. Bu Uygulama içerisinde yer alan Aktif Sistem Gereksinimleri çıktısında binanın sprinkler sistemi ihtiyacı belirtilmekteidir. Bu çıktıda sprinkler sistemi zorunlu olmadığı belirtilse bile proje üzerinde kat ve mahal bazında hususi çalışma yapılması mutlaka önerilir. ",
    level: RiskLevel.info,
  );

  static final davlumbazVar = ChoiceResult(
    label: "9-2-A (Davlumbaz)",
    uiTitle: "Evet, var.",
    uiSubtitle:
        "Endüstriyel mutfak davlumbazında otomatik söndürme sistemi var.",
    reportText:
        "OLUMLU: Endüstriyel mutfak davlumbazında otomatik söndürme sistemi olduğu beyan edilmiştir. Yangın Yönetmeliği Madde 57/1 gereği, alışveriş merkezleri, yüksek binalar içinde bulunan mutfaklar ve yemek fabrikaları ile bir anda 100'den fazla kişiye hizmet veren mutfakların davlumbazlarına otomatik söndürme sistemi yapılması şarttır.",
    level: RiskLevel.positive,
  );

  static final davlumbazYok = ChoiceResult(
    label: "9-2-B (Davlumbaz)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Davlumbazda otomatik söndürme sistemi bulunmuyor.",
    reportText:
        "KRİTİK RİSK: Endüstriyel mutfak davlumbazında otomatik söndürme sistemi bulunmamaktadır. Yangın Yönetmeliği Madde 57/1 gereği, alışveriş merkezleri, yüksek binalar içinde bulunan mutfaklar ve yemek fabrikaları ile bir anda 100'den fazla kişiye hizmet veren mutfakların davlumbazlarına otomatik söndürme sistemi yapılması ve ocaklarda kullanılan gazın özelliklerine göre gaz algılama, gaz kesme ve uyarı tesisatının kurulması şarttır.",
    adviceText:
        "Endüstriyel mutfak davlumbazlarına ivedilikle otomatik söndürme sistemi tesis edilmelidir.",
    level: RiskLevel.critical,
  );

  static final davlumbazBilmiyorum = ChoiceResult(
    label: "9-2-C (Davlumbaz)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Endüstriyel mutfak davlumbazında otomatik söndürme sistemi bulunup bulunmadığı bilinmemektedir. Yangın Yönetmeliği Madde 57/1 gereği kapsam içindeki mutfakların davlumbazlarına otomatik söndürme sistemi yapılması şarttır. Uzman kontrolü önerilir.",
    level: RiskLevel.unknown,
  );
}

class Bolum10Content {
  static final konut = ChoiceResult(
    label: "10-A",
    uiTitle: "Konut.",
    uiSubtitle: "Daire, mesken",
    reportText: "(Kullanıcı yükü hesabında 20 m²/kişi alınır.)",
    level: RiskLevel.positive,
  );

  static final azYogunTicari = ChoiceResult(
    label: "10-B",
    uiTitle: "Az yoğun ticari alan.",
    uiSubtitle: "Büro, ofis, oto galeri vb.",
    reportText: "(Kullanıcı yükü hesabında 10 m²/kişi alınır.)",
    level: RiskLevel.positive,
  );

  static final ortaYogunTicari = ChoiceResult(
    label: "10-C",
    uiTitle: "Orta yoğun ticari alan.",
    uiSubtitle: "Market, mağaza, dükkan, banka şubesi vb.",
    reportText: "(Kullanıcı yükü hesabında 5 m²/kişi alınır.)",
    level: RiskLevel.positive,
  );

  static final yuksekYogunTicari = ChoiceResult(
    label: "10-D",
    uiTitle: "Yüksek yoğun ticari alan.",
    uiSubtitle: "Restaurant, kafe, spor salonu vb.",
    reportText: "(Kullanıcı yükü hesabında 1.5 m²/kişi alınır.)",
    level: RiskLevel.positive,
  );

  static final teknikDepo = ChoiceResult(
    label: "10-E",
    uiTitle: "Depo, teknik hacim, otopark.",
    uiSubtitle: "İnsan yoğunluğu az olan alan.",
    reportText: "(Kullanıcı yükü hesabında 30 m²/kişi alınır.)",
    level: RiskLevel.positive,
  );
}

class Bolum11Content {
  // --- ADIM 1: MESAFE ---
  static final mesafeOptionA = ChoiceResult(
    label: "11-1-A",
    uiTitle: "Hayır, aşmıyor.",
    uiSubtitle:
        "İtfaiye aracı binanın tüm cephelerine 45 metre içerisinde ulaşabilmektedir.",
    reportText:
        "OLUMLU: İtfaiye yaklaşım mesafesi yeterli (tüm cepheler 45 metre menzil içerisinde) gözükmektedir. Bunun yanısıra itfaiyenin manevra yapabileceği alanların yeterli olup olmadığı yerinde kontrol edilmesi önerilir.",
    level: RiskLevel.positive,
  );

  static final mesafeOptionB = ChoiceResult(
    label: "11-1-B",
    uiTitle: "Evet, aşıyor.",
    uiSubtitle:
        "İtfaiye aracı binanın tüm cephelerine 45 metre içerisinde ulaşamaz.",
    reportText:
        "KRİTİK RİSK: İtfaiye yaklaşım mesafesi sınırın üzerindedir. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir. Mevcut durumda binanın bazı cephelerine müdahale edilemeyebilir. Bunun yanısıra itfaiyenin manevra yapabileceği alanın yeterli olup olmadığı yerinde kontrol edilmesi önerilir.",
    level: RiskLevel.critical,
  );

  static final mesafeOptionC = ChoiceResult(
    label: "11-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "UYARI: Uzman Görüşü alınması tavsiye edilir. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir. Bu konunun yanısıra itfaiyenin manevra yapabileceği alanın yeterli olup olmadığı kontrol edilmelidir.",
    level: RiskLevel.warning,
  );

  // --- ADIM 2: ENGEL ---
  static final engelOptionA = ChoiceResult(
    label: "11-2-A",
    uiTitle: "Hayır, engel yok.",
    uiSubtitle:
        "Araç binanın dibine kadar gelebiliyor, engelleyen bir duvar yok.",
    reportText:
        "OLUMLU: İtfaiye aracı binaya yaklaşabiliyor, fiziksel engel bulunmuyor. İtfaiyenin binaya yaklaşmasına engel teşkil edebilecek kilitli kapılar olsa bile bina güvenliği veya yönetim tarafından açılabiliyor.",
    level: RiskLevel.positive,
  );

  static final engelOptionB = ChoiceResult(
    label: "11-2-B",
    uiTitle: "Evet, duvar, kapı, çit gibi engel mevcut.",
    uiSubtitle: "İtfaiye aracı binaya kolayca erişemiyor.",
    reportText:
        "KRİTİK RİSK: İtfaiye erişimini zorlaştıran fiziksel engeller (duvar, kapı vs.) tespit edilmiştir. Bu engellerin kaldırılması veya yıkılabilir geçiş bölgesi oluşturulması gerekmektedir.",
    level: RiskLevel.critical,
  );

  static final engelOptionC = ChoiceResult(
    label: "11-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "UYARI: İtfaiye yaklaşım mesafesi sınırın üzerinde olabilir. Yönetmeliğe göre itfaiye aracı, binanın her cephesine (arka cepheler dahil) en fazla 45 metre mesafede yaklaşabilmelidir. Mevcut durumda binanın bazı cephelerine müdahale edilemeyebilir. Bunun yanısıra itfaiyenin manevra yapabileceği alanın yeterli olup olmadığı yerinde kontrol edilmesi önerilir.",
    level: RiskLevel.warning,
  );

  // --- ADIM 3: ZAYIF NOKTA ---
  static final zayifNoktaOptionA = ChoiceResult(
    label: "11-3-A",
    uiTitle: "Evet, var.",
    uiSubtitle: "İşaretlenmiş veya zayıflatılmış geçiş noktası mevcut.",
    reportText:
        "OLUMLU: Duvar, çit, kapı vb. engeli var ancak yıkılabilir geçiş bölgesi mevcut. Lütfen bu alanın önüne araç park edilmemesine dikkat ediniz.",
    level: RiskLevel.positive,
  );

  static final zayifNoktaOptionB = ChoiceResult(
    label: "11-3-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Herhangi bir zayıflatılmış geçiş noktası yok.",
    reportText:
        "KRİTİK RİSK: İtfaiye erişimini engelleyen duvarlarda, acil durum geçişi için zayıflatılmış ve işaretlenmiş özel bir bölüm bulunmak zorundadır. Aksi takdirde itfaiye binaya ulaşamaz.",
    level: RiskLevel.critical,
  );
}

class Bolum12Content {
  static final celikOptionA = ChoiceResult(
    label: "12-A (Çelik)",
    uiTitle: "Evet, var.",
    uiSubtitle:
        "Çelik kolon ve kirişlerin üzeri yangın geciktirici boya, püskürtme sıva, alçıpanel vb. yöntem ile kaplanmıştır.",
    reportText:
        "OLUMLU: Çelik taşıyıcı sistem üzerinde pasif yangın yalıtım uygulaması mevcuttur. Bu uygulama, yangın anında çeliğin kritik sıcaklık olan 540°C'ye ulaşmasını geciktirerek binanın çökme riskini minimize eder.",
    level: RiskLevel.positive,
  );

  static final celikOptionB = ChoiceResult(
    label: "12-B (Çelik)",
    uiTitle: "Hayır yok, çelik taşıyıcı profiller çıplak halde.",
    uiSubtitle:
        "Binanın iskeletini oluşturan çelik elemanlar üzerinde herhangi bir kaplama bulunmamaktadır.",
    reportText:
        "KRİTİK RİSK: Çelik taşıyıcı elemanlar üzerinde herhangi bir pasif yangın yalıtımı bulunmamaktadır.",
    level: RiskLevel.critical,
  );

  static final celikOptionC = ChoiceResult(
    label: "12-C (Çelik)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çelik elemanlarda yangın koruması olup olmadığı bilinmiyor. Koruma yoksa, yangın anında bina taşıma kapasitesini hızla kaybedebilir.",
    level: RiskLevel.unknown,
  );
  static final betonOptionA = ChoiceResult(
    label: "12-A (Beton)",
    uiTitle: "Bina yapım tarihimiz 2000 yılı sonrası.",
    uiSubtitle:
        "TS 500 standardı uyarınca, paspayı ölçülerinin (Kolon ≥ 35mm, Kiriş ≥ 25mm, Döşeme ≥ 20mm) uygun olduğu varsayılmıştır.",
    reportText:
        "OLUMLU: TS 500 standardı uyarınca, binanızın inşa tarihi baz alınarak paspayı ölçülerinin uygun olduğu varsayılmıştır.",
    level: RiskLevel.warning,
  );

  static final betonOptionB = ChoiceResult(
    label: "12-B (Beton)",
    uiTitle: "Binadaki paspayı ölçülerini biliyorum, kendim gireceğim.",
    uiSubtitle:
        "Betonun içindeki demiri örten tabaka kalınlıklarını manuel gireceğim.",
    reportText: "(Girilen değerlere göre otomatik analiz edilir)",
    level: RiskLevel.positive,
  );

  // YENİ EKLENEN C ŞIKKI
  static final betonOptionC = ChoiceResult(
    label: "12-C (Beton)",
    uiTitle: "Bina yapım tarihimiz 2000 yılı öncesi.",
    uiSubtitle:
        "Eski standartlara göre inşa edilen yapılarda paspayı koruması zayıf olabilir.",
    reportText:
        "UYARI: Bina yapım tarihi 2000 yılı öncesi olduğu için paspayı ölçülerinin (demir üzerindeki beton tabakası) güncel TS 500 standartlarını karşılamama ihtimali yüksektir. Yangın anında taşıyıcı sistemin korunması için detaylı inceleme yapılmalıdır.",
    level: RiskLevel.warning,
  );

  static final ahsapOptionA = ChoiceResult(
    label: "12-A (Ahşap)",
    uiTitle: "İnce keresteler (10 cm'den ince).",
    uiSubtitle:
        "Taşıyıcı kolon ve kirişler ince ahşap plakalardan veya kerestelerden oluşmaktadır.",
    reportText:
        "KRİTİK RİSK: İnce ahşap kesitler yangında çok hızlı yanarak (yaklaşık 0.8mm/dk) taşıma gücünü kaybeder. Bu durum, yangın başlangıcından kısa süre sonra binanın çökme riskini doğurur.",
    level: RiskLevel.critical,
  );

  static final ahsapOptionB = ChoiceResult(
    label: "12-B (Ahşap)",
    uiTitle: "Kalın kütükler / Lamine kirişler.",
    uiSubtitle:
        "Taşıyıcı sistemde 10 cm'den daha kalın, masif veya lamine ahşap elemanlar kullanılmıştır.",
    reportText:
        "OLUMLU: Kalın kesitli ahşaplar, yangın anında dış yüzeyi kömürleşerek iç kısmını korur ve yangına daha uzun süre direnç gösterir.",
    level: RiskLevel.positive,
  );

  static final yigmaOptionA = ChoiceResult(
    label: "12-A (Yığma)",
    uiTitle: "Evet, duvarlar kalın (19 cm +).",
    uiSubtitle:
        "Binanın yükünü taşıyan dış duvarlar en az bir tuğla boyu (19 cm) veya daha kalındır.",
    reportText:
        "OLUMLU: En az 19 cm kalınlığındaki kagir duvarlar, yönetmeliklere uygun inşa edildiyse yüksek yangın dayanımı sağlayarak binanın stabilitesini korur.",
    level: RiskLevel.positive,
  );

  static final yigmaOptionB = ChoiceResult(
    label: "12-B (Yığma)",
    uiTitle: "Hayır, daha ince duvarlar var.",
    uiSubtitle: "Taşıyıcı duvarların kalınlığı 19 cm'den daha azdır.",
    reportText:
        "UYARI: Taşıyıcı duvar kalınlığı 19 cm'den az ise yangın anında yeterli yapısal stabilite sağlanamayabilir. Uzman tarafından kontrol edilmesi önerilir.",
    level: RiskLevel.warning,
  );
}

class Bolum13Content {
  static final otoparkOptionA = ChoiceResult(
    label: "13-1-A (Otopark)",
    uiTitle:
        "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan yangın kapısı var.",
    uiSubtitle: "Duvarları da yangına dayanıklı",
    reportText:
        "OLUMLU: Otopark ile bina arasındaki geçişte yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan yangın kapısı mevcuttur. Bu kapı, olası bir araç yangınında dumanın merdiven boşluğuna dolmasını engelleyerek kaçış güvenliğini sağlar.",
    level: RiskLevel.positive,
  );

  static final otoparkOptionB = ChoiceResult(
    label: "13-1-B (Otopark)",
    uiTitle:
        "Yangına dayanıksız sac, demir, plastik, aluminyum, ahşap vb. kapı var.",
    uiSubtitle: "Veya duvarları yangına dayanıklı değil",
    reportText:
        "KRİTİK RİSK: Otopark kapısı yangına dayanıksızdır. Yönetmelik gereği bu kapı en az 90 dakika yangın dayanımlı, duman sızdırmaz ve kendiliğinden kapanan bir kapı olmalıdır. Mevcut kapı, yangın anında ısı ve dumanı saniyeler içinde yaşam alanlarına geçirebilir.",
    level: RiskLevel.critical,
  );

  static final otoparkOptionC = ChoiceResult(
    label: "13-1-C (Otopark)",
    uiTitle: "Arada kapı yok, direkt açık (serbest) geçiş var.",
    uiSubtitle:
        "Otopark ile merdiven arasında herhangi bir yangın kapısı bulunmuyor.",
    reportText:
        "KRİTİK RİSK: Otopark ile bina arasında yangına dayanıklı ayrım (kompatımantasyon) yoktur. Bir araç yangınında duman doğrudan binanın içine dolarak tüm kaçış yollarını kullanılamaz hale getirebilir. Yangın duvarı ve kapısı ile ayrım yapılmalıdır.",
    level: RiskLevel.critical,
  );

  static final otoparkOptionD = ChoiceResult(
    label: "13-1-D (Otopark)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Otopark kapısının teknik özellikleri bilinmiyor. Geçiş noktasındaki bu kapı yangına dayanıklı olmalıdır. Konuyla ilgili olarak mimari proje üzerinde veya yerinde inceleme yapılması gerekir.",
    level: RiskLevel.unknown,
  );

  static final kazanOptionA = ChoiceResult(
    label: "13-2-A (Kazan D.)",
    uiTitle:
        "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan yangın kapısı ve dışarıya doğru açılmaktadır.",
    uiSubtitle: "Duvarları yangına dayanıklı",
    reportText:
        "OLUMLU: Kazan dairesi kompartımantasyonu ve kapı özellikleri uygun gözükmektedir. Kazan dairesi duvarları yangına en az 120 dk, kapıları en az 90dk. yangın dayanıma sahip olması gereklidir. Aksi halde burada olası bir yangın hızlıca bina içerisine sirayet edebilir.",
    level: RiskLevel.positive,
  );

  static final kazanOptionB = ChoiceResult(
    label: "13-2-B (Kazan D.)",
    uiTitle:
        "Yangına dayanıksız sac, demir, plastik, aluminyum, ahşap vb. kapı var veya kapı içeriye doğru açılıyor.",
    uiSubtitle: "Veya duvarları yangına dayanıklı değil",
    reportText:
        "KRİTİK RİSK: Kazan dairesi kapısı yangına dayanıklı olmalı ve kaçış yönüne (dışarıya) açılması önerilir. İçeri açılan kapılar, patlama veya panik anında basınç nedeniyle açılamaz hale gelerek içeridekileri hapsedebilir.",
    adviceText:
        "Otopark ve kazan dairesi içerisindeki lastik, eski eşya vb. yanıcı malzemeler derhal tahliye edilmeli veya yangına dayanıklı (EI60) ayrı bir depo odasına alınmalıdır.",
    level: RiskLevel.critical,
  );

  static final kazanOptionC = ChoiceResult(
    label: "13-2-C (Kazan D.)",
    uiTitle: "Kazan dairesi binadan tamamen ayrı bir yerde.",
    uiSubtitle:
        "Kazan dairesi bina kütlesinin dışında, bahçede veya ayrı bir yapıdadır.",
    reportText:
        "OLUMLU: Kazan dairesi binadan ayrı bir yerdedir. Olası bir yangında veya patlamada binaya etkisi az olacaktır.",
    level: RiskLevel.positive,
  );

  static final kazanOptionD = ChoiceResult(
    label: "13-2-D (Kazan D.)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kazan dairesinin duvar ve kapı özellikleri bilinmiyor. Özellikle bina içerisinde yer alan kazan dairesindeki yangın güvenlik önlemleri hayati önem taşır, mimari proje üzerinde veya yerinde inceleme gerekir.",
    level: RiskLevel.unknown,
  );

  static final asansorOptionA = ChoiceResult(
    label: "13-3-A (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Asansör kat / kabin kapılarının yangına dayanıklı oldukları beyan edilmiştir. Kapıların test raporu Uzman tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.positive,
  );

  static final asansorOptionB = ChoiceResult(
    label: "13-3-B (Asansör)",
    uiTitle: "Asansör kat / kabin kapıları yangına dayanıklı değil.",
    uiSubtitle: "",
    reportText:
        "UYARI: Asansör kat / kabin kapıları yangına dayanıklı değildir. Makine daireleri yangın riski taşır, kapısı dayanıklı olmalıdır.",
    level: RiskLevel.warning,
  );

  static final asansorOptionC = ChoiceResult(
    label: "13-3-C (Asansör)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kapı özellikleri bilinmiyor, duvarlarıyla birlikte kapısının da yangına dayanıklı olması gereklidir. Asansör kat kapılarının yangın dayanım test raporu incelenerek uygunluklarına karar verilir.",
    level: RiskLevel.unknown,
  );

  static final jeneratorOptionA = ChoiceResult(
    label: "13-5-A (Jeneratör)",
    uiTitle:
        "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan yangın kapısı var.",
    uiSubtitle: "Duvarları yangına dayanıklı",
    reportText:
        "OLUMLU: Jeneratör odası yangına dayanıklı duvar ve kapı ile ayrılmıştır. Oda kapısının yangın dayanım test raporu Yangın Güvenlik Uzmanı tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.positive,
  );

  static final jeneratorOptionB = ChoiceResult(
    label: "13-5-B (Jeneratör)",
    uiTitle:
        "Yangına dayanıksız sac, plastik, ahşap, cam veya kapı içeriye doğru açılıyor.",
    uiSubtitle: "Veya duvarları yangına dayanıklı değil",
    reportText:
        "KRİTİK RİSK: Jeneratör odasında yer alan yakıtın alev alma riski bulunur, bu mahal yangın dayanımlı duvar ve yangın kapısı ile binanında geri kalanından ayrılmalıdır.",
    level: RiskLevel.critical,
  );

  static final jeneratorOptionC = ChoiceResult(
    label: "13-5-C (Jeneratör)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Jeneratör odası özellikleri bilinmiyor. Jeneratör odasında bulunan yakıtın alev alma riski bulunur, bu mahal yangın dayanımlı duvar ve yangın kapısı ile binanında geri kalanından ayrılmalıdır. Oda kapısının test raporu Uzman tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.unknown,
  );

  static final elekOdasiOptionA = ChoiceResult(
    label: "13-6-A (Elektrik Odası)",
    uiTitle: "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan kapı.",
    uiSubtitle: "Duvarları yangına dayanıklı",
    reportText:
        "OLUMLU: Elektrik odası yangına dayanıklı ve duman sızdırmaz kapı ile korunmaktadır. Oda kapısının yangın dayanım test raporu Yangın Güvenlik Uzmanı tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.positive,
  );

  static final elekOdasiOptionB = ChoiceResult(
    label: "13-6-B (Elektrik Odası)",
    uiTitle: "Yangına dayanıksız sac, demir, plastik, ahşap, cam kapı.",
    uiSubtitle: "Veya duvarları yangına dayanıklı değil",
    reportText:
        "UYARI: Elektrik odaları yangın başlangıç noktası olma ihtimali yüksektir, yangın dayanım özellikleri olması şarttır.",
    level: RiskLevel.warning,
  );

  static final elekOdasiOptionC = ChoiceResult(
    label: "13-6-C (Elektrik Odası)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Elektrik odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Oda kapısının yangın dayanım test raporu Yangın Güvenlik Uzmanı tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.unknown,
  );

  static final trafoOptionA = ChoiceResult(
    label: "13-7-A (Trafo)",
    uiTitle: "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan kapı.",
    uiSubtitle: "Duvarları yangına dayanıklı",
    reportText:
        "OLUMLU: Trafo odasının kapısı kilitli, yangına dayanıklı ve duman sızdırmaz özelliklidir.Yağlı tip trafo kullanılıyorsa oda kapısının yangın dayanım test raporu Yangın Güvenlik Uzmanı tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.positive,
  );

  static final trafoOptionB = ChoiceResult(
    label: "13-7-B (Trafo)",
    uiTitle: "Yangına dayanıksız sac, demir, plastik, ahşap, cam kapı.",
    uiSubtitle: "Veya duvarları yangına dayanıklı değil",
    reportText:
        "UYARI: Yağlı tip trafo odaları yüksek yangın riski taşır. Kapı ve duvarların yangın dayanım özellikli olması şarttır. Mevcut kapı bu riski karşılamamaktadır.",
    level: RiskLevel.warning,
  );

  static final trafoOptionC = ChoiceResult(
    label: "13-7-C (Trafo)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Özellikle yağlı tip trafo odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Trafo odası kapısının yangın dayanım test raporu Yangın Güvenlik Uzmanı tarafından incelenerek uygunluğuna karar verilir. Odayla ilgili hiçbir bilgi bilinmiyorsa proje üzerinde inceleme veya yerinde inceleme yapılması önerilir.",
    level: RiskLevel.unknown,
  );

  static final depoOptionA = ChoiceResult(
    label: "13-8-A (Depo)",
    uiTitle: "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan kapı.",
    uiSubtitle: "Duvarları yangına dayanıklı",
    reportText:
        "OLUMLU: Ortak depo/ardiye alanının kapısı metal yangın kapısı veya sac kapıdır. Depo kapısının test raporu Uzman tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.positive,
  );

  static final depoOptionB = ChoiceResult(
    label: "13-8-B (Depo)",
    uiTitle: "Yangına dayanıksız sac, demir, plastik, ahşap, cam kapı.",
    uiSubtitle: "Veya duvarları yangına dayanıklı değil",
    reportText:
        "UYARI: Depolardaki eşyalar büyük yangın yükü oluşturur. Duman sızdırmaz ve yangına dayanıklı kapı kullanılması önerilir. Mevcut durum yangının yayılmasını kolaylaştırabilir.",
    level: RiskLevel.warning,
  );

  static final depoOptionC = ChoiceResult(
    label: "13-8-C (Depo)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kapının özellikleri bilinmiyor. Özellikle yanıcı madde depolanan mahallerin duvarları ve kapıları yangın dayanım özellikli olmalıdır. Depo kapısının yangın dayanımtest raporu Yangın Güvenlik Uzmanı tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.unknown,
  );

  static final copOptionA = ChoiceResult(
    label: "13-9-A (Çöp O.)",
    uiTitle: "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan kapı.",
    uiSubtitle: "Duvarları yangına dayanıklı",
    reportText:
        "OLUMLU: Çöp toplama odasında duman sızdırmaz yangın kapısı ve havalandırma mevcuttur.",
    level: RiskLevel.positive,
  );

  static final copOptionB = ChoiceResult(
    label: "13-9-B (Çöp O.)",
    uiTitle: "Yangına dayanıksız sac, demir, plastik, ahşap, cam kapı.",
    uiSubtitle: "Veya duvarları yangına dayanıklı değil",
    reportText:
        "KRİTİK RİSK: Çöp odaları metan gazı birikme riski taşır. Kapı yangına dayanıklı olmalı ve oda mutlaka havalandırılmalıdır. Mevcut durum patlama veya zehirlenme riski oluşturabilir.",
    level: RiskLevel.critical,
  );

  static final copOptionC = ChoiceResult(
    label: "13-9-C (Çöp O.)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çöp odalarının duvarları ve kapıları yangın dayanım özellikli olmalıdır. Oda kapısının yangın dayanım test raporu Yangın Güvenlik Uzmanı tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.unknown,
  );

  static final ortakDuvarOptionA = ChoiceResult(
    label: "13-10-A (Ortak Duvar)",
    uiTitle: "Kalın tuğla veya beton duvar (En az 20-25cm).",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Yan bina ile ortak kullanılan duvar kalın tuğla veya betondur (En az 20-25cm).",
    level: RiskLevel.positive,
  );

  static final ortakDuvarOptionB = ChoiceResult(
    label: "13-10-B (Ortak Duvar)",
    uiTitle: "İnce bölme duvar.",
    uiSubtitle: "Yan bina ile aradaki duvar ince ve zayıf bir yapıdadır.",
    reportText:
        "KRİTİK RİSK: Ortak duvarlar en az 90 dk yangına dayanıklı olmalıdır.",
    level: RiskLevel.critical,
  );

  static final ortakDuvarOptionC = ChoiceResult(
    label: "13-10-C (Ortak Duvar)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Bitişik nizam bina ile aradaki duvarın kalınlığı bilinmiyor. Duvarın 90 dk dayanım gösterecek özellikte olması şarttır. Uzman Görüşü alınması tavsiye edilir.",
    level: RiskLevel.unknown,
  );

  static final ticariOptionA = ChoiceResult(
    label: "13-11-A (Ticari)",
    uiTitle:
        "Yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanan kapı var.",
    uiSubtitle: "Ticari alan ile konut arasında",
    reportText:
        "OLUMLU: Ticari alan ile konut arasındaki geçiş noktasında kullanılan duvar ve kapı yangına dayanıklıdır.",
    level: RiskLevel.positive,
  );

  static final ticariOptionB = ChoiceResult(
    label: "13-11-B (Ticari)",
    uiTitle: "Yangına dayanıksız sac, demir, plastik, ahşap, cam kapı var.",
    uiSubtitle: "Ticari alan ile konut arasında",
    reportText:
        "UYARI: Farklı kullanım amaçlı mahaller yangına dayanıklı kapı ve duvar ile birbirinden ayrılmaları önerilir.",
    level: RiskLevel.warning,
  );

  static final ticariOptionC = ChoiceResult(
    label: "13-11-C (Ticari)",
    uiTitle: "Geçiş yok.",
    uiSubtitle: "Ticari alandan konuta doğrudan geçiş yok.",
    reportText:
        "OLUMLU: Ticari alan ile konut arasında doğrudan içeriden geçiş bulunmamaktadır. Alanlar birbirinden bağımsızdır.",
    level: RiskLevel.positive,
  );

  static final ticariOptionD = ChoiceResult(
    label: "13-11-D (Ticari)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Farklı kullanım alanlarındaki geçiş bilinmiyor, Yangın Güvenlik Uzmanı görüşü alınması önerilir.",
    level: RiskLevel.unknown,
  );

  static final endustriyelMutfakOptionA = ChoiceResult(
    label: "13-13-A (Endüstriyel Mutfak)",
    uiTitle: "Duvarları 120 dk, kapısı 90 dk yangına dayanıklı.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Endüstriyel mutfak/büyük restoran, binanın diğer kısımlarından en az 120 dakika süreyle yangına dayanıklı duvar ve en az 90 dakika süreyle yangına dayanıklı kapılar ile ayrılmıştır (Madde 57/3 yönergelerine uygundur).",
    level: RiskLevel.positive,
  );

  static final endustriyelMutfakOptionB = ChoiceResult(
    label: "13-13-B (Endüstriyel Mutfak)",
    uiTitle:
        "Yangına dayanıksız duvar sistemi ile cam, ahşap, pvc kapılar kullanılmış.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Endüstriyel mutfak/büyük restoran duvarları ve kapıları yeterli yangın dayanımına sahip değildir. Yangın Yönetmeliği Madde 57/3 gereği; Ticari alanda büyük restoran (endüstriyel mutfak) olduğu beyan edilmiştir. Endüstriyel mutfaklar yüksek yangın riski taşır. Yönetmelik gereği, ticari alan içerisinde yer alan endüstriyel mutfaklar, binanın diğer kısımlarından en az 120 dakika süreyle yangına dayanıklı duvar ve kapılar ile ayrılmış biçimde konumlandırılır. Aynı anda 100’den fazla kişiye hizmet verebilen restoranların davlumbazlarına otomatik söndürme sistemi yapılması ve ocaklarında kullanılan gazın özelliklerine göre gaz algılama, gaz kesme ve uyarı tesisatının kurulması şarttır.",
    adviceText: "",
    level: RiskLevel.critical,
  );

  static final endustriyelMutfakOptionC = ChoiceResult(
    label: "13-13-C (Endüstriyel Mutfak)",
    uiTitle: "Restoran, binadan tamamen bağımsız bir yerde.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Endüstriyel mutfak binadan bağımsız ayrı bir kütlede yer almaktadır. Yangın sirayeti riski düşüktür. Ana binaya yakınlığına veya bağlantısına göre Uzman tarafından yerinde inceleme yapılması önerilir.",
    level: RiskLevel.positive,
  );

  static final endustriyelMutfakOptionD = ChoiceResult(
    label: "13-13-D (Endüstriyel Mutfak)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Endüstriyel mutfak/büyük restoranın duvar ve kapı dayanımı bilinmemektedir. Endüstriyel mutfaklar yüksek yangın riski taşır. Yönetmelik gereği, ticari alan içerisinde yer alan endüstriyel mutfaklar, binanın diğer kısımlarından en az 120 dakika süreyle yangına dayanıklı duvar ve kapılar ile ayrılmış biçimde konumlandırılır. Aynı anda 100’den fazla kişiye hizmet verebilen restoranların davlumbazlarına otomatik söndürme sistemi yapılması ve ocaklarında kullanılan gazın özelliklerine göre gaz algılama, gaz kesme ve uyarı tesisatının kurulması şarttır.",
    level: RiskLevel.unknown,
  );

  // --- ALT SORULAR ---
  // OTOPARK ALANI
  static final otoparkAlanOptionA = ChoiceResult(
    label: "13-1-ALT-A (<600)",
    uiTitle: "600 m²'nin altında",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final otoparkAlanOptionB = ChoiceResult(
    label: "13-1-ALT-B (600-1000)",
    uiTitle: "600 - 1000 m² arasında",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final otoparkAlanOptionC = ChoiceResult(
    label: "13-1-ALT-C (1001-2000)",
    uiTitle: "1001 - 2000 m² arasında",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final otoparkAlanOptionD = ChoiceResult(
    label: "13-1-ALT-D (>2000)",
    uiTitle: "2000 m²'nin üzerinde",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final otoparkAlanOptionE = ChoiceResult(
    label: "13-1-ALT-E (Bilmiyorum)",
    uiTitle: "Bilmiyorum",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );

  // KAZAN DAİRESİ ALANI
  static final kazanAlanOptionA = ChoiceResult(
    label: "13-2-ALT-A",
    uiTitle: "2000 m² veya altında",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final kazanAlanOptionB = ChoiceResult(
    label: "13-2-ALT-B",
    uiTitle: "2000 m²'nin üzerinde",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final kazanAlanOptionC = ChoiceResult(
    label: "13-2-ALT-C",
    uiTitle: "Bilmiyorum",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );

  // SIĞINAK ALANI (Yeni Soru)
  static final siginakAlanOptionA = ChoiceResult(
    label: "13-12-A (Sığınak)",
    uiTitle: "2000 m² veya altında",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final siginakAlanOptionB = ChoiceResult(
    label: "13-12-B (Sığınak)",
    uiTitle: "2000 m²'nin üzerinde",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
  static final siginakAlanOptionC = ChoiceResult(
    label: "13-12-C (Sığınak)",
    uiTitle: "Bilmiyorum",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
}

class Bolum14Content {
  static const String title = "Tesisat Şaftları";
  static const String msgHigh =
      "Binanız 30.50 metreden yüksek olduğundan tüm tesisat şaft duvarları en az 120 dk, şaft kapakları ise en az 90 dk yangına dayanıklı ve duman sızdırmaz özellikte olmalıdır.";
  static const String msgMid =
      "Binanız 21.50m - 30.50m aralığında olup tesisat şaftı ve yangın duvarlarınızın en az 90 dk, şaft kapaklarınızın ise en az 60 dk dayanıklı, duman sızdırmaz özellikte olmaları gerekmektedir.";
  static const String msgDeepBasement =
      "Binanız Yüksek Bina olmasa da, bodrum kat derinliğiniz 10 metreyi aştığı için bodrum katlarınız risk taşımaktadır. Bodrumdaki şaft duvarları en az 90 dk ve şaft kapakların dayanımları en az 60dk, zemin üst normal katlarda ise duvarları en az 60dk, kapakları en az 30dk olmalıdır.";
  static const String msgStandard =
      "Binanızın yüksekliği ve bodrum derinliği yüksek olmayan bina sınırları içindedir. Tesisat şaft duvarları en az 60 dk, şaft kapakları ise en az 30 dk dayanıklı olması yeterlidir.";
}

class Bolum15Content {
  static final kaplamaOptionA = ChoiceResult(
    label: "15-1-A",
    uiTitle:
        "Ahşap parke, laminat, pvc vinil, karo halı, vb. yanıcı malzemeler.",
    uiSubtitle: "",
    reportText:
        "UYARI: Döşeme kaplamasının yangına tepki sınıfı kontrol edilerek uygunluğuna karar verilmelidir.",
    level: RiskLevel.warning,
  );

  static final kaplamaOptionB = ChoiceResult(
    label: "15-1-B",
    uiTitle: "Taş, seramik, mermer, vb. yanmaz kaplama.",
    uiSubtitle: "Veya limitli yanıcı malzemeler.",
    reportText:
        "OLUMLU: Zemin kaplaması yanmaz malzeme olarak beyan edilmiştir. Zemin kaplaması yangına tepki sınıfı test raporu Uzman tarafından incelenerek uygunluğuna karar verilir.",
    level: RiskLevel.positive,
  );

  static final kaplamaOptionC = ChoiceResult(
    label: "15-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Zemin kaplamasının yanıcılık sınıfı bilinmiyor.Yönetmelik gereği yüksek binalarda döşeme kaplamalarının en az zor alevlenici olması gerekmektedir; aksi durumda yanıcı kaplamalar risk teşkil eder.",
    level: RiskLevel.unknown,
  );

  static final kaplamaOptionD = ChoiceResult(
    label: "15-1-D",
    uiTitle: "Karma zemin kaplama tipleri",
    uiSubtitle: "Farklı mahallerde farklı kaplamalar mevcut.",
    reportText:
        "UYARI: Binada karma zemin kaplaması mevcuttur. Yönetmelik gereği yüksek binalarda döşeme kaplamalarının en az zor alevlenici olması gerekmektedir; aksi durumda yanıcı kaplamalar risk teşkil eder.",
    level: RiskLevel.warning,
  );

  static final yalitimOptionA = ChoiceResult(
    label: "15-2-A",
    uiTitle: "Hayır, ısı yalıtım yok.",
    uiSubtitle: "Döşeme betonunda yalıtım bulunmuyor.",
    reportText:
        "OLUMLU: Döşeme betonu altında yanıcı yalıtım malzemesi bulunmamaktadır.",
    level: RiskLevel.positive,
  );

  static final yalitimOptionB = ChoiceResult(
    label: "15-2-B",
    uiTitle: "Evet, ısı yalıtımı (strafor, köpük, vb.) var.",
    uiSubtitle: "Yanıcı malzemeler",
    reportText:
        "KRİTİK RİSK: Yanıcı yalıtım malzemesi kullanımı tespit edilmiştir.",
    adviceText:
        "Tespit edilen yanıcı malzemelerin üzeri en az 2-3 cm şap ile kapatılmalı veya sökülerek zor yanıcı ve yoğun duman çıkarmayan malzemeler ile değiştirilmeleri önerilir.",
    level: RiskLevel.critical,
  );

  static final yalitimOptionC = ChoiceResult(
    label: "15-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Zemin altında yanıcı yalıtım malzemesi olup olmadığı bilinmiyor. Mimari proje üzerinden veya yerinde kontrol edilmelidir.",
    level: RiskLevel.unknown,
  );

  static final yalitimSapOptionA = ChoiceResult(
    label: "15-2-ALT-A",
    uiTitle: "Evet, en az 2 cm şap var.",
    uiSubtitle: "Koruma katmanı mevcut.",
    reportText:
        "OLUMLU: Döşemedeki yanıcı yalıtım malzemesi, şap tabakası ile korunmuştur.",
    level: RiskLevel.positive,
  );

  static final yalitimSapOptionB = ChoiceResult(
    label: "15-2-ALT-B",
    uiTitle: "Hayır, şap yok.",
    uiSubtitle: "Yalıtım malzemesinin üzeri çıplak durumda.",
    reportText:
        "KRİTİK RİSK: Yalıtımın üzeri en az 2 cm şap tabakası ile örtülmelidir.",
    level: RiskLevel.critical,
  );

  static final yalitimSapOptionC = ChoiceResult(
    label: "15-2-ALT-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "UYARI: Koruyucu şap tabakası olup olmadığı bilinmiyor. Varsa yanıcı yalıtım malzemelerinin üzeri en az 2 cm şap tabakası ile örtülmelidir. ",
    level: RiskLevel.warning,
  );

  static final tavanOptionA = ChoiceResult(
    label: "15-3-A",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Tavanlar direkt beton üzeri sıva + boya.",
    reportText: "OLUMLU: Tavanlarda asma tavan bulunmamaktadır.",
    level: RiskLevel.positive,
  );

  static final tavanOptionB = ChoiceResult(
    label: "15-3-B",
    uiTitle: "Evet, var.",
    uiSubtitle: "",
    reportText: "UYARI: Asma tavan malzemesi kontrol edilmelidir.",
    level: RiskLevel.warning,
  );

  static final tavanOptionC = ChoiceResult(
    label: "15-3-C",
    uiTitle: "Karma (Bazı alanlarda var, bazı alanlarda yok)",
    uiSubtitle: "Binanın genelinde farklı tavan tipleri mevcut.",
    reportText:
        "UYARI: Binanın bazı bölümlerinde asma tavan tespit edilmiştir; kullanılan malzemenin yangın performansı ve tavan içi tesisat yalıtımı kontrol edilmelidir.",
    level: RiskLevel.warning,
  );

  static final tavanOptionD = ChoiceResult(
    label: "15-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Tavan yapısı hakkında bilgi yok. Binadaki tavan tiplerinin incelenmesi gereklidir.",
    level: RiskLevel.unknown,
  );

  static final tavanMalzemeOptionA = ChoiceResult(
    label: "15-3-ALT-A",
    uiTitle: "Alçıpanel, metal vb. yanmaz malzeme.",
    uiSubtitle: "A1, A2 sınıfı malzemeler",
    reportText:
        "OLUMLU: Asma tavan malzemesinin yangına tepki sınıfı A1 veya A2 sınıfıdır. Yönetmelikçe sınıf bakımından yeterli olsa da malzemelerin yangına tepki test raporlarının kontrol edilmesi önerilir.",
    level: RiskLevel.positive,
  );

  static final tavanMalzemeOptionB = ChoiceResult(
    label: "15-3-ALT-B",
    uiTitle: "Ahşap, plastik, lambiri vb. yanıcı malzeme.",
    uiSubtitle: "Kolay alevlenici dekoratif malzemeler",
    reportText:
        "KRİTİK RİSK: Tavan malzemeleri kuvvetle muhtemel yanıcıdır. Asma tavan malzemelerinin yangına tepki test raporları kontrol edildikten sonra Yönetmelik şartlarını karşılayıp karşılamaadığına karar verilir.",
    level: RiskLevel.critical,
  );

  static final tavanMalzemeOptionC = ChoiceResult(
    label: "15-3-ALT-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Asma tavan malzemesinin yanıcılığı bilinmiyor. Asma tavan malzemelerinin yangına tepki test raporları kontrol edildikten sonra Yönetmelik şartlarını karşılayıp karşılamadığına karar verilir.",
    level: RiskLevel.unknown,
  );
  static final tavanMalzemeOptionKarma = ChoiceResult(
    label: "15-3-Alt-D", // D for Mixed (inserted before Unknown C in UI list)
    uiTitle: "Karma kullanım (yanıcı veya yanmaz malzemeler birlikte)",
    uiSubtitle: "Kısmen yanıcı kısmen yanmaz",
    reportText:
        "UYARI: Asma tavan malzemesi olarak mahal bazlı karma (yanıcı ve yanmaz tipte) ürünler kullanıldığı belirtilmiştir. Özellikle kaçış yolları ve toplanma alanlarında asma tavanların tamamen yanmaz (A1 sınıfı) olması tercih edilir. Mahal bazlı asma tavan malzemelerinin mimari proje üzerinde veya sahada incelenmeleri önerilir.",
    level: RiskLevel.warning,
  );
  static final tesisatOptionA = ChoiceResult(
    label: "15-4-A",
    uiTitle: "Beton, harç veya yangına dayanıklı mastik vb. ile kapatılmış.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Tesisat geçişleri yalıtılmıştır. Binadaki özellikle yangın kompartımanları, döşeme ve şaftlardaki tesisat geçişleri ve kullanılan malzemelerin akredite test raporları veya onay dokümanları kontrol edilerek uygunluklarına karar verilir.",
    level: RiskLevel.positive,
  );

  static final tesisatOptionB = ChoiceResult(
    label: "15-4-B",
    uiTitle:
        "Geçişlerde boşluklar var veya (sarı) poliüretan köpük vb. malzeme ile kapatılmış.",
    uiSubtitle: "",
    reportText:
        "UYARI: Tesisat geçişlerinde boşluklar yangına dayanıklı olmayan malzemelerle kapatma yapılmış olabilir. Döşeme, şaft, yangın kompartımanı gibi mahallerde ve geçişlerde bu durum uygunsuzluk yaratır.",
    adviceText:
        "Tesisat şaftındaki veya döşemedeki boşluklar, yangın durdurucu harç, mastik, yastık vb. ile kapatılabilir. Poliüretan köpük son derece yanıcıdır ve bu noktalarda ASLA kullanılmamalıdır.",
    level: RiskLevel.warning,
  );

  static final tesisatOptionC = ChoiceResult(
    label: "15-4-C",
    uiTitle: "Karma (Bazı tesisat geçişleri yalıtımlı, bazıları yalıtımsız)",
    uiSubtitle: "",
    reportText:
        "UYARI: Tesisat geçişlerinin bir kısmında sızdırmazlık sağlanmamıştır; katlar arası duman ve alev yayılımı riski bulunmaktadır. Binadaki özellikle yangın kompartımanları, döşeme ve şaftlardaki tesisat geçişleri ve kullanılan malzemelerin akredite test raporları veya onay dokümanları kontrol edilerek uygunluklarına karar verilir.",
    level: RiskLevel.warning,
  );

  static final tesisatOptionD = ChoiceResult(
    label: "15-4-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Tesisat şaft yalıtımı bilinmiyor. Binadaki özellikle yangın kompartımanları, döşeme ve şaftlardaki tesisat geçişleri ve kullanılan malzemelerin akredite test raporları veya onay dokümanları kontrol edilerek uygunluklarına karar verilir.",
    level: RiskLevel.unknown,
  );
}

class Bolum16Content {
  static final mantolamaOptionA = ChoiceResult(
    label: "16-1-A (Mantolama)",
    uiTitle: "Klasik Mantolama (EPS, XPS, Strafor, vb.).",
    uiSubtitle:
        "Dış cephede sıva altında köpük esaslı ısı yalıtım levhaları kullanılmıştır.",
    reportText:
        "UYARI: Dış cephede yanıcı özellikli (EPS, XPS, Strafor vb.) ısı yalıtım levhaları kullanılmıştır. Bina yüksekliği (bodrum katlar hariç) 28.50m 'nin üzerindeki binalarda bu uygulama yasaktır. Daha alçak binalarda ise pencerelerin etrafında ve zemin seviyesinde taşyünü yangın bariyerleri bulunması zorunludur.",
    level: RiskLevel.warning,
  );

  static final mantolamaOptionB = ChoiceResult(
    label: "16-1-B (Mantolama)",
    uiTitle: "A1 veya A2 sınıf taşyünü ile mantolama.",
    uiSubtitle: "Dış cephede yanmaz özellikli taşyünü vb. kullanılmıştır.",
    reportText:
        "OLUMLU: Dış cephe yalıtımında yanmaz (A1 veya A2 sınıfı) taşyünü malzeme kullanılmıştır. Bu tercih, cephe yangınlarının yayılmasını engelleyebilir. Cephe sisteminin veya malzemelerinin yangına tepki test raporları incelendikten sonra yönetmeliğe göre uygunluk kontrolü yapılmış olur.",
    level: RiskLevel.positive,
  );

  static final giydirmeOptionC = ChoiceResult(
    label: "16-1-C (Giydirme)",
    uiTitle: "Giydirme cephe (Cam, Kompozit, vb.).",
    uiSubtitle:
        "Bina dış yüzeyi alüminyum, cam veya kompozit panellerle kaplanmıştır.",
    reportText:
        "UYARI: Binada giydirme cephe sistemi mevcuttur. Cephe ile döşeme arasındaki boşlukların yalıtım durumu yangın sıçrama riski açısından kritiktir. Cephe sisteminin yangına tepki test raporları incelenmelidir.",
    level: RiskLevel.warning,
  );

  static final mantolamaOptionD = ChoiceResult(
    label: "16-1-D (Sıva/Boya)",
    uiTitle: "Cephede sadece sıva ve boya var (yalıtım yok).",
    uiSubtitle: "Dış cephede herhangi bir ısı yalıtım katmanı bulunmamaktadır.",
    reportText:
        "OLUMLU: Dış cephede yanıcı bir yalıtım malzemesi bulunmamaktadır. Yangın yükü oluşturmaz.",
    level: RiskLevel.positive,
  );

  static final mantolamaOptionE = ChoiceResult(
    label: "16-1-E (Bilinmiyor)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Dış cephe malzemesi bilinmiyor. Yüksek binalarda yanıcı malzeme kullanımı hayati risk taşır. Malzemelerin test raporları sorgulanmalıdır.",
    level: RiskLevel.unknown,
  );

  static final sagirYuzeyOptionA = ChoiceResult(
    label: "16-2-A (Sağır Yüzey)",
    uiTitle:
        "EVET, cephede katlar arasında en az 100 cm yüksekliğinde yangın dayanımlı yüzey var.",
    uiSubtitle: "Dikeyde 100 cm",
    reportText:
        "OLUMLU: Katlar arasındaki yangın dayanıklı yüzey (veya sistem) yüksekliği 100 cm şartını sağlamaktadır. Bu mesafe, alevin bir kattan diğerine sıçramasını zorlaştırır. Yönetmelik şartlarını sağlayıp sağlamadığına yanmaz yüzeyin yerinde kontrol edilmesi ile karar verilir.",
    level: RiskLevel.positive,
  );

  static final sagirYuzeyOptionB = ChoiceResult(
    label: "16-2-B (Sağır Yüzey)",
    uiTitle:
        "HAYIR, cephede katlar arasında en az 100 cm yüksekliğinde yangın dayanımlı yüzey yok.",
    uiSubtitle:
        "Pencereler dikeyde birbirine çok yakın, aradaki duvar mesafesi 1 metreden az.",
    reportText:
        "KRİTİK RİSK: Katlar arasındaki yangına dayanıklı yüzey yüksekliği 100 cm'den azdır. Yangın bir kattan diğerine kolayca sıçrayabilir.",
    adviceText:
        "Dumanın ve alevlerin üst katlara sıçramasını önlemek için cephe ile döşeme arasındaki boşluklar yangın durdurucu harç ile kapatılmalı ve kat aralarında en az 100 cm yüksekliğinde yanmaz bant (fire barrier) oluşturulmalıdır.",
    level: RiskLevel.critical,
  );

  static final sagirYuzeyOptionC = ChoiceResult(
    label: "16-2-C (Sağır Yüzey)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Katlar arasındaki yangına dayanıklı yüzey yüksekliği bilinmiyor. 100 cm'den az ise yangın dikeyde hızla yayılabilir.",
    level: RiskLevel.unknown,
  );

  static final bitisikOptionA = ChoiceResult(
    label: "16-3-A (Bitişik)",
    uiTitle: "Aynı yükseklikteyiz.",
    uiSubtitle: "Yan bina ile çatı seviyemiz aynı.",
    reportText:
        "OLUMLU: Binalar aynı hizada olduğu için yan binadan cepheye yangın sıçrama riski düşüktür.",
    level: RiskLevel.positive,
  );

  static final bitisikOptionB = ChoiceResult(
    label: "16-3-B (Bitişik)",
    uiTitle: "Biz daha alçaktayız.",
    uiSubtitle: "Bizim binamız yan binadan daha alçak.",
    reportText:
        "OLUMLU: Binanız yan binadan daha alçak olduğu için, yan binadan cephenize yangın sıçrama riski düşüktür.",
    level: RiskLevel.positive,
  );

  static final bitisikOptionC = ChoiceResult(
    label: "16-3-C (Bitişik)",
    uiTitle: "Biz daha yüksekteyiz.",
    uiSubtitle: "Bizim binamız yan binadan daha yüksek.",
    reportText:
        "UYARI: Yan binanın çatısının bittiği hizaya denk gelen dış cephe kaplamanız 'Hiç Yanmaz'(A1 sınıfı) malzeme olmalıdır.",
    level: RiskLevel.warning,
  );

  static final bitisikOptionD = ChoiceResult(
    label: "16-3-D (Bitişik)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Bitişik bina ile yükseklik durumu bilinmiyor. Eğer yan binadan yüksekseniz, o bölgedeki cephe malzemesinin yangına tepki sınıfı kritik öneme sahiptir.",
    level: RiskLevel.unknown,
  );
}

class Bolum17Content {
  static final kaplamaOptionA = ChoiceResult(
    label: "17-1-A (Kaplama)",
    uiTitle: "Kiremit, metal kenet, beton, taş türünde yanmaz malzeme.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Çatı kaplamasında hiç yanmaz (A1 sınıfı) malzeme kullanılmıştır. Bu durum, dışarıdan gelebilecek kıvılcımlara karşı koruma sağlar.",
    level: RiskLevel.positive,
  );

  static final kaplamaOptionB = ChoiceResult(
    label: "17-1-B (Kaplama)",
    uiTitle: "Shingle, Onduline, Membran, vb.",
    uiSubtitle: "Çatı yüzeyinde petrol türevi (bitümlü) örtü.",
    reportText:
        "UYARI: Çatıda kullanılan bitümlü örtüler (Shingle, Membran, vb.) yanıcı özellik gösterebilir. Bu malzemelerin 'BROOF'özellikli (dış yangına karşı dayanıklı) olması gerekmektedir. Ürünün test raporu incelenmelidr.",
    adviceText:
        "Yanıcı çatı kaplamaları, çevre binalardan veya bacalardan sıçrayabilecek kıvılcımlarla kolayca tutuşabilir. Çatı altı arasının temiz tutulması ve mümkünse kaplamanın 'BROOF' sınıfı (dış yangına dayanıklı) malzemelerle yenilenmesi önerilir.",
    level: RiskLevel.warning,
  );

  static final kaplamaOptionC = ChoiceResult(
    label: "17-1-C (Kaplama)",
    uiTitle: "Sandviç Panel (Yanıcı)",
    uiSubtitle:
        "İçi XPS, EPS, PIR, PUR, poliüretan vb. malzeme dolgulu sandviç paneller ile kaplanmıştır.",
    reportText:
        "UYARI: Yanıcı malzeme dolgulu sandviç paneller yangını çok hızlı yayar ve söndürülmesi zordur. Taşyünü dolgulu paneller tercih edilmesi önerilir. Sandviç panellerin yangına tepki test raporları Uzman tarafından kontrol edilmesinin ardından uygunluğuna karar verilir.",
    level: RiskLevel.warning,
  );

  static final kaplamaOptionD = ChoiceResult(
    label: "17-1-D (Kaplama)",
    uiTitle: "Sandviç Panel (Yanmaz)",
    uiSubtitle:
        "İçi taşyünü, cam yünü, mineral yünü vb. malzeme dolgulu sandviç paneller ile kaplanmıştır.",
    reportText:
        "OLUMLU: Taşyünü, mineral yünü, cam yünü gibi A1, A2 sınıf malzeme dolgulu sandviç paneller Yönetmelik açısından daha uygun bulunur.",
    level: RiskLevel.positive,
  );

  static final kaplamaOptionE = ChoiceResult(
    label: "17-1-E (Kaplama)",
    uiTitle: "Ahşap kaplama.",
    uiSubtitle: "Çatı yüzeyi tamamen ahşap malzeme ile kaplanmıştır.",
    reportText:
        "KRİTİK RİSK: Çatı kaplamasında ahşap kullanılması yüksek yangın riski oluşturur. Kıvılcım sıçraması durumunda çatı hızla tutuşabilir.",
    level: RiskLevel.critical,
  );

  static final kaplamaOptionF = ChoiceResult(
    label: "17-1-F (Kaplama)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çatı kaplama malzemesi bilinmiyor. Yanıcı bir malzeme (shingle, plastik vb.) kullanıldıysa tüm bina risk altındadır. Uzman Görüşü alınması tavsiye edilir.",
    level: RiskLevel.unknown,
  );

  static final iskeletOptionA = ChoiceResult(
    label: "17-2-A (İskelet)",
    uiTitle:
        "Taşıyıcılar beton veya çeliktir. Isı yalıtım olarak taşyünü vb. malzeme kullanılmıştır.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Çatı taşıyıcı sisteminin ve yalıtımının yanmaz malzemeden olması yangın güvenliği için en ideal durumdur.",
    level: RiskLevel.positive,
  );

  static final iskeletOptionB = ChoiceResult(
    label: "17-2-B (İskelet)",
    uiTitle:
        "Taşıyıcılar ve altındaki ısı yalıtım malzemesi yanıcı ürünlerdir.",
    uiSubtitle: "Ahşap, XPS, EPS, Strafor vb. malzemeler.",
    reportText: "(bina tipine göre değerlendirme yapılır)",
    level: RiskLevel.positive,
  );

  // Dinamik rapor metinleri — report_engine tarafından seçilir
  static const String iskeletOptionBYuksekReport =
      "KRİTİK RİSK: Bina YÜKSEK BİNA sınıfındadır. Yüksek binalarda ahşap taşıyıcı veya yanıcı ısı yalıtım malzemeleri (XPS, EPS, strafor) kullanılması yasaktır.";

  static const String iskeletOptionBNormalReport =
      "UYARI: Ahşap çatı iskeletinde veya altında yanıcı köpük (XPS, EPS) ya da strafor kullanımı yangın riskini artırır. Yakın bir yangında çatının hızla tutuşmasına yol açabilir.";

  static final iskeletOptionC = ChoiceResult(
    label: "17-2-C (İskelet)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çatı iskeletinin durumu bilinmiyor. Yüksek binalarda ahşap çatı büyük risk taşır. Uzman Görüşü alınması tavsiye edilir.",
    level: RiskLevel.unknown,
  );

  static final bitisikOptionA = ChoiceResult(
    label: "17-3-A (Bitişik)",
    uiTitle:
        "İki binanın çatıları arasında en az 60 cm yüksekliğinde yangın dayanımlı duvar var.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Yangın duvarı mevcuttur. Komşu binadan çatı yoluyla yangın geçişi engellenmiştir.",
    level: RiskLevel.positive,
  );

  static final bitisikOptionB = ChoiceResult(
    label: "17-3-B (Bitişik)",
    uiTitle: "Çatılar arasında yangın dayanımlı duvarı yok.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Bitişik nizam binalarda, çatılar arasında yangın geçişini engelleyecek, çatı seviyesinden en az 60 cm yükseltilmiş 'Yangın Duvarı'olması zorunludur.",
    level: RiskLevel.critical,
  );

  static final bitisikOptionC = ChoiceResult(
    label: "17-3-C (Bitişik)",
    uiTitle: "Çatı birleşim yerlerini göremiyorum, bir fikrim yok.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Komşu bina ile çatı birleşim detayı bilinmiyor. Binanıza yangın sıçrama riski olabilir.",
    level: RiskLevel.unknown,
  );

  static final isiklikOptionA = ChoiceResult(
    label: "17-4-A (Işıklık)",
    uiTitle: "Hayır, ışıklık yok.",
    uiSubtitle: "Çatıda cam veya plastik aydınlatma açıklığı bulunmuyor.",
    reportText:
        "OLUMLU: Çatıda ışıklık olmaması, yangın güvenliği açısından riski azaltır.",
    level: RiskLevel.positive,
  );

  static final isiklikOptionB = ChoiceResult(
    label: "17-4-B (Işıklık)",
    uiTitle: "Evet, ışıklık var.",
    uiSubtitle: "",
    reportText: "Işıklığın yangın performansıyla ilgili görüş aşağıdadır.",
    level: RiskLevel.positive,
  );
  static final isiklikOptionC = ChoiceResult(
    label: "17-4-C (Işıklık)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çatı ışıklık durumu bilinmiyor. Işıklık varsa ve plastikse yangın riski oluşturabilir. Uzman kontrolü önerilir.",
    level: RiskLevel.unknown,
  );

  // Alt soru: Işıklık malzeme tipi (17-4-B seçildiğinde görünür)
  static final isiklikCam = ChoiceResult(
    label: "17-4-B-CAM (Işıklık Malzeme)",
    uiTitle: "Yangına dayanıklı cam",
    uiSubtitle: "Temperli, lamine vb.",
    reportText:
        "OLUMLU: Çatı ışıklıklarında yangına dayanıklı cam kullanılmaktadır. Yangına dayanıklı cam, yangında aşağıya damlamaz ve yangını içeri taşıma riski düşüktür. Temperli, polikarbonat, lamine camların rüzgar direnci, darbe dayanımı, kırılmazlığı vs. olumlu olsa da yangın performansları tartışmalıdır.",
    level: RiskLevel.positive,
  );

  static final isiklikPlastik = ChoiceResult(
    label: "17-4-B-PLASTİK (Işıklık Malzeme)",
    uiTitle: "Plastik veya standart cam",
    uiSubtitle: "",
    reportText:
        "UYARI: Çatı ışıklıklarında plastik veya standart cam malzeme kullanılmaktadır. Bu malzemeler yangında eriyerek aşağıya damlayabilir ve yangının yapı içine yayılmasına zemin hazırlayabilir. Yangına dayanıklı cam ile değiştirilmesi tavsiye edilir.",
    level: RiskLevel.warning,
  );
}

class Bolum18Content {
  static final duvarOptionA = ChoiceResult(
    label: "18-1-A (Duvar)",
    uiTitle: "Hayır, sadece sıva ve boya.",
    uiSubtitle: "Duvarlarda ekstra bir kaplama malzemesi yoktur.",
    reportText: "OLUMLU: Duvar yüzeylerinde yanıcı kaplama bulunmamaktadır.",
    level: RiskLevel.positive,
  );

  static final duvarOptionB = ChoiceResult(
    label: "18-1-B (Duvar)",
    uiTitle: "Evet, ahşap, plastik, köpük var.",
    uiSubtitle:
        "Duvarlarda lambiri, plastik panel veya strafor süslemeler var.",
    reportText: "(bina tipine göre değerlendirme yapılır)",
    level: RiskLevel.positive,
  );

  // Dinamik rapor metinleri — report_engine tarafından seçilir
  static const String duvarOptionBYuksekReport =
      "UYARI: Bina YÜKSEK BİNA sınıfındadır. Duvar kaplama malzemeleri 'en az ZOR alevlenici' sınıfta olmalıdır.";

  static const String duvarOptionBNormalReport =
      "UYARI: Duvarlarda kullanılan köpük veya plastik malzemeler 'en az NORMAL alevlenici' sınıfta olmalıdır.";

  static final duvarOptionC = ChoiceResult(
    label: "18-1-C (Duvar)",
    uiTitle: "Evet, duvar kağıdı var.",
    uiSubtitle: "Duvarlarda standart duvar kağıdı kullanılmıştır.",
    reportText:
        "UYARI:Standart duvar kağıtları genelde kabul edilir, ancak 'Kolay Alevlenen'türde olmamalıdır.",
    level: RiskLevel.warning,
  );

  static final duvarOptionD = ChoiceResult(
    label: "18-1-D (Duvar)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Duvar kaplama malzemesi bilinmiyor. 21.50m üzeri binalarda yanıcı kaplama malzemesi kullanımı büyük risk taşır.",
    level: RiskLevel.unknown,
  );

  static final boruOptionA = ChoiceResult(
    label: "18-2-A (Boru)",
    uiTitle: "Demir, döküm boru kullanılmıştır",
    uiSubtitle:
        "Kalın etli, mineral katkılı veya metal borular kullanılmıştır.",
    reportText:
        "OLUMLU: Tesisat şaftlarında zor yanıcı (sessiz boru) veya yanmaz (döküm) borular kullanılmıştır.",
    level: RiskLevel.positive,
  );

  static final boruOptionB = ChoiceResult(
    label: "18-2-B (Boru)",
    uiTitle: "Plastik boru ve yangın dayanımlı kelepçe kullanılmıştır.",
    uiSubtitle: "Plastik boruların döşeme geçişlerinde kelepçe var.",
    reportText:
        "OLUMLU: Plastik boruların kat geçişlerinde yangın dayanımlı kelepçe kullanılarak alev geçişi engellenmiştir.",
    level: RiskLevel.positive,
  );

  static final boruOptionC = ChoiceResult(
    label: "18-2-C (Boru)",
    uiTitle:
        "Plastik boru kullanılmış ancak yangın dayanımlı kelepçe kullanılmamıştır.",
    uiSubtitle: "Plastik boruların döşeme geçişlerinde kelepçe yok.",
    reportText:
        "UYARI: 21.50m ve üzeri binalarda standart plastik borular yangın anında eriyerek yok olur ve döşemede delik açılır. Bu delikten alevler üst kata geçebilir.",
    adviceText:
        "Mevcut plastik boruların kat geçişlerine, boru çapına uygun ve onaylı Yangın durdurucu kelepçe veya sargıların uygulaması acilen yapılmalıdır.",
    level: RiskLevel.warning,
  );

  static final boruOptionD = ChoiceResult(
    label: "18-2-D (Boru)",
    uiTitle: "Tesisat geçişlerini göremiyorum.",
    uiSubtitle: "Şaftlar kapalı olduğu için boru cinsini bilmiyorum.",
    reportText:
        "BİLİNMİYOR: Tesisat borularının yangın dayanımı veya malzeme özellikleri bilinmiyor. Yüksek binalarda plastik boruların kat geçişlerinde (döşemelerinde) yangın kesici (kelepçe) olup olmadığı hayati önem taşır.",
    level: RiskLevel.unknown,
  );
}

class Bolum19Content {
  static final engelOptionA = ChoiceResult(
    label: "19-1-A",
    uiTitle: "Herhangi bir engel yok, yol tamamen açık.",
    uiSubtitle: "Tahliye yolu mevzuata uygun.",
    reportText:
        "OLUMLU: Kaçış yollarında tahliyeyi engelleyici unsur bulunmamaktadır.",
    level: RiskLevel.positive,
  );

  static final engelOptionB = ChoiceResult(
    label: "19-1-B",
    uiTitle: "Eşya, bisiklet, saksı vb. malzemeler var.",
    uiSubtitle: "Yol genişliği daralmış.",
    reportText:
        "UYARI: Kaçış yollarında eşya ve malzeme istifi tespit edilmiştir.",
    adviceText:
        "Koridorlarda ve merdiven sahanlıklarında bulunan tüm eşyalar (bisiklet, puset, ayakkabılık vb.) derhal kaldırılmalı, bu alanlar sürekli temiz ve erişilebilir tutulmalıdır.",
    level: RiskLevel.warning,
  );

  static final engelOptionC = ChoiceResult(
    label: "19-1-C",
    uiTitle: "Kilitli kapı veya geçişi zorlaştıran bariyer var.",
    uiSubtitle: "Acil çıkış engellenmiş.",
    reportText:
        "KRİTİK RİSK: Kaçış yolunda kilitli kapı veya fiziksel engel mevcut olduğu beyan edilmiştir.",
    adviceText:
        "Kilitli kapılar veya engeller yangın anında açılabilir veya bu sağlanamıyorsa her zaman açılabilir olmalıdır.",
    level: RiskLevel.critical,
  );

  static final engelOptionD = ChoiceResult(
    label: "19-1-D",
    uiTitle: "Eşik, basamak veya kaygan zemin var.",
    uiSubtitle: "Düşme ve takılma riski.",
    reportText:
        "UYARI: Kaçış yolu zemininde takılma veya kayma riski tespit edilmiştir.",
    adviceText:
        "Koridorlarda ve merdiven sahanlıklarında bulunan tüm eşyalar derhal kaldırılmalıdır. Bu alanlar sürekli temiz ve erişilebilir tutulmalıdır.",
    level: RiskLevel.warning,
  );

  static final levhaOptionA = ChoiceResult(
    label: "19-2-A",
    uiTitle:
        "EVET, tüm çıkışlarda ledli, ışıklı acil yönlendirme işaretleri var.",
    uiSubtitle: "Yeterince yönlendirme var.",
    reportText: "OLUMLU: Acil durum yönlendirme işaretleri mevcuttur.",
    level: RiskLevel.positive,
  );

  static final levhaOptionB = ChoiceResult(
    label: "19-2-B",
    uiTitle: "HAYIR, hiçbir yerde yönlendirme levhası yok.",
    uiSubtitle: "Karanlıkta veya dumanlı ortamda çıkış bulunması güçtür.",
    reportText:
        "KRİTİK RİSK: Binada acil durum yönlendirme işaretleri bulunmamaktadır.",
    level: RiskLevel.critical,
  );

  static final levhaOptionC = ChoiceResult(
    label: "19-2-C",
    uiTitle: "Yönlendirmeler var ama çalışmıyorlar, arızalı olabilir.",
    uiSubtitle: "",
    reportText:
        "UYARI: Yönlendirme işaretlemeleri mevcut ancak çalışır durumda değildir. Acil durumda bu işaretlerin çalışır durumda olması büyük önem taşır.",
    level: RiskLevel.warning,
  );

  static final yanilticiOptionA = ChoiceResult(
    label: "19-3-A",
    uiTitle: "HAYIR, yanıltıcı kapı yok, çıkış kapısını kolayca bulabilirim.",
    uiSubtitle: "Tüm kapılar amacına uygun.",
    reportText:
        "OLUMLU: Kaçış yollarında kullanıcıyı yanıltacak kapı bulunmamaktadır. Bu durum uygundur.",
    level: RiskLevel.positive,
  );

  static final yanilticiOptionB = ChoiceResult(
    label: "19-3-B",
    uiTitle:
        "EVET, yanıltıcı kapı var, çıkış kapısını bulmakta güçlük çekebilirim.",
    uiSubtitle: "Depo/Elektrik odası kapıları merdiven kapısına benziyor.",
    reportText:
        "UYARI: Kaçış yollarında yangın merdiveni ile karıştırılabilecek yanıltıcı kapılar mevcuttur.",
    adviceText:
        "Yanıltıcı kapıların üzerinde mahalin adı veya 'Çıkış Değildir' etiketleri bulunmalıdır.",
    level: RiskLevel.warning,
  );

  static final etiketOptionA = ChoiceResult(
    label: "19-3-ALT-A",
    uiTitle: "EVET, 'ÇIKIŞ DEĞİLDİR'veya mahalin adı yazıyor.",
    uiSubtitle: "İşaretleme yapılmış.",
    reportText:
        "OLUMLU: Yanıltıcı kapılar üzerinde gerekli uyarı levhaları mevcuttur. Bu durum uygundur.",
    level: RiskLevel.warning,
  );

  static final etiketOptionB = ChoiceResult(
    label: "19-3-ALT-B",
    uiTitle: "HAYIR, herhangi bir yazı veya levha yok.",
    uiSubtitle: "",
    reportText:
        "UYARI: Yanıltıcı kapılar üzerinde uyarı levhası bulunmamaktadır.",
    adviceText:
        "Yanıltıcı kapıların üzerinde mahalin adı veya 'Çıkış Değildir' etiketleri bulunmalıdır.",
    level: RiskLevel.warning,
  );

  static final etiketOptionC = ChoiceResult(
    label: "19-3-ALT-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Yanıltıcı kapıların işaretleme durumu tespit edilememiştir.",
    level: RiskLevel.unknown,
  );
}

class Bolum20Content {
  static final tekKatOptionA = ChoiceResult(
    label: "20-A (Tek Kat)",
    uiTitle: "Düz ayak, engelsiz çıkabiliyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Tek katlı binada düz ayak, engelsiz çıkış imkanı mevcuttur.",
    level: RiskLevel.positive,
  );

  static final cokKatOption1 = ChoiceResult(
    label: "20-1 (Çok Kat)",
    uiTitle: "Normal Apartman Merdiveni (Kapısız).",
    uiSubtitle:
        "Binanın ana sirkülasyon merdivenidir. Bu merdiven üzerinde yangın kapısı BULUNMAZ.",
    reportText: "(Sayısal veri olarak saklanır)",
    level: RiskLevel.positive,
  );

  static final cokKatOption2 = ChoiceResult(
    label: "20-2 (Çok Kat)",
    uiTitle: "Bina İçi 'Kapalı' Yangın Merdiveni (Kapılı).",
    uiSubtitle: "Betonarme, duvarla çevrili, YANGIN KAPISI bulunan merdiven.",
    reportText: "(Sayısal veri olarak saklanır)",
    level: RiskLevel.positive,
  );

  static final cokKatOption3 = ChoiceResult(
    label: "20-3 (Çok Kat)",
    uiTitle: "Bina Dışı 'Kapalı' Yangın Merdiveni (Kapılı).",
    uiSubtitle:
        "Çelik, yangın dayanımlı duvarla çevrili, YANGIN KAPISI bulunan merdiven",
    reportText: "(Sayısal veri olarak saklanır)",
    level: RiskLevel.positive,
  );

  static final cokKatOption4 = ChoiceResult(
    label: "20-4 (Çok Kat)",
    uiTitle: "Bina Dışı 'Açık' Çelik Merdiven (Kapılı).",
    uiSubtitle:
        "Çelik, genelde kollu (Z-tipi) merdiven, duvarsız, üzerinde YANGIN KAPISI olan merdiven",
    reportText: "(Sayısal veri olarak saklanır)",
    level: RiskLevel.positive,
  );

  static final cokKatOption5 = ChoiceResult(
    label: "20-5 (Çok Kat)",
    uiTitle: "Dairesel (Spiral, Döner) Merdiven.",
    uiSubtitle: "BİNA DIŞI, yuvarlak, dönerek inilen çelik merdiven.",
    reportText: "(Sayısal veri olarak saklanır)",
    level: RiskLevel.positive,
  );

  static final cokKatOption6 = ChoiceResult(
    label: "20-6 (Çok Kat)",
    uiTitle: "Sahanlıksız Merdiven.",
    uiSubtitle: "Basamak adedi 17'yi aşan, sahanlığı olmayan merdiven.",
    reportText: "(Sayısal veri olarak saklanır)",
    level: RiskLevel.positive,
  );

  static final cokKatOption7 = ChoiceResult(
    label: "20-7 (Çok Kat)",
    uiTitle: "Dengelenmiş Merdiven.",
    uiSubtitle:
        "BİNA İÇİ, basamak genişliği içten dışa doğru artan, sahanlıklı veya sahanlıksız merdiven.",
    reportText: "(Sayısal veri olarak saklanır)",
    level: RiskLevel.positive,
  );

  static final basYghOptionA = ChoiceResult(
    label: "20-BAS-A",
    uiTitle: "Evet, var.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Kapalı yangın merdivenlerinde basınçlandırma sistemi olduğu beyan edilmiştir.",
    level: RiskLevel.positive,
  );

  static final basYghOptionB = ChoiceResult(
    label: "20-BAS-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "",
    reportText:
        "UYARI: Kapalı yangın merdivenlerinde basınçlandırma sistemi bulunmamaktadır. Yönetmeliğe göre binadaki yangın merdiveninde basınçlandırma sistemi ihtiyacı yoksa uygundur, ihtiyaç varsa durum, mimari proje üzerinden veya sahada Uzman tarafından değerlendirilmelidir.",
    level: RiskLevel.warning,
  );

  static final basYghOptionC = ChoiceResult(
    label: "20-BAS-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Merdiven basınçlandırma durumu belirsizdir.",
    level: RiskLevel.unknown,
  );

  static final bodrumOptionA = ChoiceResult(
    label: "20-Bodrum-A",
    uiTitle: "Evet, aynı merdiven devam ediyor.",
    uiSubtitle: "",
    reportText: "(Bodrum çıkış sayısı hesabında kullanılır)",
    level: RiskLevel.positive,
  );

  static final bodrumOptionB = ChoiceResult(
    label: "20-Bodrum-B",
    uiTitle: "Hayır, bodrum kat merdivenleri bağımsız, başka yerde.",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Bodrum kat merdivenleri üst katlardan bağımsız olarak düzenlenmiştir.",
    level: RiskLevel.info,
  );

  // --- Dairesel Merdiven Yüksekliği ---
  // Label Constants (Magic String Eliminator)
  static const String daireselYukseklikLabelA = "20-Dairesel-A";
  static const String daireselYukseklikLabelB = "20-Dairesel-B";
  static const String daireselYukseklikLabelC = "20-Dairesel-C";

  static final daireselYukseklikOptionA = ChoiceResult(
    label: daireselYukseklikLabelA,
    uiTitle: "9.50 metre veya altında.",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Dairesel merdiven yüksekliği 9.50m sınırının altındadır.",
    level: RiskLevel.info,
  );

  static final daireselYukseklikOptionB = ChoiceResult(
    label: daireselYukseklikLabelB,
    uiTitle: "9.50 metrenin üzerinde.",
    uiSubtitle: "",
    reportText:
        "UYARI: Dairesel merdiven yüksekliği 9.50m sınırını aşmaktadır.",
    level: RiskLevel.warning,
  );

  static final daireselYukseklikOptionC = ChoiceResult(
    label: daireselYukseklikLabelC,
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Dairesel merdiven yüksekliği bilinmiyor.",
    level: RiskLevel.unknown,
  );

  // --- Havalandırma (Madde 45) ---
  static final havalandirmaOptionA = ChoiceResult(
    label: "20-HAV-A",
    uiTitle: "EVET, hepsinde var.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Tüm yangın merdivenlerinde doğal havalandırma (pencere/menfez) mevcut. Yönetmelik Madde 45 gereği korunmuş kaçış merdivenleri doğal veya mekanik havalandırma ile donatılmalıdır. Mevcut durum yönetmelik gerekliliklerini karşılamaktadır.",
    level: RiskLevel.positive,
  );

  static final havalandirmaOptionB = ChoiceResult(
    label: "20-HAV-B",
    uiTitle: "Bazı merdivenlerde var.",
    uiSubtitle: "",
    reportText:
        "UYARI: Bazı yangın merdivenlerinde doğal havalandırma mevcut ancak tümünde değil. Yönetmelik Madde 45 uyarınca bütün korunmuş kaçış merdivenleri doğal veya mekanik havalandırma ile donatılmalıdır. Havalandırması olmayan merdivenlere mekanik havalandırma veya basınçlandırma sistemi tesis edilmesi gerekmektedir.",
    level: RiskLevel.warning,
  );

  static final havalandirmaOptionC = ChoiceResult(
    label: "20-HAV-C",
    uiTitle: "HAYIR, hiçbirinde yok.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Yangın merdivenlerinde doğal havalandırma bulunmamaktadır. Yönetmelik Madde 45 gereği tüm korunmuş kaçış merdivenleri doğal yolla veya mekanik yolla havalandırılmalı ya da basınçlandırılmalıdır. Acil olarak mekanik havalandırma veya basınçlandırma sistemi tesis edilmesi zorunludur.",
    level: RiskLevel.critical,
  );

  static final havalandirmaOptionD = ChoiceResult(
    label: "20-HAV-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Yangın merdivenlerinde doğal havalandırma (pencere/menfez) olup olmadığı bilinmemektedir. Yönetmelik Madde 45 gereği merdivenler proje üzerinde veya yerinde kontrol edilmelidir.",
    level: RiskLevel.unknown,
  );

  static final rampaOptionB = ChoiceResult(
    label: "20-B (Tek Kat)",
    uiTitle: "Evet",
    uiSubtitle: "Eğimli yol ile çıkış sağlanıyor.",
    reportText:
        "(Rampa modülünde detaylandırılacak) Rampa ile çıkış sağlanmaktadır.",
    level: RiskLevel.positive,
  );

  static final rampaOptionC = ChoiceResult(
    label: "20-C (Tek Kat)",
    uiTitle: "Hayır",
    uiSubtitle: "Birkaç basamak inilerek/çıkılarak ulaşılıyor.",
    reportText: "(Merdiven sayısı not edilir) Çıkışta basamak mevcuttur.",
    level: RiskLevel.positive,
  );

  // --- Madde 41 - Dış Havaya Tahliye ---
  static final madde41OranHata = ChoiceResult(
    label: "36-MADDE41-ORAN-HATA",
    uiTitle: "Kaçış merdivenlerinin en az yarısı doğrudan dışarı açılmıyor.",
    uiSubtitle: "Madde 41/1 ihlali.",
    reportText:
        "KRİTİK RİSK: Madde 41/1 gereği, binadaki kaçış merdivenlerinin en az yarısının doğrudan dışarıya açılması zorunludur. Mevcut durumda bu oran sağlanamamaktadır.",
    level: RiskLevel.critical,
  );

  static final madde41MesafeHata = ChoiceResult(
    label: "36-MADDE41-MESAFE-HATA",
    uiTitle: "Bina içi tahliye mesafesi sınır değerleri aşıyor.",
    uiSubtitle: "Madde 41/2 ihlali.",
    reportText:
        "KRİTİK RİSK: Madde 41/2 gereği, doğrudan dışarı açılmayan merdivenlerin koridor içindeki tahliye mesafesi yönetmelik limitlerini (sprinklersiz binalarda 10m, sprinklerli binalarda 15m) aşmamalıdır. Mevcut durumda bu mesafe sınır değerlerin dışındadır.",
    level: RiskLevel.critical,
  );

  static final madde41Uygundur = ChoiceResult(
    label: "36-MADDE41-TAM",
    uiTitle: "Kaçış merdivenlerinin dış havaya tahliyesi mesafesi yeterlidir.",
    uiSubtitle: "Madde 41 kriterleri sağlanıyor.",
    reportText:
        "OLUMLU: Kaçış merdivenlerinin doğrudan dışarı açılma durumu ve bina içi tahliye mesafeleri Yönetmeliğin 41. maddesi kriterlerine uygundur.",
    level: RiskLevel.positive,
  );

  static final madde41MesafeAltinda = ChoiceResult(
    label: "41-MESAFE-A",
    uiTitle: "Evet, limitin altında",
    uiSubtitle: "Mesafe yeterli",
    reportText:
        "OLUMLU: Bina içi tahliye mesafesi Yönetmelik limit değerlerinin (sprinklersiz 10m / sprinklerli 15m) altındadır.",
    level: RiskLevel.positive,
  );

  static final madde41MesafeUstunde = ChoiceResult(
    label: "41-MESAFE-B",
    uiTitle: "Hayır, limitin üstünde",
    uiSubtitle: "Mesafe yetersiz",
    reportText:
        "KRİTİK RİSK: Madde 41/2 gereği, bina içi tahliye mesafesi Yönetmelik limit değerlerini (sprinklersiz 10m / sprinklerli 15m) aşmaktadır.",
    level: RiskLevel.critical,
  );

  static final madde41MesafeBilmiyorum = ChoiceResult(
    label: "41-MESAFE-C",
    uiTitle: "Bilmiyorum",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Bina içi tahliye mesafesi ölçülmemiş veya bilinmemektedir. (Limit Değerler: Sprinklersiz 10m / Sprinklerli 15m)",
    level: RiskLevel.unknown,
  );
}

class Bolum21Content {
  static final varlikOptionA = ChoiceResult(
    label: "21-1-A",
    uiTitle: "Evet, var.",
    uiSubtitle: "Giriş-çıkış kapıları olan odacık mevcut.",
    reportText:
        "OLUMLU: Merdivenin önünde Yangın Güvenlik Holü (YGH) mevcuttur.",
    level: RiskLevel.positive,
  );

  static final varlikOptionB = ChoiceResult(
    label: "21-1-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Holden geçmeden direkt merdivene çıkılıyor.",
    reportText:
        "BİLGİ: Binada YGH bulunmamaktadır. Binada YGH zorunluluğu bulunup bulunmadığı testin sonunda kontrol edilmelidir. Detaylı bilgi için Yangın Güvenlik Uzmanı 'nın görüşüne başvurulması önerilir.",
    adviceText:
        "Bu raporda YGH zorunluluğu belirtildiyse ve binada YGH oluşturulamıyorsa, Madde 89 uyarınca kaçış merdiveni yuvasının basınçlandırılması alternatif bir güvenlik önlemi olarak değerlendirilebilir. Kesin değerlendirme için Yangın Güvenlik Uzmanı 'ndan bilgi alınmalıdır.",
    level: RiskLevel.warning,
  );

  static final malzemeOptionA = ChoiceResult(
    label: "21-2-A",
    uiTitle: "Sıva, boya, alçıpanel, beton, mermer vb.",
    uiSubtitle: "Hol içinde yanmaz malzemeler kullanılmış.",
    reportText: "OLUMLU: YGH içindeki kaplamalar yanmaz özelliktedir.",
    level: RiskLevel.positive,
  );

  static final malzemeOptionB = ChoiceResult(
    label: "21-2-B",
    uiTitle: "Ahşap, duvar kağıdı, plastik.",
    uiSubtitle: "Hol içinde yanıcı kaplama veya dekorasyon var.",
    reportText:
        "KRİTİK RİSK: Yangın güvenlik holleri kaçış yolunun bir parçasıdır. Duvar, tavan ve tabanında hiçbir yanıcı malzeme kullanılamaz.",
    adviceText:
        "Hol içindeki yanıcı kaplamaların sökülerek A1 sınıfı yanmaz malzemeler ile yenilenmesi gerekmektedir.",
    level: RiskLevel.critical,
  );

  static final malzemeOptionC = ChoiceResult(
    label: "21-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Holdeki malzemelerin yanıcılık özellikleri bilinmiyor. Kaçış yollarında yanıcı malzeme kullanımı varsa bu durum ciddi risk teşkil eder.",
    level: RiskLevel.unknown,
  );

  static final kapiOptionA = ChoiceResult(
    label: "21-3-A",
    uiTitle:
        "YGH kapıları yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanan özelliktedir.",
    uiSubtitle: "",
    reportText: "OLUMLU: YGH kapıları uygun gözükmektedir.",
    level: RiskLevel.positive,
  );

  static final kapiOptionB = ChoiceResult(
    label: "21-3-B",
    uiTitle: "YGH kapıları yangına dayanıklı değil.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: YGH kapıları en az 90 dakika yangına dayanıklı ve duman sızdırmaz özellikte olmalıdır.",
    adviceText:
        "Mevcut kapıların akredite yangın dayanım test raporuna sahip, hidrolik kapatıcılı veya yaylı menteşeli (kendiliğinden kapanan) yangın kapıları ile değiştirilmesi hayati önem taşır.",
    level: RiskLevel.critical,
  );

  static final kapiOptionC = ChoiceResult(
    label: "21-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: kapıların yangın dayanımı bilinmiyor. YGH kapıları en az 90 dakika yangına dayanıklı olmalıdır.",
    level: RiskLevel.unknown,
  );

  static final esyaOptionA = ChoiceResult(
    label: "21-4-A",
    uiTitle: "Hayır, tamamen boş, gereksiz eşya yok.",
    uiSubtitle: "",
    reportText: "OLUMLU: YGH içi temiz ve boş tutulduğundan güvenli sayılır.",
    level: RiskLevel.positive,
  );
  static final esyaOptionB = ChoiceResult(
    label: "21-4-B",
    uiTitle: "Evet, eşya var.",
    uiSubtitle: "Gereksiz eşya, mobilya, çöp ayakkabılık, dolap vs.",
    reportText:
        "KRİTİK RİSK: Yangın güvenlik hollerinde kaçışı engelleyecek hiçbir eşya bulundurulamaz.",
    adviceText:
        "YGH alanındaki tüm eşyaların derhal tahliye edilmesi ve bu alanın tamamen boş tutulması gerekmektedir.",
    level: RiskLevel.critical,
  );

  static final esyaOptionC = ChoiceResult(
    label: "21-4-C",
    uiTitle: "Bazen konuluyor.",
    uiSubtitle: "Geçici depolama yapılıyor.",
    reportText:
        "KRİTİK RİSK: YGH alanları depo olarak kullanılamaz, her an boş tutulmalıdır.",
    level: RiskLevel.critical,
  );
}

class Bolum22Content {
  static final varlikOptionA = ChoiceResult(
    label: "22-1-A",
    uiTitle:
        "Hayır, itfaiye asansörü yok, sadece normal (insan taşıma) asansör var.",
    uiSubtitle: "",
    reportText:
        "BİLGİ:Binada itfaiye asansörü bulunmamaktadır. Yönetmelik gereği yapı yüksekliği 51.50 metreyi geçen binalarda yangın anında itfaiyenin kullanabileceği, jeneratöre bağlı ve korunumlu İtfaiye Asansörü tesisi mecburidir.",
    level: RiskLevel.info,
  );

  static final varlikOptionB = ChoiceResult(
    label: "22-1-B",
    uiTitle: "Evet, itfaiye asansörü var.",
    uiSubtitle: "Bazı binalarda yük asansörü olarak da isimlendirilir.",
    reportText: "BİLGİ: Binada itfaiye asansörü mevcuttur.",
    level: RiskLevel.info,
  );

  static final varlikOptionC = ChoiceResult(
    label: "22-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Binada itfaiye asansörü varlığı teyit edilememiştir. Yapı yüksekliği 51.50 metreyi geçen binalarda bu donanım zorunludur.",
    level: RiskLevel.unknown,
  );

  static final konumOptionA = ChoiceResult(
    label: "22-2-A",
    uiTitle: "Doğrudan koridora veya lobiye açılıyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: İtfaiye asansörü doğrudan koridora açılmaktadır. Dumanın kuyuya girmemesi için asansörün bir yangın güvenlik holüne açılması teknik bir zorunluluktur.",
    level: RiskLevel.critical,
  );

  static final konumOptionB = ChoiceResult(
    label: "22-2-B",
    uiTitle: "Bir Yangın Güvenlik Holü'ne (YGH'ye) açılıyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: İtfaiye asansörü Yangın Güvenlik Holü'ne açılmaktadır.",
    level: RiskLevel.positive,
  );

  static final konumOptionC = ChoiceResult(
    label: "22-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: İtfaiye asansörünün açıldığı mahal belirsizdir. Güvenli tahliye ve müdahale için asansörün yangın güvenlik holüne açılması şarttır.",
    level: RiskLevel.unknown,
  );

  static final boyutOptionA = ChoiceResult(
    label: "22-3-A",
    uiTitle: "Küçük (6 m²'den az).",
    uiSubtitle: "Hol alanı dar.",
    reportText:
        "KRİTİK RİSK: İtfaiye asansörü önündeki YGH alanı 6 m²'den azdır. Sedye ve itfaiye ekibinin sığması için bu alanın en az 6 m² olması gerekmektedir.",
    adviceText:
        "İtfaiye asansörü önündeki alan, itfaiye ekiplerinin güvenli müdahalesi için 'Yangın Güvenlik Holü' niteliğinde olmalıdır.",
    level: RiskLevel.critical,
  );

  static final boyutOptionB = ChoiceResult(
    label: "22-3-B",
    uiTitle: "Standart (6-10 m² arası).",
    uiSubtitle: "Hol alanı yeterli genişlikte.",
    reportText:
        "OLUMLU: İtfaiye asansörü önündeki YGH alanı yeterli büyüklüktedir.",
    level: RiskLevel.positive,
  );

  static final boyutOptionC = ChoiceResult(
    label: "22-3-C",
    uiTitle: "Büyük (10 m²'den fazla).",
    uiSubtitle: "Hol alanı fazla geniş.",
    reportText:
        "UYARI: İtfaiye asansörü önündeki YGH alanı 10 m²'den büyüktür. Gereksiz büyük holler duman kontrolünü zorlaştırabilir.",
    level: RiskLevel.warning,
  );

  static final boyutOptionD = ChoiceResult(
    label: "22-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: İtfaiye asansörü önündeki holün boyutları teyit edilememiştir. Alanın 6 ila 10 m² arasında olması idealdir.",
    level: RiskLevel.unknown,
  );

  static final kabinOptionA = ChoiceResult(
    label: "22-4-A",
    uiTitle: "Evet, geniş ve hızlıca çıkabiliyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: İtfaiye asansörü kabin boyutu ve hızı yönetmelik şartlarını karşılamaktadır.",
    level: RiskLevel.positive,
  );

  static final kabinOptionB = ChoiceResult(
    label: "22-4-B",
    uiTitle: "Hayır, küçük veya hızlıca çıkamıyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: İtfaiye asansörü kabini 1.8 m²'den küçük veya hızı yetersizdir. Bu durum acil müdahaleyi geciktirebilir.",
    level: RiskLevel.critical,
  );

  static final kabinOptionC = ChoiceResult(
    label: "22-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: İtfaiye asansörünün kabin ölçüleri ve hızı bilinmemektedir.",
    level: RiskLevel.unknown,
  );

  static final enerjiOptionA = ChoiceResult(
    label: "22-5-A",
    uiTitle:
        "Evet, jeneratöre bağlı ve binada elektrik olmasa bile 60 dakika boyunca çalışabilir durumda.",
    uiSubtitle: "Elektrik kesilse bile asansörler çalışabiliyor.",
    reportText:
        "OLUMLU: İtfaiye asansörü acil durum enerji sistemine (jeneratör) bağlıdır.",
    level: RiskLevel.positive,
  );

  static final enerjiOptionB = ChoiceResult(
    label: "22-5-B",
    uiTitle: "Hayır, jeneratör yok veya bağlı değil.",
    uiSubtitle: "Elektrik kesilince asansör duruyor.",
    reportText:
        "KRİTİK RİSK: İtfaiye asansörünün acil durum enerji beslemesi bulunmamaktadır. Yangın anında enerji kesilirse asansör işlevsiz kalacaktır.",
    level: RiskLevel.critical,
  );

  static final enerjiOptionC = ChoiceResult(
    label: "22-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: İtfaiye asansörünün jeneratör desteği olup olmadığı teyit edilememiştir.",
    level: RiskLevel.unknown,
  );

  static final basincOptionA = ChoiceResult(
    label: "22-6-A",
    uiTitle: "Evet, basınçlandırma sistemi var.",
    uiSubtitle: "Asansör kuyusuna hava üfleyen sistem.",
    reportText:
        "OLUMLU: İtfaiye asansör kuyusu basınçlandırma sistemi ile korunmaktadır.",
    level: RiskLevel.positive,
  );

  static final basincOptionB = ChoiceResult(
    label: "22-6-B",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Asansör kuyusuna hava üfleyen yok.",
    reportText:
        "KRİTİK RİSK: İtfaiye asansör kuyusunda basınçlandırma sistemi bulunmamaktadır. Bu durum kuyuya duman dolma riskini artırır.",
    level: RiskLevel.critical,
  );

  static final basincOptionC = ChoiceResult(
    label: "22-6-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: İtfaiye asansör kuyusunun basınçlandırma durumu bilinmemektedir.",
    level: RiskLevel.unknown,
  );
}

class Bolum23Content {
  static final bodrumOptionA = ChoiceResult(
    label: "23-1-A (Bodrum)",
    uiTitle: "Normal (insan taşıma) asansör bodrum katlara inmiyor.",
    uiSubtitle: "Sadece üst katlara hizmet veriyor.",
    reportText: "Bilgi: Asansör bodrum katlara inmemektedir.",
    level: RiskLevel.positive,
  );

  static final bodrumOptionB = ChoiceResult(
    label: "23-1-B (Bodrum)",
    uiTitle:
        "Normal asansör bodrum katlara da iniyor ve bodrum katta kapısını korunumlu bir hole açıyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Asansör bodrum katta yangın güvenlik holüne açılmaktadır.",
    level: RiskLevel.positive,
  );

  static final bodrumOptionC = ChoiceResult(
    label: "23-1-C (Bodrum)",
    uiTitle:
        "Normal asansör bodrum katlara da iniyor ve holsüz biçimde direkt otoparka, depoya veya ticari alanlara açılıyor.",
    uiSubtitle: "Asansörün bodrum kata çıktığı noktada bir YGH yok.",
    reportText:
        "KRİTİK RİSK: Asansör kuyuları binanın bacası gibidir. Bodrumdaki otoparkta veya kazan dairesinde çıkacak bir yangının dumanı, direkt asansör kapısından kuyuya girer ve saniyeler içinde tüm üst katlara yayılır.",
    level: RiskLevel.critical,
  );

  static final bodrumOptionD = ChoiceResult(
    label: "23-1-D (Bodrum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Bodrum katlardaki asansörlerin hemen önünde mutlaka 'Yangın Güvenlik Holü'olmalıdır. Mevcut durum bilinmiyor.",
    level: RiskLevel.unknown,
  );

  static final yanginModuOptionA = ChoiceResult(
    label: "23-2-A (Yangın Modu)",
    uiTitle: "Evet, otomatik olarak kendiliğinden iniyor ve kapısını açıyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Asansörlerin yangın anında nasıl hareket etmeleri gerektiğine dair senaryo mevcut ve çalışır durumda gözüküyor.",
    level: RiskLevel.positive,
  );

  static final yanginModuOptionB = ChoiceResult(
    label: "23-2-B (Yangın Modu)",
    uiTitle:
        "Hayır, asansör (normalin dışında) yangın anında herhangi bir aksiyon almıyor.",
    uiSubtitle: "Yangın anında normal çalışmasına devam ediyor.",
    reportText:
        "KRİTİK RİSK: Asansörlerin yangın anında özel aksiyon alması gereklidir.",
    level: RiskLevel.critical,
  );

  static final yanginModuOptionC = ChoiceResult(
    label: "23-2-C (Yangın Modu)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Asansörün yangın senaryosu bilinmiyor. Yangın anında asansörde mahsur kalmamak için bu özelliğin varlığı hayati önem taşır.",
    level: RiskLevel.unknown,
  );

  static final konumOptionA = ChoiceResult(
    label: "23-3-A (Konum)",
    uiTitle: "Asansör kapıları, koridora veya hole doğru açılıyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Asansör kapıları kat koridoruna veya holüne doğru açılmaktadır.",
    level: RiskLevel.positive,
  );

  static final konumOptionB = ChoiceResult(
    label: "23-3-B (Konum)",
    uiTitle: "Doğrudan merdiveninin içine açılıyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Yönetmeliğe göre asansör kapıları ASLA merdiveni yuvasına açılamaz. Asansör kuyusundan sızan duman, insanların kaçtığı temiz bölgeyi (merdiveni) dumanla doldurur.",
    level: RiskLevel.critical,
  );

  static final konumOptionC = ChoiceResult(
    label: "23-3-C (Konum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Asansör kapısının konumu net değil. Eğer yangın merdiveni içine açılıyorsa, kaçış yolunuz tehlike altındadır.",
    level: RiskLevel.unknown,
  );

  static final levhaOptionA = ChoiceResult(
    label: "23-4-A (Levha)",
    uiTitle: "Evet, her katta levha var.",
    uiSubtitle: "",
    reportText: "OLUMLU: Asansörlerde gerekli uyarı levhaları mevcuttur.",
    level: RiskLevel.warning,
  );

  static final levhaOptionB = ChoiceResult(
    label: "23-4-B (Levha)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "",
    reportText:
        "UYARI: Panik anında insanlar refleks olarak asansöre yönelebilir. Bu levha, insanları merdivene yönlendirmek için yasal zorunluluktur.",
    level: RiskLevel.warning,
  );

  static final levhaOptionC = ChoiceResult(
    label: "23-4-C (Levha)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Uyarı levhalarının varlığı bilinmiyor. Panik anında insanlar refleks olarak asansöre yönelebilir. Bu levha, insanları merdivene yönlendirmek için yasal zorunluluktur.",
    level: RiskLevel.warning,
  );

  static final havalandirmaOptionA = ChoiceResult(
    label: "23-5-A (Havalandırma)",
    uiTitle: "Evet, kuyuda pencere var.",
    uiSubtitle: "",
    reportText: "OLUMLU: Asansör kuyusunda duman tahliye bacası mevcuttur.",
    level: RiskLevel.positive,
  );

  static final havalandirmaOptionB = ChoiceResult(
    label: "23-5-B (Havalandırma)",
    uiTitle: "Hayır, kuyu tamamen kapalı.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Asansör kuyusuna sızan dumanın tahliye edilmesi için en üst noktada 'Duman Tahliye Bacası'(0.1 m²'den az olmamak kaydıyla) zorunludur.",
    level: RiskLevel.critical,
  );

  static final havalandirmaOptionC = ChoiceResult(
    label: "23-5-C (Havalandırma)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kuyu havalandırması bilinmiyor. Asansör kuyusuna sızan dumanın tahliye edilmesi için en üst noktada 'Duman Tahliye Bacası'(0.1 m²'den az olmamak kaydıyla) zorunludur.",
    level: RiskLevel.unknown,
  );
}

class Bolum24Content {
  static final tipOptionA = ChoiceResult(
    label: "24-1-A (Tip)",
    uiTitle: "Kapalı koridordan geçerek (dış) bina kapısına ulaşabiliyorum.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Binadan çıkışta dış kaçış geçidi yer almamaktadır, Yönetmeliğe göre bir değerlendirmeye ihtiyaç bulunmaz.",
    level: RiskLevel.positive,
  );

  static final tipOptionB = ChoiceResult(
    label: "24-1-B (Tip)",
    uiTitle:
        "Bina dışına çıkabilmem için cephede, üstü açık bir geçitten veya yoldan geçmem gerekiyor.",
    uiSubtitle:
        "Bina içerisindeki kapalı kat koridorundan dışarı çıkış yapamıyorum.",
    reportText:
        "UYARI: Binadan çıkışta dış kaçış geçidi yer almaktadır. Yönetmeliğe göre bu geçidin ve dış cephedeki tehlikelerin değerlendirilmesi gereklidir.",
    level: RiskLevel.warning,
  );

  static final tipOptionC = ChoiceResult(
    label: "24-1-C (Tip)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Binadan çıkışta dış kaçış geçidi (açık koridor) olup olmadığı tespit edilememiştir. Uzman kontrolü önerilir.",
    level: RiskLevel.unknown,
  );

  static final pencereOptionA = ChoiceResult(
    label: "24-2-A (Pencere)",
    uiTitle: "Hayır, bu yola veya koridora bakan pencere hiç yok.",
    uiSubtitle:
        "Açık kaçış yolu veya koridoru tarafındaki duvar sağır (penceresiz).",
    reportText:
        "OLUMLU: Açık koridora bakan pencere bulunmamaktadır. Bu durum kaçış güvenliği açısından olumludur.",
    level: RiskLevel.positive,
  );

  static final pencereOptionB = ChoiceResult(
    label: "24-2-B (Pencere)",
    uiTitle: "Evet, pencereler var.",
    uiSubtitle:
        "Açık kaçış yoluna veya koridora bakan daire pencereleri mevcut.",
    reportText:
        "UYARI: Dış kaçış geçidine bakan pencereler, yerden en az 1.80 metre yüksekte olmalıdır. Aksi takdirde daireden çıkan alev ve duman, kaçış yolunu kapatır.",
    adviceText:
        "Dış kaçış koridoruna bakan pencereler sabitlenmeli ve camları yangına dayanıklı telli cam ile değiştirilmelidir. Aksi halde daire yangını kaçış yolunu kullanılamaz hale getirebilir.",
    level: RiskLevel.warning,
  );

  static final pencereOptionC = ChoiceResult(
    label: "24-2-C (Pencere)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Dış kaçış geçidine bakan pencerelerin varlığı veya yüksekliği bilinmiyor. Bu pencereler yangın anında kaçış yolunu dumanla doldurabilir.",
    level: RiskLevel.unknown,
  );

  static final kapiOptionA = ChoiceResult(
    label: "24-3-A (Kapı)",
    uiTitle:
        "Çelik, yangına dayanıklı, duman sızdırmaz, bırakınca kendiliğinden kapanıyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Dış geçide açılan kapı yangına dayanıklı, duman sızdırmaz ve kendiliğinden kapanır özelliktedir.",
    level: RiskLevel.positive,
  );

  static final kapiOptionB = ChoiceResult(
    label: "24-3-B (Kapı)",
    uiTitle: "Yangına dayanıksız, kendiliğinden kapanmıyor.",
    uiSubtitle: "Kapı ahşap, pvc, demir vs.",
    reportText:
        "KRİTİK RİSK: Dış kaçış geçitlerine açılan kapılar en az 30 dakika yangına dayanıklı olmalı ve bırakınca kendiliğinden kapanmalıdır.",
    level: RiskLevel.critical,
  );

  static final kapiOptionC = ChoiceResult(
    label: "24-3-C (Kapı)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Dış kaçış geçidine açılan kapıların yangın dayanımı ve sızdırmazlık özellikleri bilinmiyor. Yangın Güvenlik Uzmanı tarafından yerinde kontrol edilmesi önerilir.",
    level: RiskLevel.unknown,
  );
}

class Bolum25Content {
  static final genislikOptionA = ChoiceResult(
    label: "25-1-A",
    uiTitle: "Genişlik < 100 cm",
    uiSubtitle: "Merdiven kol genişliği 100 cm'den az.",
    reportText:
        "KRİTİK RİSK: Döner merdiven genişliği 100 cm'den azdır. Yönetmelik gereği döner merdivenlerin kaçış yolu sayılabilmesi için en az 100 cm genişlik şarttır.",
    adviceText:
        "Genişliği 100 cm altında kalan döner merdivenler yasal kaçış yolu kabul edilmez. Binaya, yönetmeliğe uygun şekilde başka kaçış yolu veya yolları ilave edilmesi gerekebilir. Karar verilebilmesi için binanın mimari projesi veya sahada inceleme yapılması gerekir.",
    level: RiskLevel.critical,
  );

  static final genislikOptionB = ChoiceResult(
    label: "25-1-B",
    uiTitle: "Genişlik ≥ 100 cm",
    uiSubtitle: "Merdiven kol genişliği yeterli.",
    reportText:
        "OLUMLU: Dairesel (döner) merdiven genişliği 100 cm ve üzerindedir. Kattaki kişi sayısı 25 kişiyi aşmıyorsa döner (dairesel) merdiven kullanılabilir. 25 kişiyi aşıyorsa döner (dairesel) merdiven kullanılamaz. Katlardaki kullanıcı yükü hesabı için bu Uygulamada yapılan hesaplamalar referans alınabilir.",
    level: RiskLevel.positive,
  );

  static final genislikOptionC = ChoiceResult(
    label: "25-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Dairesel (döner) merdiven genişliği tespit edilememiştir. Genişliğin 100 cm altında olması veya kullanıcı yükünün 25 kişiyi aşması durumunda bu merdiven kaçış yolu sayılamaz.",
    level: RiskLevel.unknown,
  );
  static final basamakOptionA = ChoiceResult(
    label: "25-2-A",
    uiTitle: "Evet, rahat basılıyor.",
    uiSubtitle: "Basamağın orta kısmı en az 25 cm genişlikte.",
    reportText:
        "Dairesel merdivenin basamak genişliği (basış yüzeyi) yeterli seviyededir.",
    level: RiskLevel.positive,
  );

  static final basamakOptionB = ChoiceResult(
    label: "25-2-B",
    uiTitle: "Hayır, basamaklar çok dar.",
    uiSubtitle: "Basamaklar üçgen şeklinde, basış alanı yetersiz.",
    reportText:
        "KRİTİK RİSK: Dairesel merdivenin basamak genişliği yetersizdir. Dar basamaklar tahliye sırasında düşme riski oluşturur.",
    adviceText:
        "Basamakların en dar noktasında basış genişliğinin artırılması için basamak yapısının revize edilmesi veya merdivenin ana kaçış yolu olarak kullanılmaması planlanmalıdır.",
    level: RiskLevel.critical,
  );

  static final basamakOptionC = ChoiceResult(
    label: "25-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Döner merdiven basamak genişliği bilinmemektedir. Binanın tahliyesinde bu dairesel merdiven kritik bir rol oynuyorsa proje üzerindnen veya yerinde merdivenin incelenmesi gereklidir.",
    level: RiskLevel.unknown,
  );

  static final basKurtarmaOptionA = ChoiceResult(
    label: "25-3-A",
    uiTitle: "Standart (2.50 metreden yüksek).",
    uiSubtitle: "İnerken başınız tavana veya üst basamağa değmiyor.",
    reportText: "OLUMLU: Baş kurtarma yüksekliği yeterli seviyededir.",
    level: RiskLevel.positive,
  );

  static final basKurtarmaOptionB = ChoiceResult(
    label: "25-3-B",
    uiTitle: "Alçak (2.10 ila 2.50 metre arası).",
    uiSubtitle: "Tavan alçak, baş çarpma riski var.",
    reportText:
        "KRİTİK RİSK: Baş kurtarma yüksekliği sınır değerlerin altındadır (2.50m altı).",
    adviceText:
        "Tahliye anında yaralanmaları önlemek için tavanın alçak olduğu noktalara yumuşak koruyucu pedler ve fosforlu uyarı işaretleri yerleştirilmelidir.",
    level: RiskLevel.critical,
  );

  static final basKurtarmaOptionC = ChoiceResult(
    label: "25-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Baş kurtarma yüksekliği tespit edilememiştir, en az 2,50 metre yükseklik olmalıdır.",
    level: RiskLevel.unknown,
  );
}

class Bolum26Content {
  static final varlikOptionA = ChoiceResult(
    label: "26-1-A",
    uiTitle: "Hayır, sadece merdiven var, rampa yok.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Binada rampa bulunmadığından Yönetmeliğe göre bu konuda bir değerlendirme yapılmaz.",
    level: RiskLevel.positive,
  );

  static final varlikOptionB = ChoiceResult(
    label: "26-1-B",
    uiTitle: "Evet, rampa var.",
    uiSubtitle: "",
    reportText:
        "UYARI: Binada kaçış rampası tespit edilmiştir. Eğimi ve sahanlık durumu Yönetmelik kriterlerine uygun olmalıdır. Aksi halde rampa kaçış yolu olarak kullanılamaz.",
    level: RiskLevel.warning,
  );

  static final varlikOptionC = ChoiceResult(
    label: "26-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Binada kaçış rampası olup olmadığı veya konumu tespit edilememiştir. Eğimi ve sahanlık durumu Yönetmelik kriterlerine uygun olmalıdır. Aksi halde rampa kaçış yolu olarak kullanılamaz.",
    level: RiskLevel.unknown,
  );

  static final egimOptionA = ChoiceResult(
    label: "26-2-A",
    uiTitle: "Eğim az (%10'dan az) ve zemin kaymaz.",
    uiSubtitle: "Rahat yürünüyor, zeminde kaymaz bant veya malzeme var.",
    reportText:
        "OLUMLU: Rampa eğimi ve zemin kaplaması kaçış güvenliği için yeterli seviyededir.",
    level: RiskLevel.positive,
  );

  static final egimOptionB = ChoiceResult(
    label: "26-2-B",
    uiTitle: "Eğim fazla dik (%10'dan fazla) veya zemin kaygan.",
    uiSubtitle: "Yürürken insanı zorluyor, kayma tehlikesi var.",
    reportText:
        "KRİTİK RİSK: Kaçış rampalarının eğimi %10'dan fazla olamaz. Dik ve kaygan rampalar panik anında düşmelere sebep olur.",
    adviceText:
        "Eğimi düşürmek mümkün değilse, rampa yüzeyine kaydırmaz bant uygulaması yapılmalı ve her iki tarafa tutunma küpeştesi eklenmelidir.",
    level: RiskLevel.critical,
  );

  static final egimOptionC = ChoiceResult(
    label: "26-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Rampa eğimi ve zemin kaymazlık durumu bilinmiyor. Kaçış yolu üzerinde %10 'dan fazla eğimli rampa varsa bu rampa kaçış yolu olarak kullanılamaz.",
    level: RiskLevel.unknown,
  );

  static final sahanlikOptionA = ChoiceResult(
    label: "26-3-A",
    uiTitle: "Evet, sahanlık var, kapı önleri ve dönüşleri düz.",
    uiSubtitle: "Rampa başlangıç ve bitişinde güvenli düzlükler var.",
    reportText: "OLUMLU: Rampa sahanlıkları ve kapı önü düzlükleri mevcuttur.",
    level: RiskLevel.positive,
  );

  static final sahanlikOptionB = ChoiceResult(
    label: "26-3-B",
    uiTitle: "Hayır, rampadan önce veya sonra eğim var.",
    uiSubtitle: "Kapıyı açınca direkt eğimli yüzeye basılıyor.",
    reportText:
        "UYARI: Rampa giriş ve çıkışlarında, kapı önlerinde mutlaka düz sahanlık bulunmalıdır.",
    level: RiskLevel.warning,
  );

  static final sahanlikOptionC = ChoiceResult(
    label: "26-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Rampa sahanlıklarının varlığı ve kapı önü düzlükleri bilinmiyor.",
    level: RiskLevel.unknown,
  );

  static final otoparkOptionA = ChoiceResult(
    label: "26-4-A",
    uiTitle: "Evet, eğimi uygun (%10 'un altı).",
    uiSubtitle: "Araç rampası yürüyerek çıkmaya müsait.",
    reportText:
        "OLUMLU: Otopark rampası, eğimi uygun olduğu için 2. kaçış yolu olarak kabul edilebilir.",
    level: RiskLevel.positive,
  );

  static final otoparkOptionB = ChoiceResult(
    label: "26-4-B",
    uiTitle: "Hayır, çok dik (%10'dan fazla) veya zemin kaygan.",
    uiSubtitle: "Rampayı sadece araçlar kullanabilir.",
    reportText:
        "BİLGİ: Otopark rampası %10'dan fazla eğime sahiptir. Eğer otopark içerisinden bina içerisine (merdiven veya asansör holüne) tahliye imkanı varsa ve bu çıkışlar otoparktaki kişi sayısı için yeterli genişlikte ise, rampanın dik olması kaçış güvenliği açısından kritik risk oluşturmaz.",
    level: RiskLevel.critical,
  );

  static final otoparkOptionC = ChoiceResult(
    label: "26-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Otopark rampasının kaçış yolu olarak kullanılabilirliği belirsizdir.",
    level: RiskLevel.unknown,
  );
}

class Bolum27Content {
  // 1. BOYUT VE EŞİK
  static final boyutOptionA = ChoiceResult(
    label: "27-1-A",
    uiTitle: "80 cm'den geniş ve eşiksiz.",
    uiSubtitle: "Geçiş rahat ve ayağın takılma ihtimali yok.",
    reportText:
        "OLUMLU: Kaçış kapısı genişliği (min. 80cm) ve zemin düzgünlüğü uygundur.",
    level: RiskLevel.positive,
  );

  static final boyutOptionB = ChoiceResult(
    label: "27-1-B",
    uiTitle: "80 cm'den dar veya eşikli.",
    uiSubtitle: "Geçiş zor veya ayağın takılma ihtimali var.",
    reportText:
        "KRİTİK RİSK: Kaçış kapılarında temiz geçiş genişliği en az 80 cm olmalıdır. Ayrıca takılıp düşmeye sebep olacak 'Eşik'bulunması kesinlikle yasaktır.",
    level: RiskLevel.critical,
  );

  static final boyutOptionC = ChoiceResult(
    label: "27-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kapı ölçüleri ve eşik durumu bilinmiyor. Dar kapılar ve eşikler panik anında yığılmalara neden olabilir.",
    level: RiskLevel.unknown,
  );

  // 2. YÖN
  static final yonOptionA = ChoiceResult(
    label: "27-2-A",
    uiTitle: "Hepsi dışarıya doğru (kaçış yönünde) açılıyor.",
    uiSubtitle: "Kapıyı itince açılıyor.",
    reportText: "OLUMLU: Kapı açılış yönü (kaçış yönü) doğrudur.",
    level: RiskLevel.positive,
  );

  static final yonOptionB = ChoiceResult(
    label: "27-2-B",
    uiTitle: "Hepsi içeriye doğru açılıyor.",
    uiSubtitle: "",
    reportText:
        "UYARI: Kullanıcı yükü 50 kişiyi geçen mahallerde ve katlarda kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır.",
    adviceText:
        "Mevcut kapı kasası sökülüp ters çevrilerek veya menteşe yönü değiştirilerek kapının kaçış yönüne (dışarıya) açılması sağlanmalıdır.",
    level: RiskLevel.warning,
  );

  static final yonOptionC = ChoiceResult(
    label: "27-2-C",
    uiTitle: "Turnike, döner veya sürgülü kapı mevcut.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Kaçış yolunda döner kapı veya sürgülü kapı kullanılamaz. Bu tip kapıların yanında mutlaka kollu veya panik barlı normal kapı bulunmalıdır. Turnikeler varsa ve yangın anında serbest kalmıyorsa kaçış yolu olarak kullanılamaz.",
    level: RiskLevel.critical,
  );

  static final yonOptionD = ChoiceResult(
    label: "27-2-D",
    uiTitle: "Farkı tip kapılar mevcut.",
    uiSubtitle: "Kaçış yolu üzerinde farklı yönlere açılan kapılar mevcut.",
    reportText:
        "UYARI: Kaçış yolu üzerinde farklı tip ve farklı yönlere açılan kapılar tespit edilmiştir. Tahliye güzergahındaki tüm kapıların kaçış yönüne açılması ve sürgülü/döner kapı içermemesi esastır. Karma yapı panik anında izdihama yol açabilir. Kullanıcı yükü 50 kişiyi geçen mahallerde ve katlarda kapılar mutlaka kaçış yönüne (dışarıya) doğru açılmalıdır.",
    level: RiskLevel.warning,
  );

  static final yonOptionE = ChoiceResult(
    label: "27-2-E",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kapı açılma yönü ve kapı tipleri bilinmiyor. Yerinde inceleme yapılarak kaçış yolu üzerindeki kapıların özellikleri hususi olarak kontrol edilmelidir.",
    level: RiskLevel.unknown,
  );

  // 3. KİLİT MEKANİZMASI
  static final kilitOptionA = ChoiceResult(
    label: "27-3-A",
    uiTitle: "Panik bar mekanizması var.",
    uiSubtitle: "Vücutla itince açılıyor.",
    reportText:
        "OLUMLU: Kapıda panik bar mekanizması mevcuttur, Yönetmelik gereksinimini karşılamaktadır.",
    level: RiskLevel.positive,
  );

  static final kilitOptionB = ChoiceResult(
    label: "27-3-B",
    uiTitle: "Normal kapı kolu var.",
    uiSubtitle: "",
    reportText:
        "UYARI: Kullanıcı yükü 100 kişiyi aşmayan yerlerde kapı kolu kabul edilebilir. 100 kişiyi aşan yerlerde Panik Bar zorunludur.",
    level: RiskLevel.warning,
  );

  static final kilitOptionC = ChoiceResult(
    label: "27-3-C",
    uiTitle: "Anahtar gerekiyor veya kilitli tutuluyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Kaçış yolu kapıları ASLA kilitlenemez. Her an tek hamlede açılabilir olmalıdır.",
    adviceText:
        "Kapıdaki kilit mekanizması iptal edilmeli, kapı her an içeriden kollu veya panik barlı sistemle açılabilir hale getirilmelidir.",
    level: RiskLevel.critical,
  );

  static final kilitOptionD = ChoiceResult(
    label: "27-3-D",
    uiTitle: "Karma (Bazı kapılar panik barlı, bazıları kollu veya kilitli).",
    uiSubtitle: "",
    reportText:
        "UYARI: Kaçış güzergahında karma kilit sistemleri mevcuttur. Kullanıcı yükü 100 kişiyi aşan binalarda tüm kapıların panik bar ile donatılması şarttır. Bazı kapıların kilitli olması veya anahtar gerektirmesi tahliyeyi imkansız kılar.",
    level: RiskLevel.warning,
  );

  static final kilitOptionE = ChoiceResult(
    label: "27-3-E",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kilit mekanizması kontrol edilmelidir. Kilitli kapılar can kaybına neden olabilir. Kaçış güzergahında karma kilit sistemleri mevcuttur. Kullanıcı yükü 100 kişiyi aşan binalarda tüm kapıların panik bar ile donatılması şarttır.",
    level: RiskLevel.unknown,
  );

  // 4. DAYANIM
  static final dayanimOptionA = ChoiceResult(
    label: "27-4-A",
    uiTitle:
        "Çelik, yangına dayanıklı, duman sızdırmaz, kendiliğinden kapanıyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Yangın kapısı kullanılması olumlu bir durumdur. Kapının yangın dayanım test raporu incelendikten sonra tam olarak uygunluğuna karar verilir.",
    level: RiskLevel.positive,
  );

  static final dayanimOptionB = ChoiceResult(
    label: "27-4-B",
    uiTitle:
        "Çelik, yangına dayanıklı, duman sızdırmaz ancak kendiliğinden kapanmıyor.",
    uiSubtitle: "Hidroliği veya menteşeleri arızalı.",
    reportText:
        "UYARI: Yangın kapıları her zaman otomatik kapanır durumda olmalıdır.",
    level: RiskLevel.warning,
  );

  static final dayanimOptionC = ChoiceResult(
    label: "27-4-C",
    uiTitle: "Ahşap, PVC veya cam kapı (dayanıksız).",
    uiSubtitle: "Yangın kapısı değildir.",
    reportText:
        "KRİTİK RİSK: Yangın merdiveni kapıları yanıcı malzemeden (Ahşap/PVC) yapılamaz. Bu Uygulama'nın Bölüm-14'ünde yer alan şaft kapağı yangın dayanım süresiyle aynı dayanım süresi alınabilir. Yangın kapısı en az 60 dk yangına dayanıklı olmalıdır.",
    level: RiskLevel.critical,
  );

  static final dayanimOptionD = ChoiceResult(
    label: "27-4-D",
    uiTitle: "Karma (Bazı kapılar yangına dayanıklı, bazıları dayanıksız).",
    uiSubtitle: "Farklı katlarda farklı özellikte kapılar mevcut.",
    reportText:
        "KRİTİK RİSK: Kaçış merdivenine açılan kapıların bir kısmının yangına dayanıksız (Ahşap/PVC/Cam) olması, yangın kompartıman bütünlüğünü bozar. Tüm kapıların sertifikalı yangın kapısı olması zorunludur.",
    level: RiskLevel.critical,
  );

  static final dayanimOptionE = ChoiceResult(
    label: "27-4-E",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kaçış yolu üzerindeki kapıların özellikleri bilinmiyor. Uzman tarafından yerinde inceleme yapılması önerilir.",
    level: RiskLevel.unknown,
  );
}

class Bolum28Content {
  static final muafiyetOption = ChoiceResult(
    label: "28-1 (Muafiyet)",
    uiTitle: "(Otomatik Ekran)",
    uiSubtitle: "(Kullanıcı seçim yapmaz, sistem gösterir)",
    reportText:
        "OLUMLU: Binanız bodrum dahil 4 katı geçmemektedir ve binada konut harici ticari alan da bulunmamaktadır. Yapı tek kullanım amaçlı olup, özel bir yangın merdiveni veya kaçış mesafesi şartı aranmaz.",
    level: RiskLevel.positive,
  );

  static final mesafeOptionA = ChoiceResult(
    label: "28-2-A (Mesafe)",
    uiTitle: "20 metreden az.",
    uiSubtitle: "En uzak odadan daire kapısına kadar olan mesafe.",
    reportText:
        "OLUMLU: Daire içi kaçış mesafesi 20 metrenin altındadır, Yönetmelik talebi karşılanıyor.",
    level: RiskLevel.positive,
  );

  static final mesafeOptionB = ChoiceResult(
    label: "28-2-B (Mesafe)",
    uiTitle: "20 ila 30 metre arası.",
    uiSubtitle: "",
    reportText:
        "(Binada sprinkler varsa) OLUMLU: Sprinkler sistemi olduğu için 30 metreye kadar izin verilir.(Binada sprinkler yoksa) KRİTİK RİSK: Sprinkler olmayan dairelerde en uzak noktadan çıkışa mesafe 20 metreyi geçemez.",
    level: RiskLevel.critical,
  );

  static final mesafeOptionC = ChoiceResult(
    label: "28-2-C (Mesafe)",
    uiTitle: "30 metreden fazla.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Binanın tamamında sprinkler sistemi olsa bile daire içi kaçış mesafesi 30 metreyi geçemez.",
    level: RiskLevel.critical,
  );

  static final dubleksOptionA = ChoiceResult(
    label: "28-3-A (Dubleks)",
    uiTitle: "Hayır, tek katlı daire.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Tek katlı daire olduğu beyan edilmiştir. Ek bir değerlendirme gerekmez.",
    level: RiskLevel.positive,
  );

  static final dubleksOptionB = ChoiceResult(
    label: "28-3-B (Dubleks)",
    uiTitle: "Evet, dubleks (çift katlı)",
    uiSubtitle: "",
    reportText:
        "Dubleks daire olduğu beyan edilmiştir. Alt sorulara göre değerlendirme yapılacaktır.",
    level: RiskLevel.positive,
  );

  static final alanOption1 = ChoiceResult(
    label: "28-3-B-1 (Alan)",
    uiTitle: "Üst kat 70 m²'den küçük.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Üst kat alanı 70 m²'den küçük olduğu için tek çıkış yeterlidir.",
    level: RiskLevel.positive,
  );

  static final alanOption2 = ChoiceResult(
    label: "28-3-B-2 (Alan)",
    uiTitle: "Üst kat 70 m²'den büyük.",
    uiSubtitle: "",
    reportText:
        "Üst kat alanı 70 m²'yi geçtiği için ek bir çıkış kapısı gereklidir.",
    level: RiskLevel.positive,
  );

  static final cikisOptionA = ChoiceResult(
    label: "28-3-B-2-A (Çıkış)",
    uiTitle: "Evet, üst katta kapı var.",
    uiSubtitle: "Üst kattan apartmana çıkış mevcut.",
    reportText:
        "OLUMLU: Üst kat alanı 70 m²'yi geçtiği için yapılan ikinci çıkış kapısı olması halinde Yönetmelik talebi karşılanmaktadır.",
    level: RiskLevel.positive,
  );

  static final cikisOptionB = ChoiceResult(
    label: "28-3-B-2-B (Çıkış)",
    uiTitle: "Hayır, üst katta kapı yok.",
    uiSubtitle: "Sadece alt kattan çıkılabiliyor.",
    reportText:
        "KRİTİK RİSK: Dubleks dairelerde üst kat alanı 70 m²'yi geçerse, üst kattan da apartman koridoruna açılan ikinci bir çıkış kapısı olması zorunludur.",
    level: RiskLevel.critical,
  );
}

class Bolum29Content {
  // 1. OTOPARK
  static final otoparkOptionA = ChoiceResult(
    label: "29-1-A",
    uiTitle: "Hayır, sadece taşıtlar var, alan temiz ve düzenli.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Otopark alanı temiz, farklı risk grubuna ait depolama yapılmamıştır.",
    level: RiskLevel.positive,
  );
  static final otoparkOptionB = ChoiceResult(
    label: "29-1-B",
    uiTitle: "Evet, lastik, mobilya vb. eşya yığınları var.",
    uiSubtitle: "",
    reportText:
        "UYARI: Otopark alanlarında araçlar haricinde hiçbir yanıcı malzeme (kışlık lastik, koli, eski eşya vb.) depolanmamalıdır. Araç yangınlarında bu malzemeler yangını hızla büyüterek kontrol edilemez hale getirir.",
    level: RiskLevel.warning,
  );
  static final otoparkOptionC = ChoiceResult(
    label: "29-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Otoparkın temizlik durumu bilinmiyor. Araçların yanına istiflenen eski lastikler veya eşyalar, küçük bir araç yangınını tüm binayı saracak bir felakete dönüştürebilir. Lütfen otoparkı kontrol ediniz.",
    level: RiskLevel.unknown,
  );

  // 2. KAZAN DAİRESİ
  static final kazanOptionA = ChoiceResult(
    label: "29-2-A",
    uiTitle: "Hayır, sadece kazanlar var, temiz ve düzenli.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Kazan dairesinde gereksiz yanıcı madde bulunmamaktadır.",
    level: RiskLevel.positive,
  );
  static final kazanOptionB = ChoiceResult(
    label: "29-2-B",
    uiTitle: "Evet, gereksiz eşyalar var.",
    uiSubtitle: "",
    reportText:
        "UYARI: Kazan daireleri depo değildir. Yakıt tankının veya kazanın yanındaki en ufak bir kıvılcım, oradaki eşyaları tutuşturup binayı tehlikeye atar.",
    adviceText:
        "Kazan dairesi giriş kapısına 'Depolama Yapılmaz' benzeri bir uyarı levhası asılmalı ve periyodik kazan bakımlarında temizlik durumu 'Bakım Formu'na işlenerek takip edilmelidir.",
    level: RiskLevel.warning,
  );
  static final kazanOptionC = ChoiceResult(
    label: "29-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kazan dairesinin içi bilinmiyor. Burası binanın kalbidir ve en yüksek yangın riskini taşır. İçeride unutulan bir bez parçası veya kağıt yığını büyük bir patlamaya neden olabilir. Mutlaka denetlenmelidir.",
    level: RiskLevel.unknown,
  );

  // 3. ÇATI ARASI
  static final catiOptionA = ChoiceResult(
    label: "29-3-A",
    uiTitle: "Hayır, boş ve kilitli.",
    uiSubtitle: "",
    reportText: "OLUMLU: Çatı arası temiz ve güvenlidir.",
    level: RiskLevel.positive,
  );
  static final catiOptionB = ChoiceResult(
    label: "29-3-B",
    uiTitle: "Evet, depo gibi kullanılıyor.",
    uiSubtitle:
        "Eski eşyalar, mobilya, temizlik ürünleri vb. farklı yanıcı maddeler vs. var.",
    reportText:
        "UYARI: Çatı araları elektrik kontağından en çok yangın görülen yerlerdir. Buradaki fazla eşyalar yangına sebep olur veya mevcut yangına katkı sağlayarak hızlandırır.",
    adviceText:
        "Çatı arasına erişim kapağı sürekli kilitli tutulmalı, anahtar sadece yetkili kişide bulunmalı ve yılda en az iki kez çatı arası temizlik kontrolü yapılması önerilir.",
    level: RiskLevel.warning,
  );
  static final catiOptionC = ChoiceResult(
    label: "29-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çatı arasının durumu bilinmiyor. Genellikle fazla eşyaların biriktirildiği yerdir. Elektrik tesisatından çıkabilecek bir kıvılcım, buradaki kuru ve tozlu eşyaları anında tutuşturur. Kontrol edilmesi hayati önem taşır.",
    level: RiskLevel.unknown,
  );

  // 4. ASANSÖR ve MAKİNE DAİRESİ
  static final asansorOptionA = ChoiceResult(
    label: "29-4-A",
    uiTitle: "Hayır, temiz.",
    uiSubtitle: "Makine dairesinde sadece motor var.",
    reportText: "OLUMLU: Asansör makine dairesi temizdir.",
    level: RiskLevel.positive,
  );
  static final asansorOptionB = ChoiceResult(
    label: "29-4-B",
    uiTitle: "Evet, malzemeler var.",
    uiSubtitle: "Yağ tenekesi, bez vs. yanıcı maddeler var.",
    reportText:
        "UYARI: Asansör motorları ısınır. Yanındaki yağlı bezler veya kauçuk vb. diğer malzemeler tutuşabilir. Makine dairesi depo olarak kullanılamaz.",
    level: RiskLevel.warning,
  );
  static final asansorOptionC = ChoiceResult(
    label: "29-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Asansör makine dairesinin durumu bilinmiyor. Motorların ısınmasıyla yanabilecek yağlı bezler veya kauçuk vb. diğer malzemeler burada büyük risk oluşturur.",
    level: RiskLevel.unknown,
  );

  // 5. JENERATÖR ODASI
  static final jeneratorOptionA = ChoiceResult(
    label: "29-5-A",
    uiTitle: "Hayır.",
    uiSubtitle: "Sadece jeneratör ve ilgili ekipmanlar var.",
    reportText: "OLUMLU: Jeneratör odası temizdir.",
    level: RiskLevel.positive,
  );
  static final jeneratorOptionB = ChoiceResult(
    label: "29-5-B",
    uiTitle: "Evet.",
    uiSubtitle: "Yanıcı malzemeler, eşya vb. bekletiliyor.",
    reportText:
        "UYARI: Jeneratör odasında sadece günlük yakıt tankı bulunabilir. Bidonla yakıt saklamak veya eşya koymak yasaktır.",
    level: RiskLevel.warning,
  );
  static final jeneratorOptionC = ChoiceResult(
    label: "29-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Jeneratör odasının durumu bilinmiyor. İçeride yakıt buharı olabilir. Depolanan gereksiz eşyalar havalandırmayı tıkayabilir veya yangın yükünü artırabilir. Uzman kontrolü önerilir.",
    level: RiskLevel.unknown,
  );

  // 6. ELEKTRİK PANO ODASI
  static final panoOptionA = ChoiceResult(
    label: "29-6-A",
    uiTitle: "Hayır.",
    uiSubtitle: "Pano odası boş.",
    reportText: "OLUMLU: Elektrik pano odası temizdir.",
    level: RiskLevel.positive,
  );
  static final panoOptionB = ChoiceResult(
    label: "29-6-B",
    uiTitle: "Evet.",
    uiSubtitle: "Paspas, süpürge, kağıt vb. saklanıyor.",
    reportText:
        "UYARI: Pano odaları kesinlikle boş olmalıdır. Elektrik kontağı anında yanıcı malzemeleri tutuşturur.",
    adviceText:
        "Elektrik pano odaları temizlik malzemesi deposu değildir. Paspas, süpürge, kağıt havlu gibi malzemeler, oluşabilecek en ufak bir kıvılcımda tutuşarak ana elektrik dağıtım sistemini devre dışı bırakır ve binayı karanlığa gömer.",
    level: RiskLevel.warning,
  );
  static final panoOptionC = ChoiceResult(
    label: "29-6-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Elektrik odasının içi bilinmiyor. Pano odaları yangınların en sık başladığı yerlerdir. İçeride unutulan bir paspas veya kağıt parçası, küçük bir ark (kıvılcım) sonucu büyük bir yangını başlatabilir.",
    level: RiskLevel.unknown,
  );

  // 7. TRAFO ODASI
  static final trafoOptionA = ChoiceResult(
    label: "29-7-A",
    uiTitle: "Evet, temiz ve havadar.",
    uiSubtitle: "",
    reportText: "OLUMLU: Trafo odası havalandırılıyor ve temiz tutuluyor.",
    level: RiskLevel.positive,
  );
  static final trafoOptionB = ChoiceResult(
    label: "29-7-B",
    uiTitle: "Hayır, menfezler kapalı veya içeride eşya var.",
    uiSubtitle: "",
    reportText:
        "UYARI: Özellikle yağlı trafolar yanma ve patlama riski taşır. Havalandırma asla kapatılmamalı ve içerisi depo yapılmamalıdır.",
    level: RiskLevel.warning,
  );
  static final trafoOptionC = ChoiceResult(
    label: "29-7-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Trafo odasının durumu bilinmiyor. Yüksek gerilim hattı taşıyan bu odaların havalandırmasının kapanması veya içeride eşya olması patlama riskini doğurur. Acilen kontrol edilmelidir.",
    level: RiskLevel.unknown,
  );
  // 8. ORTAK DEPO
  static final depoOptionA = ChoiceResult(
    label: "29-8-A",
    uiTitle: "Hayır, sadece ev eşyası.",
    uiSubtitle: "Yüksek yanıcı madde yok.",
    reportText: "OLUMLU: Depolarda parlayıcı madde tespit edilmemiştir.",
    level: RiskLevel.positive,
  );
  static final depoOptionB = ChoiceResult(
    label: "29-8-B",
    uiTitle: "Evet, boya kutuları veya kimyasallar var.",
    uiSubtitle: "Yanıcı kimyasallar saklanıyor.",
    reportText:
        "UYARI: Apartman altındaki depolarda parlayıcı madde saklamak yasaktır. Bu malzemeler özel güvenlikli dolaplarda tutulmalıdır.",
    level: RiskLevel.warning,
  );
  static final depoOptionC = ChoiceResult(
    label: "29-8-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Depolarda ne saklandığı bilinmiyor. Komşularınızın buraya koyduğu tiner, boya veya LPG tüpü gibi malzemeler tüm binayı riske atabilir. Depo denetimi yapılmalıdır.",
    level: RiskLevel.unknown,
  );

  // 9. ÇÖP ODASI
  static final copOptionA = ChoiceResult(
    label: "29-9-A",
    uiTitle: "Düzenli atılıyor, temiz.",
    uiSubtitle: "Yoğun koku veya gaz birikmesi yok.",
    reportText: "OLUMLU: Çöp odası temizliği uygun gözüküyor.",
    level: RiskLevel.positive,
  );
  static final copOptionB = ChoiceResult(
    label: "29-9-B",
    uiTitle: "Çöpler birikiyor, hijyen kötü.",
    uiSubtitle: "Hijyen kötü, yoğun koku var.",
    reportText:
        "UYARI: Biriken çöpler metan gazı oluşturur ve kendiliğinden yanabilir. Günlük temizlik yapılması önerilir.",
    level: RiskLevel.warning,
  );
  static final copOptionC = ChoiceResult(
    label: "29-9-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çöp odasının temizlik durumu bilinmiyor. İyi hava almayan mekanlarda biriken çöplerden sızan metan gazı, kapalı alanda patlama riski oluşturur. Havalandırma ve temizlik kontrol edilmelidir.",
    level: RiskLevel.unknown,
  );

  // 10. SIĞINAK
  static final siginakOptionA = ChoiceResult(
    label: "29-10-A",
    uiTitle: "Hayır.",
    uiSubtitle: "",
    reportText: "OLUMLU: Sığınakta yanıcı madde depolanmamaktadır.",
    level: RiskLevel.positive,
  );
  static final siginakOptionB = ChoiceResult(
    label: "29-10-B",
    uiTitle: "Evet.",
    uiSubtitle: "Boya, tiner, tüp vb. var.",
    reportText: "UYARI: Sığınakta yanıcı madde konulamaz.",
    level: RiskLevel.warning,
  );
  static final siginakOptionC = ChoiceResult(
    label: "29-10-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Sığınağın kullanım durumu bilinmiyor. Kontrolsüzce yığılan eşyalar, sığınağı güvenli bir alan olmaktan çıkarabilir. Kontrol edilmesi tavsiye edilir.",
    level: RiskLevel.unknown,
  );
}

class Bolum30Content {
  // --- 1. KONUM ---
  static final konumOptionA = ChoiceResult(
    label: "30-1-A",
    uiTitle:
        "Duvarları ve kapısı yangına dayanıklı bir koridora veya hole açılıyor.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Kazan dairesi kapısı yangına dayanıklı bir koridora açılmaktadır.",
    level: RiskLevel.positive,
  );
  static final konumOptionB = ChoiceResult(
    label: "30-1-B",
    uiTitle: "Direkt merdiven boşluğuna açılıyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Kazan dairesi kapısı ASLA doğrudan merdiven boşluğuna açılamaz. Olası bir patlama veya gaz sızıntısında merdiven kullanılamaz hale gelir.",
    level: RiskLevel.critical,
  );
  static final konumOptionC = ChoiceResult(
    label: "30-1-C",
    uiTitle: "Binadan ayrı (dış cepheden uzakta veya bahçede).",
    uiSubtitle: "",
    reportText: "OLUMLU: Kazan dairesi bina dışındadır.",
    level: RiskLevel.positive,
  );
  static final konumOptionD = ChoiceResult(
    label: "30-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kazan dairesinin konumu ve kapı açılış yönü bilinmiyor. Yangın anında müdahale ve tahliye güvenliği için bu alanın denetlenmesi önerilir.",
    level: RiskLevel.unknown,
  );

  // --- 2. KAPASİTE ---
  static final kapasiteBilinmiyorOption = ChoiceResult(
    label: "30-2-BILMIYORUM",
    uiTitle: "Kazan dairesinin ısıl kapasitesini bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "UYARI: Kazan dairesinin ısıl kapasitesi eğer 350kw 'ın üzerindeyse veya mahal alanı 100 m2 'nin üzerindeyse (alternatif yönde konumlanan) çift çıkış kapısı gereklidir.",
    level: RiskLevel.warning,
  );

  // --- 3. KAPI SAYISI ---
  static final kapiOptionA = ChoiceResult(
    label: "30-3-A",
    uiTitle: "1 Adet Kapı.",
    uiSubtitle: "",
    reportText:
        "(Büyük Kazan İse) KRİTİK RİSK: Girdiğiniz bilgilere göre kazan daireniz 'Büyük/Yüksek Kapasiteli'sınıfındadır. Yönetmeliğe göre en az 2 adet çıkış kapısı zorunludur.<br>(Küçük Kazan İse) OLUMLU: Kapı sayısı yeterlidir.",
    level: RiskLevel.critical,
  );
  static final kapiOptionB = ChoiceResult(
    label: "30-3-B",
    uiTitle: "2 Adet (veya daha fazla).",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Kazan dairesinde birden fazla çıkış mevcuttur. Mahal alanı 100 m2 'nin altındaysa 1 adet çıkış yeterlidir, üzerindeyse alternatif yönlerde konumlandırılan 2 adet çıkış gereklidir.",
    level: RiskLevel.positive,
  );
  static final kapiOptionC = ChoiceResult(
    label: "30-3-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kazan dairesi çıkış kapısı sayısı bilinmiyor. Büyük kapasiteli kazanlarda acil durum tahliyesi için en az 2 çıkış şarttır.",
    level: RiskLevel.unknown,
  );

  // --- 4. HAVALANDIRMA ---
  static final havaOptionA = ChoiceResult(
    label: "30-4-A",
    uiTitle: "EVET, pencere veya havalandırma menfezi var.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Kazan dairesi havalandırması (alt ve üst menfez) uygundur.",
    level: RiskLevel.positive,
  );
  static final havaOptionB = ChoiceResult(
    label: "30-4-B",
    uiTitle: "HAYIR, pencere veya havalandırma menfezi yok.",
    uiSubtitle: "",
    reportText:
        "UYARI: Temiz hava girişi ve kirli hava çıkışı sağlanmazsa verimsiz yanma olur ve karbonmonoksit zehirlenmesi riski doğar.",
    level: RiskLevel.warning,
  );
  static final havaOptionC = ChoiceResult(
    label: "30-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Havalandırma durumu bilinmiyor. Yetersiz havalandırma, yanma verimini düşürür ve patlama riski oluşturur.",
    level: RiskLevel.unknown,
  );

  // --- 5. YAKIT TİPİ ---
  static final yakitOptionA = ChoiceResult(
    label: "30-5-A",
    uiTitle: "Doğalgazlı, kömürlü.",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Kazan yakıtı sıvı yakıt (fuel-oil vb.) değildir. Doğalgaz tesisatı için gerekli önlemlerin alınması yeterlidir. ",
    level: RiskLevel.info,
  );
  static final yakitOptionB = ChoiceResult(
    label: "30-5-B",
    uiTitle: "Sıvı yakıt.",
    uiSubtitle: "Mazot, fuel-oil vb.",
    reportText:
        "BİLGİ: Kazan sıvı yakıtlıdır. Sızıntı ve drenaj önlemleri kritik önem taşır.",
    level: RiskLevel.info,
  );
  static final yakitOptionC = ChoiceResult(
    label: "30-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Yakıt türü bilinmiyor. Yakıt türüne göre alınması gereken özel önlemler (drenaj, söndürme sistemi vb.) belirlenememiştir.",
    level: RiskLevel.unknown,
  );

  // --- 6. DRENAJ ---
  static final drenajOptionA = ChoiceResult(
    label: "30-5-B-1",
    uiTitle: "Evet, var.",
    uiSubtitle: "Kanal ve çukur mevcut.",
    reportText: "OLUMLU: Sıvı yakıtlı kazanda drenaj sistemi mevcuttur.",
    level: RiskLevel.positive,
  );
  static final drenajOptionB = ChoiceResult(
    label: "30-5-B-2",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "Zemin düz.",
    reportText:
        "UYARI: Sıvı yakıtlı kazan dairelerinde, yakıt sızıntısını toplayacak drenaj kanalları ve yakıt ayırıcılı pis su çukuru zorunludur.",
    level: RiskLevel.warning,
  );
  static final drenajOptionC = ChoiceResult(
    label: "30-5-B-3",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Sıvı yakıtlı kazanlarda sızıntı önleme (drenaj) sistemi olup olmadığı bilinmiyor.",
    level: RiskLevel.unknown,
  );

  // --- 7. TÜP ---
  static final tupOptionA = ChoiceResult(
    label: "30-6-A",
    uiTitle: "Evet, en az 6 kg yangın söndürme tüpü (KKT) mevcut.",
    uiSubtitle: "",
    reportText:
        "UYARI: Yangın söndürme tüpü mevcuttur. Büyük/Yüksek kapasiteli kazan dairelerinde yangın dolabı da olmalıdır.",
    level: RiskLevel.warning,
  );
  static final tupOptionB = ChoiceResult(
    label: "30-6-B",
    uiTitle: "Evet, hem 6 kg yangın söndürme tüpü hem yangın dolabı mevcut.",
    uiSubtitle: "",
    reportText: "OLUMLU: Yangın söndürme ekipmanları tamdır.",
    level: RiskLevel.positive,
  );
  static final tupOptionC = ChoiceResult(
    label: "30-6-C",
    uiTitle: "Hayır, hiçbiri yok.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Kazan dairesinde en az 1 adet 6 kg'lık Kuru Kimyevi Tozlu yangın söndürme cihazı bulunması yasal zorunluluktur.",
    level: RiskLevel.critical,
  );
  static final tupOptionD = ChoiceResult(
    label: "30-6-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Söndürme ekipmanlarının varlığı bilinmiyor. Kazan dairesinde en az 1 adet 6 kg'lık tüp bulunması şarttır.",
    level: RiskLevel.unknown,
  );
}

class Bolum31Content {
  static final yapiOptionA = ChoiceResult(
    label: "31-1-A",
    uiTitle: "Duvarları beton/tuğla, kapısı dışarıya açılıyor.",
    uiSubtitle: "Yangına dayanıklı duvar ve kapı mevcut.",
    reportText:
        "BİLGİ:: Trafo odası yangın kompartımanı olarak tasarlanmıştır. Duvarlar ve kapı yangına dayanıklıdır.",
    level: RiskLevel.info,
  );

  static final yapiOptionB = ChoiceResult(
    label: "31-1-B",
    uiTitle: "Kapısı direkt apartman koridoruna açılıyor.",
    uiSubtitle: "Kapı açılınca bina içine duman dolabilir.",
    reportText:
        "KRİTİK RİSK: Trafo odasından çıkacak yoğun duman ve ısı, kaçış yollarını (merdivenleri) kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır.",
    level: RiskLevel.critical,
  );

  static final yapiOptionC = ChoiceResult(
    label: "31-1-C",
    uiTitle: "Duvarları ve kapısı yangın dayanımsız.",
    uiSubtitle:
        "Dayanıklı olmayan malzeme (alçıpanel, ahşap kapı vb.) kullanılmıştır.",
    reportText:
        "KRİTİK RİSK: Trafo odası yangın bölmesi (kompartıman) olarak tasarlanmalıdır. Yağlı tip trafo odalarının duvarları 120dk, kapısı 90dk yangına dayanıklı olmalıdır.",
    level: RiskLevel.critical,
  );

  static final yapiOptionD = ChoiceResult(
    label: "31-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Trafo odasının yapısal özellikleri (duvar/kapı) tespit edilememiştir. Yangın güvenliği açısından bu alanın kompartıman özelliği Uzmman tarafından incelenmelidir.",
    level: RiskLevel.unknown,
  );

  static final tipOptionA = ChoiceResult(
    label: "31-2-A",
    uiTitle: "Kuru Tip.",
    uiSubtitle: "Yağsız trafo.",
    reportText:
        "OLUMLU: Kuru tip trafo kullanıldığı için yağ sızıntısı ve yangın riski daha azdır.",
    level: RiskLevel.positive,
  );

  static final tipOptionB = ChoiceResult(
    label: "31-2-B",
    uiTitle: "Yağlı Tip.",
    uiSubtitle: "İçinde soğutma yağı var.",
    reportText:
        "Yağlı tip trafolar oldukça risklidir. Bulundukları mahalde özel önlemler alınması şarttır.",
    level: RiskLevel.positive,
  );

  static final tipOptionC = ChoiceResult(
    label: "31-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Trafo tipi (yağlı/kuru) belirlenememiştir. Yağlı tip trafolar daha yüksek yangın riski taşıdığından tip tespiti kritiktir.",
    level: RiskLevel.unknown,
  );

  static final cukurOptionA = ChoiceResult(
    label: "31-2-B-1",
    uiTitle: "Evet, var.",
    uiSubtitle: "Yağ toplama çukuru mevcut.",
    reportText: "OLUMLU: Yağlı trafo altında toplama çukuru mevcuttur.",
    level: RiskLevel.positive,
  );

  static final cukurOptionB = ChoiceResult(
    label: "31-2-B-2",
    uiTitle: "Hayır, düz zemin.",
    uiSubtitle: "Çukur yok, yağ etrafa yayılabilir.",
    reportText:
        "KRİTİK RİSK: Yağlı trafolarda, ısınan yağın taşması veya tankın delinmesi durumunda yanıcı yağın çevreye yayılmaması için toplama çukuru ZORUNLUDUR.",
    adviceText:
        "Trafo yağı yanıcıdır. Olası bir sızıntıda yağın çevreye yayılmasını ve yangını büyütmesini önlemek için trafo altında, trafo yağ kapasitesini alabilecek büyüklükte içi çakıl dolu bir 'Yağ Toplama Çukuru' oluşturulması şarttır.",
    level: RiskLevel.critical,
  );

  static final cukurOptionC = ChoiceResult(
    label: "31-2-B-3",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Yağlı trafo altında yağ toplama çukuru olup olmadığı tespit edilememiştir.",
    level: RiskLevel.unknown,
  );

  static final sondurmeOptionA = ChoiceResult(
    label: "31-3-A",
    uiTitle: "Evet, dedektör ve söndürme sistemi var.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Trafo odasında otomatik yangın algılama ve söndürme sistemi mevcuttur.",
    level: RiskLevel.positive,
  );

  static final sondurmeOptionB = ChoiceResult(
    label: "31-3-B",
    uiTitle: "Hayır, hiçbir sistem yok.",
    uiSubtitle: "",
    reportText:
        "UYARI: Trafo odaları kapalı ve kilitli alanlardır. Yangın başladığında dışarıdan fark edilmesi zordur. Otomatik algılama ve söndürme sistemi hayati önem taşır.",
    level: RiskLevel.warning,
  );

  static final sondurmeOptionC = ChoiceResult(
    label: "31-3-C",
    uiTitle: "Sadece dedektör var.",
    uiSubtitle: "Otomatik söndürme yok.",
    reportText:
        "UYARI: Trafo odasında yangın algılama sistemi mevcuttur ancak otomatik söndürme sistemi yoktur. Trafo yangınlarına müdahale için gazlı otomatik söndürme sistemleri önerilir.",
    level: RiskLevel.warning,
  );

  static final sondurmeOptionD = ChoiceResult(
    label: "31-3-D",
    uiTitle: "Hayır, hiçbir sistem yok.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Trafo odaları yüksek yangın riski taşıyan kapalı alanlardır. Otomatik algılama ve söndürme sistemlerinin bulunmaması yangının geç fark edilmesine ve büyümesine yol açar.",
    level: RiskLevel.critical,
  );

  static final sondurmeOptionE = ChoiceResult(
    label: "31-3-E",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Trafo odasındaki yangın güvenlik sistemlerinin (algılama/söndürme) varlığı tespit edilememiştir.",
    level: RiskLevel.unknown,
  );

  static final cevreOptionA = ChoiceResult(
    label: "31-4-A",
    uiTitle: "Hayır, çevresi ve üstünde su tesisatı yok.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Trafo odası çevresinde su tesisatı riski bulunmamaktadır.",
    level: RiskLevel.positive,
  );

  static final cevreOptionB = ChoiceResult(
    label: "31-4-B",
    uiTitle: "Evet, içinden su boruları geçiyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Yüksek gerilim hattının olduğu yerden su borusu geçirilemez! Boru patlarsa su ve elektrik teması büyük bir patlamaya neden olur.",
    level: RiskLevel.critical,
  );

  static final cevreOptionC = ChoiceResult(
    label: "31-4-C",
    uiTitle: "Evet, üstünde banyo, tuvalet vb. ıslak hacim var.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Trafo odalarının üstü ıslak hacim olamaz. Üst kattan olası bir su sızıntısı trafoya damlarsa ölümcül kazalara ve yangına yol açabilir.",
    level: RiskLevel.critical,
  );

  static final cevreOptionD = ChoiceResult(
    label: "31-4-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Trafo odası çevresindeki su tesisatı veya ıslak hacim riskleri hakkın tespit edilememiştir.",
    level: RiskLevel.unknown,
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
        "OLUMLU: Jeneratör odasında yangın kompartımantasyonunun sağlandığı söylenebilir.",
    level: RiskLevel.positive,
  );
  static final yapiOptionB = ChoiceResult(
    label: "32-1-B",
    uiTitle: "Kapısı direkt apartman koridoruna ve hole açılıyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Jeneratör odasından çıkacak zehirli egzoz gazı ve duman, kaçış yollarını kullanılamaz hale getirir. Kapı asla direkt kaçış yoluna açılmamalıdır.",
    level: RiskLevel.critical,
  );
  static final yapiOptionC = ChoiceResult(
    label: "32-1-C",
    uiTitle: "Duvarları ve kapısı yangına dayanıksız.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Jeneratör odası yangın bölmesi olarak tasarlanmalıdır. Duvarlar ve kapı en az 90-120 dakika yangına dayanmazsa, yakıt yangını binaya sıçrayabilir.",
    level: RiskLevel.critical,
  );
  static final yapiOptionD = ChoiceResult(
    label: "32-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Jeneratör odasının yapısal özellikleri ve kapı dayanımı bilinmiyor. Yangın ve zehirli gaz yayılımı riskine karşı bu alanın teknik incelemesi yapılmalıdır.",
    level: RiskLevel.unknown,
  );

  // --- 2. YAKIT ---
  static final yakitOptionA = ChoiceResult(
    label: "32-2-A",
    uiTitle: "Kendi tankında veya gömülü tankta.",
    uiSubtitle: "Güvenli depolama.",
    reportText: "OLUMLU: Yakıt depolama yöntemi güvenli gözükmektedir.",
    level: RiskLevel.positive,
  );
  static final yakitOptionB = ChoiceResult(
    label: "32-2-B",
    uiTitle: "Oda içinde bidonlarda veya varillerde.",
    uiSubtitle: "Açıkta yedek yakıt var.",
    reportText:
        "UYARI: Jeneratör odasında bidonla veya açık kapta yakıt saklamak uygun değildir. Yakıt buharı elektrik kontağından alev alıp patlamaya neden olabilir.",
    adviceText:
        "Jeneratör yakıtı sadece ana tankta veya yönetmeliğe uygun günlük tankta tutulabilir. Bidon, varil gibi korozyona açık ve sızdırma riski olan kaplarda yakıt depolanmaması önerilir.",
    level: RiskLevel.warning,
  );
  static final yakitOptionC = ChoiceResult(
    label: "32-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Jeneratör yakıtının depolanma şekli bilinmiyor. Yanıcı sıvıların açıkta saklanması büyük bir patlama riskidir, kontrol edilmelidir.",
    level: RiskLevel.unknown,
  );

  // --- 3. ÇEVRE ---
  static final cevreOptionA = ChoiceResult(
    label: "32-3-A",
    uiTitle: "Hayır, çevresi ve üstü kuru, ıslak zemin yok.",
    uiSubtitle: "",
    reportText: "OLUMLU: Çevresel su riski bulunmamaktadır.",
    level: RiskLevel.positive,
  );
  static final cevreOptionB = ChoiceResult(
    label: "32-3-B",
    uiTitle: "Evet, içinden su/doğalgaz boruları geçiyor.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Jeneratör odasından su veya gaz tesisatı geçirilemez. Boru patlaması durumunda suyun elektrikle teması veya gaz kaçağı felakete yol açar.",
    level: RiskLevel.critical,
  );
  static final cevreOptionC = ChoiceResult(
    label: "32-3-C",
    uiTitle: "Evet, üstünde banyo/tuvalet vb. ıslak hacim var.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Jeneratör odalarının üstü ıslak hacim olamaz. Su sızıntısı kısa devreye yol açar.",
    level: RiskLevel.critical,
  );
  static final cevreOptionD = ChoiceResult(
    label: "32-3-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Jeneratör odası çevresindeki tesisat riskleri bilinmiyor. Olası bir su sızıntısının elektrik sistemine zarar verip vermeyeceği denetlenmelidir.",
    level: RiskLevel.unknown,
  );

  // --- 4. EGZOZ ---
  static final egzozOptionA = ChoiceResult(
    label: "32-4-A",
    uiTitle: "Egzoz dışarıda, havalandırma var.",
    uiSubtitle: "Gaz tahliyesi mümkün.",
    reportText: "OLUMLU: Egzoz gazı bina dışına atılmaktadır.",
    level: RiskLevel.positive,
  );
  static final egzozOptionB = ChoiceResult(
    label: "32-4-B",
    uiTitle: "Egzoz içeride veya havalandırma yok.",
    uiSubtitle: "Gaz içeride birikme yapabilir.",
    reportText:
        "KRİTİK RİSK: Jeneratör egzozu karbonmonoksit içerir. Egzoz sağlanmalı ve mutlaka bina dışına uzatılmalıdır.",
    adviceText:
        "Egzoz hattı, sızdırmaz çelik borularla ve ısı yalıtımı yapılarak bina dışına, kaçış yollarından uzak olan bir noktaya kadar uzatılmalıdır. İçeride kalan sıcak yüzeyler yanmaz malzeme ile izole edilmelidir.",
    level: RiskLevel.critical,
  );
  static final egzozOptionC = ChoiceResult(
    label: "32-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Jeneratör egzoz tahliye sistemi bilinmiyor. Karbonmonoksit zehirlenmesi riskine karşı egzozun bina dışına verildiğinden emin olunmalıdır.",
    level: RiskLevel.unknown,
  );
}

class Bolum33Content {
  static final normalKatYeterli = ChoiceResult(
    label: "33-NORMAL-OK",
    uiTitle: "Yeterli",
    uiSubtitle: "",
    reportText:
        "Normal katlara hitap eden merdivenler ADET bakımından yeterli olabilir. Merdiven tiplerinin uygunluk kontrolü için Bölüm-36 'ya bakınız. Kaçış mesafeleri ve çıkmaz koridor uzunlukları mimari proje üzerinde veya yerinde ayrıca kontrol edilmelidir.",
    level: RiskLevel.positive,
  );

  static final normalKatYetersiz = ChoiceResult(
    label: "33-NORMAL-FAIL",
    uiTitle: "Yetersiz",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Normal katlara hitap eden mevcut merdiven ADEDİ, hesaplanan kullanıcı yükü için yetersizdir. İlave çıkış gereklidir.",
    adviceText:
        "Kullanıcı yükü kapasiteyi aştığı için binaya yönetmelik limitleri çerçevesinde ilave kaçış merdiveni eklenmesi, yatay tahliye koridoru oluşturulması veya kat alanlarının yangın kompartımanlarına bölünerek her bölge için ayrı çıkış tasarlanması yöntemlerinden biri veya birkaçı uygulanarak sorunun çözülmesi gerekmektedir.",
    level: RiskLevel.critical,
  );

  static final zeminKatYeterli = ChoiceResult(
    label: "33-ZEMIN-OK",
    uiTitle: "Yeterli",
    uiSubtitle: "",
    reportText:
        "Zemin katlara hitap eden merdivenler ADET bakımından yeterli olabilir. Merdiven tiplerinin uygunluk kontrolü için Bölüm-36 'ya bakınız. Kaçış mesafeleri ve çıkmaz koridor uzunlukları mimari proje üzerinde veya yerinde ayrıca kontrol edilmelidir.",
    level: RiskLevel.positive,
  );

  static final zeminKatYetersiz = ChoiceResult(
    label: "33-ZEMIN-FAIL",
    uiTitle: "Yetersiz",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Zemin kata hitap eden mevcut merdiven ADEDİ, hesaplanan kullanıcı yükü için yetersizdir. İlave çıkış gereklidir.",
    adviceText:
        "Kullanıcı yükü kapasiteyi aştığı için binaya yönetmelik limitleri çerçevesinde ilave kaçış merdiveni eklenmesi, yatay tahliye koridoru oluşturulması veya kat alanlarının yangın kompartımanlarına bölünerek her bölge için ayrı çıkış tasarlanması yöntemlerinden biri veya birkaçı uygulanarak sorunun çözülmesi gerekmektedir.",
    level: RiskLevel.critical,
  );

  static final bodrumKatYeterli = ChoiceResult(
    label: "33-BODRUM-OK",
    uiTitle: "Yeterli",
    uiSubtitle: "",
    reportText:
        "Bodrum katlara hitap eden merdivenler ADET bakımından yeterli olabilir. Merdiven tiplerinin uygunluk kontrolü için Bölüm-36 'ya bakınız. Kaçış mesafeleri ve çıkmaz koridor uzunlukları mimari proje üzerinde veya yerinde ayrıca kontrol edilmelidir.",
    level: RiskLevel.positive,
  );

  static final bodrumKatYetersiz = ChoiceResult(
    label: "33-BODRUM-FAIL",
    uiTitle: "Yetersiz",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Bodrum katlara hitap eden mevcut merdiven ADEDİ, hesaplanan kullanıcı yükü için yetersizdir. İlave çıkış gereklidir.",
    adviceText:
        "Kullanıcı yükü kapasiteyi aştığı için binaya yönetmelik limitleri çerçevesinde ilave kaçış merdiveni eklenmesi, yatay tahliye koridoru oluşturulması veya kat alanlarının yangın kompartımanlarına bölünerek her bölge için ayrı çıkış tasarlanması yöntemlerinden biri veya birkaçı uygulanarak sorunun çözülmesi gerekmektedir.",
    level: RiskLevel.critical,
  );

  static final bos = ChoiceResult(
    label: "",
    uiTitle: "",
    uiSubtitle: "",
    reportText: "",
    level: RiskLevel.positive,
  );
}

class Bolum34Content {
  static final zeminOptionA = ChoiceResult(
    label: "34-1-A (Zemin)",
    uiTitle: "Evet, var.",
    uiSubtitle: "Müşteriler direkt dükkan kapısından çıkabiliyor.",
    reportText:
        "OLUMLU: Zemin kattaki ticari alanların kendi bağımsız çıkışları olduğu için, bina ana girişine ve merdivenlerine ek yük getirmezler.",
    level: RiskLevel.positive,
  );

  static final zeminOptionB = ChoiceResult(
    label: "34-1-B (Zemin)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "İşyerlerinin çıkışları bina koridorunun içinden sağlanıyor.",
    reportText:
        "UYARI: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Bina ana giriş kapısının genişliği bu ekstra yükü kaldıracak kapasitede olmalıdır.",
    adviceText:
        "Ticari alanların bina içine açılan kapıları iptal edilerek, giriş-çıkışları tamamen dış cepheden sağlanması önerilir. Mümkün değilse, bu kapıların en az EI60 (60 dk) yangın dayanım sınıfında ve kendiliğinden kapanır olması önerilir.",
    level: RiskLevel.warning,
  );

  static final zeminOptionC = ChoiceResult(
    label: "34-1-C (Zemin)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir.",
    level: RiskLevel.unknown,
  );

  static final bodrumOptionA = ChoiceResult(
    label: "34-2-A (Bodrum)",
    uiTitle: "Evet, var.",
    uiSubtitle: "İşyerleri bina ortak merdivenini kullanmak zorunda değiller.",
    reportText:
        "OLUMLU: Bodrum kattaki ticari kullanımın kendine ait bağımsız kaçış yolu olması büyük avantajdır. Bina merdivenleri sadece konut sakinlerine kalır.",
    level: RiskLevel.positive,
  );

  static final bodrumOptionB = ChoiceResult(
    label: "34-2-B (Bodrum)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "İşyerleri bina ortak merdivenini kullanıyorlar.",
    reportText:
        "UYARI: Bodrum kattaki ticari alanın (Örn: Restauran, kafe, spor salonu vb.) kalabalığı, bina sakinleriyle aynı merdiveni kullanacaktır. Bu durum kaçış anında merdivende tıkanıklığa yol açabilir.",
    level: RiskLevel.warning,
  );

  static final bodrumOptionC = ChoiceResult(
    label: "34-2-C (Bodrum)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Ticari alanların bina koridoruna açılması, kaçış yolundaki yoğunluğu artırır. Uzman görüşü alınması tavsiye edilir.",
    level: RiskLevel.unknown,
  );

  // --- NORMAL KAT TİCARİ ALAN ÇIKIŞLARI ---
  static final normalOptionA = ChoiceResult(
    label: "34-3-A (Normal)",
    uiTitle: "Evet, var.",
    uiSubtitle: "İşyerleri bina ortak merdivenini kullanmak zorunda değiller.",
    reportText:
        "OLUMLU: Normal katlardaki ticari kullanımın kendine ait bağımsız kaçış yolu olması büyük avantajdır. Bina merdivenleri sadece konut sakinlerine kalır.",
    level: RiskLevel.positive,
  );

  static final normalOptionB = ChoiceResult(
    label: "34-3-B (Normal)",
    uiTitle: "Hayır, yok.",
    uiSubtitle: "İşyerleri bina ortak merdivenini kullanıyorlar.",
    reportText:
        "UYARI: Normal katlardaki ticari alanın (Örn: Ofis, kurs merkezi, spor salonu vb.) kalabalığı, bina sakinleriyle aynı merdiveni kullanacaktır. Bu durum kaçış anında merdivende tıkanıklığa yol açabilir.",
    level: RiskLevel.warning,
  );

  static final normalOptionC = ChoiceResult(
    label: "34-3-C (Normal)",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Normal katlardaki ticari alanların çıkış durumu bilinmiyor. Uzman görüşü alınması tavsiye edilir.",
    level: RiskLevel.unknown,
  );
}

class Bolum35Content {
  // --- SENARYO 1: TEK YÖN ---
  static final tekYonOptionA = ChoiceResult(
    label: "35-1-A",
    uiTitle: "Tam olarak ölçüyü biliyorum.",
    uiSubtitle: "",
    reportText: "(Girilen değere göre otomatik hesaplanır)",
    level: RiskLevel.positive,
  );
  static final tekYonOptionB = ChoiceResult(
    label: "35-1-B",
    uiTitle: "Tahminen [LİMİT] metreden KISA.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Tek yön kaçış mesafesi Yönetmelik sınırları içerisindedir.",
    level: RiskLevel.positive,
  );
  static final tekYonOptionC = ChoiceResult(
    label: "35-1-C",
    uiTitle: "Tahminen [LİMİT] metreden UZUN.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Tek yön kaçış mesafesi Yönetmelik sınırının üzerindedir. ",
    level: RiskLevel.critical,
  );
  static final tekYonOptionD = ChoiceResult(
    label: "35-1-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Bu mesafe, insanların tahliye süresini belirleyen en önemli faktördür. Ölçüm yapılmalıdır.",
    level: RiskLevel.unknown,
  );

  // --- SENARYO 2: ÇİFT YÖN (EN YAKIN) ---
  static final ciftYonOptionA = ChoiceResult(
    label: "35-2-A",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "En yakın çıkışa olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)",
    level: RiskLevel.positive,
  );
  static final ciftYonOptionB = ChoiceResult(
    label: "35-2-B",
    uiTitle: "Tahminen [LİMİT] metreden KISADIR.",
    uiSubtitle: "Mesafe yakın.",
    reportText:
        "OLUMLU: En yakın çıkışa kaçış mesafesi yönetmelik sınırları içerisindedir.",
    level: RiskLevel.positive,
  );
  static final ciftYonOptionC = ChoiceResult(
    label: "35-2-C",
    uiTitle: "Tahminen [LİMİT] metreden UZUNDUR.",
    uiSubtitle: "Mesafe uzak.",
    reportText:
        "KRİTİK RİSK: En yakın çıkışa mesafe sınırın üzerindedir. Koridor mesafesini kısaltmak için yatay tahliye koridoru vb. oluşturulabilir veya farklı önlemler almak gerekebilir. bunun için yerinde Uzman kontrolü gereklidir.",
    level: RiskLevel.critical,
  );
  static final ciftYonOptionD = ChoiceResult(
    label: "35-2-D",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Kaçış mesafesi bilinmiyor. Proje üzerinde veya yerinde ölçüm yapılmalıdır.",
    level: RiskLevel.unknown,
  );

  static final cikmazOptionA = ChoiceResult(
    label: "35-3-A",
    uiTitle:
        "Hayır, daireden çıkınca sağa veya sola (iki farklı yöne) gidebiliyorum.",
    uiSubtitle: "",
    reportText: "OLUMLU: Daire çıkmaz koridor üzerinde değildir.",
    level: RiskLevel.positive,
  );
  static final cikmazOptionB = ChoiceResult(
    label: "35-3-B",
    uiTitle: "Evet, dairem çıkmaz bir koridorun ucundayım.",
    uiSubtitle: "Sadece tek yöne gidebiliyorum.",
    reportText: "(Alt soru açılır)",
    level: RiskLevel.positive,
  );

  static final cikmazMesafeOptionA = ChoiceResult(
    label: "35-3-C",
    uiTitle: "Tam ölçüyü biliyorum.",
    uiSubtitle: "Yol ayrımına kadar olan mesafeyi gireceğim.",
    reportText: "(Girilen değere göre otomatik hesaplanır)",
    level: RiskLevel.positive,
  );
  static final cikmazMesafeOptionB = ChoiceResult(
    label: "35-3-D",
    uiTitle: "Tahminen [LİMİT] metreden KISA.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Çıkmaz koridor mesafesi yönetmelik sınırları içerisindedir.",
    level: RiskLevel.positive,
  );
  static final cikmazMesafeOptionC = ChoiceResult(
    label: "35-3-E",
    uiTitle: "Tahminen [LİMİT] metreden UZUN.",
    uiSubtitle: "",
    reportText:
        "KRİTİK RİSK: Çıkmaz koridor mesafesi sınırın üzerindedir. Koridor mesafesini kısaltmak için yatay tahliye koridoru vb. oluşturulabilir veya farklı önlemler almak gerekebilir. bunun için yerinde Uzman kontrolü gereklidir.",
    level: RiskLevel.critical,
  );
  static final cikmazMesafeOptionD = ChoiceResult(
    label: "35-3-F",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText:
        "BİLİNMİYOR: Çıkmaz koridor mesafesi bilinmiyor. Ölçüm yapılmalıdır.",
    level: RiskLevel.unknown,
  );
}

class Bolum36Content {
  static final cikisKatiOptionA = ChoiceResult(
    label: "36-0-A",
    uiTitle: "Zemin kattan çıkabiliyorum.",
    uiSubtitle: "",
    reportText:
        "BİLGİ: Binadan dış havaya (atmosfere) çıkış Zemin Kattan sağlanmaktadır.",
    level: RiskLevel.info,
  );

  static final cikisKatiOptionB = ChoiceResult(
    label: "36-0-B",
    uiTitle: "Yalnızca (zemin üstü) normal kattan çıkabiliyorum.",
    uiSubtitle: "",
    reportText: "BİLGİ: Binadan dış havaya çıkış Normal Kattan sağlanmaktadır.",
    level: RiskLevel.info,
  );

  static final cikisKatiOptionC = ChoiceResult(
    label: "36-0-C",
    uiTitle: "Yalnızca (zemin altı) bodrum kattan çıkabiliyorum.",
    uiSubtitle: "",
    reportText: "BİLGİ: Binadan dış havaya çıkış Bodrum Kattan sağlanmaktadır.",
    level: RiskLevel.info,
  );

  static final disMerdOptionA = ChoiceResult(
    label: "36-1-A",
    uiTitle: "Hayır, merdiven etrafındaki duvarlar tamamen sağır (düz duvar).",
    uiSubtitle: "Merdiven etrafında pencere yok.",
    reportText:
        "OLUMLU: Dış kaçış merdiveni etrafında alev sıçrayabilecek açıklık bulunmamaktadır.",
    level: RiskLevel.positive,
  );
  static final disMerdOptionB = ChoiceResult(
    label: "36-1-B",
    uiTitle:
        "Evet, merdivenin hemen yanında/altında daire pencereleri veya kapılar var.",
    uiSubtitle: "Merdivenin hemen yanında açıklık var.",
    reportText:
        "KRİTİK RİSK: Açık dış kaçış merdiveninin 3 metre yakınında korunumsuz pencere veya kapı bulunamaz.",
    adviceText:
        "Merdivene 3 metre mesafedeki pencerelerin yangına en az 60 dakika dayanıklı (EI60 özelliğinde) sabit camlar ile değiştirilmesi veya bu açıklıkların tuğla, gazbeton vb. ile örülerek kapatılması gerekmektedir.",
    level: RiskLevel.critical,
  );
  static final disMerdOptionC = ChoiceResult(
    label: "36-1-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Dış merdiven çevresindeki açıklıklar bilinmiyor.",
    level: RiskLevel.unknown,
  );

  static final konumOptionA = ChoiceResult(
    label: "36-2-A",
    uiTitle:
        "Birbirlerine uzaklar (Koridorun zıt uçlarındalar / Farklı cephedeler).",
    uiSubtitle: "Koridorun zıt uçlarındalar.",
    reportText:
        "OLUMLU: Merdivenlerin zıt yönlerde olması, alternatif kaçış imkanı sağlar.",
    level: RiskLevel.positive,
  );
  static final konumOptionB = ChoiceResult(
    label: "36-2-B",
    uiTitle: "Yan yanalar veya birbirlerine çok yakınlar.",
    uiSubtitle: "Birbirlerine bitişikler.",
    reportText:
        "UYARI: Kaçış merdivenleri birbirinin alternatifi olmalıdır. Yan yana yapılan merdivenler 'Alternatif Çıkış'sayılmaz. Merdivenler arasında Yönetmeliğe göre olması gereken minimum mesafenin tayini için mimari projenin veya sahadaki mevcut durumun Yangın Güvenlik Uzmanı tarafından hususi olarak incelenmesi gereklidir.",
    adviceText:
        "Merdivenlerin birbirine olan mesafesi, katın en uzak iki noktasına hizmet edecek şekilde artırılmalı veya merdivenler arasında yangına dayanıklı duman sızdırmaz bölmeler oluşturulmalıdır.",
    level: RiskLevel.warning,
  );
  static final konumOptionC = ChoiceResult(
    label: "36-2-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Merdiven konumları net değil.",
    level: RiskLevel.unknown,
  );

  static final genislikBilinmiyor = ChoiceResult(
    label: "36-3-BILMIYORUM",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Kaçış yolu genişliği ölçülemedi.",
    level: RiskLevel.unknown,
  );

  static final kapiTipiOptionA = ChoiceResult(
    label: "36-4-A",
    uiTitle: "Tek Kanatlı Kapı.",
    uiSubtitle: "",
    reportText: "BİLGİ: Çıkış kapısı tek kanatlıdır.",
    level: RiskLevel.info,
  );
  static final kapiTipiOptionB = ChoiceResult(
    label: "36-4-B",
    uiTitle: "Çift Kanatlı Kapı.",
    uiSubtitle: "",
    reportText: "BİLGİ: Çıkış kapısı çift kanatlıdır.",
    level: RiskLevel.info,
  );
  static final kapiTipiOptionC = ChoiceResult(
    label: "36-4-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Çıkış kapısı tipi bilinmiyor.",
    level: RiskLevel.unknown,
  );

  static final kapiGenislikBilinmiyor = ChoiceResult(
    label: "36-4-ALT-BILMIYORUM",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Çıkış kapısı net genişliği bilinmiyor.",
    level: RiskLevel.unknown,
  );

  static final gorunurlukOptionA = ChoiceResult(
    label: "36-5-A",
    uiTitle: "Evet, açıkça görünüyor ve engel yok.",
    uiSubtitle: "",
    reportText:
        "OLUMLU: Kaçış yolları ve çıkış kapıları açıkça görülebilir durumdadır.",
    level: RiskLevel.positive,
  );
  static final gorunurlukOptionB = ChoiceResult(
    label: "36-5-B",
    uiTitle: "Hayır, önünde eşyalar var veya görmekte zorlanıyorum.",
    uiSubtitle: "",
    reportText:
        "UYARI: Çıkışlar her an kullanılabilir durumda ve engelsiz olmalıdır.",
    adviceText:
        "Kaçış yollarındaki tüm engellerin (dolap, saksı, bisiklet vb.) derhal kaldırılması ve çıkış kapılarının önünün 7/24 açık tutulması yasal zorunluluktur.",
    level: RiskLevel.warning,
  );
  static final gorunurlukOptionC = ChoiceResult(
    label: "36-5-C",
    uiTitle: "Bilmiyorum.",
    uiSubtitle: "",
    reportText: "BİLİNMİYOR: Çıkışların erişilebilirliği tespit edilememiştir.",
    level: RiskLevel.unknown,
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
        return "Elektrik tesisatı ve kabloların yangın güvenliği durumu nedir?";
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

  static const String havalandirma =
      "Kaçış merdivenlerinin doğal yolla (pencere/menfez) veya mekanik yolla havalandırılması, duman yoğunluğunu azaltır ve tahliyeyi kolaylaştırır. Madde 45 gereği tüm korunmuş kaçış merdivenleri havalandırılmalıdır.";

  static const String yanginKompartimani =
      "Binanın yangına dayanıklı elemanlarla ayrılmış, yangının belirli bir süre boyunca bu alanın dışına çıkması engellenen bölümüdür (Örn: Kazan dairesi).";

  static const String kullaniciYuku =
      "Bir binanın veya bir katın içinde aynı anda bulunabileceği kabul edilen maksimum insan sayısıdır.";

  static const String pasifYanginYalitimiCelik =
      "Çelik elemanların yangın anında taşıma kapasitelerini korumaları için kullanılan yangın geciktirici boya veya levha kaplama gibi önlemlerdir.";
  static String getSectionTitle(int id) {
    switch (id) {
      case 1:
        return "Yapı Ruhsat / Bina İnşa Tarihi";
      case 2:
        return "Bina Kullanım Sınıfı ve Taşıyıcı Sistemi";
      case 3:
        return "Bina Yüksekliği ve Kat Sayısı";
      case 4:
        return "Bina Tehlike Sınıfı";
      case 5:
        return "Bina Taban Alanı ve İnşaat Alanı";
      case 6:
        return "Otopark Durumu";
      case 7:
        return "Özel Riskli Alanlar";
      case 8:
        return "Bina Yerleşimi";
      case 9:
        return "Sprinkler Sistemi Varlığı";
      case 10:
        return "Katların Kullanım Amacı";
      case 11:
        return "İtfaiyenin Bina Yaklaşım Mesafesi";
      case 12:
        return "Yapısal Yangın Dayanımı";
      case 13:
        return "Teknik Hacimler";
      case 14:
        return "Tesisat Şaftları";
      case 15:
        return "İç Mekanlar";
      case 16:
        return "Dış Cephe Özellikleri";
      case 17:
        return "Çatı";
      case 18:
        return "İç Duvarlar";
      case 19:
        return "Kaçış Yolu Engelleri ve Yönlendirme";
      case 20:
        return "Kaçış Merdivenleri";
      case 21:
        return "Yangın Güvenlik Holü (YGH)";
      case 22:
        return "İtfaiye (Acil Durum) Asansörü";
      case 23:
        return "Normal Asansör";
      case 24:
        return "Dış Kaçış Geçitleri";
      case 25:
        return "Dairesel Merdiven";
      case 26:
        return "Kaçış Rampaları";
      case 27:
        return "Kaçış Yolu Kapıları";
      case 28:
        return "Daire İçi Mesafe";
      case 29:
        return "Temizlik ve Düzen";
      case 30:
        return "Kazan Dairesi";
      case 31:
        return "Trafo Odası";
      case 32:
        return "Jeneratör Odası";
      case 33:
        return "Çıkış Sayısı ve Kullanıcı Yükü";
      case 34:
        return "Ticari Alanlar";
      case 35:
        return "Kaçış Mesafeleri";
      case 36:
        return "Merdiven Tip ve Özellikleri";
      default:
        return "Bölüm $id";
    }
  }
}
