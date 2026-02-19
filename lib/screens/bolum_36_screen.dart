import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart'; // Restoring this just in case
import '../../data/bina_store.dart';
import '../../models/bolum_36_model.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import 'report_summary_screen.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart';
import '../../utils/app_theme.dart';
import '../../utils/input_validator.dart';

class Bolum36Screen extends StatefulWidget {
  const Bolum36Screen({super.key});
  @override
  State<Bolum36Screen> createState() => _Bolum36ScreenState();
}

class _Bolum36ScreenState extends State<Bolum36Screen> {
  Bolum36Model _model = Bolum36Model();

  final _genislikKorunumluCtrl = TextEditingController();
  final _genislikKorunumsuzCtrl = TextEditingController();

  // Yeni Koridor Kontrolcüleri
  final _koridorGenislikKorunumluCtrl = TextEditingController();
  final _koridorGenislikKorunumsuzCtrl = TextEditingController();

  final _kapiGenislikKorunumluCtrl = TextEditingController();
  final _kapiGenislikKorunumsuzCtrl = TextEditingController();

  final GlobalKey _konumKey = GlobalKey();
  final GlobalKey _genislikKey = GlobalKey();
  final GlobalKey _kapiKey = GlobalKey();

  bool _genislikBilinmiyor = false;
  bool _kapiGenislikBilinmiyor = false;

  // Genişlik Ayrımı
  bool _areWidthsSame = true;

  int _cntDisCelik = 0;
  int _totalValidCikisSayisi = 0;
  bool _hasKorunumlu = false;
  bool _hasKorunumsuz = false;

  String? _genKerr;
  String? _genKSerr;
  String? _korKerr; // Koridor Korunumlu Hata
  String? _korKSerr; // Koridor Korunumsuz Hata
  String? _kGenKerr;
  String? _kGenKSerr;

  @override
  void initState() {
    super.initState();
    // Load existing model data
    final saved = BinaStore.instance.bolum36;
    if (saved != null) {
      _model = saved;
      _areWidthsSame = saved.areWidthsSame;

      if (saved.genislikKorunumlu != null)
        _genislikKorunumluCtrl.text = saved.genislikKorunumlu.toString();
      if (saved.genislikKorunumsuz != null)
        _genislikKorunumsuzCtrl.text = saved.genislikKorunumsuz.toString();

      if (saved.koridorGenislikKorunumlu != null)
        _koridorGenislikKorunumluCtrl.text = saved.koridorGenislikKorunumlu
            .toString();
      if (saved.koridorGenislikKorunumsuz != null)
        _koridorGenislikKorunumsuzCtrl.text = saved.koridorGenislikKorunumsuz
            .toString();

      if (saved.kapiGenislikKorunumlu != null)
        _kapiGenislikKorunumluCtrl.text = saved.kapiGenislikKorunumlu
            .toString();
      if (saved.kapiGenislikKorunumsuz != null)
        _kapiGenislikKorunumsuzCtrl.text = saved.kapiGenislikKorunumsuz
            .toString();
    }

    final b20 = BinaStore.instance.bolum20;

    int icKapali = b20?.binaIciYanginMerdiveniSayisi ?? 0;
    int disKapali = b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0;
    int normal = b20?.normalMerdivenSayisi ?? 0;
    int doner = b20?.donerMerdivenSayisi ?? 0;
    int disAcik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    int sahanliksiz = b20?.sahanliksizMerdivenSayisi ?? 0;
    int dengelenmis =
        (b20?.dengelenmisMerdivenSayisi ?? 0) +
        (b20?.isBodrumIndependent == true
            ? (b20?.bodrumDengelenmisMerdivenSayisi ?? 0)
            : 0);

    _cntDisCelik = disAcik;
    _totalValidCikisSayisi =
        icKapali + disKapali + normal + doner + disAcik + dengelenmis;

    _hasKorunumlu = (icKapali + disKapali) > 0;
    _hasKorunumsuz = (normal + doner + disAcik + sahanliksiz + dengelenmis) > 0;

    _genislikKorunumluCtrl.addListener(_validate);
    _genislikKorunumsuzCtrl.addListener(_validate);
    _koridorGenislikKorunumluCtrl.addListener(_validate);
    _koridorGenislikKorunumsuzCtrl.addListener(_validate);
    _kapiGenislikKorunumluCtrl.addListener(_validate);
    _kapiGenislikKorunumsuzCtrl.addListener(_validate);
  }

  List<ChoiceResult> _getFilteredCikisKatiOptions() {
    final b3 = BinaStore.instance.bolum3;
    final int nKat = b3?.normalKatSayisi ?? 0;
    final int bKat = b3?.bodrumKatSayisi ?? 0;

    List<ChoiceResult> options = [
      Bolum36Content.cikisKatiOptionA,
    ]; // Zemin her zaman var
    if (nKat > 0) options.add(Bolum36Content.cikisKatiOptionB);
    if (bKat > 0) options.add(Bolum36Content.cikisKatiOptionC);

    return options;
  }

  void _validate() {
    setState(() {
      // 1. Merdiven Genişlikleri
      if (!_genislikBilinmiyor) {
        if (_hasKorunumlu) {
          _genKerr = InputValidator.validateNumber(
            _genislikKorunumluCtrl.text,
            min: 50,
            max: 250,
            unit: "cm",
          );
        } else {
          _genKerr = null;
        }
        if (_hasKorunumsuz) {
          _genKSerr = InputValidator.validateNumber(
            _genislikKorunumsuzCtrl.text,
            min: 50,
            max: 250,
            unit: "cm",
          );
        } else {
          _genKSerr = null;
        }
      } else {
        _genKerr = null;
        _genKSerr = null;
      }

      // 2. Koridor Genişlikleri (Sadece farklıysa kontrol et)
      if (!_areWidthsSame && !_genislikBilinmiyor) {
        if (_hasKorunumlu) {
          _korKerr = InputValidator.validateNumber(
            _koridorGenislikKorunumluCtrl.text,
            min: 50,
            max: 250,
            unit: "cm",
          );
        } else {
          _korKerr = null;
        }
        if (_hasKorunumsuz) {
          _korKSerr = InputValidator.validateNumber(
            _koridorGenislikKorunumsuzCtrl.text,
            min: 50,
            max: 250,
            unit: "cm",
          );
        } else {
          _korKSerr = null;
        }
      } else {
        _korKerr = null;
        _korKSerr = null;
      }

      // 3. Kapı Genişlikleri
      if (!_kapiGenislikBilinmiyor) {
        if (_hasKorunumlu) {
          _kGenKerr = InputValidator.validateNumber(
            _kapiGenislikKorunumluCtrl.text,
            min: 50,
            max: 250,
            unit: "cm",
          );
          // Check if door width > stair width (Compare with Stair Width always)
          if (_kGenKerr == null && _genKerr == null && !_genislikBilinmiyor) {
            double? stairW = double.tryParse(_genislikKorunumluCtrl.text);
            double? doorW = double.tryParse(_kapiGenislikKorunumluCtrl.text);
            if (stairW != null && doorW != null && doorW > stairW) {
              _kGenKerr = "Kapı genişliği merdiven genişliğinden büyük olamaz.";
            }
          }
        } else {
          _kGenKerr = null;
        }

        if (_hasKorunumsuz) {
          _kGenKSerr = InputValidator.validateNumber(
            _kapiGenislikKorunumsuzCtrl.text,
            min: 50,
            max: 250,
            unit: "cm",
          );
          // Check if door width > stair width
          if (_kGenKSerr == null && _genKSerr == null && !_genislikBilinmiyor) {
            double? stairW = double.tryParse(_genislikKorunumsuzCtrl.text);
            double? doorW = double.tryParse(_kapiGenislikKorunumsuzCtrl.text);
            if (stairW != null && doorW != null && doorW > stairW) {
              _kGenKSerr =
                  "Kapı genişliği merdiven genişliğinden büyük olamaz.";
            }
          }
        } else {
          _kGenKSerr = null;
        }
      } else {
        _kGenKerr = null;
        _kGenKSerr = null;
      }
    });
  }

  @override
  void dispose() {
    _genislikKorunumluCtrl.dispose();
    _genislikKorunumsuzCtrl.dispose();
    _koridorGenislikKorunumluCtrl.dispose();
    _koridorGenislikKorunumsuzCtrl.dispose();
    _kapiGenislikKorunumluCtrl.dispose();
    _kapiGenislikKorunumsuzCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'cikisKati') _model = _model.copyWith(cikisKati: choice);
      if (type == 'disMerd') {
        _model = _model.copyWith(disMerd: choice);
      }
      if (type == 'konum') {
        _model = _model.copyWith(konum: choice);
      }
      if (type == 'kapiTipi') {
        _model = _model.copyWith(kapiTipi: choice);
      }
      if (type == 'gorunurluk') _model = _model.copyWith(gorunurluk: choice);
    });
  }

  String _evaluateStairsAndExits() {
    final store = BinaStore.instance;
    final b4 = store.bolum4;
    final b20 = store.bolum20;
    final b33 = store.bolum33;

    double hBina = b4?.hesaplananBinaYuksekligi ?? 0.0;
    double hYapi = b4?.hesaplananYapiYuksekligi ?? 0.0;

    int korunumlu =
        (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0);
    int sahanliksiz = b20?.sahanliksizMerdivenSayisi ?? 0;
    int doner = b20?.donerMerdivenSayisi ?? 0;
    int disAcik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    int dengelenmis =
        (b20?.dengelenmisMerdivenSayisi ?? 0) +
        (b20?.isBodrumIndependent == true
            ? (b20?.bodrumDengelenmisMerdivenSayisi ?? 0)
            : 0);
    bool basinclandirmaVar = b20?.basinclandirma?.label == "20-BAS-A";

    List<String> notes = [];

    // --- Merdiven Tipi ve Sayısı Kontrolleri (Mevcut Logic) ---
    if (sahanliksiz > 0)
      notes.add(
        "Binada 'Sahanlıksız Merdiven' tespit edilmiştir. Bu merdiven tipi hiçbir binada kaçış yolu olarak kabul edilmemektedir. YENİ BİNA 'larda tüm merdiven tiplerinde insanların tahliye esnasında dinlenebileceği sahanlıkların bulunması Yönetmeliğe göre zorunludur.",
      );
    if (hBina > 9.50 && doner > 0)
      notes.add(
        "Bina yüksekliği 9.50m üzerinde olduğu için 'Dairesel Merdiven' kullanılamaz. Dairesel merdiven ile özel çözüm gereken katlar varsa Uzman görüşü alınması önerilir.",
      );
    if (hBina > 21.50 && disAcik > 0)
      notes.add(
        "Bina yüksekliği 21.50m üzerinde olduğu için 'Bina Dışı Açık Çelik Merdiven' kullanılamaz.",
      );

    if (dengelenmis > 0) {
      int maxYuk = [
        b33?.yukZemin ?? 0,
        b33?.yukNormal ?? 0,
        b33?.yukBodrum ?? 0,
      ].reduce((a, b) => a > b ? a : b);

      if (hBina > 15.50 || maxYuk > 100) {
        notes.add(
          "Binada 'Dengelenmiş Merdiven' tespit edilmiştir. Yönetmelik gereği, bina yüksekliğinin 15.50 m'den fazla olduğu binalarda veya herhangi bir katta kullanıcı yükünün 100 kişiyi aştığı durumlarda dengelenmiş merdivenlerin kaçış yolu olarak kullanılmasına izin verilmez. Mevcut durumda bu kriterler aşıldığı için merdiven uygunsuzdur.",
        );
      } else {
        notes.add(
          "Binada 'Dengelenmiş Merdiven' mevcuttur. Bina yüksekliği (≤15.50m) ve kullanıcı yükü (≤100 kişi) sınırları içerisinde kaldığı için bu merdiven tipi kaçış yolu olarak kabul edilebilir.",
        );
      }
    }

    // --- Madde 41: Doğrudan Dışarıya Tahliye ve Lobi Kontrolleri ---
    final b31 = store.bolum31;
    bool hasSprinkler = b31?.sondurme?.label == "31-4-A";

    final int totalMain =
        (b20?.normalMerdivenSayisi ?? 0) +
        (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) +
        (b20?.donerMerdivenSayisi ?? 0) +
        (b20?.sahanliksizMerdivenSayisi ?? 0) +
        (b20?.dengelenmisMerdivenSayisi ?? 0);

    if (totalMain > 0) {
      final int directMain = b20?.toplamDisariAcilanMerdivenSayisi ?? 0;
      final int requiredDirect = (totalMain / 2.0).ceil();

      if (directMain < requiredDirect) {
        notes.add(
          "KRİTİK RİSK: Kaçış merdivenlerinin en az %50'sinin doğrudan dışarıya açılması zorunludur. Binadaki $totalMain merdivenden en az $requiredDirect tanesi dışarı açılmalıdır. Mevcut: $directMain adet (Eksik: ${requiredDirect - directMain} adet).",
        );
      } else {
        notes.add(
          "OLUMLU: Merdivenlerin en az %50'si doğrudan dışarıya açılmaktadır. ($directMain/$totalMain)",
        );
      }

      if (directMain < totalMain && b20?.lobiTahliyeMesafeDurumu != null) {
        int limit = hasSprinkler ? 15 : 10;
        String sNote = hasSprinkler
            ? "(Sprinkler Var: 15m)"
            : "(Sprinkler Yok: 10m)";
        if (b20!.lobiTahliyeMesafeDurumu!.label == "41-MESAFE-B") {
          notes.add(
            "KRİTİK RİSK: Tahliye koridoru/lobi mesafesi $limit metre sınırı üzerindedir $sNote.",
          );
        } else if (b20.lobiTahliyeMesafeDurumu!.label == "41-MESAFE-A") {
          notes.add(
            "OLUMLU: Tahliye koridoru mesafesi yönetmelik limitleri ($limit m) içerisindedir.",
          );
        }
      }
    }

    int korunumluBodrum =
        (b20?.bodrumBinaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.bodrumBinaDisiKapaliYanginMerdiveniSayisi ?? 0);

    if (b20?.isBodrumIndependent == true) {
      final int totalBod =
          (b20?.bodrumNormalMerdivenSayisi ?? 0) +
          (b20?.bodrumBinaIciYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiKapaliYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiAcikYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumDonerMerdivenSayisi ?? 0) +
          (b20?.bodrumSahanliksizMerdivenSayisi ?? 0) +
          (b20?.bodrumDengelenmisMerdivenSayisi ?? 0);

      if (totalBod > 0) {
        final int directBod = b20?.bodrumToplamDisariAcilanMerdivenSayisi ?? 0;
        final int reqDirectBod = (totalBod / 2.0).ceil();
        if (directBod < reqDirectBod) {
          notes.add(
            "KRİTİK RİSK: Bodrum merdivenlerinin en az yarısı doğrudan dışarıya açılmalıdır. Gereken: $reqDirectBod, Mevcut: $directBod.",
          );
        }
      }
    }

    // --- Korunumlu Merdiven Sayısı Kontrolü ---
    int requiredProtected = 0;
    if (hYapi >= 21.50 && hYapi < 30.50)
      requiredProtected = 1;
    else if (hYapi >= 30.50)
      requiredProtected = 2;

    if (requiredProtected > 0) {
      // Üst Katlar / Genel Kontrol
      if (korunumlu < requiredProtected) {
        notes.add(
          "KRİTİK RİSK: Bina yüksekliği ($hYapi m) nedeniyle en az $requiredProtected adet 'Korunumlu Merdiven' zorunludur. Mevcut: $korunumlu adet (Eksik: ${requiredProtected - korunumlu} adet).",
        );
      } else {
        notes.add(
          "OLUMLU: Bina yüksekliği için gereken korunumlu merdiven sayısı ($requiredProtected adet) sağlanmaktadır. (Mevcut: $korunumlu)",
        );
      }

      // Bodrum Katlar (Üst kattaki kural aynen uygulanır)
      if (b20?.isBodrumIndependent == true) {
        if (korunumluBodrum < requiredProtected) {
          notes.add(
            "KRİTİK RİSK (Bodrum): Bina yüksekliği ($hYapi m) nedeniyle bodrum katlarda da en az $requiredProtected adet 'Korunumlu Merdiven' zorunludur. Mevcut: $korunumluBodrum adet (Eksik: ${requiredProtected - korunumluBodrum} adet).",
          );
        } else {
          notes.add(
            "OLUMLU (Bodrum): Bodrum katlar için gereken korunumlu merdiven sayısı sağlanmaktadır. (Mevcut: $korunumluBodrum)",
          );
        }
      }
    }

    if (hYapi >= 51.50) {
      if (!basinclandirmaVar)
        notes.add(
          "51.50m üzeri binalarda her iki 'Korunumlu Merdiven' inde hem YGH hem de Basınçlandırma Sistemi tesis edilmesi zorunludur.",
        );
    }

    // --- Genişlik Kontrolleri (Yeni Logic) ---
    if (!_genislikBilinmiyor && !_kapiGenislikBilinmiyor) {
      int yukBodrum = b33?.yukBodrum ?? 0;

      int minMerdiven = 0;
      int minKoridor = 0;
      int minKapi = 80; // Her durumda 80

      bool isYuksekBina = (hBina >= 21.50 || hYapi >= 30.50);

      // Kural 4: Yük >= 2001
      if (yukBodrum >= 2001) {
        minMerdiven = 200;
        minKoridor = 200;
      }
      // Kural 3: 501 <= Yük < 2001 (Her yükseklikte)
      else if (yukBodrum >= 501) {
        minMerdiven = 150;
        minKoridor = 150;
      }
      // Kural 2: Yüksek Bina ve Yük < 501
      else if (isYuksekBina) {
        minMerdiven = 120;
        minKoridor = 120;
      }
      // Kural 1: Yüksek Değil ve Yük < 501
      else {
        minMerdiven =
            120; // Merdiven min 120? User said "merdiven genişliği minimum 120 cm". Actually Kural 1 says merdiven 120.
        minKoridor = 110;
      }

      void checkWidths(String prefix, int uStair, int uCorridor, int uDoor) {
        List<String> violations = [];
        if (uStair < minMerdiven)
          violations.add(
            "Merdiven genişliği yetersiz (Mevcut: ${uStair}cm, Gerekli: ${minMerdiven}cm)",
          );
        if (uCorridor < minKoridor)
          violations.add(
            "Koridor genişliği yetersiz (Mevcut: ${uCorridor}cm, Gerekli: ${minKoridor}cm)",
          );
        if (uDoor < minKapi)
          violations.add(
            "Kapı genişliği yetersiz (Mevcut: ${uDoor}cm, Gerekli: ${minKapi}cm)",
          );

        if (violations.isNotEmpty) {
          notes.add(
            " $prefix İÇİN GENİŞLİK İHLALLERİ:\n- ${violations.join("\n- ")}",
          );
        } else {
          notes.add(
            " $prefix genişlikleri Bodrum Kat Kullanıcı Yükü ($yukBodrum Kişi) ve Bina Yüksekliği kriterlerince yeterlidir.",
          );
        }
      }

      if (_hasKorunumlu) {
        int s = int.tryParse(_genislikKorunumluCtrl.text) ?? 0;
        int c = _areWidthsSame
            ? s
            : (int.tryParse(_koridorGenislikKorunumluCtrl.text) ?? 0);
        int d = int.tryParse(_kapiGenislikKorunumluCtrl.text) ?? 0;
        checkWidths("KORUNUMLU MERDİVEN", s, c, d);
      }

      if (_hasKorunumsuz) {
        int s = int.tryParse(_genislikKorunumsuzCtrl.text) ?? 0;
        int c = _areWidthsSame
            ? s
            : (int.tryParse(_koridorGenislikKorunumsuzCtrl.text) ?? 0);
        int d = int.tryParse(_kapiGenislikKorunumsuzCtrl.text) ?? 0;
        checkWidths("KORUNUMSUZ MERDİVEN", s, c, d);
      }
    }

    // --- BODRUM KAT GENİŞLİK KONTROLÜ (Eğer Bağımsız ise) ---
    bool isBodrumIndependent = b20?.isBodrumIndependent ?? false;
    // Eğer bağımsız değilse (merdiven iniyorsa) zaten üst kat kontrolü yapıldı, genişlik aynı kabul ediliyor.
    // Ancak bağımsız ise, ayrı yük ve ayrı sayı kontrolü gerekir.
    if (isBodrumIndependent) {
      int yBodrum = b33?.yukBodrum ?? 0;

      // Bodrum Genişlik Kontrolü (Aynı Genişlik Varsayımıyla)
      if (!_genislikBilinmiyor && !_kapiGenislikBilinmiyor) {
        int minMerdivenB = 0;
        int minKoridorB = 0;
        int minKapiB = 80;

        // Bodrum yüküne göre minimumlar
        if (yBodrum >= 2001) {
          minMerdivenB = 200;
          minKoridorB = 200;
        } else if (yBodrum >= 501) {
          minMerdivenB = 150;
          minKoridorB = 150;
        } else if (hBina >= 21.50 || hYapi >= 30.50) {
          // Yüksek Bina ise
          minMerdivenB = 120;
          minKoridorB = 120;
        } else {
          minMerdivenB =
              120; // Normalde min 120 (Yönetmelik değişmediyse kural 1) - Kural 1: y<501 => 120
          // Kullanıcıya göre "merdiven genişliği minimum 120 cm"
          minKoridorB = 110; // Kural 1: y<501 => 110?
        }

        void checkWidthsBodrum(String prefix, int s, int c, int d) {
          List<String> violations = [];
          if (s < minMerdivenB)
            violations.add(
              "Merdiven genişliği yetersiz (Mevcut: ${s}cm, Gerekli: ${minMerdivenB}cm)",
            );
          if (c < minKoridorB)
            violations.add(
              "Koridor genişliği yetersiz (Mevcut: ${c}cm, Gerekli: ${minKoridorB}cm)",
            );
          if (d < minKapiB)
            violations.add(
              "Kapı genişliği yetersiz (Mevcut: ${d}cm, Gerekli: ${minKapiB}cm)",
            );

          if (violations.isNotEmpty) {
            notes.add(
              " [BODRUM KAT] $prefix İÇİN GENİŞLİK İHLALLERİ:\n- ${violations.join("\n- ")}",
            );
          } else {
            notes.add(
              " [BODRUM KAT] $prefix genişlikleri Bodrum Kat Kullanıcı Yükü ($yBodrum Kişi) kriterlerine uygundur.",
            );
          }
        }

        if (_hasKorunumlu) {
          int s = int.tryParse(_genislikKorunumluCtrl.text) ?? 0;
          int c = _areWidthsSame
              ? s
              : (int.tryParse(_koridorGenislikKorunumluCtrl.text) ?? 0);
          int d = int.tryParse(_kapiGenislikKorunumluCtrl.text) ?? 0;
          checkWidthsBodrum("KORUNUMLU MERDİVEN", s, c, d);
        }
        if (_hasKorunumsuz) {
          int s = int.tryParse(_genislikKorunumsuzCtrl.text) ?? 0;
          int c = _areWidthsSame
              ? s
              : (int.tryParse(_koridorGenislikKorunumsuzCtrl.text) ?? 0);
          int d = int.tryParse(_kapiGenislikKorunumsuzCtrl.text) ?? 0;
          checkWidthsBodrum("KORUNUMSUZ MERDİVEN", s, c, d);
        }
      }
    }

    if (notes.isEmpty) {
      return "OLUMLU: Merdiven özellikleri genel olarak uygun gözükmektedir.";
    } else {
      return notes.join("\n\n");
    }
  }

  bool get _isFormValid {
    if (_model.cikisKati == null) return false;
    if (_cntDisCelik > 0 && _model.disMerd == null) return false;
    if (_totalValidCikisSayisi > 1 && _model.konum == null) return false;

    if (!_genislikBilinmiyor) {
      if (_hasKorunumlu) {
        if (_genislikKorunumluCtrl.text.isEmpty || _genKerr != null)
          return false;
        if (!_areWidthsSame &&
            (_koridorGenislikKorunumluCtrl.text.isEmpty || _korKerr != null))
          return false;
      }
      if (_hasKorunumsuz) {
        if (_genislikKorunumsuzCtrl.text.isEmpty || _genKSerr != null)
          return false;
        if (!_areWidthsSame &&
            (_koridorGenislikKorunumsuzCtrl.text.isEmpty || _korKSerr != null))
          return false;
      }
    }

    if (_model.kapiTipi == null) return false;

    if (!_kapiGenislikBilinmiyor) {
      if (_hasKorunumlu &&
          (_kapiGenislikKorunumluCtrl.text.isEmpty || _kGenKerr != null))
        return false;
      if (_hasKorunumsuz &&
          (_kapiGenislikKorunumsuzCtrl.text.isEmpty || _kGenKSerr != null))
        return false;
    }

    if (_model.gorunurluk == null) return false;

    return true;
  }

  Widget _buildYghEvaluationPanel() {
    final yghReasons = ReportEngine.evaluateYghRequirement();
    if (yghReasons.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade900,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "YANGIN GÜVENLİK HOLÜ (YGH) ANALİZİ",
                  style: AppStyles.questionTitle.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Yönetmelik gereği binanızda YGH zorunluluğu tespit edilmiştir:",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...yghReasons.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "• ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      r,
                      style: const TextStyle(fontSize: 12, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Korunumlu merdivenlere geçişte YGH (veya duruma göre basınçlandırma) uygulanması şarttır.",
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStairAnalysisList() {
    // This widget visualizes the analysis that _evaluateStairsAndExits generates text for.
    // Ideally we should unify the logic, but for UI display we replicate the checks.

    final validation = _generateStairAnalysis();
    if (validation.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_turned_in,
                color: Colors.blue.shade900,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "MERDİVEN UYGUNLUK ANALİZİ",
                  style: AppStyles.questionTitle.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...validation.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item['status'] == 'OK' ? Icons.check_circle : Icons.cancel,
                    color: item['status'] == 'OK' ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['desc']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _generateStairAnalysis() {
    final store = BinaStore.instance;
    final b20 = store.bolum20;
    final b4 = store.bolum4;
    final b33 = store.bolum33;

    double hBina = b4?.hesaplananBinaYuksekligi ?? 0.0;
    double hYapi = b4?.hesaplananYapiYuksekligi ?? 0.0;
    int yukBodrum = b33?.yukBodrum ?? 0;

    List<Map<String, String>> results = [];

    // 1. Sahanlıksız
    int sahanliksiz = b20?.sahanliksizMerdivenSayisi ?? 0;
    if (sahanliksiz > 0) {
      results.add({
        'status': 'FAIL',
        'title': 'Sahanlıksız Merdiven ($sahanliksiz adet)',
        'desc': 'UYGUN DEĞİL: Hiçbir binada kaçış yolu olarak kabul edilemez.',
      });
    }

    // 2. Dairesel
    int doner = b20?.donerMerdivenSayisi ?? 0;
    if (doner > 0) {
      if (hBina > 9.50) {
        results.add({
          'status': 'FAIL',
          'title': 'Dairesel Merdiven ($doner adet)',
          'desc':
              'UYGUN DEĞİL: Bina yüksekliği 9.50m üzerinde olduğu için kullanılamaz.',
        });
      } else {
        results.add({
          'status': 'OK',
          'title': 'Dairesel Merdiven ($doner adet)',
          'desc':
              'UYGUN: Yükseklik 9.50m altında olduğu için kabul edilebilir.',
        });
      }
    }

    // 3. Bina Dışı Açık
    int disAcik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    if (disAcik > 0) {
      if (hBina > 21.50) {
        results.add({
          'status': 'FAIL',
          'title': 'Bina Dışı Açık Merdiven ($disAcik adet)',
          'desc':
              'UYGUN DEĞİL: Bina yüksekliği 21.50m üzerinde olduğu için kullanılamaz.',
        });
      } else {
        results.add({
          'status': 'OK',
          'title': 'Bina Dışı Açık Merdiven ($disAcik adet)',
          'desc': 'UYGUN: Yükseklik 21.50m sınırını aşmıyor.',
        });
      }
    }

    // 4. Dengelenmiş
    int dengelenmis =
        (b20?.dengelenmisMerdivenSayisi ?? 0) +
        (b20?.isBodrumIndependent == true
            ? (b20?.bodrumDengelenmisMerdivenSayisi ?? 0)
            : 0);
    if (dengelenmis > 0) {
      int maxYuk = [
        b33?.yukZemin ?? 0,
        b33?.yukNormal ?? 0,
        b33?.yukBodrum ?? 0,
      ].reduce((a, b) => a > b ? a : b);
      if (hBina > 15.50 || maxYuk > 100) {
        results.add({
          'status': 'FAIL',
          'title': 'Dengelenmiş Merdiven ($dengelenmis adet)',
          'desc':
              'UYGUN DEĞİL: Yükseklik > 15.50m veya Kullanıcı Yükü > 100 kişi.',
        });
      } else {
        results.add({
          'status': 'OK',
          'title': 'Dengelenmiş Merdiven ($dengelenmis adet)',
          'desc': 'UYGUN: Yükseklik ve kullanıcı yükü sınırları dahilinde.',
        });
      }
    }

    // 5. Korunumlu Merdivenler
    int icKapali = b20?.binaIciYanginMerdiveniSayisi ?? 0;
    int disKapali = b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0;
    int totalKorunumlu = icKapali + disKapali;

    if (totalKorunumlu > 0) {
      // Genişlik kontrolü
      double width = double.tryParse(_genislikKorunumluCtrl.text) ?? 0;
      // Basit kontrol (Detaylısı _evaluateStairsAndExits içinde)
      bool widthOk = true;
      if (!_genislikBilinmiyor) {
        if (yukBodrum >= 2001 && width < 200)
          widthOk = false;
        else if (yukBodrum >= 501 && width < 150)
          widthOk = false;
        else if ((hBina >= 21.50 || hYapi >= 30.50) && width < 120)
          widthOk = false;
        else if (width < 120)
          widthOk = false; // Min
      }

      if (!widthOk) {
        results.add({
          'status': 'FAIL',
          'title': 'Korunumlu Merdiven ($totalKorunumlu adet)',
          'desc':
              'GENİŞLİK YETERSİZ: Girilen genişlik ($width cm) yönetmelik minimumunu karşılamıyor.',
        });
      } else {
        // YGH Kontrolü
        final yghReasons = ReportEngine.evaluateYghRequirement();
        bool hasYgh =
            BinaStore.instance.bolum21?.varlik?.label.contains("21-1-A") ??
            false;
        // Correction: bolum20.basinclandirma is stored.
        bool b20Press =
            b20?.basinclandirma?.label == "20-BAS-A"; // 20-BAS-A is Yes

        if (yghReasons.isNotEmpty && !hasYgh && !b20Press) {
          // Simple logic: if YGH required and NO YGH and NO Press, then Warn
          results.add({
            'status': 'FAIL',
            'title': 'Korunumlu Merdiven ($totalKorunumlu adet)',
            'desc':
                'UYGUN DEĞİL: YGH veya Basınçlandırma sistemi eksik. (YGH Gerekçelerine bakınız)',
          });
        } else {
          results.add({
            'status': 'OK',
            'title': 'Korunumlu Merdiven ($totalKorunumlu adet)',
            'desc': 'UYGUN: Genişlik ve koruma önlemleri yeterli görünüyor.',
          });
        }
      }
    }

    // 6. Normal Merdivenler (Korunumsuz)
    int normal = b20?.normalMerdivenSayisi ?? 0;
    if (normal > 0) {
      // Genişlik kontrolü
      double width = double.tryParse(_genislikKorunumsuzCtrl.text) ?? 0;
      bool widthOk = true;
      if (!_genislikBilinmiyor) {
        if (yukBodrum >= 2001 && width < 200)
          widthOk = false;
        else if (yukBodrum >= 501 && width < 150)
          widthOk = false;
        else if ((hBina >= 21.50 || hYapi >= 30.50) && width < 120)
          widthOk = false;
        else if (width < 120)
          widthOk = false;
      }

      // Yükseklik Limiti (Normal merdiven her yere gider mi?)
      // Yönetmelikte: h>21.50 veya 30.50 ise en az 1 korunumlu şartı var.
      // Ama normal merdiven YASAK değildir, sadece EK OLARAK korunumlu gerekir.
      // Ancak h>30.50 ise normal merdiven kaçış yolu sayılmaz? Kaçış uzaklığına bağlı.
      // Burada sadece genişliğe bakalım.

      if (!widthOk) {
        results.add({
          'status': 'FAIL',
          'title': 'Normal Merdiven ($normal adet)',
          'desc':
              'GENİŞLİK YETERSİZ: Girilen genişlik ($width cm) yönetmelik minimumunu karşılamıyor.',
        });
      } else {
        results.add({
          'status': 'OK',
          'title': 'Normal Merdiven ($normal adet)',
          'desc':
              'UYGUN: Genişlik yeterli. (Not: Yüksekliğe bağlı korunumlu merdiven şartı ayrıca değerlendirilir)',
        });
      }
    }

    // 7. Madde 41: Dış Havaya Tahliye
    final int totalMain =
        (b20?.normalMerdivenSayisi ?? 0) +
        (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) +
        (b20?.donerMerdivenSayisi ?? 0) +
        (b20?.sahanliksizMerdivenSayisi ?? 0) +
        (b20?.dengelenmisMerdivenSayisi ?? 0);

    if (totalMain > 0) {
      final int directMain = b20?.toplamDisariAcilanMerdivenSayisi ?? 0;
      final bool ratioOk = directMain >= (totalMain / 2);
      bool distanceOk = true;
      if (directMain < totalMain) {
        distanceOk =
            b20?.lobiTahliyeMesafeDurumu?.label ==
            Bolum20Content.madde41MesafeAltinda.label;
      }

      results.add({
        'status': (ratioOk && distanceOk) ? 'OK' : 'FAIL',
        'title': 'Dış Havaya Tahliye (Madde 41) - Ana Katlar',
        'desc': (ratioOk && distanceOk)
            ? 'UYGUN: Merdiven tahliye oranı ve mesafesi yeterli.'
            : 'UYGUN DEĞİL: Tahliye oranı (<%50) veya lobi mesafesi hatalı.',
      });
    }

    // 8. Madde 41 (Bodrum)
    if (b20?.isBodrumIndependent == true) {
      final int totalBod =
          (b20?.bodrumNormalMerdivenSayisi ?? 0) +
          (b20?.bodrumBinaIciYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiKapaliYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiAcikYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumDonerMerdivenSayisi ?? 0) +
          (b20?.bodrumSahanliksizMerdivenSayisi ?? 0) +
          (b20?.bodrumDengelenmisMerdivenSayisi ?? 0);

      if (totalBod > 0) {
        final int directBod = b20?.bodrumToplamDisariAcilanMerdivenSayisi ?? 0;
        final bool ratioOkB = directBod >= (totalBod / 2);
        bool distanceOkB = true;
        if (directBod < totalBod) {
          distanceOkB =
              b20?.bodrumLobiTahliyeMesafeDurumu?.label ==
              Bolum20Content.madde41MesafeAltinda.label;
        }

        results.add({
          'status': (ratioOkB && distanceOkB) ? 'OK' : 'FAIL',
          'title': 'Dış Havaya Tahliye (Madde 41) - Bodrum Katlar',
          'desc': (ratioOkB && distanceOkB)
              ? 'UYGUN: Bodrum tahliye oranı ve mesafesi yeterli.'
              : 'UYGUN DEĞİL: Tahliye oranı (<%50) veya lobi mesafesi hatalı.',
        });
      }
    }

    return results;
  }

  void _onFinishPressed() {
    int? genK = _genislikBilinmiyor
        ? null
        : int.tryParse(_genislikKorunumluCtrl.text);
    int? genKS = _genislikBilinmiyor
        ? null
        : int.tryParse(_genislikKorunumsuzCtrl.text);

    // Parse Corridor Widths
    int? korK = (_genislikBilinmiyor || _areWidthsSame)
        ? null // If same, we don't save separate corridor width? Or duplicate it? Best to save as null and fallback to genK in logic.
        : int.tryParse(_koridorGenislikKorunumluCtrl.text);

    int? korKS = (_genislikBilinmiyor || _areWidthsSame)
        ? null
        : int.tryParse(_koridorGenislikKorunumsuzCtrl.text);

    int? kGenK = _kapiGenislikBilinmiyor
        ? null
        : int.tryParse(_kapiGenislikKorunumluCtrl.text);
    int? kGenKS = _kapiGenislikBilinmiyor
        ? null
        : int.tryParse(_kapiGenislikKorunumsuzCtrl.text);

    String finalReport = _evaluateStairsAndExits();
    _model = _model.copyWith(
      areWidthsSame: _areWidthsSame,
      genislikKorunumlu: genK,
      genislikKorunumsuz: genKS,
      koridorGenislikKorunumlu: korK,
      koridorGenislikKorunumsuz: korKS,
      kapiGenislikKorunumlu: kGenK,
      kapiGenislikKorunumsuz: kGenKS,
      merdivenDegerlendirme: finalReport,
    );
    BinaStore.instance.bolum36 = _model;
    BinaStore.instance.markAsCompleted();
    BinaStore.instance.saveToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleTransitionScreen(
          module: ReportModule.modul5,
          onContinue: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportSummaryScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Merdiven Ölçüleri ve Tahliye Esnasında Güvenlik",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isFormValid,
      onNext: _onFinishPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSoruHeader(
            "Binadan dış havaya (atmosfere) çıktığınız kat hangisidir?",
          ),
          _buildSoruCard(
            'cikisKati',
            _getFilteredCikisKatiOptions(),
            _model.cikisKati,
          ),
          if (_cntDisCelik > 0) ...[
            _buildSoruHeader(
              "Dışarıdaki yangın merdivenine 3 metre mesafede açıklık var mı?",
            ),
            _buildSoruCard('disMerd', [
              Bolum36Content.disMerdOptionA,
              Bolum36Content.disMerdOptionB,
              Bolum36Content.disMerdOptionC,
            ], _model.disMerd),
          ],
          SizedBox(key: _konumKey, height: 1),
          if (_totalValidCikisSayisi > 1) ...[
            _buildInfoNote(
              "Binada birden fazla çıkış tespit edildiği için konumlarının hususi olarak değerlendirilmesi gereklidir.",
            ),
            _buildSoruHeader(
              "Kaçış merdivenleri birbirine göre nasıl konumlanmış?",
            ),
            _buildSoruCard('konum', [
              Bolum36Content.konumOptionA,
              Bolum36Content.konumOptionB,
              Bolum36Content.konumOptionC,
            ], _model.konum),
          ],
          SizedBox(key: _genislikKey, height: 1),

          _buildSoruHeader("Merdiven ve Koridor temiz genişliği kaç cm 'dir?"),
          QuestionCard(
            child: Column(
              children: [
                // Toggle Switch for Same/Different Widths
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    value: _areWidthsSame,
                    title: const Text(
                      "Binada merdiven ve koridor genişlikleri aynıdır.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    activeColor: const Color(0xFF1565C0),
                    onChanged: (val) {
                      setState(() {
                        _areWidthsSame = val;
                      });
                    },
                  ),
                ),
                if (BinaStore.instance.bolum20?.isBodrumIndependent == true)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: Colors.grey),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Bodrum kat merdivenleri, koridorları ve kapıları üst katlarla AYNI genişliktedir.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Switch(
                          value: true,
                          onChanged: null, // Disabled/ReadOnly
                          activeColor: Colors.blueGrey,
                        ),
                      ],
                    ),
                  ),

                if (_hasKorunumlu) ...[
                  _buildInput(
                    _areWidthsSame
                        ? "Korunumlu Merdiven ve Koridor Genişliği"
                        : "Korunumlu Merdiven Genişliği",
                    _genislikKorunumluCtrl,
                    _genislikBilinmiyor,
                    _genKerr,
                  ),
                  if (!_areWidthsSame)
                    _buildInput(
                      "Korunumlu Koridor Genişliği",
                      _koridorGenislikKorunumluCtrl,
                      _genislikBilinmiyor,
                      _korKerr,
                    ),
                ],

                if (_hasKorunumsuz) ...[
                  _buildInput(
                    _areWidthsSame
                        ? "Korunumsuz Merdiven ve Koridor Genişliği"
                        : "Korunumsuz Merdiven Genişliği",
                    _genislikKorunumsuzCtrl,
                    _genislikBilinmiyor,
                    _genKSerr,
                  ),
                  if (!_areWidthsSame)
                    _buildInput(
                      "Korunumsuz Koridor Genişliği",
                      _koridorGenislikKorunumsuzCtrl,
                      _genislikBilinmiyor,
                      _korKSerr,
                    ),
                ],

                const SizedBox(height: 10),
                SelectableCard(
                  choice: Bolum36Content.genislikBilinmiyor,
                  isSelected: _genislikBilinmiyor,
                  onTap: () => setState(() {
                    _genislikBilinmiyor = !_genislikBilinmiyor;
                    if (_genislikBilinmiyor) {
                      _genislikKorunumluCtrl.clear();
                      _genislikKorunumsuzCtrl.clear();
                      _koridorGenislikKorunumluCtrl.clear();
                      _koridorGenislikKorunumsuzCtrl.clear();
                    }
                  }),
                ),
              ],
            ),
          ),
          _buildSoruHeader("Katınızdaki çıkış kapılarının tipi nedir?"),
          _buildSoruCard('kapiTipi', [
            Bolum36Content.kapiTipiOptionA,
            Bolum36Content.kapiTipiOptionB,
            Bolum36Content.kapiTipiOptionC,
          ], _model.kapiTipi),
          SizedBox(key: _kapiKey, height: 1),
          _buildSoruHeader(
            "Katınızdaki çıkış kapılarının temiz (net geçiş) genişliği kaç santimetredir?",
          ),
          QuestionCard(
            child: Column(
              children: [
                if (_hasKorunumlu)
                  _buildInput(
                    "Korunumlu Merdivene Ait Kapı Genişliği",
                    _kapiGenislikKorunumluCtrl,
                    _kapiGenislikBilinmiyor,
                    _kGenKerr,
                  ),
                if (_hasKorunumsuz)
                  _buildInput(
                    "Korunumsuz Merdivene Ait Kapı Genişliği",
                    _kapiGenislikKorunumsuzCtrl,
                    _kapiGenislikBilinmiyor,
                    _kGenKSerr,
                  ),
                const SizedBox(height: 10),
                SelectableCard(
                  choice: Bolum36Content.kapiGenislikBilinmiyor,
                  isSelected: _kapiGenislikBilinmiyor,
                  onTap: () => setState(() {
                    _kapiGenislikBilinmiyor = !_kapiGenislikBilinmiyor;
                    if (_kapiGenislikBilinmiyor) {
                      _kapiGenislikKorunumluCtrl.clear();
                      _kapiGenislikKorunumsuzCtrl.clear();
                    }
                  }),
                ),
              ],
            ),
          ),

          _buildSoruHeader("Kaçış Yolu Görünürlüğü"),
          _buildSoruCard('gorunurluk', [
            Bolum36Content.gorunurlukOptionA,
            Bolum36Content.gorunurlukOptionB,
            Bolum36Content.gorunurlukOptionC,
          ], _model.gorunurluk),

          _buildYghEvaluationPanel(),
          _buildStairAnalysisList(),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController ctrl,
    bool isDisabled,
    String? error, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        enabled: !isDisabled,
        keyboardType:
            keyboardType ??
            const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [InputValidator.flexDecimal],
        style: const TextStyle(fontSize: 14),
        decoration: AppStyles.inputDecoration(label, suffix: "cm").copyWith(
          labelText: label,
          hintText: "Örn: 120",
          errorText: error,
          errorMaxLines: 2,
        ),
      ),
    );
  }

  Widget _buildSoruHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
      child: Text(title, style: AppStyles.questionTitle),
    );
  }

  Widget _buildSoruCard(
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        children: options
            .map(
              (opt) => SelectableCard(
                choice: opt,
                isSelected: selected?.label == opt.label,
                onTap: () => _handleSelection(key, opt),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Color(0xFFE65100), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE65100),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
