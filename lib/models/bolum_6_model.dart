// lib/models/bolum_6_model.dart

/// Otoparkın dış havayla temas durumunu temsil eder.
enum OtoparkAciklikTipi {
  /// A) Hayır, tamamen kapalı.
  tamamenKapali,

  /// B) Evet, karşılıklı iki cephesi tamamen açık...
  karsilikliAcik,

  /// C) Evet, sadece tek bir cephesinde...
  tekCepheAcik,
}

class Bolum6Model {
  //--- ADIM 1 GİRDİLERİ (Checkbox'lar) ---//

  /// A) Binanın altında otopark var mı?
  final bool hasOtoparkGenel;

  /// B) Ticari alan var mı?
  final bool hasTicari;

  /// C) Konut sakinlerine ait depo alanı var mı?
  final bool hasDepo;
  // Not: "D) Hiçbiri yok" şıkkı, yukarıdaki üç değerin de 'false' olmasıyla temsil edilir.

  //--- ADIM 2 GİRDİSİ (Radio Butonlar) ---//

  /// Kullanıcının otoparkın açıklık tipi için yaptığı seçim.
  final OtoparkAciklikTipi? otoparkAciklikTipi;

  //--- HESAPLANMIŞ DEĞERLER (GETTERS) ---//

  /// Otoparkın "YARI AÇIK" statüsünde olup olmadığını belirler.
  bool get isYariAcik {
    // Sadece otopark varsa ve tipi 'karsilikliAcik' ise true döner.
    if (!hasOtoparkGenel) return false;
    return otoparkAciklikTipi == OtoparkAciklikTipi.karsilikliAcik;
  }

  /// Otopark statüsünü metin olarak döndürür.
  String? get otoparkStatus {
    if (!hasOtoparkGenel || otoparkAciklikTipi == null) return null;
    return isYariAcik ? "YARI AÇIK OTOPARK" : "KAPALI OTOPARK";
  }

  //--- STANDART MODEL FONKSİYONLARI ---//

  Bolum6Model({
    this.hasOtoparkGenel = false,
    this.hasTicari = false,
    this.hasDepo = false,
    this.otoparkAciklikTipi,
  });

  Bolum6Model copyWith({
    bool? hasOtoparkGenel,
    bool? hasTicari,
    bool? hasDepo,
    OtoparkAciklikTipi? otoparkAciklikTipi,
  }) {
    return Bolum6Model(
      hasOtoparkGenel: hasOtoparkGenel ?? this.hasOtoparkGenel,
      hasTicari: hasTicari ?? this.hasTicari,
      hasDepo: hasDepo ?? this.hasDepo,
      otoparkAciklikTipi: otoparkAciklikTipi ?? this.otoparkAciklikTipi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'has_otopark_genel': hasOtoparkGenel,
      'has_ticari': hasTicari,
      'has_depo': hasDepo,
      'otopark_aciklik_tipi': otoparkAciklikTipi?.name,
    };
  }

  factory Bolum6Model.fromMap(Map<String, dynamic> map) {
    return Bolum6Model(
      hasOtoparkGenel: map['has_otopark_genel'] ?? false,
      hasTicari: map['has_ticari'] ?? false,
      hasDepo: map['has_depo'] ?? false,
      otoparkAciklikTipi: map['otopark_aciklik_tipi'] != null
          ? OtoparkAciklikTipi.values.byName(map['otopark_aciklik_tipi'])
          : null,
    );
  }
}