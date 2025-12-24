import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum11Model {
  final ChoiceResult? mesafe;
  final ChoiceResult? engel;
  final ChoiceResult? zayifNokta;

  Bolum11Model({
    this.mesafe,
    this.engel,
    this.zayifNokta,
  });

  Bolum11Model copyWith({
    ChoiceResult? mesafe,
    ChoiceResult? engel,
    ChoiceResult? zayifNokta,
  }) {
    return Bolum11Model(
      mesafe: mesafe ?? this.mesafe,
      engel: engel ?? this.engel,
      zayifNokta: zayifNokta ?? this.zayifNokta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mesafe_label': mesafe?.label,
      'engel_label': engel?.label,
      'zayifNokta_label': zayifNokta?.label,
    };
  }

  factory Bolum11Model.fromMap(Map<String, dynamic> map) {
    // Mesafe
    ChoiceResult? m;
    final l1 = map['mesafe_label'];
    if (l1 == Bolum11Content.mesafeOptionA.label) m = Bolum11Content.mesafeOptionA;
    if (l1 == Bolum11Content.mesafeOptionB.label) m = Bolum11Content.mesafeOptionB;
    if (l1 == Bolum11Content.mesafeOptionC.label) m = Bolum11Content.mesafeOptionC;

    // Engel
    ChoiceResult? e;
    final l2 = map['engel_label'];
    if (l2 == Bolum11Content.engelOptionA.label) e = Bolum11Content.engelOptionA;
    if (l2 == Bolum11Content.engelOptionB.label) e = Bolum11Content.engelOptionB;
    if (l2 == Bolum11Content.engelOptionC.label) e = Bolum11Content.engelOptionC;

    // Zayıf Nokta
    ChoiceResult? z;
    final l3 = map['zayifNokta_label'];
    if (l3 == Bolum11Content.zayifNoktaOptionA.label) z = Bolum11Content.zayifNoktaOptionA;
    if (l3 == Bolum11Content.zayifNoktaOptionB.label) z = Bolum11Content.zayifNoktaOptionB;

    return Bolum11Model(mesafe: m, engel: e, zayifNokta: z);
  }
}