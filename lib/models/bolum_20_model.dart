enum TekKatCikisSecim { duzAyak, rampa, merdiven }
enum BodrumDevamSecim { evetDevam, hayirAyri }
enum RampaSecim { evet, hayir }

class Bolum20Model {
  // Durum A (Tek Katlı)
  final TekKatCikisSecim? resTekKatCikis;

  // Durum B (Çok Katlı - Sayaçlar)
  final int cntNormalMerdiven;
  final int cntYanginMerdiveniBeton;
  final int cntYanginMerdiveniCelik;
  final int cntDisCelikMerdiven;
  final int cntDonerMerdiven;
  final int cntSahanliksizMerdiven;

  // Ek Sorular
  final BodrumDevamSecim? resBodrumMerdivenDevam;
  final RampaSecim? resRampaVarMi;

  Bolum20Model({
    this.resTekKatCikis,
    this.cntNormalMerdiven = 0,
    this.cntYanginMerdiveniBeton = 0,
    this.cntYanginMerdiveniCelik = 0,
    this.cntDisCelikMerdiven = 0,
    this.cntDonerMerdiven = 0,
    this.cntSahanliksizMerdiven = 0,
    this.resBodrumMerdivenDevam,
    this.resRampaVarMi,
  });

  // --- HESAPLANAN BAYRAKLAR (FLAGS) ---
  
  bool get hasNormalMerdiven => cntNormalMerdiven > 0;

  bool get hasYanginMerdiveni => 
      (cntYanginMerdiveniBeton + cntYanginMerdiveniCelik + cntDisCelikMerdiven) > 0;

  String get merdivenTipi {
    if (cntDonerMerdiven > 0) return 'DONER';
    if (cntSahanliksizMerdiven > 0) return 'SAHANLIKSIZ';
    return 'STANDART';
  }

  int get toplamMerdivenSayisi => 
      cntNormalMerdiven + 
      cntYanginMerdiveniBeton + 
      cntYanginMerdiveniCelik + 
      cntDisCelikMerdiven + 
      cntDonerMerdiven + 
      cntSahanliksizMerdiven;

  Bolum20Model copyWith({
    TekKatCikisSecim? resTekKatCikis,
    int? cntNormalMerdiven,
    int? cntYanginMerdiveniBeton,
    int? cntYanginMerdiveniCelik,
    int? cntDisCelikMerdiven,
    int? cntDonerMerdiven,
    int? cntSahanliksizMerdiven,
    BodrumDevamSecim? resBodrumMerdivenDevam,
    RampaSecim? resRampaVarMi,
  }) {
    return Bolum20Model(
      resTekKatCikis: resTekKatCikis ?? this.resTekKatCikis,
      cntNormalMerdiven: cntNormalMerdiven ?? this.cntNormalMerdiven,
      cntYanginMerdiveniBeton: cntYanginMerdiveniBeton ?? this.cntYanginMerdiveniBeton,
      cntYanginMerdiveniCelik: cntYanginMerdiveniCelik ?? this.cntYanginMerdiveniCelik,
      cntDisCelikMerdiven: cntDisCelikMerdiven ?? this.cntDisCelikMerdiven,
      cntDonerMerdiven: cntDonerMerdiven ?? this.cntDonerMerdiven,
      cntSahanliksizMerdiven: cntSahanliksizMerdiven ?? this.cntSahanliksizMerdiven,
      resBodrumMerdivenDevam: resBodrumMerdivenDevam ?? this.resBodrumMerdivenDevam,
      resRampaVarMi: resRampaVarMi ?? this.resRampaVarMi,
    );
  }
}