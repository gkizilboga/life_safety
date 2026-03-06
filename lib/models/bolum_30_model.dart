import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum30Model {
  final ChoiceResult? konum;
  final ChoiceResult? kapasiteChoice;
  final ChoiceResult? kapi;
  final ChoiceResult? hava;
  final ChoiceResult? yakit;
  final ChoiceResult? drenaj;
  final ChoiceResult? tup;

  Bolum30Model({
    this.konum,
    this.kapasiteChoice,
    this.kapi,
    this.hava,
    this.yakit,
    this.drenaj,
    this.tup,
  });

  Bolum30Model copyWith({
    ChoiceResult? konum,
    ChoiceResult? kapasiteChoice,
    ChoiceResult? kapi,
    ChoiceResult? hava,
    ChoiceResult? yakit,
    ChoiceResult? drenaj,
    ChoiceResult? tup,
  }) {
    return Bolum30Model(
      konum: konum ?? this.konum,
      kapasiteChoice: kapasiteChoice ?? this.kapasiteChoice,
      kapi: kapi ?? this.kapi,
      hava: hava ?? this.hava,
      yakit: yakit ?? this.yakit,
      drenaj: drenaj ?? this.drenaj,
      tup: tup ?? this.tup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'konum_label': konum?.label,
      'kapasiteChoice_label': kapasiteChoice?.label,
      'kapi_label': kapi?.label,
      'hava_label': hava?.label,
      'yakit_label': yakit?.label,
      'drenaj_label': drenaj?.label,
      'tup_label': tup?.label,
    };
  }

  factory Bolum30Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      if (label == null) return null;
      try {
        return options.firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum30Model(
      konum: find(map['konum_label'], [
        Bolum30Content.konumOptionA,
        Bolum30Content.konumOptionB,
        Bolum30Content.konumOptionC,
        Bolum30Content.konumOptionD,
      ]),
      kapasiteChoice: find(map['kapasiteChoice_label'], [
        Bolum30Content.kapasiteAlt,
        Bolum30Content.kapasiteUst,
        Bolum30Content.kapasiteBilinmiyorOption,
      ]),
      kapi: find(map['kapi_label'], [
        Bolum30Content.kapiOptionA,
        Bolum30Content.kapiOptionB,
        Bolum30Content.kapiOptionC,
      ]),
      hava: find(map['hava_label'], [
        Bolum30Content.havaOptionA,
        Bolum30Content.havaOptionB,
        Bolum30Content.havaOptionC,
      ]),
      yakit: find(map['yakit_label'], [
        Bolum30Content.yakitOptionA,
        Bolum30Content.yakitOptionB,
        Bolum30Content.yakitOptionC,
      ]),
      drenaj: find(map['drenaj_label'], [
        Bolum30Content.drenajOptionA,
        Bolum30Content.drenajOptionB,
        Bolum30Content.drenajOptionC,
      ]),
      tup: find(map['tup_label'], [
        Bolum30Content.tupOptionA,
        Bolum30Content.tupOptionB,
        Bolum30Content.tupOptionC,
        Bolum30Content.tupOptionD,
      ]),
    );
  }
}
