import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum29Model {
  final ChoiceResult? otopark;
  final ChoiceResult? kazan;
  final ChoiceResult? cati;
  final ChoiceResult? asansor;
  final ChoiceResult? jenerator;
  final ChoiceResult? pano;
  final ChoiceResult? trafo;
  final ChoiceResult? depo;
  final ChoiceResult? cop;

  Bolum29Model({
    this.otopark,
    this.kazan,
    this.cati,
    this.asansor,
    this.jenerator,
    this.pano,
    this.trafo,
    this.depo,
    this.cop,
  });

  Bolum29Model copyWith({
    ChoiceResult? otopark,
    ChoiceResult? kazan,
    ChoiceResult? cati,
    ChoiceResult? asansor,
    ChoiceResult? jenerator,
    ChoiceResult? pano,
    ChoiceResult? trafo,
    ChoiceResult? depo,
    ChoiceResult? cop,
  }) {
    return Bolum29Model(
      otopark: otopark ?? this.otopark,
      kazan: kazan ?? this.kazan,
      cati: cati ?? this.cati,
      asansor: asansor ?? this.asansor,
      jenerator: jenerator ?? this.jenerator,
      pano: pano ?? this.pano,
      trafo: trafo ?? this.trafo,
      depo: depo ?? this.depo,
      cop: cop ?? this.cop,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'otopark_label': otopark?.label,
      'kazan_label': kazan?.label,
      'cati_label': cati?.label,
      'asansor_label': asansor?.label,
      'jenerator_label': jenerator?.label,
      'pano_label': pano?.label,
      'trafo_label': trafo?.label,
      'depo_label': depo?.label,
      'cop_label': cop?.label,
    };
  }

  factory Bolum29Model.fromMap(Map<String, dynamic> map) {
    // Yardımcı fonksiyon: Etikete göre nesne bulma
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      try {
        return options.firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum29Model(
      otopark: find(map['otopark_label'], [Bolum29Content.otoparkOptionA, Bolum29Content.otoparkOptionB]),
      kazan: find(map['kazan_label'], [Bolum29Content.kazanOptionA, Bolum29Content.kazanOptionB]),
      cati: find(map['cati_label'], [Bolum29Content.catiOptionA, Bolum29Content.catiOptionB]),
      asansor: find(map['asansor_label'], [Bolum29Content.asansorOptionA, Bolum29Content.asansorOptionB]),
      jenerator: find(map['jenerator_label'], [Bolum29Content.jeneratorOptionA, Bolum29Content.jeneratorOptionB]),
      pano: find(map['pano_label'], [Bolum29Content.panoOptionA, Bolum29Content.panoOptionB]),
      trafo: find(map['trafo_label'], [Bolum29Content.trafoOptionA, Bolum29Content.trafoOptionB, Bolum29Content.trafoOptionC]),
      depo: find(map['depo_label'], [Bolum29Content.depoOptionA, Bolum29Content.depoOptionB]),
      cop: find(map['cop_label'], [Bolum29Content.copOptionA, Bolum29Content.copOptionB]),
    );
  }
}