import 'package:life_safety/models/bolum_13_model.dart';

class Bolum21Model {
  ChoiceResult? resYghVarligi;
  ChoiceResult? resYghMalzeme;
  ChoiceResult? resYghKapi;
  ChoiceResult? resYghEsya;

  Bolum21Model({
    this.resYghVarligi,
    this.resYghMalzeme,
    this.resYghKapi,
    this.resYghEsya,
  });

  Bolum21Model copyWith({
    ChoiceResult? resYghVarligi,
    ChoiceResult? resYghMalzeme,
    ChoiceResult? resYghKapi,
    ChoiceResult? resYghEsya,
  }) {
    return Bolum21Model(
      resYghVarligi: resYghVarligi ?? this.resYghVarligi,
      resYghMalzeme: resYghMalzeme ?? this.resYghMalzeme,
      resYghKapi: resYghKapi ?? this.resYghKapi,
      resYghEsya: resYghEsya ?? this.resYghEsya,
    );
  }
}