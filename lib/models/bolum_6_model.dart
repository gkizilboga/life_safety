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

  Bolum6Model({
    this.hasOtopark = false,
    this.hasTicari = false,
    this.hasDepo = false,
    this.isSadeceKonut = false,
    this.otoparkTipi,
  });

  Bolum6Model copyWith({
    bool? hasOtopark,
    bool? hasTicari,
    bool? hasDepo,
    bool? isSadeceKonut,
    ChoiceResult? otoparkTipi,
  }) {
    return Bolum6Model(
      hasOtopark: hasOtopark ?? this.hasOtopark,
      hasTicari: hasTicari ?? this.hasTicari,
      hasDepo: hasDepo ?? this.hasDepo,
      isSadeceKonut: isSadeceKonut ?? this.isSadeceKonut,
      otoparkTipi: otoparkTipi ?? this.otoparkTipi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hasOtopark': hasOtopark,
      'hasTicari': hasTicari,
      'hasDepo': hasDepo,
      'isSadeceKonut': isSadeceKonut,
      'otoparkTipi_label': otoparkTipi?.label,
    };
  }

  factory Bolum6Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? otoparkSecim;
    final label = map['otoparkTipi_label'];
    
    if (label == Bolum6Content.otoparkKapali.label) otoparkSecim = Bolum6Content.otoparkKapali;
    else if (label == Bolum6Content.otoparkAcik.label) otoparkSecim = Bolum6Content.otoparkAcik;
    else if (label == Bolum6Content.otoparkYariAcik.label) otoparkSecim = Bolum6Content.otoparkYariAcik;

    return Bolum6Model(
      hasOtopark: map['hasOtopark'] ?? false,
      hasTicari: map['hasTicari'] ?? false,
      hasDepo: map['hasDepo'] ?? false,
      isSadeceKonut: map['isSadeceKonut'] ?? false,
      otoparkTipi: otoparkSecim,
    );
  }
}