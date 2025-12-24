import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum27Model {
  final ChoiceResult? boyut;
  final ChoiceResult? yon;
  final ChoiceResult? kilit;
  final ChoiceResult? dayanim;

  Bolum27Model({
    this.boyut,
    this.yon,
    this.kilit,
    this.dayanim,
  });

  Bolum27Model copyWith({
    ChoiceResult? boyut,
    ChoiceResult? yon,
    ChoiceResult? kilit,
    ChoiceResult? dayanim,
  }) {
    return Bolum27Model(
      boyut: boyut ?? this.boyut,
      yon: yon ?? this.yon,
      kilit: kilit ?? this.kilit,
      dayanim: dayanim ?? this.dayanim,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'boyut_label': boyut?.label,
      'yon_label': yon?.label,
      'kilit_label': kilit?.label,
      'dayanim_label': dayanim?.label,
    };
  }

  factory Bolum27Model.fromMap(Map<String, dynamic> map) {
    // Boyut
    ChoiceResult? b;
    final l1 = map['boyut_label'];
    if (l1 == Bolum27Content.boyutOptionA.label) b = Bolum27Content.boyutOptionA;
    if (l1 == Bolum27Content.boyutOptionB.label) b = Bolum27Content.boyutOptionB;
    if (l1 == Bolum27Content.boyutOptionC.label) b = Bolum27Content.boyutOptionC;

    // Yön
    ChoiceResult? y;
    final l2 = map['yon_label'];
    if (l2 == Bolum27Content.yonOptionA.label) y = Bolum27Content.yonOptionA;
    if (l2 == Bolum27Content.yonOptionB.label) y = Bolum27Content.yonOptionB;
    if (l2 == Bolum27Content.yonOptionC.label) y = Bolum27Content.yonOptionC;
    if (l2 == Bolum27Content.yonOptionD.label) y = Bolum27Content.yonOptionD;

    // Kilit
    ChoiceResult? k;
    final l3 = map['kilit_label'];
    if (l3 == Bolum27Content.kilitOptionA.label) k = Bolum27Content.kilitOptionA;
    if (l3 == Bolum27Content.kilitOptionB.label) k = Bolum27Content.kilitOptionB;
    if (l3 == Bolum27Content.kilitOptionC.label) k = Bolum27Content.kilitOptionC;
    if (l3 == Bolum27Content.kilitOptionD.label) k = Bolum27Content.kilitOptionD;

    // Dayanım
    ChoiceResult? d;
    final l4 = map['dayanim_label'];
    if (l4 == Bolum27Content.dayanimOptionA.label) d = Bolum27Content.dayanimOptionA;
    if (l4 == Bolum27Content.dayanimOptionB.label) d = Bolum27Content.dayanimOptionB;
    if (l4 == Bolum27Content.dayanimOptionC.label) d = Bolum27Content.dayanimOptionC;
    if (l4 == Bolum27Content.dayanimOptionD.label) d = Bolum27Content.dayanimOptionD;

    return Bolum27Model(
      boyut: b,
      yon: y,
      kilit: k,
      dayanim: d,
    );
  }
}