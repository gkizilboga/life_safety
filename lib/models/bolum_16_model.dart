import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum16Model {
  final ChoiceResult? mantolama;
  final bool? giydirmeBoslukYalitim;
  final ChoiceResult? sagirYuzey;
  final bool? sagirYuzeySprinkler;
  final ChoiceResult? bitisikNizam;

  final int? bariyerYan;
  final int? bariyerUst;
  final int? bariyerZemin;

  /// Cephe uzunluğu seçimi: A (≤75m), B (>75m), C (Bilmiyorum)
  final ChoiceResult? cepheUzunlugu;

  Bolum16Model({
    this.mantolama,
    this.giydirmeBoslukYalitim,
    this.sagirYuzey,
    this.sagirYuzeySprinkler,
    this.bitisikNizam,
    this.bariyerYan,
    this.bariyerUst,
    this.bariyerZemin,
    this.cepheUzunlugu,
  });

  Bolum16Model copyWith({
    ChoiceResult? mantolama,
    bool? giydirmeBoslukYalitim,
    ChoiceResult? sagirYuzey,
    bool? sagirYuzeySprinkler,
    ChoiceResult? bitisikNizam,
    int? bariyerYan,
    int? bariyerUst,
    int? bariyerZemin,
    ChoiceResult? cepheUzunlugu,
  }) {
    return Bolum16Model(
      mantolama: mantolama ?? this.mantolama,
      giydirmeBoslukYalitim:
          giydirmeBoslukYalitim ?? this.giydirmeBoslukYalitim,
      sagirYuzey: sagirYuzey ?? this.sagirYuzey,
      sagirYuzeySprinkler: sagirYuzeySprinkler ?? this.sagirYuzeySprinkler,
      bitisikNizam: bitisikNizam ?? this.bitisikNizam,
      bariyerYan: bariyerYan ?? this.bariyerYan,
      bariyerUst: bariyerUst ?? this.bariyerUst,
      bariyerZemin: bariyerZemin ?? this.bariyerZemin,
      cepheUzunlugu: cepheUzunlugu ?? this.cepheUzunlugu,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mantolama_label': mantolama?.label,
      'giydirmeBoslukYalitim': giydirmeBoslukYalitim,
      'sagirYuzey_label': sagirYuzey?.label,
      'sagirYuzeySprinkler': sagirYuzeySprinkler,
      'bitisikNizam_label': bitisikNizam?.label,
      'bariyerYan': bariyerYan,
      'bariyerUst': bariyerUst,
      'bariyerZemin': bariyerZemin,
      'cepheUzunlugu_label': cepheUzunlugu?.label,
    };
  }

  factory Bolum16Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l, List<ChoiceResult> options) {
      if (l == null) return null;
      try {
        return options.firstWhere((e) => e.label == l);
      } catch (_) {
        return null;
      }
    }

    return Bolum16Model(
      mantolama: find(map['mantolama_label'], [
        Bolum16Content.mantolamaOptionA,
        Bolum16Content.mantolamaOptionB,
        Bolum16Content.giydirmeOptionC,
        Bolum16Content.mantolamaOptionD,
        Bolum16Content.mantolamaOptionE,
      ]),
      giydirmeBoslukYalitim: map['giydirmeBoslukYalitim'],
      sagirYuzey: find(map['sagirYuzey_label'], [
        Bolum16Content.sagirYuzeyOptionA,
        Bolum16Content.sagirYuzeyOptionB,
        Bolum16Content.sagirYuzeyOptionC,
      ]),
      sagirYuzeySprinkler: map['sagirYuzeySprinkler'],
      bitisikNizam: find(map['bitisikNizam_label'], [
        Bolum16Content.bitisikOptionA,
        Bolum16Content.bitisikOptionB,
        Bolum16Content.bitisikOptionC,
        Bolum16Content.bitisikOptionD,
      ]),
      bariyerYan: map['bariyerYan'],
      bariyerUst: map['bariyerUst'],
      bariyerZemin: map['bariyerZemin'],
      cepheUzunlugu: find(map['cepheUzunlugu_label'], [
        Bolum16Content.cepheUzunluguOlumlu,
        Bolum16Content.cepheUzunluguKritik,
        Bolum16Content.cepheUzunluguBilinmiyor,
      ]),
    );
  }
}
