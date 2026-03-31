import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum33Model {
  final double? alanZemin;
  final double? alanNormal;
  final double? alanBodrumMax;
  final int? yukZemin;
  final int? yukNormal;
  final int? yukBodrum;
  final int? gerekliZemin;
  final int? gerekliNormal;
  final int? gerekliBodrum;
  final int? mevcutUst;
  final int? mevcutBodrum;

  Bolum33Model({
    this.alanZemin,
    this.alanNormal,
    this.alanBodrumMax,
    this.yukZemin,
    this.yukNormal,
    this.yukBodrum,
    this.gerekliZemin,
    this.gerekliNormal,
    this.gerekliBodrum,
    this.mevcutUst,
    this.mevcutBodrum,
  });

  ChoiceResult? get normalKatSonuc {
    if (mevcutUst == null || gerekliNormal == null) return null;
    return (mevcutUst! >= gerekliNormal!)
        ? Bolum33Content.normalKatYeterli
        : Bolum33Content.normalKatYetersiz;
  }

  ChoiceResult? get zeminKatSonuc {
    if (mevcutUst == null || gerekliZemin == null) return null;
    return (mevcutUst! >= gerekliZemin!)
        ? Bolum33Content.zeminKatYeterli
        : Bolum33Content.zeminKatYetersiz;
  }

  ChoiceResult? get bodrumKatSonuc {
    if (mevcutBodrum == null || gerekliBodrum == null) return null;
    return (mevcutBodrum! >= gerekliBodrum!)
        ? Bolum33Content.bodrumKatYeterli
        : Bolum33Content.bodrumKatYetersiz;
  }

  String get combinedReportText {
    final resZemin = zeminKatSonuc;
    final resNormal = normalKatSonuc;
    final resBodrum = bodrumKatSonuc;

    List<ChoiceResult> currentResults = [];
    if (resZemin != null) currentResults.add(resZemin);
    if (resNormal != null) currentResults.add(resNormal);
    if (resBodrum != null) currentResults.add(resBodrum);

    if (currentResults.isEmpty) return "Bölüm 33 hesaplaması yapılmamış.";

    // Check if everything is sufficient
    bool allOk = currentResults.every((r) => r.label.contains("-OK"));
    // Check if everything is insufficient
    bool allFail = currentResults.every((r) => r.label.contains("-FAIL"));

    // Consolidate if everything matches and there is more than 1 floor type
    if (allOk && currentResults.length > 1) {
      return Bolum33Content.allKatlarYeterli.reportText;
    }
    if (allFail && currentResults.length > 1) {
      return Bolum33Content.allKatlarYetersiz.reportText;
    }

    List<String> parts = [];
    // Zemin Kat
    if (resZemin != null) {
      parts.add("ZEMİN KAT: ${resZemin.reportText}");
    }

    // Normal Kat
    if (resNormal != null) {
      parts.add("NORMAL KATLAR: ${resNormal.reportText}");
    }

    // Bodrum Kat
    if (resBodrum != null) {
      parts.add("BODRUM KATLAR: ${resBodrum.reportText}");
    }

    return parts.join("\n\n");
  }

  Bolum33Model copyWith({
    double? alanZemin,
    double? alanNormal,
    double? alanBodrumMax,
    int? yukZemin,
    int? yukNormal,
    int? yukBodrum,
    int? gerekliZemin,
    int? gerekliNormal,
    int? gerekliBodrum,
    int? mevcutUst,
    int? mevcutBodrum,
  }) {
    return Bolum33Model(
      alanZemin: alanZemin ?? this.alanZemin,
      alanNormal: alanNormal ?? this.alanNormal,
      alanBodrumMax: alanBodrumMax ?? this.alanBodrumMax,
      yukZemin: yukZemin ?? this.yukZemin,
      yukNormal: yukNormal ?? this.yukNormal,
      yukBodrum: yukBodrum ?? this.yukBodrum,
      gerekliZemin: gerekliZemin ?? this.gerekliZemin,
      gerekliNormal: gerekliNormal ?? this.gerekliNormal,
      gerekliBodrum: gerekliBodrum ?? this.gerekliBodrum,
      mevcutUst: mevcutUst ?? this.mevcutUst,
      mevcutBodrum: mevcutBodrum ?? this.mevcutBodrum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alanZemin': alanZemin,
      'alanNormal': alanNormal,
      'alanBodrumMax': alanBodrumMax,
      'yukZemin': yukZemin,
      'yukNormal': yukNormal,
      'yukBodrum': yukBodrum,
      'gerekliZemin': gerekliZemin,
      'gerekliNormal': gerekliNormal,
      'gerekliBodrum': gerekliBodrum,
      'mevcutUst': mevcutUst,
      'mevcutBodrum': mevcutBodrum,
    };
  }

  factory Bolum33Model.fromMap(Map<String, dynamic> map) {
    return Bolum33Model(
      alanZemin: map['alanZemin'],
      alanNormal: map['alanNormal'],
      alanBodrumMax: map['alanBodrumMax'],
      yukZemin: map['yukZemin'],
      yukNormal: map['yukNormal'],
      yukBodrum: map['yukBodrum'],
      gerekliZemin: map['gerekliZemin'],
      gerekliNormal: map['gerekliNormal'],
      gerekliBodrum: map['gerekliBodrum'],
      mevcutUst: map['mevcutUst'],
      mevcutBodrum: map['mevcutBodrum'],
    );
  }
}
