import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum34Model {
  final ChoiceResult? mutfakBacasi;

  Bolum34Model({
    this.mutfakBacasi,
  });

  Bolum34Model copyWith({
    ChoiceResult? mutfakBacasi,
  }) {
    return Bolum34Model(
      mutfakBacasi: mutfakBacasi ?? this.mutfakBacasi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mutfak_bacasi_label': mutfakBacasi?.label,
    };
  }

  factory Bolum34Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      if (label == null) return null;
      try {
        return options.firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum34Model(
      mutfakBacasi: find(map['mutfak_bacasi_label'], [
        Bolum34Content.mutfakBacasiOptionA,
        Bolum34Content.mutfakBacasiOptionB,
        Bolum34Content.mutfakBacasiOptionC,
      ]),
    );
  }
}
