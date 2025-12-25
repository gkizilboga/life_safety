import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum15Model {
  final ChoiceResult? kaplama;
  final ChoiceResult? yalitim;
  final bool? yalitimSapVar; 
  final ChoiceResult? tavan;
  final String? tavanMalzemesi; 
  final ChoiceResult? tesisat;

  Bolum15Model({
    this.kaplama,
    this.yalitim,
    this.yalitimSapVar,
    this.tavan,
    this.tavanMalzemesi,
    this.tesisat,
  });

  Bolum15Model copyWith({
    ChoiceResult? kaplama,
    ChoiceResult? yalitim,
    bool? yalitimSapVar,
    ChoiceResult? tavan,
    String? tavanMalzemesi,
    ChoiceResult? tesisat,
  }) {
    return Bolum15Model(
      kaplama: kaplama ?? this.kaplama,
      yalitim: yalitim ?? this.yalitim,
      yalitimSapVar: yalitimSapVar ?? this.yalitimSapVar,
      tavan: tavan ?? this.tavan,
      tavanMalzemesi: tavanMalzemesi ?? this.tavanMalzemesi,
      tesisat: tesisat ?? this.tesisat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kaplama_label': kaplama?.label,
      'yalitim_label': yalitim?.label,
      'yalitimSapVar': yalitimSapVar,
      'tavan_label': tavan?.label,
      'tavanMalzemesi': tavanMalzemesi,
      'tesisat_label': tesisat?.label,
    };
  }

  factory Bolum15Model.fromMap(Map<String, dynamic> map) {
    // Kaplama
    ChoiceResult? k;
    final l1 = map['kaplama_label'];
    if (l1 == Bolum15Content.kaplamaOptionA.label) k = Bolum15Content.kaplamaOptionA;
    if (l1 == Bolum15Content.kaplamaOptionB.label) k = Bolum15Content.kaplamaOptionB;
    if (l1 == Bolum15Content.kaplamaOptionC.label) k = Bolum15Content.kaplamaOptionC;

    // Yalıtım
    ChoiceResult? y;
    final l2 = map['yalitim_label'];
    if (l2 == Bolum15Content.yalitimOptionA.label) y = Bolum15Content.yalitimOptionA;
    if (l2 == Bolum15Content.yalitimOptionB.label) y = Bolum15Content.yalitimOptionB;
    if (l2 == Bolum15Content.yalitimOptionC.label) y = Bolum15Content.yalitimOptionC;

    // Tavan
    ChoiceResult? t;
    final l3 = map['tavan_label'];
    if (l3 == Bolum15Content.tavanOptionA.label) t = Bolum15Content.tavanOptionA;
    if (l3 == Bolum15Content.tavanOptionB.label) t = Bolum15Content.tavanOptionB;
    if (l3 == Bolum15Content.tavanOptionC.label) t = Bolum15Content.tavanOptionC;

    // Tesisat
    ChoiceResult? ts;
    final l4 = map['tesisat_label'];
    if (l4 == Bolum15Content.tesisatOptionA.label) ts = Bolum15Content.tesisatOptionA;
    if (l4 == Bolum15Content.tesisatOptionB.label) ts = Bolum15Content.tesisatOptionB;
    if (l4 == Bolum15Content.tesisatOptionC.label) ts = Bolum15Content.tesisatOptionC;

    return Bolum15Model(
      kaplama: k,
      yalitim: y,
      yalitimSapVar: map['yalitimSapVar'],
      tavan: t,
      tavanMalzemesi: map['tavanMalzemesi'],
      tesisat: ts,
    );
  }
}