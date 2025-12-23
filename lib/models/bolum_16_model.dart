import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum16Model {
  ChoiceResult? resCepheTipi;
  ChoiceResult? resGiydirmeBosluk; // Alt Soru 1
  ChoiceResult? resSagirYuzey;
  ChoiceResult? resCepheSprinkler; // Alt Soru 2
  ChoiceResult? resBitisikCati; // Sadece Bitişik Nizamda

  Bolum16Model({
    this.resCepheTipi,
    this.resGiydirmeBosluk,
    this.resSagirYuzey,
    this.resCepheSprinkler,
    this.resBitisikCati,
  });

  Bolum16Model copyWith({
    ChoiceResult? resCepheTipi,
    ChoiceResult? resGiydirmeBosluk,
    ChoiceResult? resSagirYuzey,
    ChoiceResult? resCepheSprinkler,
    ChoiceResult? resBitisikCati,
  }) {
    return Bolum16Model(
      resCepheTipi: resCepheTipi ?? this.resCepheTipi,
      resGiydirmeBosluk: resGiydirmeBosluk ?? this.resGiydirmeBosluk,
      resSagirYuzey: resSagirYuzey ?? this.resSagirYuzey,
      resCepheSprinkler: resCepheSprinkler ?? this.resCepheSprinkler,
      resBitisikCati: resBitisikCati ?? this.resBitisikCati,
    );
  }
}