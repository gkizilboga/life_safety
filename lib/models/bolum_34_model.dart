import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum34Model {
  final ChoiceResult? zemin;
  final ChoiceResult? bodrum;

  Bolum34Model({
    this.zemin,
    this.bodrum,
  });

  Bolum34Model copyWith({
    ChoiceResult? zemin,
    ChoiceResult? bodrum,
  }) {
    return Bolum34Model(
      zemin: zemin ?? this.zemin,
      bodrum: bodrum ?? this.bodrum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zemin_label': zemin?.label,
      'bodrum_label': bodrum?.label,
    };
  }

  factory Bolum34Model.fromMap(Map<String, dynamic> map) {
    // Zemin
    ChoiceResult? z;
    final l1 = map['zemin_label'];
    if (l1 == Bolum34Content.zeminOptionA.label) z = Bolum34Content.zeminOptionA;
    if (l1 == Bolum34Content.zeminOptionB.label) z = Bolum34Content.zeminOptionB;
    if (l1 == Bolum34Content.zeminOptionC.label) z = Bolum34Content.zeminOptionC;

    // Bodrum
    ChoiceResult? b;
    final l2 = map['bodrum_label'];
    if (l2 == Bolum34Content.bodrumOptionA.label) b = Bolum34Content.bodrumOptionA;
    if (l2 == Bolum34Content.bodrumOptionB.label) b = Bolum34Content.bodrumOptionB;
    if (l2 == Bolum34Content.bodrumOptionC.label) b = Bolum34Content.bodrumOptionC;

    return Bolum34Model(
      zemin: z,
      bodrum: b,
    );
  }
}