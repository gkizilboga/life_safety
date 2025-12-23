import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum31Model {
  ChoiceResult? resTrafoYapi;
  ChoiceResult? resTrafoTip;
  ChoiceResult? resTrafoCukur; // Alt Soru
  ChoiceResult? resTrafoSondurme;
  ChoiceResult? resTrafoCevre;

  Bolum31Model({
    this.resTrafoYapi,
    this.resTrafoTip,
    this.resTrafoCukur,
    this.resTrafoSondurme,
    this.resTrafoCevre,
  });

  Bolum31Model copyWith({
    ChoiceResult? resTrafoYapi,
    ChoiceResult? resTrafoTip,
    ChoiceResult? resTrafoCukur,
    ChoiceResult? resTrafoSondurme,
    ChoiceResult? resTrafoCevre,
  }) {
    return Bolum31Model(
      resTrafoYapi: resTrafoYapi ?? this.resTrafoYapi,
      resTrafoTip: resTrafoTip ?? this.resTrafoTip,
      resTrafoCukur: resTrafoCukur ?? this.resTrafoCukur,
      resTrafoSondurme: resTrafoSondurme ?? this.resTrafoSondurme,
      resTrafoCevre: resTrafoCevre ?? this.resTrafoCevre,
    );
  }
}