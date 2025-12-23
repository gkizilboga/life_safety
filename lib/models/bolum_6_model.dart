enum OtoparkAciklikTipi { tamKapali, karsilikliAcik, tekCepheAcik }

class Bolum6Model {
  final bool hasOtoparkGenel;
  final bool hasTicari;
  final bool hasDepo;
  final bool hasSadeceKonut; // D Şıkkı
  final OtoparkAciklikTipi? otoparkAciklikTipi;

  Bolum6Model({
    this.hasOtoparkGenel = false,
    this.hasTicari = false,
    this.hasDepo = false,
    this.hasSadeceKonut = false,
    this.otoparkAciklikTipi,
  });

  // Mantıksal Getters
  bool get isYariAcik {
    if (!hasOtoparkGenel) return false;
    return otoparkAciklikTipi == OtoparkAciklikTipi.karsilikliAcik;
  }

  String? get otoparkStatus {
    if (!hasOtoparkGenel || otoparkAciklikTipi == null) return null;
    return isYariAcik ? "YARI AÇIK OTOPARK" : "KAPALI OTOPARK";
  }

  // Seçim Kontrolü (En az biri seçili mi?)
  bool get isAnySelected => hasOtoparkGenel || hasTicari || hasDepo || hasSadeceKonut;

  Bolum6Model copyWith({
    bool? hasOtoparkGenel,
    bool? hasTicari,
    bool? hasDepo,
    bool? hasSadeceKonut,
    OtoparkAciklikTipi? otoparkAciklikTipi,
  }) {
    return Bolum6Model(
      hasOtoparkGenel: hasOtoparkGenel ?? this.hasOtoparkGenel,
      hasTicari: hasTicari ?? this.hasTicari,
      hasDepo: hasDepo ?? this.hasDepo,
      hasSadeceKonut: hasSadeceKonut ?? this.hasSadeceKonut,
      otoparkAciklikTipi: otoparkAciklikTipi ?? this.otoparkAciklikTipi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'has_otopark_genel': hasOtoparkGenel,
      'has_ticari': hasTicari,
      'has_depo': hasDepo,
      'has_sadece_konut': hasSadeceKonut,
      'otopark_aciklik_tipi': otoparkAciklikTipi?.name,
      'otopark_status': otoparkStatus,
      'is_yari_acik': isYariAcik,
    };
  }

  factory Bolum6Model.fromMap(Map<String, dynamic> map) {
    return Bolum6Model(
      hasOtoparkGenel: map['has_otopark_genel'] ?? false,
      hasTicari: map['has_ticari'] ?? false,
      hasDepo: map['has_depo'] ?? false,
      hasSadeceKonut: map['has_sadece_konut'] ?? false,
      otoparkAciklikTipi: map['otopark_aciklik_tipi'] != null
          ? OtoparkAciklikTipi.values.byName(map['otopark_aciklik_tipi'])
          : null,
    );
  }
}