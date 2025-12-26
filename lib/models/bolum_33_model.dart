import 'choice_result.dart'; 
import '../utils/app_content.dart';

class Bolum33Model {
  // Kullanıcı Girişleri (Alanlar)
  final double? alanZemin;
  final double? alanNormal;
  final double? alanBodrumMax;

  // Hesaplanan Yükler (Kişi Sayıları)
  final double? yukZemin;
  final double? yukNormal;
  final double? yukBodrum;

  // Gereken Çıkış Sayıları
  final int? gerekliZemin;
  final int? gerekliNormal;
  final int? gerekliBodrum;

  // Mevcut Çıkış Sayıları (Bölüm 20'den çekilen)
  final int? mevcutUst;
  final int? mevcutBodrum;

  // Sonuç Mesajları (ChoiceResult)
  final ChoiceResult? normalKatSonuc;
  final ChoiceResult? zeminKatSonuc;
  final ChoiceResult? bodrumKatSonuc;

  Bolum33Model({
    this.alanZemin,
    this.alanNormal,
    this.alanBodrumMax,
    this.yukZemin,
    this.yukNormal,
    this.yukBodrum,
    this.gerekliZemin,
    this.gerekliNormal,
    this.gerekliBodrum,
    this.mevcutUst,
    this.mevcutBodrum,
    this.normalKatSonuc,
    this.zeminKatSonuc,
    this.bodrumKatSonuc,
  });

  Bolum33Model copyWith({
    double? alanZemin,
    double? alanNormal,
    double? alanBodrumMax,
    double? yukZemin,
    double? yukNormal,
    double? yukBodrum,
    int? gerekliZemin,
    int? gerekliNormal,
    int? gerekliBodrum,
    int? mevcutUst,
    int? mevcutBodrum,
    ChoiceResult? normalKatSonuc,
    ChoiceResult? zeminKatSonuc,
    ChoiceResult? bodrumKatSonuc,
  }) {
    return Bolum33Model(
      alanZemin: alanZemin ?? this.alanZemin,
      alanNormal: alanNormal ?? this.alanNormal,
      alanBodrumMax: alanBodrumMax ?? this.alanBodrumMax,
      yukZemin: yukZemin ?? this.yukZemin,
      yukNormal: yukNormal ?? this.yukNormal,
      yukBodrum: yukBodrum ?? this.yukBodrum,
      gerekliZemin: gerekliZemin ?? this.gerekliZemin,
      gerekliNormal: gerekliNormal ?? this.gerekliNormal,
      gerekliBodrum: gerekliBodrum ?? this.gerekliBodrum,
      mevcutUst: mevcutUst ?? this.mevcutUst,
      mevcutBodrum: mevcutBodrum ?? this.mevcutBodrum,
      normalKatSonuc: normalKatSonuc ?? this.normalKatSonuc,
      zeminKatSonuc: zeminKatSonuc ?? this.zeminKatSonuc,
      bodrumKatSonuc: bodrumKatSonuc ?? this.bodrumKatSonuc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alanZemin': alanZemin,
      'alanNormal': alanNormal,
      'alanBodrumMax': alanBodrumMax,
      'yukZemin': yukZemin,
      'yukNormal': yukNormal,
      'yukBodrum': yukBodrum,
      'gerekliZemin': gerekliZemin,
      'gerekliNormal': gerekliNormal,
      'gerekliBodrum': gerekliBodrum,
      'mevcutUst': mevcutUst,
      'mevcutBodrum': mevcutBodrum,
      'normalKatSonuc_label': normalKatSonuc?.label,
      'zeminKatSonuc_label': zeminKatSonuc?.label,
      'bodrumKatSonuc_label': bodrumKatSonuc?.label,
    };
  }

  factory Bolum33Model.fromMap(Map<String, dynamic> map) {
    ChoiceResult? find(String? label, List<ChoiceResult> options) {
      try { return options.firstWhere((e) => e.label == label); } catch (_) { return null; }
    }
    return Bolum33Model(
      alanZemin: map['alanZemin'],
      alanNormal: map['alanNormal'],
      alanBodrumMax: map['alanBodrumMax'],
      yukZemin: map['yukZemin'],
      yukNormal: map['yukNormal'],
      yukBodrum: map['yukBodrum'],
      gerekliZemin: map['gerekliZemin'],
      gerekliNormal: map['gerekliNormal'],
      gerekliBodrum: map['gerekliBodrum'],
      mevcutUst: map['mevcutUst'],
      mevcutBodrum: map['mevcutBodrum'],
      normalKatSonuc: find(map['normalKatSonuc_label'], [Bolum33Content.normalKatYeterli, Bolum33Content.normalKatYetersiz]),
      zeminKatSonuc: find(map['zeminKatSonuc_label'], [Bolum33Content.zeminKatYeterli, Bolum33Content.zeminKatYetersiz]),
      bodrumKatSonuc: find(map['bodrumKatSonuc_label'], [Bolum33Content.bodrumKatYeterli, Bolum33Content.bodrumKatYetersiz]),
    );
  }
}