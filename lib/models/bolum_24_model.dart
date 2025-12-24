import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum24Model {
  final ChoiceResult? tip;
  final ChoiceResult? pencere;
  final ChoiceResult? kapi;

  Bolum24Model({
    this.tip,
    this.pencere,
    this.kapi,
  });

  Bolum24Model copyWith({
    ChoiceResult? tip,
    ChoiceResult? pencere,
    ChoiceResult? kapi,
  }) {
    return Bolum24Model(
      tip: tip ?? this.tip,
      pencere: pencere ?? this.pencere,
      kapi: kapi ?? this.kapi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tip_label': tip?.label,
      'pencere_label': pencere?.label,
      'kapi_label': kapi?.label,
    };
  }

  factory Bolum24Model.fromMap(Map<String, dynamic> map) {
    // Tip
    ChoiceResult? t;
    final l1 = map['tip_label'];
    if (l1 == Bolum24Content.tipOptionA.label) t = Bolum24Content.tipOptionA;
    if (l1 == Bolum24Content.tipOptionB.label) t = Bolum24Content.tipOptionB;

    // Pencere
    ChoiceResult? p;
    final l2 = map['pencere_label'];
    if (l2 == Bolum24Content.pencereOptionA.label) p = Bolum24Content.pencereOptionA;
    if (l2 == Bolum24Content.pencereOptionB.label) p = Bolum24Content.pencereOptionB;

    // Kapı
    ChoiceResult? k;
    final l3 = map['kapi_label'];
    if (l3 == Bolum24Content.kapiOptionA.label) k = Bolum24Content.kapiOptionA;
    if (l3 == Bolum24Content.kapiOptionB.label) k = Bolum24Content.kapiOptionB;

    return Bolum24Model(
      tip: t,
      pencere: p,
      kapi: k,
    );
  }
}