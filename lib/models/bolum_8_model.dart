enum NizamDurumu { ayrik, bitisik }

class Bolum8Model {
  final NizamDurumu? secim;

  Bolum8Model({this.secim});

  // Teknik talimatta istenen String değer karşılığı
  String? get nizamDurumuDeger {
    if (secim == null) return null;
    return secim == NizamDurumu.ayrik ? 'AYRIK' : 'BITISIK';
  }

  Bolum8Model copyWith({NizamDurumu? secim}) {
    return Bolum8Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim': secim?.name};
  }

  factory Bolum8Model.fromMap(Map<String, dynamic> map) {
    return Bolum8Model(
      secim: map['secim'] != null
          ? NizamDurumu.values.byName(map['secim'])
          : null,
    );
  }
}