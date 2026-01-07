import 'choice_result.dart';

class Bolum36Model {
  final ChoiceResult? cikisKati;
  final ChoiceResult? disMerd;
  final ChoiceResult? konum;
  final double? genislik;
  final ChoiceResult? kapiTipi;
  final double? kapiGenislik;
  final ChoiceResult? gorunurluk;
  final String? merdivenDegerlendirme;

  Bolum36Model({
    this.cikisKati,
    this.disMerd,
    this.konum,
    this.genislik,
    this.kapiTipi,
    this.kapiGenislik,
    this.gorunurluk,
    this.merdivenDegerlendirme,
  });

  Bolum36Model copyWith({
    ChoiceResult? cikisKati,
    ChoiceResult? disMerd,
    ChoiceResult? konum,
    double? genislik,
    ChoiceResult? kapiTipi,
    double? kapiGenislik,
    ChoiceResult? gorunurluk,
    String? merdivenDegerlendirme,
  }) {
    return Bolum36Model(
      cikisKati: cikisKati ?? this.cikisKati,
      disMerd: disMerd ?? this.disMerd,
      konum: konum ?? this.konum,
      genislik: genislik ?? this.genislik,
      kapiTipi: kapiTipi ?? this.kapiTipi,
      kapiGenislik: kapiGenislik ?? this.kapiGenislik,
      gorunurluk: gorunurluk ?? this.gorunurluk,
      merdivenDegerlendirme: merdivenDegerlendirme ?? this.merdivenDegerlendirme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cikisKati_label': cikisKati?.label,
      'disMerd_label': disMerd?.label,
      'konum_label': konum?.label,
      'genislik': genislik,
      'kapiTipi_label': kapiTipi?.label,
      'kapiGenislik': kapiGenislik,
      'gorunurluk_label': gorunurluk?.label,
      'merdivenDegerlendirme': merdivenDegerlendirme,
    };
  }

  factory Bolum36Model.fromMap(Map<String, dynamic> map) {
    return Bolum36Model(
      genislik: map['genislik'],
      kapiGenislik: map['kapiGenislik'],
      merdivenDegerlendirme: map['merdivenDegerlendirme'],
    );
  }
}