import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_11_model.dart';
import 'bolum_12_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';

class Bolum11Screen extends StatefulWidget {
  const Bolum11Screen({super.key});

  @override
  State<Bolum11Screen> createState() => _Bolum11ScreenState();
}

class _Bolum11ScreenState extends State<Bolum11Screen> {
  Bolum11Model _model = Bolum11Model();
  final GlobalKey _engelKey = GlobalKey();
  final GlobalKey _zayifNoktaKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mesafe') {
        _model = _model.copyWith(mesafe: choice);
        if (choice.label == Bolum11Content.mesafeOptionB.label)
          _scrollToKey(_engelKey);
        else
          _model = _model.copyWith(engel: null, zayifNokta: null);
      } else if (type == 'engel') {
        _model = _model.copyWith(engel: choice);
        if (choice.label == Bolum11Content.engelOptionB.label)
          _scrollToKey(_zayifNoktaKey);
        else
          _model = _model.copyWith(zayifNokta: null);
      } else if (type == 'zayifNokta') {
        _model = _model.copyWith(zayifNokta: choice);
      }
    });
  }

  bool _isReady() {
    if (_model.mesafe == null) return false;
    if (_model.mesafe?.label == Bolum11Content.mesafeOptionB.label) {
      if (_model.engel == null) return false;
      if (_model.engel?.label == Bolum11Content.engelOptionB.label) {
        if (_model.zayifNokta == null) return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "İtfaiye Araçlarının Bina Yaklaşım Mesafesi",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum11 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum12Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSoru(
            "1. İtfaiye aracının binaya yaklaşım mesafesi 45 metreyi aşıyor mu?",
            'mesafe',
            [
              Bolum11Content.mesafeOptionA,
              Bolum11Content.mesafeOptionB,
              Bolum11Content.mesafeOptionC,
            ],
            _model.mesafe,
            assetPath: AppAssets.section11Yaklasim,
          ),

          if (_model.mesafe?.label == Bolum11Content.mesafeOptionB.label) ...[
            _buildInfoNote(
              "Mesafe 45m'yi aştığı için ek güvenlik soruları açılmıştır.",
              key: _engelKey,
            ),
            _buildSoru(
              "2. İtfaiye aracının binaya yanaşmasını engelleyen bir bahçe duvarı veya kilitli kapılar var mı?",
              'engel',
              [
                Bolum11Content.engelOptionA,
                Bolum11Content.engelOptionB,
                Bolum11Content.engelOptionC,
              ],
              _model.engel,
              assetPath: AppAssets.section11ErisimYok,
            ),
          ],

          if (_model.engel?.label == Bolum11Content.engelOptionB.label) ...[
            _buildInfoNote(
              "Engel bulunduğu için zayıf geçiş noktası tespiti gereklidir.",
              key: _zayifNoktaKey,
            ),
            _buildSoru(
              "3. Bu duvarda itfaiyenin kolayca yıkıp geçebileceği zayıf bir bölüm var mı?",
              'zayifNokta',
              [
                Bolum11Content.zayifNoktaOptionA,
                Bolum11Content.zayifNoktaOptionB,
              ],
              _model.zayifNokta,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
    String? assetPath,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.questionTitle,
          ),
          if (assetPath != null)
            TechnicalDrawingButton(assetPath: assetPath, title: "Teknik Detay"),
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

  Widget _buildInfoNote(String text, {GlobalKey? key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Color(0xFFE65100)),
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
