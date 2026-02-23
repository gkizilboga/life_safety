import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum10Model {
  final ChoiceResult? zemin;
  final List<ChoiceResult?> bodrumlar;
  final List<ChoiceResult?> normaller;
  final bool bodrumlarAyni;
  final bool normallerAyni;

  ChoiceResult? get secim => zemin;

  Bolum10Model({
    this.zemin,
    this.bodrumlar = const [],
    this.normaller = const [],
    this.bodrumlarAyni = true,
    this.normallerAyni = true,
  });

  Bolum10Model copyWith({
    ChoiceResult? zemin,
    List<ChoiceResult?>? bodrumlar,
    List<ChoiceResult?>? normaller,
    bool? bodrumlarAyni,
    bool? normallerAyni,
  }) {
    return Bolum10Model(
      zemin: zemin ?? this.zemin,
      bodrumlar: bodrumlar ?? this.bodrumlar,
      normaller: normaller ?? this.normaller,
      bodrumlarAyni: bodrumlarAyni ?? this.bodrumlarAyni,
      normallerAyni: normallerAyni ?? this.normallerAyni,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zemin': zemin?.label,
      'bodrumlar': bodrumlar.map((e) => e?.label).toList(),
      'normaller': normaller.map((e) => e?.label).toList(),
      'bodrumlarAyni': bodrumlarAyni,
      'normallerAyni': normallerAyni,
    };
  }

  factory Bolum10Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? findChoice(String? label) {
      if (label == null) return null;
      return [
        Bolum10Content.konut,
        Bolum10Content.azYogunTicari,
        Bolum10Content.ortaYogunTicari,
        Bolum10Content.yuksekYogunTicari,
        Bolum10Content.teknikDepo,
      ].firstWhere((e) => e.label == label, orElse: () => Bolum10Content.konut);
    }

    return Bolum10Model(
      zemin: findChoice(map['zemin']),
      bodrumlar:
          (map['bodrumlar'] as List?)
              ?.map((e) => findChoice(e.toString()))
              .toList() ??
          [],
      normaller:
          (map['normaller'] as List?)
              ?.map((e) => findChoice(e.toString()))
              .toList() ??
          [],
      bodrumlarAyni: map['bodrumlarAyni'] ?? true,
      normallerAyni: map['normallerAyni'] ?? true,
    );
  }
}
