// lib/models/bolum_8_model.dart

/// Binanın yapılaşma nizamını (bitişik veya ayrık) temsil eder.
enum NizamDurumu {
  /// A) Ayrık Nizam
  ayrik,

  /// B) Bitişik Nizam
  bitisik,
}

class Bolum8Model {
  /// Kullanıcının yaptığı nizam durumu seçimi.
  final NizamDurumu? secim;

  //--- STANDART MODEL FONKSİYONLARI ---//

  Bolum8Model({
    this.secim,
  });

  Bolum8Model copyWith({
    NizamDurumu? secim,
  }) {
    return Bolum8Model(
      secim: secim ?? this.secim,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'secim': secim?.name,
    };
  }

  factory Bolum8Model.fromMap(Map<String, dynamic> map) {
    return Bolum8Model(
      secim: map['secim'] != null
          ? NizamDurumu.values.byName(map['secim'])
          : null,
    );
  }
}