import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum16Model {
  final ChoiceResult? mantolama;
  
  // Eğer giydirme cephe seçildiyse:
  // "Giydirme cephe ile döşeme arasındaki boşluklar yangına dayanıklı malzeme ile yalıtılmış mı?"
  final bool? giydirmeBoslukYalitim; // true: Boşluk Yok, false: Boşluk Var

  final ChoiceResult? sagirYuzey;
  // Eğer sağır yüzey yetersizse (100cm altı):
  // "Cepheye bakan sprinkler sistemi var mı?"
  final bool? sagirYuzeySprinkler; 

  final ChoiceResult? bitisikNizam;

  ChoiceResult? get secim => mantolama ?? sagirYuzey ?? bitisikNizam;

  Bolum16Model({
    this.mantolama,
    this.giydirmeBoslukYalitim,
    this.sagirYuzey,
    this.sagirYuzeySprinkler,
    this.bitisikNizam,
  });

  Bolum16Model copyWith({
    ChoiceResult? mantolama,
    bool? giydirmeBoslukYalitim,
    ChoiceResult? sagirYuzey,
    bool? sagirYuzeySprinkler,
    ChoiceResult? bitisikNizam,
  }) {
    return Bolum16Model(
      mantolama: mantolama ?? this.mantolama,
      giydirmeBoslukYalitim: giydirmeBoslukYalitim ?? this.giydirmeBoslukYalitim,
      sagirYuzey: sagirYuzey ?? this.sagirYuzey,
      sagirYuzeySprinkler: sagirYuzeySprinkler ?? this.sagirYuzeySprinkler,
      bitisikNizam: bitisikNizam ?? this.bitisikNizam,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mantolama_label': mantolama?.label,
      'giydirmeBoslukYalitim': giydirmeBoslukYalitim,
      'sagirYuzey_label': sagirYuzey?.label,
      'sagirYuzeySprinkler': sagirYuzeySprinkler,
      'bitisikNizam_label': bitisikNizam?.label,
    };
  }

  factory Bolum16Model.fromMap(Map<String, dynamic> map) {
    // Mantolama
    ChoiceResult? m;
    final l1 = map['mantolama_label'];
    if (l1 == Bolum16Content.mantolamaOptionA.label) m = Bolum16Content.mantolamaOptionA;
    if (l1 == Bolum16Content.mantolamaOptionB.label) m = Bolum16Content.mantolamaOptionB;
    if (l1 == Bolum16Content.giydirmeOptionC.label) m = Bolum16Content.giydirmeOptionC;
    if (l1 == Bolum16Content.mantolamaOptionD.label) m = Bolum16Content.mantolamaOptionD;
    if (l1 == Bolum16Content.mantolamaOptionE.label) m = Bolum16Content.mantolamaOptionE;

    // Sağır Yüzey
    ChoiceResult? s;
    final l2 = map['sagirYuzey_label'];
    if (l2 == Bolum16Content.sagirYuzeyOptionA.label) s = Bolum16Content.sagirYuzeyOptionA;
    if (l2 == Bolum16Content.sagirYuzeyOptionB.label) s = Bolum16Content.sagirYuzeyOptionB;
    if (l2 == Bolum16Content.sagirYuzeyOptionC.label) s = Bolum16Content.sagirYuzeyOptionC;

    // Bitişik Nizam
    ChoiceResult? b;
    final l3 = map['bitisikNizam_label'];
    if (l3 == Bolum16Content.bitisikOptionA.label) b = Bolum16Content.bitisikOptionA;
    if (l3 == Bolum16Content.bitisikOptionB.label) b = Bolum16Content.bitisikOptionB;
    if (l3 == Bolum16Content.bitisikOptionC.label) b = Bolum16Content.bitisikOptionC;

    return Bolum16Model(
      mantolama: m,
      giydirmeBoslukYalitim: map['giydirmeBoslukYalitim'],
      sagirYuzey: s,
      sagirYuzeySprinkler: map['sagirYuzeySprinkler'],
      bitisikNizam: b,
    );
  }
}