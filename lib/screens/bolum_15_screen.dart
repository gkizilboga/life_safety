import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_15_model.dart';
import 'bolum_16_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart';

class Bolum15Screen extends StatefulWidget {
  const Bolum15Screen({super.key});

  @override
  State<Bolum15Screen> createState() => _Bolum15ScreenState();
}

class _Bolum15ScreenState extends State<Bolum15Screen> {
  Bolum15Model _model = Bolum15Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum15 != null) {
      _model = BinaStore.instance.bolum15!;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'kaplama') {
        _model = _model.copyWith(kaplama: choice);
      }
      if (type == 'yalitim') {
        _model = _model.copyWith(yalitim: choice);
        if (choice.label != Bolum15Content.yalitimOptionB.label) {
          _model = _model.copyWith(yalitimSap: null);
        }
      }
      if (type == 'yalitimSap') {
        _model = _model.copyWith(yalitimSap: choice);
      }
      if (type == 'tavan') {
        _model = _model.copyWith(tavan: choice);
        if (choice.label != Bolum15Content.tavanOptionB.label &&
            choice.label != Bolum15Content.tavanOptionC.label) {
          _model = _model.copyWith(tavanMalzeme: null);
        }
      }
      if (type == 'tavanMalzeme') {
        _model = _model.copyWith(tavanMalzeme: choice);
      }
      if (type == 'tesisat') _model = _model.copyWith(tesisat: choice);
    });
  }

  bool _isReady() {
    if (_model.kaplama == null ||
        _model.yalitim == null ||
        _model.tavan == null ||
        _model.tesisat == null)
      return false;
    if (_model.yalitim?.label == Bolum15Content.yalitimOptionB.label &&
        _model.yalitimSap == null)
      return false;
    if ((_model.tavan?.label == Bolum15Content.tavanOptionB.label ||
            _model.tavan?.label == Bolum15Content.tavanOptionC.label) &&
        _model.tavanMalzeme == null)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "İç Mekanlar",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum15 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleTransitionScreen(
              module: ReportModule.modul1,
              onContinue: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Bolum16Screen(),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
        children: [
          const QuestionTitle("Zemin kaplama malzemesi nedir?"),
          _buildSoru("", 'kaplama', [
            Bolum15Content.kaplamaOptionA,
            Bolum15Content.kaplamaOptionB,
            Bolum15Content.kaplamaOptionD,
            Bolum15Content.kaplamaOptionC,
          ], _model.kaplama),

          _buildSoru(
            "Döşeme üzerinde ısı yalıtımı var mı?",
            'yalitim',
            [
              Bolum15Content.yalitimOptionA,
              Bolum15Content.yalitimOptionBYanmaz,
              Bolum15Content.yalitimOptionB, // Yanıcı = 15-2-C
              Bolum15Content.yalitimOptionC, // Bilmiyorum = 15-2-D
            ],
            _model.yalitim,
            imagePath: AppAssets.section15DosemeYalitim,
            imageTitle: "Döşeme yalıtımı",
          ),

          if (_model.yalitim?.label == Bolum15Content.yalitimOptionB.label) ...[
            _buildInfoNote(
              "Yanıcı yalıtım tespit edildiği için şap sorgulanmaktadır.",
            ),
            _buildSoru(
              "Yalıtım üzerinde en az 2 cm şap var mı?",
              'yalitimSap',
              [
                Bolum15Content.yalitimSapOptionA,
                Bolum15Content.yalitimSapOptionB,
                Bolum15Content.yalitimSapOptionC,
              ],
              _model.yalitimSap,
            ),
          ],

          const QuestionTitle("Asma Tavan var mı?"),
          _buildSoru("", 'tavan', [
            Bolum15Content.tavanOptionA,
            Bolum15Content.tavanOptionB,
            Bolum15Content.tavanOptionC,
            Bolum15Content.tavanOptionD,
          ], _model.tavan),

          if (_model.tavan?.label == Bolum15Content.tavanOptionB.label ||
              _model.tavan?.label == Bolum15Content.tavanOptionC.label) ...[
            _buildInfoNote("Asma tavan malzemesi sorgulanmaktadır."),
            _buildSoru("Asma tavan malzemesi nedir?", 'tavanMalzeme', [
              Bolum15Content.tavanMalzemeOptionA,
              Bolum15Content.tavanMalzemeOptionB,
              Bolum15Content.tavanMalzemeOptionKarma,
              Bolum15Content.tavanMalzemeOptionC,
            ], _model.tavanMalzeme),
          ],

          _buildSoru(
            "Duvarlardaki tesisat geçişleri nasıl kapatılmış?",
            'tesisat',
            [
              Bolum15Content.tesisatOptionA,
              Bolum15Content.tesisatOptionB,
              Bolum15Content.tesisatOptionC,
              Bolum15Content.tesisatOptionD,
            ],
            _model.tesisat,
            imagePath: AppAssets.section15Gecis,
            imageTitle: "Tesisat geçişleri",
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
    String? imagePath,
    String? imageTitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: QuestionHeaderWithImage(
                questionText: title,
                imageAssetPath: imagePath,
                imageTitle: imageTitle ?? "Asansör kuyusu derinliği",
              ),
            )
          else
            QuestionTitle(title),
        QuestionCard(
          child: Column(
            children: [
              ...options.map(
                (opt) => SelectableCard(
                  choice: opt,
                  isSelected: selected?.label == opt.label,
                  onTap: () => _handleSelection(key, opt),
                ),
              ),
            ],
          ),
        ),
      ],
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
