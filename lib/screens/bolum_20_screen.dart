import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_20_model.dart';
import 'bolum_21_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';
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

  final _normalCtrl = TextEditingController();
  final _icKapaliCtrl = TextEditingController();
  final _disKapaliCtrl = TextEditingController();
  final _disAcikCtrl = TextEditingController();
  final _donerCtrl = TextEditingController();
  final _sahanliksizCtrl = TextEditingController();

  String? _normalErr;
  String? _icKapaliErr;
  String? _disKapaliErr;
  String? _disAcikErr;
  String? _donerErr;
  String? _sahanliksizErr;

  @override
  void initState() {
    super.initState();
    _loadBuildingInfo();
    _normalCtrl.addListener(_validateLimits);
    _icKapaliCtrl.addListener(_validateLimits);
    _disKapaliCtrl.addListener(_validateLimits);
    _disAcikCtrl.addListener(_validateLimits);
    _donerCtrl.addListener(_validateLimits);
    _sahanliksizCtrl.addListener(_validateLimits);
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
      _normalErr = _checkLimit(_normalCtrl.text);
      _icKapaliErr = _checkLimit(_icKapaliCtrl.text);
      _disKapaliErr = _checkLimit(_disKapaliCtrl.text);
      _disAcikErr = _checkLimit(_disAcikCtrl.text);
      _donerErr = _checkLimit(_donerCtrl.text);
      _sahanliksizErr = _checkLimit(_sahanliksizCtrl.text);

      int ic = int.tryParse(_icKapaliCtrl.text) ?? 0;
      int dis = int.tryParse(_disKapaliCtrl.text) ?? 0;
      _showBasinclandirma = (ic >= 1 || dis >= 1);
      if (!_showBasinclandirma) _model = _model.copyWith(basinclandirma: null);
    });
  }

  String? _checkLimit(String text) {
    if (text.isEmpty) return null;
    int? val = int.tryParse(text);
    if (val != null && val > 6) return "Maks: 6";
    return null;
  }

  bool get _isLimitValid {
    return _normalErr == null && _icKapaliErr == null && _disKapaliErr == null && 
           _disAcikErr == null && _donerErr == null && _sahanliksizErr == null;
  }

  @override
  void dispose() {
    _normalCtrl.dispose();
    _icKapaliCtrl.dispose();
    _disKapaliCtrl.dispose();
    _disAcikCtrl.dispose();
    _donerCtrl.dispose();
    _sahanliksizCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tekKatCikis') _model = _model.copyWith(tekKatCikis: choice);
      if (type == 'tekKatRampa') _model = _model.copyWith(tekKatRampa: choice);
      if (type == 'basinclandirma') _model = _model.copyWith(basinclandirma: choice);
      if (type == 'bodrum') _model = _model.copyWith(bodrumMerdivenDevami: choice);
    });
  }

  bool _validateAndSave() {
    if (_isTekKatli) {
      if (_model.tekKatCikis == null || _model.tekKatRampa == null) return false;
    } else {
      int normal = int.tryParse(_normalCtrl.text) ?? 0;
      int icKapali = int.tryParse(_icKapaliCtrl.text) ?? 0;
      int disKapali = int.tryParse(_disKapaliCtrl.text) ?? 0;
      int disAcik = int.tryParse(_disAcikCtrl.text) ?? 0;
      int doner = int.tryParse(_donerCtrl.text) ?? 0;
      int sahanliksiz = int.tryParse(_sahanliksizCtrl.text) ?? 0;

      if (normal + icKapali + disKapali + disAcik + doner + sahanliksiz == 0) return false;
      if (_showBasinclandirma && _model.basinclandirma == null) return false;

      _model = _model.copyWith(
        normalMerdivenSayisi: normal,
        binaIciYanginMerdiveniSayisi: icKapali,
        binaDisiKapaliYanginMerdiveniSayisi: disKapali,
        binaDisiAcikYanginMerdiveniSayisi: disAcik,
        donerMerdivenSayisi: doner,
        sahanliksizMerdivenSayisi: sahanliksiz,
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
      subtitle: "Binadaki merdiven tipleri ve adetleri",
      screenType: widget.runtimeType,
      isNextEnabled: _isLimitValid,
      onNext: () {
        if (_validateAndSave()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleTransitionScreen(
                module: ReportModule.modul2,
                onContinue: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Bolum21Screen()),
                  );
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lütfen gerekli alanları doğru şekilde doldurunuz.")),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isTekKatli) ...[
            _buildSoru("Binadan dışarıya (sokağa/caddeye) çıkışınız nasıl?", 'tekKatCikis', 
              [Bolum20Content.tekKatOptionA], _model.tekKatCikis),
            _buildSoru("Binadan sokağa çıkarken rampa kullanmak zorunda kalıyor musunuz?", 'tekKatRampa', 
              [Bolum20Content.rampaOptionB, Bolum20Content.rampaOptionC], _model.tekKatRampa),
          ] else ...[
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 16),
              child: Text("Binanızda aşağıdaki merdiven türlerinden kaçar tane var? (Maks: 6)", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
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
                    assetPaths: [AppAssets.section20DisAcik1, AppAssets.section20DisAcik2],
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

          if (_showBasinclandirma)
            _buildSoru("Merdivende basınçlandırma sistemi var mı?", 'basinclandirma', 
              [Bolum20Content.basYghOptionA, Bolum20Content.basYghOptionB, Bolum20Content.basYghOptionC], _model.basinclandirma),

          if (_hasBodrum)
            _buildSoru("Bodrum kata inen merdiveniniz, üst katlara çıkan merdivenin devamı mı?", 'bodrum', 
              [Bolum20Content.bodrumOptionA, Bolum20Content.bodrumOptionB], _model.bodrumMerdivenDevami),
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
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
            const SizedBox(width: 10),
            SizedBox(
              width: 70,
              child: TextFormField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), 
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
          ...assetPaths.map((path) => TechnicalDrawingButton(assetPath: path, title: label)),
      ],
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )),
        ],
      ),
    );
  }
}