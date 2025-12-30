import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum24Model {
  final ChoiceResult? tip;
  final ChoiceResult? pencere;
  final ChoiceResult? kapi;

  ChoiceResult? get secim => tip ?? pencere ?? kapi;

  Bolum24Model({this.tip, this.pencere, this.kapi});

  Bolum24Model copyWith({ChoiceResult? tip, ChoiceResult? pencere, ChoiceResult? kapi}) {
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
    ChoiceResult? find(String? l) {
      if (l == null) return null;
      return [
        Bolum24Content.tipOptionA, Bolum24Content.tipOptionB, Bolum24Content.tipOptionC,
        Bolum24Content.pencereOptionA, Bolum24Content.pencereOptionB, Bolum24Content.pencereOptionC,
        Bolum24Content.kapiOptionA, Bolum24Content.kapiOptionB, Bolum24Content.kapiOptionC,
      ].firstWhere((e) => e.label == l, orElse: () => Bolum24Content.tipOptionC);
    }

    return Bolum24Model(
      tip: find(map['tip_label']),
      pencere: find(map['pencere_label']),
      kapi: find(map['kapi_label']),
    );
  }
}