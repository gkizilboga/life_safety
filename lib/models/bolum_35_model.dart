import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum35Model {
  final double? tekYonMesafe;
  final double? ciftYonMesafe;
  final ChoiceResult? cikmaz;
  final double? cikmazUzunluk;

  Bolum35Model({
    this.tekYonMesafe,
    this.ciftYonMesafe,
    this.cikmaz,
    this.cikmazUzunluk,
  });

  Bolum35Model copyWith({
    Object? tekYonMesafe = _sentinel,
    Object? ciftYonMesafe = _sentinel,
    Object? cikmaz = _sentinel,
    Object? cikmazUzunluk = _sentinel,
  }) {
    return Bolum35Model(
      tekYonMesafe: tekYonMesafe == _sentinel
          ? this.tekYonMesafe
          : (tekYonMesafe as double?),
      ciftYonMesafe: ciftYonMesafe == _sentinel
          ? this.ciftYonMesafe
          : (ciftYonMesafe as double?),
      cikmaz: cikmaz == _sentinel
          ? this.cikmaz
          : (cikmaz as ChoiceResult?),
      cikmazUzunluk: cikmazUzunluk == _sentinel
          ? this.cikmazUzunluk
          : (cikmazUzunluk as double?),
    );
  }

  static const _sentinel = Object();

  Map<String, dynamic> toMap() {
    return {
      'tekYonMesafe': tekYonMesafe,
      'ciftYonMesafe': ciftYonMesafe,
      'cikmaz_label': cikmaz?.label,
      'cikmazUzunluk': cikmazUzunluk,
    };
  }

  factory Bolum35Model.fromMap(Map<String, dynamic> map) {
    return Bolum35Model(
      tekYonMesafe: (map['tekYonMesafe'] as num?)?.toDouble(),
      ciftYonMesafe: (map['ciftYonMesafe'] as num?)?.toDouble(),
      cikmaz: () {
        final label = map['cikmaz_label'];
        if (label == null) return null;
        try {
          return [
            Bolum35Content.cikmazOptionA,
            Bolum35Content.cikmazOptionB,
            Bolum35Content.cikmazOptionC,
          ].firstWhere((e) => e.label == label);
        } catch (_) {
          return null;
        }
      }(),
      cikmazUzunluk: (map['cikmazUzunluk'] as num?)?.toDouble(),
    );
  }
}
