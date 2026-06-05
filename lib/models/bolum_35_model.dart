import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum35Model {
  final ChoiceResult? tekYon;
  final ChoiceResult? ciftYon;
  final ChoiceResult? cikmaz;
  final ChoiceResult? cikmazMesafe;
  final double? manuelMesafe;
  final double? cikmazManuelMesafe;

  Bolum35Model({
    this.tekYon,
    this.ciftYon,
    this.cikmaz,
    this.cikmazMesafe,
    this.manuelMesafe,
    this.cikmazManuelMesafe,
  });

  Bolum35Model copyWith({
    Object? tekYon = _sentinel,
    Object? ciftYon = _sentinel,
    Object? cikmaz = _sentinel,
    Object? cikmazMesafe = _sentinel,
    Object? manuelMesafe = _sentinel,
    Object? cikmazManuelMesafe = _sentinel,
  }) {
    return Bolum35Model(
      tekYon: tekYon == _sentinel ? this.tekYon : (tekYon as ChoiceResult?),
      ciftYon: ciftYon == _sentinel ? this.ciftYon : (ciftYon as ChoiceResult?),
      cikmaz: cikmaz == _sentinel ? this.cikmaz : (cikmaz as ChoiceResult?),
      cikmazMesafe: cikmazMesafe == _sentinel
          ? this.cikmazMesafe
          : (cikmazMesafe as ChoiceResult?),
      manuelMesafe: manuelMesafe == _sentinel
          ? this.manuelMesafe
          : (manuelMesafe as double?),
      cikmazManuelMesafe: cikmazManuelMesafe == _sentinel
          ? this.cikmazManuelMesafe
          : (cikmazManuelMesafe as double?),
    );
  }

  static const _sentinel = Object();

  Map<String, dynamic> toMap() {
    return {
      'tekYon_label': tekYon?.label,
      'ciftYon_label': ciftYon?.label,
      'cikmaz_label': cikmaz?.label,
      'cikmazMesafe_label': cikmazMesafe?.label,
      'manuelMesafe': manuelMesafe,
      'cikmazManuelMesafe': cikmazManuelMesafe,
    };
  }

  factory Bolum35Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? resolveChoice(String? label, List<ChoiceResult> options) {
      if (label == null) return null;
      try {
        return options.firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum35Model(
      tekYon: resolveChoice(map['tekYon_label'], [
        Bolum35Content.tekYonOptionA,
        Bolum35Content.tekYonOptionB,
        Bolum35Content.tekYonOptionC,
        Bolum35Content.tekYonOptionD,
      ]),
      ciftYon: resolveChoice(map['ciftYon_label'], [
        Bolum35Content.ciftYonOptionA,
        Bolum35Content.ciftYonOptionB,
        Bolum35Content.ciftYonOptionC,
        Bolum35Content.ciftYonOptionD,
      ]),
      cikmaz: resolveChoice(map['cikmaz_label'], [
        Bolum35Content.cikmazOptionA,
        Bolum35Content.cikmazOptionB,
        Bolum35Content.cikmazOptionC,
      ]),
      cikmazMesafe: resolveChoice(map['cikmazMesafe_label'], [
        Bolum35Content.cikmazMesafeOptionA,
        Bolum35Content.cikmazMesafeOptionB,
        Bolum35Content.cikmazMesafeOptionC,
        Bolum35Content.cikmazMesafeOptionD,
      ]),
      manuelMesafe: (map['manuelMesafe'] as num?)?.toDouble(),
      cikmazManuelMesafe: (map['cikmazManuelMesafe'] as num?)?.toDouble(),
    );
  }
}
