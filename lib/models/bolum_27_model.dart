import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum27Model {
  ChoiceResult? resKapiBoyutEsik;
  ChoiceResult? resKapiYonu;
  ChoiceResult? resKapiMekanizma;
  ChoiceResult? resKapiDayanim;

  Bolum27Model({
    this.resKapiBoyutEsik,
    this.resKapiYonu,
    this.resKapiMekanizma,
    this.resKapiDayanim,
  });

  Bolum27Model copyWith({
    ChoiceResult? resKapiBoyutEsik,
    ChoiceResult? resKapiYonu,
    ChoiceResult? resKapiMekanizma,
    ChoiceResult? resKapiDayanim,
  }) {
    return Bolum27Model(
      resKapiBoyutEsik: resKapiBoyutEsik ?? this.resKapiBoyutEsik,
      resKapiYonu: resKapiYonu ?? this.resKapiYonu,
      resKapiMekanizma: resKapiMekanizma ?? this.resKapiMekanizma,
      resKapiDayanim: resKapiDayanim ?? this.resKapiDayanim,
    );
  }
}