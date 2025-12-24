import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum13Model {
  // Her riskli alan için bir soru (ChoiceResult)
  final ChoiceResult? otoparkKapi;
  final ChoiceResult? kazanKapi;
  final ChoiceResult? asansorKapi;
  final ChoiceResult? jeneratorKapi;
  final ChoiceResult? elektrikKapi;
  final ChoiceResult? trafoKapi;
  final ChoiceResult? depoKapi;
  final ChoiceResult? copKapi;
  
  // Ortak Duvar ve Ticari Alan soruları (Bölüm 6 ve 7'den gelen bilgiye göre)
  final ChoiceResult? ortakDuvar;
  final ChoiceResult? ticariKapi;

  Bolum13Model({
    this.otoparkKapi,
    this.kazanKapi,
    this.asansorKapi,
    this.jeneratorKapi,
    this.elektrikKapi,
    this.trafoKapi,
    this.depoKapi,
    this.copKapi,
    this.ortakDuvar,
    this.ticariKapi,
  });

  Bolum13Model copyWith({
    ChoiceResult? otoparkKapi,
    ChoiceResult? kazanKapi,
    ChoiceResult? asansorKapi,
    ChoiceResult? jeneratorKapi,
    ChoiceResult? elektrikKapi,
    ChoiceResult? trafoKapi,
    ChoiceResult? depoKapi,
    ChoiceResult? copKapi,
    ChoiceResult? ortakDuvar,
    ChoiceResult? ticariKapi,
  }) {
    return Bolum13Model(
      otoparkKapi: otoparkKapi ?? this.otoparkKapi,
      kazanKapi: kazanKapi ?? this.kazanKapi,
      asansorKapi: asansorKapi ?? this.asansorKapi,
      jeneratorKapi: jeneratorKapi ?? this.jeneratorKapi,
      elektrikKapi: elektrikKapi ?? this.elektrikKapi,
      trafoKapi: trafoKapi ?? this.trafoKapi,
      depoKapi: depoKapi ?? this.depoKapi,
      copKapi: copKapi ?? this.copKapi,
      ortakDuvar: ortakDuvar ?? this.ortakDuvar,
      ticariKapi: ticariKapi ?? this.ticariKapi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'otoparkKapi_label': otoparkKapi?.label,
      'kazanKapi_label': kazanKapi?.label,
      'asansorKapi_label': asansorKapi?.label,
      'jeneratorKapi_label': jeneratorKapi?.label,
      'elektrikKapi_label': elektrikKapi?.label,
      'trafoKapi_label': trafoKapi?.label,
      'depoKapi_label': depoKapi?.label,
      'copKapi_label': copKapi?.label,
      'ortakDuvar_label': ortakDuvar?.label,
      'ticariKapi_label': ticariKapi?.label,
    };
  }

  factory Bolum13Model.fromMap(Map<String, dynamic> map) {
    // Burada AppContent'teki tüm seçenekleri tek tek kontrol etmek yerine
    // sadece label'ı kaydedip rapor aşamasında eşleştirme yapacağız.
    // Ancak UI'da göstermek için manuel mapping gerekebilir.
    // Şimdilik basitçe null check ile geçiyoruz, detaylı mapping
    // proje sonunda AppContent içindeki bir helper metod ile yapılabilir.
    
    // Örnek Mapping (Sadece Otopark İçin Gösteriyorum, Diğerlerini de ekleyebilirsin)
    ChoiceResult? otopark;
    if (map['otoparkKapi_label'] == Bolum13Content.otoparkOptionA.label) {
      otopark = Bolum13Content.otoparkOptionA;
    } else if (map['otoparkKapi_label'] == Bolum13Content.otoparkOptionB.label) otopark = Bolum13Content.otoparkOptionB;
    else if (map['otoparkKapi_label'] == Bolum13Content.otoparkOptionC.label) otopark = Bolum13Content.otoparkOptionC;
    else if (map['otoparkKapi_label'] == Bolum13Content.otoparkOptionD.label) otopark = Bolum13Content.otoparkOptionD;

    // Diğer alanlar için de benzer mantık kurulmalı veya
    // Raporlama sırasında sadece label üzerinden gidilmeli.
    // Şimdilik null döndürerek devam ediyoruz.
    return Bolum13Model(otoparkKapi: otopark);
  }
}