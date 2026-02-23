import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum15Model {
  final ChoiceResult? kaplama;
  final ChoiceResult? yalitim;
  final ChoiceResult? yalitimSap;
  final ChoiceResult? tavan;
  final ChoiceResult? tavanMalzeme;
  final ChoiceResult? tesisat;

  Bolum15Model({
    this.kaplama,
    this.yalitim,
    this.yalitimSap,
    this.tavan,
    this.tavanMalzeme,
    this.tesisat,
  });

  Bolum15Model copyWith({
    ChoiceResult? kaplama,
    ChoiceResult? yalitim,
    Object? yalitimSap = _sentinel,
    ChoiceResult? tavan,
    Object? tavanMalzeme = _sentinel,
    ChoiceResult? tesisat,
  }) {
    return Bolum15Model(
      kaplama: kaplama ?? this.kaplama,
      yalitim: yalitim ?? this.yalitim,
      yalitimSap: yalitimSap == _sentinel
          ? this.yalitimSap
          : (yalitimSap as ChoiceResult?),
      tavan: tavan ?? this.tavan,
      tavanMalzeme: tavanMalzeme == _sentinel
          ? this.tavanMalzeme
          : (tavanMalzeme as ChoiceResult?),
      tesisat: tesisat ?? this.tesisat,
    );
  }

  static const _sentinel = Object();

  Map<String, dynamic> toMap() {
    return {
      'kaplama': kaplama?.label,
      'yalitim': yalitim?.label,
      'yalitimSap': yalitimSap?.label,
      'tavan': tavan?.label,
      'tavanMalzeme': tavanMalzeme?.label,
      'tesisat': tesisat?.label,
    };
  }

  factory Bolum15Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label) {
      if (label == null) return null;
      try {
        return [
          Bolum15Content.kaplamaOptionA,
          Bolum15Content.kaplamaOptionB,
          Bolum15Content.kaplamaOptionC,
          Bolum15Content.kaplamaOptionD,
          Bolum15Content.yalitimOptionA,
          Bolum15Content.yalitimOptionB,
          Bolum15Content.yalitimOptionC,
          Bolum15Content.yalitimSapOptionA,
          Bolum15Content.yalitimSapOptionB,
          Bolum15Content.yalitimSapOptionC,
          Bolum15Content.tavanOptionA,
          Bolum15Content.tavanOptionB,
          Bolum15Content.tavanOptionC,
          Bolum15Content.tavanOptionD,
          Bolum15Content.tavanMalzemeOptionA,
          Bolum15Content.tavanMalzemeOptionB,
          Bolum15Content.tavanMalzemeOptionC,
          Bolum15Content.tesisatOptionA,
          Bolum15Content.tesisatOptionB,
          Bolum15Content.tesisatOptionC,
          Bolum15Content.tesisatOptionD,
        ].firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum15Model(
      kaplama: find(map['kaplama']),
      yalitim: find(map['yalitim']),
      yalitimSap: find(map['yalitimSap']),
      tavan: find(map['tavan']),
      tavanMalzeme: find(map['tavanMalzeme']),
      tesisat: find(map['tesisat']),
    );
  }
}
