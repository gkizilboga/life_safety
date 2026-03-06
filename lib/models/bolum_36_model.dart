import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum36Model {
  final ChoiceResult? cikisKati;
  final ChoiceResult? disMerd;
  final ChoiceResult? konum;

  // Merdiven Genişlikleri
  final ChoiceResult? genislikKorunumlu;
  final ChoiceResult? genislikKorunumsuz;

  // Koridor Genişlikleri
  final ChoiceResult? koridorGenislikKorunumlu;
  final ChoiceResult? koridorGenislikKorunumsuz;

  final bool areWidthsSame;

  final ChoiceResult? kapiTipi;

  final ChoiceResult? kapiGenislikKorunumlu;
  final ChoiceResult? kapiGenislikKorunumsuz;

  final String? merdivenDegerlendirme;

  Bolum36Model({
    this.cikisKati,
    this.disMerd,
    this.konum,
    this.genislikKorunumlu,
    this.genislikKorunumsuz,
    this.koridorGenislikKorunumlu,
    this.koridorGenislikKorunumsuz,
    this.kapiTipi,
    this.kapiGenislikKorunumlu,
    this.kapiGenislikKorunumsuz,
    this.merdivenDegerlendirme,
    this.areWidthsSame = true,
  });

  Bolum36Model copyWith({
    ChoiceResult? cikisKati,
    ChoiceResult? disMerd,
    ChoiceResult? konum,
    ChoiceResult? genislikKorunumlu,
    ChoiceResult? genislikKorunumsuz,
    ChoiceResult? koridorGenislikKorunumlu,
    ChoiceResult? koridorGenislikKorunumsuz,
    ChoiceResult? kapiTipi,
    ChoiceResult? kapiGenislikKorunumlu,
    ChoiceResult? kapiGenislikKorunumsuz,
    String? merdivenDegerlendirme,
    bool? areWidthsSame,
  }) {
    return Bolum36Model(
      cikisKati: cikisKati ?? this.cikisKati,
      disMerd: disMerd ?? this.disMerd,
      konum: konum ?? this.konum,
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
      areWidthsSame: areWidthsSame ?? this.areWidthsSame,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cikisKati_label': cikisKati?.label,
      'disMerd_label': disMerd?.label,
      'konum_label': konum?.label,
      'genislikKorunumlu_label': genislikKorunumlu?.label,
      'genislikKorunumsuz_label': genislikKorunumsuz?.label,
      'koridorGenislikKorunumlu_label': koridorGenislikKorunumlu?.label,
      'koridorGenislikKorunumsuz_label': koridorGenislikKorunumsuz?.label,
      'kapiTipi_label': kapiTipi?.label,
      'kapiGenislikKorunumlu_label': kapiGenislikKorunumlu?.label,
      'kapiGenislikKorunumsuz_label': kapiGenislikKorunumsuz?.label,
      'merdivenDegerlendirme': merdivenDegerlendirme,
      'areWidthsSame': areWidthsSame,
    };
  }

  factory Bolum36Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? findChoice(String? l, List<ChoiceResult> options) {
      if (l == null) return null;
      try {
        return options.firstWhere((e) => e.label == l);
      } catch (_) {
        return null;
      }
    }

    final kapiOptions = [
      Bolum36WidthContent.kapiGenislikKritik,
      Bolum36WidthContent.kapiGenislikOlumlu,
      Bolum36WidthContent.kapiGenislikBilinmiyor,
    ];

    final kapiTipiOptions = [
      Bolum36Content.kapiTipiOptionA,
      Bolum36Content.kapiTipiOptionB,
      Bolum36Content.kapiTipiOptionC,
    ];

    final cikisKatiOptions = [
      Bolum36Content.cikisKatiOptionA,
      Bolum36Content.cikisKatiOptionB,
      Bolum36Content.cikisKatiOptionC,
    ];

    final disMerdOptions = [
      Bolum36Content.disMerdOptionA,
      Bolum36Content.disMerdOptionB,
      Bolum36Content.disMerdOptionC,
    ];

    final konumOptions = [
      Bolum36Content.konumOptionA,
      Bolum36Content.konumOptionB,
      Bolum36Content.konumOptionC,
    ];

    final merdOptions = [
      Bolum36WidthContent.merdGenislikA,
      Bolum36WidthContent.merdGenislikB,
      Bolum36WidthContent.merdGenislikC,
      Bolum36WidthContent.merdGenislikD,
      Bolum36WidthContent.merdGenislikBilinmiyor,
    ];

    final koridorOptions = [
      Bolum36WidthContent.koridorGenislikA,
      Bolum36WidthContent.koridorGenislikB,
      Bolum36WidthContent.koridorGenislikC,
      Bolum36WidthContent.koridorGenislikD,
      Bolum36WidthContent.koridorGenislikE,
      Bolum36WidthContent.koridorGenislikBilinmiyor,
    ];

    return Bolum36Model(
      cikisKati: findChoice(map['cikisKati_label'], cikisKatiOptions),
      disMerd: findChoice(map['disMerd_label'], disMerdOptions),
      konum: findChoice(map['konum_label'], konumOptions),
      kapiTipi: findChoice(map['kapiTipi_label'], kapiTipiOptions),
      genislikKorunumlu: findChoice(
        map['genislikKorunumlu_label'],
        merdOptions,
      ),
      genislikKorunumsuz: findChoice(
        map['genislikKorunumsuz_label'],
        merdOptions,
      ),
      koridorGenislikKorunumlu: findChoice(
        map['koridorGenislikKorunumlu_label'],
        koridorOptions,
      ),
      koridorGenislikKorunumsuz: findChoice(
        map['koridorGenislikKorunumsuz_label'],
        koridorOptions,
      ),
      kapiGenislikKorunumlu: findChoice(
        map['kapiGenislikKorunumlu_label'],
        kapiOptions,
      ),
      kapiGenislikKorunumsuz: findChoice(
        map['kapiGenislikKorunumsuz_label'],
        kapiOptions,
      ),
      merdivenDegerlendirme: map['merdivenDegerlendirme'],
      areWidthsSame: map['areWidthsSame'] ?? true,
    );
  }
}
