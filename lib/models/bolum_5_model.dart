// lib/models/bolum_5_model.dart

class Bolum5Model {
  //--- KULLANICI GİRDİLERİ ---//

  /// Binanın zemine oturduğu taban alanı (m²).
  final double? alanOturum;

  /// Standart bir kattaki toplam brüt alan (m²).
  final double? alanKatBrut;

  /// Binanın toplam inşaat alanı (m²).
  final double? alanToplamInsaat;

  //--- HESAPLANMIŞ DEĞERLER VE DOĞRULAMA (GETTERS) ---//

  /// A) Boş alan kontrolü: Tüm alanların girilip girilmediğini kontrol eder.
  bool get isAlanlarGirildi {
    return (alanOturum ?? 0) > 0 &&
        (alanKatBrut ?? 0) > 0 &&
        (alanToplamInsaat ?? 0) > 0;
  }

  /// B) Mantık hatası kontrolü: Alanların birbiriyle tutarlı olup olmadığını kontrol eder.
  bool get isMantiksalHataYok {
    // Önce alanların girildiğinden emin ol, sonra mantık kontrolü yap.
    if (!isAlanlarGirildi) return true; // Henüz hata yok.
    return alanToplamInsaat! >= alanOturum! &&
        alanToplamInsaat! >= alanKatBrut!;
  }

  /// Tüm doğrulamaların geçerli olup olmadığını belirten ana kontrolcü.
  bool get isFormGecerli => isAlanlarGirildi && isMantiksalHataYok;

  /// UI'da gösterilecek spesifik hata mesajını döndürür.
  String? get hataMesaji {
    if (!isAlanlarGirildi) {
      return "Doğru analiz için lütfen tüm alan bilgilerini giriniz.";
    }
    if (!isMantiksalHataYok) {
      return "Hatalı Giriş: Oturum alanı veya kat alanı, toplam inşaat alanından büyük olamaz.";
    }
    return null; // Hata yoksa null döner.
  }

  //--- STANDART MODEL FONKSİYONLARI ---//

  Bolum5Model({
    this.alanOturum,
    this.alanKatBrut,
    this.alanToplamInsaat,
  });

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