import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/bina_store.dart';
import '../../models/bolum_27_model.dart';
import 'bolum_28_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';

class Bolum27Screen extends StatefulWidget {
  const Bolum27Screen({super.key});

  @override
  State<Bolum27Screen> createState() => _Bolum27ScreenState();
}

class _Bolum27ScreenState extends State<Bolum27Screen> {
  Bolum27Model _model = Bolum27Model();
  bool _needsFireDoor = false;

  final GlobalKey _yonKey = GlobalKey();
  final GlobalKey _kilitKey = GlobalKey();
  final GlobalKey _dayanimKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum27 != null) {
      _model = BinaStore.instance.bolum27!;
    }
    _loadLogicData();
  }

  void _loadLogicData() {
    final b20 = BinaStore.instance.bolum20;
    int closedStairsCount = 0;
    if (b20 != null) {
      closedStairsCount += b20.binaIciYanginMerdiveniSayisi;
      closedStairsCount += b20.binaDisiKapaliYanginMerdiveniSayisi;
    }
    bool needsFireDoor = closedStairsCount > 0;

    setState(() {
      _needsFireDoor = needsFireDoor;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'boyut') {
        _model = _model.copyWith(boyut: choice);
      }
      if (type == 'yon') {
        List<ChoiceResult> current = List<ChoiceResult>.from(_model.yon);
        final label = choice.label;

        if (current.any((e) => e.label == label)) {
          current.removeWhere((e) => e.label == label);
        } else {
          if (label.contains('27-2-E')) {
            // Bilmiyorum is exclusive
            current = [choice];
          } else if (label.contains('27-2-C')) {
            // Turnike/Sürgülü (C) can pair with A, B, or D.
            // Remove 'Bilmiyorum' if present.
            current.removeWhere((e) => e.label.contains('27-2-E'));
            current.add(choice);
          } else if (label.contains('27-2-A') ||
              label.contains('27-2-B') ||
              label.contains('27-2-D')) {
            // A, B, D are mutually exclusive.
            // Remove any existing A, B, D or E.
            current.removeWhere(
              (e) =>
                  e.label.contains('27-2-A') ||
                  e.label.contains('27-2-B') ||
                  e.label.contains('27-2-D') ||
                  e.label.contains('27-2-E'),
            );
            current.add(choice);
          } else {
            current.add(choice);
          }
        }
        _model = _model.copyWith(yon: current);
      }
      if (type == 'kilit') {
        List<ChoiceResult> current = List<ChoiceResult>.from(_model.kilit);
        final label = choice.label;

        if (current.any((e) => e.label == label)) {
          current.removeWhere((e) => e.label == label);
        } else {
          // Rule: A, B, D are exclusive to each other. C is extra.
          // Labels: 27-3-A, 27-3-B, 27-3-C, 27-3-D, 27-3-E
          if (label.contains('27-3-C')) {
            // Always allow C if not present, unless E is there?
            current.removeWhere((e) => e.label.contains('27-3-E'));
            current.add(choice);
          } else if (label.contains('27-3-E')) {
            // Bilmiyorum is exclusive
            current = [choice];
          } else if (label.contains('27-3-A') ||
              label.contains('27-3-B') ||
              label.contains('27-3-D')) {
            // Mutual exclusivity for A, B, D
            current.removeWhere(
              (e) =>
                  e.label.contains('27-3-A') ||
                  e.label.contains('27-3-B') ||
                  e.label.contains('27-3-D') ||
                  e.label.contains('27-3-E'),
            );
            current.add(choice);
          } else {
            // Fallback for any other options if they existed
            current.add(choice);
          }
        }
        _model = _model.copyWith(kilit: current);
      }
      if (type == 'dayanim') _model = _model.copyWith(dayanim: choice);
    });
  }

  bool _isReady() {
    if (_model.boyut == null || _model.yon.isEmpty || _model.kilit.isEmpty) {
      return false;
    }
    if (_needsFireDoor && _model.dayanim == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kaçış Yolu Kapıları",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum27 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum28Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEnZayifHalkaUyarisi(),

          _buildSoruHeader(
            Bolum27Content.questionBoyut,
          ),
          _buildSoruCard('boyut', [
            Bolum27Content.boyutOptionA,
            Bolum27Content.boyutOptionB,
            Bolum27Content.boyutOptionC,
          ], _model.boyut),

          SizedBox(key: _yonKey, height: 1),
          _buildSoruHeader(
            Bolum27Content.questionYon,
            imagePath: AppAssets.section27KacisYonu,
            imageTitle: "Kapı Açılış Yönü Kriterleri",
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              "Birden fazla seçenek işaretleyebilirsiniz.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildSoruCard('yon', [
            Bolum27Content.yonOptionA,
            Bolum27Content.yonOptionB,
            Bolum27Content.yonOptionC,
            Bolum27Content.yonOptionD,
            Bolum27Content.yonOptionE,
          ], _model.yon),

          SizedBox(key: _kilitKey, height: 1),
          _buildSoruHeader(
            Bolum27Content.questionKilit,
            imagePath: AppAssets.section27KilitTipi,
            imageTitle: "Kilit ve Panik Bar Tipleri",
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              "Birden fazla seçenek işaretleyebilirsiniz.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildSoruCard('kilit', [
            Bolum27Content.kilitOptionA,
            Bolum27Content.kilitOptionB,
            Bolum27Content.kilitOptionC,
            Bolum27Content.kilitOptionD,
            Bolum27Content.kilitOptionE,
          ], _model.kilit),

          if (_needsFireDoor) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(thickness: 1.5),
            ),
            _buildInfoNote(
              "Binada korunumlu yangın merdiveni tespit edildiği için dayanım sorusu açılmıştır.",
            ),
            SizedBox(key: _dayanimKey, height: 1),
            _buildSoruHeader(Bolum27Content.questionDayanim),
            _buildSoruCard('dayanim', [
              Bolum27Content.dayanimOptionA,
              Bolum27Content.dayanimOptionB,
              Bolum27Content.dayanimOptionC,
              Bolum27Content.dayanimOptionD,
              Bolum27Content.dayanimOptionE,
            ], _model.dayanim),
          ],
        ],
      ),
    );
  }

  Widget _buildSoruHeader(String title, {String? imagePath, String? imageTitle}) {
    if (imagePath != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: QuestionHeaderWithImage(
          questionText: title,
          imageAssetPath: imagePath,
          imageTitle: imageTitle ?? "Görseli İncele",
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
      child: Text(title, style: AppStyles.questionTitle),
    );
  }

  Widget _buildSoruCard(
    String key,
    List<ChoiceResult> options,
    dynamic selected,
  ) {
    return QuestionCard(
      child: Column(
        children: options.map((opt) {
          bool isSelected = false;
          if (selected is ChoiceResult) {
            isSelected = selected.label == opt.label;
          } else if (selected is List<ChoiceResult>) {
            isSelected = selected.any((e) => e.label == opt.label);
          }
          return SelectableCard(
            choice: opt,
            isSelected: isSelected,
            onTap: () => _handleSelection(key, opt),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnZayifHalkaUyarisi() {
    return const CustomInfoNote(
      type: InfoNoteType.warning,
      text:
          "Lütfen kaçış yolunuz üzerinde EN KÖTÜ durumdaki kapıyı baz alarak cevap veriniz. (daire kapısı hariç)",
      icon: Icons.warning_amber_rounded,
    );
  }

  Widget _buildInfoNote(String text) {
    return CustomInfoNote(
      type: InfoNoteType.info,
      text: text,
      icon: Icons.info_outline,
      margin: const EdgeInsets.only(bottom: 12),
    );
  }
}
