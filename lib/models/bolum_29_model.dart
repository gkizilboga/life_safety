import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum29Model {
  ChoiceResult? resTemizlikOtopark;
  ChoiceResult? resTemizlikKazan;
  ChoiceResult? resTemizlikCati;
  ChoiceResult? resTemizlikAsansor;
  ChoiceResult? resTemizlikJenerator;
  ChoiceResult? resTemizlikPano;
  ChoiceResult? resTemizlikTrafo;
  ChoiceResult? resTemizlikDepo;
  ChoiceResult? resTemizlikCop;
  ChoiceResult? resTemizlikSiginak;

  Bolum29Model({
    this.resTemizlikOtopark,
    this.resTemizlikKazan,
    this.resTemizlikCati,
    this.resTemizlikAsansor,
    this.resTemizlikJenerator,
    this.resTemizlikPano,
    this.resTemizlikTrafo,
    this.resTemizlikDepo,
    this.resTemizlikCop,
    this.resTemizlikSiginak,
  });

  Bolum29Model copyWith({
    ChoiceResult? resTemizlikOtopark,
    ChoiceResult? resTemizlikKazan,
    ChoiceResult? resTemizlikCati,
    ChoiceResult? resTemizlikAsansor,
    ChoiceResult? resTemizlikJenerator,
    ChoiceResult? resTemizlikPano,
    ChoiceResult? resTemizlikTrafo,
    ChoiceResult? resTemizlikDepo,
    ChoiceResult? resTemizlikCop,
    ChoiceResult? resTemizlikSiginak,
  }) {
    return Bolum29Model(
      resTemizlikOtopark: resTemizlikOtopark ?? this.resTemizlikOtopark,
      resTemizlikKazan: resTemizlikKazan ?? this.resTemizlikKazan,
      resTemizlikCati: resTemizlikCati ?? this.resTemizlikCati,
      resTemizlikAsansor: resTemizlikAsansor ?? this.resTemizlikAsansor,
      resTemizlikJenerator: resTemizlikJenerator ?? this.resTemizlikJenerator,
      resTemizlikPano: resTemizlikPano ?? this.resTemizlikPano,
      resTemizlikTrafo: resTemizlikTrafo ?? this.resTemizlikTrafo,
      resTemizlikDepo: resTemizlikDepo ?? this.resTemizlikDepo,
      resTemizlikCop: resTemizlikCop ?? this.resTemizlikCop,
      resTemizlikSiginak: resTemizlikSiginak ?? this.resTemizlikSiginak,
    );
  }
}