import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum4Model {
  final ChoiceResult? binaYukseklikSinifi;
  final ChoiceResult? yapiYuksekligiUyarisi; // Bodrum dahil yükseklik uyarısı için
  final double? hesaplananBinaYuksekligi;
  final double? hesaplananYapiYuksekligi;

  Bolum4Model({
    this.binaYukseklikSinifi,
    this.yapiYuksekligiUyarisi,
    this.hesaplananBinaYuksekligi,
    this.hesaplananYapiYuksekligi,
  });

  Bolum4Model copyWith({
    ChoiceResult? binaYukseklikSinifi,
    ChoiceResult? yapiYuksekligiUyarisi,
    double? hesaplananBinaYuksekligi,
    double? hesaplananYapiYuksekligi,
  }) {
    return Bolum4Model(
      binaYukseklikSinifi: binaYukseklikSinifi ?? this.binaYukseklikSinifi,
      yapiYuksekligiUyarisi: yapiYuksekligiUyarisi ?? this.yapiYuksekligiUyarisi,
      hesaplananBinaYuksekligi: hesaplananBinaYuksekligi ?? this.hesaplananBinaYuksekligi,
      hesaplananYapiYuksekligi: hesaplananYapiYuksekligi ?? this.hesaplananYapiYuksekligi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'binaYukseklikSinifi_label': binaYukseklikSinifi?.label,
      'yapiYuksekligiUyarisi_label': yapiYuksekligiUyarisi?.label,
      'hesaplananBinaYuksekligi': hesaplananBinaYuksekligi,
      'hesaplananYapiYuksekligi': hesaplananYapiYuksekligi,
    };
  }

  factory Bolum4Model.fromMap(Map<String, dynamic> map) {
    // Ana Sınıfı Bul
    ChoiceResult? anaSinif;
    final label1 = map['binaYukseklikSinifi_label'];
    if (label1 == Bolum4Content.yukseklikSinifiDusuk.label) {
      anaSinif = Bolum4Content.yukseklikSinifiDusuk;
    } else if (label1 == Bolum4Content.yukseklikSinifiYuksek.label) anaSinif = Bolum4Content.yukseklikSinifiYuksek;
    else if (label1 == Bolum4Content.yukseklikSinifiCokYuksek.label) anaSinif = Bolum4Content.yukseklikSinifiCokYuksek;
    else if (label1 == Bolum4Content.yukseklikSinifiMaksimum.label) anaSinif = Bolum4Content.yukseklikSinifiMaksimum;

    // Uyarıyı Bul
    ChoiceResult? uyari;
    final label2 = map['yapiYuksekligiUyarisi_label'];
    if (label2 == Bolum4Content.yapiYuksekligiUyari.label) uyari = Bolum4Content.yapiYuksekligiUyari;

    return Bolum4Model(
      binaYukseklikSinifi: anaSinif,
      yapiYuksekligiUyarisi: uyari,
      hesaplananBinaYuksekligi: map['hesaplananBinaYuksekligi'],
      hesaplananYapiYuksekligi: map['hesaplananYapiYuksekligi'],
    );
  }
}