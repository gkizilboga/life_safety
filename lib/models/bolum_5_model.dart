class Bolum5Model {
  final double? tabanAlani;
  final double? katAlani;
  final double? toplamInsaatAlani;

  Bolum5Model({
    this.tabanAlani,
    this.katAlani,
    this.toplamInsaatAlani,
  });

  Bolum5Model copyWith({
    double? tabanAlani,
    double? katAlani,
    double? toplamInsaatAlani,
  }) {
    return Bolum5Model(
      tabanAlani: tabanAlani ?? this.tabanAlani,
      katAlani: katAlani ?? this.katAlani,
      toplamInsaatAlani: toplamInsaatAlani ?? this.toplamInsaatAlani,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tabanAlani': tabanAlani,
      'katAlani': katAlani,
      'toplamInsaatAlani': toplamInsaatAlani,
    };
  }

  factory Bolum5Model.fromMap(Map<String, dynamic> map) {
    return Bolum5Model(
      tabanAlani: map['tabanAlani'],
      katAlani: map['katAlani'],
      toplamInsaatAlani: map['toplamInsaatAlani'],
    );
  }
}