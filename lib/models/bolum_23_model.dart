import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum23Model {
  final ChoiceResult? bodrum;
  final ChoiceResult? yanginModu;
  final ChoiceResult? konum;
  final ChoiceResult? levha;
  final ChoiceResult? havalandirma;

  Bolum23Model({
    this.bodrum,
    this.yanginModu,
    this.konum,
    this.levha,
    this.havalandirma,
  });

  Bolum23Model copyWith({
    ChoiceResult? bodrum,
    ChoiceResult? yanginModu,
    ChoiceResult? konum,
    ChoiceResult? levha,
    ChoiceResult? havalandirma,
  }) {
    return Bolum23Model(
      bodrum: bodrum ?? this.bodrum,
      yanginModu: yanginModu ?? this.yanginModu,
      konum: konum ?? this.konum,
      levha: levha ?? this.levha,
      havalandirma: havalandirma ?? this.havalandirma,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bodrum_label': bodrum?.label,
      'yanginModu_label': yanginModu?.label,
      'konum_label': konum?.label,
      'levha_label': levha?.label,
      'havalandirma_label': havalandirma?.label,
    };
  }

  factory Bolum23Model.fromMap(Map<String, dynamic> map) {
    // Bodrum
    ChoiceResult? b;
    final l1 = map['bodrum_label'];
    if (l1 == Bolum23Content.bodrumOptionA.label) b = Bolum23Content.bodrumOptionA;
    if (l1 == Bolum23Content.bodrumOptionB.label) b = Bolum23Content.bodrumOptionB;
    if (l1 == Bolum23Content.bodrumOptionC.label) b = Bolum23Content.bodrumOptionC;
    if (l1 == Bolum23Content.bodrumOptionD.label) b = Bolum23Content.bodrumOptionD;

    // Yangın Modu
    ChoiceResult? y;
    final l2 = map['yanginModu_label'];
    if (l2 == Bolum23Content.yanginModuOptionA.label) y = Bolum23Content.yanginModuOptionA;
    if (l2 == Bolum23Content.yanginModuOptionB.label) y = Bolum23Content.yanginModuOptionB;
    if (l2 == Bolum23Content.yanginModuOptionC.label) y = Bolum23Content.yanginModuOptionC;

    // Konum
    ChoiceResult? k;
    final l3 = map['konum_label'];
    if (l3 == Bolum23Content.konumOptionA.label) k = Bolum23Content.konumOptionA;
    if (l3 == Bolum23Content.konumOptionB.label) k = Bolum23Content.konumOptionB;
    if (l3 == Bolum23Content.konumOptionC.label) k = Bolum23Content.konumOptionC;

    // Levha
    ChoiceResult? le;
    final l4 = map['levha_label'];
    if (l4 == Bolum23Content.levhaOptionA.label) le = Bolum23Content.levhaOptionA;
    if (l4 == Bolum23Content.levhaOptionB.label) le = Bolum23Content.levhaOptionB;
    if (l4 == Bolum23Content.levhaOptionC.label) le = Bolum23Content.levhaOptionC;

    // Havalandırma
    ChoiceResult? h;
    final l5 = map['havalandirma_label'];
    if (l5 == Bolum23Content.havalandirmaOptionA.label) h = Bolum23Content.havalandirmaOptionA;
    if (l5 == Bolum23Content.havalandirmaOptionB.label) h = Bolum23Content.havalandirmaOptionB;
    if (l5 == Bolum23Content.havalandirmaOptionC.label) h = Bolum23Content.havalandirmaOptionC;

    return Bolum23Model(
      bodrum: b,
      yanginModu: y,
      konum: k,
      levha: le,
      havalandirma: h,
    );
  }
}