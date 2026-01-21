import 'choice_result.dart';

class Bolum36Model {
  final ChoiceResult? cikisKati;
  final ChoiceResult? disMerd;
  final ChoiceResult? konum;

  // Genişlikler
  final bool areWidthsSame; // Default true (Merdiven = Koridor)

  // Merdiven Genişlikleri
  final int? genislikKorunumlu;
  final int? genislikKorunumsuz;

  // Koridor Genişlikleri (areWidthsSame = false ise kullanılır)
  final int? koridorGenislikKorunumlu;
  final int? koridorGenislikKorunumsuz;

  final ChoiceResult? kapiTipi;

  final int? kapiGenislikKorunumlu;
  final int? kapiGenislikKorunumsuz;

  final ChoiceResult? gorunurluk;
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
    this.gorunurluk,
    this.merdivenDegerlendirme,
  });

  Bolum36Model copyWith({
    ChoiceResult? cikisKati,
    ChoiceResult? disMerd,
    ChoiceResult? konum,
    bool? areWidthsSame,
    int? genislikKorunumlu,
    int? genislikKorunumsuz,
    int? koridorGenislikKorunumlu,
    int? koridorGenislikKorunumsuz,
    ChoiceResult? kapiTipi,
    int? kapiGenislikKorunumlu,
    int? kapiGenislikKorunumsuz,
    ChoiceResult? gorunurluk,
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
      gorunurluk: gorunurluk ?? this.gorunurluk,
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
      'gorunurluk_label': gorunurluk?.label,
      'merdivenDegerlendirme': merdivenDegerlendirme,
    };
  }

  factory Bolum36Model.fromMap(Map<String, dynamic> map) {
    return Bolum36Model(
      areWidthsSame: map['areWidthsSame'] ?? true,
      genislikKorunumlu: map['genislikKorunumlu'] as int?,
      genislikKorunumsuz: map['genislikKorunumsuz'] as int?,
      koridorGenislikKorunumlu: map['koridorGenislikKorunumlu'] as int?,
      koridorGenislikKorunumsuz: map['koridorGenislikKorunumsuz'] as int?,
      kapiGenislikKorunumlu: map['kapiGenislikKorunumlu'] as int?,
      kapiGenislikKorunumsuz: map['kapiGenislikKorunumsuz'] as int?,
      merdivenDegerlendirme: map['merdivenDegerlendirme'],
    );
  }
}
