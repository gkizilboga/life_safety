// lib/models/bolum_10_model.dart

/// Katların kullanım amacını ve ilgili kullanıcı yükü katsayısını temsil eder.
enum KullanimAmaci {
  /// A) Konut (Daire, mesken).
  konut(10.0),

  /// B) Az yoğun ticari alan (Büro, ofis, oto galeri vb.).
  azYogunTicari(10.0),

  /// C) Orta yoğun ticari alan (Market, mağaza, banka vb.).
  ortaYogunTicari(5.0),

  /// D) Yüksek yoğun ticari alan (Restaurant, cafe, spor salonu vb.).
  yuksekYogunTicari(1.5),

  /// E) Otopark, depo veya teknik hacim.
  teknikOtopark(30.0);

  /// Her kullanım amacına karşılık gelen m²/kişi katsayısı.
  final double katsayi;
  const KullanimAmaci(this.katsayi);
}

class Bolum10Model {
  //--- KULLANICI GİRDİLERİ ---//

  /// Zemin katın kullanım amacı.
  final KullanimAmaci? kullanimZemin;

  /// Bodrum katların kullanım amaçlarını sırayla tutan liste.
  /// Örn: kullanimBodrum[0] -> 1. Bodrum Kat
  final List<KullanimAmaci?> kullanimBodrum;

  /// Normal katların kullanım amaçlarını sırayla tutan liste.
  /// Örn: kullanimNormal[0] -> 1. Normal Kat
  final List<KullanimAmaci?> kullanimNormal;

  //--- STANDART MODEL FONKSİYONLARI ---//

  Bolum10Model({
    this.kullanimZemin,
    // Varsayılan olarak boş listeler atayarak null hatalarını önleriz.
    this.kullanimBodrum = const [],
    this.kullanimNormal = const [],
  });

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

  Map<String, dynamic> toMap() {
    return {
      'kullanim_zemin': kullanimZemin?.name,
      // enum listesini String listesine çevirerek kaydediyoruz.
      'kullanim_bodrum': kullanimBodrum.map((e) => e?.name).toList(),
      'kullanim_normal': kullanimNormal.map((e) => e?.name).toList(),
    };
  }

  factory Bolum10Model.fromMap(Map<String, dynamic> map) {
    return Bolum10Model(
      kullanimZemin: map['kullanim_zemin'] != null
          ? KullanimAmaci.values.byName(map['kullanim_zemin'])
          : null,
      // String listesini tekrar enum listesine çeviriyoruz.
      kullanimBodrum: (map['kullanim_bodrum'] as List<dynamic>?)
              ?.map((name) =>
                  name != null ? KullanimAmaci.values.byName(name) : null)
              .toList() ??
          const [],
      kullanimNormal: (map['kullanim_normal'] as List<dynamic>?)
              ?.map((name) =>
                  name != null ? KullanimAmaci.values.byName(name) : null)
              .toList() ??
          const [],
    );
  }
}