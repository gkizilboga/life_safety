import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum28Model {
  final ChoiceResult? mesafe;
  final ChoiceResult? dubleks;
  final ChoiceResult? alan;
  final ChoiceResult? cikis;
  final ChoiceResult?
  muafiyet; // Otomatik atlama (4 kat altı muafiyeti) için eklendi

  Bolum28Model({
    this.mesafe,
    this.dubleks,
    this.alan,
    this.cikis,
    this.muafiyet,
  });

  Bolum28Model copyWith({
    ChoiceResult? mesafe,
    ChoiceResult? dubleks,
    Object? alan = _sentinel,
    Object? cikis = _sentinel,
    Object? muafiyet = _sentinel,
  }) {
    return Bolum28Model(
      mesafe: mesafe ?? this.mesafe,
      dubleks: dubleks ?? this.dubleks,
      alan: alan == _sentinel ? this.alan : (alan as ChoiceResult?),
      cikis: cikis == _sentinel ? this.cikis : (cikis as ChoiceResult?),
      muafiyet: muafiyet == _sentinel
          ? this.muafiyet
          : (muafiyet as ChoiceResult?),
    );
  }

  static const _sentinel = Object();

  Map<String, dynamic> toMap() {
    return {
      'mesafe_label': mesafe?.label,
      'dubleks_label': dubleks?.label,
      'alan_label': alan?.label,
      'cikis_label': cikis?.label,
      'muafiyet_label': muafiyet?.label,
    };
  }

  factory Bolum28Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label) {
      if (label == null) return null;
      try {
        return [
          Bolum28Content.mesafeOptionA,
          Bolum28Content.mesafeOptionB,
          Bolum28Content.mesafeOptionC,
          Bolum28Content.dubleksOptionA,
          Bolum28Content.dubleksOptionB,
          Bolum28Content.alanOption1,
          Bolum28Content.alanOption2,
          Bolum28Content.cikisOptionA,
          Bolum28Content.cikisOptionB,
          Bolum28Content.muafiyetOption,
        ].firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum28Model(
      mesafe: find(map['mesafe_label']),
      dubleks: find(map['dubleks_label']),
      alan: find(map['alan_label']),
      cikis: find(map['cikis_label']),
      muafiyet: find(map['muafiyet_label']),
    );
  }
}
