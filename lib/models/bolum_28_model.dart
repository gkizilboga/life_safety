import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum28Model {
  final bool isExempt; // Muafiyet durumu (Adım-1 sonucu)
  final ChoiceResult? resDaireMesafe;
  final ChoiceResult? resDubleksTip;
  final ChoiceResult? resDubleksAlan70; // Alt Soru 1
  final ChoiceResult? resDubleksCikis; // Alt Soru 2

  Bolum28Model({
    this.isExempt = false,
    this.resDaireMesafe,
    this.resDubleksTip,
    this.resDubleksAlan70,
    this.resDubleksCikis,
  });

  Bolum28Model copyWith({
    bool? isExempt,
    ChoiceResult? resDaireMesafe,
    ChoiceResult? resDubleksTip,
    ChoiceResult? resDubleksAlan70,
    ChoiceResult? resDubleksCikis,
  }) {
    return Bolum28Model(
      isExempt: isExempt ?? this.isExempt,
      resDaireMesafe: resDaireMesafe ?? this.resDaireMesafe,
      resDubleksTip: resDubleksTip ?? this.resDubleksTip,
      resDubleksAlan70: resDubleksAlan70 ?? this.resDubleksAlan70,
      resDubleksCikis: resDubleksCikis ?? this.resDubleksCikis,
    );
  }
}