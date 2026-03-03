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
  bool _isLocked = false;
  String _lockReason = "";

  @override
  void initState() {
    super.initState();

    // 1. Load existing data
    final existing = BinaStore.instance.bolum8;
    if (existing != null) {
      _model = existing;
    }

    // 2. Check Section 7 for dynamic locking
    final b7 = BinaStore.instance.bolum7;
    if (b7 != null) {
      _isLocked = true;
      if (b7.hasDuvar) {
        _lockReason =
            "Bölüm-7'de 'Ortak Duvar' işaretlediğiniz için bu bölüm otomatik olarak 'Bitişik Nizam' olarak seçilmiştir.";
        _model = _model.copyWith(secim: Bolum8Content.bitisikNizam);
      } else {
        _lockReason =
            "Bölüm-7'de 'Ortak Duvar' işaretlemediğiniz için bu bölüm otomatik olarak 'Ayrık Nizam' olarak seçilmiştir.";
        _model = _model.copyWith(secim: Bolum8Content.ayrikNizam);
      }
    } else {
      _isLocked = false;
    }
  }

  void _handleSelection(ChoiceResult choice) {
    if (_isLocked) return; // Prevent changing if locked
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Nizam Durumu",
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
          if (_isLocked)
            CustomInfoNote(
              icon: Icons.lock_person_rounded,
              richText: TextSpan(
                children: [
                  TextSpan(
                    text: "$_lockReason\n\n",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text:
                        "Değişiklik yapmak istiyorsanız lütfen Bölüm-7'ye giderek 'Ortak Duvar' seçeneğini güncelleyin.",
                    style: TextStyle(fontStyle: FontStyle.italic),
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
                  onTap: _isLocked
                      ? null
                      : () => _handleSelection(Bolum8Content.ayrikNizam),
                  isDisabled:
                      _isLocked &&
                      _model.secim?.label != Bolum8Content.ayrikNizam.label,
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
                  onTap: _isLocked
                      ? null
                      : () => _handleSelection(Bolum8Content.bitisikNizam),
                  isDisabled:
                      _isLocked &&
                      _model.secim?.label != Bolum8Content.bitisikNizam.label,
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

