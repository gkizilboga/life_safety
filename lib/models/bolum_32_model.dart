import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum32Model {
  final ChoiceResult? yapi;
  final ChoiceResult? yakit;
  final ChoiceResult? cevre;
  final ChoiceResult? egzoz;

  Bolum32Model({
    this.yapi,
    this.yakit,
    this.cevre,
    this.egzoz,
  });

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
    // Yapı
    ChoiceResult? y;
    final l1 = map['yapi_label'];
    if (l1 == Bolum32Content.yapiOptionA.label) y = Bolum32Content.yapiOptionA;
    if (l1 == Bolum32Content.yapiOptionB.label) y = Bolum32Content.yapiOptionB;
    if (l1 == Bolum32Content.yapiOptionC.label) y = Bolum32Content.yapiOptionC;

    // Yakıt
    ChoiceResult? ya;
    final l2 = map['yakit_label'];
    if (l2 == Bolum32Content.yakitOptionA.label) ya = Bolum32Content.yakitOptionA;
    if (l2 == Bolum32Content.yakitOptionB.label) ya = Bolum32Content.yakitOptionB;

    // Çevre
    ChoiceResult? ce;
    final l3 = map['cevre_label'];
    if (l3 == Bolum32Content.cevreOptionA.label) ce = Bolum32Content.cevreOptionA;
    if (l3 == Bolum32Content.cevreOptionB.label) ce = Bolum32Content.cevreOptionB;
    if (l3 == Bolum32Content.cevreOptionC.label) ce = Bolum32Content.cevreOptionC;

    // Egzoz
    ChoiceResult? eg;
    final l4 = map['egzoz_label'];
    if (l4 == Bolum32Content.egzozOptionA.label) eg = Bolum32Content.egzozOptionA;
    if (l4 == Bolum32Content.egzozOptionB.label) eg = Bolum32Content.egzozOptionB;

    return Bolum32Model(
      yapi: y,
      yakit: ya,
      cevre: ce,
      egzoz: eg,
    );
  }
}