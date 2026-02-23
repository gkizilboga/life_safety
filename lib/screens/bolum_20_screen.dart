import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_20_model.dart';
import 'bolum_21_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';
import '../../utils/input_validator.dart';
import '../../utils/app_theme.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart';

class Bolum20Screen extends StatefulWidget {
  const Bolum20Screen({super.key});

  @override
  State<Bolum20Screen> createState() => _Bolum20ScreenState();
}

class _Bolum20ScreenState extends State<Bolum20Screen> {
  Bolum20Model _model = Bolum20Model();

  bool _isTekKatli = false;
  bool _hasBodrum = false;
  bool _showBasinclandirma = false;
  bool _hasDairesel = false;
  bool _isBodrumIndependent = false; // Confirmed state

  // Upper/Main Stair Controllers
  final _normalCtrl = TextEditingController();
  final _icKapaliCtrl = TextEditingController();
  final _disKapaliCtrl = TextEditingController();
  final _disAcikCtrl = TextEditingController();
  final _donerCtrl = TextEditingController();
  final _sahanliksizCtrl = TextEditingController();
  final _dengelenmisCtrl = TextEditingController(); // NEW

  // Basement Independent Stair Controllers
  final _bodNormalCtrl = TextEditingController();
  final _bodIcKapaliCtrl = TextEditingController();
  final _bodDisKapaliCtrl = TextEditingController();
  final _bodDisAcikCtrl = TextEditingController();
  final _bodDonerCtrl = TextEditingController();
  final _bodSahanliksizCtrl = TextEditingController();
  final _bodDengelenmisCtrl = TextEditingController();

  // Direct Exit Controllers (Madde 41 - Simplified)
  final _toplamDirectCtrl = TextEditingController();
  /* Removed individual direct controllers
  final _normalDirectCtrl = TextEditingController();
  final _icKapaliDirectCtrl = TextEditingController();
  ...
  */

  // Distance Status (Madde 41) - Changed from numeric to choice
  ChoiceResult? _lobiMesafeDurumu;

  final _bodToplamDirectCtrl = TextEditingController();
  /* Removed individual basement direct controllers
  final _bodNormalDirectCtrl = TextEditingController();
  ...
  */

  // Basement Distance Status (Madde 41) - Changed from numeric to choice
  ChoiceResult? _bodLobiMesafeDurumu;

  // Errors for Main
  String? _normalErr;
  String? _icKapaliErr;
  String? _disKapaliErr;
  String? _disAcikErr;
  String? _donerErr;
  String? _sahanliksizErr;
  String? _dengelenmisErr; // NEW

  // Errors for Basement
  String? _bodNormalErr;
  String? _bodIcKapaliErr;
  String? _bodDisKapaliErr;
  String? _bodDisAcikErr;
  String? _bodDonerErr;
  String? _bodSahanliksizErr;
  String? _bodDengelenmisErr; // NEW

  @override
  void initState() {
    super.initState();
    _loadBuildingInfo();

    // Listeners for Main
    _normalCtrl.addListener(_validateLimits);
    _icKapaliCtrl.addListener(_validateLimits);
    _disKapaliCtrl.addListener(_validateLimits);
    _disAcikCtrl.addListener(_validateLimits);
    _donerCtrl.addListener(_validateLimits);
    _sahanliksizCtrl.addListener(_validateLimits);
    _dengelenmisCtrl.addListener(_validateLimits);

    // Listeners for Basement
    _bodNormalCtrl.addListener(_validateLimits);
    _bodIcKapaliCtrl.addListener(_validateLimits);
    _bodDisKapaliCtrl.addListener(_validateLimits);
    _bodDisAcikCtrl.addListener(_validateLimits);
    _bodDonerCtrl.addListener(_validateLimits);
    _bodSahanliksizCtrl.addListener(_validateLimits);
    _bodDengelenmisCtrl.addListener(_validateLimits); // NEW

    // Load existing data
    final saved = BinaStore.instance.bolum20;
    if (saved != null) {
      _model = saved;
      // Main
      if (saved.normalMerdivenSayisi > 0)
        _normalCtrl.text = saved.normalMerdivenSayisi.toString();
      if (saved.binaIciYanginMerdiveniSayisi > 0)
        _icKapaliCtrl.text = saved.binaIciYanginMerdiveniSayisi.toString();
      if (saved.binaDisiKapaliYanginMerdiveniSayisi > 0)
        _disKapaliCtrl.text = saved.binaDisiKapaliYanginMerdiveniSayisi
            .toString();
      if (saved.binaDisiAcikYanginMerdiveniSayisi > 0)
        _disAcikCtrl.text = saved.binaDisiAcikYanginMerdiveniSayisi.toString();
      if (saved.donerMerdivenSayisi > 0)
        _donerCtrl.text = saved.donerMerdivenSayisi.toString();
      if (saved.sahanliksizMerdivenSayisi > 0)
        _sahanliksizCtrl.text = saved.sahanliksizMerdivenSayisi.toString();
      if (saved.dengelenmisMerdivenSayisi > 0)
        _dengelenmisCtrl.text = saved.dengelenmisMerdivenSayisi.toString();

      // Load Direct Exits
      if (saved.toplamDisariAcilanMerdivenSayisi > 0)
        _toplamDirectCtrl.text = saved.toplamDisariAcilanMerdivenSayisi
            .toString();

      // Load Distance Status
      _lobiMesafeDurumu = saved.lobiTahliyeMesafeDurumu;

      // Basement
      _isBodrumIndependent = saved.isBodrumIndependent;
      if (_isBodrumIndependent) {
        if (saved.bodrumNormalMerdivenSayisi > 0)
          _bodNormalCtrl.text = saved.bodrumNormalMerdivenSayisi.toString();
        if (saved.bodrumBinaIciYanginMerdiveniSayisi > 0)
          _bodIcKapaliCtrl.text = saved.bodrumBinaIciYanginMerdiveniSayisi
              .toString();
        if (saved.bodrumBinaDisiKapaliYanginMerdiveniSayisi > 0)
          _bodDisKapaliCtrl.text = saved
              .bodrumBinaDisiKapaliYanginMerdiveniSayisi
              .toString();
        if (saved.bodrumBinaDisiAcikYanginMerdiveniSayisi > 0)
          _bodDisAcikCtrl.text = saved.bodrumBinaDisiAcikYanginMerdiveniSayisi
              .toString();
        if (saved.bodrumDonerMerdivenSayisi > 0)
          _bodDonerCtrl.text = saved.bodrumDonerMerdivenSayisi.toString();
        if (saved.bodrumSahanliksizMerdivenSayisi > 0)
          _bodSahanliksizCtrl.text = saved.bodrumSahanliksizMerdivenSayisi
              .toString();
        if (saved.bodrumDengelenmisMerdivenSayisi > 0) // NEW
          _bodDengelenmisCtrl.text = saved.bodrumDengelenmisMerdivenSayisi
              .toString();

        if (saved.bodrumToplamDisariAcilanMerdivenSayisi > 0)
          _bodToplamDirectCtrl.text = saved
              .bodrumToplamDisariAcilanMerdivenSayisi
              .toString();

        _bodLobiMesafeDurumu = saved.bodrumLobiTahliyeMesafeDurumu;
      }
    }
  }

  void _loadBuildingInfo() {
    final bolum3 = BinaStore.instance.bolum3;
    int nKat = bolum3?.normalKatSayisi ?? 0;
    int bKat = bolum3?.bodrumKatSayisi ?? 0;
    int toplamKat = nKat + bKat + 1;

    setState(() {
      _isTekKatli = (toplamKat == 1);
      _hasBodrum = (bKat > 0);
    });
  }

  void _validateLimits() {
    setState(() {
      // Main Errors
      _normalErr = _checkLimit(_normalCtrl.text);
      _icKapaliErr = _checkLimit(_icKapaliCtrl.text);
      _disKapaliErr = _checkLimit(_disKapaliCtrl.text);
      _disAcikErr = _checkLimit(_disAcikCtrl.text);
      _donerErr = _checkLimit(_donerCtrl.text);
      _sahanliksizErr = _checkLimit(_sahanliksizCtrl.text);
      _dengelenmisErr = _checkLimit(_dengelenmisCtrl.text); // NEW

      // Basement Errors
      if (_isBodrumIndependent) {
        _bodNormalErr = _checkLimit(_bodNormalCtrl.text);
        _bodIcKapaliErr = _checkLimit(_bodIcKapaliCtrl.text);
        _bodDisKapaliErr = _checkLimit(_bodDisKapaliCtrl.text);
        _bodDisAcikErr = _checkLimit(_bodDisAcikCtrl.text);
        _bodDonerErr = _checkLimit(_bodDonerCtrl.text);
        _bodSahanliksizErr = _checkLimit(_bodSahanliksizCtrl.text);
        _bodDengelenmisErr = _checkLimit(_bodDengelenmisCtrl.text); // NEW
      }

      // Show Basinclandirma Logic (Combined check)
      int ic = int.tryParse(_icKapaliCtrl.text) ?? 0;
      int dis = int.tryParse(_disKapaliCtrl.text) ?? 0;
      int bIc = int.tryParse(_bodIcKapaliCtrl.text) ?? 0; // Check basement too?
      int bDis = int.tryParse(_bodDisKapaliCtrl.text) ?? 0;

      // Logic: Show pressurization if ANY protected stair exists
      _showBasinclandirma = (ic >= 1 || dis >= 1 || bIc >= 1 || bDis >= 1);

      // Logic: Show Dairesel Height question if spiral stairs exist
      int doner = int.tryParse(_donerCtrl.text) ?? 0;
      int bDoner = int.tryParse(_bodDonerCtrl.text) ?? 0;

      bool daireselExists = doner > 0;
      if (_isBodrumIndependent && bDoner > 0) daireselExists = true;

      _hasDairesel = daireselExists;
      if (!_hasDairesel) {
        _model = _model.copyWith(daireselMerdivenYuksekligi: null);
      }

      if (!_showBasinclandirma) {
        _model = _model.copyWith(basinclandirma: null);
      }
    });
  }

  bool _shouldShowLobbyDistanceQuestion() {
    int total =
        (int.tryParse(_normalCtrl.text) ?? 0) +
        (int.tryParse(_icKapaliCtrl.text) ?? 0) +
        (int.tryParse(_disKapaliCtrl.text) ?? 0) +
        (int.tryParse(_donerCtrl.text) ?? 0) +
        (int.tryParse(_dengelenmisCtrl.text) ?? 0) +
        (int.tryParse(_disAcikCtrl.text) ?? 0) +
        (int.tryParse(_sahanliksizCtrl.text) ?? 0);

    int direct = int.tryParse(_toplamDirectCtrl.text) ?? 0;

    return total > 0 && direct < total;
  }

  bool _shouldShowBasementLobbyDistanceQuestion() {
    if (!_isBodrumIndependent) return false;

    int total =
        (int.tryParse(_bodNormalCtrl.text) ?? 0) +
        (int.tryParse(_bodIcKapaliCtrl.text) ?? 0) +
        (int.tryParse(_bodDisKapaliCtrl.text) ?? 0) +
        (int.tryParse(_bodDonerCtrl.text) ?? 0) +
        (int.tryParse(_bodDengelenmisCtrl.text) ?? 0) +
        (int.tryParse(_bodDisAcikCtrl.text) ?? 0) +
        (int.tryParse(_bodSahanliksizCtrl.text) ?? 0);

    int direct = int.tryParse(_bodToplamDirectCtrl.text) ?? 0;

    return total > 0 && direct < total;
  }

  String? _checkLimit(String text) {
    return InputValidator.validateNumber(
      text,
      min: 0,
      max: 6,
      unit: "adet",
      isRequired: false,
    );
  }

  bool get _isLimitValid {
    bool mainValid =
        _normalErr == null &&
        _icKapaliErr == null &&
        _disKapaliErr == null &&
        _disAcikErr == null &&
        _donerErr == null &&
        _sahanliksizErr == null &&
        _dengelenmisErr == null; // NEW

    if (!_isBodrumIndependent) return mainValid;

    bool bodrumValid =
        _bodNormalErr == null &&
        _bodIcKapaliErr == null &&
        _bodDisKapaliErr == null &&
        _bodDisAcikErr == null &&
        _bodDonerErr == null &&
        _bodSahanliksizErr == null &&
        _bodDengelenmisErr == null; // NEW

    return mainValid && bodrumValid;
  }

  @override
  void dispose() {
    _normalCtrl.dispose();
    _icKapaliCtrl.dispose();
    _disKapaliCtrl.dispose();
    _disAcikCtrl.dispose();
    _donerCtrl.dispose();
    _sahanliksizCtrl.dispose();
    _dengelenmisCtrl.dispose(); // NEW

    _bodNormalCtrl.dispose();
    _bodIcKapaliCtrl.dispose();
    _bodDisKapaliCtrl.dispose();
    _bodDisAcikCtrl.dispose();
    _bodDonerCtrl.dispose();
    _bodSahanliksizCtrl.dispose();
    _bodDengelenmisCtrl.dispose();

    _toplamDirectCtrl.dispose();

    _bodToplamDirectCtrl.dispose();

    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    if (type == 'bodrum') {
      if (choice.label == Bolum20Content.bodrumOptionB.label) {
        // "Hayır, bodruma inen merdiven farklı bir yerde" selected - DIRECTLY ENABLE without dialog
        setState(() {
          _isBodrumIndependent = true;
          _model = _model.copyWith(
            bodrumMerdivenDevami: choice,
            isBodrumIndependent: true,
          );
        });
        return;
      } else {
        // "Evet" selected (Reset independent)
        setState(() {
          _isBodrumIndependent = false;
          _model = _model.copyWith(
            bodrumMerdivenDevami: choice,
            isBodrumIndependent: false,
          );
          // Clear basement inputs
          _bodNormalCtrl.clear();
          _bodIcKapaliCtrl.clear();
          _bodDisKapaliCtrl.clear();
          _bodDisAcikCtrl.clear();
          _bodDonerCtrl.clear();
          _bodSahanliksizCtrl.clear();
        });
        return;
      }
    }

    setState(() {
      if (type == 'tekKatCikis') _model = _model.copyWith(tekKatCikis: choice);
      if (type == 'tekKatRampa') _model = _model.copyWith(tekKatRampa: choice);
      if (type == 'basinclandirma')
        _model = _model.copyWith(basinclandirma: choice);
      if (type == 'havalandirma')
        _model = _model.copyWith(havalandirma: choice);
      if (type == 'daireselH')
        _model = _model.copyWith(daireselMerdivenYuksekligi: choice);
    });
  }

  bool _validateAndSave() {
    if (_isTekKatli) {
      if (_model.tekKatCikis == null || _model.tekKatRampa == null)
        return false;
    } else {
      // Validate Main Stairs
      int normal = int.tryParse(_normalCtrl.text) ?? 0;
      int icKapali = int.tryParse(_icKapaliCtrl.text) ?? 0;
      int disKapali = int.tryParse(_disKapaliCtrl.text) ?? 0;
      int disAcik = int.tryParse(_disAcikCtrl.text) ?? 0;
      int doner = int.tryParse(_donerCtrl.text) ?? 0;
      int sahanliksiz = int.tryParse(_sahanliksizCtrl.text) ?? 0;
      int dengelenmis = int.tryParse(_dengelenmisCtrl.text) ?? 0;

      int totalStairs =
          normal +
          icKapali +
          disKapali +
          disAcik +
          doner +
          sahanliksiz +
          dengelenmis;

      // Validation: Direct Count <= Total Count
      int totalDirect = int.tryParse(_toplamDirectCtrl.text) ?? 0;
      if (totalDirect > totalStairs) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Dışarı açılan merdiven sayısı toplam merdiven sayısından fazla olamaz.",
            ),
          ),
        );
        return false;
      }

      if (totalStairs == 0) return false;

      // Validate Basement Stairs if Independent
      int bNormal = 0,
          bIc = 0,
          bDisK = 0,
          bDisA = 0,
          bDoner = 0,
          bSahan = 0,
          bDengelenmis = 0;
      if (_isBodrumIndependent) {
        bNormal = int.tryParse(_bodNormalCtrl.text) ?? 0;
        bIc = int.tryParse(_bodIcKapaliCtrl.text) ?? 0;
        bDisK = int.tryParse(_bodDisKapaliCtrl.text) ?? 0;
        bDisA = int.tryParse(_bodDisAcikCtrl.text) ?? 0;
        bDoner = int.tryParse(_bodDonerCtrl.text) ?? 0;
        bSahan = int.tryParse(_bodSahanliksizCtrl.text) ?? 0;
        bDengelenmis = int.tryParse(_bodDengelenmisCtrl.text) ?? 0; // NEW

        int totalBasement =
            bNormal + bIc + bDisK + bDisA + bDoner + bSahan + bDengelenmis;

        if (totalBasement == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Bodrum kat için en az bir merdiven tipi girmelisiniz.",
              ),
            ),
          );
          return false;
        }

        // Validate Basement Direct Exits
        int bTotalDirect = int.tryParse(_bodToplamDirectCtrl.text) ?? 0;

        if (bTotalDirect > totalBasement) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Bodrum kat: Dışarı açılan merdiven sayısı toplam sayıdan fazla olamaz.",
              ),
            ),
          );
          return false;
        }
      }

      if (_model.isDaireselYukseklikRequired &&
          _model.daireselMerdivenYuksekligi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lütfen dairesel merdiven yüksekliğini seçiniz."),
          ),
        );
        return false;
      }

      if (_showBasinclandirma && _model.basinclandirma == null) return false;

      // Havalandırma is required for all multi-story buildings
      if (_model.havalandirma == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lütfen havalandırma durumunu seçiniz."),
          ),
        );
        return false;
      }

      _model = _model.copyWith(
        normalMerdivenSayisi: normal,
        binaIciYanginMerdiveniSayisi: icKapali,
        binaDisiKapaliYanginMerdiveniSayisi: disKapali,
        binaDisiAcikYanginMerdiveniSayisi: disAcik,
        donerMerdivenSayisi: doner,
        sahanliksizMerdivenSayisi: sahanliksiz,
        dengelenmisMerdivenSayisi: dengelenmis,

        // Save Direct Exits
        toplamDisariAcilanMerdivenSayisi:
            int.tryParse(_toplamDirectCtrl.text) ?? 0,

        lobiTahliyeMesafeDurumu: _lobiMesafeDurumu,

        // Save Basement Data
        isBodrumIndependent: _isBodrumIndependent,
        bodrumNormalMerdivenSayisi: bNormal,
        bodrumBinaIciYanginMerdiveniSayisi: bIc,
        bodrumBinaDisiKapaliYanginMerdiveniSayisi: bDisK,
        bodrumBinaDisiAcikYanginMerdiveniSayisi: bDisA,
        bodrumDonerMerdivenSayisi: bDoner,
        bodrumSahanliksizMerdivenSayisi: bSahan,
        bodrumDengelenmisMerdivenSayisi: bDengelenmis,

        bodrumToplamDisariAcilanMerdivenSayisi:
            int.tryParse(_bodToplamDirectCtrl.text) ?? 0,

        bodrumLobiTahliyeMesafeDurumu: _bodLobiMesafeDurumu,
      );
    }

    if (_hasBodrum && _model.bodrumMerdivenDevami == null) return false;

    BinaStore.instance.bolum20 = _model;
    BinaStore.instance.saveToDisk();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kaçış Merdivenleri",
      subtitle: "Merdiven tipleri ve adetleri",
      screenType: widget.runtimeType,
      isNextEnabled: _isLimitValid,
      onNext: () async {
        if (_validateAndSave()) {
          // Capture navigator before async gap
          final navigator = Navigator.of(context);

          // Check for independent basement stairs warning
          if (_isBodrumIndependent) {
            bool confirmed =
                await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(child: Text("Dikkat: Merdiven Konumu")),
                      ],
                    ),
                    content: const Text(
                      "Bodrum kat merdivenlerinin, normal kat merdivenlerinden FARKLI bir konumda (bağımsız) olduğunu belirttiniz.\n\nBu durum, kaçış yollarının sürekliliği açısından kritik bir bilgidir.\n\nOnaylıyor musunuz?",
                      style: TextStyle(fontSize: 15),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text("Geri Dön"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Anladım, Devam Et"),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (!confirmed) return;
          }

          if (!mounted) return;
          navigator.push(
            MaterialPageRoute(
              builder: (context) => ModuleTransitionScreen(
                module: ReportModule.modul2,
                onContinue: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Bolum21Screen(),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          // If snackbar wasn't shown in validation
          if (_isLimitValid) {
            // Only show generic if limits are OK but something else missed
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Lütfen gerekli alanları doğru şekilde doldurunuz.",
                ),
              ),
            );
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isTekKatli) ...[
            _buildSoru(
              "Binadan dışarıya (sokağa veya caddeye) çıkışınız nasıl?",
              'tekKatCikis',
              [Bolum20Content.tekKatOptionA],
              _model.tekKatCikis,
            ),
            _buildSoru(
              "Binadan dışarıya çıkarken rampa kullanmak zorunda kalıyor musunuz?",
              'tekKatRampa',
              [Bolum20Content.rampaOptionB, Bolum20Content.rampaOptionC],
              _model.tekKatRampa,
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 16),
              child: Text(
                "Binanızda aşağıdaki merdiven türlerinden kaçar tane var?",
                style: AppStyles.questionTitle,
              ),
            ),

            QuestionCard(
              child: Column(
                children: [
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption1.uiTitle,
                    ctrl: _normalCtrl,
                    error: _normalErr,
                    assetPath: AppAssets.section20Normal,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption2.uiTitle,
                    ctrl: _icKapaliCtrl,
                    error: _icKapaliErr,
                    assetPath: AppAssets.section20IcKapali,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption3.uiTitle,
                    ctrl: _disKapaliCtrl,
                    error: _disKapaliErr,
                    assetPath: AppAssets.section20DisKapali,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption4.uiTitle,
                    ctrl: _disAcikCtrl,
                    error: _disAcikErr,
                    assetPaths: [
                      AppAssets.section20DisAcik1,
                      AppAssets.section20DisAcik2,
                    ],
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption5.uiTitle,
                    ctrl: _donerCtrl,
                    error: _donerErr,
                    assetPath: AppAssets.section20Dairesel,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption6.uiTitle,
                    ctrl: _sahanliksizCtrl,
                    error: _sahanliksizErr,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption7.uiTitle,
                    ctrl: _dengelenmisCtrl,
                    error: _dengelenmisErr,
                    assetPath: AppAssets.section20Dengelenmis,
                  ),
                ],
              ),
            ),

            // Total Direct Exits Question (Upper Floors)
            const SizedBox(height: 12),
            _buildTotalDirectInput(),

            // LOBI MESAFE SORUSU (Madde 41)
            if (_shouldShowLobbyDistanceQuestion()) ...[
              const SizedBox(height: 14),
              _buildLobbyDistanceInput(),
            ],
          ],

          // Stair Classification Summary
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Merdiven Sınıflandırması (Otomatik Hesaplandı)',
                  style: AppStyles.questionTitle,
                ),
                const SizedBox(height: 12),
                _buildClassificationRow(
                  'Korunumlu Merdiven',
                  (int.tryParse(_icKapaliCtrl.text) ?? 0) +
                      (int.tryParse(_disKapaliCtrl.text) ?? 0),
                  Colors.green.shade700,
                ),
                const SizedBox(height: 8),
                _buildClassificationRow(
                  'Korunumsuz Merdiven',
                  (int.tryParse(_normalCtrl.text) ?? 0) +
                      (int.tryParse(_disAcikCtrl.text) ?? 0) +
                      (int.tryParse(_donerCtrl.text) ?? 0) +
                      (int.tryParse(_sahanliksizCtrl.text) ?? 0) +
                      (int.tryParse(_dengelenmisCtrl.text) ?? 0),
                  Colors.orange.shade700,
                ),
              ],
            ),
          ),

          if (_hasBodrum)
            _buildSoru(
              "Bodrum kata inen merdiveniniz, üst katlara çıkan merdivenin devamı mı?",
              'bodrum',
              [Bolum20Content.bodrumOptionA, Bolum20Content.bodrumOptionB],
              _model.bodrumMerdivenDevami,
            ),

          // Independent Basement Stairs Section
          if (_isBodrumIndependent) ...[
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 16, top: 20),
              child: Text(
                "Bodrum Katlar İçin Özel Merdiven Bilgileri",
                style: AppStyles
                    .questionTitle, // Fixed style: headerTitle was white on white
              ),
            ),
            CustomInfoNote(
              text:
                  "Bağımsız olduğunu belirttiğiniz bodrum kat merdivenlerinin türlerini ve sayılarını aşağıya giriniz.",
              icon: Icons.info_outline,
            ),
            QuestionCard(
              child: Column(
                children: [
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption1.uiTitle}",
                    ctrl: _bodNormalCtrl,
                    error: _bodNormalErr,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption2.uiTitle}",
                    ctrl: _bodIcKapaliCtrl,
                    error: _bodIcKapaliErr,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption3.uiTitle}",
                    ctrl: _bodDisKapaliCtrl,
                    error: _bodDisKapaliErr,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption4.uiTitle}",
                    ctrl: _bodDisAcikCtrl,
                    error: _bodDisAcikErr,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption5.uiTitle}",
                    ctrl: _bodDonerCtrl,
                    error: _bodDonerErr,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption6.uiTitle}",
                    ctrl: _bodSahanliksizCtrl,
                    error: _bodSahanliksizErr,
                  ),
                  const Divider(height: 16),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption7.uiTitle}",
                    ctrl: _bodDengelenmisCtrl,
                    error: _bodDengelenmisErr,
                  ),
                ],
              ),
            ),

            // Total Direct Exits Question (Basement)
            const SizedBox(height: 16),
            _buildTotalDirectInput(isBasement: true),

            // Basement Lobby Distance
            if (_shouldShowBasementLobbyDistanceQuestion()) ...[
              const SizedBox(height: 16),
              _buildLobbyDistanceInput(isBasement: true),
            ],
          ],

          if (_hasDairesel)
            _buildSoru(
              "Binadaki dairesel merdivenin yüksekliği nedir?",
              'daireselH',
              [
                Bolum20Content.daireselYukseklikOptionA,
                Bolum20Content.daireselYukseklikOptionB,
                Bolum20Content.daireselYukseklikOptionC,
              ],
              _model.daireselMerdivenYuksekligi,
            ),

          if (_showBasinclandirma)
            _buildSoruWithDef(
              "Merdivenlerde basınçlandırma sistemi var mı?",
              AppDefinitions.basinclandirma,
              "Basınçlandırma Sistemi",
              'basinclandirma',
              [
                Bolum20Content.basYghOptionA,
                Bolum20Content.basYghOptionB,
                Bolum20Content.basYghOptionC,
              ],
              _model.basinclandirma,
            ),

          // Havalandırma Question (Madde 45) - Always shown for multi-story
          if (!_isTekKatli)
            _buildSoruWithDef(
              "Merdivenlerde doğal havalandırma var mı?",
              AppDefinitions.havalandirma,
              "Havalandırma (Madde 45)",
              'havalandirma',
              [
                Bolum20Content.havalandirmaOptionA,
                Bolum20Content.havalandirmaOptionB,
                Bolum20Content.havalandirmaOptionC,
                Bolum20Content.havalandirmaOptionD,
              ],
              _model.havalandirma,
            ),
        ],
      ),
    );
  }

  Widget _buildStairInputGroup({
    required String label,
    required TextEditingController ctrl,
    String? error,
    String? assetPath,
    List<String>? assetPaths,
  }) {
    // Simplify: removed directCtrl sub-input logic from here

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 55,
              child: TextFormField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [InputValidator.positiveInteger],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  border: const OutlineInputBorder(),
                  hintText: "0",
                  errorText: error,
                  errorStyle: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (assetPath != null)
          TechnicalDrawingButton(assetPath: assetPath, title: label),
        if (assetPaths != null)
          ...assetPaths.map(
            (path) => TechnicalDrawingButton(assetPath: path, title: label),
          ),
      ],
    );
  }

  Widget _buildTotalDirectInput({bool isBasement = false}) {
    int total = 0;
    if (isBasement) {
      total =
          (int.tryParse(_bodNormalCtrl.text) ?? 0) +
          (int.tryParse(_bodIcKapaliCtrl.text) ?? 0) +
          (int.tryParse(_bodDisKapaliCtrl.text) ?? 0) +
          (int.tryParse(_bodDonerCtrl.text) ?? 0) +
          (int.tryParse(_bodDengelenmisCtrl.text) ?? 0) +
          (int.tryParse(_bodDisAcikCtrl.text) ?? 0) +
          (int.tryParse(_bodSahanliksizCtrl.text) ?? 0);
    } else {
      total =
          (int.tryParse(_normalCtrl.text) ?? 0) +
          (int.tryParse(_icKapaliCtrl.text) ?? 0) +
          (int.tryParse(_disKapaliCtrl.text) ?? 0) +
          (int.tryParse(_donerCtrl.text) ?? 0) +
          (int.tryParse(_dengelenmisCtrl.text) ?? 0) +
          (int.tryParse(_disAcikCtrl.text) ?? 0) +
          (int.tryParse(_sahanliksizCtrl.text) ?? 0);
    }

    if (total == 0) return const SizedBox.shrink();

    final ctrl = isBasement ? _bodToplamDirectCtrl : _toplamDirectCtrl;
    final title = isBasement
        ? "Bodrum Kat: Dışarıya Açılan Merdivenler"
        : "Dışarıya Açılan Merdivenler";
    String desc =
        "Bu $total adet merdivenden kaç tanesi doğrudan dışarı (bina dışına) açılmaktadır?";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBasement ? Colors.orange.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBasement ? Colors.orange.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          SizedBox(
            width: 120,
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [InputValidator.positiveInteger],
              decoration: InputDecoration(
                hintText: "0",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(
    String title,
    String keyParam,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => _handleSelection(keyParam, opt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoruWithDef(
    String title,
    String def,
    String term,
    String keyParam,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              DefinitionButton(term: term, definition: def),
            ],
          ),
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => _handleSelection(keyParam, opt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLobbyDistanceInput({bool isBasement = false}) {
    // Get sprinkler status from Bolum9
    final hasSprinkler = BinaStore.instance.bolum9?.secim?.label == "9-1-A";
    final limit = hasSprinkler ? 15 : 10;

    final title = isBasement
        ? "Bodrum Kat: Lobi/Koridor Tahliye Mesafesi"
        : "Lobi/Koridor Tahliye Mesafesi";

    final question =
        "Dışarıya açılmayan merdivenlerin bina içi tahliye mesafesi $limit metrenin altında mı?";

    final currentSelection = isBasement
        ? _bodLobiMesafeDurumu
        : _lobiMesafeDurumu;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBasement ? Colors.orange.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBasement ? Colors.orange.shade200 : Colors.blue.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 8),
          Text(question, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          SelectableCard(
            choice: Bolum20Content.madde41MesafeAltinda.copyWith(
              uiTitle: "$limit m veya altında",
            ),
            isSelected:
                currentSelection?.label ==
                Bolum20Content.madde41MesafeAltinda.label,
            onTap: () {
              setState(() {
                if (isBasement) {
                  _bodLobiMesafeDurumu = Bolum20Content.madde41MesafeAltinda;
                } else {
                  _lobiMesafeDurumu = Bolum20Content.madde41MesafeAltinda;
                }
              });
            },
          ),
          SelectableCard(
            choice: Bolum20Content.madde41MesafeUstunde.copyWith(
              uiTitle: "$limit m üzerinde",
            ),
            isSelected:
                currentSelection?.label ==
                Bolum20Content.madde41MesafeUstunde.label,
            onTap: () {
              setState(() {
                if (isBasement) {
                  _bodLobiMesafeDurumu = Bolum20Content.madde41MesafeUstunde;
                } else {
                  _lobiMesafeDurumu = Bolum20Content.madde41MesafeUstunde;
                }
              });
            },
          ),
          SelectableCard(
            choice: Bolum20Content.madde41MesafeBilmiyorum,
            isSelected:
                currentSelection?.label ==
                Bolum20Content.madde41MesafeBilmiyorum.label,
            onTap: () {
              setState(() {
                if (isBasement) {
                  _bodLobiMesafeDurumu = Bolum20Content.madde41MesafeBilmiyorum;
                } else {
                  _lobiMesafeDurumu = Bolum20Content.madde41MesafeBilmiyorum;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationRow(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
