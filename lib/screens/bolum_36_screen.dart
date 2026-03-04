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
            min: 30,
            max: 600,
            unit: "cm",
          );
          if (_genKerr != null && _genislikKorunumluCtrl.text.isNotEmpty) {
            _genKerr = "Değer 30 ile 600 cm arasında olmalıdır.";
          }
        } else {
          _genKerr = null;
        }
        if (_hasKorunumsuz) {
          _genKSerr = InputValidator.validateNumber(
            _genislikKorunumsuzCtrl.text,
            min: 30,
            max: 600,
            unit: "cm",
          );
          if (_genKSerr != null && _genislikKorunumsuzCtrl.text.isNotEmpty) {
            _genKSerr = "Değer 30 ile 600 cm arasında olmalıdır.";
          }
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
            min: 30,
            max: 600,
            unit: "cm",
          );
          if (_korKerr != null &&
              _koridorGenislikKorunumluCtrl.text.isNotEmpty) {
            _korKerr = "Değer 30 ile 600 cm arasında olmalıdır.";
          }
        } else {
          _korKerr = null;
        }
        if (_hasKorunumsuz) {
          _korKSerr = InputValidator.validateNumber(
            _koridorGenislikKorunumsuzCtrl.text,
            min: 30,
            max: 600,
            unit: "cm",
          );
          if (_korKSerr != null &&
              _koridorGenislikKorunumsuzCtrl.text.isNotEmpty) {
            _korKSerr = "Değer 30 ile 600 cm arasında olmalıdır.";
          }
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
            min: 30,
            max: 600,
            unit: "cm",
          );
          if (_kGenKerr != null &&
              _kapiGenislikKorunumluCtrl.text.isNotEmpty &&
              !_kGenKerr!.contains("merdiven")) {
            _kGenKerr = "Değer 30 ile 600 cm arasında olmalıdır.";
          }
          // Check if door width > stair width (Compare with Stair Width always)
          if (_kGenKerr == null && _genKerr == null && !_genislikBilinmiyor) {
            double? stairW = InputValidator.parseFlex(
              _genislikKorunumluCtrl.text,
            );
            double? doorW = InputValidator.parseFlex(
              _kapiGenislikKorunumluCtrl.text,
            );
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
            min: 30,
            max: 600,
            unit: "cm",
          );
          if (_kGenKSerr != null &&
              _kapiGenislikKorunumsuzCtrl.text.isNotEmpty &&
              !_kGenKSerr!.contains("merdiven")) {
            _kGenKSerr = "Değer 30 ile 600 cm arasında olmalıdır.";
          }
          // Check if door width > stair width
          if (_kGenKSerr == null && _genKSerr == null && !_genislikBilinmiyor) {
            double? stairW = InputValidator.parseFlex(
              _genislikKorunumsuzCtrl.text,
            );
            double? doorW = InputValidator.parseFlex(
              _kapiGenislikKorunumsuzCtrl.text,
            );
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
    });
  }

  String _evaluateStairsAndExits() {
    final store = BinaStore.instance;
    final b4 = store.bolum4;
    final b20 = store.bolum20;
    final b33 = store.bolum33;

    double hBina = b4?.hesaplananBinaYuksekligi ?? 0.0;
    double hYapi = b4?.hesaplananYapiYuksekligi ?? 0.0;

    int sahanliksiz = b20?.sahanliksizMerdivenSayisi ?? 0;
    int disAcik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    int dengelenmis =
        (b20?.dengelenmisMerdivenSayisi ?? 0) +
        (b20?.isBodrumIndependent == true
            ? (b20?.bodrumDengelenmisMerdivenSayisi ?? 0)
            : 0);
    bool basinclandirmaVar = b20?.basinclandirma?.label == "20-BAS-A";

    List<String> notes = [];

    // --- Ekran Özel Merdiven Tipi Kontrolleri ---
    if (sahanliksiz > 0)
      notes.add(
        "Binada 'Sahanlıksız Merdiven' tespit edilmiştir. Bu merdiven tipi hiçbir binada kaçış yolu olarak kabul edilmemektedir. YENİ BİNA 'larda tüm merdiven tiplerinde insanların tahliye esnasında dinlenebileceği sahanlıkların bulunması Yönetmeliğe göre zorunludur.",
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

    if (hYapi >= 51.50) {
      if (!basinclandirmaVar)
        notes.add(
          "51.50m üzeri binalarda her iki 'Korunumlu Merdiven' inde hem YGH hem de Basınçlandırma Sistemi tesis edilmesi zorunludur.",
        );
    }

    // --- Madde 41 ve Korunumlu Merdiven (Sayısal vb.) Kontrolleri rapor motoruna devredildi ---

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
            " $prefix genişlikleri (Merdiven: ${uStair}cm, Koridor: ${uCorridor}cm, Kapı: ${uDoor}cm) Bodrum Kat Kullanıcı Yükü ($yukBodrum Kişi) ve Bina Yüksekliği kriterlerince yeterlidir.",
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
              " [BODRUM KAT] $prefix genişlikleri (Merdiven: ${s}cm, Koridor: ${c}cm, Kapı: ${d}cm) Bodrum Kat Kullanıcı Yükü ($yBodrum Kişi) kriterlerine uygundur.",
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

    return true;
  }

  void _onFinishPressed() {
    double? genK = _genislikBilinmiyor
        ? null
        : InputValidator.parseFlex(_genislikKorunumluCtrl.text);
    double? genKS = _genislikBilinmiyor
        ? null
        : InputValidator.parseFlex(_genislikKorunumsuzCtrl.text);

    // Parse Corridor Widths
    double? korK = (_genislikBilinmiyor || _areWidthsSame)
        ? null // If same, we don't save separate corridor width? Or duplicate it? Best to save as null and fallback to genK in logic.
        : InputValidator.parseFlex(_koridorGenislikKorunumluCtrl.text);

    double? korKS = (_genislikBilinmiyor || _areWidthsSame)
        ? null
        : InputValidator.parseFlex(_koridorGenislikKorunumsuzCtrl.text);

    double? kGenK = _kapiGenislikBilinmiyor
        ? null
        : InputValidator.parseFlex(_kapiGenislikKorunumluCtrl.text);
    double? kGenKS = _kapiGenislikBilinmiyor
        ? null
        : InputValidator.parseFlex(_kapiGenislikKorunumsuzCtrl.text);

    String finalReport = _evaluateStairsAndExits();
    _model = _model.copyWith(
      areWidthsSame: _areWidthsSame,
      genislikKorunumlu: genK,
      genislikKorunumsuz: genKS,
      koridorGenislikKorunumlu: korK,
      koridorGenislikKorunumsuz: korKS,
      kapiGenislikKorunumlu: kGenK,
      kapiGenislikKorunumsuz: kGenKS,
      merdivenDegerlendirme: finalReport.length > 2000
          ? finalReport.substring(0, 2000)
          : finalReport,
    );
    BinaStore.instance.bolum36 = _model;
    BinaStore.instance.markAsCompleted();
    BinaStore.instance.saveToDisk(immediate: true);
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
      title: "Genel Değerlendirme",
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
        maxLength: 6, // Senior QA: Layout crash prevention (Supports 600.00)
        style: const TextStyle(fontSize: 14),
        decoration: AppStyles.inputDecoration(label, suffix: "cm").copyWith(
          counterText: "", // Hide counter for cleaner UI
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
    return CustomInfoNote(text: text, icon: Icons.arrow_downward);
  }
}
