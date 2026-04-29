import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum34Model {
  final bool areTicariCikisSame;
  final ChoiceResult? zemin;
  final ChoiceResult? bodrum;
  final ChoiceResult? normal;
  final ChoiceResult? mutfakBacasi;

  Bolum34Model({
    this.areTicariCikisSame = true,
    this.zemin,
    this.bodrum,
    this.normal,
    this.mutfakBacasi,
  });

  Bolum34Model copyWith({
    bool? areTicariCikisSame,
    ChoiceResult? zemin,
    ChoiceResult? bodrum,
    ChoiceResult? normal,
    ChoiceResult? mutfakBacasi,
  }) {
    return Bolum34Model(
      areTicariCikisSame: areTicariCikisSame ?? this.areTicariCikisSame,
      zemin: zemin ?? this.zemin,
      bodrum: bodrum ?? this.bodrum,
      normal: normal ?? this.normal,
      mutfakBacasi: mutfakBacasi ?? this.mutfakBacasi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'areTicariCikisSame': areTicariCikisSame,
      'zemin_label': zemin?.label,
      'bodrum_label': bodrum?.label,
      'normal_label': normal?.label,
      'mutfak_bacasi_label': mutfakBacasi?.label,
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
      areTicariCikisSame: map['areTicariCikisSame'] ?? true,
      zemin: find(map['zemin_label'], [
        Bolum34Content.zeminOptionA,
        Bolum34Content.zeminOptionB,
        Bolum34Content.zeminOptionC,
      ]),
      bodrum: find(map['bodrum_label'], [
        Bolum34Content.bodrumOptionA,
        Bolum34Content.bodrumOptionB,
        Bolum34Content.bodrumOptionC,
      ]),
      normal: find(map['normal_label'], [
        Bolum34Content.normalOptionA,
        Bolum34Content.normalOptionB,
        Bolum34Content.normalOptionC,
      ]),
      mutfakBacasi: find(map['mutfak_bacasi_label'], [
        Bolum34Content.mutfakBacasiOptionA,
        Bolum34Content.mutfakBacasiOptionB,
        Bolum34Content.mutfakBacasiOptionC,
      ]),
    );
  }
}
