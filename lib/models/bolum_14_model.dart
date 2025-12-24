class Bolum14Model {
  final int? gerekenDuvarDk;
  final int? gerekenKapakDk;
  final String? raporMesaji;

  Bolum14Model({
    this.gerekenDuvarDk,
    this.gerekenKapakDk,
    this.raporMesaji,
  });

  Map<String, dynamic> toMap() {
    return {
      'gerekenDuvarDk': gerekenDuvarDk,
      'gerekenKapakDk': gerekenKapakDk,
      'raporMesaji': raporMesaji,
    };
  }

  factory Bolum14Model.fromMap(Map<String, dynamic> map) {
    return Bolum14Model(
      gerekenDuvarDk: map['gerekenDuvarDk'],
      gerekenKapakDk: map['gerekenKapakDk'],
      raporMesaji: map['raporMesaji'],
    );
  }
}