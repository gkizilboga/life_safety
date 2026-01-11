class Bolum7Model {
  final bool hasOtopark; 
  final bool hasKazan;
  final bool hasAsansor;
  final bool hasCati;
  final bool hasJenerator;
  final bool hasElektrik;
  final bool hasTrafo;
  final bool hasDepo;
  final bool hasCop;
  final bool hasSiginak;
  final bool hasDuvar;
  final bool isHicbiri;

  Bolum7Model({
    this.hasOtopark = false,
    this.hasKazan = false,
    this.hasAsansor = false,
    this.hasCati = false,
    this.hasJenerator = false,
    this.hasElektrik = false,
    this.hasTrafo = false,
    this.hasDepo = false,
    this.hasCop = false,
    this.hasSiginak = false,
    this.hasDuvar = false,
    this.isHicbiri = false,
  });

  Bolum7Model copyWith({
    bool? hasOtopark,
    bool? hasKazan,
    bool? hasAsansor,
    bool? hasCati,
    bool? hasJenerator,
    bool? hasElektrik,
    bool? hasTrafo,
    bool? hasDepo,
    bool? hasCop,
    bool? hasSiginak,
    bool? hasDuvar,
    bool? isHicbiri,
  }) {
    return Bolum7Model(
      hasOtopark: hasOtopark ?? this.hasOtopark,
      hasKazan: hasKazan ?? this.hasKazan,
      hasAsansor: hasAsansor ?? this.hasAsansor,
      hasCati: hasCati ?? this.hasCati,
      hasJenerator: hasJenerator ?? this.hasJenerator,
      hasElektrik: hasElektrik ?? this.hasElektrik,
      hasTrafo: hasTrafo ?? this.hasTrafo,
      hasDepo: hasDepo ?? this.hasDepo,
      hasCop: hasCop ?? this.hasCop,
      hasSiginak: hasSiginak ?? this.hasSiginak,
      hasDuvar: hasDuvar ?? this.hasDuvar,
      isHicbiri: isHicbiri ?? this.isHicbiri,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hasOtopark': hasOtopark,
      'hasKazan': hasKazan,
      'hasAsansor': hasAsansor,
      'hasCati': hasCati,
      'hasJenerator': hasJenerator,
      'hasElektrik': hasElektrik,
      'hasTrafo': hasTrafo,
      'hasDepo': hasDepo,
      'hasCop': hasCop,
      'hasSiginak': hasSiginak,
      'hasDuvar': hasDuvar,
      'isHicbiri': isHicbiri,
    };
  }

  factory Bolum7Model.fromMap(Map<String, dynamic> map) {
    return Bolum7Model(
      hasOtopark: map['hasOtopark'] ?? false,
      hasKazan: map['hasKazan'] ?? false,
      hasAsansor: map['hasAsansor'] ?? false,
      hasCati: map['hasCati'] ?? false,
      hasJenerator: map['hasJenerator'] ?? false,
      hasElektrik: map['hasElektrik'] ?? false,
      hasTrafo: map['hasTrafo'] ?? false,
      hasDepo: map['hasDepo'] ?? false,
      hasCop: map['hasCop'] ?? false,
      hasSiginak: map['hasSiginak'] ?? false,
      hasDuvar: map['hasDuvar'] ?? false,
      isHicbiri: map['isHicbiri'] ?? false,
    );
  }
}