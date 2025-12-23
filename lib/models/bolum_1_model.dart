enum RuhsatDurumu {
  sonrasi,
  oncesiDegerlendir,
}
class Bolum1Model {
  final RuhsatDurumu? secim;
  Bolum1Model({this.secim});
  bool? get isYeniBina {
    if (secim == null) return null;
    return secim == RuhsatDurumu.sonrasi;
  }
  Bolum1Model copyWith({RuhsatDurumu? secim}) {
    return Bolum1Model(secim: secim ?? this.secim);
  }
  Map<String, dynamic> toMap() {
    return {'secim': secim?.name};
  }
  factory Bolum1Model.fromMap(Map<String, dynamic> map) {
    return Bolum1Model(
      secim: map['secim'] != null
          ? RuhsatDurumu.values.byName(map['secim'])
          : null,
    );
  }
}