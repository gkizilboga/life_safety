import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum26Model {
  final ChoiceResult? varlik;
  final ChoiceResult? egim;
  final ChoiceResult? sahanlik;
  final ChoiceResult? otopark;

  Bolum26Model({
    this.varlik,
    this.egim,
    this.sahanlik,
    this.otopark,
  });

  Bolum26Model copyWith({
    ChoiceResult? varlik,
    ChoiceResult? egim,
    ChoiceResult? sahanlik,
    ChoiceResult? otopark,
  }) {
    return Bolum26Model(
      varlik: varlik ?? this.varlik,
      egim: egim ?? this.egim,
      sahanlik: sahanlik ?? this.sahanlik,
      otopark: otopark ?? this.otopark,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'varlik_label': varlik?.label,
      'egim_label': egim?.label,
      'sahanlik_label': sahanlik?.label,
      'otopark_label': otopark?.label,
    };
  }

  factory Bolum26Model.fromMap(Map<String, dynamic> map) {
    // Varlık
    ChoiceResult? v;
    final l1 = map['varlik_label'];
    if (l1 == Bolum26Content.varlikOptionA.label) v = Bolum26Content.varlikOptionA;
    if (l1 == Bolum26Content.varlikOptionB.label) v = Bolum26Content.varlikOptionB;

    // Eğim
    ChoiceResult? e;
    final l2 = map['egim_label'];
    if (l2 == Bolum26Content.egimOptionA.label) e = Bolum26Content.egimOptionA;
    if (l2 == Bolum26Content.egimOptionB.label) e = Bolum26Content.egimOptionB;

    // Sahanlık
    ChoiceResult? s;
    final l3 = map['sahanlik_label'];
    if (l3 == Bolum26Content.sahanlikOptionA.label) s = Bolum26Content.sahanlikOptionA;
    if (l3 == Bolum26Content.sahanlikOptionB.label) s = Bolum26Content.sahanlikOptionB;

    // Otopark
    ChoiceResult? o;
    final l4 = map['otopark_label'];
    if (l4 == Bolum26Content.otoparkOptionA.label) o = Bolum26Content.otoparkOptionA;
    if (l4 == Bolum26Content.otoparkOptionB.label) o = Bolum26Content.otoparkOptionB;

    return Bolum26Model(
      varlik: v,
      egim: e,
      sahanlik: s,
      otopark: o,
    );
  }
}