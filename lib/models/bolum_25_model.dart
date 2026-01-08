import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum25Model {
  final ChoiceResult? genislik;
  final ChoiceResult? basamak;
  final ChoiceResult? basKurtarma;

  Bolum25Model({
    this.genislik,
    this.basamak,
    this.basKurtarma,
  });

  Bolum25Model copyWith({
    ChoiceResult? genislik,
    ChoiceResult? basamak,
    ChoiceResult? basKurtarma,
  }) {
    return Bolum25Model(
      genislik: genislik ?? this.genislik,
      basamak: basamak ?? this.basamak,
      basKurtarma: basKurtarma ?? this.basKurtarma,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'genislik_label': genislik?.label,
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
      genislik: find(map['genislik_label'], [
        Bolum25Content.genislikOptionA,
        Bolum25Content.genislikOptionB,
        Bolum25Content.genislikOptionC
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