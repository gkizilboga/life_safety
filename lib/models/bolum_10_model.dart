enum KullanimAmaci {
  konut,
  azYogunTicari,
  ortaYogunTicari,
  yuksekYogunTicari,
  teknikOtopark,
}

extension KullanimAmaciExtension on KullanimAmaci {
  String get aciklama {
    switch (this) {
      case KullanimAmaci.konut:
        return "A) Konut (Daire, mesken)";
      case KullanimAmaci.azYogunTicari:
        return "B) Az yoğun ticari alan (Büro, ofis, oto galeri vb.)";
      case KullanimAmaci.ortaYogunTicari:
        return "C) Orta yoğun ticari alan (Market, mağaza, banka vb.)";
      case KullanimAmaci.yuksekYogunTicari:
        return "D) Yüksek yoğun ticari alan (Restaurant, cafe, spor salonu vb.)";
      case KullanimAmaci.teknikOtopark:
        return "E) Otopark, depo veya teknik hacim";
    }
  }

  double get katsayi {
    switch (this) {
      case KullanimAmaci.konut:
        return 10.0;
      case KullanimAmaci.azYogunTicari:
        return 10.0;
      case KullanimAmaci.ortaYogunTicari:
        return 5.0;
      case KullanimAmaci.yuksekYogunTicari:
        return 1.5;
      case KullanimAmaci.teknikOtopark:
        return 30.0;
    }
  }
}

class Bolum10Model {
  final KullanimAmaci? kullanimZemin;
  final List<KullanimAmaci?> kullanimBodrum;
  final List<KullanimAmaci?> kullanimNormal;

  Bolum10Model({
    this.kullanimZemin,
    this.kullanimBodrum = const [],
    this.kullanimNormal = const [],
  });

  bool get isFormValid {
    if (kullanimZemin == null) return false;
    if (kullanimBodrum.contains(null)) return false;
    if (kullanimNormal.contains(null)) return false;
    return true;
  }

  Bolum10Model copyWith({
    KullanimAmaci? kullanimZemin,
    List<KullanimAmaci?>? kullanimBodrum,
    List<KullanimAmaci?>? kullanimNormal,
  }) {
    return Bolum10Model(
      kullanimZemin: kullanimZemin ?? this.kullanimZemin,
      kullanimBodrum: kullanimBodrum ?? this.kullanimBodrum,
      kullanimNormal: kullanimNormal ?? this.kullanimNormal,
    );
  }
}