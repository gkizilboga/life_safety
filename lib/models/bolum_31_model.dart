import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum31Model {
  final ChoiceResult? yapi;
  final ChoiceResult? tip;
  final ChoiceResult? cukur; // Yağlı tip ise
  final ChoiceResult? sondurme; // Yağlı tip ise
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
    // Yapı
    ChoiceResult? y;
    final l1 = map['yapi_label'];
    if (l1 == Bolum31Content.yapiOptionA.label) y = Bolum31Content.yapiOptionA;
    if (l1 == Bolum31Content.yapiOptionB.label) y = Bolum31Content.yapiOptionB;
    if (l1 == Bolum31Content.yapiOptionC.label) y = Bolum31Content.yapiOptionC;

    // Tip
    ChoiceResult? t;
    final l2 = map['tip_label'];
    if (l2 == Bolum31Content.tipOptionA.label) t = Bolum31Content.tipOptionA;
    if (l2 == Bolum31Content.tipOptionB.label) t = Bolum31Content.tipOptionB;

    // Çukur
    ChoiceResult? c;
    final l3 = map['cukur_label'];
    if (l3 == Bolum31Content.cukurOptionA.label) c = Bolum31Content.cukurOptionA;
    if (l3 == Bolum31Content.cukurOptionB.label) c = Bolum31Content.cukurOptionB;

    // Söndürme
    ChoiceResult? s;
    final l4 = map['sondurme_label'];
    if (l4 == Bolum31Content.sondurmeOptionA.label) s = Bolum31Content.sondurmeOptionA;
    if (l4 == Bolum31Content.sondurmeOptionB.label) s = Bolum31Content.sondurmeOptionB;

    // Çevre
    ChoiceResult? ce;
    final l5 = map['cevre_label'];
    if (l5 == Bolum31Content.cevreOptionA.label) ce = Bolum31Content.cevreOptionA;
    if (l5 == Bolum31Content.cevreOptionB.label) ce = Bolum31Content.cevreOptionB;
    if (l5 == Bolum31Content.cevreOptionC.label) ce = Bolum31Content.cevreOptionC;

    return Bolum31Model(
      yapi: y,
      tip: t,
      cukur: c,
      sondurme: s,
      cevre: ce,
    );
  }
}