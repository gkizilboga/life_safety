import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult sınıfı için

class Bolum17Model {
  ChoiceResult? resCatiKaplama;
  ChoiceResult? resCatiYalitim;
  ChoiceResult? resBitisikCati; // Sadece Bitişik Nizamda
  ChoiceResult? resCatiIsiklik;
  ChoiceResult? resIsiklikMalzeme; // Alt Soru

  Bolum17Model({
    this.resCatiKaplama,
    this.resCatiYalitim,
    this.resBitisikCati,
    this.resCatiIsiklik,
    this.resIsiklikMalzeme,
  });

  Bolum17Model copyWith({
    ChoiceResult? resCatiKaplama,
    ChoiceResult? resCatiYalitim,
    ChoiceResult? resBitisikCati,
    ChoiceResult? resCatiIsiklik,
    ChoiceResult? resIsiklikMalzeme,
  }) {
    return Bolum17Model(
      resCatiKaplama: resCatiKaplama ?? this.resCatiKaplama,
      resCatiYalitim: resCatiYalitim ?? this.resCatiYalitim,
      resBitisikCati: resBitisikCati ?? this.resBitisikCati,
      resCatiIsiklik: resCatiIsiklik ?? this.resCatiIsiklik,
      resIsiklikMalzeme: resIsiklikMalzeme ?? this.resIsiklikMalzeme,
    );
  }
}