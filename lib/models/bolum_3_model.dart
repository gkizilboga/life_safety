class Bolum3Model {
  final int? normalKatSayisi;
  final int? bodrumKatSayisi;
  final double? katYuksekligi;
  final double? hBina;
  final double? hYapi;
  final bool isYuksekBina;

  Bolum3Model({
    this.normalKatSayisi,
    this.bodrumKatSayisi,
    this.katYuksekligi,
    this.hBina,
    this.hYapi,
    this.isYuksekBina = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'normalKatSayisi': normalKatSayisi,
      'bodrumKatSayisi': bodrumKatSayisi,
      'katYuksekligi': katYuksekligi,
      'hBina': hBina,
      'hYapi': hYapi,
      'isYuksekBina': isYuksekBina,
    };
  }

  factory Bolum3Model.fromMap(Map<String, dynamic> map) {
    return Bolum3Model(
      normalKatSayisi: map['normalKatSayisi'],
      bodrumKatSayisi: map['bodrumKatSayisi'],
      katYuksekligi: (map['katYuksekligi'] as num?)?.toDouble(),
      hBina: (map['hBina'] as num?)?.toDouble(),
      hYapi: (map['hYapi'] as num?)?.toDouble(),
      isYuksekBina: map['isYuksekBina'] ?? false,
    );
  }
}