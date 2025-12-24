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
    // Kapasite
    ChoiceResult? k;
    final l1 = map['kapasite_label'];
    if (l1 == Bolum25Content.kapasiteOptionA.label) k = Bolum25Content.kapasiteOptionA;
    if (l1 == Bolum25Content.kapasiteOptionB.label) k = Bolum25Content.kapasiteOptionB;

    // Basamak
    ChoiceResult? b;
    final l2 = map['basamak_label'];
    if (l2 == Bolum25Content.basamakOptionA.label) b = Bolum25Content.basamakOptionA;
    if (l2 == Bolum25Content.basamakOptionB.label) b = Bolum25Content.basamakOptionB;

    // Baş Kurtarma
    ChoiceResult? bk;
    final l3 = map['basKurtarma_label'];
    if (l3 == Bolum25Content.basKurtarmaOptionA.label) bk = Bolum25Content.basKurtarmaOptionA;
    if (l3 == Bolum25Content.basKurtarmaOptionB.label) bk = Bolum25Content.basKurtarmaOptionB;

    return Bolum25Model(
      kapasite: k,
      basamak: b,
      basKurtarma: bk,
    );
  }
}