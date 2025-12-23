enum SprinklerDurumuSecim { tamamenVar, hicYok, kismenVar }

class Bolum9Model {
  final SprinklerDurumuSecim? secim;

  Bolum9Model({this.secim});

  // KRİTİK MANTIK: Sadece "Tamamen Var" ise true döner.
  // "Kısmen Var" veya "Hiç Yok" durumunda false döner.
  bool get hasSprinkler => secim == SprinklerDurumuSecim.tamamenVar;

  Bolum9Model copyWith({SprinklerDurumuSecim? secim}) {
    return Bolum9Model(secim: secim ?? this.secim);
  }

  Map<String, dynamic> toMap() {
    return {'secim': secim?.name};
  }

  factory Bolum9Model.fromMap(Map<String, dynamic> map) {
    return Bolum9Model(
      secim: map['secim'] != null
          ? SprinklerDurumuSecim.values.byName(map['secim'])
          : null,
    );
  }
}