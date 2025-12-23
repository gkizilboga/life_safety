import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

enum CikisKapiTipi { tekKanat, ciftKanat }

class Bolum36Model {
  // Ön Hesaplama Sonuçları (Rapor için)
  final int? calcToplamCikisSayisi;
  final bool? isDonerMerdivenElendi;
  final bool? isDisCelikMerdivenElendi;

  // Kullanıcı Cevapları
  final ChoiceResult? resDisMerdivenMesafe;
  final ChoiceResult? resMerdivenKonum;
  final double? valKoridorGenislik;
  final CikisKapiTipi? resCikisKapiTipi;
  final double? valCikisKapiGenislik;
  final ChoiceResult? resCikisGorunurluk;

  Bolum36Model({
    this.calcToplamCikisSayisi,
    this.isDonerMerdivenElendi,
    this.isDisCelikMerdivenElendi,
    this.resDisMerdivenMesafe,
    this.resMerdivenKonum,
    this.valKoridorGenislik,
    this.resCikisKapiTipi,
    this.valCikisKapiGenislik,
    this.resCikisGorunurluk,
  });

  Bolum36Model copyWith({
    int? calcToplamCikisSayisi,
    bool? isDonerMerdivenElendi,
    bool? isDisCelikMerdivenElendi,
    ChoiceResult? resDisMerdivenMesafe,
    ChoiceResult? resMerdivenKonum,
    double? valKoridorGenislik,
    CikisKapiTipi? resCikisKapiTipi,
    double? valCikisKapiGenislik,
    ChoiceResult? resCikisGorunurluk,
  }) {
    return Bolum36Model(
      calcToplamCikisSayisi: calcToplamCikisSayisi ?? this.calcToplamCikisSayisi,
      isDonerMerdivenElendi: isDonerMerdivenElendi ?? this.isDonerMerdivenElendi,
      isDisCelikMerdivenElendi: isDisCelikMerdivenElendi ?? this.isDisCelikMerdivenElendi,
      resDisMerdivenMesafe: resDisMerdivenMesafe ?? this.resDisMerdivenMesafe,
      resMerdivenKonum: resMerdivenKonum ?? this.resMerdivenKonum,
      valKoridorGenislik: valKoridorGenislik ?? this.valKoridorGenislik,
      resCikisKapiTipi: resCikisKapiTipi ?? this.resCikisKapiTipi,
      valCikisKapiGenislik: valCikisKapiGenislik ?? this.valCikisKapiGenislik,
      resCikisGorunurluk: resCikisGorunurluk ?? this.resCikisGorunurluk,
    );
  }
}