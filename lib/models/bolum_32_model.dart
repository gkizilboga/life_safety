import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum32Model {
  ChoiceResult? resJeneratorYapi;
  ChoiceResult? resJeneratorYakit;
  ChoiceResult? resJeneratorCevre;
  ChoiceResult? resJeneratorHavalandirma;

  Bolum32Model({
    this.resJeneratorYapi,
    this.resJeneratorYakit,
    this.resJeneratorCevre,
    this.resJeneratorHavalandirma,
  });

  Bolum32Model copyWith({
    ChoiceResult? resJeneratorYapi,
    ChoiceResult? resJeneratorYakit,
    ChoiceResult? resJeneratorCevre,
    ChoiceResult? resJeneratorHavalandirma,
  }) {
    return Bolum32Model(
      resJeneratorYapi: resJeneratorYapi ?? this.resJeneratorYapi,
      resJeneratorYakit: resJeneratorYakit ?? this.resJeneratorYakit,
      resJeneratorCevre: resJeneratorCevre ?? this.resJeneratorCevre,
      resJeneratorHavalandirma: resJeneratorHavalandirma ?? this.resJeneratorHavalandirma,
    );
  }
}