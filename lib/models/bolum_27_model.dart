import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum27Model {
  final ChoiceResult? boyut;
  final ChoiceResult? yon;
  final ChoiceResult? kilit;
  final ChoiceResult? dayanim; // Sadece yangın merdiveni varsa dolu olur

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
    ChoiceResult? find(String? l, List<ChoiceResult> options) {
      if (l == null) return null;
      try {
        // Sadece eşleşen etiketi bul, bulamazsan null dön (rastgele şık seçme)
        return options.firstWhere((e) => e.label == l);
      } catch (_) {
        return null; 
      }
    }

    return Bolum27Model(
      boyut: find(map['boyut_label'], [Bolum27Content.boyutOptionA, Bolum27Content.boyutOptionB, Bolum27Content.boyutOptionC]),
      yon: find(map['yon_label'], [Bolum27Content.yonOptionA, Bolum27Content.yonOptionB, Bolum27Content.yonOptionC, Bolum27Content.yonOptionD]),
      kilit: find(map['kilit_label'], [Bolum27Content.kilitOptionA, Bolum27Content.kilitOptionB, Bolum27Content.kilitOptionC, Bolum27Content.kilitOptionD]),
      dayanim: find(map['dayanim_label'], [Bolum27Content.dayanimOptionA, Bolum27Content.dayanimOptionB, Bolum27Content.dayanimOptionC, Bolum27Content.dayanimOptionD]),
    );
  }
}