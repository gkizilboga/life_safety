// lib/models/bolum_7_model.dart

class Bolum7Model {
  //--- KULLANICI GİRDİLERİ (Checkbox'lar) ---//

  /// 1. Kapalı Otopark var mı? (Bu değer Bölüm-6'dan otomatik gelir)
  final bool hasKapaliOtopark;

  /// 2. Kazan Dairesi / Isı Merkezi var mı?
  final bool hasKazanDairesi;

  /// 3. Normal Asansör var mı?
  final bool hasAsansorNormal;

  /// 4. Asansör Makine Dairesi var mı?
  final bool hasAsansorDairesi;

  /// 5. Çatı Arası var mı?
  final bool hasCatiArasi;

  /// 6. Jeneratör Odası var mı?
  final bool hasJeneratorOdasi;

  /// 7. Elektrik Odası / Pano Odası var mı?
  final bool hasElektrikOdasi;

  /// 8. Yağlı Tip Trafo Odası var mı?
  final bool hasTrafoOdasi;

  /// 9. Ortak Depo / Ardiye / Kiler var mı?
  final bool hasDepo;

  /// 10. Çöp Odası / Çöp Şut Odası var mı?
  final bool hasCopOdasi;

  /// 11. Sığınak var mı?
  final bool hasSiginak;

  /// 12. Ortak Duvar var mı?
  final bool hasOrtakDuvar;

  //--- HESAPLANMIŞ DEĞERLER (GETTERS) ---//

  /// Kullanıcının "Hiçbiri Yok" dışında en az bir seçim yapıp yapmadığını kontrol eder.
  /// Formun geçerliliği için kullanılır.
  bool get isAnySelected {
    return hasKapaliOtopark ||
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
        hasOrtakDuvar;
  }

  //--- STANDART MODEL FONKSİYONLARI ---//

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
  });

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'has_kapali_otopark': hasKapaliOtopark,
      'has_kazan_dairesi': hasKazanDairesi,
      'has_asansor_normal': hasAsansorNormal,
      'has_asansor_dairesi': hasAsansorDairesi,
      'has_cati_arasi': hasCatiArasi,
      'has_jenerator_odasi': hasJeneratorOdasi,
      'has_elektrik_odasi': hasElektrikOdasi,
      'has_trafo_odasi': hasTrafoOdasi,
      'has_depo': hasDepo,
      'has_cop_odasi': hasCopOdasi,
      'has_siginak': hasSiginak,
      'has_ortak_duvar': hasOrtakDuvar,
    };
  }

  factory Bolum7Model.fromMap(Map<String, dynamic> map) {
    return Bolum7Model(
      hasKapaliOtopark: map['has_kapali_otopark'] ?? false,
      hasKazanDairesi: map['has_kazan_dairesi'] ?? false,
      hasAsansorNormal: map['has_asansor_normal'] ?? false,
      hasAsansorDairesi: map['has_asansor_dairesi'] ?? false,
      hasCatiArasi: map['has_cati_arasi'] ?? false,
      hasJeneratorOdasi: map['has_jenerator_odasi'] ?? false,
      hasElektrikOdasi: map['has_elektrik_odasi'] ?? false,
      hasTrafoOdasi: map['has_trafo_odasi'] ?? false,
      hasDepo: map['has_depo'] ?? false,
      hasCopOdasi: map['has_cop_odasi'] ?? false,
      hasSiginak: map['has_siginak'] ?? false,
      hasOrtakDuvar: map['has_ortak_duvar'] ?? false,
    );
  }
}