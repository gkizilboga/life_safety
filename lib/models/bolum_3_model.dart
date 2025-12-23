enum YukseklikGirisTipi { hassas, standart }

class Bolum3Model {
  final int zeminKatSayisi = 1; // Sabit
  final int? normalKatSayisi;
  final int? bodrumKatSayisi;
  final YukseklikGirisTipi? yukseklikGirisTipi;
  final double? hKatZeminManuel;
  final double? hKatNormalManuel;
  final double? hKatBodrumManuel;

  Bolum3Model({
    this.normalKatSayisi,
    this.bodrumKatSayisi,
    this.yukseklikGirisTipi,
    this.hKatZeminManuel,
    this.hKatNormalManuel,
    this.hKatBodrumManuel,
  });

  // Efektif Yükseklikler (Manuel veya Varsayılan)
  double get efektifHKatZemin => yukseklikGirisTipi == YukseklikGirisTipi.standart ? 3.50 : (hKatZeminManuel ?? 3.50);
  double get efektifHKatNormal => yukseklikGirisTipi == YukseklikGirisTipi.standart ? 3.00 : (hKatNormalManuel ?? 3.00);
  double get efektifHKatBodrum => yukseklikGirisTipi == YukseklikGirisTipi.standart ? 3.50 : (hKatBodrumManuel ?? 3.50);

  // Hesaplamalar
  double get normalKatlarToplamH => (normalKatSayisi ?? 0) > 0 ? (normalKatSayisi! * efektifHKatNormal) : 0;
  double get hBina => efektifHKatZemin + normalKatlarToplamH;
  double get hBodrum => (bodrumKatSayisi ?? 0) > 0 ? (bodrumKatSayisi! * efektifHKatBodrum) : 0;
  double get hYapi => hBina + hBodrum;

  // Yüksek Bina Kontrolü (> 21.50m)
  bool get isGenelYuksekBina => hBina > 21.50;

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
      'h_bina': hBina,
      'h_yapi': hYapi,
      'is_genel_yuksek_bina': isGenelYuksekBina,
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