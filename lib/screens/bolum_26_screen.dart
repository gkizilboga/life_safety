import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_26_model.dart';
import 'bolum_27_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';

class Bolum26Screen extends StatefulWidget {
  const Bolum26Screen({super.key});

  @override
  State<Bolum26Screen> createState() => _Bolum26ScreenState();
}

class _Bolum26ScreenState extends State<Bolum26Screen> {
  Bolum26Model _model = Bolum26Model();
  bool _askOtopark = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum26 != null) {
      _model = BinaStore.instance.bolum26!;
    }
    // Bölüm 6'daki otopark varlığına göre şalteri ayarla
    final b6 = BinaStore.instance.bolum6;
    if (b6?.hasOtopark == true) {
      _askOtopark = true;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        if (choice.label != Bolum26Content.varlikOptionB.label) {
          _model = _model.copyWith(egim: null, sahanlik: null);
        }
      } else if (type == 'egim') {
        _model = _model.copyWith(egim: choice);
      } else if (type == 'sahanlik') {
        _model = _model.copyWith(sahanlik: choice);
      } else if (type == 'otopark') {
        _model = _model.copyWith(otopark: choice);
      }
    });
  }

  bool _isReady() {
    if (_model.varlik == null) return false;
    if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) {
      if (_model.egim == null || _model.sahanlik == null) return false;
    }
    if (_askOtopark && _model.otopark == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Rampa",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum26 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum27Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SORU 1: VARLIK ---
          QuestionHeaderWithImage(
            questionText: "Binada kullanmak zorunda kaldığınız eğimli bir rampa var mı?",
            imageAssetPath: AppAssets.section26Rampa,
            imageTitle: "Kaçış rampası",
          ),

          QuestionCard(
            child: Column(
              children: [
                SelectableCard(
                  choice: Bolum26Content.varlikOptionA,
                  isSelected:
                      _model.varlik?.label ==
                      Bolum26Content.varlikOptionA.label,
                  onTap: () =>
                      _handleSelection('varlik', Bolum26Content.varlikOptionA),
                ),
                SelectableCard(
                  choice: Bolum26Content.varlikOptionB,
                  isSelected:
                      _model.varlik?.label ==
                      Bolum26Content.varlikOptionB.label,
                  onTap: () =>
                      _handleSelection('varlik', Bolum26Content.varlikOptionB),
                ),
                SelectableCard(
                  choice: Bolum26Content.varlikOptionC,
                  isSelected:
                      _model.varlik?.label ==
                      Bolum26Content.varlikOptionC.label,
                  onTap: () =>
                      _handleSelection('varlik', Bolum26Content.varlikOptionC),
                ),
              ],
            ),
          ),

          // --- ALT SORULAR (Rampa Varsa) ---
          if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) ...[
            _buildInfoNote(
              "Rampa tespit edildiği için eğim ve sahanlık soruları açılmıştır.",
            ),

            _buildSoru("Bu rampanın eğimi ve zemin kaplaması nasıl?", 'egim', [
              Bolum26Content.egimOptionA,
              Bolum26Content.egimOptionB,
              Bolum26Content.egimOptionC,
            ], _model.egim),

            _buildSoru(
              "Rampanın başlangıcında ve bitişinde sahanlık (düzlük) var mı?",
              'sahanlik',
              [
                Bolum26Content.sahanlikOptionA,
                Bolum26Content.sahanlikOptionB,
                Bolum26Content.sahanlikOptionC,
              ],
              _model.sahanlik,
            ),
          ],

          // --- OTOPARK RAMPASI (Sadece Otopark Varsa) ---
          if (_askOtopark) ...[
            const SizedBox(height: 12),
            _buildSoru(
              "Otopark araç rampasını acil durumda kaçış yolu olarak kullanabilir misiniz?",
              'otopark',
              [
                Bolum26Content.otoparkOptionA,
                Bolum26Content.otoparkOptionB,
                Bolum26Content.otoparkOptionC,
              ],
              _model.otopark,
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
              onTap: () => _handleSelection(key, opt),
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
