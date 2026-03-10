import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_24_model.dart';
import 'bolum_25_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';

class Bolum24Screen extends StatefulWidget {
  const Bolum24Screen({super.key});

  @override
  State<Bolum24Screen> createState() => _Bolum24ScreenState();
}

class _Bolum24ScreenState extends State<Bolum24Screen> {
  Bolum24Model _model = Bolum24Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum24 != null) {
      _model = BinaStore.instance.bolum24!;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tip') {
        _model = _model.copyWith(tip: choice);
        if (choice.label != Bolum24Content.tipOptionB.label) {
          _model = _model.copyWith(pencere: null, kapi: null);
        }
      } else if (type == 'pencere') {
        _model = _model.copyWith(pencere: choice);
      } else if (type == 'kapi') {
        _model = _model.copyWith(kapi: choice);
      }
    });
  }

  bool _isReady() {
    if (_model.tip == null) return false;
    if (_model.tip?.label == Bolum24Content.tipOptionB.label) {
      return _model.pencere != null && _model.kapi != null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Dış Kaçış Geçidi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum24 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum25Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SORU 1 ---
          // --- SORU 1 ---
          QuestionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dairenizden itibaren bina dışına çıkış nasıl?",
                  style: AppStyles.questionTitle,
                ),
                const SizedBox(height: 12),

                SelectableCard(
                  choice: Bolum24Content.tipOptionA,
                  isSelected:
                      _model.tip?.label == Bolum24Content.tipOptionA.label,
                  onTap: () =>
                      _handleSelection('tip', Bolum24Content.tipOptionA),
                  imageAssetPath: AppAssets.section24KapaliKoridor,
                  imageTitle: "Kapalı Koridor Örneği",
                ),
                const SizedBox(height: 8),

                SelectableCard(
                  choice: Bolum24Content.tipOptionB,
                  isSelected:
                      _model.tip?.label == Bolum24Content.tipOptionB.label,
                  onTap: () =>
                      _handleSelection('tip', Bolum24Content.tipOptionB),
                  imageAssetPath: AppAssets.section24DisGecit,
                  imageTitle: "Dış Kaçış Geçidi Örneği",
                ),
                const SizedBox(height: 8),

                // Option C: Direkt Çıkış
                SelectableCard(
                  choice: Bolum24Content.tipOptionC,
                  isSelected:
                      _model.tip?.label == Bolum24Content.tipOptionC.label,
                  onTap: () =>
                      _handleSelection('tip', Bolum24Content.tipOptionC),
                ),
              ],
            ),
          ),

          // Alt Sorular (Sadece Seçenek B ise görünür)
          if (_model.tip?.label == Bolum24Content.tipOptionB.label) ...[
            // SORU 2'NİN ADRESİ (Key buraya bağlandı)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildInfoNote(
                "Açık kaçış güzergahı tespit edildiği için ek güvenlik soruları açılmıştır.",
              ),
            ),

            _buildSoru(
              "Açık kaçış güzergahına bakan dairelere ait pencereler var mı?",
              'pencere',
              [
                Bolum24Content.pencereOptionA,
                Bolum24Content.pencereOptionB,
                Bolum24Content.pencereOptionC,
              ],
              _model.pencere,
            ),

            _buildSoru(
              "Açık kaçış güzergahına açılan daire kapınızın özelliği nedir?",
              'kapi',
              [
                Bolum24Content.kapiOptionA,
                Bolum24Content.kapiOptionB,
                Bolum24Content.kapiOptionC,
              ],
              _model.kapi,
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
    String? assetTitle,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (assetPath != null)
            QuestionHeaderWithImage(
              questionText: title,
              imageAssetPath: assetPath,
              imageTitle: assetTitle ?? "Teknik Detay",
            )
          else ...[
            Text(title, style: AppStyles.questionTitle),
          ],

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

