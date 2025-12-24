import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum20Model {
  // Tek Katlı Bina İse
  final ChoiceResult? tekKatCikis;
  final ChoiceResult? tekKatRampa;

  // Çok Katlı Bina İse (Sayısal Girişler)
  final int normalMerdivenSayisi;
  final int binaIciYanginMerdiveniSayisi;
  final int binaDisiKapaliYanginMerdiveniSayisi;
  final int binaDisiAcikYanginMerdiveniSayisi;
  final int donerMerdivenSayisi;
  final int sahanliksizMerdivenSayisi;

  // Bodrum Varsa (Bölüm 3'ten gelen bilgiye göre)
  final ChoiceResult? bodrumMerdivenDevami;

  Bolum20Model({
    this.tekKatCikis,
    this.tekKatRampa,
    this.normalMerdivenSayisi = 0,
    this.binaIciYanginMerdiveniSayisi = 0,
    this.binaDisiKapaliYanginMerdiveniSayisi = 0,
    this.binaDisiAcikYanginMerdiveniSayisi = 0,
    this.donerMerdivenSayisi = 0,
    this.sahanliksizMerdivenSayisi = 0,
    this.bodrumMerdivenDevami,
  });

  Bolum20Model copyWith({
    ChoiceResult? tekKatCikis,
    ChoiceResult? tekKatRampa,
    int? normalMerdivenSayisi,
    int? binaIciYanginMerdiveniSayisi,
    int? binaDisiKapaliYanginMerdiveniSayisi,
    int? binaDisiAcikYanginMerdiveniSayisi,
    int? donerMerdivenSayisi,
    int? sahanliksizMerdivenSayisi,
    ChoiceResult? bodrumMerdivenDevami,
  }) {
    return Bolum20Model(
      tekKatCikis: tekKatCikis ?? this.tekKatCikis,
      tekKatRampa: tekKatRampa ?? this.tekKatRampa,
      normalMerdivenSayisi: normalMerdivenSayisi ?? this.normalMerdivenSayisi,
      binaIciYanginMerdiveniSayisi: binaIciYanginMerdiveniSayisi ?? this.binaIciYanginMerdiveniSayisi,
      binaDisiKapaliYanginMerdiveniSayisi: binaDisiKapaliYanginMerdiveniSayisi ?? this.binaDisiKapaliYanginMerdiveniSayisi,
      binaDisiAcikYanginMerdiveniSayisi: binaDisiAcikYanginMerdiveniSayisi ?? this.binaDisiAcikYanginMerdiveniSayisi,
      donerMerdivenSayisi: donerMerdivenSayisi ?? this.donerMerdivenSayisi,
      sahanliksizMerdivenSayisi: sahanliksizMerdivenSayisi ?? this.sahanliksizMerdivenSayisi,
      bodrumMerdivenDevami: bodrumMerdivenDevami ?? this.bodrumMerdivenDevami,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tekKatCikis_label': tekKatCikis?.label,
      'tekKatRampa_label': tekKatRampa?.label,
      'normalMerdivenSayisi': normalMerdivenSayisi,
      'binaIciYanginMerdiveniSayisi': binaIciYanginMerdiveniSayisi,
      'binaDisiKapaliYanginMerdiveniSayisi': binaDisiKapaliYanginMerdiveniSayisi,
      'binaDisiAcikYanginMerdiveniSayisi': binaDisiAcikYanginMerdiveniSayisi,
      'donerMerdivenSayisi': donerMerdivenSayisi,
      'sahanliksizMerdivenSayisi': sahanliksizMerdivenSayisi,
      'bodrumMerdivenDevami_label': bodrumMerdivenDevami?.label,
    };
  }

  factory Bolum20Model.fromMap(Map<String, dynamic> map) {
    // Tek Kat Çıkış
    ChoiceResult? tk;
    if (map['tekKatCikis_label'] == Bolum20Content.tekKatOptionA.label) tk = Bolum20Content.tekKatOptionA;

    // Tek Kat Rampa
    ChoiceResult? tr;
    if (map['tekKatRampa_label'] == Bolum20Content.rampaOptionB.label) tr = Bolum20Content.rampaOptionB;
    if (map['tekKatRampa_label'] == Bolum20Content.rampaOptionC.label) tr = Bolum20Content.rampaOptionC;

    // Bodrum Devamı
    ChoiceResult? bd;
    if (map['bodrumMerdivenDevami_label'] == Bolum20Content.bodrumOptionA.label) bd = Bolum20Content.bodrumOptionA;
    if (map['bodrumMerdivenDevami_label'] == Bolum20Content.bodrumOptionB.label) bd = Bolum20Content.bodrumOptionB;

    return Bolum20Model(
      tekKatCikis: tk,
      tekKatRampa: tr,
      normalMerdivenSayisi: map['normalMerdivenSayisi'] ?? 0,
      binaIciYanginMerdiveniSayisi: map['binaIciYanginMerdiveniSayisi'] ?? 0,
      binaDisiKapaliYanginMerdiveniSayisi: map['binaDisiKapaliYanginMerdiveniSayisi'] ?? 0,
      binaDisiAcikYanginMerdiveniSayisi: map['binaDisiAcikYanginMerdiveniSayisi'] ?? 0,
      donerMerdivenSayisi: map['donerMerdivenSayisi'] ?? 0,
      sahanliksizMerdivenSayisi: map['sahanliksizMerdivenSayisi'] ?? 0,
      bodrumMerdivenDevami: bd,
    );
  }
}