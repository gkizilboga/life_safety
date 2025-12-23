class ChoiceResult {
  final String label; // A, B, C...
  final String reportText; // Rapor metni

  ChoiceResult({required this.label, required this.reportText});

  // DÜZELTME: Nesne eşitliği yerine içerik eşitliği kontrolü
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChoiceResult && other.label == label;
  }

  @override
  int get hashCode => label.hashCode;
}

class Bolum13Model {
  ChoiceResult? resOtoparkKapi;
  ChoiceResult? resKazanKapi;
  ChoiceResult? resAsansorKapi;
  ChoiceResult? resAsansorMakineKapi;
  ChoiceResult? resJeneratorKapi;
  ChoiceResult? resElektrikKapi;
  ChoiceResult? resTrafoKapi;
  ChoiceResult? resDepoKapi;
  ChoiceResult? resCopKapi;
  ChoiceResult? resOrtakDuvar;
  ChoiceResult? resTicariAlan;
  bool? hasTicariYanginKapisi;

  Bolum13Model({
    this.resOtoparkKapi,
    this.resKazanKapi,
    this.resAsansorKapi,
    this.resAsansorMakineKapi,
    this.resJeneratorKapi,
    this.resElektrikKapi,
    this.resTrafoKapi,
    this.resDepoKapi,
    this.resCopKapi,
    this.resOrtakDuvar,
    this.resTicariAlan,
    this.hasTicariYanginKapisi,
  });

  Bolum13Model copyWith({
    ChoiceResult? resOtoparkKapi,
    ChoiceResult? resKazanKapi,
    ChoiceResult? resAsansorKapi,
    ChoiceResult? resAsansorMakineKapi,
    ChoiceResult? resJeneratorKapi,
    ChoiceResult? resElektrikKapi,
    ChoiceResult? resTrafoKapi,
    ChoiceResult? resDepoKapi,
    ChoiceResult? resCopKapi,
    ChoiceResult? resOrtakDuvar,
    ChoiceResult? resTicariAlan,
    bool? hasTicariYanginKapisi,
  }) {
    return Bolum13Model(
      resOtoparkKapi: resOtoparkKapi ?? this.resOtoparkKapi,
      resKazanKapi: resKazanKapi ?? this.resKazanKapi,
      resAsansorKapi: resAsansorKapi ?? this.resAsansorKapi,
      resAsansorMakineKapi: resAsansorMakineKapi ?? this.resAsansorMakineKapi,
      resJeneratorKapi: resJeneratorKapi ?? this.resJeneratorKapi,
      resElektrikKapi: resElektrikKapi ?? this.resElektrikKapi,
      resTrafoKapi: resTrafoKapi ?? this.resTrafoKapi,
      resDepoKapi: resDepoKapi ?? this.resDepoKapi,
      resCopKapi: resCopKapi ?? this.resCopKapi,
      resOrtakDuvar: resOrtakDuvar ?? this.resOrtakDuvar,
      resTicariAlan: resTicariAlan ?? this.resTicariAlan,
      hasTicariYanginKapisi: hasTicariYanginKapisi ?? this.hasTicariYanginKapisi,
    );
  }
}