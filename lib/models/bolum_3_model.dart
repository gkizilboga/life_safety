class Bolum3Model {
  final int? normalKatSayisi;
  final int? bodrumKatSayisi;
  final double? zeminYuksekligi;
  final double? normalYuksekligi;
  final double? bodrumYuksekligi;
  final double? hBina;
  final double? hYapi;
  final bool isYuksekBina;
  final bool yukseklikBilinmiyor;
  final bool isConfirmed;

  Bolum3Model({
    this.normalKatSayisi,
    this.bodrumKatSayisi,
    this.zeminYuksekligi,
    this.normalYuksekligi,
    this.bodrumYuksekligi,
    this.hBina,
    this.hYapi,
    this.isYuksekBina = false,
    this.yukseklikBilinmiyor = false,
    this.isConfirmed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'normalKatSayisi': normalKatSayisi,
      'bodrumKatSayisi': bodrumKatSayisi,
      'zeminYuksekligi': zeminYuksekligi,
      'normalYuksekligi': normalYuksekligi,
      'bodrumYuksekligi': bodrumYuksekligi,
      'hBina': hBina,
      'hYapi': hYapi,
      'isYuksekBina': isYuksekBina,
      'yukseklikBilinmiyor': yukseklikBilinmiyor,
      'isConfirmed': isConfirmed,
    };
  }

  factory Bolum3Model.fromMap(Map<String, dynamic> map) {
    return Bolum3Model(
      normalKatSayisi: map['normalKatSayisi'],
      bodrumKatSayisi: map['bodrumKatSayisi'],
      zeminYuksekligi: (map['zeminYuksekligi'] as num?)?.toDouble(),
      normalYuksekligi: (map['normalYuksekligi'] as num?)?.toDouble(),
      bodrumYuksekligi: (map['bodrumYuksekligi'] as num?)?.toDouble(),
      hBina: (map['hBina'] as num?)?.toDouble(),
      hYapi: (map['hYapi'] as num?)?.toDouble(),
      isYuksekBina: map['isYuksekBina'] ?? false,
      yukseklikBilinmiyor: map['yukseklikBilinmiyor'] ?? false,
      isConfirmed: map['isConfirmed'] ?? false,
    );
  }

  Bolum3Model copyWith({
    int? normalKatSayisi,
    int? bodrumKatSayisi,
    double? zeminYuksekligi,
    double? normalYuksekligi,
    double? bodrumYuksekligi,
    double? hBina,
    double? hYapi,
    bool? isYuksekBina,
    bool? yukseklikBilinmiyor,
    bool? isConfirmed,
  }) {
    return Bolum3Model(
      normalKatSayisi: normalKatSayisi ?? this.normalKatSayisi,
      bodrumKatSayisi: bodrumKatSayisi ?? this.bodrumKatSayisi,
      zeminYuksekligi: zeminYuksekligi ?? this.zeminYuksekligi,
      normalYuksekligi: normalYuksekligi ?? this.normalYuksekligi,
      bodrumYuksekligi: bodrumYuksekligi ?? this.bodrumYuksekligi,
      hBina: hBina ?? this.hBina,
      hYapi: hYapi ?? this.hYapi,
      isYuksekBina: isYuksekBina ?? this.isYuksekBina,
      yukseklikBilinmiyor: yukseklikBilinmiyor ?? this.yukseklikBilinmiyor,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }
}
