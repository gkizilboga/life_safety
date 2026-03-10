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
        (_model.tekYon?.label == "35-1-A" ||
        _model.ciftYon?.label == "35-2-A" ||
        _model.cikmazMesafe?.label == "35-3-C");
    if (showManualInput) {
      if (_mesafeCtrl.text.isEmpty || _mesafeErr != null) return false;
    }
    if (_tekCikis) {
      if (_model.tekYon == null) return false;
    } else {
      if (_model.ciftYon == null) return false;
      if (_model.cikmaz == null) return false;
      if (_model.cikmaz?.label == Bolum35Content.cikmazOptionB.label &&
          _model.cikmazMesafe == null)
        return false;
    }
    return true;
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tekYon') {
        _model = _model.copyWith(tekYon: choice);
        if (choice.label == "35-1-A") {
          // Scroll removed
        }
      }
      if (type == 'ciftYon') {
        _model = _model.copyWith(ciftYon: choice);
      }
      if (type == 'cikmaz') {
        _model = _model.copyWith(cikmaz: choice);
        if (choice.label != Bolum35Content.cikmazOptionB.label) {
          _model = _model.copyWith(cikmazMesafe: null);
        } else {
          // Scroll removed
        }
      }
      if (type == 'cikmazMesafe') {
        _model = _model.copyWith(cikmazMesafe: choice);
        if (choice.label == "35-3-C") {
          // Scroll removed
        }
      }
    });
  }

  ChoiceResult _getDynamicChoice(ChoiceResult original, int limit) {
    return ChoiceResult(
      label: original.label,
      uiTitle: original.uiTitle.replaceAll("[LİMİT]", limit.toString()),
      uiSubtitle: original.uiSubtitle.replaceAll("[LİMİT]", limit.toString()),
      reportText: original.reportText.replaceAll("[LİMİT]", limit.toString()),
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
            _buildSoruHeaderWithDef(
              "Daire kapınızdan çıktığınızda kattaki merdiven kapısına kadar olan mesafe kaç metredir?",
              "Kaçış Mesafesi",
              AppDefinitions.kacisMesafesi,
              imagePath: AppAssets.section35DairedenOlcum,
              imageTitle: "Tek Yön Kaçış Mesafesi Ölçüm Detayı",
            ),
            _buildSoruCard('tekYon', [
              Bolum35Content.tekYonOptionA,
              _getDynamicChoice(Bolum35Content.tekYonOptionB, _limitTekYon),
              _getDynamicChoice(Bolum35Content.tekYonOptionC, _limitTekYon),
              Bolum35Content.tekYonOptionD,
            ], _model.tekYon),
            if (_model.tekYon?.label == "35-1-A") ...[
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
            _buildSoruHeaderWithDef(
              "Daire kapınızdan çıktığınızda, size EN YAKIN merdivene olan mesafe kaç metredir?",
              "Kaçış Mesafesi",
              AppDefinitions.kacisMesafesi,
              imagePath: AppAssets.section35KacisGosterim,
              imageTitle: "Çift Yön Kaçış Mesafesi Ölçüm Detayı",
            ),
            _buildSoruCard('ciftYon', [
              Bolum35Content.ciftYonOptionA,
              _getDynamicChoice(Bolum35Content.ciftYonOptionB, _limitCiftYon),
              _getDynamicChoice(Bolum35Content.ciftYonOptionC, _limitCiftYon),
              Bolum35Content.ciftYonOptionD,
            ], _model.ciftYon),
            if (_model.ciftYon?.label == "35-2-A") ...[
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
            _buildSoruHeaderWithDef(
              "Daireniz, koridorun sonunda 'Çıkmaz' bir noktada mı?",
              "Çıkmaz Koridor",
              AppDefinitions.cikmazKoridor,
            ),
            _buildSoruCard('cikmaz', [
              Bolum35Content.cikmazOptionA,
              Bolum35Content.cikmazOptionB,
              Bolum35Content.cikmazOptionC,
            ], _model.cikmaz),
            if (_model.cikmaz?.label == Bolum35Content.cikmazOptionB.label) ...[
              _buildInfoNote(
                "Çıkmaz koridor tespiti yapıldı. Lütfen yol ayrımına kadar olan mesafeyi belirtiniz.",
              ),
              _buildSoruCard('cikmazMesafe', [
                Bolum35Content.cikmazMesafeOptionA,
                _getDynamicChoice(
                  Bolum35Content.cikmazMesafeOptionB,
                  _limitTekYon,
                ),
                _getDynamicChoice(
                  Bolum35Content.cikmazMesafeOptionC,
                  _limitTekYon,
                ),
                Bolum35Content.cikmazMesafeOptionD,
              ], _model.cikmazMesafe),
              if (_model.cikmazMesafe?.label == "35-3-C") ...[
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

  Widget _buildSoruHeaderWithDef(String title, String term, String def, {String? imagePath, String? imageTitle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title, style: AppStyles.questionTitle)),
          const SizedBox(width: 8),
          if (imagePath != null) ...[
            GestureDetector(
              onTap: () => ImageModalHelper.show(
                context,
                assetPath: imagePath,
                title: imageTitle ?? 'Görseli İncele',
              ),
              child: Tooltip(
                message: 'Görseli İncele',
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF43A047).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    color: Color(0xFF2E7D32),
                    size: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          DefinitionButton(term: term, definition: def),
        ],
      ),
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
    return CustomInfoNote(
      type: InfoNoteType.info,
      text: text,
      icon: Icons.arrow_downward,
    );
  }
}
