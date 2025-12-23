import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum25Model {
  ChoiceResult? resDonerGenislikYuk;
  ChoiceResult? resDonerBasamak;
  ChoiceResult? resDonerBasKurtarma;

  Bolum25Model({
    this.resDonerGenislikYuk,
    this.resDonerBasamak,
    this.resDonerBasKurtarma,
  });

  Bolum25Model copyWith({
    ChoiceResult? resDonerGenislikYuk,
    ChoiceResult? resDonerBasamak,
    ChoiceResult? resDonerBasKurtarma,
  }) {
    return Bolum25Model(
      resDonerGenislikYuk: resDonerGenislikYuk ?? this.resDonerGenislikYuk,
      resDonerBasamak: resDonerBasamak ?? this.resDonerBasamak,
      resDonerBasKurtarma: resDonerBasKurtarma ?? this.resDonerBasKurtarma,
    );
  }
}