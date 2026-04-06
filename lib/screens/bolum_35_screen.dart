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

import '../../utils/input_validator.dart';

class Bolum35Screen extends StatefulWidget {
  const Bolum35Screen({super.key});

  @override
  State<Bolum35Screen> createState() => _Bolum35ScreenState();
}

class _Bolum35ScreenState extends State<Bolum35Screen> {
  Bolum35Model _model = Bolum35Model();
  final _mesafeCtrl = TextEditingController();

  bool _tekCikis = true;
  int _limitTekYon = 15;
  int _limitCiftYon = 30;
  String? _mesafeErr;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum35 != null) {
      _model = BinaStore.instance.bolum35!;
      if (_model.manuelMesafe != null) {
        _mesafeCtrl.text = _model.manuelMesafe.toString();
      }
    }
    _calculateLimits();
    _mesafeCtrl.addListener(_validateMesafe);
  }

  @override
  void dispose() {
    _mesafeCtrl.dispose();
    super.dispose();
  }

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

  void _validateMesafe() {
    setState(() {
      _mesafeErr = InputValidator.validateNumber(
        _mesafeCtrl.text,
        min: 0,
        max: 200,
        unit: "m",
      );
    });
  }

  bool _isReadyToProceed() {
    bool showManualInput =
        (_model.tekYon?.label == "35-1-C" ||
        _model.ciftYon?.label == "35-2-C" ||
        _model.cikmazMesafe?.label == "35-3-E");
    if (showManualInput) {
      if (_mesafeCtrl.text.isEmpty || _mesafeErr != null) return false;
    }
    if (_tekCikis) {
      if (_model.tekYon == null) return false;
    } else {
      if (_model.ciftYon == null) return false;
      if (_model.cikmaz == null) return false;
      if (_model.cikmaz?.label == Bolum35Content.cikmazOptionA.label &&
          _model.cikmazMesafe == null)
        return false;
    }
    return true;
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tekYon') {
        _model = _model.copyWith(tekYon: choice);
        if (choice.label == "35-1-C") {
          // Scroll removed
        }
      }
      if (type == 'ciftYon') {
        _model = _model.copyWith(ciftYon: choice);
      }
      if (type == 'cikmaz') {
        _model = _model.copyWith(cikmaz: choice);
        if (choice.label != Bolum35Content.cikmazOptionA.label) {
          _model = _model.copyWith(cikmazMesafe: null);
        } else {
          // Scroll removed
        }
      }
      if (type == 'cikmazMesafe') {
        _model = _model.copyWith(cikmazMesafe: choice);
        if (choice.label == "35-3-E") {
          // Scroll removed
        }
      }
    });
  }

  ChoiceResult _getDynamicChoice(ChoiceResult original, int limit) {
    return ChoiceResult(
      label: original.label,
      uiTitle: original.uiTitle.replaceAll("[LIMIT]", limit.toString()),
      uiSubtitle: original.uiSubtitle.replaceAll("[LIMIT]", limit.toString()),
      reportText: original.reportText.replaceAll("[LIMIT]", limit.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kaçış Mesafesi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReadyToProceed(),
      onSave: () {
        if (_mesafeCtrl.text.isNotEmpty) {
          _model = _model.copyWith(
            manuelMesafe: InputValidator.parseFlex(_mesafeCtrl.text),
          );
        }
        BinaStore.instance.bolum35 = _model;
        BinaStore.instance.saveToDisk();
      },
      onNext: () {
        if (_mesafeCtrl.text.isNotEmpty) {
          _model = _model.copyWith(
            manuelMesafe: InputValidator.parseFlex(_mesafeCtrl.text),
          );
        }
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
          if (_tekCikis) ...[
            _buildIntegratedQuestionCard(
              "tekYon",
              "Daire kapınızdan çıktığınızda kattaki merdiven kapısına kadar olan mesafe kaç metredir?",
              [
                _getDynamicChoice(Bolum35Content.tekYonOptionA, _limitTekYon),
                _getDynamicChoice(Bolum35Content.tekYonOptionB, _limitTekYon),
                _getDynamicChoice(Bolum35Content.tekYonOptionC, _limitTekYon),
                Bolum35Content.tekYonOptionD,
              ],
              _model.tekYon,
              term: "Kaçış Mesafesi",
              definition: AppDefinitions.kacisMesafesi,
              imagePath: AppAssets.section35DairedenOlcum,
              imageTitle: "Tek yön kaçış mesafesi",
            ),
            if (_model.tekYon?.label == "35-1-C") ...[
              const SizedBox(height: 12),
              _buildInfoNote(
                "Lütfen net mesafeyi metre cinsinden aşağıya yazınız.",
              ),
              QuestionCard(
                child: TextFormField(
                  controller: _mesafeCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [InputValidator.flexDecimal],
                  decoration: InputDecoration(
                    labelText: "Net Mesafeyi Giriniz (m)",
                    suffixText: "metre",
                    errorText: _mesafeErr,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.straighten),
                  ),
                ),
              ),
            ],
          ] else ...[
            _buildIntegratedQuestionCard(
              "ciftYon",
              "Daire kapınızdan çıktığınızda, size EN YAKIN merdivene olan mesafe kaç metredir?",
              [
                _getDynamicChoice(Bolum35Content.ciftYonOptionA, _limitCiftYon),
                _getDynamicChoice(Bolum35Content.ciftYonOptionB, _limitCiftYon),
                _getDynamicChoice(Bolum35Content.ciftYonOptionC, _limitCiftYon),
                Bolum35Content.ciftYonOptionD,
              ],
              _model.ciftYon,
              term: "Kaçış Mesafesi",
              definition: AppDefinitions.kacisMesafesi,
              imagePath: AppAssets.section35KacisGosterim,
              imageTitle: "Çift yön kaçış mesafesi",
            ),
            if (_model.ciftYon?.label == "35-2-C") ...[
              const SizedBox(height: 12),
              _buildInfoNote(
                "Lütfen net mesafeyi metre cinsinden aşağıya yazınız.",
              ),
              QuestionCard(
                child: TextFormField(
                  controller: _mesafeCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [InputValidator.flexDecimal],
                  decoration: InputDecoration(
                    labelText: "Net Mesafeyi Giriniz (m)",
                    suffixText: "metre",
                    errorText: _mesafeErr,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.straighten),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildIntegratedQuestionCard(
              "cikmaz",
              "Daireniz, 'Çıkmaz' bir koridorun ucunda mı?",
              [
                Bolum35Content.cikmazOptionA,
                Bolum35Content.cikmazOptionB,
                Bolum35Content.cikmazOptionC,
              ],
              _model.cikmaz,
              term: "Çıkmaz Koridor",
              definition: AppDefinitions.cikmazKoridor,
            ),
            if (_model.cikmaz?.label == Bolum35Content.cikmazOptionA.label) ...[
              _buildInfoNote(
                "Çıkmaz koridor tespiti yapıldı. Lütfen koridor uzunluğunu belirtiniz.",
              ),
              _buildIntegratedQuestionCard(
                "cikmazMesafe",
                "Çıkmaz koridor kaç metre uzunluğundadır?",
                [
                  _getDynamicChoice(
                    Bolum35Content.cikmazMesafeOptionA,
                    _limitTekYon,
                  ),
                  _getDynamicChoice(
                    Bolum35Content.cikmazMesafeOptionB,
                    _limitTekYon,
                  ),
                  _getDynamicChoice(
                    Bolum35Content.cikmazMesafeOptionC,
                    _limitTekYon,
                  ),
                  Bolum35Content.cikmazMesafeOptionD,
                ],
                _model.cikmazMesafe,
                term: "Çıkmaz Koridor Mesafesi",
                definition: AppDefinitions.cikmazKoridor,
              ),
              if (_model.cikmazMesafe?.label == "35-3-E") ...[
                const SizedBox(height: 12),
                _buildInfoNote(
                  "Lütfen net mesafeyi metre cinsinden aşağıya yazınız.",
                ),
                QuestionCard(
                  child: TextFormField(
                    controller: _mesafeCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [InputValidator.flexDecimal],
                    decoration: InputDecoration(
                      labelText: "Net Mesafeyi Giriniz (m)",
                      suffixText: "metre",
                      errorText: _mesafeErr,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.straighten),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildIntegratedQuestionCard(
    String key,
    String title,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
    String? term,
    String? definition,
    String? imagePath,
    String? imageTitle,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(title, style: AppStyles.questionTitle)),
              if (imagePath != null) ...[
                const SizedBox(width: 8),
                _buildCameraIcon(imagePath, imageTitle),
              ],
              if (term != null && definition != null) ...[
                const SizedBox(width: 8),
                DefinitionButton(term: term, definition: definition),
              ],
            ],
          ),
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => _handleSelection(key, opt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraIcon(String imagePath, String? imageTitle) {
    return ActionIconWrapper(
      onTap: () => ImageModalHelper.show(
        context,
        assetPath: imagePath,
        title: imageTitle ?? 'Görseli incele',
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
