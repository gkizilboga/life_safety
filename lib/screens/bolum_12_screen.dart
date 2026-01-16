import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_12_model.dart';
import 'bolum_13_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';
import '../../utils/input_validator.dart';

class Bolum12Screen extends StatefulWidget {
  const Bolum12Screen({super.key});

  @override
  State<Bolum12Screen> createState() => _Bolum12ScreenState();
}

class _Bolum12ScreenState extends State<Bolum12Screen> {
  Bolum12Model _model = Bolum12Model();
  String? _tasiyiciSistemLabel;
  final _kolonPaspayiCtrl = TextEditingController();
  final _kirisPaspayiCtrl = TextEditingController();
  final _dosemePaspayiCtrl = TextEditingController();

  String? _kolonErr;
  String? _kirisErr;
  String? _dosemeErr;

  @override
  void initState() {
    super.initState();
    final bolum2 = BinaStore.instance.bolum2;
    _tasiyiciSistemLabel = bolum2?.secim?.label;
    _kolonPaspayiCtrl.addListener(_validate);
    _kirisPaspayiCtrl.addListener(_validate);
    _dosemePaspayiCtrl.addListener(_validate);
  }

  void _validate() {
    setState(() {
      _kolonErr = InputValidator.validateNumber(
        _kolonPaspayiCtrl.text,
        min: 5,
        max: 100,
        unit: "mm",
        isRequired: false,
      );
      _kirisErr = InputValidator.validateNumber(
        _kirisPaspayiCtrl.text,
        min: 5,
        max: 100,
        unit: "mm",
        isRequired: false,
      );
      _dosemeErr = InputValidator.validateNumber(
        _dosemePaspayiCtrl.text,
        min: 5,
        max: 100,
        unit: "mm",
        isRequired: false,
      );
    });
  }

  @override
  void dispose() {
    _kolonPaspayiCtrl.dispose();
    _kirisPaspayiCtrl.dispose();
    _dosemePaspayiCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'celik')
        _model = _model.copyWith(celikKoruma: choice);
      else if (type == 'beton')
        _model = _model.copyWith(betonPaspayi: choice);
      else if (type == 'ahsap')
        _model = _model.copyWith(ahsapKesit: choice);
      else if (type == 'yigma')
        _model = _model.copyWith(yigmaDuvar: choice);
    });
  }

  bool _isReady() {
    if (_tasiyiciSistemLabel == "2-B") return _model.celikKoruma != null;
    if (_tasiyiciSistemLabel == "2-C") return _model.ahsapKesit != null;
    if (_tasiyiciSistemLabel == "2-D") return _model.yigmaDuvar != null;

    if (_model.betonPaspayi == null) return false;
    if (_model.betonPaspayi?.label == Bolum12Content.betonOptionB.label) {
      bool filled =
          _kolonPaspayiCtrl.text.isNotEmpty &&
          _kirisPaspayiCtrl.text.isNotEmpty &&
          _dosemePaspayiCtrl.text.isNotEmpty;
      return filled &&
          _kolonErr == null &&
          _kirisErr == null &&
          _dosemeErr == null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yapısal Yangın Dayanımı",
      subtitle: "Taşıyıcı sistemin yangın anındaki stabilitesi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        if (_model.betonPaspayi?.label == Bolum12Content.betonOptionB.label) {
          _model = _model.copyWith(
            kolonPaspayi: InputValidator.parseFlex(_kolonPaspayiCtrl.text),
            kirisPaspayi: InputValidator.parseFlex(_kirisPaspayiCtrl.text),
            dosemePaspayi: InputValidator.parseFlex(_dosemePaspayiCtrl.text),
          );
        }
        BinaStore.instance.bolum12 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum13Screen()),
        );
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_tasiyiciSistemLabel == "2-B") return _buildCelikSorusu();
    if (_tasiyiciSistemLabel == "2-C") return _buildAhsapSorusu();
    if (_tasiyiciSistemLabel == "2-D") return _buildYigmaSorusu();
    return _buildBetonSorusu();
  }

  Widget _buildBetonSorusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Betonarme taşıyıcılarınızdaki paspayı (demir koruma tabakası) durumu nedir?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
        ),
        TechnicalDrawingButton(
          assetPath: AppAssets.section12Paspayi,
          title: "Paspayı Detayı",
        ),
        const SizedBox(height: 12),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard(
                choice: Bolum12Content.betonOptionA,
                isSelected:
                    _model.betonPaspayi?.label ==
                    Bolum12Content.betonOptionA.label,
                onTap: () =>
                    _handleSelection('beton', Bolum12Content.betonOptionA),
              ),
              SelectableCard(
                choice: Bolum12Content.betonOptionB,
                isSelected:
                    _model.betonPaspayi?.label ==
                    Bolum12Content.betonOptionB.label,
                onTap: () =>
                    _handleSelection('beton', Bolum12Content.betonOptionB),
              ),
              if (_model.betonPaspayi?.label ==
                  Bolum12Content.betonOptionB.label) ...[
                const SizedBox(height: 12),
                _buildManualInput(
                  "Kolon Paspayı (mm)",
                  _kolonPaspayiCtrl,
                  _kolonErr,
                ),
                const SizedBox(height: 12),
                _buildManualInput(
                  "Kiriş Paspayı (mm)",
                  _kirisPaspayiCtrl,
                  _kirisErr,
                ),
                const SizedBox(height: 12),
                _buildManualInput(
                  "Döşeme Paspayı (mm)",
                  _dosemePaspayiCtrl,
                  _dosemeErr,
                ),
                const SizedBox(height: 12),
              ],
              SelectableCard(
                choice: Bolum12Content.betonOptionC,
                isSelected:
                    _model.betonPaspayi?.label ==
                    Bolum12Content.betonOptionC.label,
                onTap: () =>
                    _handleSelection('beton', Bolum12Content.betonOptionC),
              ),
              SelectableCard(
                choice: Bolum12Content.betonOptionD,
                isSelected:
                    _model.betonPaspayi?.label ==
                    Bolum12Content.betonOptionD.label,
                onTap: () =>
                    _handleSelection('beton', Bolum12Content.betonOptionD),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManualInput(
    String label,
    TextEditingController ctrl,
    String? error,
  ) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        suffixText: "mm",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildCelikSorusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Çelik taşıyıcılarınızda yangına karşı bir koruma veya yalıtım var mı?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard(
                choice: Bolum12Content.celikOptionA,
                isSelected:
                    _model.celikKoruma?.label ==
                    Bolum12Content.celikOptionA.label,
                onTap: () =>
                    _handleSelection('celik', Bolum12Content.celikOptionA),
              ),
              SelectableCard(
                choice: Bolum12Content.celikOptionB,
                isSelected:
                    _model.celikKoruma?.label ==
                    Bolum12Content.celikOptionB.label,
                onTap: () =>
                    _handleSelection('celik', Bolum12Content.celikOptionB),
              ),
              SelectableCard(
                choice: Bolum12Content.celikOptionC,
                isSelected:
                    _model.celikKoruma?.label ==
                    Bolum12Content.celikOptionC.label,
                onTap: () =>
                    _handleSelection('celik', Bolum12Content.celikOptionC),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAhsapSorusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ahşap taşıyıcılarınızın kalınlığı (kesiti) nedir?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard(
                choice: Bolum12Content.ahsapOptionA,
                isSelected:
                    _model.ahsapKesit?.label ==
                    Bolum12Content.ahsapOptionA.label,
                onTap: () =>
                    _handleSelection('ahsap', Bolum12Content.ahsapOptionA),
              ),
              SelectableCard(
                choice: Bolum12Content.ahsapOptionB,
                isSelected:
                    _model.ahsapKesit?.label ==
                    Bolum12Content.ahsapOptionB.label,
                onTap: () =>
                    _handleSelection('ahsap', Bolum12Content.ahsapOptionB),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYigmaSorusu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Binanızın taşıyıcı duvarlarının kalınlığı en az 19 cm midir?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard(
                choice: Bolum12Content.yigmaOptionA,
                isSelected:
                    _model.yigmaDuvar?.label ==
                    Bolum12Content.yigmaOptionA.label,
                onTap: () =>
                    _handleSelection('yigma', Bolum12Content.yigmaOptionA),
              ),
              SelectableCard(
                choice: Bolum12Content.yigmaOptionB,
                isSelected:
                    _model.yigmaDuvar?.label ==
                    Bolum12Content.yigmaOptionB.label,
                onTap: () =>
                    _handleSelection('yigma', Bolum12Content.yigmaOptionB),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
