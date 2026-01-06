import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum25Model {
  final ChoiceResult? kapasite;
  final ChoiceResult? basamak;
  final ChoiceResult? basKurtarma;

  Bolum25Model({
    this.kapasite,
    this.basamak,
    this.basKurtarma,
  });

  Bolum25Model copyWith({
    ChoiceResult? kapasite,
    ChoiceResult? basamak,
    ChoiceResult? basKurtarma,
  }) {
    return Bolum25Model(
      kapasite: kapasite ?? this.kapasite,
      basamak: basamak ?? this.basamak,
      basKurtarma: basKurtarma ?? this.basKurtarma,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kapasite_label': kapasite?.label,
      'basamak_label': basamak?.label,
      'basKurtarma_label': basKurtarma?.label,
    };
  }

  factory Bolum25Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l, List<ChoiceResult> options) {
      if (l == null) return null;
      try {
        return options.firstWhere((e) => e.label == l);
      } catch (_) {
        return null;
      }
    }

    return Bolum25Model(
      kapasite: find(map['kapasite_label'], [
        Bolum25Content.kapasiteOptionA,
        Bolum25Content.kapasiteOptionB,
        Bolum25Content.kapasiteOptionC
      ]),
      basamak: find(map['basamak_label'], [
        Bolum25Content.basamakOptionA,
        Bolum25Content.basamakOptionB,
        Bolum25Content.basamakOptionC
      ]),
      basKurtarma: find(map['basKurtarma_label'], [
        Bolum25Content.basKurtarmaOptionA,
        Bolum25Content.basKurtarmaOptionB,
        Bolum25Content.basKurtarmaOptionC
      ]),
    );
  }
}