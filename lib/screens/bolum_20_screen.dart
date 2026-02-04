import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_20_model.dart';
import 'bolum_21_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';
import '../../utils/input_validator.dart';
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
  bool _isBodrumIndependent = false; // Confirmed state

  // Upper/Main Stair Controllers
  final _normalCtrl = TextEditingController();
  final _icKapaliCtrl = TextEditingController();
  final _disKapaliCtrl = TextEditingController();
  final _disAcikCtrl = TextEditingController();
  final _donerCtrl = TextEditingController();
  final _sahanliksizCtrl = TextEditingController();

  // Basement Independent Stair Controllers
  final _bodNormalCtrl = TextEditingController();
  final _bodIcKapaliCtrl = TextEditingController();
  final _bodDisKapaliCtrl = TextEditingController();
  final _bodDisAcikCtrl = TextEditingController();
  final _bodDonerCtrl = TextEditingController();
  final _bodSahanliksizCtrl = TextEditingController();

  // Errors for Main
  String? _normalErr;
  String? _icKapaliErr;
  String? _disKapaliErr;
  String? _disAcikErr;
  String? _donerErr;
  String? _sahanliksizErr;

  // Errors for Basement
  String? _bodNormalErr;
  String? _bodIcKapaliErr;
  String? _bodDisKapaliErr;
  String? _bodDisAcikErr;
  String? _bodDonerErr;
  String? _bodSahanliksizErr;

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

    // Listeners for Basement
    _bodNormalCtrl.addListener(_validateLimits);
    _bodIcKapaliCtrl.addListener(_validateLimits);
    _bodDisKapaliCtrl.addListener(_validateLimits);
    _bodDisAcikCtrl.addListener(_validateLimits);
    _bodDonerCtrl.addListener(_validateLimits);
    _bodSahanliksizCtrl.addListener(_validateLimits);

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

      // Basement Errors
      if (_isBodrumIndependent) {
        _bodNormalErr = _checkLimit(_bodNormalCtrl.text);
        _bodIcKapaliErr = _checkLimit(_bodIcKapaliCtrl.text);
        _bodDisKapaliErr = _checkLimit(_bodDisKapaliCtrl.text);
        _bodDisAcikErr = _checkLimit(_bodDisAcikCtrl.text);
        _bodDonerErr = _checkLimit(_bodDonerCtrl.text);
        _bodSahanliksizErr = _checkLimit(_bodSahanliksizCtrl.text);
      }

      // Show Basinclandirma Logic (Combined check)
      int ic = int.tryParse(_icKapaliCtrl.text) ?? 0;
      int dis = int.tryParse(_disKapaliCtrl.text) ?? 0;
      int bIc = int.tryParse(_bodIcKapaliCtrl.text) ?? 0; // Check basement too?
      int bDis = int.tryParse(_bodDisKapaliCtrl.text) ?? 0;

      // Logic: Show pressurization if ANY protected stair exists
      _showBasinclandirma = (ic >= 1 || dis >= 1 || bIc >= 1 || bDis >= 1);

      if (!_showBasinclandirma) {
        _model = _model.copyWith(basinclandirma: null);
      }
    });
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
        _sahanliksizErr == null;

    if (!_isBodrumIndependent) return mainValid;

    bool bodrumValid =
        _bodNormalErr == null &&
        _bodIcKapaliErr == null &&
        _bodDisKapaliErr == null &&
        _bodDisAcikErr == null &&
        _bodDonerErr == null &&
        _bodSahanliksizErr == null;

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

    _bodNormalCtrl.dispose();
    _bodIcKapaliCtrl.dispose();
    _bodDisKapaliCtrl.dispose();
    _bodDisAcikCtrl.dispose();
    _bodDonerCtrl.dispose();
    _bodSahanliksizCtrl.dispose();

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

      if (normal + icKapali + disKapali + disAcik + doner + sahanliksiz == 0)
        return false;

      // Validate Basement Stairs if Independent
      int bNormal = 0, bIc = 0, bDisK = 0, bDisA = 0, bDoner = 0, bSahan = 0;
      if (_isBodrumIndependent) {
        bNormal = int.tryParse(_bodNormalCtrl.text) ?? 0;
        bIc = int.tryParse(_bodIcKapaliCtrl.text) ?? 0;
        bDisK = int.tryParse(_bodDisKapaliCtrl.text) ?? 0;
        bDisA = int.tryParse(_bodDisAcikCtrl.text) ?? 0;
        bDoner = int.tryParse(_bodDonerCtrl.text) ?? 0;
        bSahan = int.tryParse(_bodSahanliksizCtrl.text) ?? 0;

        if (bNormal + bIc + bDisK + bDisA + bDoner + bSahan == 0) {
          // Must enter at least 1 basement stair if confirmed independent
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Bodrum kat için en az bir merdiven tipi girmelisiniz.",
              ),
            ),
          );
          return false;
        }
      }

      if (_showBasinclandirma && _model.basinclandirma == null) return false;

      _model = _model.copyWith(
        normalMerdivenSayisi: normal,
        binaIciYanginMerdiveniSayisi: icKapali,
        binaDisiKapaliYanginMerdiveniSayisi: disKapali,
        binaDisiAcikYanginMerdiveniSayisi: disAcik,
        donerMerdivenSayisi: doner,
        sahanliksizMerdivenSayisi: sahanliksiz,

        // Save Basement Data
        isBodrumIndependent: _isBodrumIndependent,
        bodrumNormalMerdivenSayisi: bNormal,
        bodrumBinaIciYanginMerdiveniSayisi: bIc,
        bodrumBinaDisiKapaliYanginMerdiveniSayisi: bDisK,
        bodrumBinaDisiAcikYanginMerdiveniSayisi: bDisA,
        bodrumDonerMerdivenSayisi: bDoner,
        bodrumSahanliksizMerdivenSayisi: bSahan,
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
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption2.uiTitle,
                    ctrl: _icKapaliCtrl,
                    error: _icKapaliErr,
                    assetPath: AppAssets.section20IcKapali,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption3.uiTitle,
                    ctrl: _disKapaliCtrl,
                    error: _disKapaliErr,
                    assetPath: AppAssets.section20DisKapali,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption4.uiTitle,
                    ctrl: _disAcikCtrl,
                    error: _disAcikErr,
                    assetPaths: [
                      AppAssets.section20DisAcik1,
                      AppAssets.section20DisAcik2,
                    ],
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption5.uiTitle,
                    ctrl: _donerCtrl,
                    error: _donerErr,
                    assetPath: AppAssets.section20Dairesel,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption6.uiTitle,
                    ctrl: _sahanliksizCtrl,
                    error: _sahanliksizErr,
                  ),
                ],
              ),
            ),
          ],

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
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                // borderRadius: BorderRadius.circular(12), // Removed for stability
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Bağımsız olduğunu belirttiğiniz bodrum kat merdivenlerinin türlerini ve sayılarını aşağıya giriniz.",
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            QuestionCard(
              child: Column(
                children: [
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption1.uiTitle}",
                    ctrl: _bodNormalCtrl,
                    error: _bodNormalErr,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption2.uiTitle}",
                    ctrl: _bodIcKapaliCtrl,
                    error: _bodIcKapaliErr,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption3.uiTitle}",
                    ctrl: _bodDisKapaliCtrl,
                    error: _bodDisKapaliErr,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption4.uiTitle}",
                    ctrl: _bodDisAcikCtrl,
                    error: _bodDisAcikErr,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption5.uiTitle}",
                    ctrl: _bodDonerCtrl,
                    error: _bodDonerErr,
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: "Bodrum: ${Bolum20Content.cokKatOption6.uiTitle}",
                    ctrl: _bodSahanliksizCtrl,
                    error: _bodSahanliksizErr,
                  ),
                ],
              ),
            ),
          ],

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
            const SizedBox(width: 10),
            SizedBox(
              width: 70,
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
}
