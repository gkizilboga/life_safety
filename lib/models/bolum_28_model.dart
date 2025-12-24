import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum28Model {
  final ChoiceResult? mesafe;
  final ChoiceResult? dubleks;
  final ChoiceResult? alan;
  final ChoiceResult? cikis;

  Bolum28Model({
    this.mesafe,
    this.dubleks,
    this.alan,
    this.cikis,
  });

  Bolum28Model copyWith({
    ChoiceResult? mesafe,
    ChoiceResult? dubleks,
    ChoiceResult? alan,
    ChoiceResult? cikis,
  }) {
    return Bolum28Model(
      mesafe: mesafe ?? this.mesafe,
      dubleks: dubleks ?? this.dubleks,
      alan: alan ?? this.alan,
      cikis: cikis ?? this.cikis,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mesafe_label': mesafe?.label,
      'dubleks_label': dubleks?.label,
      'alan_label': alan?.label,
      'cikis_label': cikis?.label,
    };
  }

  factory Bolum28Model.fromMap(Map<String, dynamic> map) {
    // Mesafe
    ChoiceResult? m;
    final l1 = map['mesafe_label'];
    if (l1 == Bolum28Content.mesafeOptionA.label) m = Bolum28Content.mesafeOptionA;
    if (l1 == Bolum28Content.mesafeOptionB.label) m = Bolum28Content.mesafeOptionB;
    if (l1 == Bolum28Content.mesafeOptionC.label) m = Bolum28Content.mesafeOptionC;

    // Dubleks
    ChoiceResult? d;
    final l2 = map['dubleks_label'];
    if (l2 == Bolum28Content.dubleksOptionA.label) d = Bolum28Content.dubleksOptionA;
    if (l2 == Bolum28Content.dubleksOptionB.label) d = Bolum28Content.dubleksOptionB;

    // Alan
    ChoiceResult? a;
    final l3 = map['alan_label'];
    if (l3 == Bolum28Content.alanOption1.label) a = Bolum28Content.alanOption1;
    if (l3 == Bolum28Content.alanOption2.label) a = Bolum28Content.alanOption2;

    // Çıkış
    ChoiceResult? c;
    final l4 = map['cikis_label'];
    if (l4 == Bolum28Content.cikisOptionA.label) c = Bolum28Content.cikisOptionA;
    if (l4 == Bolum28Content.cikisOptionB.label) c = Bolum28Content.cikisOptionB;

    return Bolum28Model(
      mesafe: m,
      dubleks: d,
      alan: a,
      cikis: c,
    );
  }
}