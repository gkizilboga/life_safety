import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum35Model {
  final ChoiceResult? tekYon;
  final ChoiceResult? ciftYon;
  final ChoiceResult? cikmaz;
  final ChoiceResult? cikmazMesafe;
  final double? manuelMesafe; // Sayısal giriş için

  Bolum35Model({
    this.tekYon,
    this.ciftYon,
    this.cikmaz,
    this.cikmazMesafe,
    this.manuelMesafe,
  });

  Bolum35Model copyWith({
    ChoiceResult? tekYon,
    ChoiceResult? ciftYon,
    ChoiceResult? cikmaz,
    ChoiceResult? cikmazMesafe,
    double? manuelMesafe,
  }) {
    return Bolum35Model(
      tekYon: tekYon ?? this.tekYon,
      ciftYon: ciftYon ?? this.ciftYon,
      cikmaz: cikmaz ?? this.cikmaz,
      cikmazMesafe: cikmazMesafe ?? this.cikmazMesafe,
      manuelMesafe: manuelMesafe ?? this.manuelMesafe,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tekYon_label': tekYon?.label,
      'ciftYon_label': ciftYon?.label,
      'cikmaz_label': cikmaz?.label,
      'cikmazMesafe_label': cikmazMesafe?.label,
      'manuelMesafe': manuelMesafe,
    };
  }

  factory Bolum35Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      try { return options.firstWhere((e) => e.label == label); } catch (_) { return null; }
    }

    return Bolum35Model(
      tekYon: find(map['tekYon_label'], [Bolum35Content.tekYonOptionA, Bolum35Content.tekYonOptionB, Bolum35Content.tekYonOptionC, Bolum35Content.tekYonOptionD]),
      ciftYon: find(map['ciftYon_label'], [Bolum35Content.ciftYonOptionA, Bolum35Content.ciftYonOptionB, Bolum35Content.ciftYonOptionC, Bolum35Content.ciftYonOptionD]),
      cikmaz: find(map['cikmaz_label'], [Bolum35Content.cikmazOptionA, Bolum35Content.cikmazOptionB]),
      cikmazMesafe: find(map['cikmazMesafe_label'], [Bolum35Content.cikmazMesafeOptionA, Bolum35Content.cikmazMesafeOptionB, Bolum35Content.cikmazMesafeOptionC, Bolum35Content.cikmazMesafeOptionD]),
      manuelMesafe: map['manuelMesafe'],
    );
  }
}