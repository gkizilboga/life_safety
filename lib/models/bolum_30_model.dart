import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum30Model {
  final ChoiceResult? konum;
  final double? kapasite; // Sayısal Giriş
  final ChoiceResult? kapi;
  final ChoiceResult? hava;
  final ChoiceResult? yakit;
  final ChoiceResult? drenaj; // Sıvı yakıt ise
  final ChoiceResult? tup;

  Bolum30Model({
    this.konum,
    this.kapasite,
    this.kapi,
    this.hava,
    this.yakit,
    this.drenaj,
    this.tup,
  });

  Bolum30Model copyWith({
    ChoiceResult? konum,
    double? kapasite,
    ChoiceResult? kapi,
    ChoiceResult? hava,
    ChoiceResult? yakit,
    ChoiceResult? drenaj,
    ChoiceResult? tup,
  }) {
    return Bolum30Model(
      konum: konum ?? this.konum,
      kapasite: kapasite ?? this.kapasite,
      kapi: kapi ?? this.kapi,
      hava: hava ?? this.hava,
      yakit: yakit ?? this.yakit,
      drenaj: drenaj ?? this.drenaj,
      tup: tup ?? this.tup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'konum_label': konum?.label,
      'kapasite': kapasite,
      'kapi_label': kapi?.label,
      'hava_label': hava?.label,
      'yakit_label': yakit?.label,
      'drenaj_label': drenaj?.label,
      'tup_label': tup?.label,
    };
  }

  factory Bolum30Model.fromMap(Map<String, dynamic> map) {
    // Konum
    ChoiceResult? kn;
    final l1 = map['konum_label'];
    if (l1 == Bolum30Content.konumOptionA.label) kn = Bolum30Content.konumOptionA;
    if (l1 == Bolum30Content.konumOptionB.label) kn = Bolum30Content.konumOptionB;
    if (l1 == Bolum30Content.konumOptionC.label) kn = Bolum30Content.konumOptionC;

    // Kapı
    ChoiceResult? k;
    final l2 = map['kapi_label'];
    if (l2 == Bolum30Content.kapiOptionA.label) k = Bolum30Content.kapiOptionA;
    if (l2 == Bolum30Content.kapiOptionB.label) k = Bolum30Content.kapiOptionB;

    // Hava
    ChoiceResult? h;
    final l3 = map['hava_label'];
    if (l3 == Bolum30Content.havaOptionA.label) h = Bolum30Content.havaOptionA;
    if (l3 == Bolum30Content.havaOptionB.label) h = Bolum30Content.havaOptionB;

    // Yakıt
    ChoiceResult? y;
    final l4 = map['yakit_label'];
    if (l4 == Bolum30Content.yakitOptionA.label) y = Bolum30Content.yakitOptionA;
    if (l4 == Bolum30Content.yakitOptionB.label) y = Bolum30Content.yakitOptionB;

    // Drenaj
    ChoiceResult? d;
    final l5 = map['drenaj_label'];
    if (l5 == Bolum30Content.drenajOptionA.label) d = Bolum30Content.drenajOptionA;
    if (l5 == Bolum30Content.drenajOptionB.label) d = Bolum30Content.drenajOptionB;

    // Tüp
    ChoiceResult? t;
    final l6 = map['tup_label'];
    if (l6 == Bolum30Content.tupOptionA.label) t = Bolum30Content.tupOptionA;
    if (l6 == Bolum30Content.tupOptionB.label) t = Bolum30Content.tupOptionB;
    if (l6 == Bolum30Content.tupOptionC.label) t = Bolum30Content.tupOptionC;

    return Bolum30Model(
      konum: kn,
      kapasite: map['kapasite'],
      kapi: k,
      hava: h,
      yakit: y,
      drenaj: d,
      tup: t,
    );
  }
}