import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum4Model {
  final ChoiceResult? binaYukseklikSinifi;
  final ChoiceResult? yapiYuksekligiUyarisi;
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
    ChoiceResult? findSinif(String? label) {
      if (label == null) return null;
      return [
        Bolum4Content.yukseklikSinifiDusuk,
        Bolum4Content.yukseklikSinifiYuksek,
        Bolum4Content.yukseklikSinifiCokYuksek,
        Bolum4Content.yukseklikSinifiMaksimum
      ].firstWhere((e) => e.label == label, orElse: () => Bolum4Content.yukseklikSinifiDusuk);
    }
    
    return Bolum4Model(
      binaYukseklikSinifi: findSinif(map['binaYukseklikSinifi_label']),
      yapiYuksekligiUyarisi: map['yapiYuksekligiUyarisi_label'] == Bolum4Content.yapiYuksekligiUyari.label ? Bolum4Content.yapiYuksekligiUyari : null,
      hesaplananBinaYuksekligi: (map['hesaplananBinaYuksekligi'] as num?)?.toDouble(),
      hesaplananYapiYuksekligi: (map['hesaplananYapiYuksekligi'] as num?)?.toDouble(),
    );
  }
}