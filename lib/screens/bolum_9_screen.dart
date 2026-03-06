import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_9_model.dart';
import 'bolum_10_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart'; // Görsel yolu için eklendi

class Bolum9Screen extends StatefulWidget {
  const Bolum9Screen({super.key});

  @override
  State<Bolum9Screen> createState() => _Bolum9ScreenState();
}

class _Bolum9ScreenState extends State<Bolum9Screen> {
  Bolum9Model _model = Bolum9Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum9 != null) {
      _model = BinaStore.instance.bolum9!;
    }
  }

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _handleDavlumbaz(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(davlumbaz: choice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Sprinkler Sistemi",
      screenType: widget.runtimeType,
      isNextEnabled: _model.secim != null,
      onNext: () {
        BinaStore.instance.bolum9 = _model;
        // saveToDisk() işlemi AnalysisPageLayout içinde otomatik yapılmaktadır.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum10Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Binada otomatik sprinkler sistemi var mı?",
                  style: AppStyles.questionTitle,
                ),
                // --- TEKNİK GÖRSEL BUTONU (Sorunun Hemen Altında) ---
                TechnicalDrawingButton(
                  assetPath: AppAssets.section9Sprinkler,
                  title: "Sprinkler Detayı",
                ),
                const SizedBox(height: 12),
                SelectableCard(
                  choice: Bolum9Content.tamKapsam,
                  isSelected:
                      _model.secim?.label == Bolum9Content.tamKapsam.label,
                  onTap: () => _handleSelection(Bolum9Content.tamKapsam),
                ),
                SelectableCard(
                  choice: Bolum9Content.yok,
                  isSelected: _model.secim?.label == Bolum9Content.yok.label,
                  onTap: () => _handleSelection(Bolum9Content.yok),
                ),
                SelectableCard(
                  choice: Bolum9Content.kismen,
                  isSelected: _model.secim?.label == Bolum9Content.kismen.label,
                  onTap: () => _handleSelection(Bolum9Content.kismen),
                ),
              ],
            ),
          ),

          if (BinaStore.instance.bolum6?.buyukRestoran?.label ==
              Bolum6Content.buyukRestoranVar.label) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(thickness: 1, color: Color(0xFFECEFF1)),
            ),
            QuestionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Büyük restoran (endüstriyel mutfak) davlumbazında otomatik söndürme sistemi var mı?",
                    style: AppStyles.questionTitle,
                  ),
                  // --- TEKNİK GÖRSEL BUTONU (Davlumbaz) ---
                  TechnicalDrawingButton(
                    assetPath: AppAssets.section9Davlumbaz,
                    title: "Davlumbaz Detayı",
                  ),
                  const SizedBox(height: 12),
                  SelectableCard(
                    choice: Bolum9Content.davlumbazVar,
                    isSelected:
                        _model.davlumbaz?.label ==
                        Bolum9Content.davlumbazVar.label,
                    onTap: () => _handleDavlumbaz(Bolum9Content.davlumbazVar),
                  ),
                  SelectableCard(
                    choice: Bolum9Content.davlumbazYok,
                    isSelected:
                        _model.davlumbaz?.label ==
                        Bolum9Content.davlumbazYok.label,
                    onTap: () => _handleDavlumbaz(Bolum9Content.davlumbazYok),
                  ),
                  SelectableCard(
                    choice: Bolum9Content.davlumbazBilmiyorum,
                    isSelected:
                        _model.davlumbaz?.label ==
                        Bolum9Content.davlumbazBilmiyorum.label,
                    onTap: () =>
                        _handleDavlumbaz(Bolum9Content.davlumbazBilmiyorum),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
