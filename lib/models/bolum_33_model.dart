import 'choice_result.dart'; 

class Bolum33Model {
  final double? alanZemin;
  final double? alanNormal;
  final double? alanBodrumMax;
  final int? yukZemin;
  final int? yukNormal;
  final int? yukBodrum;
  final int? gerekliZemin;
  final int? gerekliNormal;
  final int? gerekliBodrum;
  final int? mevcutUst;
  final int? mevcutBodrum;

  Bolum33Model({
    this.alanZemin, this.alanNormal, this.alanBodrumMax,
    this.yukZemin, this.yukNormal, this.yukBodrum,
    this.gerekliZemin, this.gerekliNormal, this.gerekliBodrum,
    this.mevcutUst, this.mevcutBodrum,
  });

  Bolum33Model copyWith({
    double? alanZemin, double? alanNormal, double? alanBodrumMax,
    int? yukZemin, int? yukNormal, int? yukBodrum,
    int? gerekliZemin, int? gerekliNormal, int? gerekliBodrum,
    int? mevcutUst, int? mevcutBodrum,
  }) {
    return Bolum33Model(
      alanZemin: alanZemin ?? this.alanZemin,
      alanNormal: alanNormal ?? this.alanNormal,
      alanBodrumMax: alanBodrumMax ?? this.alanBodrumMax,
      yukZemin: yukZemin ?? this.yukZemin,
      yukNormal: yukNormal ?? this.yukNormal,
      yukBodrum: yukBodrum ?? this.yukBodrum,
      gerekliZemin: gerekliZemin ?? this.gerekliZemin,
      gerekliNormal: gerekliNormal ?? this.gerekliNormal,
      gerekliBodrum: gerekliBodrum ?? this.gerekliBodrum,
      mevcutUst: mevcutUst ?? this.mevcutUst,
      mevcutBodrum: mevcutBodrum ?? this.mevcutBodrum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alanZemin': alanZemin,
      'alanNormal': alanNormal,
      'alanBodrumMax': alanBodrumMax,
      'yukZemin': yukZemin,
      'yukNormal': yukNormal,
      'yukBodrum': yukBodrum,
      'gerekliZemin': gerekliZemin,
      'gerekliNormal': gerekliNormal,
      'gerekliBodrum': gerekliBodrum,
      'mevcutUst': mevcutUst,
      'mevcutBodrum': mevcutBodrum,
    };
  }

  factory Bolum33Model.fromMap(Map<String, dynamic> map) {
    return Bolum33Model(
      alanZemin: map['alanZemin'],
      alanNormal: map['alanNormal'],
      alanBodrumMax: map['alanBodrumMax'],
      yukZemin: map['yukZemin'],
      yukNormal: map['yukNormal'],
      yukBodrum: map['yukBodrum'],
      gerekliZemin: map['gerekliZemin'],
      gerekliNormal: map['gerekliNormal'],
      gerekliBodrum: map['gerekliBodrum'],
      mevcutUst: map['mevcutUst'],
      mevcutBodrum: map['mevcutBodrum'],
    );
  }
}