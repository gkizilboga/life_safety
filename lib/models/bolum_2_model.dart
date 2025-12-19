// lib/models/bolum_2_model.dart

/// Binanın ana taşıyıcı sistem türlerini temsil eder. Bunlar nihai değerlerdir.
enum TasiyiciSistem {
  betonarme,
  celik,
  ahsap,
  yigma,
}

/// Kullanıcının ekranda yaptığı seçimi temsil eder (Bilmiyorum dahil).
enum TasiyiciSistemSecim {
  betonarme,
  celik,
  ahsap,
  yigma,
  bilmiyorum,
}

class Bolum2Model {
  /// Kullanıcının A, B, C, D veya E şıklarından hangisini seçtiğini tutar.
  final TasiyiciSistemSecim? secim;

  Bolum2Model({
    this.secim,
  });

  /// "Bilmiyorum" seçilse bile, sistemin kullanacağı nihai taşıyıcı sistem.
  /// Word dosyasındaki kurala göre "Bilmiyorum" seçilirse otomatik olarak
  /// Betonarme varsayılır.
  TasiyiciSistem? get efektifTasiyiciSistem {
    if (secim == null) return null;
    switch (secim!) {
      case TasiyiciSistemSecim.betonarme:
      case TasiyiciSistemSecim.bilmiyorum: // Kural burada uygulanıyor!
        return TasiyiciSistem.betonarme;
      case TasiyiciSistemSecim.celik:
        return TasiyiciSistem.celik;
      case TasiyiciSistemSecim.ahsap:
        return TasiyiciSistem.ahsap;
      case TasiyiciSistemSecim.yigma:
        return TasiyiciSistem.yigma;
    }
  }

  /// Ekrana "Bilgilendirme" pop-up'ı gösterilip gösterilmeyeceğini belirler.
  bool get bilgilendirmeGerekli => secim == TasiyiciSistemSecim.bilmiyorum;

  Bolum2Model copyWith({
    TasiyiciSistemSecim? secim,
  }) {
    return Bolum2Model(
      secim: secim ?? this.secim,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'secim': secim?.name,
    };
  }

  factory Bolum2Model.fromMap(Map<String, dynamic> map) {
    return Bolum2Model(
      secim: map['secim'] != null
          ? TasiyiciSistemSecim.values.byName(map['secim'])
          : null,
    );
  }
}