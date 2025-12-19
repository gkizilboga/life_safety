// lib/models/bolum_3_model.dart

enum YukseklikGirisTipi {
  hassas,
  standart,
}

class Bolum3Model {
  //--- KULLANICI GİRDİLERİ ---//
  final int? normalKatSayisi;
  final int? bodrumKatSayisi;
  final YukseklikGirisTipi? yukseklikGirisTipi;
  final double? hKatZeminManuel;
  final double? hKatNormalManuel;
  final double? hKatBodrumManuel;

  //--- BÖLÜM 3 HESAPLAMALARI (GETTERS) ---//
  double get efektifHKatZemin {
    if (yukseklikGirisTipi == YukseklikGirisTipi.standart) return 3.50;
    return hKatZeminManuel ?? 3.50;
  }

  double get efektifHKatNormal {
    if (yukseklikGirisTipi == YukseklikGirisTipi.standart) return 3.00;
    return hKatNormalManuel ?? 3.00;
  }

  double get efektifHKatBodrum {
    if (yukseklikGirisTipi == YukseklikGirisTipi.standart) return 3.50;
    return hKatBodrumManuel ?? 3.50;
  }

  double get hBina {
    final normalKatlarToplamH = (normalKatSayisi ?? 0) * efektifHKatNormal;
    return efektifHKatZemin + normalKatlarToplamH;
  }

  double get hBodrum {
    return (bodrumKatSayisi ?? 0) * efektifHKatBodrum;
  }

  double get hYapi => hBina + hBodrum;

  //--- BÖLÜM 4 HESAPLAMALARI (YENİ EKLENEN FLAGS) ---//

  // A) Bina Yüksekliğine Göre Bayraklar (h_bina)
  bool get isLimitBina0950 => hBina > 9.50;
  bool get isLimitBina1550 => hBina > 15.50;
  bool get isLimitBina2150 => hBina > 21.50;
  bool get isLimitBina2850 => hBina > 28.50;
  bool get isLimitBina3050 => hBina > 30.50;
  bool get isLimitBina5150 => hBina > 51.50;

  // B) Yapı Yüksekliğine Göre Bayraklar (h_yapi)
  bool get isLimitYapi2150 => hYapi > 21.50;
  bool get isLimitYapi3050 => hYapi > 30.50;
  bool get isLimitYapi5150 => hYapi > 51.50;

  // C) Yüksek Bina Tanımı (Master Flag)
  bool get isGenelYuksekBina => isLimitBina2150 || isLimitYapi3050;

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