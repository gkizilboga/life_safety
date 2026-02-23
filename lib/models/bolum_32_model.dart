import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum32Model {
  final ChoiceResult? yapi;
  final ChoiceResult? yakit;
  final ChoiceResult? cevre;
  final ChoiceResult? egzoz;

  Bolum32Model({this.yapi, this.yakit, this.cevre, this.egzoz});

  Bolum32Model copyWith({
    ChoiceResult? yapi,
    ChoiceResult? yakit,
    ChoiceResult? cevre,
    ChoiceResult? egzoz,
  }) {
    return Bolum32Model(
      yapi: yapi ?? this.yapi,
      yakit: yakit ?? this.yakit,
      cevre: cevre ?? this.cevre,
      egzoz: egzoz ?? this.egzoz,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'yapi_label': yapi?.label,
      'yakit_label': yakit?.label,
      'cevre_label': cevre?.label,
      'egzoz_label': egzoz?.label,
    };
  }

  factory Bolum32Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      if (label == null) return null;
      try {
        return options.firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum32Model(
      yapi: find(map['yapi_label'], [
        Bolum32Content.yapiOptionA,
        Bolum32Content.yapiOptionB,
        Bolum32Content.yapiOptionC,
        Bolum32Content.yapiOptionD,
      ]),
      yakit: find(map['yakit_label'], [
        Bolum32Content.yakitOptionA,
        Bolum32Content.yakitOptionB,
        Bolum32Content.yakitOptionC,
      ]),
      cevre: find(map['cevre_label'], [
        Bolum32Content.cevreOptionA,
        Bolum32Content.cevreOptionB,
        Bolum32Content.cevreOptionC,
        Bolum32Content.cevreOptionD,
      ]),
      egzoz: find(map['egzoz_label'], [
        Bolum32Content.egzozOptionA,
        Bolum32Content.egzozOptionB,
        Bolum32Content.egzozOptionC,
      ]),
    );
  }
}
