import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum16Model {
  final ChoiceResult? mantolama;
  final ChoiceResult? giydirmeCepheMalzemesi;
  final ChoiceResult? giydirmeYalitimMalzemesi;
  final ChoiceResult? sagirYuzey;
  final int? sagirYuzeySprinkler;
  final ChoiceResult? bitisikNizam;

  final int? bariyerYan;
  final int? bariyerUst;
  final int? bariyerZemin;

  /// Cephe uzunluğu seçimi: A (≤75m), B (>75m), C (Bilmiyorum)
  final ChoiceResult? cepheUzunlugu;

  Bolum16Model({
    this.mantolama,
    this.giydirmeCepheMalzemesi,
    this.giydirmeYalitimMalzemesi,
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
    ChoiceResult? giydirmeCepheMalzemesi,
    ChoiceResult? giydirmeYalitimMalzemesi,
    ChoiceResult? sagirYuzey,
    int? sagirYuzeySprinkler,
    ChoiceResult? bitisikNizam,
    int? bariyerYan,
    int? bariyerUst,
    int? bariyerZemin,
    ChoiceResult? cepheUzunlugu,
  }) {
    return Bolum16Model(
      mantolama: mantolama ?? this.mantolama,
      giydirmeCepheMalzemesi:
          giydirmeCepheMalzemesi ?? this.giydirmeCepheMalzemesi,
      giydirmeYalitimMalzemesi:
          giydirmeYalitimMalzemesi ?? this.giydirmeYalitimMalzemesi,
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
      'giydirmeCepheMalzemesi_label': giydirmeCepheMalzemesi?.label,
      'giydirmeYalitimMalzemesi_label': giydirmeYalitimMalzemesi?.label,
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
      giydirmeCepheMalzemesi: find(map['giydirmeCepheMalzemesi_label'], [
        Bolum16Content.giydirmeCepheA,
        Bolum16Content.giydirmeCepheB,
        Bolum16Content.giydirmeCepheC,
      ]),
      giydirmeYalitimMalzemesi: find(map['giydirmeYalitimMalzemesi_label'], [
        Bolum16Content.giydirmeYalitimA,
        Bolum16Content.giydirmeYalitimB,
        Bolum16Content.giydirmeYalitimC,
      ]),
      sagirYuzey: find(map['sagirYuzey_label'], [
        Bolum16Content.sagirYuzeyOptionA,
        Bolum16Content.sagirYuzeyOptionB,
        Bolum16Content.sagirYuzeyOptionC,
      ]),
      sagirYuzeySprinkler: map['sagirYuzeySprinkler'] is bool
          ? ((map['sagirYuzeySprinkler'] as bool) ? 1 : 0)
          : map['sagirYuzeySprinkler'],
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
