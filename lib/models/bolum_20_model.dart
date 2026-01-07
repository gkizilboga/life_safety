import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum20Model {
  final ChoiceResult? tekKatCikis;
  final ChoiceResult? tekKatRampa;
  final int normalMerdivenSayisi;
  final int binaIciYanginMerdiveniSayisi;
  final int binaDisiKapaliYanginMerdiveniSayisi;
  final int binaDisiAcikYanginMerdiveniSayisi;
  final int donerMerdivenSayisi;
  final int sahanliksizMerdivenSayisi;
  final ChoiceResult? basinclandirma;
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
    this.basinclandirma,
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
    ChoiceResult? basinclandirma,
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
      basinclandirma: basinclandirma ?? this.basinclandirma,
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
      'basinclandirma_label': basinclandirma?.label,
      'bodrumMerdivenDevami_label': bodrumMerdivenDevami?.label,
    };
  }

  factory Bolum20Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label) {
      if (label == null) return null;
      return [
        Bolum20Content.tekKatOptionA, Bolum20Content.rampaOptionB, Bolum20Content.rampaOptionC,
        Bolum20Content.basYghOptionA, Bolum20Content.basYghOptionB, Bolum20Content.basYghOptionC,
        Bolum20Content.bodrumOptionA, Bolum20Content.bodrumOptionB
      ].firstWhere((e) => e.label == label, orElse: () => Bolum20Content.basYghOptionB);
    }

    return Bolum20Model(
      tekKatCikis: find(map['tekKatCikis_label']),
      tekKatRampa: find(map['tekKatRampa_label']),
      normalMerdivenSayisi: map['normalMerdivenSayisi'] ?? 0,
      binaIciYanginMerdiveniSayisi: map['binaIciYanginMerdiveniSayisi'] ?? 0,
      binaDisiKapaliYanginMerdiveniSayisi: map['binaDisiKapaliYanginMerdiveniSayisi'] ?? 0,
      binaDisiAcikYanginMerdiveniSayisi: map['binaDisiAcikYanginMerdiveniSayisi'] ?? 0,
      donerMerdivenSayisi: map['donerMerdivenSayisi'] ?? 0,
      sahanliksizMerdivenSayisi: map['sahanliksizMerdivenSayisi'] ?? 0,
      basinclandirma: find(map['basinclandirma_label']),
      bodrumMerdivenDevami: find(map['bodrumMerdivenDevami_label']),
    );
  }
}