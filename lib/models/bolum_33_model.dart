class Bolum33Model {
  // Girdiler
  final double? valAlanZemin;
  final double? valAlanNormal;
  final double? valAlanBodrum;

  // Hesaplanan Sonuçlar (Rapor için saklıyoruz)
  final int? calcYukZemin;
  final int? calcYukNormal;
  final int? calcYukBodrum;
  
  final int? calcGerekliCikisZemin;
  final int? calcGerekliCikisNormal;
  final int? calcGerekliCikisBodrum;

  final int? valMevcutCikisUst;
  final int? valMevcutCikisBodrum;

  final String? resRaporZemin;
  final String? resRaporNormal;
  final String? resRaporBodrum;

  Bolum33Model({
    this.valAlanZemin,
    this.valAlanNormal,
    this.valAlanBodrum,
    this.calcYukZemin,
    this.calcYukNormal,
    this.calcYukBodrum,
    this.calcGerekliCikisZemin,
    this.calcGerekliCikisNormal,
    this.calcGerekliCikisBodrum,
    this.valMevcutCikisUst,
    this.valMevcutCikisBodrum,
    this.resRaporZemin,
    this.resRaporNormal,
    this.resRaporBodrum,
  });

  Bolum33Model copyWith({
    double? valAlanZemin,
    double? valAlanNormal,
    double? valAlanBodrum,
    int? calcYukZemin,
    int? calcYukNormal,
    int? calcYukBodrum,
    int? calcGerekliCikisZemin,
    int? calcGerekliCikisNormal,
    int? calcGerekliCikisBodrum,
    int? valMevcutCikisUst,
    int? valMevcutCikisBodrum,
    String? resRaporZemin,
    String? resRaporNormal,
    String? resRaporBodrum,
  }) {
    return Bolum33Model(
      valAlanZemin: valAlanZemin ?? this.valAlanZemin,
      valAlanNormal: valAlanNormal ?? this.valAlanNormal,
      valAlanBodrum: valAlanBodrum ?? this.valAlanBodrum,
      calcYukZemin: calcYukZemin ?? this.calcYukZemin,
      calcYukNormal: calcYukNormal ?? this.calcYukNormal,
      calcYukBodrum: calcYukBodrum ?? this.calcYukBodrum,
      calcGerekliCikisZemin: calcGerekliCikisZemin ?? this.calcGerekliCikisZemin,
      calcGerekliCikisNormal: calcGerekliCikisNormal ?? this.calcGerekliCikisNormal,
      calcGerekliCikisBodrum: calcGerekliCikisBodrum ?? this.calcGerekliCikisBodrum,
      valMevcutCikisUst: valMevcutCikisUst ?? this.valMevcutCikisUst,
      valMevcutCikisBodrum: valMevcutCikisBodrum ?? this.valMevcutCikisBodrum,
      resRaporZemin: resRaporZemin ?? this.resRaporZemin,
      resRaporNormal: resRaporNormal ?? this.resRaporNormal,
      resRaporBodrum: resRaporBodrum ?? this.resRaporBodrum,
    );
  }
}