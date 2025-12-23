import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum35Model {
  // Senaryo 1 (Tek Çıkış)
  ChoiceResult? resMesafeTekYon;
  double? valMesafeTekYon;

  // Senaryo 2 (Çok Çıkış)
  ChoiceResult? resMesafeCiftYon;
  double? valMesafeCiftYon;
  
  ChoiceResult? hasCikmazKoridor;
  
  ChoiceResult? resMesafeCikmaz;
  double? valMesafeCikmaz;

  Bolum35Model({
    this.resMesafeTekYon,
    this.valMesafeTekYon,
    this.resMesafeCiftYon,
    this.valMesafeCiftYon,
    this.hasCikmazKoridor,
    this.resMesafeCikmaz,
    this.valMesafeCikmaz,
  });

  Bolum35Model copyWith({
    ChoiceResult? resMesafeTekYon,
    double? valMesafeTekYon,
    ChoiceResult? resMesafeCiftYon,
    double? valMesafeCiftYon,
    ChoiceResult? hasCikmazKoridor,
    ChoiceResult? resMesafeCikmaz,
    double? valMesafeCikmaz,
  }) {
    return Bolum35Model(
      resMesafeTekYon: resMesafeTekYon ?? this.resMesafeTekYon,
      valMesafeTekYon: valMesafeTekYon ?? this.valMesafeTekYon,
      resMesafeCiftYon: resMesafeCiftYon ?? this.resMesafeCiftYon,
      valMesafeCiftYon: valMesafeCiftYon ?? this.valMesafeCiftYon,
      hasCikmazKoridor: hasCikmazKoridor ?? this.hasCikmazKoridor,
      resMesafeCikmaz: resMesafeCikmaz ?? this.resMesafeCikmaz,
      valMesafeCikmaz: valMesafeCikmaz ?? this.valMesafeCikmaz,
    );
  }
}