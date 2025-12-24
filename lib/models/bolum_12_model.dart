import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum12Model {
  // Çelik Sorusu
  final ChoiceResult? celikKoruma;
  
  // Betonarme Sorusu
  final ChoiceResult? betonPaspayi;
  // Eğer kullanıcı manuel paspayı girmek isterse:
  final double? kolonPaspayi;
  final double? kirisPaspayi;

  // Ahşap Sorusu
  final ChoiceResult? ahsapKesit;

  // Yığma Sorusu
  final ChoiceResult? yigmaDuvar;

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
    // Çelik
    ChoiceResult? c;
    final l1 = map['celikKoruma_label'];
    if (l1 == Bolum12Content.celikOptionA.label) c = Bolum12Content.celikOptionA;
    if (l1 == Bolum12Content.celikOptionB.label) c = Bolum12Content.celikOptionB;
    if (l1 == Bolum12Content.celikOptionC.label) c = Bolum12Content.celikOptionC;

    // Beton
    ChoiceResult? b;
    final l2 = map['betonPaspayi_label'];
    if (l2 == Bolum12Content.betonOptionA.label) b = Bolum12Content.betonOptionA;
    if (l2 == Bolum12Content.betonOptionB.label) b = Bolum12Content.betonOptionB;
    if (l2 == Bolum12Content.betonOptionC.label) b = Bolum12Content.betonOptionC;

    // Ahşap
    ChoiceResult? a;
    final l3 = map['ahsapKesit_label'];
    if (l3 == Bolum12Content.ahsapOptionA.label) a = Bolum12Content.ahsapOptionA;
    if (l3 == Bolum12Content.ahsapOptionB.label) a = Bolum12Content.ahsapOptionB;

    // Yığma
    ChoiceResult? y;
    final l4 = map['yigmaDuvar_label'];
    if (l4 == Bolum12Content.yigmaOptionA.label) y = Bolum12Content.yigmaOptionA;
    if (l4 == Bolum12Content.yigmaOptionB.label) y = Bolum12Content.yigmaOptionB;

    return Bolum12Model(
      celikKoruma: c,
      betonPaspayi: b,
      kolonPaspayi: map['kolonPaspayi'],
      kirisPaspayi: map['kirisPaspayi'],
      ahsapKesit: a,
      yigmaDuvar: y,
    );
  }
}