import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum23Model {
  ChoiceResult? resAsansorBodrumHol;
  ChoiceResult? resAsansorYanginModu;
  ChoiceResult? resAsansorMerdivenIliski;
  ChoiceResult? resAsansorLevha;
  ChoiceResult? resAsansorHavalandirma;

  Bolum23Model({
    this.resAsansorBodrumHol,
    this.resAsansorYanginModu,
    this.resAsansorMerdivenIliski,
    this.resAsansorLevha,
    this.resAsansorHavalandirma,
  });

  Bolum23Model copyWith({
    ChoiceResult? resAsansorBodrumHol,
    ChoiceResult? resAsansorYanginModu,
    ChoiceResult? resAsansorMerdivenIliski,
    ChoiceResult? resAsansorLevha,
    ChoiceResult? resAsansorHavalandirma,
  }) {
    return Bolum23Model(
      resAsansorBodrumHol: resAsansorBodrumHol ?? this.resAsansorBodrumHol,
      resAsansorYanginModu: resAsansorYanginModu ?? this.resAsansorYanginModu,
      resAsansorMerdivenIliski: resAsansorMerdivenIliski ?? this.resAsansorMerdivenIliski,
      resAsansorLevha: resAsansorLevha ?? this.resAsansorLevha,
      resAsansorHavalandirma: resAsansorHavalandirma ?? this.resAsansorHavalandirma,
    );
  }
}