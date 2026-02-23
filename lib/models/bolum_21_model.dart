import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum21Model {
  final ChoiceResult? varlik;
  final ChoiceResult? malzeme;
  final ChoiceResult? kapi;
  final ChoiceResult? esya;

  Bolum21Model({this.varlik, this.malzeme, this.kapi, this.esya});

  Bolum21Model copyWith({
    ChoiceResult? varlik,
    ChoiceResult? malzeme,
    ChoiceResult? kapi,
    ChoiceResult? esya,
  }) {
    return Bolum21Model(
      varlik: varlik ?? this.varlik,
      malzeme: malzeme ?? this.malzeme,
      kapi: kapi ?? this.kapi,
      esya: esya ?? this.esya,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'varlik': varlik?.label,
      'malzeme': malzeme?.label,
      'kapi': kapi?.label,
      'esya': esya?.label,
    };
  }

  factory Bolum21Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label) {
      if (label == null) return null;
      return [
        Bolum21Content.varlikOptionA,
        Bolum21Content.varlikOptionB,
        Bolum21Content.malzemeOptionA,
        Bolum21Content.malzemeOptionB,
        Bolum21Content.malzemeOptionC,
        Bolum21Content.kapiOptionA,
        Bolum21Content.kapiOptionB,
        Bolum21Content.kapiOptionC,
        Bolum21Content.esyaOptionA,
        Bolum21Content.esyaOptionB,
        Bolum21Content.esyaOptionC,
      ].firstWhere(
        (e) => e.label == label,
        orElse: () => Bolum21Content.varlikOptionB,
      );
    }

    return Bolum21Model(
      varlik: find(map['varlik']),
      malzeme: find(map['malzeme']),
      kapi: find(map['kapi']),
      esya: find(map['esya']),
    );
  }
}
