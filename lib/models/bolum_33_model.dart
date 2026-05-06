import 'choice_result.dart';
import '../utils/app_content.dart';

class Bolum33Model {
  final double? alanZemin;
  final double? alanNormal;
  final double? alanBodrumMax;
  final int? yukZemin;
  final int? yukNormal;
  final int? yukBodrum;
  final int? gerekliZemin;
  final int? gerekliNormal;
  final int? gerekliBodrum;
  /// Toplam merdiven sayısı (tüm kat tipleri için baz değer)
  final int? mevcutUst;
  final int? mevcutBodrum;
  final ChoiceResult? cikisKati;
  final int? cikisSayisi;
  /// Hesaplamada kullanılan minimum merdiven genişliği (metre). En yüksek kat yüküne göre seçilir.
  final double? minMerdivGenisligi;

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
    this.cikisKati,
    this.cikisSayisi,
    this.minMerdivGenisligi,
  });

  /// Zemin katın gerçek mevcut çıkış sayısı.
  /// Çıkış katı Zemin (36-0-A) ise kullanıcının girdiği cikisSayisi,
  /// aksi halde toplam merdiven sayısı olan mevcutUst kullanılır.
  int? get mevcutZemin {
    final label = cikisKati?.label ?? '';
    if (label == '36-0-A') {
      return cikisSayisi;
    }
    return mevcutUst;
  }

  /// Normal katların gerçek mevcut çıkış sayısı.
  /// Çıkış katı Normal Kat (36-0-B) ise kullanıcının girdiği cikisSayisi,
  /// aksi halde toplam merdiven sayısı olan mevcutUst kullanılır.
  int? get mevcutNormal {
    final label = cikisKati?.label ?? '';
    if (label == '36-0-B') {
      return cikisSayisi;
    }
    return mevcutUst;
  }

  ChoiceResult? get normalKatSonuc {
    if (yukNormal == 0) return ChoiceResult(
      label: "33-N-EXCLUDED",
      uiTitle: "Hesaplanmadı",
      uiSubtitle: "",
      reportText: "BİLGİ: Kattaki ticari alanlarla bina arasında geçiş olmadığından kullanıcı yükü hesaplanmamıştır.",
      level: RiskLevel.info,
    );
    final mNormal = mevcutNormal;
    if (mNormal == null || gerekliNormal == null) return null;
    return (mNormal >= gerekliNormal!)
        ? Bolum33Content.normalKatYeterli
        : Bolum33Content.normalKatYetersiz;
  }

  ChoiceResult? get zeminKatSonuc {
    if (yukZemin == 0) return ChoiceResult(
      label: "33-Z-EXCLUDED",
      uiTitle: "Hesaplanmadı",
      uiSubtitle: "",
      reportText: "BİLGİ: Kattaki ticari alanlarla bina arasında geçiş olmadığından kullanıcı yükü hesaplanmamıştır.",
      level: RiskLevel.info,
    );
    final mZemin = mevcutZemin;
    if (mZemin == null || gerekliZemin == null) return null;
    return (mZemin >= gerekliZemin!)
        ? Bolum33Content.zeminKatYeterli
        : Bolum33Content.zeminKatYetersiz;
  }

  ChoiceResult? get bodrumKatSonuc {
    if (yukBodrum == 0) return ChoiceResult(
      label: "33-B-EXCLUDED",
      uiTitle: "Hesaplanmadı",
      uiSubtitle: "",
      reportText: "BİLGİ: Kattaki ticari alanlarla bina arasında geçiş olmadığından kullanıcı yükü hesaplanmamıştır.",
      level: RiskLevel.info,
    );
    if (mevcutBodrum == null || gerekliBodrum == null) return null;
    return (mevcutBodrum! >= gerekliBodrum!)
        ? Bolum33Content.bodrumKatYeterli
        : Bolum33Content.bodrumKatYetersiz;
  }

  String get combinedReportText {
    final resZemin = zeminKatSonuc;
    final resNormal = normalKatSonuc;
    final resBodrum = bodrumKatSonuc;

    List<ChoiceResult> currentResults = [];
    if (resZemin != null) currentResults.add(resZemin);
    if (resNormal != null) currentResults.add(resNormal);
    if (resBodrum != null) currentResults.add(resBodrum);

    if (currentResults.isEmpty) return "Bölüm 33 hesaplaması yapılmamış.";

    bool allOk = currentResults.every((r) => r.label.contains("-OK"));
    bool allFail = currentResults.every((r) => r.label.contains("-FAIL"));

    if (allOk && currentResults.length > 1) {
      return Bolum33Content.allKatlarYeterli.reportText;
    }
    if (allFail && currentResults.length > 1) {
      return Bolum33Content.allKatlarYetersiz.reportText;
    }

    List<String> parts = [];
    if (resZemin != null) parts.add("ZEMİN KAT:\n${resZemin.reportText}");
    if (resNormal != null) parts.add("NORMAL KATLAR (En Yoğun Kat):\n${resNormal.reportText}");
    if (resBodrum != null) parts.add("BODRUM KATLAR (En Yoğun Kat):\n${resBodrum.reportText}");

    return parts.join("\n\n");
  }

  Bolum33Model copyWith({
    double? alanZemin,
    double? alanNormal,
    double? alanBodrumMax,
    int? yukZemin,
    int? yukNormal,
    int? yukBodrum,
    int? gerekliZemin,
    int? gerekliNormal,
    int? gerekliBodrum,
    int? mevcutUst,
    int? mevcutBodrum,
    ChoiceResult? cikisKati,
    int? cikisSayisi,
    double? minMerdivGenisligi,
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
      cikisKati: cikisKati ?? this.cikisKati,
      cikisSayisi: cikisSayisi ?? this.cikisSayisi,
      minMerdivGenisligi: minMerdivGenisligi ?? this.minMerdivGenisligi,
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
      'cikisKati_label': cikisKati?.label,
      'cikisSayisi': cikisSayisi,
      'minMerdivGenisligi': minMerdivGenisligi,
    };
  }

  factory Bolum33Model.fromMap(Map<String, dynamic> map) {
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
      cikisSayisi: map['cikisSayisi'],
      minMerdivGenisligi: map['minMerdivGenisligi'],
      cikisKati: (() {
        final l = map['cikisKati_label'];
        if (l == null) return null;
        return [
          Bolum36Content.cikisKatiOptionA,
          Bolum36Content.cikisKatiOptionB,
          Bolum36Content.cikisKatiOptionC,
        ].firstWhere((e) => e.label == l, orElse: () => Bolum36Content.cikisKatiOptionA);
      })(),
    );
  }
}
