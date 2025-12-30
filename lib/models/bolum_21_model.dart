import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum21Model {
  final ChoiceResult? varlik;
  final ChoiceResult? malzeme;
  final ChoiceResult? kapi;
  final ChoiceResult? esya;

  Bolum21Model({
    this.varlik,
    this.malzeme,
    this.kapi,
    this.esya,
  });

  ChoiceResult? get secim => varlik ?? malzeme ?? kapi ?? esya;

  Bolum21Model copyWith({
    ChoiceResult? varlik,
    ChoiceResult? malzeme,
    ChoiceResult? kapi,
    ChoiceResult? esya,
  }) {
    return Bolum21Model(
      varlik: varlik ?? this.varlik,
      malzeme: malzeme ?? this.malzeme,
      kapi: kapi ?? this.kapi,
      esya: esya ?? this.esya,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'varlik_label': varlik?.label,
      'malzeme_label': malzeme?.label,
      'kapi_label': kapi?.label,
      'esya_label': esya?.label,
    };
  }

  factory Bolum21Model.fromMap(Map<String, dynamic> map) {
    // Varlık
    ChoiceResult? v;
    final l1 = map['varlik_label'];
    if (l1 == Bolum21Content.varlikOptionA.label) v = Bolum21Content.varlikOptionA;
    if (l1 == Bolum21Content.varlikOptionB.label) v = Bolum21Content.varlikOptionB;

    // Malzeme
    ChoiceResult? m;
    final l2 = map['malzeme_label'];
    if (l2 == Bolum21Content.malzemeOptionA.label) m = Bolum21Content.malzemeOptionA;
    if (l2 == Bolum21Content.malzemeOptionB.label) m = Bolum21Content.malzemeOptionB;
    if (l2 == Bolum21Content.malzemeOptionC.label) m = Bolum21Content.malzemeOptionC;

    // Kapı
    ChoiceResult? k;
    final l3 = map['kapi_label'];
    if (l3 == Bolum21Content.kapiOptionA.label) k = Bolum21Content.kapiOptionA;
    if (l3 == Bolum21Content.kapiOptionB.label) k = Bolum21Content.kapiOptionB;
    if (l3 == Bolum21Content.kapiOptionC.label) k = Bolum21Content.kapiOptionC;

    // Eşya
    ChoiceResult? e;
    final l4 = map['esya_label'];
    if (l4 == Bolum21Content.esyaOptionA.label) e = Bolum21Content.esyaOptionA;
    if (l4 == Bolum21Content.esyaOptionB.label) e = Bolum21Content.esyaOptionB;
    if (l4 == Bolum21Content.esyaOptionC.label) e = Bolum21Content.esyaOptionC;

    return Bolum21Model(
      varlik: v,
      malzeme: m,
      kapi: k,
      esya: e,
    );
  }
}