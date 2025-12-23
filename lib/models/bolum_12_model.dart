enum CelikKorumaSecim { evetKorumaVar, hayirCiplak, bilmiyorum }
enum BetonYontemSecim { standart2007, manuelGiris, bilmiyorum }
enum AhsapKesitSecim { ince, kalin, bilmiyorum }
enum YigmaDuvarSecim { kalin, ince, bilmiyorum }

class Bolum12Model {
  // Çelik değişkenleri
  final CelikKorumaSecim? resCelikKoruma;
  // Betonarme değişkenleri
  final BetonYontemSecim? resBetonYontem;
  final double? valPaspayiKolon;
  final double? valPaspayiKiris;
  final double? valPaspayiDoseme;
  // Ahşap değişkenleri
  final AhsapKesitSecim? resAhsapKesit;
  // Yığma değişkenleri
  final YigmaDuvarSecim? resYigmaDuvar;

  Bolum12Model({
    this.resCelikKoruma,
    this.resBetonYontem,
    this.valPaspayiKolon,
    this.valPaspayiKiris,
    this.valPaspayiDoseme,
    this.resAhsapKesit,
    this.resYigmaDuvar,
  });

  Bolum12Model copyWith({
    CelikKorumaSecim? resCelikKoruma,
    BetonYontemSecim? resBetonYontem,
    double? valPaspayiKolon,
    double? valPaspayiKiris,
    double? valPaspayiDoseme,
    AhsapKesitSecim? resAhsapKesit,
    YigmaDuvarSecim? resYigmaDuvar,
  }) {
    return Bolum12Model(
      resCelikKoruma: resCelikKoruma ?? this.resCelikKoruma,
      resBetonYontem: resBetonYontem ?? this.resBetonYontem,
      valPaspayiKolon: valPaspayiKolon ?? this.valPaspayiKolon,
      valPaspayiKiris: valPaspayiKiris ?? this.valPaspayiKiris,
      valPaspayiDoseme: valPaspayiDoseme ?? this.valPaspayiDoseme,
      resAhsapKesit: resAhsapKesit ?? this.resAhsapKesit,
      resYigmaDuvar: resYigmaDuvar ?? this.resYigmaDuvar,
    );
  }
}