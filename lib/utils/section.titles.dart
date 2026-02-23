class SectionTitles {
  /// Bölüm numarası ve ekranda görünecek başlık eşleşmesi.
  /// Kod içinde sadece rakamları (1, 2, 3...) kullanacağız.
  static const Map<int, String> list = {
    1: "BİNA YAPIM YILI VE RUHSAT",
    2: "YAPI İSKELETİ",
    3: "BİNA KAT BİLGİLERİ VE YÜKSEKLİĞİ",
    // 4. Bölümde arayüz yok, o yüzden listeye eklemedik.
    // Navigasyonda 3'ten direkt 5'e atlayacağız.
    5: "BİNA ALAN BİLGİLERİ",
    6: "KONUT HARİCİ ALANLAR",
    7: "ÖZEL RİSKLİ HACİMLER",
    8: "NİZAM DURUMU",
    9: "SPRINKLER SİSTEMİ VARLIĞI",
    10: "KAT KULLANIM AMACI",
  };

  /// Verilen bölüm numarası için başlığı getirir.
  static String getTitle(int sectionNumber) {
    return list[sectionNumber] ?? "BÖLÜM $sectionNumber";
  }
}
