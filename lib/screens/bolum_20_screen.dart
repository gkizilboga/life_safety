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

  final _normalCtrl = TextEditingController();
  final _icKapaliCtrl = TextEditingController();
  final _disKapaliCtrl = TextEditingController();
  final _disAcikCtrl = TextEditingController();
  final _donerCtrl = TextEditingController();
  final _sahanliksizCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBuildingInfo();
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
      isNextEnabled: true,
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
            const SnackBar(content: Text("Lütfen gerekli alanları doldurunuz.")),
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
              child: Text("Binanızda aşağıdaki merdiven türlerinden kaçar tane var?", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
            ),
            
            QuestionCard(
              child: Column(
                children: [
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption1.uiTitle,
                    ctrl: _normalCtrl,
                    assetPath: AppAssets.section20Normal,
                    assetTitle: "Normal Apartman Merdiveni",
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption2.uiTitle,
                    ctrl: _icKapaliCtrl,
                    assetPath: AppAssets.section20IcKapali,
                    assetTitle: "Bina İçi Kapalı Yangın Merdiveni",
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption3.uiTitle,
                    ctrl: _disKapaliCtrl,
                    assetPath: AppAssets.section20DisKapali,
                    assetTitle: "Bina Dışı Kapalı Yangın Merdiveni",
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption4.uiTitle,
                    ctrl: _disAcikCtrl,
                    assetPaths: [
                      AppAssets.section20DisAcik1,
                      AppAssets.section20DisAcik2,
                    ],
                    assetTitles: [
                      "Dış Açık Merdiven Örnek 1",
                      "Dış Açık Merdiven Örnek 2",
                    ],
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption5.uiTitle,
                    ctrl: _donerCtrl,
                    assetPath: AppAssets.section20Dairesel,
                    assetTitle: "Döner (Spiral) Merdiven",
                  ),
                  const Divider(height: 32),
                  _buildStairInputGroup(
                    label: Bolum20Content.cokKatOption6.uiTitle,
                    ctrl: _sahanliksizCtrl,
                    assetTitle: "Sahanlıksız (Dönemeçli) Merdiven",
                  ),
                ],
              ),
            ),
          ],

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
    String? assetPath, 
    String? assetTitle,
    List<String>? assetPaths,
    List<String>? assetTitles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
            const SizedBox(width: 10),
            SizedBox(
              width: 60,
              child: TextFormField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8), border: OutlineInputBorder(), hintText: "0"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (assetPath != null)
          TechnicalDrawingButton(assetPath: assetPath, title: assetTitle ?? label),
        if (assetPaths != null)
          ...List.generate(assetPaths.length, (index) => 
            TechnicalDrawingButton(assetPath: assetPaths[index], title: assetTitles![index])
          ),
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