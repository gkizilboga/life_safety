import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum31Model {
  final ChoiceResult? yapi;
  final ChoiceResult? tip;
  final ChoiceResult? cukur;
  final ChoiceResult? sondurme;
  final ChoiceResult? cevre;

  Bolum31Model({
    this.yapi,
    this.tip,
    this.cukur,
    this.sondurme,
    this.cevre,
  });

  Bolum31Model copyWith({
    ChoiceResult? yapi,
    ChoiceResult? tip,
    ChoiceResult? cukur,
    ChoiceResult? sondurme,
    ChoiceResult? cevre,
  }) {
    return Bolum31Model(
      yapi: yapi ?? this.yapi,
      tip: tip ?? this.tip,
      cukur: cukur ?? this.cukur,
      sondurme: sondurme ?? this.sondurme,
      cevre: cevre ?? this.cevre,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'yapi_label': yapi?.label,
      'tip_label': tip?.label,
      'cukur_label': cukur?.label,
      'sondurme_label': sondurme?.label,
      'cevre_label': cevre?.label,
    };
  }

  factory Bolum31Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l) {
      if (l == null) return null;
      return [
        Bolum31Content.yapiOptionA, Bolum31Content.yapiOptionB, Bolum31Content.yapiOptionC, Bolum31Content.yapiOptionD,
        Bolum31Content.tipOptionA, Bolum31Content.tipOptionB, Bolum31Content.tipOptionC,
        Bolum31Content.cukurOptionA, Bolum31Content.cukurOptionB, Bolum31Content.cukurOptionC,
        Bolum31Content.sondurmeOptionA, Bolum31Content.sondurmeOptionB, Bolum31Content.sondurmeOptionC,
        Bolum31Content.cevreOptionA, Bolum31Content.cevreOptionB, Bolum31Content.cevreOptionC, Bolum31Content.cevreOptionD,
      ].firstWhere((e) => e.label == l, orElse: () => Bolum31Content.tipOptionC);
    }

    return Bolum31Model(
      yapi: find(map['yapi_label']),
      tip: find(map['tip_label']),
      cukur: find(map['cukur_label']),
      sondurme: find(map['sondurme_label']),
      cevre: find(map['cevre_label']),
    );
  }
}