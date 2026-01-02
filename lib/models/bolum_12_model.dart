import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum12Model {
  final ChoiceResult? celikKoruma;
  final ChoiceResult? betonPaspayi;
  final double? kolonPaspayi;
  final double? kirisPaspayi;
  final ChoiceResult? ahsapKesit;
  final ChoiceResult? yigmaDuvar;

  ChoiceResult? get secim => celikKoruma ?? betonPaspayi ?? ahsapKesit ?? yigmaDuvar;

  Bolum12Model({
    this.celikKoruma,
    this.betonPaspayi,
    this.kolonPaspayi,
    this.kirisPaspayi,
    this.ahsapKesit,
    this.yigmaDuvar,
  });

  Bolum12Model copyWith({
    ChoiceResult? celikKoruma,
    ChoiceResult? betonPaspayi,
    double? kolonPaspayi,
    double? kirisPaspayi,
    ChoiceResult? ahsapKesit,
    ChoiceResult? yigmaDuvar,
  }) {
    return Bolum12Model(
      celikKoruma: celikKoruma ?? this.celikKoruma,
      betonPaspayi: betonPaspayi ?? this.betonPaspayi,
      kolonPaspayi: kolonPaspayi ?? this.kolonPaspayi,
      kirisPaspayi: kirisPaspayi ?? this.kirisPaspayi,
      ahsapKesit: ahsapKesit ?? this.ahsapKesit,
      yigmaDuvar: yigmaDuvar ?? this.yigmaDuvar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'celikKoruma_label': celikKoruma?.label,
      'betonPaspayi_label': betonPaspayi?.label,
      'kolonPaspayi': kolonPaspayi,
      'kirisPaspayi': kirisPaspayi,
      'ahsapKesit_label': ahsapKesit?.label,
      'yigmaDuvar_label': yigmaDuvar?.label,
    };
  }

  factory Bolum12Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l, List<ChoiceResult> options) {
      if (l == null) return null;
      try { return options.firstWhere((e) => e.label == l); } catch (_) { return null; }
    }

    return Bolum12Model(
      celikKoruma: find(map['celikKoruma_label'], [Bolum12Content.celikOptionA, Bolum12Content.celikOptionB, Bolum12Content.celikOptionC]),
      betonPaspayi: find(map['betonPaspayi_label'], [Bolum12Content.betonOptionA, Bolum12Content.betonOptionB, Bolum12Content.betonOptionC, Bolum12Content.betonOptionD]),
      kolonPaspayi: map['kolonPaspayi'],
      kirisPaspayi: map['kirisPaspayi'],
      ahsapKesit: find(map['ahsapKesit_label'], [Bolum12Content.ahsapOptionA, Bolum12Content.ahsapOptionB]),
      yigmaDuvar: find(map['yigmaDuvar_label'], [Bolum12Content.yigmaOptionA, Bolum12Content.yigmaOptionB]),
    );
  }
}