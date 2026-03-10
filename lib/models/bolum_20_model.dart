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
  final int dengelenmisMerdivenSayisi;

  // Madde 41: Toplam kaç tanesi direkt dışarı açılıyor?
  final int toplamDisariAcilanMerdivenSayisi; // NEW simplified field

  final ChoiceResult?
  lobiTahliyeMesafeDurumu; // Upper floors: above/below/unknown limit

  // Independent Basement Stairs
  final bool isBodrumIndependent;
  final int bodrumNormalMerdivenSayisi;
  final int bodrumBinaIciYanginMerdiveniSayisi;
  final int bodrumBinaDisiKapaliYanginMerdiveniSayisi;
  final int bodrumBinaDisiAcikYanginMerdiveniSayisi;
  final int bodrumDonerMerdivenSayisi;
  final int bodrumSahanliksizMerdivenSayisi;
  final int bodrumDengelenmisMerdivenSayisi;

  // Madde 41 (Bodrum): Toplam kaç tanesi direkt dışarı açılıyor?
  final int bodrumToplamDisariAcilanMerdivenSayisi; // NEW simplified field

  final ChoiceResult?
  bodrumLobiTahliyeMesafeDurumu; // Basement: above/below/unknown limit

  final ChoiceResult? bodrumMerdivenDevami;
  final ChoiceResult? basinclandirma;
  final ChoiceResult? havalandirma; // NEW - Madde 45

  // --- Computed Properties (Single Source of Truth) ---

  /// Binada dairesel (spiral) merdiven var mı?
  /// Ana katlarda veya bağımsız bodrumda dairesel merdiven kontrolü.
  bool get hasDaireselMerdiven =>
      donerMerdivenSayisi > 0 ||
      (isBodrumIndependent && bodrumDonerMerdivenSayisi > 0);

  Bolum20Model({
    this.tekKatCikis,
    this.tekKatRampa,
    this.normalMerdivenSayisi = 0,
    this.binaIciYanginMerdiveniSayisi = 0,
    this.binaDisiKapaliYanginMerdiveniSayisi = 0,
    this.binaDisiAcikYanginMerdiveniSayisi = 0,
    this.donerMerdivenSayisi = 0,
    this.sahanliksizMerdivenSayisi = 0,
    this.dengelenmisMerdivenSayisi = 0,

    this.toplamDisariAcilanMerdivenSayisi = 0, // NEW
    this.lobiTahliyeMesafeDurumu,
    this.isBodrumIndependent = false,
    this.bodrumMerdivenDevami,
    this.bodrumNormalMerdivenSayisi = 0,
    this.bodrumBinaIciYanginMerdiveniSayisi = 0,
    this.bodrumBinaDisiKapaliYanginMerdiveniSayisi = 0,
    this.bodrumBinaDisiAcikYanginMerdiveniSayisi = 0,
    this.bodrumDonerMerdivenSayisi = 0,
    this.bodrumSahanliksizMerdivenSayisi = 0,
    this.bodrumDengelenmisMerdivenSayisi = 0,

    this.bodrumToplamDisariAcilanMerdivenSayisi = 0, // NEW
    this.bodrumLobiTahliyeMesafeDurumu,

    this.basinclandirma,
    this.havalandirma, // NEW - Madde 45
  });

  // No longer needed, using stored fields directly
  // int get totalDirectExits => ...
  // int get totalBasementDirectExits => ...

  Bolum20Model copyWith({
    ChoiceResult? tekKatCikis,
    ChoiceResult? tekKatRampa,
    int? normalMerdivenSayisi,
    int? binaIciYanginMerdiveniSayisi,
    int? binaDisiKapaliYanginMerdiveniSayisi,
    int? binaDisiAcikYanginMerdiveniSayisi,
    int? donerMerdivenSayisi,
    int? sahanliksizMerdivenSayisi,
    int? dengelenmisMerdivenSayisi,
    int? toplamDisariAcilanMerdivenSayisi, // NEW
    ChoiceResult? lobiTahliyeMesafeDurumu,
    bool? isBodrumIndependent,
    ChoiceResult? bodrumMerdivenDevami,
    int? bodrumNormalMerdivenSayisi,
    int? bodrumBinaIciYanginMerdiveniSayisi,
    int? bodrumBinaDisiKapaliYanginMerdiveniSayisi,
    int? bodrumBinaDisiAcikYanginMerdiveniSayisi,
    int? bodrumDonerMerdivenSayisi,
    int? bodrumSahanliksizMerdivenSayisi,
    int? bodrumDengelenmisMerdivenSayisi,
    int? bodrumToplamDisariAcilanMerdivenSayisi, // NEW
    ChoiceResult? bodrumLobiTahliyeMesafeDurumu,
    ChoiceResult? basinclandirma,
    ChoiceResult? havalandirma, // NEW - Madde 45
  }) {
    return Bolum20Model(
      tekKatCikis: tekKatCikis ?? this.tekKatCikis,
      tekKatRampa: tekKatRampa ?? this.tekKatRampa,
      normalMerdivenSayisi: normalMerdivenSayisi ?? this.normalMerdivenSayisi,
      binaIciYanginMerdiveniSayisi:
          binaIciYanginMerdiveniSayisi ?? this.binaIciYanginMerdiveniSayisi,
      binaDisiKapaliYanginMerdiveniSayisi:
          binaDisiKapaliYanginMerdiveniSayisi ??
          this.binaDisiKapaliYanginMerdiveniSayisi,
      binaDisiAcikYanginMerdiveniSayisi:
          binaDisiAcikYanginMerdiveniSayisi ??
          this.binaDisiAcikYanginMerdiveniSayisi,
      donerMerdivenSayisi: donerMerdivenSayisi ?? this.donerMerdivenSayisi,
      sahanliksizMerdivenSayisi:
          sahanliksizMerdivenSayisi ?? this.sahanliksizMerdivenSayisi,
      dengelenmisMerdivenSayisi:
          dengelenmisMerdivenSayisi ?? this.dengelenmisMerdivenSayisi,

      toplamDisariAcilanMerdivenSayisi:
          toplamDisariAcilanMerdivenSayisi ??
          this.toplamDisariAcilanMerdivenSayisi,
      lobiTahliyeMesafeDurumu:
          lobiTahliyeMesafeDurumu ?? this.lobiTahliyeMesafeDurumu,
      isBodrumIndependent: isBodrumIndependent ?? this.isBodrumIndependent,
      bodrumMerdivenDevami: bodrumMerdivenDevami ?? this.bodrumMerdivenDevami,
      bodrumNormalMerdivenSayisi:
          bodrumNormalMerdivenSayisi ?? this.bodrumNormalMerdivenSayisi,
      bodrumBinaIciYanginMerdiveniSayisi:
          bodrumBinaIciYanginMerdiveniSayisi ??
          this.bodrumBinaIciYanginMerdiveniSayisi,
      bodrumBinaDisiKapaliYanginMerdiveniSayisi:
          bodrumBinaDisiKapaliYanginMerdiveniSayisi ??
          this.bodrumBinaDisiKapaliYanginMerdiveniSayisi,
      bodrumBinaDisiAcikYanginMerdiveniSayisi:
          bodrumBinaDisiAcikYanginMerdiveniSayisi ??
          this.bodrumBinaDisiAcikYanginMerdiveniSayisi,
      bodrumDonerMerdivenSayisi:
          bodrumDonerMerdivenSayisi ?? this.bodrumDonerMerdivenSayisi,
      bodrumSahanliksizMerdivenSayisi:
          bodrumSahanliksizMerdivenSayisi ??
          this.bodrumSahanliksizMerdivenSayisi,
      bodrumDengelenmisMerdivenSayisi:
          bodrumDengelenmisMerdivenSayisi ??
          this.bodrumDengelenmisMerdivenSayisi,

      bodrumToplamDisariAcilanMerdivenSayisi:
          bodrumToplamDisariAcilanMerdivenSayisi ??
          this.bodrumToplamDisariAcilanMerdivenSayisi,
      bodrumLobiTahliyeMesafeDurumu:
          bodrumLobiTahliyeMesafeDurumu ?? this.bodrumLobiTahliyeMesafeDurumu,
      basinclandirma: basinclandirma ?? this.basinclandirma,
      havalandirma: havalandirma ?? this.havalandirma,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tekKatCikis_label': tekKatCikis?.label,
      'tekKatRampa_label': tekKatRampa?.label,
      'normalMerdivenSayisi': normalMerdivenSayisi,
      'binaIciYanginMerdiveniSayisi': binaIciYanginMerdiveniSayisi,
      'binaDisiKapaliYanginMerdiveniSayisi':
          binaDisiKapaliYanginMerdiveniSayisi,
      'binaDisiAcikYanginMerdiveniSayisi': binaDisiAcikYanginMerdiveniSayisi,
      'donerMerdivenSayisi': donerMerdivenSayisi,
      'sahanliksizMerdivenSayisi': sahanliksizMerdivenSayisi,
      'dengelenmisMerdivenSayisi': dengelenmisMerdivenSayisi,

      'toplamDisariAcilanMerdivenSayisi':
          toplamDisariAcilanMerdivenSayisi, // NEW

      'lobiTahliyeMesafeDurumu_label': lobiTahliyeMesafeDurumu?.label,
      'isBodrumIndependent': isBodrumIndependent,
      'bodrumMerdivenDevami_label': bodrumMerdivenDevami?.label,
      'bodrumNormalMerdivenSayisi': bodrumNormalMerdivenSayisi,
      'bodrumBinaIciYanginMerdiveniSayisi': bodrumBinaIciYanginMerdiveniSayisi,
      'bodrumBinaDisiKapaliYanginMerdiveniSayisi':
          bodrumBinaDisiKapaliYanginMerdiveniSayisi,
      'bodrumBinaDisiAcikYanginMerdiveniSayisi':
          bodrumBinaDisiAcikYanginMerdiveniSayisi,
      'bodrumDonerMerdivenSayisi': bodrumDonerMerdivenSayisi,
      'bodrumSahanliksizMerdivenSayisi': bodrumSahanliksizMerdivenSayisi,
      'bodrumDengelenmisMerdivenSayisi': bodrumDengelenmisMerdivenSayisi,

      'bodrumToplamDisariAcilanMerdivenSayisi':
          bodrumToplamDisariAcilanMerdivenSayisi, // NEW

      'bodrumLobiTahliyeMesafeDurumu_label':
          bodrumLobiTahliyeMesafeDurumu?.label,
      'basinclandirma_label': basinclandirma?.label,
      'havalandirma_label': havalandirma?.label,
    };
  }

  factory Bolum20Model.fromMap(Map<String, dynamic> map) {
    int toInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      if (val is num) return val.toInt();
      return 0;
    }

    bool toBool(dynamic val) {
      if (val == null) return false;
      if (val is bool) return val;
      if (val is String) return val.toLowerCase() == 'true';
      return false;
    }

    ChoiceResult? find(String? l, List<ChoiceResult> opts) {
      if (l == null) return null;
      try {
        return opts.firstWhere((e) => e.label == l);
      } catch (_) {
        return null;
      }
    }

    return Bolum20Model(
      tekKatCikis: find(map['tekKatCikis_label']?.toString(), [
        Bolum20Content.tekKatOptionA,
      ]),
      tekKatRampa: find(map['tekKatRampa_label']?.toString(), [
        Bolum20Content.rampaOptionB,
        Bolum20Content.rampaOptionC,
      ]),
      normalMerdivenSayisi: toInt(map['normalMerdivenSayisi']),
      binaIciYanginMerdiveniSayisi: toInt(map['binaIciYanginMerdiveniSayisi']),
      binaDisiKapaliYanginMerdiveniSayisi:
          toInt(map['binaDisiKapaliYanginMerdiveniSayisi']),
      binaDisiAcikYanginMerdiveniSayisi:
          toInt(map['binaDisiAcikYanginMerdiveniSayisi']),
      donerMerdivenSayisi: toInt(map['donerMerdivenSayisi']),
      sahanliksizMerdivenSayisi: toInt(map['sahanliksizMerdivenSayisi']),
      dengelenmisMerdivenSayisi: toInt(map['dengelenmisMerdivenSayisi']),

      toplamDisariAcilanMerdivenSayisi: toInt(
        map['toplamDisariAcilanMerdivenSayisi'],
      ),

      lobiTahliyeMesafeDurumu: find(map['lobiTahliyeMesafeDurumu_label']?.toString(), [
        Bolum20Content.madde41MesafeAltinda,
        Bolum20Content.madde41MesafeUstunde,
        Bolum20Content.madde41MesafeBilmiyorum,
      ]),
      isBodrumIndependent: toBool(map['isBodrumIndependent']),
      bodrumMerdivenDevami: find(map['bodrumMerdivenDevami_label']?.toString(), [
        Bolum20Content.bodrumOptionA,
        Bolum20Content.bodrumOptionB,
      ]),
      bodrumNormalMerdivenSayisi: toInt(map['bodrumNormalMerdivenSayisi']),
      bodrumBinaIciYanginMerdiveniSayisi: toInt(
        map['bodrumBinaIciYanginMerdiveniSayisi'],
      ),
      bodrumBinaDisiKapaliYanginMerdiveniSayisi: toInt(
        map['bodrumBinaDisiKapaliYanginMerdiveniSayisi'],
      ),
      bodrumBinaDisiAcikYanginMerdiveniSayisi: toInt(
        map['bodrumBinaDisiAcikYanginMerdiveniSayisi'],
      ),
      bodrumDonerMerdivenSayisi: toInt(map['bodrumDonerMerdivenSayisi']),
      bodrumSahanliksizMerdivenSayisi: toInt(
        map['bodrumSahanliksizMerdivenSayisi'],
      ),
      bodrumDengelenmisMerdivenSayisi: toInt(
        map['bodrumDengelenmisMerdivenSayisi'],
      ),

      bodrumToplamDisariAcilanMerdivenSayisi: toInt(
        map['bodrumToplamDisariAcilanMerdivenSayisi'],
      ),

      bodrumLobiTahliyeMesafeDurumu: find(
        map['bodrumLobiTahliyeMesafeDurumu_label']?.toString(),
        [
          Bolum20Content.madde41MesafeAltinda,
          Bolum20Content.madde41MesafeUstunde,
          Bolum20Content.madde41MesafeBilmiyorum,
        ],
      ),
      basinclandirma: find(map['basinclandirma_label']?.toString(), [
        Bolum20Content.basYghOptionA,
        Bolum20Content.basYghOptionB,
        Bolum20Content.basYghOptionC,
      ]),
      havalandirma: find(map['havalandirma_label']?.toString(), [
        Bolum20Content.havalandirmaOptionA,
        Bolum20Content.havalandirmaOptionB,
        Bolum20Content.havalandirmaOptionC,
        Bolum20Content.havalandirmaOptionD,
      ]),
    );
  }
}
