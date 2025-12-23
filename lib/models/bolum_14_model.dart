class Bolum14Model {
  final int valGerekenDuvarDk;
  final int valGerekenKapakDk;
  final String resDuvarRaporMesaji;

  Bolum14Model({
    this.valGerekenDuvarDk = 0,
    this.valGerekenKapakDk = 0,
    this.resDuvarRaporMesaji = '',
  });

  Bolum14Model copyWith({
    int? valGerekenDuvarDk,
    int? valGerekenKapakDk,
    String? resDuvarRaporMesaji,
  }) {
    return Bolum14Model(
      valGerekenDuvarDk: valGerekenDuvarDk ?? this.valGerekenDuvarDk,
      valGerekenKapakDk: valGerekenKapakDk ?? this.valGerekenKapakDk,
      resDuvarRaporMesaji: resDuvarRaporMesaji ?? this.resDuvarRaporMesaji,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'val_gereken_duvar_dk': valGerekenDuvarDk,
      'val_gereken_kapak_dk': valGerekenKapakDk,
      'res_duvar_rapor_mesaji': resDuvarRaporMesaji,
    };
  }

  factory Bolum14Model.fromMap(Map<String, dynamic> map) {
    return Bolum14Model(
      valGerekenDuvarDk: map['val_gereken_duvar_dk'] ?? 0,
      valGerekenKapakDk: map['val_gereken_kapak_dk'] ?? 0,
      resDuvarRaporMesaji: map['res_duvar_rapor_mesaji'] ?? '',
    );
  }
}