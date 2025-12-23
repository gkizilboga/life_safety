class Bolum7Model {
  final bool hasKapaliOtopark;
  final bool hasKazanDairesi;
  final bool hasAsansorNormal;
  final bool hasAsansorDairesi;
  final bool hasCatiArasi;
  final bool hasJeneratorOdasi;
  final bool hasElektrikOdasi;
  final bool hasTrafoOdasi;
  final bool hasDepo;
  final bool hasCopOdasi;
  final bool hasSiginak;
  final bool hasOrtakDuvar;
  final bool hasHicbiri;

  Bolum7Model({
    this.hasKapaliOtopark = false,
    this.hasKazanDairesi = false,
    this.hasAsansorNormal = false,
    this.hasAsansorDairesi = false,
    this.hasCatiArasi = false,
    this.hasJeneratorOdasi = false,
    this.hasElektrikOdasi = false,
    this.hasTrafoOdasi = false,
    this.hasDepo = false,
    this.hasCopOdasi = false,
    this.hasSiginak = false,
    this.hasOrtakDuvar = false,
    this.hasHicbiri = false,
  });

  // Hiçbir şey seçili değil mi kontrolü
  bool get isAnySelected =>
      hasKapaliOtopark ||
      hasKazanDairesi ||
      hasAsansorNormal ||
      hasAsansorDairesi ||
      hasCatiArasi ||
      hasJeneratorOdasi ||
      hasElektrikOdasi ||
      hasTrafoOdasi ||
      hasDepo ||
      hasCopOdasi ||
      hasSiginak ||
      hasOrtakDuvar ||
      hasHicbiri;

  Bolum7Model copyWith({
    bool? hasKapaliOtopark,
    bool? hasKazanDairesi,
    bool? hasAsansorNormal,
    bool? hasAsansorDairesi,
    bool? hasCatiArasi,
    bool? hasJeneratorOdasi,
    bool? hasElektrikOdasi,
    bool? hasTrafoOdasi,
    bool? hasDepo,
    bool? hasCopOdasi,
    bool? hasSiginak,
    bool? hasOrtakDuvar,
    bool? hasHicbiri,
  }) {
    return Bolum7Model(
      hasKapaliOtopark: hasKapaliOtopark ?? this.hasKapaliOtopark,
      hasKazanDairesi: hasKazanDairesi ?? this.hasKazanDairesi,
      hasAsansorNormal: hasAsansorNormal ?? this.hasAsansorNormal,
      hasAsansorDairesi: hasAsansorDairesi ?? this.hasAsansorDairesi,
      hasCatiArasi: hasCatiArasi ?? this.hasCatiArasi,
      hasJeneratorOdasi: hasJeneratorOdasi ?? this.hasJeneratorOdasi,
      hasElektrikOdasi: hasElektrikOdasi ?? this.hasElektrikOdasi,
      hasTrafoOdasi: hasTrafoOdasi ?? this.hasTrafoOdasi,
      hasDepo: hasDepo ?? this.hasDepo,
      hasCopOdasi: hasCopOdasi ?? this.hasCopOdasi,
      hasSiginak: hasSiginak ?? this.hasSiginak,
      hasOrtakDuvar: hasOrtakDuvar ?? this.hasOrtakDuvar,
      hasHicbiri: hasHicbiri ?? this.hasHicbiri,
    );
  }
}