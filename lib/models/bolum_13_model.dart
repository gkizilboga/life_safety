import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum13Model {
  final bool areTicariKapiSame;
  final ChoiceResult? otoparkKapi;
  final ChoiceResult? kazanKapi;
  final ChoiceResult? asansorKapi;
  final ChoiceResult? jeneratorKapi;
  final ChoiceResult? elektrikKapi;
  final ChoiceResult? trafoKapi;
  final ChoiceResult? depoKapi;
  final ChoiceResult? copKapi;
  final ChoiceResult? ortakDuvar;
  final ChoiceResult? ticariKapiZemin;
  final ChoiceResult? ticariKapiNormal;
  final ChoiceResult? ticariKapiBodrum;
  final ChoiceResult? otoparkAlan;
  final ChoiceResult? kazanAlan;
  final ChoiceResult? siginakAlan;
  final ChoiceResult? depoBodrumAlan;
  final ChoiceResult? endustriyelMutfakKapi;

  Bolum13Model({
    this.areTicariKapiSame = true,
    this.otoparkKapi,
    this.kazanKapi,
    this.asansorKapi,
    this.jeneratorKapi,
    this.elektrikKapi,
    this.trafoKapi,
    this.depoKapi,
    this.copKapi,
    this.ortakDuvar,
    this.ticariKapiZemin,
    this.ticariKapiNormal,
    this.ticariKapiBodrum,
    this.otoparkAlan,
    this.kazanAlan,
    this.siginakAlan,
    this.depoBodrumAlan,
    this.endustriyelMutfakKapi,
  });

  Bolum13Model copyWith({
    bool? areTicariKapiSame,
    ChoiceResult? otoparkKapi,
    ChoiceResult? kazanKapi,
    ChoiceResult? asansorKapi,
    ChoiceResult? jeneratorKapi,
    ChoiceResult? elektrikKapi,
    ChoiceResult? trafoKapi,
    ChoiceResult? depoKapi,
    ChoiceResult? copKapi,
    ChoiceResult? ortakDuvar,
    ChoiceResult? ticariKapiZemin,
    ChoiceResult? ticariKapiNormal,
    ChoiceResult? ticariKapiBodrum,
    ChoiceResult? otoparkAlan,
    ChoiceResult? kazanAlan,
    ChoiceResult? siginakAlan,
    ChoiceResult? depoBodrumAlan,
    ChoiceResult? endustriyelMutfakKapi,
  }) {
    return Bolum13Model(
      areTicariKapiSame: areTicariKapiSame ?? this.areTicariKapiSame,
      otoparkKapi: otoparkKapi ?? this.otoparkKapi,
      kazanKapi: kazanKapi ?? this.kazanKapi,
      asansorKapi: asansorKapi ?? this.asansorKapi,
      jeneratorKapi: jeneratorKapi ?? this.jeneratorKapi,
      elektrikKapi: elektrikKapi ?? this.elektrikKapi,
      trafoKapi: trafoKapi ?? this.trafoKapi,
      depoKapi: depoKapi ?? this.depoKapi,
      copKapi: copKapi ?? this.copKapi,
      ortakDuvar: ortakDuvar ?? this.ortakDuvar,
      ticariKapiZemin: ticariKapiZemin ?? this.ticariKapiZemin,
      ticariKapiNormal: ticariKapiNormal ?? this.ticariKapiNormal,
      ticariKapiBodrum: ticariKapiBodrum ?? this.ticariKapiBodrum,
      otoparkAlan: otoparkAlan ?? this.otoparkAlan,
      kazanAlan: kazanAlan ?? this.kazanAlan,
      siginakAlan: siginakAlan ?? this.siginakAlan,
      depoBodrumAlan: depoBodrumAlan ?? this.depoBodrumAlan,
      endustriyelMutfakKapi:
          endustriyelMutfakKapi ?? this.endustriyelMutfakKapi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'areTicariKapiSame': areTicariKapiSame,
      'otoparkKapi_label': otoparkKapi?.label,
      'kazanKapi_label': kazanKapi?.label,
      'asansorKapi_label': asansorKapi?.label,
      'jeneratorKapi_label': jeneratorKapi?.label,
      'elektrikKapi_label': elektrikKapi?.label,
      'trafoKapi_label': trafoKapi?.label,
      'depoKapi_label': depoKapi?.label,
      'copKapi_label': copKapi?.label,
      'ortakDuvar_label': ortakDuvar?.label,
      'ticariKapiZemin_label': ticariKapiZemin?.label,
      'ticariKapiNormal_label': ticariKapiNormal?.label,
      'ticariKapiBodrum_label': ticariKapiBodrum?.label,
      'otoparkAlan_label': otoparkAlan?.label,
      'kazanAlan_label': kazanAlan?.label,
      'siginakAlan_label': siginakAlan?.label,
      'depoBodrumAlan_label': depoBodrumAlan?.label,
      'endustriyelMutfakKapi_label': endustriyelMutfakKapi?.label,
    };
  }

  factory Bolum13Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l, List<ChoiceResult> opts) {
      if (l == null) return null;
      try {
        return opts.firstWhere((e) => e.label == l);
      } catch (_) {
        return null;
      }
    }

    return Bolum13Model(
      otoparkKapi: find(map['otoparkKapi_label'], [
        Bolum13Content.otoparkOptionA,
        Bolum13Content.otoparkOptionB,
        Bolum13Content.otoparkOptionC,
        Bolum13Content.otoparkOptionD,
      ]),
      kazanKapi: find(map['kazanKapi_label'], [
        Bolum13Content.kazanOptionA,
        Bolum13Content.kazanOptionB,
        Bolum13Content.kazanOptionC,
        Bolum13Content.kazanOptionD,
      ]),
      asansorKapi: find(map['asansorKapi_label'], [
        Bolum13Content.asansorOptionA,
        Bolum13Content.asansorOptionB,
        Bolum13Content.asansorOptionC,
      ]),
      jeneratorKapi: find(map['jeneratorKapi_label'], [
        Bolum13Content.jeneratorOptionA,
        Bolum13Content.jeneratorOptionB,
        Bolum13Content.jeneratorOptionC,
      ]),
      elektrikKapi: find(map['elektrikKapi_label'], [
        Bolum13Content.elekOdasiOptionA,
        Bolum13Content.elekOdasiOptionB,
        Bolum13Content.elekOdasiOptionC,
      ]),
      trafoKapi: find(map['trafoKapi_label'], [
        Bolum13Content.trafoOptionA,
        Bolum13Content.trafoOptionB,
        Bolum13Content.trafoOptionC,
      ]),
      depoKapi: find(map['depoKapi_label'], [
        Bolum13Content.depoOptionA,
        Bolum13Content.depoOptionB,
        Bolum13Content.depoOptionC,
      ]),
      copKapi: find(map['copKapi_label'], [
        Bolum13Content.copOptionA,
        Bolum13Content.copOptionB,
        Bolum13Content.copOptionC,
      ]),
      ortakDuvar: find(map['ortakDuvar_label'], [
        Bolum13Content.ortakDuvarOptionA,
        Bolum13Content.ortakDuvarOptionB,
        Bolum13Content.ortakDuvarOptionC,
      ]),
      areTicariKapiSame: map['areTicariKapiSame'] ?? true,
      // Backward compatibility: map old ticariKapi to Zemin
      ticariKapiZemin: find(map['ticariKapiZemin_label'] ?? map['ticariKapi_label'], [
        Bolum13Content.ticariOptionA,
        Bolum13Content.ticariOptionB,
        Bolum13Content.ticariOptionC,
        Bolum13Content.ticariOptionD,
      ]),
      ticariKapiNormal: find(map['ticariKapiNormal_label'], [
        Bolum13Content.ticariOptionA,
        Bolum13Content.ticariOptionB,
        Bolum13Content.ticariOptionC,
        Bolum13Content.ticariOptionD,
      ]),
      ticariKapiBodrum: find(map['ticariKapiBodrum_label'], [
        Bolum13Content.ticariOptionA,
        Bolum13Content.ticariOptionB,
        Bolum13Content.ticariOptionC,
        Bolum13Content.ticariOptionD,
      ]),
      otoparkAlan: find(map['otoparkAlan_label'], [
        Bolum13Content.otoparkAlanOptionA,
        Bolum13Content.otoparkAlanOptionB,
        Bolum13Content.otoparkAlanOptionC,
      ]),
      kazanAlan: find(map['kazanAlan_label'], [
        Bolum13Content.kazanAlanOptionA,
        Bolum13Content.kazanAlanOptionB,
        Bolum13Content.kazanAlanOptionC,
      ]),
      siginakAlan: find(map['siginakAlan_label'], [
        Bolum13Content.siginakAlanOptionA,
        Bolum13Content.siginakAlanOptionB,
        Bolum13Content.siginakAlanOptionC,
      ]),
      depoBodrumAlan: find(map['depoBodrumAlan_label'], [
        Bolum13Content.depoBodrumAlanOptionA,
        Bolum13Content.depoBodrumAlanOptionB,
        Bolum13Content.depoBodrumAlanOptionC,
      ]),
      endustriyelMutfakKapi: find(map['endustriyelMutfakKapi_label'], [
        Bolum13Content.endustriyelMutfakOptionA,
        Bolum13Content.endustriyelMutfakOptionB,
        Bolum13Content.endustriyelMutfakOptionC,
        Bolum13Content.endustriyelMutfakOptionD,
      ]),
    );
  }
}
