import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum36Model {
  final ChoiceResult? disMerd;
  final ChoiceResult? konum;
  final double? genislik;
  final ChoiceResult? kapiTipi;
  final double? kapiGenislik;
  final ChoiceResult? gorunurluk;

  Bolum36Model({
    this.disMerd,
    this.konum,
    this.genislik,
    this.kapiTipi,
    this.kapiGenislik,
    this.gorunurluk,
  });

  Bolum36Model copyWith({
    ChoiceResult? disMerd,
    ChoiceResult? konum,
    double? genislik,
    ChoiceResult? kapiTipi,
    double? kapiGenislik,
    ChoiceResult? gorunurluk,
  }) {
    return Bolum36Model(
      disMerd: disMerd ?? this.disMerd,
      konum: konum ?? this.konum,
      genislik: genislik ?? this.genislik,
      kapiTipi: kapiTipi ?? this.kapiTipi,
      kapiGenislik: kapiGenislik ?? this.kapiGenislik,
      gorunurluk: gorunurluk ?? this.gorunurluk,
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
    };
  }

  factory Bolum36Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      try {
        return options.firstWhere((e) => e.label == label);
      } catch (_) {
        return null;
      }
    }

    return Bolum36Model(
      disMerd: find(map['disMerd_label'], [Bolum36Content.disMerdOptionA, Bolum36Content.disMerdOptionB, Bolum36Content.disMerdOptionC]),
      konum: find(map['konum_label'], [Bolum36Content.konumOptionA, Bolum36Content.konumOptionB, Bolum36Content.konumOptionC]),
      genislik: map['genislik'],
      kapiTipi: find(map['kapiTipi_label'], [Bolum36Content.kapiTipiOptionA, Bolum36Content.kapiTipiOptionB]),
      kapiGenislik: map['kapiGenislik'],
      gorunurluk: find(map['gorunurluk_label'], [Bolum36Content.gorunurlukOptionA, Bolum36Content.gorunurlukOptionB, Bolum36Content.gorunurlukOptionC]),
    );
  }
}