import 'choice_result.dart';

class Bolum36Model {
  final ChoiceResult? cikisKati;
  final ChoiceResult? disMerd;
  final ChoiceResult? konum;
  
  // Yeni Ayrıştırılmış Alanlar
  final int? genislikKorunumlu;
  final int? genislikKorunumsuz;
  
  final ChoiceResult? kapiTipi;
  
  final int? kapiGenislikKorunumlu;
  final int? kapiGenislikKorunumsuz;
  
  final ChoiceResult? gorunurluk;
  final String? merdivenDegerlendirme;

  Bolum36Model({
    this.cikisKati,
    this.disMerd,
    this.konum,
    this.genislikKorunumlu,
    this.genislikKorunumsuz,
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
    int? genislikKorunumlu,
    int? genislikKorunumsuz,
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
      genislikKorunumlu: genislikKorunumlu ?? this.genislikKorunumlu,
      genislikKorunumsuz: genislikKorunumsuz ?? this.genislikKorunumsuz,
      kapiTipi: kapiTipi ?? this.kapiTipi,
      kapiGenislikKorunumlu: kapiGenislikKorunumlu ?? this.kapiGenislikKorunumlu,
      kapiGenislikKorunumsuz: kapiGenislikKorunumsuz ?? this.kapiGenislikKorunumsuz,
      gorunurluk: gorunurluk ?? this.gorunurluk,
      merdivenDegerlendirme: merdivenDegerlendirme ?? this.merdivenDegerlendirme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cikisKati_label': cikisKati?.label,
      'disMerd_label': disMerd?.label,
      'konum_label': konum?.label,
      'genislikKorunumlu': genislikKorunumlu,
      'genislikKorunumsuz': genislikKorunumsuz,
      'kapiTipi_label': kapiTipi?.label,
      'kapiGenislikKorunumlu': kapiGenislikKorunumlu,
      'kapiGenislikKorunumsuz': kapiGenislikKorunumsuz,
      'gorunurluk_label': gorunurluk?.label,
      'merdivenDegerlendirme': merdivenDegerlendirme,
    };
  }

  factory Bolum36Model.fromMap(Map<String, dynamic> map) {
    return Bolum36Model(
      genislikKorunumlu: map['genislikKorunumlu'] as int?,
      genislikKorunumsuz: map['genislikKorunumsuz'] as int?,
      kapiGenislikKorunumlu: map['kapiGenislikKorunumlu'] as int?,
      kapiGenislikKorunumsuz: map['kapiGenislikKorunumsuz'] as int?,
      merdivenDegerlendirme: map['merdivenDegerlendirme'],
    );
  }
}