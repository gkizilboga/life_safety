import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart';
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
  final GlobalKey _gorunurlukKey = GlobalKey();

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

    _cntDisCelik = disAcik;
    _totalValidCikisSayisi = icKapali + disKapali + normal + doner + disAcik;

    _hasKorunumlu = (icKapali + disKapali) > 0;
    _hasKorunumsuz = (normal + doner + disAcik + sahanliksiz) > 0;

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
              _kGenKerr = "Kapı genişliği merdivenden büyük olamaz.";
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
              _kGenKSerr = "Kapı genişliği merdivenden büyük olamaz.";
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
    bool basinclandirmaVar = b20?.basinclandirma?.label == "20-BAS-A";

    List<String> notes = [];

    // --- Merdiven Tipi ve Sayısı Kontrolleri (Mevcut Logic) ---
    if (sahanliksiz > 0)
      notes.add(
        "Binada 'Sahanlıksız Merdiven' tespit edilmiştir. Bu merdiven tipi hiçbir binada kaçış yolu olarak kabul edilemez. YENİ BİNA 'larda tüm merdiven tiplerinde insanların tahliye esnasında dinlenebileceği sahanlıkların bulunması Yönetmeliğe göre zorunludur.",
      );
    if (hBina > 9.50 && doner > 0)
      notes.add(
        "Bina yüksekliği 9.50m üzerinde olduğu için 'Dairesel Merdiven' kullanılamaz. Dairesel merdiven ile özel çözüm gereken katlar varsa Uzman görüşü alınması önerilir.",
      );
    if (hBina > 21.50 && disAcik > 0)
      notes.add(
        "Bina yüksekliği 21.50m üzerinde olduğu için 'Bina Dışı Açık Çelik Merdiven' kullanılamaz.",
      );

    if (hYapi < 21.50)
      notes.add(
        "Yapı yüksekliği 21.50m altındadır. Sahanlıksız Merdiven ve Dengelenmiş Merdiven hariç tüm merdiven tipleri kullanılabilir.",
      );
    else if (hYapi >= 21.50 && hYapi < 30.50) {
      if (korunumlu >= 1)
        notes.add(
          "Yapı yüksekliği 21.50m-30.50m arasındadır ve en az 1 adet 'Korunumlu Merdiven' mevcuttur.",
        );
      else
        notes.add(
          "Yapı yüksekliği 21.50m-30.50m arasındadır. En az 1 adet 'Korunumlu Merdiven' zorunludur.",
        );
    } else if (hYapi >= 30.50 && hYapi < 51.50) {
      if (korunumlu >= 2)
        notes.add(
          "Yapı yüksekliği 30.50m-51.50m arasındadır ve en az 2 adet 'Korunumlu Merdiven' mevcuttur.",
        );
      else
        notes.add(
          "Yapı yüksekliği 30.50m-51.50m arasındadır. En az 2 adet 'Korunumlu Merdiven' zorunludur.",
        );
    } else if (hYapi >= 51.50) {
      if (korunumlu >= 2)
        notes.add(
          "Yapı yüksekliği 51.50m üzerindedir ve en az 2 adet 'Korunumlu Merdiven' mevcuttur.",
        );
      else
        notes.add(
          "Yapı yüksekliği 51.50m üzerindedir. En az 2 adet 'Korunumlu Merdiven' zorunludur.",
        );
      if (!basinclandirmaVar)
        notes.add(
          "51.50m üzeri binalarda her iki 'Korunumlu Merdiven'inde hem YGH hem de Basınçlandırma Sistemi tesis edilmesi zorunludur.",
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
            "🚨 $prefix İÇİN GENİŞLİK İHLALLERİ:\n- ${violations.join("\n- ")}",
          );
        } else {
          notes.add(
            "✅ $prefix genişlikleri Bodrum Kat Kullanıcı Yükü ($yukBodrum Kişi) ve Bina Yüksekliği kriterlerine uygundur.",
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

    // --- Çıkış Sayısı Kontrolü ---
    int gerekli = b33?.gerekliNormal ?? 0;
    int mevcut = b33?.mevcutUst ?? 0;
    if (mevcut >= gerekli)
      notes.add(
        "✅ ÇIKIŞ SAYISI YETERLİ: Mevcut çıkış sayısı ($mevcut), gereken çıkış sayısından ($gerekli) fazla veya eşit olduğundan, çıkış sayısı bakımından yeterli gözükmektedir. Ancak bu durum tek başına yeterli olmayıp, binadaki merdiven tiplerinin ve adedinin kriterleri de uygun olması gereklidir.",
      );
    else
      notes.add(
        "🚨 ÇIKIŞ SAYISI YETERSİZ: Yönetmelik gereği $gerekli çıkış gerekirken, binada sadece $mevcut çıkış bulunmaktadır. Çıkış sayısı bakımından yetersiz gözükmektedir. Bu durumla birlikte binadaki merdiven tiplerinin ve adetlerinin de Yönetmelik kriterlerini karşılaması beklenir.",
      );
    return notes.join("\n\n");
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

          _buildSoruHeader("Merdiven ve Koridor temiz genişliği (cm) kaçtır?"),
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
                    border: Border.all(color: Colors.blue.shade100),
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
                        // If turning ON same widths, clear separate corridor inputs to avoid confusion?
                        // Or keep them. Let's just update UI.
                      });
                    },
                  ),
                ),

                if (_hasKorunumlu) ...[
                  _buildInput(
                    _areWidthsSame
                        ? "Korunumlu Merdiven/Koridor Genişliği"
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
                        ? "Korunumsuz Merdiven/Koridor Genişliği"
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
                    "Korunumlu Merdiven Kapı Genişliği",
                    _kapiGenislikKorunumluCtrl,
                    _kapiGenislikBilinmiyor,
                    _kGenKerr,
                  ),
                if (_hasKorunumsuz)
                  _buildInput(
                    "Korunumsuz Merdiven Kapı Genişliği",
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
          SizedBox(key: _gorunurlukKey, height: 1),
          _buildSoruHeader("Kaçış yolları açıkça görülebiliyor mu?"),
          _buildSoruCard('gorunurluk', [
            Bolum36Content.gorunurlukOptionA,
            Bolum36Content.gorunurlukOptionB,
            Bolum36Content.gorunurlukOptionC,
          ], _model.gorunurluk),
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController ctrl,
    bool isDisabled,
    String? error,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        enabled: !isDisabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
