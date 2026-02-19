import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum27Model {
  final ChoiceResult? boyut;
  final List<ChoiceResult> yon;
  final List<ChoiceResult> kilit;
  final ChoiceResult? dayanim;

  Bolum27Model({
    this.boyut,
    this.yon = const [],
    this.kilit = const [],
    this.dayanim,
  });

  Bolum27Model copyWith({
    ChoiceResult? boyut,
    List<ChoiceResult>? yon,
    List<ChoiceResult>? kilit,
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
      'yon_labels': yon.map((e) => e.label).join(','),
      'kilit_labels': kilit.map((e) => e.label).join(','),
      'dayanim_label': dayanim?.label,
    };
  }

  factory Bolum27Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l, List<ChoiceResult> options) {
      if (l == null || l.isEmpty) return null;
      try {
        return options.firstWhere((e) => e.label == l);
      } catch (_) {
        return null;
      }
    }

    List<ChoiceResult> findList(String? labels, List<ChoiceResult> options) {
      if (labels == null || labels.isEmpty) return [];
      return labels
          .split(',')
          .map((l) => find(l, options))
          .whereType<ChoiceResult>()
          .toList();
    }

    return Bolum27Model(
      boyut: find(map['boyut_label'], [
        Bolum27Content.boyutOptionA,
        Bolum27Content.boyutOptionB,
        Bolum27Content.boyutOptionC,
      ]),
      yon: findList(map['yon_labels'] ?? map['yon_label'], [
        Bolum27Content.yonOptionA,
        Bolum27Content.yonOptionB,
        Bolum27Content.yonOptionC,
        Bolum27Content.yonOptionD,
        Bolum27Content.yonOptionE,
      ]),
      kilit: findList(map['kilit_labels'] ?? map['kilit_label'], [
        Bolum27Content.kilitOptionA,
        Bolum27Content.kilitOptionB,
        Bolum27Content.kilitOptionC,
        Bolum27Content.kilitOptionD,
        Bolum27Content.kilitOptionE,
      ]),
      dayanim: find(map['dayanim_label'], [
        Bolum27Content.dayanimOptionA,
        Bolum27Content.dayanimOptionB,
        Bolum27Content.dayanimOptionC,
        Bolum27Content.dayanimOptionD,
        Bolum27Content.dayanimOptionE,
      ]),
    );
  }
}
