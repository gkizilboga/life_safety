import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum33Model {
  // Kullanıcı Girişleri
  final double? normalKatAlani;
  final double? zeminKatAlani;
  final double? bodrumKatAlani;

  // Hesaplanan Sonuçlar (ChoiceResult olarak)
  final ChoiceResult? normalKatSonuc;
  final ChoiceResult? zeminKatSonuc;
  final ChoiceResult? bodrumKatSonuc;

  Bolum33Model({
    this.normalKatAlani,
    this.zeminKatAlani,
    this.bodrumKatAlani,
    this.normalKatSonuc,
    this.zeminKatSonuc,
    this.bodrumKatSonuc,
  });

  Bolum33Model copyWith({
    double? normalKatAlani,
    double? zeminKatAlani,
    double? bodrumKatAlani,
    ChoiceResult? normalKatSonuc,
    ChoiceResult? zeminKatSonuc,
    ChoiceResult? bodrumKatSonuc,
  }) {
    return Bolum33Model(
      normalKatAlani: normalKatAlani ?? this.normalKatAlani,
      zeminKatAlani: zeminKatAlani ?? this.zeminKatAlani,
      bodrumKatAlani: bodrumKatAlani ?? this.bodrumKatAlani,
      normalKatSonuc: normalKatSonuc ?? this.normalKatSonuc,
      zeminKatSonuc: zeminKatSonuc ?? this.zeminKatSonuc,
      bodrumKatSonuc: bodrumKatSonuc ?? this.bodrumKatSonuc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'normalKatAlani': normalKatAlani,
      'zeminKatAlani': zeminKatAlani,
      'bodrumKatAlani': bodrumKatAlani,
      'normalKatSonuc_label': normalKatSonuc?.label,
      'zeminKatSonuc_label': zeminKatSonuc?.label,
      'bodrumKatSonuc_label': bodrumKatSonuc?.label,
    };
  }

  factory Bolum33Model.fromMap(Map<String, dynamic> map) {
    // Normal Sonuç
    ChoiceResult? n;
    final l1 = map['normalKatSonuc_label'];
    if (l1 == Bolum33Content.normalKatYeterli.label) n = Bolum33Content.normalKatYeterli;
    if (l1 == Bolum33Content.normalKatYetersiz.label) n = Bolum33Content.normalKatYetersiz;

    // Zemin Sonuç
    ChoiceResult? z;
    final l2 = map['zeminKatSonuc_label'];
    if (l2 == Bolum33Content.zeminKatYeterli.label) z = Bolum33Content.zeminKatYeterli;
    if (l2 == Bolum33Content.zeminKatYetersiz.label) z = Bolum33Content.zeminKatYetersiz;

    // Bodrum Sonuç
    ChoiceResult? b;
    final l3 = map['bodrumKatSonuc_label'];
    if (l3 == Bolum33Content.bodrumKatYeterli.label) b = Bolum33Content.bodrumKatYeterli;
    if (l3 == Bolum33Content.bodrumKatYetersiz.label) b = Bolum33Content.bodrumKatYetersiz;

    return Bolum33Model(
      normalKatAlani: map['normalKatAlani'],
      zeminKatAlani: map['zeminKatAlani'],
      bodrumKatAlani: map['bodrumKatAlani'],
      normalKatSonuc: n,
      zeminKatSonuc: z,
      bodrumKatSonuc: b,
    );
  }
}