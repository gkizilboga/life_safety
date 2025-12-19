// lib/models/bolum_9_model.dart

/// Kullanıcının sprinkler sistemi varlığı için yaptığı seçimi temsil eder.
enum SprinklerDurumuSecim {
  /// A) Evet, tüm binada var.
  tamamenVar,

  /// B) Hayır, hiçbir yerde yok.
  hicYok,

  /// C) Kısmen var. (Sadece bazı katlarda / bazı mahallerde)
  kismenVar,
}

class Bolum9Model {
  /// Kullanıcının A, B veya C şıklarından hangisini seçtiğini tutar.
  final SprinklerDurumuSecim? secim;

  /// Projenin genelinde kullanılacak olan nihai boolean (Evet/Hayır) değeri.
  /// Kritik Kural: Sadece 'tamamenVar' seçeneği true kabul edilir.
  bool get hasSprinkler {
    if (secim == null) return false;
    return secim == SprinklerDurumuSecim.tamamenVar;
  }

  //--- STANDART MODEL FONKSİYONLARI ---//

  Bolum9Model({
    this.secim,
  });

  Bolum9Model copyWith({
    SprinklerDurumuSecim? secim,
  }) {
    return Bolum9Model(
      secim: secim ?? this.secim,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'secim': secim?.name,
    };
  }

  factory Bolum9Model.fromMap(Map<String, dynamic> map) {
    return Bolum9Model(
      secim: map['secim'] != null
          ? SprinklerDurumuSecim.values.byName(map['secim'])
          : null,
    );
  }
}