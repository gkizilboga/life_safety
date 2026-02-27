import 'choice_result.dart';

class Bolum36Model {
  final ChoiceResult? cikisKati;
  final ChoiceResult? disMerd;
  final ChoiceResult? konum;

  // Genişlikler
  final bool areWidthsSame; // Default true (Merdiven = Koridor)

  // Merdiven Genişlikleri
  final double? genislikKorunumlu;
  final double? genislikKorunumsuz;

  // Koridor Genişlikleri (areWidthsSame = false ise kullanılır)
  final double? koridorGenislikKorunumlu;
  final double? koridorGenislikKorunumsuz;

  final ChoiceResult? kapiTipi;

  final double? kapiGenislikKorunumlu;
  final double? kapiGenislikKorunumsuz;

  final String? merdivenDegerlendirme;

  Bolum36Model({
    this.cikisKati,
    this.disMerd,
    this.konum,
    this.areWidthsSame = true,
    this.genislikKorunumlu,
    this.genislikKorunumsuz,
    this.koridorGenislikKorunumlu,
    this.koridorGenislikKorunumsuz,
    this.kapiTipi,
    this.kapiGenislikKorunumlu,
    this.kapiGenislikKorunumsuz,
    this.merdivenDegerlendirme,
  });

  Bolum36Model copyWith({
    ChoiceResult? cikisKati,
    ChoiceResult? disMerd,
    ChoiceResult? konum,
    bool? areWidthsSame,
    double? genislikKorunumlu,
    double? genislikKorunumsuz,
    double? koridorGenislikKorunumlu,
    double? koridorGenislikKorunumsuz,
    ChoiceResult? kapiTipi,
    double? kapiGenislikKorunumlu,
    double? kapiGenislikKorunumsuz,
    String? merdivenDegerlendirme,
  }) {
    return Bolum36Model(
      cikisKati: cikisKati ?? this.cikisKati,
      disMerd: disMerd ?? this.disMerd,
      konum: konum ?? this.konum,
      areWidthsSame: areWidthsSame ?? this.areWidthsSame,
      genislikKorunumlu: genislikKorunumlu ?? this.genislikKorunumlu,
      genislikKorunumsuz: genislikKorunumsuz ?? this.genislikKorunumsuz,
      koridorGenislikKorunumlu:
          koridorGenislikKorunumlu ?? this.koridorGenislikKorunumlu,
      koridorGenislikKorunumsuz:
          koridorGenislikKorunumsuz ?? this.koridorGenislikKorunumsuz,
      kapiTipi: kapiTipi ?? this.kapiTipi,
      kapiGenislikKorunumlu:
          kapiGenislikKorunumlu ?? this.kapiGenislikKorunumlu,
      kapiGenislikKorunumsuz:
          kapiGenislikKorunumsuz ?? this.kapiGenislikKorunumsuz,
      merdivenDegerlendirme:
          merdivenDegerlendirme ?? this.merdivenDegerlendirme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cikisKati_label': cikisKati?.label,
      'disMerd_label': disMerd?.label,
      'konum_label': konum?.label,
      'areWidthsSame': areWidthsSame,
      'genislikKorunumlu': genislikKorunumlu,
      'genislikKorunumsuz': genislikKorunumsuz,
      'koridorGenislikKorunumlu': koridorGenislikKorunumlu,
      'koridorGenislikKorunumsuz': koridorGenislikKorunumsuz,
      'kapiTipi_label': kapiTipi?.label,
      'kapiGenislikKorunumlu': kapiGenislikKorunumlu,
      'kapiGenislikKorunumsuz': kapiGenislikKorunumsuz,
      'merdivenDegerlendirme': merdivenDegerlendirme,
    };
  }

  factory Bolum36Model.fromMap(Map<String, dynamic> map) {
    return Bolum36Model(
      areWidthsSame: map['areWidthsSame'] ?? true,
      genislikKorunumlu: (map['genislikKorunumlu'] as num?)?.toDouble(),
      genislikKorunumsuz: (map['genislikKorunumsuz'] as num?)?.toDouble(),
      koridorGenislikKorunumlu: (map['koridorGenislikKorunumlu'] as num?)
          ?.toDouble(),
      koridorGenislikKorunumsuz: (map['koridorGenislikKorunumsuz'] as num?)
          ?.toDouble(),
      kapiGenislikKorunumlu: (map['kapiGenislikKorunumlu'] as num?)?.toDouble(),
      kapiGenislikKorunumsuz: (map['kapiGenislikKorunumsuz'] as num?)
          ?.toDouble(),
      merdivenDegerlendirme: map['merdivenDegerlendirme'],
    );
  }
}
