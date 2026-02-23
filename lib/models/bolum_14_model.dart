import 'choice_result.dart'; // BU SATIRI EKLE

class Bolum14Model {
  final int? gerekenDuvarDk;
  final int? gerekenKapakDk;
  final String? raporMesaji;

  // Rapor motorunun bu hesaplama sonucunu anlayabilmesi için "secim" olarak paketliyoruz
  ChoiceResult? get secim => ChoiceResult(
    label: "14-Analiz",
    uiTitle: "Şaft Kapak Analizi",
    uiSubtitle: "Otomatik hesaplanan dayanım süreleri", // BU SATIRI EKLEDİK
    reportText: raporMesaji ?? "",
  );

  Bolum14Model({this.gerekenDuvarDk, this.gerekenKapakDk, this.raporMesaji});

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
