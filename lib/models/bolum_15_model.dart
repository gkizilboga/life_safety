import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult sınıfını kullanmak için

class Bolum15Model {
  ChoiceResult? resDosemeKaplama;
  ChoiceResult? resDosemeYalitim;
  ChoiceResult? resSapDurumu; // Alt Soru 1
  ChoiceResult? resAsmaTavan;
  ChoiceResult? resTavanMalzeme; // Alt Soru 2
  ChoiceResult? resTesisatGecis;

  Bolum15Model({
    this.resDosemeKaplama,
    this.resDosemeYalitim,
    this.resSapDurumu,
    this.resAsmaTavan,
    this.resTavanMalzeme,
    this.resTesisatGecis,
  });

  Bolum15Model copyWith({
    ChoiceResult? resDosemeKaplama,
    ChoiceResult? resDosemeYalitim,
    ChoiceResult? resSapDurumu,
    ChoiceResult? resAsmaTavan,
    ChoiceResult? resTavanMalzeme,
    ChoiceResult? resTesisatGecis,
  }) {
    return Bolum15Model(
      resDosemeKaplama: resDosemeKaplama ?? this.resDosemeKaplama,
      resDosemeYalitim: resDosemeYalitim ?? this.resDosemeYalitim,
      resSapDurumu: resSapDurumu ?? this.resSapDurumu,
      resAsmaTavan: resAsmaTavan ?? this.resAsmaTavan,
      resTavanMalzeme: resTavanMalzeme ?? this.resTavanMalzeme,
      resTesisatGecis: resTesisatGecis ?? this.resTesisatGecis,
    );
  }
}