class AppStrings {
  static const String appName = "Yangın Risk Analizi";
  static const String stepLabel = "Adım";
  static const String completeLabel = "Tamamlandı";
  static const String nextButton = "DEVAM ET";
  static const String backButton = "GERİ DÖN";

  static const String b1Title = "Yapı Ruhsat / İnşa Tarihi";
  static const String b1Question = " ";
  static const String b1SubQuestion =
      "Binanızın yapı ruhsatı hangi tarihte alındı veya yapım tarihi nedir?";

  static const String kvkkTitle = "KVKK ve Veri Güvenliği Aydınlatma Metni";
  static const String kvkkContent =
      """6698 sayılı Kişisel Verilerin Korunması Kanunu (“KVKK”) uyarınca Veri Sorumlusu sıfatıyla bilgilendirmedir:

1. VERİ İŞLEME POLİTİKASI (LOCAL-ONLY): İşbu uygulama "Çevrimdışı/Yerel" mimaride çalışmaktadır. Girdiğiniz bina verileri, kişisel notlar ve analiz sonuçları, doğrudan veya dolaylı olarak uygulama geliştiricisine ait sunuculara AKTARILMAMAKTA ve DEPOLANMAMAKTADIR.
2. CİHAZ VE YEDEKLEME SORUMLULUĞU: Verileriniz sadece kendi cihazınızın hafızasında tutulur. İşletim sisteminizin (Android/iOS) otomatik yedekleme hizmetleri (Cloud Backups) haricinde, verileriniz hiçbir üçüncü tarafla paylaşılmaz. Cihaz güvenliği ve veri yedekliliği tamamen kullanıcının sorumluluğundadır.
3. HAKLAR VE İMHA: Uygulama silindiğinde, oluşturulan tüm yerel veritabanı geri döndürülemez şekilde silinir. Geliştirici, erişimi olmayan bir veriyi silemeyeceği veya anonimleştiremeyeceği için, KVKK m.11 kapsamındaki talepleriniz "veri tutulmadığı" gerekçesiyle işleme alınamayabilir.""";

  static const String legalDisclaimerTitle =
      "Yasal Bildirim ve Sorumluluk Sınırlandırması";
  static const String legalDisclaimerContent =
      """İŞBU METİN, KULLANICI İLE YANGIN RİSK ANALİZİ UYGULAMASI ARASINDAKİ NİHAİ YASAL ÇERÇEVEDİR. KÖTÜ NİYETLİ KULLANIMLARA KARŞI TÜRK CEZA KANUNU HÜKÜMLERİ SAKLIDIR.

1. Hukuki Nitelik, Geçersizlik ve Sorumsuzluk Kaydı (TKHK m.13): 
Bu rapor bağlayıcılığı olmayan "Taslak/Tavsiye" niteliğindedir. Resmi makamlara "Mühendislik Raporu" veya onay belgesi olarak sunulamaz. Uygulama "olduğu gibi" sunulmakta olup, sonuçların mutlak doğruluğu, ruhsat onayı veya sigorta indirimi sağlama konusunda hiçbir açık/zımni ticari garanti verilmez. Tüm hukuki/cezai sorumluluk kullanıcıya aittir.

2. Algoritma Kapsamı ve Teknik Sınırlar:
Mevzuat Dayanağı: Uygulama algoritmaları yalnızca "Binaların Yangından Korunması Hakkında Yönetmelik" kriterlerini baz alır.
Kapsam Dışı Alanlar: Binanın tam güvenliği için gerekli olan İmar Kanunu, Türkiye Deprem Yönetmeliği, TS 500, Topraklama Yönetmeliği, Elektrik İç Tesisleri Yönetmeliği, Asansör Yönetmeliği, TS EN 62305 gibi diğer mevzuatların uygulanması bu raporun kapsamı dışındadır ve uygulama bu konuda bir garanti vermez.
Veri Doğruluğu: Uygulama, kullanıcının beyan ettiği verileri doğru kabul ederek analiz üretir. Kullanıcının beyan ettiği, Yönetmeliğe göre uygun gibi gözüken mevcut saha imalatlarının fiziksel olarak hasarlı veya yetersiz olması uygulamanın teknik kapasitesi dışındadır.

3. Sorumluluk Sınırı ve İSG (6331 sy. Kanun & TBK m.49):
Uygulamanın ürettiği tavsiyeler, Yangın Güvenlik Uzmanı onayından geçmeden doğrudan fiziki imalat (inşaat/tadilat) dayanağı yapılamaz. İşveren'in yasal "Risk Değerlendirmesi" yükümlülüğü devredilmez. Bu araç bir Müşavirlik hizmeti değildir; olası maddi/manevi zararlardan geliştirici sorumlu tutulamaz.

4. Felsefi Mülkiyet, Tersine Mühendislik ve TCK Uyarısı:
Kod, algoritma ve rapor şablonları 5846 sayılı FSEK kapsamında korunmaktadır. Tersine mühendislik veya ticari kopyalama yasaktır. Raporun tahrif edilip resmi belge gibi sunulması TCK m.204/207 (Sahtecilik) kapsamında suçtur.

5. KVKK Açık Rıza ve Yargı Yeri:
Çevrimdışı (local-only) mimari esastır; bina verileri sunuculara aktarılmaz, cihaz güvenliği kullanıcıya aittir. Ancak uygulamanın işleyişi ve çökme raporları (crash logs) anonim olarak toplanabilir. İhtilaflarda İstanbul Mahkemeleri ve İcra Daireleri yetkilidir.""";

  static const String legislationTitle = "Mevzuat";
  static const String legislationSubtitle =
      "Resmi dokümanlar ve teknik rehberler";

  // QR Kod ve Tanıtım Linkleri (Market linkleri buraya gelecek)
  static const String qrDownloadUrl = "https://lifesafety.app/download"; 
}
