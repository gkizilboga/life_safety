// lib/models/bolum_3_model.dart

/// Kullanıcının kat yüksekliklerini nasıl girmek istediğini belirtir.
enum YukseklikGirisTipi {
  /// A) Kat yüksekliklerini biliyorum (Hassas Giriş).
  hassas,

  /// B) Bilmiyorum / Standart değerleri kabul et.
  standart,
}

class Bolum3Model {
  //--- KULLANICI GİRDİLERİ ---//

  /// Zemin katın üzerindeki kat sayısı.
  final int? normalKatSayisi;

  /// Zemin katın altındaki kat (bodrum) sayısı.
  final int? bodrumKatSayisi;

  /// Kullanıcının yükseklikler için seçtiği yöntem (Hassas/Standart).
  final YukseklikGirisTipi? yukseklikGirisTipi;

  /// Hassas giriş seçildiğinde kullanıcının girdiği zemin kat yüksekliği (m).
  final double? hKatZeminManuel;

  /// Hassas giriş seçildiğinde kullanıcının girdiği normal kat yüksekliği (m).
  final double? hKatNormalManuel;

  /// Hassas giriş seçildiğinde kullanıcının girdiği bodrum kat yüksekliği (m).
  final double? hKatBodrumManuel;

  //--- HESAPLANMIŞ DEĞERLER (GETTERS) ---//
  // Bu değerler veritabanına kaydedilmez, girdilerden anlık hesaplanır.

  /// Seçime göre kullanılacak nihai zemin kat yüksekliği.
  double get efektifHKatZemin {
    if (yukseklikGirisTipi == YukseklikGirisTipi.standart) return 3.50;
    return hKatZeminManuel ?? 3.50;
  }

  /// Seçime göre kullanılacak nihai normal kat yüksekliği.
  double get efektifHKatNormal {
    if (yukseklikGirisTipi == YukseklikGirisTipi.standart) return 3.00;
    return hKatNormalManuel ?? 3.00;
  }

  /// Seçime göre kullanılacak nihai bodrum kat yüksekliği.
  double get efektifHKatBodrum {
    if (yukseklikGirisTipi == YukseklikGirisTipi.standart) return 3.50;
    return hKatBodrumManuel ?? 3.50;
  }

  /// HESAP-1: BİNA YÜKSEKLİĞİ (h_bina)
  double get hBina {
    final normalKatlarToplamH = (normalKatSayisi ?? 0) * efektifHKatNormal;
    return efektifHKatZemin + normalKatlarToplamH;
  }

  /// HESAP-2: BODRUM DERİNLİĞİ (h_bodrum)
  double get hBodrum {
    return (bodrumKatSayisi ?? 0) * efektifHKatBodrum;
  }

  /// HESAP-3: YAPI YÜKSEKLİĞİ (h_yapi)
  double get hYapi => hBina + hBodrum;

  /// HESAP-4: YÜKSEK BİNA KONTROLÜ
  bool get isGenelYuksekBina => hBina > 21.50;

  //--- STANDART MODEL FONKSİYONLARI ---//

  Bolum3Model({
    this.normalKatSayisi,
    this.bodrumKatSayisi,
    this.yukseklikGirisTipi,
    this.hKatZeminManuel,
    this.hKatNormalManuel,
    this.hKatBodrumManuel,
  });

  Bolum3Model copyWith({
    int? normalKatSayisi,
    int? bodrumKatSayisi,
    YukseklikGirisTipi? yukseklikGirisTipi,
    double? hKatZeminManuel,
    double? hKatNormalManuel,
    double? hKatBodrumManuel,
  }) {
    return Bolum3Model(
      normalKatSayisi: normalKatSayisi ?? this.normalKatSayisi,
      bodrumKatSayisi: bodrumKatSayisi ?? this.bodrumKatSayisi,
      yukseklikGirisTipi: yukseklikGirisTipi ?? this.yukseklikGirisTipi,
      hKatZeminManuel: hKatZeminManuel ?? this.hKatZeminManuel,
      hKatNormalManuel: hKatNormalManuel ?? this.hKatNormalManuel,
      hKatBodrumManuel: hKatBodrumManuel ?? this.hKatBodrumManuel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'normal_kat_sayisi': normalKatSayisi,
      'bodrum_kat_sayisi': bodrumKatSayisi,
      'yukseklik_giris_tipi': yukseklikGirisTipi?.name,
      'h_kat_zemin_manuel': hKatZeminManuel,
      'h_kat_normal_manuel': hKatNormalManuel,
      'h_kat_bodrum_manuel': hKatBodrumManuel,
    };
  }

  factory Bolum3Model.fromMap(Map<String, dynamic> map) {
    return Bolum3Model(
      normalKatSayisi: map['normal_kat_sayisi'],
      bodrumKatSayisi: map['bodrum_kat_sayisi'],
      yukseklikGirisTipi: map['yukseklik_giris_tipi'] != null
          ? YukseklikGirisTipi.values.byName(map['yukseklik_giris_tipi'])
          : null,
      hKatZeminManuel: map['h_kat_zemin_manuel'],
      hKatNormalManuel: map['h_kat_normal_manuel'],
      hKatBodrumManuel: map['h_kat_bodrum_manuel'],
    );
  }
}