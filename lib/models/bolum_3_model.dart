import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum3Model {
  final int? normalKatSayisi;
  final int? bodrumKatSayisi;
  
  // Yükseklik Hassasiyet Tercihi (Biliniyor / Standart)
  final ChoiceResult? yukseklikTercihi;

  // Eğer "Biliyorum" seçilirse girilecek değerler:
  final double? zeminKatYuksekligi;
  final double? normalKatYuksekligi;
  final double? bodrumKatYuksekligi;

  Bolum3Model({
    this.normalKatSayisi,
    this.bodrumKatSayisi,
    this.yukseklikTercihi,
    this.zeminKatYuksekligi,
    this.normalKatYuksekligi,
    this.bodrumKatYuksekligi,
  });

  // Toplam Yüksekliği Hesaplayan Akıllı Getter
  double get toplamYukseklik {
    double zeminH = zeminKatYuksekligi ?? 3.50; // Varsayılan
    double normalH = normalKatYuksekligi ?? 3.00; // Varsayılan
    double bodrumH = bodrumKatYuksekligi ?? 3.50; // Varsayılan

    // Eğer standart seçildiyse varsayılanları kullan
    if (yukseklikTercihi?.label == Bolum3Content.yukseklikStandart.label) {
      zeminH = 3.50;
      normalH = 3.00;
      bodrumH = 3.50;
    }

    int nKat = normalKatSayisi ?? 0;
    int bKat = bodrumKatSayisi ?? 0;

    // Toplam = Zemin + (Normal Katlar) + (Bodrumlar)
    return zeminH + (nKat * normalH) + (bKat * bodrumH);
  }

  Bolum3Model copyWith({
    int? normalKatSayisi,
    int? bodrumKatSayisi,
    ChoiceResult? yukseklikTercihi,
    double? zeminKatYuksekligi,
    double? normalKatYuksekligi,
    double? bodrumKatYuksekligi,
  }) {
    return Bolum3Model(
      normalKatSayisi: normalKatSayisi ?? this.normalKatSayisi,
      bodrumKatSayisi: bodrumKatSayisi ?? this.bodrumKatSayisi,
      yukseklikTercihi: yukseklikTercihi ?? this.yukseklikTercihi,
      zeminKatYuksekligi: zeminKatYuksekligi ?? this.zeminKatYuksekligi,
      normalKatYuksekligi: normalKatYuksekligi ?? this.normalKatYuksekligi,
      bodrumKatYuksekligi: bodrumKatYuksekligi ?? this.bodrumKatYuksekligi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'normalKatSayisi': normalKatSayisi,
      'bodrumKatSayisi': bodrumKatSayisi,
      'yukseklikTercihi_label': yukseklikTercihi?.label,
      'zeminKatYuksekligi': zeminKatYuksekligi,
      'normalKatYuksekligi': normalKatYuksekligi,
      'bodrumKatYuksekligi': bodrumKatYuksekligi,
    };
  }

  factory Bolum3Model.fromMap(Map<String, dynamic> map) {
    // Tercihi geri yükle
    ChoiceResult? secilenTercih;
    final label = map['yukseklikTercihi_label'];
    if (label == Bolum3Content.yukseklikBiliniyor.label) {
      secilenTercih = Bolum3Content.yukseklikBiliniyor;
    } else if (label == Bolum3Content.yukseklikStandart.label) {
      secilenTercih = Bolum3Content.yukseklikStandart;
    }

    return Bolum3Model(
      normalKatSayisi: map['normalKatSayisi'],
      bodrumKatSayisi: map['bodrumKatSayisi'],
      yukseklikTercihi: secilenTercih,
      zeminKatYuksekligi: map['zeminKatYuksekligi'],
      normalKatYuksekligi: map['normalKatYuksekligi'],
      bodrumKatYuksekligi: map['bodrumKatYuksekligi'],
    );
  }
}