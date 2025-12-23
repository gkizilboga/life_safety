class Bolum4Model {
  final double hBina;
  final double hYapi;

  Bolum4Model({required this.hBina, required this.hYapi});

  bool get isLimitBina0950 => hBina > 9.50;
  bool get isLimitBina1550 => hBina > 15.50;
  bool get isLimitBina2150 => hBina > 21.50;
  bool get isLimitBina2850 => hBina > 28.50;
  bool get isLimitBina3050 => hBina > 30.50;
  bool get isLimitBina5150 => hBina > 51.50;

  bool get isLimitYapi2150 => hYapi > 21.50;
  bool get isLimitYapi3050 => hYapi > 30.50;
  bool get isLimitYapi5150 => hYapi > 51.50;

  bool get isGenelYuksekBina => isLimitBina2150 || isLimitYapi3050;

  Map<String, dynamic> toMap() {
    return {
      'h_bina': hBina,
      'h_yapi': hYapi,
      'is_limit_bina_0950': isLimitBina0950,
      'is_limit_bina_1550': isLimitBina1550,
      'is_limit_bina_2150': isLimitBina2150,
      'is_limit_bina_2850': isLimitBina2850,
      'is_limit_bina_3050': isLimitBina3050,
      'is_limit_bina_5150': isLimitBina5150,
      'is_limit_yapi_2150': isLimitYapi2150,
      'is_limit_yapi_3050': isLimitYapi3050,
      'is_limit_yapi_5150': isLimitYapi5150,
      'is_genel_yuksek_bina': isGenelYuksekBina,
    };
  }

  factory Bolum4Model.fromMap(Map<String, dynamic> map) {
    return Bolum4Model(
      hBina: map['h_bina'] ?? 0.0,
      hYapi: map['h_yapi'] ?? 0.0,
    );
  }
}