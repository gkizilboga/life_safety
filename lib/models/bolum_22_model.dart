import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum22Model {
  final ChoiceResult? varlik;
  final ChoiceResult? konum;
  final ChoiceResult? boyut;
  final ChoiceResult? kabin;
  final ChoiceResult? enerji;
  final ChoiceResult? basinc;

  ChoiceResult? get secim =>
      varlik ?? konum ?? boyut ?? kabin ?? enerji ?? basinc;

  Bolum22Model({
    this.varlik,
    this.konum,
    this.boyut,
    this.kabin,
    this.enerji,
    this.basinc,
  });

  Bolum22Model copyWith({
    ChoiceResult? varlik,
    ChoiceResult? konum,
    ChoiceResult? boyut,
    ChoiceResult? kabin,
    ChoiceResult? enerji,
    ChoiceResult? basinc,
  }) {
    return Bolum22Model(
      varlik: varlik ?? this.varlik,
      konum: konum ?? this.konum,
      boyut: boyut ?? this.boyut,
      kabin: kabin ?? this.kabin,
      enerji: enerji ?? this.enerji,
      basinc: basinc ?? this.basinc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'varlik_label': varlik?.label,
      'konum_label': konum?.label,
      'boyut_label': boyut?.label,
      'kabin_label': kabin?.label,
      'enerji_label': enerji?.label,
      'basinc_label': basinc?.label,
    };
  }

  factory Bolum22Model.fromMap(Map<String, dynamic> map) {
    // Varlık
    ChoiceResult? v;
    final l1 = map['varlik_label'];
    if (l1 == Bolum22Content.varlikOptionA.label)
      v = Bolum22Content.varlikOptionA;
    if (l1 == Bolum22Content.varlikOptionB.label)
      v = Bolum22Content.varlikOptionB;
    if (l1 == Bolum22Content.varlikOptionC.label)
      v = Bolum22Content.varlikOptionC;

    // Konum
    ChoiceResult? k;
    final l2 = map['konum_label'];
    if (l2 == Bolum22Content.konumOptionA.label)
      k = Bolum22Content.konumOptionA;
    if (l2 == Bolum22Content.konumOptionB.label)
      k = Bolum22Content.konumOptionB;
    if (l2 == Bolum22Content.konumOptionC.label)
      k = Bolum22Content.konumOptionC;

    // Boyut
    ChoiceResult? b;
    final l3 = map['boyut_label'];
    if (l3 == Bolum22Content.boyutOptionA.label)
      b = Bolum22Content.boyutOptionA;
    if (l3 == Bolum22Content.boyutOptionB.label)
      b = Bolum22Content.boyutOptionB;
    if (l3 == Bolum22Content.boyutOptionC.label)
      b = Bolum22Content.boyutOptionC;
    if (l3 == Bolum22Content.boyutOptionD.label)
      b = Bolum22Content.boyutOptionD;

    // Kabin
    ChoiceResult? ka;
    final l4 = map['kabin_label'];
    if (l4 == Bolum22Content.kabinOptionA.label)
      ka = Bolum22Content.kabinOptionA;
    if (l4 == Bolum22Content.kabinOptionB.label)
      ka = Bolum22Content.kabinOptionB;
    if (l4 == Bolum22Content.kabinOptionC.label)
      ka = Bolum22Content.kabinOptionC;

    // Enerji
    ChoiceResult? e;
    final l5 = map['enerji_label'];
    if (l5 == Bolum22Content.enerjiOptionA.label)
      e = Bolum22Content.enerjiOptionA;
    if (l5 == Bolum22Content.enerjiOptionB.label)
      e = Bolum22Content.enerjiOptionB;
    if (l5 == Bolum22Content.enerjiOptionC.label)
      e = Bolum22Content.enerjiOptionC;

    // Basınç
    ChoiceResult? ba;
    final l6 = map['basinc_label'];
    if (l6 == Bolum22Content.basincOptionA.label)
      ba = Bolum22Content.basincOptionA;
    if (l6 == Bolum22Content.basincOptionB.label)
      ba = Bolum22Content.basincOptionB;
    if (l6 == Bolum22Content.basincOptionC.label)
      ba = Bolum22Content.basincOptionC;

    return Bolum22Model(
      varlik: v,
      konum: k,
      boyut: b,
      kabin: ka,
      enerji: e,
      basinc: ba,
    );
  }
}
