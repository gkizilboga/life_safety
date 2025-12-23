import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

enum KazanKapasiteYontem { tahmini, sayisal }

class Bolum30Model {
  ChoiceResult? resKazanKonum;
  KazanKapasiteYontem? resKazanKapasiteYontem;
  
  // Yöntem 1: Tahmini
  ChoiceResult? resKazanTahminAlan;
  ChoiceResult? resKazanTahminGuc;
  
  // Yöntem 2: Sayısal
  double? valKazanAlan;
  double? valKazanGuc;

  ChoiceResult? resKazanKapiSayisi;
  ChoiceResult? resKazanHavalandirma;
  ChoiceResult? resKazanYakitTipi;
  ChoiceResult? resKazanDrenaj; // Alt Soru
  ChoiceResult? resKazanYanginTupu;

  Bolum30Model({
    this.resKazanKonum,
    this.resKazanKapasiteYontem,
    this.resKazanTahminAlan,
    this.resKazanTahminGuc,
    this.valKazanAlan,
    this.valKazanGuc,
    this.resKazanKapiSayisi,
    this.resKazanHavalandirma,
    this.resKazanYakitTipi,
    this.resKazanDrenaj,
    this.resKazanYanginTupu,
  });

  // BÜYÜK KAZAN HESABI (Logic)
  bool get isBuyukKazan {
    if (resKazanKapasiteYontem == KazanKapasiteYontem.tahmini) {
      // A1 (Evet) veya B1 (Evet) seçildiyse büyüktür
      return (resKazanTahminAlan?.label == "A1") || (resKazanTahminGuc?.label == "B1");
    } else if (resKazanKapasiteYontem == KazanKapasiteYontem.sayisal) {
      return (valKazanAlan ?? 0) > 100 || (valKazanGuc ?? 0) > 350;
    }
    return false;
  }

  Bolum30Model copyWith({
    ChoiceResult? resKazanKonum,
    KazanKapasiteYontem? resKazanKapasiteYontem,
    ChoiceResult? resKazanTahminAlan,
    ChoiceResult? resKazanTahminGuc,
    double? valKazanAlan,
    double? valKazanGuc,
    ChoiceResult? resKazanKapiSayisi,
    ChoiceResult? resKazanHavalandirma,
    ChoiceResult? resKazanYakitTipi,
    ChoiceResult? resKazanDrenaj,
    ChoiceResult? resKazanYanginTupu,
  }) {
    return Bolum30Model(
      resKazanKonum: resKazanKonum ?? this.resKazanKonum,
      resKazanKapasiteYontem: resKazanKapasiteYontem ?? this.resKazanKapasiteYontem,
      resKazanTahminAlan: resKazanTahminAlan ?? this.resKazanTahminAlan,
      resKazanTahminGuc: resKazanTahminGuc ?? this.resKazanTahminGuc,
      valKazanAlan: valKazanAlan ?? this.valKazanAlan,
      valKazanGuc: valKazanGuc ?? this.valKazanGuc,
      resKazanKapiSayisi: resKazanKapiSayisi ?? this.resKazanKapiSayisi,
      resKazanHavalandirma: resKazanHavalandirma ?? this.resKazanHavalandirma,
      resKazanYakitTipi: resKazanYakitTipi ?? this.resKazanYakitTipi,
      resKazanDrenaj: resKazanDrenaj ?? this.resKazanDrenaj,
      resKazanYanginTupu: resKazanYanginTupu ?? this.resKazanYanginTupu,
    );
  }
}