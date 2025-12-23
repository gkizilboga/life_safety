enum TasiyiciSistem { betonarme, celik, ahsap, yigma }
enum TasiyiciSistemSecim { betonarme, celik, ahsap, yigma, bilmiyorum }

class Bolum2Model {
  final TasiyiciSistemSecim? secim;
  Bolum2Model({this.secim});

  TasiyiciSistem? get efektifTasiyiciSistem {
    if (secim == null) return null;
    switch (secim!) {
      case TasiyiciSistemSecim.betonarme:
      case TasiyiciSistemSecim.bilmiyorum:
        return TasiyiciSistem.betonarme;
      case TasiyiciSistemSecim.celik:
        return TasiyiciSistem.celik;
      case TasiyiciSistemSecim.ahsap:
        return TasiyiciSistem.ahsap;
      case TasiyiciSistemSecim.yigma:
        return TasiyiciSistem.yigma;
    }
  }

  String? get tasiyiciSistemDeger {
    if (secim == null) return null;
    if (secim == TasiyiciSistemSecim.bilmiyorum) return 'BETONARME';
    switch (secim!) {
      case TasiyiciSistemSecim.betonarme: return 'BETONARME';
      case TasiyiciSistemSecim.celik: return 'CELIK';
      case TasiyiciSistemSecim.ahsap: return 'AHSAP';
      case TasiyiciSistemSecim.yigma: return 'YIGMA';
      default: return null;
    }
  }

  bool get bilgilendirmeGerekli => secim == TasiyiciSistemSecim.bilmiyorum;

  Bolum2Model copyWith({TasiyiciSistemSecim? secim}) {
    return Bolum2Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim': secim?.name};
  }

  factory Bolum2Model.fromMap(Map<String, dynamic> map) {
    return Bolum2Model(
      secim: map['secim'] != null
          ? TasiyiciSistemSecim.values.byName(map['secim'])
          : null,
    );
  }
}