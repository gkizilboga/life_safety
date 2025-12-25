import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum3Model {
  final int? normalKatSayisi;
  final int? bodrumKatSayisi;
  
  // Yükseklik Hassasiyet Tercihi (Biliniyor / Standart)
  final ChoiceResult? yukseklikTercihi;

  // Girilen Değerler
  final double? zeminKatYuksekligi;
  final double? normalKatYuksekligi;
  final double? bodrumKatYuksekligi;

  // Hesaplanan Sonuçlar (Özet Ekranı İçin)
  final double? hBina; // Zemin + Normal
  final double? hYapi; // Zemin + Normal + Bodrum
  final bool? isYuksekBina; // hBina > 21.50 mi?

  Bolum3Model({
    this.normalKatSayisi,
    this.bodrumKatSayisi,
    this.yukseklikTercihi,
    this.zeminKatYuksekligi,
    this.normalKatYuksekligi,
    this.bodrumKatYuksekligi,
    this.hBina,
    this.hYapi,
    this.isYuksekBina,
  });

  Bolum3Model copyWith({
    int? normalKatSayisi,
    int? bodrumKatSayisi,
    ChoiceResult? yukseklikTercihi,
    double? zeminKatYuksekligi,
    double? normalKatYuksekligi,
    double? bodrumKatYuksekligi,
    double? hBina,
    double? hYapi,
    bool? isYuksekBina,
  }) {
    return Bolum3Model(
      normalKatSayisi: normalKatSayisi ?? this.normalKatSayisi,
      bodrumKatSayisi: bodrumKatSayisi ?? this.bodrumKatSayisi,
      yukseklikTercihi: yukseklikTercihi ?? this.yukseklikTercihi,
      zeminKatYuksekligi: zeminKatYuksekligi ?? this.zeminKatYuksekligi,
      normalKatYuksekligi: normalKatYuksekligi ?? this.normalKatYuksekligi,
      bodrumKatYuksekligi: bodrumKatYuksekligi ?? this.bodrumKatYuksekligi,
      hBina: hBina ?? this.hBina,
      hYapi: hYapi ?? this.hYapi,
      isYuksekBina: isYuksekBina ?? this.isYuksekBina,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'normalKatSayisi': normalKatSayisi,
      'bodrumKatSayisi': bodrumKatSayisi,
      'yukseklikTercihi_label': yukseklikTercihi?.label,
      'zeminKatYuksekligi': zeminKatYuksekligi,
      'normalKatYuksekligi': normalKatYuksekligi,
      'bodrumKatYuksekligi': bodrumKatYuksekligi,
      'hBina': hBina,
      'hYapi': hYapi,
      'isYuksekBina': isYuksekBina,
    };
  }

  factory Bolum3Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? secilenTercih;
    final label = map['yukseklikTercihi_label'];
    if (label == Bolum3Content.yukseklikBiliniyor.label) {
      secilenTercih = Bolum3Content.yukseklikBiliniyor;
    } else if (label == Bolum3Content.yukseklikStandart.label) {
      secilenTercih = Bolum3Content.yukseklikStandart;
    }

    return Bolum3Model(
      normalKatSayisi: map['normalKatSayisi'],
      bodrumKatSayisi: map['bodrumKatSayisi'],
      yukseklikTercihi: secilenTercih,
      zeminKatYuksekligi: map['zeminKatYuksekligi'],
      normalKatYuksekligi: map['normalKatYuksekligi'],
      bodrumKatYuksekligi: map['bodrumKatYuksekligi'],
      hBina: map['hBina'],
      hYapi: map['hYapi'],
      isYuksekBina: map['isYuksekBina'],
    );
  }
}