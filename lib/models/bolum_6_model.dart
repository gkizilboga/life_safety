import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum6Model {
  // Çoklu Seçim Alanları
  final bool hasOtopark;
  final bool hasTicari;
  final bool hasDepo;
  final bool isSadeceKonut;

  // Alt Sorular
  final ChoiceResult? otoparkTipi; // Sadece hasOtopark true ise
  final double?
  kapaliOtoparkAlani; // Kapalı otopark m² (A veya C şıkkı seçildiğinde)
  final ChoiceResult? buyukRestoran; // Ticari alan olduğunda Endüstriyel Mutfak

  Bolum6Model({
    this.hasOtopark = false,
    this.hasTicari = false,
    this.hasDepo = false,
    this.isSadeceKonut = false,
    this.otoparkTipi,
    this.kapaliOtoparkAlani,
    this.buyukRestoran,
  });

  Bolum6Model copyWith({
    bool? hasOtopark,
    bool? hasTicari,
    bool? hasDepo,
    bool? isSadeceKonut,
    ChoiceResult? otoparkTipi,
    double? kapaliOtoparkAlani,
    bool clearKapaliOtoparkAlani = false,
    ChoiceResult? buyukRestoran,
  }) {
    return Bolum6Model(
      hasOtopark: hasOtopark ?? this.hasOtopark,
      hasTicari: hasTicari ?? this.hasTicari,
      hasDepo: hasDepo ?? this.hasDepo,
      isSadeceKonut: isSadeceKonut ?? this.isSadeceKonut,
      otoparkTipi: otoparkTipi ?? this.otoparkTipi,
      kapaliOtoparkAlani: clearKapaliOtoparkAlani
          ? null
          : (kapaliOtoparkAlani ?? this.kapaliOtoparkAlani),
      buyukRestoran: buyukRestoran ?? this.buyukRestoran,
    );
  }

  // Kapalı otopark alanı sorulmalı mı?
  bool get needsKapaliOtoparkAlani {
    if (!hasOtopark || otoparkTipi == null) return false;
    // A şıkkı (Tamamen Kapalı) veya C şıkkı (Tek cephede pencere)
    return otoparkTipi!.label == Bolum6Content.otoparkKapali.label ||
        otoparkTipi!.label == Bolum6Content.otoparkYariAcik.label;
  }

  Map<String, dynamic> toMap() {
    return {
      'hasOtopark': hasOtopark,
      'hasTicari': hasTicari,
      'hasDepo': hasDepo,
      'isSadeceKonut': isSadeceKonut,
      'otoparkTipi_label': otoparkTipi?.label,
      'kapaliOtoparkAlani': kapaliOtoparkAlani,
      'buyukRestoran_label': buyukRestoran?.label,
    };
  }

  factory Bolum6Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? otoparkSecim;
    final label = map['otoparkTipi_label'];

    if (label == Bolum6Content.otoparkKapali.label) {
      otoparkSecim = Bolum6Content.otoparkKapali;
    } else if (label == Bolum6Content.otoparkAcik.label)
      otoparkSecim = Bolum6Content.otoparkAcik;
    else if (label == Bolum6Content.otoparkYariAcik.label)
      otoparkSecim = Bolum6Content.otoparkYariAcik;

    ChoiceResult? restoranSecim;
    final rLabel = map['buyukRestoran_label'];
    if (rLabel == Bolum6Content.buyukRestoranVar.label) {
      restoranSecim = Bolum6Content.buyukRestoranVar;
    } else if (rLabel == Bolum6Content.buyukRestoranYok.label) {
      restoranSecim = Bolum6Content.buyukRestoranYok;
    } else if (rLabel == Bolum6Content.buyukRestoranBilmiyorum.label) {
      restoranSecim = Bolum6Content.buyukRestoranBilmiyorum;
    }

    return Bolum6Model(
      hasOtopark: map['hasOtopark'] ?? false,
      hasTicari: map['hasTicari'] ?? false,
      hasDepo: map['hasDepo'] ?? false,
      isSadeceKonut: map['isSadeceKonut'] ?? false,
      otoparkTipi: otoparkSecim,
      kapaliOtoparkAlani: map['kapaliOtoparkAlani']?.toDouble(),
      buyukRestoran: restoranSecim,
    );
  }
}
