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
    if (yukNormal == 0)
      return ChoiceResult(
        label: "33-N-EXCLUDED",
        uiTitle: "Hesaplanmadı",
        uiSubtitle: "",
        reportText:
            "BİLGİ: Kattaki ticari alanlarla bina arasında geçiş olmadığından kullanıcı yükü hesaplanmamıştır.",
        level: RiskLevel.info,
      );
    final mNormal = mevcutNormal;
    if (mNormal == null || gerekliNormal == null) return null;
    return (mNormal >= gerekliNormal!)
        ? Bolum33Content.normalKatYeterli
        : Bolum33Content.normalKatYetersiz;
  }

  ChoiceResult? get zeminKatSonuc {
    // yukZemin == 0 ama gerekliZemin > 0: Tahliye katı transferi yapılmış demektir.
    // Bu durumda zemin katı "Hesaplanmadı" yerine kapasite transferiyle değerlendir.
    if (yukZemin == 0 && (gerekliZemin == null || gerekliZemin == 0)) {
      return ChoiceResult(
        label: "33-Z-EXCLUDED",
        uiTitle: "Hesaplanmadı",
        uiSubtitle: "",
        reportText:
            "BİLGİ: Kattaki ticari alanlarla bina arasında geçiş olmadığından kullanıcı yükü hesaplanmamıştır.",
        level: RiskLevel.info,
      );
    }
    final mZemin = mevcutZemin;
    if (mZemin == null || gerekliZemin == null) return null;
    return (mZemin >= gerekliZemin!)
        ? Bolum33Content.zeminKatYeterli
        : Bolum33Content.zeminKatYetersiz;
  }

  ChoiceResult? get bodrumKatSonuc {
    if (yukBodrum == 0)
      return ChoiceResult(
        label: "33-B-EXCLUDED",
        uiTitle: "Hesaplanmadı",
        uiSubtitle: "",
        reportText:
            "BİLGİ: Kattaki ticari alanlarla bina arasında geçiş olmadığından kullanıcı yükü hesaplanmamıştır.",
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

    Map<String, List<String>> groups = {};

    void addToGroup(String label, ChoiceResult? res) {
      if (res == null) return;
      final text = res.reportText;
      if (!groups.containsKey(text)) {
        groups[text] = [];
      }
      groups[text]!.add(label);
    }

    addToGroup("ZEMİN KAT", resZemin);
    addToGroup("NORMAL KATLAR (En Yoğun Kat)", resNormal);
    addToGroup("BODRUM KATLAR (En Yoğun Kat)", resBodrum);

    if (groups.isEmpty) return "Bölüm 33 hesaplaması yapılmamış.";

    // Eğer her şey aynıysa (ve birden fazla kategori varsa) özel "Tüm Katlar" mesajını döndür
    bool allSame = groups.length == 1;
    int totalResCount =
        (resZemin != null ? 1 : 0) +
        (resNormal != null ? 1 : 0) +
        (resBodrum != null ? 1 : 0);

    if (allSame && totalResCount > 1) {
      final text = groups.keys.first;
      if (text.contains("yeterlidir")) {
        return Bolum33Content.allKatlarYeterli.reportText;
      } else if (text.contains("yetersizdir")) {
        return Bolum33Content.allKatlarYetersiz.reportText;
      }
    }

    List<String> finalParts = [];
    groups.forEach((text, labels) {
      String groupLabel = labels.join(" VE ");
      // "VE" eklemesi sonrası güzelleştirme: "NORMAL KATLAR VE BODRUM KATLAR" -> "NORMAL VE BODRUM KATLAR"
      if (labels.length > 1) {
        if (labels.contains("NORMAL KATLAR (En Yoğun Kat)") &&
            labels.contains("BODRUM KATLAR (En Yoğun Kat)")) {
          groupLabel = "NORMAL VE BODRUM KATLAR (En Yoğun Kat)";
          if (labels.contains("ZEMİN KAT"))
            groupLabel = "ZEMİN, NORMAL VE BODRUM KATLAR";
        } else if (labels.contains("ZEMİN KAT") &&
            labels.contains("NORMAL KATLAR (En Yoğun Kat)")) {
          groupLabel = "ZEMİN VE NORMAL KATLAR";
        } else if (labels.contains("ZEMİN KAT") &&
            labels.contains("BODRUM KATLAR (En Yoğun Kat)")) {
          groupLabel = "ZEMİN VE BODRUM KATLAR";
        }
      }

      finalParts.add("$groupLabel:\n$text");
    });

    return finalParts.join("\n\n");
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
        ].firstWhere(
          (e) => e.label == l,
          orElse: () => Bolum36Content.cikisKatiOptionA,
        );
      })(),
    );
  }
}
