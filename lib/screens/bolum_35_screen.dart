import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_35_model.dart';
import 'bolum_36_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';
import '../../utils/input_validator.dart' show InputValidator;

class Bolum35Screen extends StatefulWidget {
  const Bolum35Screen({super.key});

  @override
  State<Bolum35Screen> createState() => _Bolum35ScreenState();
}

class _Bolum35ScreenState extends State<Bolum35Screen> {
  Bolum35Model _model = Bolum35Model();
  final _distanceCtrl = TextEditingController();
  final _cikmazCtrl = TextEditingController();

  bool _tekCikis = true;
  int _limitTekYon = 15;
  int _limitCiftYon = 30;
  String? _distanceErr;
  String? _cikmazErr;

  @override
  void initState() {
    super.initState();
    _calculateLimits();
    if (BinaStore.instance.bolum35 != null) {
      _model = BinaStore.instance.bolum35!;
      if (_model.manuelMesafe != null) {
        _distanceCtrl.text = _model.manuelMesafe.toString();
      }
      if (_model.cikmazManuelMesafe != null) {
        _cikmazCtrl.text = _model.cikmazManuelMesafe.toString();
      }
    }
    _distanceCtrl.addListener(_onDistanceChanged);
    _cikmazCtrl.addListener(_onCikmazChanged);
  }

  @override
  void dispose() {
    _distanceCtrl.removeListener(_onDistanceChanged);
    _cikmazCtrl.removeListener(_onCikmazChanged);
    _distanceCtrl.dispose();
    _cikmazCtrl.dispose();
    super.dispose();
  }

  String get _limitStr => _tekCikis ? "$_limitTekYon" : "$_limitCiftYon";

  void _calculateLimits() {
    final b20 = BinaStore.instance.bolum20;
    final b9 = BinaStore.instance.bolum9;
    int toplamCikis =
        (b20?.normalMerdivenSayisi ?? 0) +
        (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0);
    bool hasSprinkler = b9?.secim?.label == "9-1-A";
    setState(() {
      _tekCikis = (toplamCikis <= 1);
      _limitTekYon = hasSprinkler ? 30 : 15;
      _limitCiftYon = hasSprinkler ? 75 : 30;
    });
  }

  void _onDistanceChanged() {
    final err = InputValidator.validateNumber(
      _distanceCtrl.text,
      min: 0, max: 200, unit: "m",
    );
    final val = InputValidator.parseFlex(_distanceCtrl.text);
    setState(() {
      _distanceErr = err;
      _model = _model.copyWith(
        manuelMesafe: val != null && val > 0 ? val : null,
      );
    });
  }

  void _onCikmazChanged() {
    final err = InputValidator.validateNumber(
      _cikmazCtrl.text,
      min: 0, max: 200, unit: "m",
    );
    final val = InputValidator.parseFlex(_cikmazCtrl.text);
    setState(() {
      _cikmazErr = err;
      _model = _model.copyWith(
        cikmazManuelMesafe: val != null && val > 0 ? val : null,
      );
    });
  }

  bool _hasMesafeSelection() {
    if (_tekCikis) return _model.tekYon != null;
    return _model.ciftYon != null;
  }

  bool _isManuelChosen() {
    if (_tekCikis) return _model.tekYon?.label == Bolum35Content.tekYonOptionC.label;
    return _model.ciftYon?.label == Bolum35Content.ciftYonOptionC.label;
  }

  bool _isCikmazManuelChosen() {
    return _model.cikmazMesafe?.label == Bolum35Content.cikmazMesafeOptionC.label;
  }

  bool _isReadyToProceed() {
    if (!_hasMesafeSelection()) return false;
    if (_isManuelChosen() && (_distanceErr != null || _model.manuelMesafe == null)) return false;
    if (!_tekCikis) {
      if (_model.cikmaz == null) return false;
      if (_model.cikmaz?.label == Bolum35Content.cikmazOptionA.label) {
        if (_model.cikmazMesafe == null) return false;
        if (_isCikmazManuelChosen() && (_cikmazErr != null || _model.cikmazManuelMesafe == null)) return false;
      }
    }
    return true;
  }

  ChoiceResult _replaceChoiceLabel(ChoiceResult choice, String template, String limit) {
    return ChoiceResult(
      label: choice.label,
      uiTitle: template.replaceAll("[LIMIT]", limit),
      uiSubtitle: choice.uiSubtitle,
      reportText: choice.reportText.replaceAll("[LIMIT]", limit),
      adviceText: choice.adviceText?.replaceAll("[LIMIT]", limit),
      level: choice.level,
    );
  }

  void _onTekYonSelected(ChoiceResult choice) {
    if (_model.tekYon?.label == choice.label) return;
    final clearManual = choice.label != Bolum35Content.tekYonOptionC.label;
    setState(() {
      _model = _model.copyWith(
        tekYon: choice,
        manuelMesafe: clearManual ? null : _model.manuelMesafe,
      );
      if (clearManual) _distanceCtrl.clear();
    });
  }

  void _onCiftYonSelected(ChoiceResult choice) {
    if (_model.ciftYon?.label == choice.label) return;
    final clearManual = choice.label != Bolum35Content.ciftYonOptionC.label;
    setState(() {
      _model = _model.copyWith(
        ciftYon: choice,
        manuelMesafe: clearManual ? null : _model.manuelMesafe,
      );
      if (clearManual) _distanceCtrl.clear();
    });
  }

  void _onCikmazSelected(ChoiceResult choice) {
    if (_model.cikmaz?.label == choice.label) return;
    final clearSub = choice.label != Bolum35Content.cikmazOptionA.label;
    setState(() {
      _model = _model.copyWith(
        cikmaz: choice,
        cikmazMesafe: clearSub ? null : _model.cikmazMesafe,
        cikmazManuelMesafe: clearSub ? null : _model.cikmazManuelMesafe,
      );
      if (clearSub) _cikmazCtrl.clear();
    });
  }

  void _onCikmazMesafeSelected(ChoiceResult choice) {
    if (_model.cikmazMesafe?.label == choice.label) return;
    final clearManual = choice.label != Bolum35Content.cikmazMesafeOptionC.label;
    setState(() {
      _model = _model.copyWith(
        cikmazMesafe: choice,
        cikmazManuelMesafe: clearManual ? null : _model.cikmazManuelMesafe,
      );
      if (clearManual) _cikmazCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kaçış Mesafesi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReadyToProceed(),
      onSave: () {
        BinaStore.instance.bolum35 = _model;
        BinaStore.instance.saveToDisk();
      },
      onNext: () {
        BinaStore.instance.bolum35 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum36Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDistanceQuestion(),
          const SizedBox(height: 12),
          if (!_tekCikis) ...[
            _buildCikmazQuestion(),
            if (_model.cikmaz?.label == Bolum35Content.cikmazOptionA.label)
              _buildCikmazUzunlukQuestion(),
          ],
        ],
      ),
    );
  }

  Widget _buildDistanceQuestion() {
    final title = _tekCikis
        ? "Daire kapınızdan çıktığınızda kattaki merdiven kapısına kadar olan mesafe kaç metredir?"
        : "Daire kapınızdan çıktığınızda, size EN YAKIN merdivene olan mesafe kaç metredir?";

    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(title, style: AppStyles.questionTitle),
              ),
              const SizedBox(width: 8),
              ActionIconWrapper(
                onTap: () => ImageModalHelper.show(
                  context,
                  assetPath: _tekCikis
                      ? AppAssets.section35DairedenOlcum
                      : AppAssets.section35KacisGosterim,
                  title: _tekCikis
                      ? "Tek yön kaçış mesafesi"
                      : "Çift yön kaçış mesafesi",
                ),
                tooltip: 'Görseli incele',
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF43A047).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DefinitionButton(
                term: "Kaçış Mesafesi",
                definition: AppDefinitions.kacisMesafesi,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_tekCikis) ...[
            SelectableCard(
              choice: _replaceChoiceLabel(Bolum35Content.tekYonOptionA, "[LIMIT] metreden KISA.", _limitStr),
              isSelected: _model.tekYon?.label == Bolum35Content.tekYonOptionA.label,
              onTap: () => _onTekYonSelected(Bolum35Content.tekYonOptionA),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: _replaceChoiceLabel(Bolum35Content.tekYonOptionB, "[LIMIT] metreden UZUN.", _limitStr),
              isSelected: _model.tekYon?.label == Bolum35Content.tekYonOptionB.label,
              onTap: () => _onTekYonSelected(Bolum35Content.tekYonOptionB),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: Bolum35Content.tekYonOptionC,
              isSelected: _model.tekYon?.label == Bolum35Content.tekYonOptionC.label,
              onTap: () => _onTekYonSelected(Bolum35Content.tekYonOptionC),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: Bolum35Content.tekYonOptionD,
              isSelected: _model.tekYon?.label == Bolum35Content.tekYonOptionD.label,
              onTap: () => _onTekYonSelected(Bolum35Content.tekYonOptionD),
            ),
          ] else ...[
            SelectableCard(
              choice: _replaceChoiceLabel(Bolum35Content.ciftYonOptionA, "[LIMIT] metreden KISADIR.", _limitStr),
              isSelected: _model.ciftYon?.label == Bolum35Content.ciftYonOptionA.label,
              onTap: () => _onCiftYonSelected(Bolum35Content.ciftYonOptionA),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: _replaceChoiceLabel(Bolum35Content.ciftYonOptionB, "[LIMIT] metreden UZUNDUR.", _limitStr),
              isSelected: _model.ciftYon?.label == Bolum35Content.ciftYonOptionB.label,
              onTap: () => _onCiftYonSelected(Bolum35Content.ciftYonOptionB),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: Bolum35Content.ciftYonOptionC,
              isSelected: _model.ciftYon?.label == Bolum35Content.ciftYonOptionC.label,
              onTap: () => _onCiftYonSelected(Bolum35Content.ciftYonOptionC),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: Bolum35Content.ciftYonOptionD,
              isSelected: _model.ciftYon?.label == Bolum35Content.ciftYonOptionD.label,
              onTap: () => _onCiftYonSelected(Bolum35Content.ciftYonOptionD),
            ),
          ],
          if (_isManuelChosen()) ...[
            const SizedBox(height: 12),
            _buildInputField(
              controller: _distanceCtrl,
              errorText: _distanceErr,
              label: "Mesafe (m)",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCikmazQuestion() {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  "Daireniz, 'Çıkmaz' bir koridorun ucunda mı?",
                  style: AppStyles.questionTitle,
                ),
              ),
              const SizedBox(width: 8),
              DefinitionButton(
                term: "Çıkmaz Koridor",
                definition: AppDefinitions.cikmazKoridor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableCard(
            choice: Bolum35Content.cikmazOptionA,
            isSelected: _model.cikmaz?.label == Bolum35Content.cikmazOptionA.label,
            onTap: () => _onCikmazSelected(Bolum35Content.cikmazOptionA),
          ),
          const SizedBox(height: 6),
          SelectableCard(
            choice: Bolum35Content.cikmazOptionB,
            isSelected: _model.cikmaz?.label == Bolum35Content.cikmazOptionB.label,
            onTap: () => _onCikmazSelected(Bolum35Content.cikmazOptionB),
          ),
          const SizedBox(height: 6),
          SelectableCard(
            choice: Bolum35Content.cikmazOptionC,
            isSelected: _model.cikmaz?.label == Bolum35Content.cikmazOptionC.label,
            onTap: () => _onCikmazSelected(Bolum35Content.cikmazOptionC),
          ),
        ],
      ),
    );
  }

  Widget _buildCikmazUzunlukQuestion() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SubQuestionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: SubQuestionTitle("Çıkmaz koridor kaç metre uzunluğundadır?"),
                ),
                DefinitionButton(
                  term: "Çıkmaz Koridor",
                  definition: AppDefinitions.cikmazKoridor,
                ),
              ],
            ),
            const SizedBox(height: 6),
            _buildInfoNote(
              "Çıkmaz koridor tespiti yapıldı. Lütfen koridor uzunluğunu değerlendiriniz.",
            ),
            const SizedBox(height: 10),
            SelectableCard(
              choice: _replaceChoiceLabel(Bolum35Content.cikmazMesafeOptionA, "[LIMIT] metreden KISA.", _limitTekYon.toString()),
              isSelected: _model.cikmazMesafe?.label == Bolum35Content.cikmazMesafeOptionA.label,
              onTap: () => _onCikmazMesafeSelected(Bolum35Content.cikmazMesafeOptionA),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: _replaceChoiceLabel(Bolum35Content.cikmazMesafeOptionB, "[LIMIT] metreden UZUN.", _limitTekYon.toString()),
              isSelected: _model.cikmazMesafe?.label == Bolum35Content.cikmazMesafeOptionB.label,
              onTap: () => _onCikmazMesafeSelected(Bolum35Content.cikmazMesafeOptionB),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: Bolum35Content.cikmazMesafeOptionC,
              isSelected: _model.cikmazMesafe?.label == Bolum35Content.cikmazMesafeOptionC.label,
              onTap: () => _onCikmazMesafeSelected(Bolum35Content.cikmazMesafeOptionC),
            ),
            const SizedBox(height: 6),
            SelectableCard(
              choice: Bolum35Content.cikmazMesafeOptionD,
              isSelected: _model.cikmazMesafe?.label == Bolum35Content.cikmazMesafeOptionD.label,
              onTap: () => _onCikmazMesafeSelected(Bolum35Content.cikmazMesafeOptionD),
            ),
            if (_isCikmazManuelChosen()) ...[
              const SizedBox(height: 10),
              _buildInputField(
                controller: _cikmazCtrl,
                errorText: _cikmazErr,
                label: "Çıkmaz Koridor Uzunluğu (m)",
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    String? errorText,
    String? label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [InputValidator.flexDecimal],
      style: const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(fontSize: 13.5, color: AppColors.textLabel),
        hintText: "Örn: 25.5",
        hintStyle:
            TextStyle(fontSize: 12, color: Colors.grey.shade400),
        errorText: errorText,
        suffixText: "metre",
        suffixStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        prefixIcon: const Icon(Icons.straighten,
            color: AppColors.primaryBlue, size: 18),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return CustomInfoNote(
      type: InfoNoteType.info,
      text: text,
      icon: Icons.arrow_downward,
    );
  }
}
