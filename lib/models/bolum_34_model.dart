import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum34Model {
  ChoiceResult? resTicariCikisZemin;
  ChoiceResult? resTicariCikisBodrum;

  Bolum34Model({
    this.resTicariCikisZemin,
    this.resTicariCikisBodrum,
  });

  Bolum34Model copyWith({
    ChoiceResult? resTicariCikisZemin,
    ChoiceResult? resTicariCikisBodrum,
  }) {
    return Bolum34Model(
      resTicariCikisZemin: resTicariCikisZemin ?? this.resTicariCikisZemin,
      resTicariCikisBodrum: resTicariCikisBodrum ?? this.resTicariCikisBodrum,
    );
  }
}