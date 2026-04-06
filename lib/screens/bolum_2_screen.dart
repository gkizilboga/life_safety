import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../models/bolum_2_model.dart';
import 'bolum_3_screen.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/selectable_card.dart';
import '../utils/app_content.dart';
import '../models/choice_result.dart';
import '../utils/app_theme.dart';
import '../utils/app_assets.dart'; // Görsel yolu için

class Bolum2Screen extends StatefulWidget {
  const Bolum2Screen({super.key});

  @override
  State<Bolum2Screen> createState() => _Bolum2ScreenState();
}

class _Bolum2ScreenState extends State<Bolum2Screen> {
  Bolum2Model _model = Bolum2Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum2 != null) {
      _model = BinaStore.instance.bolum2!;
    }
  }

  void _handleSelection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(secim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) return;
    BinaStore.instance.bolum2 = _model;
    BinaStore.instance.saveToDisk(); // EKLE
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum3Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Taşıyıcı Sistem",
      screenType: widget.runtimeType,
      isNextEnabled: _model.secim != null,
      onNext: _onNextPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Binanızın taşıyıcı sistemi (yapı türü) nedir?",
              style: AppStyles.questionTitle,
            ),
          ),

          // --- BETONARME ŞIKKI ---
          SelectableCard(
            choice: Bolum2Content.betonarme,
            isSelected: _model.secim?.label == Bolum2Content.betonarme.label,
            onTap: () => _handleSelection(Bolum2Content.betonarme),
          ),

          // --- ÇELİK ŞIKKI VE BUTONU ---
          SelectableCard(
            choice: Bolum2Content.celik,
            isSelected: _model.secim?.label == Bolum2Content.celik.label,
            onTap: () => _handleSelection(Bolum2Content.celik),
            imageAssetPath: AppAssets.section2Celik,
            imageTitle: "Çelik yapı örneği",
          ),
          const SizedBox(height: 8),

          // --- DİĞER ŞIKLAR ---
          SelectableCard(
            choice: Bolum2Content.ahsap,
            isSelected: _model.secim?.label == Bolum2Content.ahsap.label,
            onTap: () => _handleSelection(Bolum2Content.ahsap),
          ),
          SelectableCard(
            choice: Bolum2Content.yigma,
            isSelected: _model.secim?.label == Bolum2Content.yigma.label,
            onTap: () => _handleSelection(Bolum2Content.yigma),
          ),
          SelectableCard(
            choice: Bolum2Content.bilinmiyor,
            isSelected: _model.secim?.label == Bolum2Content.bilinmiyor.label,
            onTap: () => _handleSelection(Bolum2Content.bilinmiyor),
          ),
        ],
      ),
    );
  }
}
