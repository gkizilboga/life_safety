// lib/models/bolum_1_model.dart

/// Kullanıcının yapı ruhsat tarihi için yaptığı seçimi temsil eder.
enum RuhsatTarihiSecim {
  /// A) 19.12.2007 ve sonrasında alınmıştır (YENİ BİNA).
  sonrasiNet,

  /// B) 19.12.2007 öncesinde alınmıştır (MEVCUT BİNA).
  oncesiNet,

  /// C) Net olarak bilmiyorum ancak 2007 yılı sonrası alındığını tahmin ediyorum.
  sonrasiTahmin,

  /// D) Net olarak bilmiyorum ancak 2007 yılı veya öncesinde alındığını tahmin ediyorum.
  oncesiTahmin,
}

class Bolum1Model {
  /// Kullanıcının A, B, C veya D şıklarından hangisini seçtiğini tutar.
  final RuhsatTarihiSecim? secim;

  Bolum1Model({
    this.secim,
  });

  /// Seçime göre binanın YENİ mi ESKİ mi olduğuna karar veren hesaplanmış özellik.
  /// Bu sayede UI kodunda if/else yazmakla uğraşmayız.
  bool? get isYeniBina {
    if (secim == null) return null;
    switch (secim!) {
      case RuhsatTarihiSecim.sonrasiNet:
      case RuhsatTarihiSecim.sonrasiTahmin:
        return true;
      case RuhsatTarihiSecim.oncesiNet:
      case RuhsatTarihiSecim.oncesiTahmin:
        return false;
    }
  }

  Bolum1Model copyWith({
    RuhsatTarihiSecim? secim,
  }) {
    return Bolum1Model(
      secim: secim ?? this.secim,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // enum'ı okunabilir bir metin olarak kaydediyoruz.
      'secim': secim?.name,
    };
  }

  factory Bolum1Model.fromMap(Map<String, dynamic> map) {
    return Bolum1Model(
      // Metni tekrar enum'a çeviriyoruz.
      secim: map['secim'] != null
          ? RuhsatTarihiSecim.values.byName(map['secim'])
          : null,
    );
  }
}