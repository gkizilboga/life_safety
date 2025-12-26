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
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      try {
        return options.firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum34Model(
      zemin: find(map['zemin_label'], [
        Bolum34Content.zeminOptionA, 
        Bolum34Content.zeminOptionB, 
        Bolum34Content.zeminOptionC
      ]),
      bodrum: find(map['bodrum_label'], [
        Bolum34Content.bodrumOptionA, 
        Bolum34Content.bodrumOptionB, 
        Bolum34Content.bodrumOptionC
      ]),
    );
  }
}