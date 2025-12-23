import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum26Model {
  ChoiceResult? resRampaVar;
  ChoiceResult? resRampaEgim;
  ChoiceResult? resRampaSahanlik;
  ChoiceResult? resOtoparkRampa;

  Bolum26Model({
    this.resRampaVar,
    this.resRampaEgim,
    this.resRampaSahanlik,
    this.resOtoparkRampa,
  });

  Bolum26Model copyWith({
    ChoiceResult? resRampaVar,
    ChoiceResult? resRampaEgim,
    ChoiceResult? resRampaSahanlik,
    ChoiceResult? resOtoparkRampa,
  }) {
    return Bolum26Model(
      resRampaVar: resRampaVar ?? this.resRampaVar,
      resRampaEgim: resRampaEgim ?? this.resRampaEgim,
      resRampaSahanlik: resRampaSahanlik ?? this.resRampaSahanlik,
      resOtoparkRampa: resOtoparkRampa ?? this.resOtoparkRampa,
    );
  }
}