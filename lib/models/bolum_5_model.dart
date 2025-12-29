class Bolum5Model {
  final double? tabanAlani;
  final double? normalKatAlani;
  final double? bodrumKatAlani;
  final double? toplamInsaatAlani;

  // ESKİ KODLARIN ÇALIŞMASI İÇİN GETTER EKLEDİK
  double? get katAlani => normalKatAlani;

  Bolum5Model({
    this.tabanAlani,
    this.normalKatAlani,
    this.bodrumKatAlani,
    this.toplamInsaatAlani,
  });

  Bolum5Model copyWith({
    double? tabanAlani,
    double? normalKatAlani,
    double? bodrumKatAlani,
    double? toplamInsaatAlani,
  }) {
    return Bolum5Model(
      tabanAlani: tabanAlani ?? this.tabanAlani,
      normalKatAlani: normalKatAlani ?? this.normalKatAlani,
      bodrumKatAlani: bodrumKatAlani ?? this.bodrumKatAlani,
      toplamInsaatAlani: toplamInsaatAlani ?? this.toplamInsaatAlani,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tabanAlani': tabanAlani,
      'normalKatAlani': normalKatAlani,
      'bodrumKatAlani': bodrumKatAlani,
      'toplamInsaatAlani': toplamInsaatAlani,
    };
  }

  factory Bolum5Model.fromMap(Map<String, dynamic> map) {
    return Bolum5Model(
      tabanAlani: map['tabanAlani'],
      normalKatAlani: map['normalKatAlani'],
      bodrumKatAlani: map['bodrumKatAlani'],
      toplamInsaatAlani: map['toplamInsaatAlani'],
    );
  }
}