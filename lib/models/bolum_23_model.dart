import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum23Model {
  final ChoiceResult? bodrum;
  final ChoiceResult? yanginModu;
  final ChoiceResult? konum;
  final ChoiceResult? levha;
  final ChoiceResult? havalandirma;

  ChoiceResult? get secim => bodrum ?? yanginModu ?? konum ?? levha ?? havalandirma;

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
    ChoiceResult? find(String? l) {
      if (l == null) return null;
      return [
        Bolum23Content.bodrumOptionA, Bolum23Content.bodrumOptionB, Bolum23Content.bodrumOptionC, Bolum23Content.bodrumOptionD,
        Bolum23Content.yanginModuOptionA, Bolum23Content.yanginModuOptionB, Bolum23Content.yanginModuOptionC,
        Bolum23Content.konumOptionA, Bolum23Content.konumOptionB, Bolum23Content.konumOptionC,
        Bolum23Content.levhaOptionA, Bolum23Content.levhaOptionB, Bolum23Content.levhaOptionC,
        Bolum23Content.havalandirmaOptionA, Bolum23Content.havalandirmaOptionB, Bolum23Content.havalandirmaOptionC,
      ].firstWhere((e) => e.label == l, orElse: () => Bolum23Content.levhaOptionC);
    }

    return Bolum23Model(
      bodrum: find(map['bodrum_label']),
      yanginModu: find(map['yanginModu_label']),
      konum: find(map['konum_label']),
      levha: find(map['levha_label']),
      havalandirma: find(map['havalandirma_label']),
    );
  }
}