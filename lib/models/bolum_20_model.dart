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

  // Independent Basement Stairs
  final bool isBodrumIndependent;
  final int bodrumNormalMerdivenSayisi;
  final int bodrumBinaIciYanginMerdiveniSayisi;
  final int bodrumBinaDisiKapaliYanginMerdiveniSayisi;
  final int bodrumBinaDisiAcikYanginMerdiveniSayisi;
  final int bodrumDonerMerdivenSayisi;
  final int bodrumSahanliksizMerdivenSayisi;
  final int bodrumDengelenmisMerdivenSayisi;

  final ChoiceResult? bodrumMerdivenDevami;
  final ChoiceResult? basinclandirma;
  final ChoiceResult? daireselMerdivenYuksekligi;

  // --- Computed Properties (Single Source of Truth) ---

  /// Binada dairesel (spiral) merdiven var mı?
  /// Ana katlarda veya bağımsız bodrumda dairesel merdiven kontrolü.
  bool get hasDaireselMerdiven =>
      donerMerdivenSayisi > 0 ||
      (isBodrumIndependent && bodrumDonerMerdivenSayisi > 0);

  /// Dairesel merdiven yüksekliği seçimi gerekli mi?
  /// Dairesel merdiven varsa yükseklik bilgisi zorunludur.
  bool get isDaireselYukseklikRequired => hasDaireselMerdiven;

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
    this.isBodrumIndependent = false,
    this.bodrumMerdivenDevami,
    this.bodrumNormalMerdivenSayisi = 0,
    this.bodrumBinaIciYanginMerdiveniSayisi = 0,
    this.bodrumBinaDisiKapaliYanginMerdiveniSayisi = 0,
    this.bodrumBinaDisiAcikYanginMerdiveniSayisi = 0,
    this.bodrumDonerMerdivenSayisi = 0,
    this.bodrumSahanliksizMerdivenSayisi = 0,
    this.bodrumDengelenmisMerdivenSayisi = 0,
    this.basinclandirma,
    this.daireselMerdivenYuksekligi,
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
    int? dengelenmisMerdivenSayisi,
    bool? isBodrumIndependent,
    ChoiceResult? bodrumMerdivenDevami,
    int? bodrumNormalMerdivenSayisi,
    int? bodrumBinaIciYanginMerdiveniSayisi,
    int? bodrumBinaDisiKapaliYanginMerdiveniSayisi,
    int? bodrumBinaDisiAcikYanginMerdiveniSayisi,
    int? bodrumDonerMerdivenSayisi,
    int? bodrumSahanliksizMerdivenSayisi,
    int? bodrumDengelenmisMerdivenSayisi,
    ChoiceResult? basinclandirma,
    ChoiceResult? daireselMerdivenYuksekligi,
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
      bodrumDengelenmisMerdivenSayisi: bodrumDengelenmisMerdivenSayisi ??
          this.bodrumDengelenmisMerdivenSayisi,
      basinclandirma: basinclandirma ?? this.basinclandirma,
      daireselMerdivenYuksekligi:
          daireselMerdivenYuksekligi ?? this.daireselMerdivenYuksekligi,
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
      'basinclandirma_label': basinclandirma?.label,
      'daireselMerdivenYuksekligi_label': daireselMerdivenYuksekligi?.label,
    };
  }

  factory Bolum20Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? l, List<ChoiceResult> opts) {
      if (l == null) return null;
      try {
        return opts.firstWhere((e) => e.label == l);
      } catch (_) {
        return null;
      }
    }

    // Better strategy: Use the lists we know.

    return Bolum20Model(
      tekKatCikis: find(map['tekKatCikis_label'], [
        Bolum20Content.tekKatOptionA,
      ]),
      tekKatRampa: find(map['tekKatRampa_label'], [
        Bolum20Content.rampaOptionB,
        Bolum20Content.rampaOptionC,
      ]),
      normalMerdivenSayisi: map['normalMerdivenSayisi'] ?? 0,
      binaIciYanginMerdiveniSayisi: map['binaIciYanginMerdiveniSayisi'] ?? 0,
      binaDisiKapaliYanginMerdiveniSayisi:
          map['binaDisiKapaliYanginMerdiveniSayisi'] ?? 0,
      binaDisiAcikYanginMerdiveniSayisi:
          map['binaDisiAcikYanginMerdiveniSayisi'] ?? 0,
      donerMerdivenSayisi: map['donerMerdivenSayisi'] ?? 0,
      sahanliksizMerdivenSayisi: map['sahanliksizMerdivenSayisi'] ?? 0,
      dengelenmisMerdivenSayisi: map['dengelenmisMerdivenSayisi'] ?? 0,
      isBodrumIndependent: map['isBodrumIndependent'] ?? false,
      bodrumMerdivenDevami: find(map['bodrumMerdivenDevami_label'], [
        Bolum20Content.bodrumOptionA,
        Bolum20Content.bodrumOptionB,
      ]),
      bodrumNormalMerdivenSayisi: map['bodrumNormalMerdivenSayisi'] ?? 0,
      bodrumBinaIciYanginMerdiveniSayisi:
          map['bodrumBinaIciYanginMerdiveniSayisi'] ?? 0,
      bodrumBinaDisiKapaliYanginMerdiveniSayisi:
          map['bodrumBinaDisiKapaliYanginMerdiveniSayisi'] ?? 0,
      bodrumBinaDisiAcikYanginMerdiveniSayisi:
          map['bodrumBinaDisiAcikYanginMerdiveniSayisi'] ?? 0,
      bodrumDonerMerdivenSayisi: map['bodrumDonerMerdivenSayisi'] ?? 0,
      bodrumSahanliksizMerdivenSayisi:
          map['bodrumSahanliksizMerdivenSayisi'] ?? 0,
      bodrumDengelenmisMerdivenSayisi:
          map['bodrumDengelenmisMerdivenSayisi'] ?? 0,
      basinclandirma: find(map['basinclandirma_label'], [
        Bolum20Content.basYghOptionA,
        Bolum20Content.basYghOptionB,
        Bolum20Content.basYghOptionC,
      ]),
      daireselMerdivenYuksekligi:
          find(map['daireselMerdivenYuksekligi_label'], [
            Bolum20Content.daireselYukseklikOptionA,
            Bolum20Content.daireselYukseklikOptionB,
            Bolum20Content.daireselYukseklikOptionC,
          ]),
    );
  }
}
