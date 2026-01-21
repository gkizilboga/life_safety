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
  bool _isLockedToBitisik = false;

  @override
  void initState() {
    super.initState();

    // 1. Load existing data
    final existing = BinaStore.instance.bolum8;
    if (existing != null) {
      _model = existing;
    }

    // 2. Check if "Ortak Duvar" was selected in Section 7
    final b7 = BinaStore.instance.bolum7;
    if (b7 != null && b7.hasDuvar) {
      _isLockedToBitisik = true;
      _model = _model.copyWith(secim: Bolum8Content.bitisikNizam);
    } else {
      _isLockedToBitisik = false;
      // If was locked before but Section 7 changed, we keep the bitisik choice but unlock it
      // unless user wants to change it.
    }
  }

  void _handleSelection(ChoiceResult choice) {
    if (_isLockedToBitisik) return; // Prevent changing if locked
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
        children: [
          // Warning banner if locked due to Ortak Duvar selection
          if (_isLockedToBitisik)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFF9800)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Color(0xFFE65100),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Bir önceki bölümde 'Ortak Duvar' işaretlediğiniz için bu bölüm 'Bitişik Nizam' olarak kilitlenmiştir. Değiştirmek isterseniz lütfen Bölüm-7'ye dönün.",
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
                  onTap: _isLockedToBitisik
                      ? null
                      : () => _handleSelection(Bolum8Content.ayrikNizam),
                  isDisabled: _isLockedToBitisik,
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
                  onTap: _isLockedToBitisik
                      ? null
                      : () => _handleSelection(Bolum8Content.bitisikNizam),
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
