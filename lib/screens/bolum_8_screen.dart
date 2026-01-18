import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_8_model.dart';
import 'bolum_9_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart'; // Görsel yolları için eklendi

class Bolum8Screen extends StatefulWidget {
  const Bolum8Screen({super.key});

  @override
  State<Bolum8Screen> createState() => _Bolum8ScreenState();
}

class _Bolum8ScreenState extends State<Bolum8Screen> {
  Bolum8Model _model = Bolum8Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Bina Yerleşimi",
      subtitle: "Ayrık veya bitişik nizam tespiti",
      screenType: widget.runtimeType,
      isNextEnabled: _model.secim != null,
      onNext: () {
        BinaStore.instance.bolum8 = _model;
        // saveToDisk() işlemi AnalysisPageLayout içinde otomatik yapılmaktadır.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum9Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        crossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              "Binanızın yerleşim durumu nedir?",
              style: AppStyles.questionTitle,
            ),
          ),

          QuestionCard(
            child: Column(
              children: [
                // --- AYRIK NİZAM ---
                SelectableCard(
                  choice: Bolum8Content.ayrikNizam,
                  isSelected:
                      _model.secim?.label == Bolum8Content.ayrikNizam.label,
                  onTap: () => _handleSelection(Bolum8Content.ayrikNizam),
                ),
                TechnicalDrawingButton(
                  assetPath: AppAssets.section8Ayrik,
                  title: "Ayrık Nizam Yerleşim Detayı",
                ),

                const SizedBox(height: 16),
                const Divider(height: 32),

                // --- BİTİŞİK NİZAM ---
                SelectableCard(
                  choice: Bolum8Content.bitisikNizam,
                  isSelected:
                      _model.secim?.label == Bolum8Content.bitisikNizam.label,
                  onTap: () => _handleSelection(Bolum8Content.bitisikNizam),
                ),
                TechnicalDrawingButton(
                  assetPath: AppAssets.section8Bitisik,
                  title: "Bitişik Nizam Yerleşim Detayı",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
