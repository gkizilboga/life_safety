class AppStrings {
  static const String appName = "Bina Yangın Risk Analizi";
  static const String stepLabel = "Adım";
  static const String completeLabel = "Tamamlandı";
  static const String nextButton = "DEVAM ET";
  static const String backButton = "GERİ DÖN";
  
  static const String b1Title = "Yapı Ruhsat / İnşa Tarihi";
  static const String b1Question = " ";
  static const String b1SubQuestion = "Binanızın yapı ruhsatı hangi tarihte alındı veya yapım tarihi nedir?";

  static const String kvkkTitle = "KVKK ve Veri Güvenliği Aydınlatma Metni";
  static const String kvkkContent = """6698 sayılı Kişisel Verilerin Korunması Kanunu (“KVKK”) uyarınca Veri Sorumlusu sıfatıyla bilgilendirmedir:

1. VERİ İŞLEME POLİTİKASI (LOCAL-ONLY): İşbu uygulama "Çevrimdışı/Yerel" mimaride çalışmaktadır. Girdiğiniz bina verileri, kişisel notlar ve analiz sonuçları, doğrudan veya dolaylı olarak uygulama geliştiricisine ait sunuculara AKTARILMAMAKTA ve DEPOLANMAMAKTADIR.
2. CİHAZ VE YEDEKLEME SORUMLULUĞU: Verileriniz sadece kendi cihazınızın hafızasında tutulur. İşletim sisteminizin (Android/iOS) otomatik yedekleme hizmetleri (Cloud Backups) haricinde, verileriniz hiçbir üçüncü tarafla paylaşılmaz. Cihaz güvenliği ve veri yedekliliği tamamen kullanıcının sorumluluğundadır.
3. HAKLAR VE İMHA: Uygulama silindiğinde, oluşturulan tüm yerel veritabanı geri döndürülemez şekilde silinir. Geliştirici, erişimi olmayan bir veriyi silemeyeceği veya anonimleştiremeyeceği için, KVKK m.11 kapsamındaki talepleriniz "veri tutulmadığı" gerekçesiyle işleme alınamayabilir.""";
  
  static const String legalDisclaimerTitle = "YASAL SORUMLULUK REDDİ (KESİN HÜKÜMLER)";
  static const String legalDisclaimerContent = """İŞBU METİN, KULLANICI İLE YAŞAM GÜVENLİĞİ ASİSTANI (UYGULAMA) ARASINDAKİ NİHAİ YASAL ÇERÇEVEDİR. KÖTÜ NİYETLİ KULLANIMLARA KARŞI TÜRK CEZA KANUNU HÜKÜMLERİ SAKLIDIR.

1. RESMİ BELGE NİTELİĞİ VE KULLANIM YASAĞI:
Bu uygulama tarafından üretilen her türlü rapor, analiz, tablo veya çıktı; "Ön Bilgilendirme Amaçlı Taslak" niteliğindedir. İşbu belgeler; Belediyeler, İtfaiye Daire Başkanlıkları, Çevre ve Şehircilik İl Müdürlükleri, Tapu Müdürlükleri veya Yapı Denetim Kuruluşları nezdinde YAPI RUHSATI, YAPI KULLANMA İZİN BELGESİ (İSKAN) veya İTFAİYE UYGUNLUK RAPORU süreçlerinde "RESMİ BELGE" olarak KULLANILAMAZ. Bu yönde yapılacak herhangi bir teşebbüs, kullanıcının şahsi sorumluluğundadır.

2. MEVZUAT KAPSAMI VE YETKİ SINIRI:
Uygulama algoritmaları temel olarak "Binaların Yangından Korunması Hakkında Yönetmelik (2015)" referans alınarak hazırlanmıştır. ANCAK, bir binanın tam yangın güvenliği; aşağıda sayılı mevzuatların da eksiksiz uygulanmasına bağlıdır ve uygulama bu kapsamı GARANTİ ETMEZ:
   - 3194 Sayılı İmar Kanunu ve Planlı Alanlar İmar Yönetmeliği,
   - Elektrik İç Tesisleri Yönetmeliği ve Topraklama Yönetmeliği,
   - Asansör Yönetmeliği (2014/33/AB) ve ilgili Bakım/İşletme Yönetmelikleri,
   - Binalarda Isı Yalıtımı Yönetmeliği (TS 825),
   - Binalarda Enerji Performansı Yönetmeliği,
   - TS EN 62305 (Yıldırımdan Korunma) ve ilgili diğer TSE Standartları.

3. KÖTÜ NİYETLİ KULLANIM VE CEZAİ SORUMLULUK (TCK UYARISI):
Uygulama çıktısını tahrif ederek, üzerine ıslak imza/kaşe taklit ederek veya bunu resmi bir belge gibi kamu kurumlarına sunmaya çalışan kullanıcılar; 5237 sayılı Türk Ceza Kanunu'nun 204. Maddesi (Resmi Belgede Sahtecilik) ve 207. Maddesi (Özel Belgede Sahtecilik) uyarınca SUÇ İŞLEMİŞ sayılacaktır. Geliştirici ekip, bu tür kötü niyetli kullanımlardan doğacak hukuki süreçlerde, uygulamanın "Salt Bilgilendirme" amacı taşıdığını ve kullanıcıyı bu konuda açıkça uyardığını delil olarak sunacaktır.

4. SAHA GERÇEKLİĞİ VE İŞVEREN YÜKÜMLÜLÜĞÜ (6331 s.K.):
Yazılım, kullanıcının beyan ettiği veriyi doğru kabul eder. Sahada paslanmış bir boru, kilitli bir yangın kapısı veya projesine aykırı bir duvarı yazılımın tespit etmesi teknik olarak imkansızdır. 6331 sayılı İş Sağlığı ve Güvenliği Kanunu md. 4 ve md. 10 uyarınca; İşveren/Yönetici'nin "Risk Değerlendirmesi Yapma/Yaptırma" yükümlülüğü, bu uygulama ile DEVREDİLMİŞ SAYILMAZ.

5. FERAGAT VE KABUL:
Kullanıcı, bu uygulamayı indirdiği ve kullandığı andan itibaren; uygulamanın bir "Mühendislik/Müşavirlik Hizmeti" olmadığını, sadece "Veri İşleme Aracı" olduğunu ve oluşabilecek her türlü maddi/manevi zararda geliştiricinin kusursuz sorumluluğu bulunmadığını gayrikabili rücu kabul, beyan ve taahhüt eder.""";

  static const String legislationTitle = "Binaların Yangından Korunması Hakkında Yönetmeliği (BYKHY)";
  static const String legislationSubtitle = " Yönetmelik hükümleri.";
}