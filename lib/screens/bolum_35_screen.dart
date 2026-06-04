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
  final _cikmazCtrl = TextEditingController();

  bool _tekCikis = true;
  int _limitTekYon = 15;
  int _limitCiftYon = 75;
  String? _mesafeErr;
  String? _cikmazErr;

  @override
  void initState() {
    super.initState();
    _calculateLimits();
    if (BinaStore.instance.bolum35 != null) {
      _model = BinaStore.instance.bolum35!;
      if (_tekCikis && _model.tekYonMesafe != null) {
        _mesafeCtrl.text = _model.tekYonMesafe.toString();
      } else if (!_tekCikis && _model.ciftYonMesafe != null) {
        _mesafeCtrl.text = _model.ciftYonMesafe.toString();
      }
      if (_model.cikmazUzunluk != null) {
        _cikmazCtrl.text = _model.cikmazUzunluk.toString();
      }
    }
    _mesafeCtrl.addListener(_onMesafeChanged);
    _cikmazCtrl.addListener(_onCikmazChanged);
  }

  @override
  void dispose() {
    _mesafeCtrl.dispose();
    _cikmazCtrl.dispose();
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

  void _onMesafeChanged() {
    final err = InputValidator.validateNumber(
      _mesafeCtrl.text,
      min: 0,
      max: 200,
      unit: "m",
    );
    final val = InputValidator.parseFlex(_mesafeCtrl.text);
    setState(() {
      _mesafeErr = err;
      if (_tekCikis) {
        _model = _model.copyWith(tekYonMesafe: val != null && val > 0 ? val : null);
      } else {
        _model = _model.copyWith(ciftYonMesafe: val != null && val > 0 ? val : null);
      }
    });
  }

  void _onCikmazChanged() {
    final err = InputValidator.validateNumber(
      _cikmazCtrl.text,
      min: 0,
      max: 200,
      unit: "m",
    );
    final val = InputValidator.parseFlex(_cikmazCtrl.text);
    setState(() {
      _cikmazErr = err;
      _model = _model.copyWith(cikmazUzunluk: val != null && val > 0 ? val : null);
    });
  }

  bool _isReadyToProceed() {
    final mesafeVal = InputValidator.parseFlex(_mesafeCtrl.text);
    if (mesafeVal == null || mesafeVal <= 0 || _mesafeErr != null) return false;
    if (!_tekCikis) {
      if (_model.cikmaz == null) return false;
      if (_model.cikmaz?.label == Bolum35Content.cikmazOptionA.label) {
        final cikmazVal = InputValidator.parseFlex(_cikmazCtrl.text);
        if (cikmazVal == null || cikmazVal <= 0 || _cikmazErr != null) return false;
      }
    }
    return true;
  }

  void _onCikmazSelected(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(cikmaz: choice);
      if (choice.label != Bolum35Content.cikmazOptionA.label) {
        _model = _model.copyWith(cikmazUzunluk: null);
        _cikmazCtrl.clear();
      }
    });
  }

  _EvaluationResult? _computeMesafeEval() {
    final val = InputValidator.parseFlex(_mesafeCtrl.text);
    if (val == null || val <= 0) return null;
    final limit = _tekCikis ? _limitTekYon : _limitCiftYon;
    final isOk = val <= limit;
    return _EvaluationResult(
      text: isOk
          ? "OLUMLU: Girilen kaçış mesafesi ${_formatSayi(val)} m, yönetmelik sınırı olan $limit m'nin altında olduğu için uygundur."
          : "KRİTİK RİSK: Girilen kaçış mesafesi ${_formatSayi(val)} m, yönetmelik sınırı olan $limit m'nin üzerinde olduğu için UYGUN DEĞİLDİR. Kaçış mesafesini kısaltmak için yatay tahliye koridoru vb. oluşturulabilir veya farklı önlemler almak gerekebilir.",
      level: isOk ? RiskLevel.positive : RiskLevel.critical,
    );
  }

  _EvaluationResult? _computeCikmazEval() {
    final val = InputValidator.parseFlex(_cikmazCtrl.text);
    if (val == null || val <= 0) return null;
    final isOk = val <= _limitTekYon;
    return _EvaluationResult(
      text: isOk
          ? "OLUMLU: Çıkmaz koridor uzunluğu ${_formatSayi(val)} m, yönetmelik sınırı olan $_limitTekYon m'nin altında olduğu için uygundur."
          : "KRİTİK RİSK: Çıkmaz koridor uzunluğu ${_formatSayi(val)} m, yönetmelik sınırı olan $_limitTekYon m'nin üzerinde olduğu için UYGUN DEĞİLDİR. Koridor mesafesini kısaltmak için yatay tahliye koridoru vb. oluşturulabilir veya farklı önlemler almak gerekebilir.",
      level: isOk ? RiskLevel.positive : RiskLevel.critical,
    );
  }

  String _formatSayi(double val) {
    if (val.isNaN || val.isInfinite) return "0";
    return val == val.roundToDouble()
        ? val.toInt().toString()
        : val.toStringAsFixed(1);
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
    final eval = _computeMesafeEval();

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
          _buildInputField(
            controller: _mesafeCtrl,
            errorText: _mesafeErr,
            label: "Kaçış Mesafesi (m)",
          ),
          if (eval != null) ...[
            const SizedBox(height: 8),
            _buildEvalBadge(text: eval.text, level: eval.level),
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
            isSelected:
                _model.cikmaz?.label == Bolum35Content.cikmazOptionA.label,
            onTap: () => _onCikmazSelected(Bolum35Content.cikmazOptionA),
          ),
          const SizedBox(height: 6),
          SelectableCard(
            choice: Bolum35Content.cikmazOptionB,
            isSelected:
                _model.cikmaz?.label == Bolum35Content.cikmazOptionB.label,
            onTap: () => _onCikmazSelected(Bolum35Content.cikmazOptionB),
          ),
          const SizedBox(height: 6),
          SelectableCard(
            choice: Bolum35Content.cikmazOptionC,
            isSelected:
                _model.cikmaz?.label == Bolum35Content.cikmazOptionC.label,
            onTap: () => _onCikmazSelected(Bolum35Content.cikmazOptionC),
          ),
        ],
      ),
    );
  }

  Widget _buildCikmazUzunlukQuestion() {
    final eval = _computeCikmazEval();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: QuestionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Çıkmaz koridor kaç metre uzunluğundadır?",
              style: AppStyles.questionTitle,
            ),
            const SizedBox(height: 8),
            _buildInfoNote(
              "Çıkmaz koridor tespiti yapıldı. Lütfen koridor uzunluğunu metre cinsinden giriniz.",
            ),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _cikmazCtrl,
              errorText: _cikmazErr,
              label: "Çıkmaz Koridor Uzunluğu (m)",
            ),
            if (eval != null) ...[
              const SizedBox(height: 8),
              _buildEvalBadge(text: eval.text, level: eval.level),
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

  Widget _buildEvalBadge({
    required String text,
    required RiskLevel level,
  }) {
    final Color bgColor;
    final Color textColor;
    final IconData icon;
    switch (level) {
      case RiskLevel.critical:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        icon = Icons.warning_amber_rounded;
      case RiskLevel.warning:
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF57F17);
        icon = Icons.info_outline;
      case RiskLevel.positive:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle_outline;
      case RiskLevel.unknown:
        bgColor = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF7B1FA2);
        icon = Icons.help_outline;
      case RiskLevel.info:
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        icon = Icons.info_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
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

class _EvaluationResult {
  final String text;
  final RiskLevel level;
  const _EvaluationResult({required this.text, required this.level});
}
