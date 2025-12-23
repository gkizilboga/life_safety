class Bolum5Model {
  final double? alanOturum;
  final double? alanKatBrut;
  final double? alanToplamInsaat;

  Bolum5Model({
    this.alanOturum,
    this.alanKatBrut,
    this.alanToplamInsaat,
  });

  bool get isAlanlarGirildi => 
      (alanOturum ?? 0) > 0 && 
      (alanKatBrut ?? 0) > 0 && 
      (alanToplamInsaat ?? 0) > 0;

  bool get isMantiksalHataYok {
    if (!isAlanlarGirildi) return true; 
    // Toplam inşaat alanı, tek bir katın alanından veya oturum alanından küçük olamaz.
    return (alanToplamInsaat! >= (alanOturum ?? 0)) && 
           (alanToplamInsaat! >= (alanKatBrut ?? 0));
  }

  Bolum5Model copyWith({
    double? alanOturum,
    double? alanKatBrut,
    double? alanToplamInsaat,
  }) {
    return Bolum5Model(
      alanOturum: alanOturum ?? this.alanOturum,
      alanKatBrut: alanKatBrut ?? this.alanKatBrut,
      alanToplamInsaat: alanToplamInsaat ?? this.alanToplamInsaat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alan_oturum': alanOturum,
      'alan_kat_brut': alanKatBrut,
      'alan_toplam_insaat': alanToplamInsaat,
    };
  }

  factory Bolum5Model.fromMap(Map<String, dynamic> map) {
    return Bolum5Model(
      alanOturum: map['alan_oturum'],
      alanKatBrut: map['alan_kat_brut'],
      alanToplamInsaat: map['alan_toplam_insaat'],
    );
  }
}