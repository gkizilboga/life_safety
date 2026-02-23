import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum17Model {
  final ChoiceResult? kaplama;
  final ChoiceResult? iskelet;
  final ChoiceResult? bitisikDuvar; // Sadece bitişik nizam ise sorulur
  final ChoiceResult? isiklik;
  final String? isiklikMalzemesi; // "cam" veya "plastik"

  Bolum17Model({
    this.kaplama,
    this.iskelet,
    this.bitisikDuvar,
    this.isiklik,
    this.isiklikMalzemesi,
  });

  Bolum17Model copyWith({
    ChoiceResult? kaplama,
    ChoiceResult? iskelet,
    ChoiceResult? bitisikDuvar,
    ChoiceResult? isiklik,
    String? isiklikMalzemesi,
  }) {
    return Bolum17Model(
      kaplama: kaplama ?? this.kaplama,
      iskelet: iskelet ?? this.iskelet,
      bitisikDuvar: bitisikDuvar ?? this.bitisikDuvar,
      isiklik: isiklik ?? this.isiklik,
      isiklikMalzemesi: isiklikMalzemesi ?? this.isiklikMalzemesi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kaplama_label': kaplama?.label,
      'iskelet_label': iskelet?.label,
      'bitisikDuvar_label': bitisikDuvar?.label,
      'isiklik_label': isiklik?.label,
      'isiklikMalzemesi': isiklikMalzemesi,
    };
  }

  factory Bolum17Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? k;
    final l1 = map['kaplama_label'];
    if (l1 == Bolum17Content.kaplamaOptionA.label)
      k = Bolum17Content.kaplamaOptionA;
    else if (l1 == Bolum17Content.kaplamaOptionB.label)
      k = Bolum17Content.kaplamaOptionB;
    else if (l1 == Bolum17Content.kaplamaOptionC.label)
      k = Bolum17Content.kaplamaOptionC;
    else if (l1 == Bolum17Content.kaplamaOptionD.label)
      k = Bolum17Content.kaplamaOptionD;
    else if (l1 == Bolum17Content.kaplamaOptionE.label)
      k = Bolum17Content.kaplamaOptionE;
    else if (l1 == Bolum17Content.kaplamaOptionF.label)
      k = Bolum17Content.kaplamaOptionF;

    ChoiceResult? i;
    final l2 = map['iskelet_label'];
    if (l2 == Bolum17Content.iskeletOptionA.label)
      i = Bolum17Content.iskeletOptionA;
    else if (l2 == Bolum17Content.iskeletOptionB.label)
      i = Bolum17Content.iskeletOptionB;
    else if (l2 == Bolum17Content.iskeletOptionC.label)
      i = Bolum17Content.iskeletOptionC;

    ChoiceResult? b;
    final l3 = map['bitisikDuvar_label'];
    if (l3 == Bolum17Content.bitisikOptionA.label)
      b = Bolum17Content.bitisikOptionA;
    else if (l3 == Bolum17Content.bitisikOptionB.label)
      b = Bolum17Content.bitisikOptionB;
    else if (l3 == Bolum17Content.bitisikOptionC.label)
      b = Bolum17Content.bitisikOptionC;

    ChoiceResult? ls;
    final l4 = map['isiklik_label'];
    if (l4 == Bolum17Content.isiklikOptionA.label)
      ls = Bolum17Content.isiklikOptionA;
    else if (l4 == Bolum17Content.isiklikOptionB.label)
      ls = Bolum17Content.isiklikOptionB;
    else if (l4 == Bolum17Content.isiklikOptionC.label)
      ls = Bolum17Content.isiklikOptionC;

    return Bolum17Model(
      kaplama: k,
      iskelet: i,
      bitisikDuvar: b,
      isiklik: ls,
      isiklikMalzemesi: map['isiklikMalzemesi'],
    );
  }
}
