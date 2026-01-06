import 'choice_result.dart';

class Bolum36Model {
  final ChoiceResult? disMerd;
  final ChoiceResult? konum;
  final double? genislik;
  final ChoiceResult? kapiTipi;
  final double? kapiGenislik;
  final ChoiceResult? gorunurluk;
  final int? totalValidCikisSayisi;
  final bool? donerElendi;
  final bool? disCelikElendi;

  Bolum36Model({
    this.disMerd,
    this.konum,
    this.genislik,
    this.kapiTipi,
    this.kapiGenislik,
    this.gorunurluk,
    this.totalValidCikisSayisi,
    this.donerElendi = false,
    this.disCelikElendi = false,
  });

  Bolum36Model copyWith({
    ChoiceResult? disMerd,
    ChoiceResult? konum,
    double? genislik,
    ChoiceResult? kapiTipi,
    double? kapiGenislik,
    ChoiceResult? gorunurluk,
    int? totalValidCikisSayisi,
    bool? donerElendi,
    bool? disCelikElendi,
  }) {
    return Bolum36Model(
      disMerd: disMerd ?? this.disMerd,
      konum: konum ?? this.konum,
      genislik: genislik ?? this.genislik,
      kapiTipi: kapiTipi ?? this.kapiTipi,
      kapiGenislik: kapiGenislik ?? this.kapiGenislik,
      gorunurluk: gorunurluk ?? this.gorunurluk,
      totalValidCikisSayisi: totalValidCikisSayisi ?? this.totalValidCikisSayisi,
      donerElendi: donerElendi ?? this.donerElendi,
      disCelikElendi: disCelikElendi ?? this.disCelikElendi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'disMerd_label': disMerd?.label,
      'konum_label': konum?.label,
      'genislik': genislik,
      'kapiTipi_label': kapiTipi?.label,
      'kapiGenislik': kapiGenislik,
      'gorunurluk_label': gorunurluk?.label,
      'totalValidCikisSayisi': totalValidCikisSayisi,
      'donerElendi': donerElendi,
      'disCelikElendi': disCelikElendi,
    };
  }

  factory Bolum36Model.fromMap(Map<String, dynamic> map) {
    return Bolum36Model(
      genislik: map['genislik'],
      kapiGenislik: map['kapiGenislik'],
      totalValidCikisSayisi: map['totalValidCikisSayisi'],
      donerElendi: map['donerElendi'] ?? false,
      disCelikElendi: map['disCelikElendi'] ?? false,
    );
  }
}