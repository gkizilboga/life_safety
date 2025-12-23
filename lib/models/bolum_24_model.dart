import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum24Model {
  ChoiceResult? resKoridorTipi;
  ChoiceResult? resGecitPencere;
  ChoiceResult? resPencereYukseklik; // Alt Soru
  ChoiceResult? resGecitKapi;

  Bolum24Model({
    this.resKoridorTipi,
    this.resGecitPencere,
    this.resPencereYukseklik,
    this.resGecitKapi,
  });

  Bolum24Model copyWith({
    ChoiceResult? resKoridorTipi,
    ChoiceResult? resGecitPencere,
    ChoiceResult? resPencereYukseklik,
    ChoiceResult? resGecitKapi,
  }) {
    return Bolum24Model(
      resKoridorTipi: resKoridorTipi ?? this.resKoridorTipi,
      resGecitPencere: resGecitPencere ?? this.resGecitPencere,
      resPencereYukseklik: resPencereYukseklik ?? this.resPencereYukseklik,
      resGecitKapi: resGecitKapi ?? this.resGecitKapi,
    );
  }
}