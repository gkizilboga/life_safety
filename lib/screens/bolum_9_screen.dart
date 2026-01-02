import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_9_model.dart';
import 'bolum_10_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart'; // Görsel yolu için eklendi

class Bolum9Screen extends StatefulWidget {
  const Bolum9Screen({super.key});

  @override
  State<Bolum9Screen> createState() => _Bolum9ScreenState();
}

class _Bolum9ScreenState extends State<Bolum9Screen> {
  Bolum9Model _model = Bolum9Model();

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Yağmurlama Sistemi",
      subtitle: "Binadaki otomatik söndürme sistemi varlığı",
      screenType: widget.runtimeType,
      isNextEnabled: _model.secim != null,
      onNext: () {
        BinaStore.instance.bolum9 = _model;
        // saveToDisk() işlemi AnalysisPageLayout içinde otomatik yapılmaktadır.
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum10Screen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              "Otomatik Yağmurlama (Sprinkler) Sistemi Durumu:",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
          ),

          // --- TEKNİK GÖRSEL BUTONU (Sorunun Hemen Altında) ---
          TechnicalDrawingButton(
            assetPath: AppAssets.section9Sprinkler,
            title: "Sprinkler Detayı",
          ),
          
          const SizedBox(height: 12),

          QuestionCard(
            child: Column(
              children: [
                SelectableCard(
                  choice: Bolum9Content.tamKapsam,
                  isSelected: _model.secim?.label == Bolum9Content.tamKapsam.label,
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
        ],
      ),
    );
  }
}