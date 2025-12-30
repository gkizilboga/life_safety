import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum26Model {
  final ChoiceResult? varlik;
  final ChoiceResult? egim;
  final ChoiceResult? sahanlik;
  final ChoiceResult? otopark;

  ChoiceResult? get secim => varlik ?? egim ?? sahanlik ?? otopark;

  Bolum26Model({this.varlik, this.egim, this.sahanlik, this.otopark});

  Bolum26Model copyWith({ChoiceResult? varlik, ChoiceResult? egim, ChoiceResult? sahanlik, ChoiceResult? otopark}) {
    return Bolum26Model(
      varlik: varlik ?? this.varlik,
      egim: egim ?? this.egim,
      sahanlik: sahanlik ?? this.sahanlik,
      otopark: otopark ?? this.otopark,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'varlik_label': varlik?.label,
      'egim_label': egim?.label,
      'sahanlik_label': sahanlik?.label,
      'otopark_label': otopark?.label,
    };
  }

  factory Bolum26Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l) {
      if (l == null) return null;
      return [
        Bolum26Content.varlikOptionA, Bolum26Content.varlikOptionB, Bolum26Content.varlikOptionC,
        Bolum26Content.egimOptionA, Bolum26Content.egimOptionB, Bolum26Content.egimOptionC,
        Bolum26Content.sahanlikOptionA, Bolum26Content.sahanlikOptionB, Bolum26Content.sahanlikOptionC,
        Bolum26Content.otoparkOptionA, Bolum26Content.otoparkOptionB, Bolum26Content.otoparkOptionC,
      ].firstWhere((e) => e.label == l, orElse: () => Bolum26Content.varlikOptionC);
    }
    return Bolum26Model(
      varlik: find(map['varlik_label']),
      egim: find(map['egim_label']),
      sahanlik: find(map['sahanlik_label']),
      otopark: find(map['otopark_label']),
    );
  }
}